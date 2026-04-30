import { getAppUiState } from '../../state/AppUiState'
import { getHdsTopNavigationMaskExtraHeight } from '../../utils/HdsVisualEffectUtil'
import { withColorAlpha } from '../../utils/ColorAlphaUtils'

@ComponentV2
export struct SettingsCompactTitleBarContent {
  @Param title: string | Resource = ''
  @Event onBack: () => void = () => {}

  build() {
    Row({ space: 4 }) {
      Button() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(20)
          .fontColor([$r('app.color.text_primary')])
      }
      .type(ButtonType.Normal)
      .stateEffect(false)
      .width(40)
      .height(40)
      .borderRadius(20)
      .backgroundColor(Color.Transparent)
      .onClick(() => {
        this.onBack()
      })

      Text(this.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .layoutWeight(1)
        .margin({ left: 4 })

      Column()
        .width(40)
        .height(40)
    }
    .width('100%')
    .height(56)
    .padding({ left: 8, right: 8 })
    .alignItems(VerticalAlign.Center)
  }
}

@ComponentV2
export struct SettingsCompactPageHeader {
  @Param title: string | Resource = ''
  @Param topAvoidHeight: number = 0
  @Event onBack: () => void = () => {}

  private get windowWidthVp(): number {
    return getAppUiState().windowWidthVp
  }

  private get windowHeightVp(): number {
    return getAppUiState().windowHeightVp
  }

  private px2vp(px: number): number {
    return px / (this.getUIContext().getHostContext()?.resourceManager.getDeviceCapabilitySync().screenDensity ?? 3) * 160
  }

  private getMaskExtraHeight(): number {
    return getHdsTopNavigationMaskExtraHeight(this.windowWidthVp, this.windowHeightVp)
  }

  build() {
    Column() {
      Column()
        .width('100%')
        .height(this.px2vp(this.topAvoidHeight))

      SettingsCompactTitleBarContent({
        title: this.title,
        onBack: this.onBack
      })

      Column()
        .width('100%')
        .height(this.getMaskExtraHeight())
        .backgroundColor(withColorAlpha(getAppUiState().themeBackground, '00'))
        .backgroundBlurStyle(BlurStyle.COMPONENT_THIN)
    }
    .width('100%')
    .backgroundColor(withColorAlpha(getAppUiState().themeBackground, 'E6'))
    .backgroundBlurStyle(BlurStyle.COMPONENT_THIN)
    .renderGroup(true)
  }
}
