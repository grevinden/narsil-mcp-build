# forgemax build Makefile
# Usage: make          — build everything (release + deb)
#        make release  — release build only
#        make debug    — debug build
#        make deb      — build .deb package
#        make clean    — clean artifacts
#        make distclean — full clean

MAKEFLAGS += --no-print-directory

MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
PROJECT      := $(MAKEFILE_DIR)../../src/forgemax
TARGET       := $(MAKEFILE_DIR)target
PACKAGE_DIR  := $(MAKEFILE_DIR)deb-pkg
BINARIES     := forgemax forgemax-worker

# Package metadata
VERSION := $(shell cd "$(PROJECT)" && \
    grep '^version = ' Cargo.toml | \
    head -1 | sed 's/.*= "\(.*\)"/\1/')
ARCH    := $(shell dpkg --print-architecture 2>/dev/null || echo amd64)
DEBNAME := forgemax_$(VERSION)_$(ARCH).deb
DEB_DIR := $(MAKEFILE_DIR)../../deb

export RUSTFLAGS := -C target-cpu=native

.PHONY: all release debug clean distclean test deb install-deb help

all: deb

release:
	@echo "==> Building forgemax (release)…"
	@cd "$(PROJECT)" && cargo build \
		--release \
		--target-dir "$(TARGET)"
	@printf "\n   Binaries:\n"; \
	for bin in $(BINARIES); do \
		path="$(TARGET)/release/$$bin"; \
		if [ -f "$$path" ]; then \
			printf "     %s  %s\n" "$$(ls -lh "$$path" | awk '{print $$5}')" "$$bin"; \
		fi; \
	done

debug:
	@echo "==> Building forgemax (debug)…"
	@cd "$(PROJECT)" && cargo build \
		--target-dir "$(TARGET)"
	@printf "\n   Binaries:\n"; \
	for bin in $(BINARIES); do \
		path="$(TARGET)/debug/$$bin"; \
		if [ -f "$$path" ]; then \
			printf "     %s  %s\n" "$$(ls -lh "$$path" | awk '{print $$5}')" "$$bin"; \
		fi; \
	done

test:
	@echo "==> Running tests…"
	@cd "$(PROJECT)" && cargo test \
		--target-dir "$(TARGET)"

# ---------------------------------------------------------------------------
# .deb package
# ---------------------------------------------------------------------------

deb: release
	@echo "==> Building .deb package…"
	@rm -rf "$(PACKAGE_DIR)"
	@mkdir -p "$(PACKAGE_DIR)/DEBIAN"
	@mkdir -p "$(PACKAGE_DIR)/usr/bin"
	@mkdir -p "$(PACKAGE_DIR)/usr/lib/forgemax"
	@mkdir -p "$(PACKAGE_DIR)/usr/share/doc/forgemax"
	@mkdir -p "$(PACKAGE_DIR)/usr/share/man/man1"
	@mkdir -p "$(PACKAGE_DIR)/usr/share/bash-completion/completions"
	@mkdir -p "$(PACKAGE_DIR)/usr/share/zsh/vendor-completions"
	@mkdir -p "$(PACKAGE_DIR)/usr/share/fish/vendor_completions.d"
	@mkdir -p "$(PACKAGE_DIR)/etc/forgemax"
	# Binaries
	@install -m 755 "$(TARGET)/release/forgemax" "$(PACKAGE_DIR)/usr/bin/forgemax"
	@install -m 755 "$(TARGET)/release/forgemax-worker" "$(PACKAGE_DIR)/usr/bin/forgemax-worker"
	# Example config
	@install -m 644 "$(PROJECT)/forge.toml.example" "$(PACKAGE_DIR)/etc/forgemax/forge.toml.example"
	@install -m 644 "$(PROJECT)/forge.toml.example.production" "$(PACKAGE_DIR)/etc/forgemax/forge.toml.example.production"
	# Documentation
	@install -m 644 "$(PROJECT)/README.md" "$(PACKAGE_DIR)/usr/share/doc/forgemax/"
	@install -m 644 "$(PROJECT)/ARCHITECTURE.md" "$(PACKAGE_DIR)/usr/share/doc/forgemax/"
	@install -m 644 "$(PROJECT)/CHANGELOG.md" "$(PACKAGE_DIR)/usr/share/doc/forgemax/"
	@install -m 644 "$(PROJECT)/LICENSE" "$(PACKAGE_DIR)/usr/share/doc/forgemax/"
	@install -m 644 "$(PROJECT)/SECURITY.md" "$(PACKAGE_DIR)/usr/share/doc/forgemax/"
	@install -m 644 "$(PROJECT)/UPGRADE.md" "$(PACKAGE_DIR)/usr/share/doc/forgemax/"
	# Man page (generate minimal if absent)
	@if [ -f "$(PROJECT)/docs/forgemax.1" ]; then \
		install -m 644 "$(PROJECT)/docs/forgemax.1" "$(PACKAGE_DIR)/usr/share/man/man1/"; \
	else \
		echo '.TH FORGEMAX 1 "$(VERSION)" "forgemax" "User Commands"' > "$(PACKAGE_DIR)/usr/share/man/man1/forgemax.1"; \
		echo '.SH NAME' >> "$(PACKAGE_DIR)/usr/share/man/man1/forgemax.1"; \
		echo 'forgemax \- Code Mode MCP Gateway' >> "$(PACKAGE_DIR)/usr/share/man/man1/forgemax.1"; \
		echo '.SH DESCRIPTION' >> "$(PACKAGE_DIR)/usr/share/man/man1/forgemax.1"; \
		echo 'Collapses N servers x M tools into 2 MCP tools (search + execute).' >> "$(PACKAGE_DIR)/usr/share/man/man1/forgemax.1"; \
	fi
	# DEBIAN control (substitute version/arch)
	@sed \
		-e 's/@VERSION@/$(VERSION)/g' \
		-e 's/@ARCH@/$(ARCH)/g' \
		"$(DEB_DIR)/forgemax/DEBIAN/control" > "$(PACKAGE_DIR)/DEBIAN/control"
	@chmod 644 "$(PACKAGE_DIR)/DEBIAN/control"
	# DEBIAN maintainer scripts
	@install -m 755 "$(DEB_DIR)/forgemax/DEBIAN/postinst" "$(PACKAGE_DIR)/DEBIAN/postinst" 2>/dev/null || true
	@install -m 755 "$(DEB_DIR)/forgemax/DEBIAN/postrm" "$(PACKAGE_DIR)/DEBIAN/postrm" 2>/dev/null || true
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
	@echo "==> Cleaning cargo target…"
	@cd "$(PROJECT)" && cargo clean --target-dir "$(TARGET)"
	@echo "   done."

distclean: clean
	@echo "==> Removing .deb artifacts…"
	@rm -rf "$(DEB_DIR)/forgemax_*.deb" "$(PACKAGE_DIR)"
	@echo "   done."

help:
	@echo "Usage:"
	@echo "  make           — release build + .deb package"
	@echo "  make debug     — debug build"
	@echo "  make test      — run tests"
	@echo "  make deb       — build .deb package (implies release)"
	@echo "  make install-deb — build & install .deb via dpkg"
	@echo "  make clean     — remove build artifacts"
	@echo "  make distclean — full clean (incl. .deb)"
