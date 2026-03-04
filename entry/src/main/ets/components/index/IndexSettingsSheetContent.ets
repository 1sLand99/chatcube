import { ThemeMode, AppLanguage } from '../../services/PreferencesService'
import { ColorTheme } from '../../models/ThemeColors'
import { ThemeColorPicker } from '../ThemeColorPicker'
import { SettingsSheetType } from '../../pages/index/IndexPageTypes'
import { IndexSettingsSheetActionCallbacks } from '../../pages/index/IndexSettingsSheetCoordinator'

@Component
export struct IndexSettingsSheetContent {
  @Prop settingsSheetType: SettingsSheetType = SettingsSheetType.NONE
  @StorageProp('theme_primary') themePrimary: string = '#0A59F7'
  @Prop currentThemeMode: ThemeMode = ThemeMode.SYSTEM
  @Prop currentLanguage: AppLanguage = AppLanguage.SYSTEM
  @Prop notifyEnabled: boolean = true
  @Prop notifyOnComplete: boolean = true
  @Prop notifyOnFailed: boolean = true
  @Prop handAdaptiveEnabled: boolean = false
  @Prop handAdaptiveNewChat: boolean = false
  @Prop handAdaptiveUnsupported: boolean = false
  @Prop chatFontSize: number = 15
  @State previewFontSize: number = 15
  @StorageProp('theme_user_bubble') themeUserBubble: string = '#0A59F7'
  @StorageProp('theme_user_bubble_text') themeUserBubbleText: string = '#FFFFFF'
  @StorageProp('theme_ai_bubble') themeAiBubble: string = '#FFFFFF'
  callbacks: IndexSettingsSheetActionCallbacks = new IndexSettingsSheetActionCallbacks()

  aboutToAppear(): void {
    if (this.settingsSheetType === SettingsSheetType.FONT_SIZE) {
      this.previewFontSize = this.chatFontSize
    }
  }

  private applyFontSize(size: number): void {
    this.previewFontSize = size
    this.callbacks.onFontSizeChanged(size)
  }

  @Builder
  private FontSizePresetButton(label: Resource, size: number) {
    Button(label)
      .height(36)
      .fontSize(13)
      .fontWeight(FontWeight.Medium)
      .fontColor(this.previewFontSize === size ? '#FFFFFF' : this.themePrimary)
      .backgroundColor(this.previewFontSize === size ? this.themePrimary : this.themePrimary + '1A')
      .borderRadius(18)
      .layoutWeight(1)
      .onClick(() => {
        this.applyFontSize(size)
      })
  }

  @Builder
  private FontSizeSheetContent() {
    Column({ space: 16 }) {
      // 预览框
      Column({ space: 12 }) {
        // AI 消息预览
        Row() {
          Column() {
            Text($r('app.string.font_preview_ai_message'))
              .fontSize(this.previewFontSize - 1)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(this.previewFontSize + 7)
          }
          .padding({ left: 14, right: 14, top: 10, bottom: 10 })
          .backgroundColor(this.themeAiBubble)
          .borderRadius({
            topLeft: 20,
            topRight: 20,
            bottomLeft: 6,
            bottomRight: 20
          })
          .constraintSize({ maxWidth: '75%' })

          Blank()
        }
        .width('100%')

        // 用户消息预览
        Row() {
          Blank()

          Column() {
            Text($r('app.string.font_preview_user_message'))
              .fontSize(this.previewFontSize)
              .fontColor(this.themeUserBubbleText)
              .lineHeight(this.previewFontSize + 7)
          }
          .padding({ left: 14, right: 14, top: 10, bottom: 10 })
          .backgroundColor(this.themeUserBubble)
          .borderRadius({
            topLeft: 20,
            topRight: 20,
            bottomLeft: 20,
            bottomRight: 6
          })
          .constraintSize({ maxWidth: '75%' })
        }
        .width('100%')
      }
      .width('100%')
      .padding(16)
      .backgroundColor($r('app.color.background'))
      .borderRadius(16)

      // 当前值显示
      Text(`${this.previewFontSize} fp`)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .textAlign(TextAlign.Center)
        .width('100%')

      // Slider
      Row({ space: 8 }) {
        Text('A')
          .fontSize(12)
          .fontColor($r('app.color.text_secondary'))
        Slider({
          value: this.previewFontSize,
          min: 12,
          max: 22,
          step: 1,
          style: SliderStyle.InSet
        })
          .selectedColor(this.themePrimary)
          .trackThickness(28)
          .layoutWeight(1)
          .onChange((value: number, mode: SliderChangeMode) => {
            this.previewFontSize = Math.round(value)
            if (mode === SliderChangeMode.End || mode === SliderChangeMode.Click) {
              this.callbacks.onFontSizeChanged(this.previewFontSize)
            }
          })
        Text('A')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_secondary'))
      }
      .width('100%')

      // 预设按钮
      Row({ space: 8 }) {
        this.FontSizePresetButton($r('app.string.font_size_small'), 13)
        this.FontSizePresetButton($r('app.string.font_size_default'), 15)
        this.FontSizePresetButton($r('app.string.font_size_large'), 17)
        this.FontSizePresetButton($r('app.string.font_size_extra_large'), 19)
      }
      .width('100%')
    }
    .width('100%')
  }

  @Builder
  private ThemeOptionItem(mode: ThemeMode, label: Resource) {
    Row() {
      Text(label)
        .fontSize(16)
        .fontColor($r('app.color.text_primary'))

      Blank()

      if (this.currentThemeMode === mode) {
        SymbolGlyph($r('sys.symbol.checkmark'))
          .fontSize(20)
          .fontColor([this.themePrimary])
      }
    }
    .width('100%')
    .height(56)
    .padding({ left: 8, right: 8 })
    .onClick(() => {
      this.callbacks.onSelectTheme(mode)
    })
  }

  @Builder
  private LanguageOptionItem(language: AppLanguage, label: Resource) {
    Row() {
      Text(label)
        .fontSize(16)
        .fontColor($r('app.color.text_primary'))

      Blank()

      if (this.currentLanguage === language) {
        SymbolGlyph($r('sys.symbol.checkmark'))
          .fontSize(20)
          .fontColor([this.themePrimary])
      }
    }
    .width('100%')
    .height(56)
    .padding({ left: 8, right: 8 })
    .onClick(() => {
      this.callbacks.onSelectLanguage(language)
    })
  }

  @Builder
  private HandAdaptiveToggleItem(title: Resource, desc: Resource, checked: boolean, enabled: boolean,
    onChanged: (value: boolean) => void) {
    Row() {
      Column() {
        Text(title)
          .fontSize(15)
          .fontColor(enabled ? $r('app.color.text_primary') : $r('app.color.text_tertiary'))

        Text(desc)
          .fontSize(12)
          .fontColor(enabled ? $r('app.color.text_secondary') : $r('app.color.text_tertiary'))
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Toggle({ type: ToggleType.Switch, isOn: checked })
        .selectedColor(this.themePrimary)
        .enabled(enabled)
        .onChange((value: boolean) => {
          onChanged(value)
        })
    }
    .width('100%')
    .padding({ left: 8, right: 8, top: 12, bottom: 12 })
  }

  @Builder
  private HandAdaptiveSheetContent() {
    Column() {
      this.HandAdaptiveToggleItem($r('app.string.hand_adaptive_master_title'),
        $r('app.string.hand_adaptive_master_desc'), this.handAdaptiveEnabled, true, (value: boolean) => {
          this.callbacks.onToggleHandAdaptiveEnabled(value)
        })

      if (this.handAdaptiveEnabled) {
        Divider().color($r('app.color.divider'))

        this.HandAdaptiveToggleItem($r('app.string.hand_adaptive_new_chat_title'),
          $r('app.string.hand_adaptive_new_chat_desc'), this.handAdaptiveNewChat, this.handAdaptiveEnabled,
          (value: boolean) => {
            this.callbacks.onToggleHandAdaptiveNewChat(value)
          })

        if (this.handAdaptiveUnsupported) {
          Text($r('app.string.hand_adaptive_unsupported_tip'))
            .fontSize(12)
            .fontColor($r('app.color.status_error'))
            .lineHeight(18)
            .margin({ left: 8, right: 8, top: 12 })
        }
      }
    }
    .width('100%')
  }

  @Builder
  private NotificationToggleItem(title: Resource, desc: Resource, checked: boolean, onChanged: (value: boolean) =>
    void) {
    Row() {
      Column() {
        Text(title)
          .fontSize(15)
          .fontColor($r('app.color.text_primary'))

        Text(desc)
          .fontSize(12)
          .fontColor($r('app.color.text_secondary'))
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Toggle({ type: ToggleType.Switch, isOn: checked })
        .onChange((value: boolean) => {
          onChanged(value)
        })
    }
    .width('100%')
    .padding({ left: 8, right: 8, top: 12, bottom: 12 })
  }

  @Builder
  private OpenSystemNotificationSettingsEntry() {
    Column() {
      Text($r('app.string.notification_system_settings_tip'))
        .fontSize(12)
        .fontColor($r('app.color.text_secondary'))
        .lineHeight(18)
        .margin({ top: 10, bottom: 10 })

      Button($r('app.string.notification_open_system_settings'))
        .width('100%')
        .height(40)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.themePrimary)
        .backgroundColor(this.themePrimary + '1A')
        .borderRadius(12)
        .onClick(() => {
          this.callbacks.onOpenSystemNotificationSettings()
        })
    }
    .width('100%')
    .padding({ left: 8, right: 8, top: 2, bottom: 2 })
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Column() {
      if (this.settingsSheetType === SettingsSheetType.THEME) {
        this.ThemeOptionItem(ThemeMode.SYSTEM, $r('app.string.theme_system'))
        Divider().color($r('app.color.divider'))
        this.ThemeOptionItem(ThemeMode.LIGHT, $r('app.string.theme_light'))
        Divider().color($r('app.color.divider'))
        this.ThemeOptionItem(ThemeMode.DARK, $r('app.string.theme_dark'))
      } else if (this.settingsSheetType === SettingsSheetType.LANGUAGE) {
        this.LanguageOptionItem(AppLanguage.SYSTEM, $r('app.string.language_system'))
        Divider().color($r('app.color.divider'))
        this.LanguageOptionItem(AppLanguage.ZH_CN, $r('app.string.language_zh_cn'))
        Divider().color($r('app.color.divider'))
        this.LanguageOptionItem(AppLanguage.EN_US, $r('app.string.language_en_us'))
      } else if (this.settingsSheetType === SettingsSheetType.COLOR_THEME) {
        ThemeColorPicker({
          onThemeSelected: (theme: ColorTheme) => {
            this.callbacks.onSelectColorTheme(theme)
          }
        })
      } else if (this.settingsSheetType === SettingsSheetType.HAND_ADAPTIVE) {
        this.HandAdaptiveSheetContent()
      } else if (this.settingsSheetType === SettingsSheetType.NOTIFICATION) {
        this.NotificationToggleItem($r('app.string.notification_enabled_title'),
          $r('app.string.notification_enabled_desc'), this.notifyEnabled, (value: boolean) => {
            this.callbacks.onToggleNotifyEnabled(value)
          })

        Divider().color($r('app.color.divider'))

        this.NotificationToggleItem($r('app.string.notification_on_complete_title'),
          $r('app.string.notification_on_complete_desc'), this.notifyOnComplete, (value: boolean) => {
            this.callbacks.onToggleNotifyOnComplete(value)
          })

        Divider().color($r('app.color.divider'))

        this.NotificationToggleItem($r('app.string.notification_on_failed_title'),
          $r('app.string.notification_on_failed_desc'), this.notifyOnFailed, (value: boolean) => {
            this.callbacks.onToggleNotifyOnFailed(value)
          })

        Divider().color($r('app.color.divider')).margin({ top: 6 })
        this.OpenSystemNotificationSettingsEntry()
      } else if (this.settingsSheetType === SettingsSheetType.FONT_SIZE) {
        this.FontSizeSheetContent()
      } else {
        Column()
          .width('100%')
          .height(1)
      }
    }
    .width('100%')
    .padding({
      left: this.settingsSheetType === SettingsSheetType.COLOR_THEME ? 0 : 16,
      right: this.settingsSheetType === SettingsSheetType.COLOR_THEME ? 0 : 16,
      bottom: 32
    })
  }
}
