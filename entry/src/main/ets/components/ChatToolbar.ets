/**
 * 聊天工具栏组件
 * 包含工具选择入口、推理开关等功能按钮
 */

import { ReasoningLevel } from '../models/ChatModels'
import { getAppUiState } from '../state/AppUiState'

@ComponentV2
export struct ChatToolbar {
  @Param webSearchAvailable: boolean = false
  @Param webSearchEnabled: boolean = false
  @Event onToggleWebSearch: () => void = (): void => {}
  @Param toolSelectionAvailable: boolean = false
  @Param hasSelectedTools: boolean = false
  @Event onOpenTools: () => void = (): void => {}
  // 当前模型是否支持推理
  @Param reasoningAvailable: boolean = false
  // 推理级别状态
  @Param reasoningLevel: ReasoningLevel = ReasoningLevel.OFF
  @Event onReasoningLevelChange: (value: ReasoningLevel) => void = (_value: ReasoningLevel): void => {}

  // 主题颜色
  private get themePrimary(): string {
    return getAppUiState().themePrimary
  }

  private get themeSurface(): string {
    return getAppUiState().themeSurface
  }

  private get themeDivider(): string {
    return getAppUiState().themeDivider
  }

  private get isDarkMode(): boolean {
    return getAppUiState().isDarkMode
  }

  private withAlpha(color: string, alphaHex: string): string {
    if (color.startsWith('#') && color.length === 7) {
      return `#${alphaHex}${color.slice(1)}`
    }
    if (color.startsWith('#') && color.length === 9) {
      return `#${alphaHex}${color.slice(3)}`
    }
    return color
  }

  private getChipBackgroundColor(): string {
    return this.withAlpha(this.themeSurface, this.isDarkMode ? '14' : '1A')
  }

  private getInactiveChipBorderColor(): string {
    return this.withAlpha(this.themeDivider, this.isDarkMode ? 'A6' : '73')
  }

  private getActiveChipBorderColor(): string {
    return this.themePrimary
  }

  private getChipShadowColor(): string {
    return this.isDarkMode ? 'rgba(0, 0, 0, 0.18)' : 'rgba(15, 23, 42, 0.06)'
  }

  build() {
    Row() {
      if (this.webSearchAvailable) {
        Button({ type: ButtonType.Capsule, stateEffect: false }) {
          Row() {
            SymbolGlyph($r('sys.symbol.magnifyingglass'))
              .fontSize(16)
              .fontColor([this.webSearchEnabled ? this.themePrimary : $r('app.color.text_secondary')])

            Text($r('app.string.chat_toolbar_web_search'))
              .fontSize(14)
              .fontColor(this.webSearchEnabled ? this.themePrimary : $r('app.color.text_secondary'))
              .fontWeight(this.webSearchEnabled ? FontWeight.Medium : FontWeight.Regular)
              .margin({ left: 4 })
          }
        }
        .height(32)
        .padding({ left: 12, right: 12 })
        .borderRadius(16)
        .backgroundColor(this.getChipBackgroundColor())
        .backgroundBlurStyle(BlurStyle.COMPONENT_REGULAR)
        .border({
          width: this.webSearchEnabled ? 1.4 : 0.5,
          color: this.webSearchEnabled ? this.getActiveChipBorderColor() : this.getInactiveChipBorderColor()
        })
        .shadow({ radius: 10, color: this.getChipShadowColor(), offsetX: 0, offsetY: 2 })
        .animation({ duration: 200, curve: Curve.EaseOut })
        .onClick(() => {
          this.onToggleWebSearch()
        })
      }

      if (this.toolSelectionAvailable) {
        Button({ type: ButtonType.Capsule, stateEffect: false }) {
          Row() {
            SymbolGlyph($r('sys.symbol.gearshape'))
              .fontSize(16)
              .fontColor([this.hasSelectedTools ? this.themePrimary : $r('app.color.text_secondary')])

            Text($r('app.string.chat_toolbar_tools'))
              .fontSize(14)
              .fontColor(this.hasSelectedTools ? this.themePrimary : $r('app.color.text_secondary'))
              .fontWeight(this.hasSelectedTools ? FontWeight.Medium : FontWeight.Regular)
              .margin({ left: 4 })
          }
        }
        .height(32)
        .padding({ left: 12, right: 12 })
        .borderRadius(16)
        .backgroundColor(this.getChipBackgroundColor())
        .backgroundBlurStyle(BlurStyle.COMPONENT_REGULAR)
        .border({
          width: this.hasSelectedTools ? 1.4 : 0.5,
          color: this.hasSelectedTools ? this.getActiveChipBorderColor() : this.getInactiveChipBorderColor()
        })
        .shadow({ radius: 10, color: this.getChipShadowColor(), offsetX: 0, offsetY: 2 })
        .margin({ left: this.webSearchAvailable ? 8 : 0 })
        .animation({ duration: 200, curve: Curve.EaseOut })
        .onClick(() => {
          this.onOpenTools()
        })
      }

      if (this.reasoningAvailable) {
        // 推理开关按钮
        Button({ type: ButtonType.Capsule, stateEffect: false }) {
          Row() {
            SymbolGlyph($r('sys.symbol.lightbulb'))
              .fontSize(16)
              .fontColor([this.isReasoningEnabled() ? this.themePrimary : $r('app.color.text_secondary')])

            Text($r('app.string.chat_toolbar_reasoning'))
              .fontSize(14)
              .fontColor(this.isReasoningEnabled() ? this.themePrimary : $r('app.color.text_secondary'))
              .fontWeight(this.isReasoningEnabled() ? FontWeight.Medium : FontWeight.Regular)
              .margin({ left: 4 })
          }
        }
        .height(32)
        .padding({ left: 12, right: 12 })
        .borderRadius(16)
        .backgroundColor(this.getChipBackgroundColor())
        .backgroundBlurStyle(BlurStyle.COMPONENT_REGULAR)
        .border({
          width: this.isReasoningEnabled() ? 1.4 : 0.5,
          color: this.isReasoningEnabled() ? this.getActiveChipBorderColor() : this.getInactiveChipBorderColor()
        })
        .shadow({ radius: 10, color: this.getChipShadowColor(), offsetX: 0, offsetY: 2 })
        .margin({ left: this.webSearchAvailable || this.toolSelectionAvailable ? 8 : 0 })
        .animation({ duration: 200, curve: Curve.EaseOut })
        .onClick(() => {
          this.onReasoningLevelChange(this.isReasoningEnabled() ? ReasoningLevel.OFF : ReasoningLevel.MEDIUM)
        })
      }

      Blank()
    }
    .width('100%')
    .padding({ left: 4, right: 4 })
    .margin({ bottom: 8 })
  }

  private isReasoningEnabled(): boolean {
    return this.reasoningLevel !== ReasoningLevel.OFF
  }
}

