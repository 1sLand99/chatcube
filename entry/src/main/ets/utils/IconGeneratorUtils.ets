/**
 * 图标生成工具类
 * 用于生成供应商的文字图标和背景色
 */

// 文字图标配置接口
export interface TextIconConfig {
  text: string
  bgColor: string
}

// 透明背景色常量
export const TRANSPARENT_BG_COLOR: string = 'transparent'

// 30 种中饱和背景色（与白字对比度 ≥ 3:1，符合鸿蒙 UX 无障碍规范）
const SOFT_COLORS: string[] = [
  '#E53935', // 红
  '#D81B60', // 玫红
  '#8E24AA', // 紫
  '#5E35B1', // 深紫
  '#3949AB', // 靛蓝
  '#1E88E5', // 蓝
  '#0277BD', // 深天蓝
  '#00838F', // 深青
  '#00897B', // 水鸭绿
  '#2E7D32', // 绿
  '#558B2F', // 草绿
  '#827717', // 橄榄
  '#E65100', // 深橙
  '#BF360C', // 赤褐
  '#4E342E', // 棕
  '#546E7A', // 蓝灰
  '#6D4C41', // 咖啡
  '#7B1FA2', // 亮紫
  '#512DA8', // 深紫罗兰
  '#303F9F', // 深靛蓝
  '#1565C0', // 皇家蓝
  '#00695C', // 深绿松石
  '#388E3C', // 常青绿
  '#9C27B0', // 兰花紫
  '#C62828', // 深红
  '#AD1457', // 深玫红
  '#6A1B9A', // 暗紫
  '#283593', // 午夜蓝
  '#0D47A1', // 海军蓝
  '#4527A0'  // 皇家紫
]

/**
 * 生成随机柔和背景色
 */
export function generateSoftColor(): string {
  const randomIndex = Math.floor(Math.random() * SOFT_COLORS.length)
  return SOFT_COLORS[randomIndex]
}

/**
 * 基于字符串生成确定性颜色（相同输入产生相同输出）
 * 使用简单的哈希算法
 * @param text 输入文本
 * @returns 颜色值
 */
export function generateSoftColorFromString(text: string): string {
  if (text === '') {
    return generateSoftColor()
  }

  // 计算字符串的哈希值
  let hash = 0
  for (let i = 0; i < text.length; i++) {
    const char = text.charCodeAt(i)
    hash = ((hash << 5) - hash) + char
    hash = hash & hash // 转换为 32 位整数
  }

  // 使用哈希值选择颜色（确保为正数）
  const index = Math.abs(hash) % SOFT_COLORS.length
  return SOFT_COLORS[index]
}

/**
 * 判断字符是否为英文字母
 */
function isEnglishLetter(char: string): boolean {
  const code = char.charCodeAt(0)
  return (code >= 65 && code <= 90) || (code >= 97 && code <= 122)
}

/**
 * 提取文本的首字母
 * 规则:
 * 1. 英文: 取每个单词的首字母大写,最多 2 个
 * 2. 中文/其他: 直接取第一个字符
 * 3. Emoji/短文本: 直接取前 3 个字符
 * 4. 空文本: 返回 "AI"
 */
export function extractInitials(text: string): string {
  if (text === '' || text.length === 0) {
    return 'AI'
  }

  // 移除空格和特殊字符,保留字母和中文
  const cleanText = text.trim()
  if (cleanText === '') {
    return 'AI'
  }

  // 检查是否包含 Emoji（Unicode 范围）
  const hasEmoji = /[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F700}-\u{1F77F}]|[\u{1F780}-\u{1F7FF}]|[\u{1F800}-\u{1F8FF}]|[\u{1F900}-\u{1F9FF}]|[\u{1FA00}-\u{1FA6F}]|[\u{1FA70}-\u{1FAFF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]/u.test(cleanText)

  // 如果包含 Emoji 或文本很短，直接取前 3 个字符
  if (hasEmoji || cleanText.length <= 3) {
    return cleanText.substring(0, 3)
  }

  const initials: string[] = []

  // 尝试提取英文首字母
  const words = cleanText.split(/[\s\-_]+/)
  for (let i = 0; i < words.length; i++) {
    const word = words[i]
    if (word.length === 0) {
      continue
    }
    const firstChar = word.charAt(0)
    if (isEnglishLetter(firstChar)) {
      initials.push(firstChar.toUpperCase())
      if (initials.length >= 2) {
        break
      }
    }
  }

  // 如果提取到英文首字母,直接返回
  if (initials.length > 0) {
    return initials.join('')
  }

  // 否则直接取第一个字符
  return cleanText.charAt(0).toUpperCase()
}

/**
 * 生成默认文字图标配置
 * @param providerName 供应商名称
 * @returns 文字图标配置
 */
export function generateDefaultTextIcon(providerName: string): TextIconConfig {
  const text = extractInitials(providerName)
  // 使用基于供应商名称的确定性颜色，而不是随机颜色
  const bgColor = generateSoftColorFromString(providerName)
  return {
    text: text,
    bgColor: bgColor
  }
}

/**
 * 获取所有预设柔和色彩
 */
export function getAllSoftColors(): string[] {
  return SOFT_COLORS.slice()
}
