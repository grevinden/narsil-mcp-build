# forgemax — сборка

Полная сборка forgemax (Rust workspace: forge-cli, forge-sandbox, forge-server и др.).

## Требования

- **Rust** 1.91.1+ (stable)
- **cmake** — для сборки V8/deno_core
- **fakeroot**, **dpkg-deb** — только для сборки `.deb` пакета

## Быстрый старт

```bash
make   # полная сборка (release + deb)
```

Результат:
- Бинарники: `target/release/forgemax`, `target/release/forgemax-worker`
- .deb пакет: `../../deb/forgemax_<version>_<arch>.deb`

## Цели Makefile

| Команда | Что делает |
|---------|-----------|
| `make` | Release-сборка + .deb пакет |
| `make debug` | Debug-сборка |
| `make test` | Запуск тестов |
| `make deb` | Release + сборка `.deb` пакета |
| `make install-deb` | Release + сборка + установка через `dpkg -i` |
| `make clean` | Очистка cargo target |
| `make distclean` | Как clean + удаление `.deb` |

## Состав сборки

```
forgemax                 CLI entry point (stdio MCP transport)
forgemax-worker          Isolated V8 sandbox worker process (child process)
```

Оба бинарника собираются из workspace crates.

## .deb пакет

Собирается через `make deb`. Внутри пакета:

```
/usr/bin/forgemax                        — CLI binary
/usr/bin/forgemax-worker                — V8 sandbox worker
/etc/forgemax/forge.toml.example         — пример конфига
/etc/forgemax/forge.toml.example.production
/usr/share/doc/forgemax/README.md        — документация
/usr/share/doc/forgemax/ARCHITECTURE.md
/usr/share/doc/forgemax/CHANGELOG.md
/usr/share/doc/forgemax/LICENSE
/usr/share/doc/forgemax/SECURITY.md
/usr/share/doc/forgemax/UPGRADE.md
/usr/share/man/man1/forgemax.1           — man-страница
```

```bash
# Только сборка
make deb

# Сборка + установка
make install-deb
```

## Пошагово (без Makefile)

```bash
cd src/forgemax
cargo build --release --target-dir ../../build/forgemax/target

# Бинарники: build/forgemax/target/release/{forgemax,forgemax-worker}
```
