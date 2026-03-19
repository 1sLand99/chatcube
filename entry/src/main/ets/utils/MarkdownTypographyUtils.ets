export type MarkdownTitleScale = [number, number, number, number, number, number]

function clamp(value: number, minValue: number, maxValue: number): number {
  return Math.max(minValue, Math.min(maxValue, value))
}

export function getMarkdownTextLineHeight(textSize: number, compact: boolean = false): number {
  const normalizedTextSize = Math.max(textSize, 10)
  const multiplier = compact ? 1.35 : 1.4
  return Math.round(normalizedTextSize * multiplier)
}

export function getMarkdownTitleSizes(textSize: number, compact: boolean = false): MarkdownTitleScale {
  const normalizedTextSize = Math.max(textSize, 10)
  if (compact) {
    return [
      normalizedTextSize + 3,
      normalizedTextSize + 2,
      normalizedTextSize + 1,
      normalizedTextSize + 1,
      normalizedTextSize,
      normalizedTextSize
    ]
  }

  return [
    normalizedTextSize + 4,
    normalizedTextSize + 3,
    normalizedTextSize + 2,
    normalizedTextSize + 1,
    normalizedTextSize,
    normalizedTextSize
  ]
}

export function getMarkdownTitleLineHeights(titleSizes: MarkdownTitleScale, compact: boolean = false): MarkdownTitleScale {
  const multiplier = compact ? 1.28 : 1.3
  return [
    Math.round(titleSizes[0] * multiplier),
    Math.round(titleSizes[1] * multiplier),
    Math.round(titleSizes[2] * multiplier),
    Math.round(titleSizes[3] * multiplier),
    Math.round(titleSizes[4] * multiplier),
    Math.round(titleSizes[5] * multiplier)
  ]
}

export function getMarkdownBlockSpacing(textSize: number, compact: boolean = false): number {
  const normalizedTextSize = Math.max(textSize, 10)
  if (compact) {
    return clamp(Math.round(normalizedTextSize * 0.5), 6, 10)
  }
  return clamp(Math.round(normalizedTextSize * 0.55), 7, 12)
}

export function getMarkdownQuotePadding(textSize: number, compact: boolean = false): Padding {
  const normalizedTextSize = Math.max(textSize, 10)
  const vertical = compact
    ? clamp(Math.round(normalizedTextSize * 0.4), 5, 10)
    : clamp(Math.round(normalizedTextSize * 0.45), 6, 12)
  const horizontal = compact
    ? clamp(Math.round(normalizedTextSize * 0.72), 9, 14)
    : clamp(Math.round(normalizedTextSize * 0.8), 10, 16)

  return {
    top: vertical,
    right: horizontal,
    bottom: vertical,
    left: horizontal
  }
}
