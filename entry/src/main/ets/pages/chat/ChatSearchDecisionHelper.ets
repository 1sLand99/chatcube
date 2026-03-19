function isBingSearchEngineForChat(engineName: string): boolean {
  const normalizedName = engineName.trim().toLowerCase()
  return normalizedName === 'bing' || normalizedName === 'bing(local)' || normalizedName.startsWith('bing(')
}

export function isSelfOptimizedSearchEngineForChat(engineName: string): boolean {
  const normalizedName = engineName.trim().toLowerCase()
  return normalizedName === 'exa'
}

export function shouldApplyLlmQueryOptimizationForChat(engineName: string, globalEnabled: boolean): boolean {
  if (!globalEnabled) {
    return false
  }
  return isBingSearchEngineForChat(engineName)
}
