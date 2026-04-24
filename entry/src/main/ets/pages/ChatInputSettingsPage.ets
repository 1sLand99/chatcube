import { AppStorageKeys } from '../config/AppStorageKeys'
import { ServiceRegistry } from '../services/ServiceRegistry'
import { IndexSettingsSheetContent } from '../components/index/IndexSettingsSheetContent'
import { SettingsCompactPageHeader } from '../components/settings/SettingsCompactPageHeader'
import { IndexSettingsSheetActionCallbacks } from './index/IndexSettingsSheetCoordinator'
import { SettingsSheetType } from './index/IndexPageTypes'
import { getSettingsPageContentMaxWidth, getSettingsPageCompactTabsTotalInset } from '../utils/SettingsPageLayoutHelper'
import { SettingsPagePresentationMode } from '../config/SettingsDetailPresentation'
import { getAppUiState, setAppUiStateValue } from '../state/AppUiState'

let chatInputSettingsPathStack: NavPathStack | null = null

@Entry
@ComponentV2
struct ChatInputSettingsPage {
  private get topAvoidHeight(): number {
    return getAppUiState().topAvoidHeight
  }
  private get bottomAvoidHeight(): number {
    return getAppUiState().bottomAvoidHeight
  }
  private get layoutSizeClass(): string {
    return getAppUiState().layoutSizeClass
  }
  private get windowWidthVp(): number {
    return getAppUiState().windowWidthVp
  }
  private get windowHeightVp(): number {
    return getAppUiState().windowHeightVp
  }
  private get settingsDetailPresentationMode(): string {
    return getAppUiState().settingsDetailPresentationMode
  }

  @Local chatInputEnterKeySend: boolean = false

  private settingsManager = ServiceRegistry.settings()

  private px2vp(px: number): number {
    return px / (this.getUIContext().getHostContext()?.resourceManager.getDeviceCapabilitySync().screenDensity ?? 3) * 160
  }

  aboutToAppear(): void {
    this.reloadSettings()
  }

  private reloadSettings(): void {
    this.chatInputEnterKeySend = this.settingsManager.getChatInputEnterKeySend()
  }

  private getContentMaxWidth(): number {
    return getSettingsPageContentMaxWidth(this.layoutSizeClass, this.windowWidthVp, this.settingsDetailPresentationMode,
      this.windowHeightVp)
  }

  private isDetailPaneMode(): boolean {
    return this.settingsDetailPresentationMode === SettingsPagePresentationMode.DETAIL_PANE
  }

  private getScrollBottomPadding(): number {
    return 24 + getSettingsPageCompactTabsTotalInset(this.px2vp(this.bottomAvoidHeight),
      this.settingsDetailPresentationMode)
  }

  private handleBack(): void {
    if (chatInputSettingsPathStack !== null && chatInputSettingsPathStack.size() > 0) {
      chatInputSettingsPathStack.pop()
    }
  }

  private buildCallbacks(): IndexSettingsSheetActionCallbacks {
    const callbacks = new IndexSettingsSheetActionCallbacks()
    callbacks.onToggleChatInputEnterKeySend = async (value: boolean): Promise<void> => {
      const previousValue = this.chatInputEnterKeySend
      this.chatInputEnterKeySend = value
      setAppUiStateValue(AppStorageKeys.CHAT_INPUT_ENTER_KEY_SEND, value)
      try {
        await this.settingsManager.setChatInputEnterKeySend(value)
      } catch (error) {
        console.error('ChatInputSettingsPage', `Failed to set enter key behavior: ${JSON.stringify(error)}`)
        this.chatInputEnterKeySend = previousValue
        setAppUiStateValue(AppStorageKeys.CHAT_INPUT_ENTER_KEY_SEND, previousValue)
      }
    }
    return callbacks
  }

  @Builder
  private PageContent() {
    Scroll() {
      Row() {
        Column() {
          IndexSettingsSheetContent({
            settingsSheetType: SettingsSheetType.CHAT_INPUT,
            chatInputEnterKeySend: this.chatInputEnterKeySend,
            callbacks: this.buildCallbacks()
          })
        }
        .width('100%')
        .constraintSize({ maxWidth: this.getContentMaxWidth() })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .padding({ left: 16, right: 16, bottom: this.getScrollBottomPadding() })
    }
    .width('100%')
    .layoutWeight(1)
    .scrollBar(BarState.Off)
  }

  @Builder
  private DetailPaneHeader() {
    Column() {
      Row() {
        Text($r('app.string.settings_chat_input'))
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)
      }
      .width('100%')
      .height(64)
      .padding({ left: 24, right: 24 })
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .backgroundColor($r('app.color.background'))
    .border({ width: { bottom: 1 }, color: $r('app.color.divider') })
  }

  build() {
    Column() {
      if (this.isDetailPaneMode()) {
        Column() {
          this.DetailPaneHeader()
          this.PageContent()
        }
        .width('100%')
        .layoutWeight(1)
      } else {
        Column() {
          SettingsCompactPageHeader({
            title: $r('app.string.settings_chat_input'),
            topAvoidHeight: this.topAvoidHeight,
            onBack: () => {
              this.handleBack()
            }
          })
          this.PageContent()
        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor($r('app.color.background'))
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background'))
  }
}

@Builder
export function ChatInputSettingsPageBuilder(name: string, param: Object) {
  NavDestination() {
    ChatInputSettingsPage()
  }
  .hideTitleBar(true)
  .hideBackButton(true)
  .onReady((context: NavDestinationContext) => {
    chatInputSettingsPathStack = context.pathStack
  })
  .onBackPressed((): boolean => {
    if (chatInputSettingsPathStack !== null && chatInputSettingsPathStack.size() > 0) {
      chatInputSettingsPathStack.pop()
    }
    return true
  })
}
