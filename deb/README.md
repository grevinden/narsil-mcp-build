# deb/ — Debian-пакеты

Сборка .deb пакетов компонентов монорепозитория narsil-mcp.

## Структура

```
deb/
├── README.md
├── narsil-mcp/
│   ├── DEBIAN/
│   │   ├── control      # метаданные пакета
│   │   ├── postinst     # постустановочный скрипт
│   │   └── postrm       # скрипт удаления
│   └── README.md
└── forgemax/
    ├── DEBIAN/
    │   ├── control      # метаданные пакета
    │   ├── postinst     # постустановочный скрипт
    │   └── postrm       # скрипт удаления
    └── README.md
```

## Сборка

```bash
# Сборка всех .deb пакетов из корня проекта
make deb

# Или по отдельности
make -C build/narsil-mcp deb
make -C build/forgemax deb

# Результат в этом каталоге:
ls -lh *.deb
```

## Требования

- `fakeroot`
- `dpkg-deb`

## Установка

```bash
# Установить все .deb пакеты из этого каталога
sudo dpkg -i *.deb
```
