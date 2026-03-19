import { ChatMessage } from '../../models/ChatModels'

export interface ChatScrollUiFlowDependencies {
  scroller: Scroller
  messages: ChatMessage[]
  getBottomAnchorIndex: () => number
  getCurrentScrollOffset: () => number
  getLastScrollOffset: () => number
  setLastScrollOffset: (value: number) => void
  getMaxScrollOffset: () => number
  setMaxScrollOffset: (value: number) => void
  getInputBarShowThreshold: () => number
  getInputBarHideThreshold: () => number
  getIsAtTop: () => boolean
  getIsAtBottom: () => boolean
  getIsInputBarVisible: () => boolean
  getIsSending: () => boolean
  getIsEditingMessage: () => boolean
  getEditingMessageId: () => string
  hasDraftContent: () => boolean
  onSetIsAtTopState: (value: boolean) => void
  onSetIsAtBottomState: (value: boolean) => void
  onSetInputBarVisibleState: (value: boolean) => void
  onSetScrollProgressState: (value: number) => void
  onAnimate: (duration: number, curve: Curve, updater: () => void) => void
}

export class ChatScrollUiFlow {
  private deps: ChatScrollUiFlowDependencies

  constructor(deps: ChatScrollUiFlowDependencies) {
    this.deps = deps
  }

  private normalizeScrollOffset(value: number): number {
    if (!Number.isFinite(value) || value <= 0) {
      return 0
    }
    return value
  }

  private clampProgress(value: number): number {
    if (!Number.isFinite(value)) {
      return 0
    }
    if (value <= 0) {
      return 0
    }
    if (value >= 1) {
      return 1
    }
    return value
  }

  private setScrollProgress(value: number): void {
    this.deps.onSetScrollProgressState(this.clampProgress(value))
  }

  private getCurrentScrollProgress(): number {
    const maxScrollOffset = this.deps.getMaxScrollOffset()
    if (maxScrollOffset <= 0) {
      return 0
    }
    const normalizedOffset = this.normalizeScrollOffset(this.deps.getCurrentScrollOffset())
    return this.clampProgress(normalizedOffset / maxScrollOffset)
  }

  private updateScrollProgress(): void {
    const normalizedOffset = this.normalizeScrollOffset(this.deps.getCurrentScrollOffset())
    if (normalizedOffset <= 0 || this.deps.getIsAtTop()) {
      this.setScrollProgress(0)
      return
    }
    const maxScrollOffset = this.deps.getMaxScrollOffset()
    if (maxScrollOffset <= 0) {
      return
    }
    this.setScrollProgress(normalizedOffset / maxScrollOffset)
  }

  private captureBottomScrollBaseline(): void {
    const currentOffset = this.normalizeScrollOffset(this.deps.getCurrentScrollOffset())
    if (currentOffset > this.deps.getMaxScrollOffset()) {
      this.deps.setMaxScrollOffset(currentOffset)
    }
    if (this.deps.getMaxScrollOffset() > 0) {
      this.setScrollProgress(1)
      return
    }
    if (this.deps.getIsAtTop()) {
      this.setScrollProgress(0)
      return
    }
    if (currentOffset > 0) {
      this.setScrollProgress(1)
    }
  }

  private syncBottomScrollBaselineAfterLayout(): void {
    setTimeout(() => {
      this.captureBottomScrollBaseline()
    }, 0)
    setTimeout(() => {
      this.captureBottomScrollBaseline()
    }, 50)
  }

  private scrollBottomAnchor(smooth: boolean): void {
    const bottomAnchorIndex = this.deps.getBottomAnchorIndex()
    if (bottomAnchorIndex >= 0) {
      this.deps.scroller.scrollToIndex(bottomAnchorIndex, smooth, ScrollAlign.END)
      return
    }
    this.deps.scroller.scrollEdge(Edge.Bottom)
  }

  private scrollEdgeAfterLayout(edge: Edge): void {
    setTimeout(() => {
      this.deps.scroller.scrollEdge(edge)
    }, 0)
    setTimeout(() => {
      this.deps.scroller.scrollEdge(edge)
    }, 50)
  }

  alignToBottomAfterLayout(): void {
    setTimeout(() => {
      this.scrollBottomAnchor(false)
    }, 0)
    setTimeout(() => {
      this.scrollBottomAnchor(false)
    }, 50)
    this.syncBottomScrollBaselineAfterLayout()
  }

  alignToBottomIfPinned(): void {
    if (!this.deps.getIsAtBottom()) {
      return
    }
    this.alignToBottomAfterLayout()
  }

  setIsAtTop(value: boolean): void {
    if (this.deps.getIsAtTop() === value) {
      return
    }
    this.deps.onAnimate(200, Curve.EaseOut, () => {
      this.deps.onSetIsAtTopState(value)
    })
  }

  setIsAtBottom(value: boolean): void {
    if (this.deps.getIsAtBottom() === value) {
      return
    }
    this.deps.onAnimate(200, Curve.EaseOut, () => {
      this.deps.onSetIsAtBottomState(value)
    })
  }

  setInputBarVisible(value: boolean): void {
    if (this.deps.getIsInputBarVisible() === value) {
      return
    }
    this.deps.onAnimate(300, Curve.FastOutSlowIn, () => {
      this.deps.onSetInputBarVisibleState(value)
    })
  }

  handleMessageListDidScroll(scrollOffset: number, scrollState: ScrollState): void {
    const lastScrollOffset = this.deps.getLastScrollOffset()
    const offsetDelta = scrollOffset - lastScrollOffset

    if (scrollState === ScrollState.Scroll && this.deps.getIsAtBottom() && offsetDelta < 0) {
      this.setIsAtBottom(false)
    }

    if (scrollState === ScrollState.Scroll && scrollOffset !== 0) {
      this.setIsAtTop(false)
    }

    if (scrollState === ScrollState.Scroll || scrollState === ScrollState.Fling) {
      if (offsetDelta > this.deps.getInputBarShowThreshold()) {
        this.setInputBarVisible(true)
      } else if (offsetDelta < -this.deps.getInputBarHideThreshold()) {
        if (!this.deps.getIsAtBottom() &&
          !this.deps.getIsSending() &&
          !this.deps.getIsEditingMessage() &&
          this.getCurrentScrollProgress() > 0.2) {
          this.setInputBarVisible(false)
        }
      }

      this.deps.setLastScrollOffset(scrollOffset)
      this.updateScrollProgress()
    }
  }

  onDraftContentChanged(): void {
    if (!this.deps.getIsEditingMessage() && this.deps.getEditingMessageId() === '' &&
      this.deps.hasDraftContent()) {
      this.alignToBottomAfterLayout()
    }
  }

  scrollToBottomWithAnimation(): void {
    this.setIsAtBottom(true)
    this.setIsAtTop(false)
    this.setInputBarVisible(true)
    this.scrollBottomAnchor(true)
    this.captureBottomScrollBaseline()
    this.alignToBottomAfterLayout()
  }

  scrollToTopWithAnimation(): void {
    if (this.deps.messages.length <= 0) {
      return
    }
    this.setIsAtTop(true)
    this.setIsAtBottom(false)
    this.setInputBarVisible(true)
    this.setScrollProgress(0)
    this.deps.scroller.scrollEdge(Edge.Top)
    this.scrollEdgeAfterLayout(Edge.Top)
  }

  handleReachStart(): void {
    this.setIsAtTop(true)
    this.setScrollProgress(0)
  }

  handleReachEnd(): void {
    this.setIsAtBottom(true)
    this.setInputBarVisible(true)
    this.captureBottomScrollBaseline()
  }
}
