# src/ — исходные компоненты

Каталог содержит два независимых Rust-компонента, подключённых как git submodules.

## Состав

| Компонент | Путь | Описание |
|-----------|------|----------|
| [**narsil-mcp**](./narsil-mcp) | `src/narsil-mcp/` | MCP-сервер code intelligence — 90 инструментов, tree-sitter, поиск, анализ |
| [**forgemax**](./forgemax) | `src/forgemax/` | Многосерверный MCP gateway с V8 sandbox |

## Инициализация submodules

```bash
git submodule update --init --recursive
```

## Обновление

```bash
git submodule update --remote --merge
```

## Сборка

```bash
# Из корня проекта — оба компонента
make

# По отдельности
make narsil-mcp
make forgemax
```

Подробнее: [build/README.md](../build/README.md), [deb/README.md](../deb/README.md).
