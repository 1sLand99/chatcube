import { Context } from '@kit.AbilityKit'
import { i18n } from '@kit.LocalizationKit'
import {
  AppLanguage,
  getPreferencesService,
  normalizeAppLanguageValue,
  PreferenceKeys
} from './PreferencesService'

const APP_PREFERRED_LANGUAGE_DEFAULT = 'default'

export class LanguageService {
  private static instance: LanguageService | null = null
  private lastAppliedLanguageTag: string = ''
  private lastAppliedPreferredLanguage: string = ''

  private constructor() {
  }

  static getInstance(): LanguageService {
    if (LanguageService.instance === null) {
      LanguageService.instance = new LanguageService()
    }
    return LanguageService.instance
  }

  async migrateStoredLanguagePreference(): Promise<AppLanguage> {
    const preferencesService = getPreferencesService()
    const hasStoredLanguage = await preferencesService.has(PreferenceKeys.LANGUAGE)
    const rawStoredLanguage = hasStoredLanguage
      ? await preferencesService.getString(PreferenceKeys.LANGUAGE, AppLanguage.SYSTEM)
      : ''
    const sourceLanguage = rawStoredLanguage !== '' ? rawStoredLanguage : this.getAppPreferredLanguageOrDefault()
    const normalizedLanguage = normalizeAppLanguageValue(sourceLanguage)
    if (!hasStoredLanguage || rawStoredLanguage !== normalizedLanguage) {
      await preferencesService.setLanguage(normalizedLanguage)
    }
    return normalizedLanguage
  }

  async getStoredLanguage(): Promise<AppLanguage> {
    await this.migrateStoredLanguagePreference()
    return await getPreferencesService().getLanguage()
  }

  async applyStoredLanguage(context: Context): Promise<AppLanguage> {
    const language = await this.migrateStoredLanguagePreference()
    this.applyLanguage(context, language)
    return language
  }

  async handleSystemConfigurationUpdate(context: Context): Promise<void> {
    const language = await this.getStoredLanguage()
    if (language === AppLanguage.SYSTEM) {
      this.applyLanguage(context, AppLanguage.SYSTEM)
    }
  }

  applyLanguage(context: Context, language: AppLanguage): void {
    const targetLanguage = this.resolveAppLanguageTag(language)
    const preferredLanguage = this.resolvePreferredLanguageTag(language, targetLanguage)
    if (targetLanguage === this.lastAppliedLanguageTag &&
      preferredLanguage === this.lastAppliedPreferredLanguage) {
      return
    }

    const previousLanguageTag = this.lastAppliedLanguageTag
    const previousPreferredLanguage = this.lastAppliedPreferredLanguage
    try {
      i18n.System.setAppPreferredLanguage(preferredLanguage)
      this.lastAppliedPreferredLanguage = preferredLanguage
      this.lastAppliedLanguageTag = targetLanguage
      context.getApplicationContext().setLanguage(targetLanguage)
    } catch (error) {
      this.lastAppliedLanguageTag = previousLanguageTag
      this.lastAppliedPreferredLanguage = previousPreferredLanguage
      console.error('LanguageService', `Failed to apply language: ${JSON.stringify(error)}`)
    }
  }

  private getAppPreferredLanguageOrDefault(): string {
    try {
      return i18n.System.getAppPreferredLanguage()
    } catch (error) {
      console.error('LanguageService', `Failed to get app preferred language: ${JSON.stringify(error)}`)
      return AppLanguage.SYSTEM
    }
  }

  private resolveAppLanguageTag(language: AppLanguage): string {
    if (language === AppLanguage.SYSTEM) {
      return i18n.System.getSystemLanguage()
    }

    const supportedLanguages = i18n.System.getSystemLanguages()
    if (language === AppLanguage.ZH_CN) {
      return this.resolveSupportedLanguageTag(supportedLanguages, ['zh-cn', 'zh-hans-cn', 'zh-hans', 'zh'])
    }
    return this.resolveSupportedLanguageTag(supportedLanguages, ['en-us', 'en-latn-us', 'en'])
  }

  private resolvePreferredLanguageTag(language: AppLanguage, targetLanguage: string): string {
    if (language === AppLanguage.SYSTEM) {
      return APP_PREFERRED_LANGUAGE_DEFAULT
    }
    return targetLanguage
  }

  private resolveSupportedLanguageTag(supportedLanguages: Array<string>, preferredTags: Array<string>): string {
    for (let i = 0; i < preferredTags.length; i++) {
      const preferredTag = preferredTags[i]
      const exactMatch = this.findSupportedLanguageTagByNormalizedValue(supportedLanguages, preferredTag)
      if (exactMatch !== '') {
        return exactMatch
      }
    }

    for (let i = 0; i < preferredTags.length; i++) {
      const preferredTag = preferredTags[i]
      const languageCode = this.extractLanguageCode(preferredTag)
      const prefixMatch = this.findSupportedLanguageTagByLanguageCode(supportedLanguages, languageCode)
      if (prefixMatch !== '') {
        return prefixMatch
      }
    }

    return preferredTags[0]
  }

  private findSupportedLanguageTagByNormalizedValue(supportedLanguages: Array<string>, preferredTag: string): string {
    const normalizedPreferredTag = this.normalizeLanguageTag(preferredTag)
    for (let i = 0; i < supportedLanguages.length; i++) {
      const supportedLanguage = supportedLanguages[i]
      if (this.normalizeLanguageTag(supportedLanguage) === normalizedPreferredTag) {
        return supportedLanguage
      }
    }
    return ''
  }

  private findSupportedLanguageTagByLanguageCode(supportedLanguages: Array<string>, languageCode: string): string {
    for (let i = 0; i < supportedLanguages.length; i++) {
      const supportedLanguage = supportedLanguages[i]
      if (this.extractLanguageCode(supportedLanguage) === languageCode) {
        return supportedLanguage
      }
    }
    return ''
  }

  private extractLanguageCode(languageTag: string): string {
    const normalizedTag = this.normalizeLanguageTag(languageTag)
    const separatorIndex = normalizedTag.indexOf('-')
    return separatorIndex >= 0 ? normalizedTag.substring(0, separatorIndex) : normalizedTag
  }

  private normalizeLanguageTag(languageTag: string): string {
    return languageTag.replace(/_/g, '-').toLowerCase()
  }
}

export function getLanguageService(): LanguageService {
  return LanguageService.getInstance()
}
