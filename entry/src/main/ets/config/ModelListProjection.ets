import { ModelInfo, ModelProvider } from '../models/ChatModels'
import { PickerModelGroup, buildPickerModelGroups } from './ProviderDetailShared'

export enum ModelRowGroupPosition {
  SINGLE = 'single',
  FIRST = 'first',
  MIDDLE = 'middle',
  LAST = 'last'
}

export interface ModelRowRadius {
  topLeft: number
  topRight: number
  bottomLeft: number
  bottomRight: number
}

export enum ModelSelectorRowType {
  PROVIDER_HEADER = 'provider_header',
  MODEL_ITEM = 'model_item'
}

export interface ModelSelectorProviderHeaderRow {
  type: ModelSelectorRowType.PROVIDER_HEADER
  key: string
  provider: ModelProvider
}

export interface ModelSelectorModelRow {
  type: ModelSelectorRowType.MODEL_ITEM
  key: string
  provider: ModelProvider
  model: ModelInfo
  isFavorite: boolean
  groupPosition: ModelRowGroupPosition
}

export type ModelSelectorRow = ModelSelectorProviderHeaderRow | ModelSelectorModelRow

export interface ModelSelectorBuildResult {
  rows: ModelSelectorRow[]
  enabledModelCount: number
  favoriteEnabledCount: number
  matchedModelCount: number
  hasEnabledModels: boolean
  hasFavoriteModels: boolean
  hasFilteredModels: boolean
}

export function buildModelSelectorRows(
  providers: ModelProvider[],
  searchKeywords: string,
  favoriteKeys: Set<string>,
  showFavoritesOnly: boolean,
  includeModelIdInSearch: boolean
): ModelSelectorBuildResult {
  const rows: ModelSelectorRow[] = []
  const trimmedKeyword = searchKeywords.trim().toLowerCase()
  let enabledModelCount = 0
  let favoriteEnabledCount = 0
  let matchedModelCount = 0

  for (let i = 0; i < providers.length; i++) {
    const provider = providers[i]
    const matchedModels: ModelInfo[] = []

    for (let j = 0; j < provider.models.length; j++) {
      const model = provider.models[j]
      if (!model.isEnabled) {
        continue
      }

      enabledModelCount++
      const favoriteKey = `${provider.id}::${model.id}`
      const isFavorite = favoriteKeys.has(favoriteKey)
      if (isFavorite) {
        favoriteEnabledCount++
      }

      if (trimmedKeyword !== '') {
        const matchesName = model.name.toLowerCase().includes(trimmedKeyword)
        const matchesId = includeModelIdInSearch && model.id.toLowerCase().includes(trimmedKeyword)
        if (!matchesName && !matchesId) {
          continue
        }
      }

      if (showFavoritesOnly && !isFavorite) {
        continue
      }

      matchedModels.push(model)
      matchedModelCount++
    }

    if (matchedModels.length === 0) {
      continue
    }

    rows.push({
      type: ModelSelectorRowType.PROVIDER_HEADER,
      key: `${provider.id}::header`,
      provider: provider
    } as ModelSelectorProviderHeaderRow)

    for (let j = 0; j < matchedModels.length; j++) {
      const favoriteStateKey = favoriteKeys.has(`${provider.id}::${matchedModels[j].id}`) ? 'favorite' : 'normal'
      rows.push({
        type: ModelSelectorRowType.MODEL_ITEM,
        key: `${provider.id}::${matchedModels[j].id}::${favoriteStateKey}`,
        provider: provider,
        model: matchedModels[j],
        isFavorite: favoriteKeys.has(`${provider.id}::${matchedModels[j].id}`),
        groupPosition: resolveGroupPosition(j, matchedModels.length)
      } as ModelSelectorModelRow)
    }
  }

  return {
    rows: rows,
    enabledModelCount: enabledModelCount,
    favoriteEnabledCount: favoriteEnabledCount,
    matchedModelCount: matchedModelCount,
    hasEnabledModels: enabledModelCount > 0,
    hasFavoriteModels: favoriteEnabledCount > 0,
    hasFilteredModels: matchedModelCount > 0
  } as ModelSelectorBuildResult
}

export enum ModelPickerRowType {
  GROUP_HEADER = 'group_header',
  MODEL_ITEM = 'model_item'
}

export interface ModelPickerGroupHeaderRow {
  type: ModelPickerRowType.GROUP_HEADER
  key: string
  groupName: string
  modelIds: string[]
  isExpanded: boolean
}

export interface ModelPickerModelRow {
  type: ModelPickerRowType.MODEL_ITEM
  key: string
  groupName: string
  modelId: string
  isExisting: boolean
  groupPosition: ModelRowGroupPosition
}

export type ModelPickerRow = ModelPickerGroupHeaderRow | ModelPickerModelRow

export interface ModelPickerBuildResult {
  rows: ModelPickerRow[]
  filteredModelIds: string[]
  groups: PickerModelGroup[]
}

export function buildModelPickerRows(
  availableModels: string[],
  selectedModelIds: Set<string>,
  existingModelIds: Set<string>,
  searchKeywords: string,
  expansionState: Map<string, boolean>
): ModelPickerBuildResult {
  const filteredModelIds = filterAvailableModels(availableModels, searchKeywords)
  const selectedFilteredModelIds = collectSelectedModelIds(filteredModelIds, selectedModelIds)
  const unselectedFilteredModelIds = collectUnselectedModelIds(filteredModelIds, selectedModelIds)
  const rawGroups = buildPickerModelGroups(unselectedFilteredModelIds)
  const groups: PickerModelGroup[] = []
  const rows: ModelPickerRow[] = []

  if (selectedFilteredModelIds.length > 0) {
    appendPickerGroup(
      groups,
      rows,
      {
        name: '已选择',
        modelIds: selectedFilteredModelIds,
        isExpanded: true
      },
      expansionState,
      existingModelIds
    )
  }

  for (let i = 0; i < rawGroups.length; i++) {
    appendPickerGroup(groups, rows, rawGroups[i], expansionState, existingModelIds)
  }

  return {
    rows: rows,
    filteredModelIds: filteredModelIds,
    groups: groups
  } as ModelPickerBuildResult
}

function filterAvailableModels(availableModels: string[], searchKeywords: string): string[] {
  const trimmedKeyword = searchKeywords.trim().toLowerCase()
  if (trimmedKeyword === '') {
    return availableModels.slice()
  }

  const result: string[] = []
  for (let i = 0; i < availableModels.length; i++) {
    const modelId = availableModels[i]
    if (modelId.toLowerCase().includes(trimmedKeyword)) {
      result.push(modelId)
    }
  }
  return result
}

function collectSelectedModelIds(modelIds: string[], selectedModelIds: Set<string>): string[] {
  const selected: string[] = []
  for (let i = 0; i < modelIds.length; i++) {
    const modelId = modelIds[i]
    if (selectedModelIds.has(modelId)) {
      selected.push(modelId)
    }
  }
  return selected
}

function collectUnselectedModelIds(modelIds: string[], selectedModelIds: Set<string>): string[] {
  const unselected: string[] = []
  for (let i = 0; i < modelIds.length; i++) {
    const modelId = modelIds[i]
    if (!selectedModelIds.has(modelId)) {
      unselected.push(modelId)
    }
  }
  return unselected
}

function appendPickerGroup(
  groups: PickerModelGroup[],
  rows: ModelPickerRow[],
  rawGroup: PickerModelGroup,
  expansionState: Map<string, boolean>,
  existingModelIds: Set<string>
): void {
  const isExpanded = expansionState.has(rawGroup.name) ? (expansionState.get(rawGroup.name) ?? true) : true
  const group: PickerModelGroup = {
    name: rawGroup.name,
    modelIds: rawGroup.modelIds,
    isExpanded: isExpanded
  }
  groups.push(group)

  rows.push({
    type: ModelPickerRowType.GROUP_HEADER,
    key: `group::${group.name}`,
    groupName: group.name,
    modelIds: group.modelIds,
    isExpanded: group.isExpanded
  } as ModelPickerGroupHeaderRow)

  if (!group.isExpanded) {
    return
  }

  for (let i = 0; i < group.modelIds.length; i++) {
    const modelId = group.modelIds[i]
    rows.push({
      type: ModelPickerRowType.MODEL_ITEM,
      key: `${group.name}::${modelId}`,
      groupName: group.name,
      modelId: modelId,
      isExisting: existingModelIds.has(modelId),
      groupPosition: resolveGroupPosition(i, group.modelIds.length)
    } as ModelPickerModelRow)
  }
}

function resolveGroupPosition(index: number, totalCount: number): ModelRowGroupPosition {
  if (totalCount <= 1) {
    return ModelRowGroupPosition.SINGLE
  }
  if (index === 0) {
    return ModelRowGroupPosition.FIRST
  }
  if (index === totalCount - 1) {
    return ModelRowGroupPosition.LAST
  }
  return ModelRowGroupPosition.MIDDLE
}
