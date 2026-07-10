# build/ — сборочная инфраструктура

Сборочные Makefile и target-директории для компонентов монорепозитория.

## Структура

```
build/
├── README.md
├── narsil-mcp/          # Сборка narsil-mcp (бинарник + .deb)
│   ├── Makefile
│   ├── README.md
│   └── target/
└── forgemax/            # Сборка forgemax (бинарник + .deb)
    ├── Makefile
    ├── README.md
    └── target/
```

## Компоненты

| Компонент | Сборка | Результат |
|-----------|--------|-----------|
| `narsil-mcp` | `make -C build/narsil-mcp` | `build/narsil-mcp/target/release/narsil-mcp` |
| `forgemax` | `make -C build/forgemax` | `build/forgemax/target/release/{forgemax,forgemax-worker}` |
