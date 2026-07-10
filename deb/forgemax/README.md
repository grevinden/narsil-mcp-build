# forgemax — .deb пакет

Метаданные для сборки `.deb` пакета `forgemax`.

## Состав пакета

```
/usr/bin/forgemax                        — CLI binary
/usr/lib/forgemax/forgemax-worker        — V8 sandbox worker (вспомогательный процесс)
/etc/forgemax/forge.toml.example         — пример конфигурации
/etc/forgemax/forge.toml.example.production
/usr/share/doc/forgemax/README.md        — документация
/usr/share/doc/forgemax/ARCHITECTURE.md
/usr/share/doc/forgemax/CHANGELOG.md
/usr/share/doc/forgemax/LICENSE
/usr/share/doc/forgemax/SECURITY.md
/usr/share/doc/forgemax/UPGRADE.md
/usr/share/man/man1/forgemax.1           — man-страница
```

## Файлы метаданных

| Файл | Назначение |
|------|-----------|
| `DEBIAN/control` | Метаданные пакета (`@VERSION@`, `@ARCH@` — подставляются из Makefile) |
| `DEBIAN/postinst` | Выполняется после установки (обновляет `mandb`) |
| `DEBIAN/postrm` | Выполняется при удалении (обновляет `mandb`) |

## Параметры сборки

- **Версия**: из `src/forgemax/Cargo.toml`
- **Архитектура**: из `dpkg --print-architecture`
- **Результат**: `deb/forgemax_<version>_<arch>.deb`

## Сборка

```bash
# Из корня проекта
make -C build/forgemax deb

# Или напрямую
cd build/forgemax && make deb
```
