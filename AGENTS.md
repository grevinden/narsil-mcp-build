- создавать или поддерживай актуальность документации:
  - README.md
  - FORGEMAX.usage.md
  - NARSIL.usage.md
  - build/README.md
  - build/narsil-mcp/README.md
  - build/forgemax/README.md
  - deb/README.md
  - deb/narsil-mcp/README.md
  - deb/forgemax/README.md
  - src/README.md
- используй схемы mermaid
- данные в git submodules изменять нельзя

## Инструменты narsil mcp — ПРИОРИТЕТ №1

Всегда используй инструменты narsil mcp как **первичный источник** анализа проекта.
Только если инструменты не дают ответа — переходи к ручному чтению кода.

### Порядок действий:

1. **Структура:** `get_project_structure`, `list_directory`, `find_path`
2. **Безопасность:** `scan_security`, `check_owasp_top10`, `check_cwe_top25`, `get_security_summary`
3. **Зависимости:** `check_dependencies`, `check_licenses`, `find_upgrade_path`
4. **Качество кода:** `find_circular_imports`, `find_dead_code`, `find_dead_stores`, `check_type_errors`
5. **Инъекции:** `find_injection_vulnerabilities`, `get_taint_sources`, `trace_taint`
6. **Структура кода:** `get_chunks`, `get_dependencies`, `get_import_graph`, `get_code_graph`
7. **Символы:** `find_symbols`, `find_references`, `find_similar_code`, `workspace_symbol_search`
8. **Контроль потока:** `get_control_flow`, `get_data_flow`, `get_reaching_definitions`
9. **SBOM:** `generate_sbom`

### Когда использовать narsil mcp:

- Анализ безопасности → `scan_security` + `check_owasp_top10` + `check_cwe_top25`
- Поиск багов → `find_dead_code` + `find_uninitialized` + `find_circular_imports`
- Поиск дублей → `find_similar_code` + `find_similar_to_symbol`
- Поиск usage → `find_symbol_usages` + `find_references`
- Зависимости → `check_dependencies` + `check_licenses` + `generate_sbom`
- Типы → `check_type_errors` + `infer_types`
- Taint-анализ → `get_taint_sources` + `trace_taint` + `get_typed_taint_flow`
- Всё остальное — смотри полный список инструментов в `NARSIL.usage.md`
