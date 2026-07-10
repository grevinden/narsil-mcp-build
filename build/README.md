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
└── forgemax/            # TODO: сборка forgemax
```

## Компоненты

| Компонент | Сборка | Результат |
|-----------|--------|-----------|
| `narsil-mcp` | `make -C build/narsil-mcp` | `build/narsil-mcp/target/release/narsil-mcp` |
| `forgemax` | — | TODO |
