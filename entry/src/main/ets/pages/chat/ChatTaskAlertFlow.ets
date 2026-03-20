import { ChatTaskStatus } from '../../models/ChatTaskModels'
import { showSnackBar, SnackBarDisplayOptions, SnackBarTone } from '../../utils/ToastUtil'
import {
  parseInAppTaskAlertPayload,
  parseOpenSessionPayload
} from '../../utils/TaskAlertUtils'

export interface ChatTaskAlertFlowDependencies {
  getCurrentSessionId: () => string
  getLastHandledAlertTimestamp: () => number
  onSetLastHandledAlertTimestamp: (value: number) => void
  onNavigateToSession: (sessionId: string) => void
  onClearOpenSessionPayloadStorage: () => void
  onClearInAppTaskAlertPayloadStorage: () => void
  getUIContext: () => UIContext
}

export class ChatTaskAlertFlow {
  private deps: ChatTaskAlertFlowDependencies

  constructor(deps: ChatTaskAlertFlowDependencies) {
    this.deps = deps
  }

  handleOpenSessionPayload(payloadText: string): void {
    if (payloadText === '') {
      return
    }

    const payload = parseOpenSessionPayload(payloadText)
    if (payload === null) {
      console.error('ChatTaskAlertFlow', 'Failed to parse openSession payload')
      return
    }

    const currentSessionId = this.deps.getCurrentSessionId()
    if (payload.sessionId === currentSessionId) {
      this.deps.onClearOpenSessionPayloadStorage()
      return
    }

    this.deps.onNavigateToSession(payload.sessionId)
    this.deps.onClearOpenSessionPayloadStorage()
  }

  handleInAppTaskAlertPayload(payloadText: string): void {
    if (payloadText === '') {
      return
    }

    const payload = parseInAppTaskAlertPayload(payloadText)
    if (payload === null) {
      console.error('ChatTaskAlertFlow', 'Failed to parse in-app alert payload')
      return
    }

    if (payload.timestamp <= this.deps.getLastHandledAlertTimestamp()) {
      return
    }

    const currentSessionId = this.deps.getCurrentSessionId()
    if (payload.sessionId === currentSessionId) {
      this.deps.onClearInAppTaskAlertPayloadStorage()
      return
    }

    this.deps.onSetLastHandledAlertTimestamp(payload.timestamp)

    const opts = new SnackBarDisplayOptions()
    opts.message = payload.message
    opts.duration = 5000
    opts.tone = payload.status === ChatTaskStatus.FAILED ? SnackBarTone.ERROR : SnackBarTone.SUCCESS
    opts.actionText = $r('app.string.task_alert_view')
    opts.onAction = (): void => {
      this.deps.onNavigateToSession(payload.sessionId)
    }
    showSnackBar(this.deps.getUIContext(), opts)
    this.deps.onClearInAppTaskAlertPayloadStorage()
  }
}
