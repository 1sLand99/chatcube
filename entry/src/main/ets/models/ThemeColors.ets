// 主题类型枚举
export enum ColorTheme {
  DEFAULT = 'default',      // 默认蓝色
  YUANBAO = 'yuanbao',      // 元宝护眼
  CLAUDE = 'claude',        // Claude 风格
  CHATGPT = 'chatgpt',      // ChatGPT 风格
  VIOLET = 'violet',        // 紫罗兰
  MINT = 'mint',            // 薄荷绿
  SUNSET = 'sunset',        // 日落橙
  BERRY = 'berry'           // 莓果粉
}

// 主题颜色配置接口
export interface ThemeColorConfig {
  // 主色调
  primary: string
  primaryLight: string
  // 背景色
  background: string
  // 表面色
  surface: string
  // 分隔线
  divider: string
  // 用户气泡
  userBubble: string
  userBubbleText: string
  // AI 气泡
  aiBubble: string
  // 文字颜色
  textPrimary: string
  textSecondary: string
  textTertiary: string
  // Markdown 相关
  markdownTitle: string
  markdownText: string
  markdownLink: string
  markdownLinkBg: string
  markdownCodeBg: string
  markdownCodeText: string
  markdownQuoteBg: string
  markdownTableBg: string
  markdownTableHeaderBg: string
  markdownTableAltBg: string
  markdownTableBorder: string
}

// 主题信息接口
export interface ThemeInfo {
  id: ColorTheme
  nameKey: string           // 字符串资源 key
  descriptionKey: string    // 描述字符串资源 key
  previewColors: string[]   // 预览色块（3个颜色：背景、主色、气泡）
  light: ThemeColorConfig
  dark: ThemeColorConfig
}

// 默认主题（蓝色）
const DEFAULT_THEME: ThemeInfo = {
  id: ColorTheme.DEFAULT,
  nameKey: 'theme_color_default',
  descriptionKey: 'theme_color_default_desc',
  previewColors: ['#F7F9FC', '#EDF4FF', '#0B57D0'],
  light: {
    primary: '#0A59F7',
    primaryLight: '#EDF4FF',
    background: '#F7F9FC',
    surface: '#FFFFFF',
    divider: '#E7EBF0',
    userBubble: '#0B57D0',
    userBubbleText: '#FFFFFF',
    aiBubble: '#FFFFFF',
    textPrimary: '#1C1C1E',
    textSecondary: '#6B7280',
    textTertiary: '#8691A3',
    markdownTitle: '#1C1C1E',
    markdownText: '#333333',
    markdownLink: '#0A59F7',
    markdownLinkBg: '#EDF4FF',
    markdownCodeBg: '#F5F7FA',
    markdownCodeText: '#D63384',
    markdownQuoteBg: '#F5F7FA',
    markdownTableBg: '#FFFFFF',
    markdownTableHeaderBg: '#F5F7FA',
    markdownTableAltBg: '#FBFCFE',
    markdownTableBorder: '#E7EBF0'
  },
  dark: {
    primary: '#0A59F7',
    primaryLight: '#16396B',
    background: '#121212',
    surface: '#1C1C1E',
    divider: '#38383A',
    userBubble: '#0B57D0',
    userBubbleText: '#FFFFFF',
    aiBubble: '#2C2C2E',
    textPrimary: '#F5F5F7',
    textSecondary: '#8E8E93',
    textTertiary: '#636366',
    markdownTitle: '#F5F5F7',
    markdownText: '#E0E0E0',
    markdownLink: '#0A59F7',
    markdownLinkBg: '#16396B',
    markdownCodeBg: '#2C2C2E',
    markdownCodeText: '#FF79C6',
    markdownQuoteBg: '#2C2C2E',
    markdownTableBg: '#1C1C1E',
    markdownTableHeaderBg: '#2C2C2E',
    markdownTableAltBg: '#252528',
    markdownTableBorder: '#38383A'
  }
}

// 元宝风格（护眼暖色调）
const YUANBAO_THEME: ThemeInfo = {
  id: ColorTheme.YUANBAO,
  nameKey: 'theme_color_yuanbao',
  descriptionKey: 'theme_color_yuanbao_desc',
  previewColors: ['#FAF8F5', '#F5EBE0', '#A16B32'],
  light: {
    primary: '#D4A574',
    primaryLight: '#F5EBE0',
    background: '#FAF8F5',
    surface: '#FFFEF9',
    divider: '#E8E4DE',
    userBubble: '#A16B32',
    userBubbleText: '#FFFFFF',
    aiBubble: '#FFFEF9',
    textPrimary: '#3D3530',
    textSecondary: '#8A7F75',
    textTertiary: '#B5ADA5',
    markdownTitle: '#3D3530',
    markdownText: '#4A4540',
    markdownLink: '#C9956C',
    markdownLinkBg: '#F5EBE0',
    markdownCodeBg: '#F5F0EA',
    markdownCodeText: '#B8763C',
    markdownQuoteBg: '#F5F0EA',
    markdownTableBg: '#FFFEF9',
    markdownTableHeaderBg: '#F5F0EA',
    markdownTableAltBg: '#FAF7F2',
    markdownTableBorder: '#E8E4DE'
  },
  dark: {
    primary: '#C9956C',
    primaryLight: '#3D3025',
    background: '#2A2520',
    surface: '#3A3530',
    divider: '#4A4540',
    userBubble: '#A3693C',
    userBubbleText: '#FFFFFF',
    aiBubble: '#3A3530',
    textPrimary: '#F5F0EA',
    textSecondary: '#B5ADA5',
    textTertiary: '#8A7F75',
    markdownTitle: '#F5F0EA',
    markdownText: '#E5DFD8',
    markdownLink: '#D4A574',
    markdownLinkBg: '#3D3025',
    markdownCodeBg: '#3A3530',
    markdownCodeText: '#E8B87A',
    markdownQuoteBg: '#3A3530',
    markdownTableBg: '#3A3530',
    markdownTableHeaderBg: '#4A4540',
    markdownTableAltBg: '#3F3A35',
    markdownTableBorder: '#4A4540'
  }
}

// Claude 风格（深橄榄绿）
const CLAUDE_THEME: ThemeInfo = {
  id: ColorTheme.CLAUDE,
  nameKey: 'theme_color_claude',
  descriptionKey: 'theme_color_claude_desc',
  previewColors: ['#F5F5F0', '#FDEEE8', '#C6522D'],
  light: {
    primary: '#D97757',
    primaryLight: '#FDEEE8',
    background: '#F5F5F0',
    surface: '#FFFFFF',
    divider: '#E5E5E0',
    userBubble: '#C6522D',
    userBubbleText: '#FFFFFF',
    aiBubble: '#FFFFFF',
    textPrimary: '#2D3A2D',
    textSecondary: '#6B7A6B',
    textTertiary: '#9AA59A',
    markdownTitle: '#2D3A2D',
    markdownText: '#3A4A3A',
    markdownLink: '#D97757',
    markdownLinkBg: '#FDEEE8',
    markdownCodeBg: '#F0F0EB',
    markdownCodeText: '#C45A3B',
    markdownQuoteBg: '#F0F0EB',
    markdownTableBg: '#FFFFFF',
    markdownTableHeaderBg: '#F0F0EB',
    markdownTableAltBg: '#F8F8F5',
    markdownTableBorder: '#E5E5E0'
  },
  dark: {
    primary: '#D97757',
    primaryLight: '#3D2A25',
    background: '#2D3A2D',
    surface: '#3A4A3A',
    divider: '#4A5A4A',
    userBubble: '#C6522D',
    userBubbleText: '#FFFFFF',
    aiBubble: '#3A4A3A',
    textPrimary: '#F0F5F0',
    textSecondary: '#A5B5A5',
    textTertiary: '#7A8A7A',
    markdownTitle: '#F0F5F0',
    markdownText: '#E0E8E0',
    markdownLink: '#E8886A',
    markdownLinkBg: '#3D2A25',
    markdownCodeBg: '#3A4A3A',
    markdownCodeText: '#F5A080',
    markdownQuoteBg: '#3A4A3A',
    markdownTableBg: '#3A4A3A',
    markdownTableHeaderBg: '#4A5A4A',
    markdownTableAltBg: '#3F4F3F',
    markdownTableBorder: '#4A5A4A'
  }
}

// ChatGPT 风格（冷色深空）
const CHATGPT_THEME: ThemeInfo = {
  id: ColorTheme.CHATGPT,
  nameKey: 'theme_color_chatgpt',
  descriptionKey: 'theme_color_chatgpt_desc',
  previewColors: ['#F8FAFC', '#EAF2FF', '#1F2937'],
  light: {
    primary: '#3B82F6',
    primaryLight: '#EAF2FF',
    background: '#F8FAFC',
    surface: '#FFFFFF',
    divider: '#E5E7EB',
    userBubble: '#1F2937',
    userBubbleText: '#F9FAFB',
    aiBubble: '#FFFFFF',
    textPrimary: '#111827',
    textSecondary: '#667085',
    textTertiary: '#98A2B3',
    markdownTitle: '#111827',
    markdownText: '#334155',
    markdownLink: '#2563EB',
    markdownLinkBg: '#EAF2FF',
    markdownCodeBg: '#F3F6FB',
    markdownCodeText: '#334155',
    markdownQuoteBg: '#F3F6FB',
    markdownTableBg: '#FFFFFF',
    markdownTableHeaderBg: '#F3F6FB',
    markdownTableAltBg: '#FBFCFE',
    markdownTableBorder: '#E5E7EB'
  },
  dark: {
    primary: '#3B82F6',
    primaryLight: '#1A2740',
    background: '#0F141B',
    surface: '#151B23',
    divider: '#232B36',
    userBubble: '#1F2937',
    userBubbleText: '#F9FAFB',
    aiBubble: '#151B23',
    textPrimary: '#E6EDF3',
    textSecondary: '#9AA4AF',
    textTertiary: '#7B8794',
    markdownTitle: '#E6EDF3',
    markdownText: '#D3DAE3',
    markdownLink: '#93C5FD',
    markdownLinkBg: '#1A2740',
    markdownCodeBg: '#0D1117',
    markdownCodeText: '#C9D1D9',
    markdownQuoteBg: '#141A22',
    markdownTableBg: '#151B23',
    markdownTableHeaderBg: '#1B2230',
    markdownTableAltBg: '#19202B',
    markdownTableBorder: '#2B3440'
  }
}

// 紫罗兰主题
const VIOLET_THEME: ThemeInfo = {
  id: ColorTheme.VIOLET,
  nameKey: 'theme_color_violet',
  descriptionKey: 'theme_color_violet_desc',
  previewColors: ['#FAF5FF', '#EDE9FE', '#8655F6'],
  light: {
    primary: '#8B5CF6',
    primaryLight: '#EDE9FE',
    background: '#FAF5FF',
    surface: '#FFFFFF',
    divider: '#E9E3F5',
    userBubble: '#8655F6',
    userBubbleText: '#FFFFFF',
    aiBubble: '#FFFFFF',
    textPrimary: '#3B2E5A',
    textSecondary: '#7C6A9A',
    textTertiary: '#A89BC0',
    markdownTitle: '#3B2E5A',
    markdownText: '#4A3D6A',
    markdownLink: '#8B5CF6',
    markdownLinkBg: '#EDE9FE',
    markdownCodeBg: '#F5F0FF',
    markdownCodeText: '#7C3AED',
    markdownQuoteBg: '#F5F0FF',
    markdownTableBg: '#FFFFFF',
    markdownTableHeaderBg: '#F5F0FF',
    markdownTableAltBg: '#FAF7FF',
    markdownTableBorder: '#E9E3F5'
  },
  dark: {
    primary: '#A78BFA',
    primaryLight: '#2E2050',
    background: '#1E1B2E',
    surface: '#2D2640',
    divider: '#3D3555',
    userBubble: '#8057F8',
    userBubbleText: '#FFFFFF',
    aiBubble: '#2D2640',
    textPrimary: '#F3E8FF',
    textSecondary: '#A78BFA',
    textTertiary: '#7C6A9A',
    markdownTitle: '#F3E8FF',
    markdownText: '#E8DEFF',
    markdownLink: '#A78BFA',
    markdownLinkBg: '#2E2050',
    markdownCodeBg: '#2D2640',
    markdownCodeText: '#C4B5FD',
    markdownQuoteBg: '#2D2640',
    markdownTableBg: '#2D2640',
    markdownTableHeaderBg: '#3D3555',
    markdownTableAltBg: '#352D4A',
    markdownTableBorder: '#3D3555'
  }
}

// 薄荷绿主题
const MINT_THEME: ThemeInfo = {
  id: ColorTheme.MINT,
  nameKey: 'theme_color_mint',
  descriptionKey: 'theme_color_mint_desc',
  previewColors: ['#F0FDF4', '#D1FAE5', '#0C875E'],
  light: {
    primary: '#10B981',
    primaryLight: '#D1FAE5',
    background: '#F0FDF4',
    surface: '#FFFFFF',
    divider: '#D1E7DD',
    userBubble: '#0C875E',
    userBubbleText: '#FFFFFF',
    aiBubble: '#FFFFFF',
    textPrimary: '#14532D',
    textSecondary: '#2F7A5D',
    textTertiary: '#5A9C79',
    markdownTitle: '#14532D',
    markdownText: '#166534',
    markdownLink: '#10B981',
    markdownLinkBg: '#D1FAE5',
    markdownCodeBg: '#ECFDF5',
    markdownCodeText: '#059669',
    markdownQuoteBg: '#ECFDF5',
    markdownTableBg: '#FFFFFF',
    markdownTableHeaderBg: '#ECFDF5',
    markdownTableAltBg: '#F5FDF8',
    markdownTableBorder: '#D1E7DD'
  },
  dark: {
    primary: '#34D399',
    primaryLight: '#0D2818',
    background: '#0D1F17',
    surface: '#1A2F23',
    divider: '#2A4035',
    userBubble: '#1D8660',
    userBubbleText: '#FFFFFF',
    aiBubble: '#1A2F23',
    textPrimary: '#ECFDF5',
    textSecondary: '#6EE7B7',
    textTertiary: '#4ADE80',
    markdownTitle: '#ECFDF5',
    markdownText: '#D1FAE5',
    markdownLink: '#34D399',
    markdownLinkBg: '#0D2818',
    markdownCodeBg: '#1A2F23',
    markdownCodeText: '#6EE7B7',
    markdownQuoteBg: '#1A2F23',
    markdownTableBg: '#1A2F23',
    markdownTableHeaderBg: '#2A4035',
    markdownTableAltBg: '#22372A',
    markdownTableBorder: '#2A4035'
  }
}

// 日落橙主题
const SUNSET_THEME: ThemeInfo = {
  id: ColorTheme.SUNSET,
  nameKey: 'theme_color_sunset',
  descriptionKey: 'theme_color_sunset_desc',
  previewColors: ['#FFFBF5', '#FFEDD5', '#C55405'],
  light: {
    primary: '#F97316',
    primaryLight: '#FFEDD5',
    background: '#FFFBF5',
    surface: '#FFFFFF',
    divider: '#FED7AA',
    userBubble: '#C55405',
    userBubbleText: '#FFFFFF',
    aiBubble: '#FFFFFF',
    textPrimary: '#431407',
    textSecondary: '#9A3412',
    textTertiary: '#FDBA74',
    markdownTitle: '#431407',
    markdownText: '#7C2D12',
    markdownLink: '#F97316',
    markdownLinkBg: '#FFEDD5',
    markdownCodeBg: '#FFF7ED',
    markdownCodeText: '#EA580C',
    markdownQuoteBg: '#FFF7ED',
    markdownTableBg: '#FFFFFF',
    markdownTableHeaderBg: '#FFF7ED',
    markdownTableAltBg: '#FFFAF5',
    markdownTableBorder: '#FED7AA'
  },
  dark: {
    primary: '#FB923C',
    primaryLight: '#2D1A10',
    background: '#1C1410',
    surface: '#2A1F18',
    divider: '#3D3025',
    userBubble: '#BF5804',
    userBubbleText: '#FFFFFF',
    aiBubble: '#2A1F18',
    textPrimary: '#FFF7ED',
    textSecondary: '#FDBA74',
    textTertiary: '#9A3412',
    markdownTitle: '#FFF7ED',
    markdownText: '#FFEDD5',
    markdownLink: '#FB923C',
    markdownLinkBg: '#2D1A10',
    markdownCodeBg: '#2A1F18',
    markdownCodeText: '#FDBA74',
    markdownQuoteBg: '#2A1F18',
    markdownTableBg: '#2A1F18',
    markdownTableHeaderBg: '#3D3025',
    markdownTableAltBg: '#35281D',
    markdownTableBorder: '#3D3025'
  }
}

// 莓果粉主题
const BERRY_THEME: ThemeInfo = {
  id: ColorTheme.BERRY,
  nameKey: 'theme_color_berry',
  descriptionKey: 'theme_color_berry_desc',
  previewColors: ['#FFF1F5', '#FCE7F3', '#E2187C'],
  light: {
    primary: '#EC4899',
    primaryLight: '#FCE7F3',
    background: '#FFF1F5',
    surface: '#FFFFFF',
    divider: '#F5C2D8',
    userBubble: '#E2187C',
    userBubbleText: '#FFFFFF',
    aiBubble: '#FFFFFF',
    textPrimary: '#4A102A',
    textSecondary: '#9D4C71',
    textTertiary: '#D989AE',
    markdownTitle: '#4A102A',
    markdownText: '#6B2140',
    markdownLink: '#DB2777',
    markdownLinkBg: '#FCE7F3',
    markdownCodeBg: '#FFF5F8',
    markdownCodeText: '#BE185D',
    markdownQuoteBg: '#FFF5F8',
    markdownTableBg: '#FFFFFF',
    markdownTableHeaderBg: '#FFF5F8',
    markdownTableAltBg: '#FFF8FA',
    markdownTableBorder: '#F5C2D8'
  },
  dark: {
    primary: '#F472B6',
    primaryLight: '#3C1630',
    background: '#1F0E18',
    surface: '#2D1623',
    divider: '#4A2638',
    userBubble: '#E3127F',
    userBubbleText: '#FFFFFF',
    aiBubble: '#2D1623',
    textPrimary: '#FFE4F1',
    textSecondary: '#F9A8D4',
    textTertiary: '#B86B92',
    markdownTitle: '#FFE4F1',
    markdownText: '#FFD3E7',
    markdownLink: '#F472B6',
    markdownLinkBg: '#3C1630',
    markdownCodeBg: '#2D1623',
    markdownCodeText: '#F9A8D4',
    markdownQuoteBg: '#2D1623',
    markdownTableBg: '#2D1623',
    markdownTableHeaderBg: '#4A2638',
    markdownTableAltBg: '#351B29',
    markdownTableBorder: '#4A2638'
  }
}

// 所有主题列表
export const ALL_THEMES: ThemeInfo[] = [
  DEFAULT_THEME,
  YUANBAO_THEME,
  CLAUDE_THEME,
  CHATGPT_THEME,
  VIOLET_THEME,
  MINT_THEME,
  SUNSET_THEME,
  BERRY_THEME
]

// 根据主题 ID 获取主题信息
export function getThemeById(themeId: ColorTheme): ThemeInfo {
  for (let i = 0; i < ALL_THEMES.length; i++) {
    if (ALL_THEMES[i].id === themeId) {
      return ALL_THEMES[i]
    }
  }
  return DEFAULT_THEME
}

// 根据主题 ID 和深浅模式获取颜色配置
export function getThemeColors(themeId: ColorTheme, isDarkMode: boolean): ThemeColorConfig {
  const theme = getThemeById(themeId)
  return isDarkMode ? theme.dark : theme.light
}
