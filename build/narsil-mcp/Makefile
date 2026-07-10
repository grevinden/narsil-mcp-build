# narsil-mcp build Makefile
# Usage: make          — build everything (release)
#        make debug    — debug build
#        make frontend — frontend only
#        make deb      — build .deb package
#        make clean    — clean artifacts
#        make distclean — full clean (including node_modules)

MAKEFLAGS += --no-print-directory

MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
PROJECT      := $(MAKEFILE_DIR)../../src/narsil-mcp
FRONTEND     := $(PROJECT)/frontend
TARGET       := $(MAKEFILE_DIR)target
PACKAGE_DIR  := $(MAKEFILE_DIR)deb-pkg
FEATURES     := native,graph,frontend,neural

# Package metadata — bump VERSION when releasing
VERSION := $(shell cd "$(PROJECT)" && \
    grep '^version = ' Cargo.toml | \
    head -1 | sed 's/.*= "\(.*\)"/\1/')
ARCH    := $(shell dpkg --print-architecture 2>/dev/null || echo amd64)
DEBNAME := narsil-mcp_$(VERSION)_$(ARCH).deb
DEB_DIR  := $(MAKEFILE_DIR)../../deb

.PHONY: all release debug frontend frontend-dev clean distclean test deb install-deb help

all: deb

frontend:
	@echo "==> Building frontend…"
	@cd "$(FRONTEND)" && npm ci --quiet && npm run build
	@echo "   done."

frontend-dev:
	@echo "==> Starting frontend dev server…"
	@cd "$(FRONTEND)" && npm run dev

release: frontend
	@echo "==> Building narsil-mcp (release)…"
	@cd "$(PROJECT)" && cargo build \
		--release \
		--target-dir "$(TARGET)" \
		--no-default-features \
		--features "$(FEATURES)"
	@printf "\n   Binary: "; \
	ls -lh "$(TARGET)/release/narsil-mcp" | awk '{print $$5, $$NF}'

debug: frontend
	@echo "==> Building narsil-mcp (debug)…"
	@cd "$(PROJECT)" && cargo build \
		--target-dir "$(TARGET)" \
		--no-default-features \
		--features "$(FEATURES)"
	@printf "\n   Binary: "; \
	ls -lh "$(TARGET)/debug/narsil-mcp" | awk '{print $$5, $$NF}'

test:
	@echo "==> Running tests…"
	@cd "$(PROJECT)" && cargo test \
		--target-dir "$(TARGET)" \
		--no-default-features \
		--features "$(FEATURES)"

# ---------------------------------------------------------------------------
# .deb package
# ---------------------------------------------------------------------------

deb: release
	@echo "==> Building .deb package…"
	@rm -rf "$(PACKAGE_DIR)"
	@mkdir -p "$(PACKAGE_DIR)/DEBIAN"
	@mkdir -p "$(PACKAGE_DIR)/usr/bin"
	@mkdir -p "$(PACKAGE_DIR)/usr/share/doc/narsil-mcp"
	@mkdir -p "$(PACKAGE_DIR)/usr/share/man/man1"
	@mkdir -p "$(PACKAGE_DIR)/usr/share/bash-completion/completions"
	@mkdir -p "$(PACKAGE_DIR)/usr/share/zsh/vendor-completions"
	@mkdir -p "$(PACKAGE_DIR)/usr/share/fish/vendor_completions.d"
	# Binary
	@install -m 755 "$(TARGET)/release/narsil-mcp" "$(PACKAGE_DIR)/usr/bin/narsil-mcp"
	# Documentation
	@install -m 644 "$(PROJECT)/README.md" "$(PACKAGE_DIR)/usr/share/doc/narsil-mcp/"
	@install -m 644 "$(PROJECT)/LICENSE-MIT" "$(PACKAGE_DIR)/usr/share/doc/narsil-mcp/" 2>/dev/null || true
	@install -m 644 "$(PROJECT)/LICENSE-APACHE" "$(PACKAGE_DIR)/usr/share/doc/narsil-mcp/" 2>/dev/null || true
	@install -m 644 "$(PROJECT)/CHANGELOG.md" "$(PACKAGE_DIR)/usr/share/doc/narsil-mcp/" 2>/dev/null || true
	# Man page (generate minimal if absent)
	@if [ -f "$(PROJECT)/docs/narsil-mcp.1" ]; then \
		install -m 644 "$(PROJECT)/docs/narsil-mcp.1" "$(PACKAGE_DIR)/usr/share/man/man1/"; \
	else \
		echo '.TH NARSIL-MCP 1 "$(VERSION)" "narsil-mcp" "User Commands"' > "$(PACKAGE_DIR)/usr/share/man/man1/narsil-mcp.1"; \
		echo '.SH NAME' >> "$(PACKAGE_DIR)/usr/share/man/man1/narsil-mcp.1"; \
		echo 'narsil-mcp \- blazingly fast MCP server for code intelligence' >> "$(PACKAGE_DIR)/usr/share/man/man1/narsil-mcp.1"; \
		echo '.SH DESCRIPTION' >> "$(PACKAGE_DIR)/usr/share/man/man1/narsil-mcp.1"; \
		echo 'A blazingly fast MCP server for code intelligence.' >> "$(PACKAGE_DIR)/usr/share/man/man1/narsil-mcp.1"; \
	fi
	# DEBIAN control (substitute version/arch)
	@sed \
		-e 's/@VERSION@/$(VERSION)/g' \
		-e 's/@ARCH@/$(ARCH)/g' \
		"$(MAKEFILE_DIR)../../deb/narsil-mcp/DEBIAN/control" > "$(PACKAGE_DIR)/DEBIAN/control"
	@chmod 644 "$(PACKAGE_DIR)/DEBIAN/control"
	# DEBIAN maintainer scripts
	@install -m 755 "$(MAKEFILE_DIR)../../deb/narsil-mcp/DEBIAN/postinst" "$(PACKAGE_DIR)/DEBIAN/postinst" 2>/dev/null || true
	@install -m 755 "$(MAKEFILE_DIR)../../deb/narsil-mcp/DEBIAN/postrm" "$(PACKAGE_DIR)/DEBIAN/postrm" 2>/dev/null || true
	# Build .deb
		@fakeroot dpkg-deb --build "$(PACKAGE_DIR)" "$(DEB_DIR)/$(DEBNAME)" 2>&1
	@rm -rf "$(PACKAGE_DIR)"
	@printf "\n   Package: "; ls -lh "$(DEB_DIR)/$(DEBNAME)" | awk '{print $$5, $$NF}'

install-deb: deb
	@echo "==> Installing .deb package…"
	@sudo dpkg -i "$(DEB_DIR)/$(DEBNAME)"

# ---------------------------------------------------------------------------
# Clean
# ---------------------------------------------------------------------------

clean:
	@echo "==> Cleaning frontend dist…"
	@rm -rf "$(FRONTEND)/dist"
	@echo "==> Cleaning cargo target…"
	@cd "$(PROJECT)" && cargo clean --target-dir "$(TARGET)"
	@echo "   done."

distclean: clean
	@echo "==> Removing node_modules…"
	@rm -rf "$(FRONTEND)/node_modules"
	@echo "==> Removing .deb artifacts…"
	@rm -rf "$(DEB_DIR)/narsil-mcp_*.deb" "$(PACKAGE_DIR)"
	@echo "   done."

help:
	@echo "Usage:"
	@echo "  make           — release build (frontend + Rust)"
	@echo "  make debug     — debug build"
	@echo "  make frontend  — build frontend only"
	@echo "  make test      — run tests"
	@echo "  make deb       — build .deb package (implies release)"
	@echo "  make install-deb — build & install .deb via dpkg"
	@echo "  make clean     — remove build artifacts"
	@echo "  make distclean — full clean (incl. node_modules, .deb)"
