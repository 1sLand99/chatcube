import { ChatMessage, MessageRole } from '../models/ChatModels'

export function shouldShowAssistantMessageToolbar(message: ChatMessage, isMultiSelectMode: boolean): boolean {
  if (message.role !== MessageRole.ASSISTANT) {
    return false
  }
  return !message.isGenerating && !message.isSearching && !isMultiSelectMode
}
