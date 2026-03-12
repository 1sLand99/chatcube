import { ToolDefinition, ToolConfig, ToolParameters, ToolFunction, ToolParameterProperty } from '../models/ChatModels'
import { ToolExecutor, RegisteredTool, getToolRegistry } from '../services/ToolRegistry'
import { getWebSearchService, SearchResult } from '../services/WebSearchService'

// web_search 工具参数接口
interface WebSearchArgs {
  query: string
}

// 搜索结果项接口（用于格式化输出）
class SearchResultItem {
  index: number = 0
  id: string = ''
  title: string = ''
  url: string = ''
  snippet: string = ''

  constructor(index: number, id: string, title: string, url: string, snippet: string) {
    this.index = index
    this.id = id
    this.title = title
    this.url = url
    this.snippet = snippet
  }
}


// 搜索结果输出接口
class SearchResultOutput {
  query: string = ''
  searchEngine: string = ''
  results: SearchResultItem[] = []
  summary: string = ''

  constructor(query: string, searchEngine: string, results: SearchResultItem[], summary: string) {
    this.query = query
    this.searchEngine = searchEngine
    this.results = results
    this.summary = summary
  }
}

// 错误输出接口
class ErrorOutput {
  error: string = ''

  constructor(error: string) {
    this.error = error
  }
}

// web_search 执行器
class WebSearchExecutor implements ToolExecutor {
  async execute(args: string): Promise<string> {
    try {
      const params = JSON.parse(args) as WebSearchArgs
      if (params.query === undefined || params.query === '') {
        return JSON.stringify(new ErrorOutput('搜索关键词不能为空'))
      }

      console.info('WebSearchExecutor', `Executing web search: ${params.query}`)
      const searchResult = await getWebSearchService().search(params.query)
      return this.formatResult(searchResult)
    } catch (error) {
      console.error('WebSearchExecutor', `Search error: ${JSON.stringify(error)}`)
      return JSON.stringify(new ErrorOutput(`搜索失败: ${JSON.stringify(error)}`))
    }
  }

  private formatResult(result: SearchResult): string {
    if (!result.success) {
      return JSON.stringify(new ErrorOutput(result.errorMessage))
    }

    // 返回结构化的搜索结果（包含 index 和 id）
    const formattedResults: SearchResultItem[] = []
    for (let i = 0; i < result.references.length; i++) {
      const ref = result.references[i]
      formattedResults.push(new SearchResultItem(
        i + 1,  // index 从 1 开始
        ref.id,
        ref.title,
        ref.url,
        ref.snippet
      ))
    }

    const output = new SearchResultOutput(
      result.query,
      result.searchEngine,
      formattedResults,
      result.contentForAI
    )
    return JSON.stringify(output)
  }
}

// 创建 web_search 工具定义
function createWebSearchToolDefinition(): ToolDefinition {
  const parameters = new ToolParameters()
  parameters.addProperty('query', new ToolParameterProperty(
    'string',
    '搜索关键词（尽量简洁，避免“查下/帮我/请”等口语前缀），用于在互联网上搜索相关信息'
  ))
  parameters.addRequired('query')

  const func = new ToolFunction(
    'web_search',
    '搜索互联网获取最新信息。当用户询问实时信息、新闻、天气、股票、最新事件等需要联网查询的内容时使用此工具。调用时请优先使用“可检索的关键词短语”，不要把口语化指令当作关键词。',
    parameters
  )

  return new ToolDefinition(func)
}

// 创建 web_search 工具配置
function createWebSearchToolConfig(): ToolConfig {
  return new ToolConfig(
    'web_search',
    '联网搜索',
    '搜索互联网获取最新信息',
    null,
    false,
    false
  )
}

// 注册所有内置工具
export function registerBuiltinTools(): void {
  const registry = getToolRegistry()
  let registeredNow = 0

  if (!registry.isToolRegistered('web_search')) {
    const webSearchTool = new RegisteredTool(
      'web_search',
      createWebSearchToolConfig(),
      createWebSearchToolDefinition(),
      new WebSearchExecutor()
    )
    registry.registerTool(webSearchTool)
    registeredNow += 1
  }

  console.info(
    'BuiltinTools',
    `Builtin tools ready: total=${registry.getToolCount()}, newlyRegistered=${registeredNow}`
  )
}

// 获取所有内置工具 ID
export function getBuiltinToolIds(): string[] {
  return ['web_search']
}
