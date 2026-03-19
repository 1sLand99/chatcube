import { i18n } from '@kit.LocalizationKit'
import { AppLanguage, normalizeAppLanguageValue } from '../services/PreferencesService'
import { ServiceRegistry } from '../services/ServiceRegistry'

export function resolveCurrentAppLanguage(): AppLanguage {
  const storedLanguage = ServiceRegistry.settings().getLanguage()
  if (storedLanguage !== AppLanguage.SYSTEM) {
    return storedLanguage
  }
  return normalizeAppLanguageValue(i18n.System.getSystemLanguage())
}

export function isChineseAppLanguage(): boolean {
  return resolveCurrentAppLanguage() === AppLanguage.ZH_CN
}

export function pickLocalizedText(chineseText: string, englishText: string): string {
  return isChineseAppLanguage() ? chineseText : englishText
}

export function formatLocalizedCount(
  count: number,
  chineseUnit: string,
  englishSingular: string,
  englishPlural: string
): string {
  if (isChineseAppLanguage()) {
    return `${count} ${chineseUnit}`
  }
  return `${count} ${count === 1 ? englishSingular : englishPlural}`
}
