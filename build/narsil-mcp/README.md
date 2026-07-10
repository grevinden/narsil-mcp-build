# narsil-mcp — сборка

Полная сборка narsil-mcp (Rust + React/Vite frontend) из этого каталога.

## Требования

- **Rust** 1.85+ (stable)
- **Node.js** 22+
- **npm** 10+
- **fakeroot**, **dpkg-deb** — только для сборки `.deb` пакета

## Быстрый старт

```bash
make   # полная сборка (release) + .deb пакет
```

Результат:
- Бинарник: `target/release/narsil-mcp`
- .deb пакет: `../deb/narsil-mcp_<version>_<arch>.deb`

## Цели Makefile

| Команда | Что делает |
|---------|-----------|
| `make` | Release + .deb пакет: frontend → Rust → `target/release/narsil-mcp` → `.deb` |
| `make release` | Только release-сборка (без deb) |
| `make debug` | Debug-сборка: frontend → Rust → `target/debug/narsil-mcp` |
| `make frontend` | Только фронтенд (React/Vite) |
| `make frontend-dev` | Dev-сервер фронтенда (sveltekit, hot-reload) |
| `make deb` | Release + сборка `.deb` пакета |
| `make install-deb` | Release + сборка + установка через `dpkg -i` |
| `make test` | Запуск тестов (Rust) |
| `make clean` | Удаление `frontend/dist` + `target/` |
| `make distclean` | Как `clean`, + удаление `node_modules` + `*.deb` |

## Структура сборки

```
build/narsil-mcp/
├── Makefile       # точки входа сборки
├── README.md
└── target/        # cargo target (отдельный от src, удобно для IDE)

deb/                          # метаданные .deb пакета (в корне проекта)
└── narsil-mcp/
    └── DEBIAN/
        ├── control           # шаблон: @VERSION@, @ARCH@
        ├── postinst          # постустановочный скрипт
        └── postrm            # скрипт удаления

src/narsil-mcp/
├── Cargo.toml
├── frontend/      # React/Vite SPA
│   ├── package.json
│   ├── src/
│   └── dist/      # результат сборки, встраивается в бинарник
└── src/           # Rust исходники
```

## Фичи (feature flags)

Собирается с набором фич `native,graph,frontend,neural`:

| Фича | Описание |
|------|----------|
| `native` | Базовый функционал: LSP, git, watch, HTTP-сервер |
| `graph` | RDF граф знаний с SPARQL |
| `frontend` | Встраивание React UI в бинарник (включает `native`) |
| `neural` | Эмбеддинги (usearch + ndarray) |
| `neural-onnx` | **Не включён** — ONNX runtime для эмбеддингов |
| `wasm` | **Не включён** — WebAssembly сборка |

## .deb пакет

Собирается через `make deb`. Внутри пакета:

```
/usr/bin/narsil-mcp                   — бинарник
/usr/share/doc/narsil-mcp/README.md     — документация
/usr/share/doc/narsil-mcp/LICENSE-MIT   — лицензия (если есть)
/usr/share/doc/narsil-mcp/LICENSE-APACHE
/usr/share/doc/narsil-mcp/CHANGELOG.md
/usr/share/man/man1/narsil-mcp.1        — man-страница
```

Версия подхватывается из `Cargo.toml`, архитектура — из `dpkg --print-architecture`.

```bash
# Только сборка
make deb

# Сборка + установка
make install-deb
```

## Пошагово (без Makefile)

```bash
# 1. Фронтенд
cd src/narsil-mcp/frontend
npm ci && npm run build

# 2. Rust
cd ..
cargo build --release \
    --target-dir ../../build/narsil-mcp/target \
    --no-default-features \
    --features native,graph,frontend,neural

# Бинарник: build/narsil-mcp/target/release/narsil-mcp
```
