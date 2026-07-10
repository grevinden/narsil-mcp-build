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
└── forge.max/            # TODO
```

## Сборка

```bash
# Сборка .deb пакета narsil-mcp
make -C build/narsil-mcp deb

# Результат в этом каталоге:
ls -lh narsil-mcp_*.deb
```

## Требования

- `fakeroot`
- `dpkg-deb`

## Установка

```bash
sudo dpkg -i narsil-mcp_*.deb
```
