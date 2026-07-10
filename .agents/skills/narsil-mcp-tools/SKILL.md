---
name: narsil-mcp-tools
description: Comprehensive guide for using narsil-mcp MCP server tools - code intelligence, security analysis (taint/OWASP/CWE), search, call graphs, data flow, type inference, supply chain SBOM, git integration, LSP, and SPARQL/RDF knowledge graph. Use as primary source for project analysis.
---

# narsil-mcp Tools Usage Guide

narsil-mcp is a blazingly fast MCP server for code intelligence with 90+ tools organized into categories. Always use narsil-mcp tools as the **primary source** of project analysis before manual code reading.

## Tool Categories and Available Tools

### Repository & File Management (8 tools)
- Project structure navigation
- File enumeration and discovery
- Reindexing operations

### Symbol Search & Navigation (7 tools)
- `find_symbols` - Search for symbols by pattern
- `find_references` - Find symbol references
- `workspace_symbol_search` - Global symbol search
- Export maps, fuzzy search capabilities

### Code Search (12 tools)
- BM25 search engine (Tantivy-based)
- TF-IDF embeddings for similar code search
- Hybrid search with RRF Fusion
- Neural semantic search (requires `--neural`)
- AST-aware chunking

### Call Graph Analysis (6 tools, requires `--call-graph` feature)
- `get_call_graph()` - Full call graph analysis
- `get_control_flow()` - CFG generation
- Caller/callee enumeration
- Complexity and hotspot identification

### Control Flow Analysis (2 tools)
- Control Flow Graph (CFG) generation
- Basic blocks analysis
- Dead code detection (`find_dead_code`)

### Data Flow Analysis (4 tools)
- Def-Use chains analysis
- `get_reaching_definitions` - Reaching definitions tracing
- Dead stores detection (`find_dead_stores`)

### Type Inference (3 tools, Python/JavaScript/TypeScript)
- Type inference engine
- `check_type_errors` - Type error validation
- Taint + types combined analysis

### Security Analysis (9 tools) — **PRIORITET №1**

#### Taint Tracking:
- `find_injection_vulnerabilities` - Find injection vulnerabilities
- `get_taint_sources` - Identify taint sources
- `trace_taint` - Trace taint flow from source to sink

#### Rules Engine (OWASP/CWE):
- `scan_security` - Full security scan with configurable options
- `check_owasp_top10` - OWASP Top 10 vulnerability scan
- `check_cwe_top25` - CWE Top 25 vulnerability scan
- `get_security_summary` - Security summary report

#### Vulnerability Explanation & Fixes:
- `explain_vulnerability` - Explain specific vulnerability with examples and references
- `suggest_fix` - Suggest code fixes for detected vulnerabilities

Security rule types supported: Pattern, TaintFlow, ControlFlow, Secret, Crypto.
Languages covered: Python, JS/TS, Rust, Go, Java, C#, PHP, Ruby, Kotlin, Elixir, Bash, IaC (Docker/K8s/Terraform/CloudFormation).

### Supply Chain Security (4 tools)
- `generate_sbom` - Generate SBOM in CycloneDX or SPDX formats
- OSV dependency vulnerability checking
- License compliance analysis
- `find_upgrade_path` - Find upgrade paths for vulnerable dependencies

### Git Integration (9 tools, requires `--git` feature)
- Blame analysis
- Commit history traversal
- Hotspots identification by commit frequency
- Diff comparison operations

### LSP Integration (3 tools, requires `--lsp` feature)
- Hover information extraction
- Type info retrieval
- Go to definition navigation

### Remote Repository Support (3 tools, requires `--remote` feature)
- GitHub API integration: clone, list repositories, fetch content

### Graph/SPARQL & Knowledge Graph (14 tools, requires `--graph` feature)
- RDF knowledge graph storage via oxigraph
- SPARQL query execution
- CCG (Code Context Graph) with L0-L3 layers in JSON-LD format

## Presets Configuration

narsil-mcp supports tool presets to balance performance and capabilities:

| Preset | Tool count | Editor | Description |
|--------|------------|--------|-------------|
| `minimal` | 20-30 | Zed, Vim | Fast, lightweight — essential tools only |
| `balanced` | ~40 | VS Code, IntelliJ | Good defaults — git + LSP + security basics |
| `full` | 70+ | Claude Desktop | All features — comprehensive analysis |
| `security-focused` | ~30 | Security audits | Taint, OWASP/CWE, supply chain only |

### CLI Usage Examples:

```bash
# Minimal - Fast, lightweight (Zed, quick edits)
narsil-mcp --repos . --preset minimal

# Balanced - Good defaults (VS Code, IntelliJ)
narsil-mcp --repos . --preset balanced --git --call-graph

# Full - All features (Claude Desktop, comprehensive analysis)
narsil-mcp --repos . --preset full --git --call-graph

# Security-focused - Security and supply chain tools
narsil-mcp --repos . --preset security-focused

# With neural semantic search enabled
narsil-mcp --repos . --preset full --neural

# With RDF knowledge graph enabled
narsil-mcp --repos . --preset full --graph
```

## MCP Client Configuration

### Claude Desktop:

```json
{
  "mcpServers": {
    "narsil-mcp": {
      "command": "narsil-mcp",
      "args": ["--repos", "/path/to/project", "--preset", "full"]
    }
  }
}
```

### Cursor / VS Code:

```json
{
  "mcpServers": {
    "narsil-mcp": {
      "command": "narsil-mcp",
      "args": ["--repos", "."]
    }
  }
}
```

## Security Scan Options

When using `scan_security`, configurable options include:
- `path` - Specific file or directory path to scan
- `severity_threshold` - Filter by severity level (low, medium, high, critical)
- `ruleset` - Custom ruleset name or builtin (owasp_top10, cwe_top25)
- `exclude_tests` - Exclude test files and fixtures from scanning
- `max_findings` - Maximum number of findings to return (pagination support)
- `offset` - Offset for pagination

## Taint Analysis Architecture

The taint analysis module supports:
- Taint source identification (user input, file reads, network data)
- Taint sink detection (SQL queries, command execution, HTML output)
- Taint propagation through data flow
- Sanitizer recognition
- Vulnerability detection: SQL injection, XSS, command injection, path traversal

Supported languages for taint patterns: Python (Flask, Django), JavaScript/TypeScript (Express, Node.js), Rust (Actix, SQLx), Go (net/http), Java (Servlet, Spring), C# (ASP.NET), PHP, Ruby (Rails), Kotlin.

## Forgemax Integration

forgemax is the MCP gateway with V8 sandbox for safe execution of LLM-generated JavaScript code. It provides defense-in-depth protection:

- Layer 1: Code Validation (pre-execution validator, AST validator via oxc)
- Layer 2: V8 Isolation (no fs/net/env access, eval/Function removed)
- Layer 3: Dispatcher (GroupEnforcingDispatcher with strict/open isolation, Circuit Breaker)
- Layer 4: Output (Error Redaction for URLs/IPs/credentials/stack traces, Manifest Sanitisation)

Server groups configuration example:

```toml
[groups.internal]
servers = ["vault", "database"]
isolation = "strict"  # Cannot transfer data outward

[groups.external]
servers = ["slack", "github"]
isolation = "strict"

[groups.analysis]
servers = ["narsil"]
isolation = "open"    # Can communicate with any servers
```

Sandbox API example for LLM JavaScript:

```javascript
async () => {
  // Search symbols in code
  const symbols = await narsil.symbols.find({ pattern: "handle_*" });

  // Read resource
  const content = await forge.readResource("narsil", "file:///src/main.rs");

  // Save to stash
  await forge.stash.put("results", symbols);

  // Parallel calls
  const [issues, errors] = await forge.parallel([
    () => github.issues.list({ repo: "my-app" }),
    () => sentry.errors.list({ project: "my-app" }),
  ]);
}
```

## Documentation References

- [README.md](../README.md) — full project documentation
- [NARSIL.usage.md](../NARSIL.usage.md) — narsil-mcp usage guide (preset tool counts)
- [FORGEMAX.usage.md](../FORGEMAX.usage.md) — forgemax usage guide
- [src/narsil-mcp/README.md](../src/narsil-mcp/README.md) — component documentation with full tool list
- [src/forgemax/README.md](../src/forgemax/README.md) — security architecture and examples
- [src/forgemax/ARCHITECTURE.md](../src/forgemax/ARCHITECTURE.md) — defense-in-depth, server groups, circuit breakers