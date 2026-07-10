# narsil-mcp — .deb пакет

Метаданные для сборки `.deb` пакета `narsil-mcp`.

## Состав пакета

```
/usr/bin/narsil-mcp                   — бинарник
/usr/share/doc/narsil-mcp/README.md     — документация
/usr/share/doc/narsil-mcp/LICENSE-MIT   — лицензия MIT (если есть)
/usr/share/doc/narsil-mcp/LICENSE-APACHE — лицензия Apache 2.0
/usr/share/doc/narsil-mcp/CHANGELOG.md  — история изменений
/usr/share/man/man1/narsil-mcp.1        — man-страница
```

## Файлы метаданных

| Файл | Назначение |
|------|-----------|
| `DEBIAN/control` | Метаданные пакета (`@VERSION@`, `@ARCH@` — подставляются из Makefile) |
| `DEBIAN/postinst` | Выполняется после установки (обновляет `mandb`) |
| `DEBIAN/postrm` | Выполняется при удалении (обновляет `mandb`) |

## Параметры сборки

- **Версия**: из `src/narsil-mcp/Cargo.toml`
- **Архитектура**: из `dpkg --print-architecture`
- **Результат**: `deb/narsil-mcp_<version>_<arch>.deb`

## Сборка

```bash
# Из корня проекта
make deb
make -C build/narsil-mcp deb

# Или напрямую
cd build/narsil-mcp && make deb
```
