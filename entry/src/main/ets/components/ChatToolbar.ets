/**
 * 聊天工具栏组件
 * 包含联网查询开关、推理开关等功能按钮
 */

import { ReasoningLevel } from '../models/ChatModels'
import { getPreferencesService, PreferenceKeys } from '../services/PreferencesService'
import { getAppUiState } from '../state/AppUiState'

@ComponentV2
export struct ChatToolbar {
  // 联网查询全局可用状态（工具中心控制）
  @Param webSearchAvailable: boolean = false
  // 联网查询本会话开关状态（聊天页面控制）
  @Param webSearchEnabled: boolean = false
  @Event onWebSearchEnabledChange: (value: boolean) => void = (_value: boolean): void => {}
  // 当前模型是否支持推理
  @Param reasoningAvailable: boolean = false
  // 推理级别状态
  @Param reasoningLevel: ReasoningLevel = ReasoningLevel.OFF
  @Event onReasoningLevelChange: (value: ReasoningLevel) => void = (_value: ReasoningLevel): void => {}

  // 主题颜色
  private get themePrimary(): string {
    return getAppUiState().themePrimary
  }

  build() {
    Row() {
      // 联网查询开关（仅在工具中心启用时展示）
      if (this.webSearchAvailable) {
        Button({ type: ButtonType.Capsule, stateEffect: false }) {
          Row() {
            SymbolGlyph($r('sys.symbol.worldclock'))
              .fontSize(16)
              .fontColor([this.webSearchEnabled ? Color.White : $r('app.color.text_secondary')])

            Text($r('app.string.chat_toolbar_web_search'))
              .fontSize(14)
              .fontColor(this.webSearchEnabled ? Color.White : $r('app.color.text_secondary'))
              .margin({ left: 4 })
          }
        }
        .padding({ left: 12, right: 12, top: 6, bottom: 6 })
        .clip(true)
        .backgroundColor(this.webSearchEnabled ? this.themePrimary : $r('app.color.surface'))
        .border(this.webSearchEnabled ? undefined : {
          width: 0.5,
          color: $r('app.color.divider')
        })
        // 背景色过渡动画
        .animation({ duration: 200, curve: Curve.EaseOut })
        .onClick(() => {
          const newValue = !this.webSearchEnabled
          this.onWebSearchEnabledChange(newValue)
          const prefsService = getPreferencesService()
          prefsService.setBoolean(PreferenceKeys.SEARCH_CONVERSATION_ENABLED, newValue)
        })
      }

      if (this.reasoningAvailable) {
        // 推理开关按钮
        Button({ type: ButtonType.Capsule, stateEffect: false }) {
          Row() {
            SymbolGlyph($r('sys.symbol.lightbulb'))
              .fontSize(16)
              .fontColor([this.isReasoningEnabled() ? Color.White : $r('app.color.text_secondary')])

            Text($r('app.string.chat_toolbar_reasoning'))
              .fontSize(14)
              .fontColor(this.isReasoningEnabled() ? Color.White : $r('app.color.text_secondary'))
              .margin({ left: 4 })
          }
        }
        .padding({ left: 12, right: 12, top: 6, bottom: 6 })
        .clip(true)
        .backgroundColor(this.isReasoningEnabled() ? this.themePrimary : $r('app.color.surface'))
        .margin({ left: this.webSearchAvailable ? 8 : 0 })
        .border(this.isReasoningEnabled() ? undefined : {
          width: 0.5,
          color: $r('app.color.divider')
        })
        // 背景色过渡动画
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

