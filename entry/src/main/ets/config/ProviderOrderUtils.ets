import { ModelProvider } from '../models/ChatModels'

export enum ProviderManageTabKey {
  ENABLED = 'enabled',
  DISABLED = 'disabled'
}

export function filterProvidersByTab(providers: ModelProvider[], tabKey: ProviderManageTabKey): ModelProvider[] {
  const result: ModelProvider[] = []
  const shouldIncludeEnabled = tabKey === ProviderManageTabKey.ENABLED
  for (let i = 0; i < providers.length; i++) {
    if (providers[i].isConnected === shouldIncludeEnabled) {
      result.push(providers[i])
    }
  }
  return result
}

export function reorderProvidersWithinTab(
  allProviders: ModelProvider[],
  tabKey: ProviderManageTabKey,
  from: number,
  to: number
): ModelProvider[] {
  if (from === to || from < 0 || to < 0) {
    return allProviders
  }

  const slotIndexes: number[] = []
  const shouldIncludeEnabled = tabKey === ProviderManageTabKey.ENABLED
  for (let i = 0; i < allProviders.length; i++) {
    if (allProviders[i].isConnected === shouldIncludeEnabled) {
      slotIndexes.push(i)
    }
  }

  if (from >= slotIndexes.length || to >= slotIndexes.length) {
    return allProviders
  }

  const tabProviders = filterProvidersByTab(allProviders, tabKey)
  const moved = tabProviders.splice(from, 1)
  if (moved.length === 0) {
    return allProviders
  }
  tabProviders.splice(to, 0, moved[0])

  const nextProviders: ModelProvider[] = []
  let tabIndex = 0
  for (let i = 0; i < allProviders.length; i++) {
    if (allProviders[i].isConnected === shouldIncludeEnabled) {
      nextProviders.push(tabProviders[tabIndex])
      tabIndex++
    } else {
      nextProviders.push(allProviders[i])
    }
  }
  return nextProviders
}

export function buildProviderImportOrder(importProviderIds: string[], localProviderIds: string[]): string[] {
  const ordered: string[] = []
  const seen = new Set<string>()

  for (let i = 0; i < importProviderIds.length; i++) {
    const providerId = importProviderIds[i]
    if (providerId === '' || seen.has(providerId)) {
      continue
    }
    ordered.push(providerId)
    seen.add(providerId)
  }

  for (let i = 0; i < localProviderIds.length; i++) {
    const providerId = localProviderIds[i]
    if (providerId === '' || seen.has(providerId)) {
      continue
    }
    ordered.push(providerId)
    seen.add(providerId)
  }

  return ordered
}
