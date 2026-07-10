# forgemax — использование

Code Mode MCP Gateway — заменяет N серверов × M инструментов на 2 инструмента (~1 000 токенов).

## Быстрый старт

```bash
# Сгенерировать конфиг
forgemax init

# Проверить конфигурацию
forgemax doctor

# Запустить MCP сервер
RUST_LOG=info forgemax
```

## CLI команды

| Команда | Описание |
|---------|----------|
| `forgemax` | Запуск MCP gateway (stdio) |
| `forgemax serve` | Явный запуск сервера |
| `forgemax doctor` | Диагностика конфигурации |
| `forgemax manifest` | Просмотр манифеста возможностей |
| `forgemax run <file>` | Выполнить JS-файл против серверов |
| `forgemax init` | Сгенерировать starter config |

## Конфигурация

```toml
# forge.toml
[servers.narsil]
command = "narsil-mcp"
args = ["--repos", "./my-project", "--preset", "full"]
transport = "stdio"
timeout_secs = 30
circuit_breaker = true

[sandbox]
timeout_secs = 60
max_heap_mb = 256
max_concurrent = 4
```

## Server Groups (изоляция)

```toml
[groups.internal]
servers = ["vault", "database"]
isolation = "strict"  # Не могут передавать данные наружу

[groups.external]
servers = ["slack", "github"]
isolation = "strict"

[groups.analysis]
servers = ["narsil"]
isolation = "open"    # Могут общаться с любыми
```

## Sandbox API

LLM пишет JavaScript, вызывая инструменты через proxy-объекты:

```javascript
async () => {
  // Поиск символов в коде
  const symbols = await narsil.symbols.find({ pattern: "handle_*" });

  // Чтение ресурса
  const content = await forge.readResource("narsil", "file:///src/main.rs");

  // Сохранение в stash
  await forge.stash.put("results", symbols);

  // Параллельные вызовы
  const [issues, errors] = await forge.parallel([
    () => github.issues.list({ repo: "my-app" }),
    () => sentry.errors.list({ project: "my-app" }),
  ]);
}
```

## Примеры MCP серверов

| Сервер | Транспорт | Аутентификация |
|--------|-----------|---------------|
| narsil-mcp | stdio | Нет |
| GitHub | stdio (Docker) | Personal access token |
| Sentry | stdio (npx) | Auth token |
| Supabase | stdio (npx) | Access token |
| Stripe | stdio (npx) | Secret key |

## Диагностика

```bash
# Проверка конфигурации
forgemax doctor

# Просмотр манифеста
forgemax manifest

# Проверка worker
FORGE_WORKER_BIN=/path/to/forgemax-worker forgemax doctor
```

## Подробнее

- [README.md](./README.md) — полная документация проекта
- [src/forgemax/README.md](./src/forgemax/README.md) — документация компонента
- [src/forgemax/ARCHITECTURE.md](./src/forgemax/ARCHITECTURE.md) — архитектура безопасности
