# narsil-mcp monorepo — top-level Makefile
# Delegates to build/*/Makefile.

MAKEFLAGS += --no-print-directory

BUILD_NARSIL := build/narsil-mcp
BUILD_FORGEMAX := build/forgemax

.PHONY: all narsil-mcp forgemax deb release debug test clean distclean install help

all: narsil-mcp forgemax

narsil-mcp:
	@$(MAKE) -C $(BUILD_NARSIL)

forgemax:
	@$(MAKE) -C $(BUILD_FORGEMAX)

release:
	@$(MAKE) -C $(BUILD_NARSIL) release
	@$(MAKE) -C $(BUILD_FORGEMAX) release

debug:
	@$(MAKE) -C $(BUILD_NARSIL) debug
	@$(MAKE) -C $(BUILD_FORGEMAX) debug

deb: narsil-mcp forgemax

test:
	@$(MAKE) -C $(BUILD_NARSIL) test
	@$(MAKE) -C $(BUILD_FORGEMAX) test

install:
	@echo "==> Installing all .deb packages…"; \
	for pkg in deb/narsil-mcp_*.deb deb/forgemax_*.deb; do \
		if [ -f "$$pkg" ]; then sudo dpkg -i "$$pkg"; fi; \
	done

clean:
	@$(MAKE) -C $(BUILD_NARSIL) clean
	@$(MAKE) -C $(BUILD_FORGEMAX) clean

distclean:
	@$(MAKE) -C $(BUILD_NARSIL) distclean
	@$(MAKE) -C $(BUILD_FORGEMAX) distclean

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  make          — build all (release + deb)"
	@echo "  make narsil-mcp — build narsil-mcp only"
	@echo "  make forgemax   — build forgemax only"
	@echo "  make release  — release build all"
	@echo "  make debug    — debug build all"
	@echo "  make deb      — .deb packages all"
	@echo "  make test     — run all tests"
	@echo "  make install  — install all .deb packages"
	@echo "  make clean    — clean build artifacts"
	@echo "  make distclean — full clean"
