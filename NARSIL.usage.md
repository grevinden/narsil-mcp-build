# narsil-mcp — использование

MCP-сервер code intelligence — парсинг, поиск, анализ кода (90+ инструментов).

## Быстрый старт

```bash
# Запуск с проектом
narsil-mcp --repos /path/to/project

# С расширенными возможностями
narsil-mcp --repos /path/to/project --preset full --git --lsp --call-graph
```

## Режимы запуска

### MCP сервер (stdio)

```bash
narsil-mcp --repos ./my-project
```

Подключается к LLM-клиенту через MCP протокол (JSON-RPC over stdio).

### HTTP сервер + фронтенд

```bash
narsil-mcp serve --repos ./my-project
```

Запускает веб-интерфейс для визуализации кодовой базы.

### WebAssembly (браузер)

```bash
narsil-mcp --wasm
```

## Ключевые возможности

| Категория | Инструменты | Описание |
|-----------|-------------|----------|
| **Репозиторий** | 8 | Структура проекта, навигация, реиндексация |
| **Символы** | 7 | Поиск символов, референсы, fuzzy search |
| **Поиск** | 12 | BM25, TF-IDF, гибридный, нейронный, чанки |
| **Call Graph** | 6 | Граф вызовов, callers/callees, hotspots |
| **Security** | 9 | Taint, OWASP, CWE, сканирование, фиксы |
| **Supply Chain** | 4 | SBOM (CycloneDX/SPDX), OSV, лицензии |
| **Git** | 9 | Blame, история, коммиты, диффы |
| **Remote** | 3 | GitHub API: clone, list, fetch |
| **Graph** | 14 | RDF, SPARQL, CCG (Code Context Graph) |

## Пресеты

| Preset | Tool count | Editor | Description |
|--------|------------|--------|-------------|
| `minimal` | 20-30 | Zed, Vim | Fast, lightweight — essential tools only |
| `balanced` | ~40 | VS Code, IntelliJ | Good defaults — git + LSP + security basics |
| `full` | 70+ | Claude Desktop | All features — comprehensive analysis |
| `security-focused` | ~30 | Security audits | Taint, OWASP/CWE, supply chain only |

```bash
# Minimal - Fast, lightweight (Zed, quick edits)
narsil-mcp --repos . --preset minimal

# Balanced - Good defaults (VS Code, IntelliJ)
narsil-mcp --repos . --preset balanced --git --call-graph

# Full - All features (Claude Desktop, comprehensive analysis)
narsil-mcp --repos . --preset full --git --call-graph

# Security-focused - Security and supply chain tools
narsil-mcp --repos . --preset security-focused
```

## Конфигурация

```toml
# .narsil-mcp.toml
version = 1
preset = "full"

[tools.categories]
Security.enabled = true
SupplyChain.enabled = true

[performance]
max_tool_count = 20
```

## Примеры

```bash
# Поиск символов
narsil-mcp --repos . --tool find_symbols --args '{"pattern": "handle_*"}'

# Анализ безопасности
narsil-mcp --repos . --tool scan_security

# Граф вызовов
narsil-mcp --repos . --tool get_call_graph --args '{"file": "src/main.rs"}'
```

## Конфигурация MCP клиента

### Claude Desktop

```json
{
  "mcpServers": {
    "narsil-mcp": {
      "command": "narsil-mcp",
      "args": ["--repos", "/path/to/project", "--preset", "full"]
    }
  }
}
```

### Cursor / VS Code

```json
{
  "mcpServers": {
    "narsil-mcp": {
      "command": "narsil-mcp",
      "args": ["--repos", "."]
    }
  }
}
```

## Подробнее

- [README.md](./README.md) — полная документация проекта
- [src/narsil-mcp/README.md](./src/narsil-mcp/README.md) — документация компонента
