# =============================================================================
# Claude Code Setup
# =============================================================================

SHELL := /bin/bash
SHELL_RC := $(shell \
	if [ -n "$$ZSH_VERSION" ] || [ "$$(basename $$SHELL)" = "zsh" ]; then \
		echo "$$HOME/.zshrc"; \
	else \
		echo "$$HOME/.bashrc"; \
	fi)

GIT_SYNC_LINE := [ -f "$$HOME/.claude/git-sync.sh" ] && source "$$HOME/.claude/git-sync.sh"

.PHONY: all install-claude install-plugins shell-setup help

# -----------------------------------------------------------------------------

all: install-claude install-plugins shell-setup
	@echo ""
	@echo "✓ All done. Restart your terminal or run: source $(SHELL_RC)"

# -----------------------------------------------------------------------------

install-claude:
	@echo "==> Installing Claude Code (native installer)"
	curl -fsSL https://claude.ai/install.sh | bash
	@echo "✓ Claude Code installed. Run 'claude' to authenticate."

# -----------------------------------------------------------------------------

install-plugins:
	@echo ""
	@echo "==> [1/5] Installing rtk"
	curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
	rtk init -g

	@echo ""
	@echo "==> [2/5] Installing mgrep"
	npm install -g @mixedbread-ai/mgrep
	@echo "  → Run 'mgrep login' manually after setup to authenticate."

	@echo ""
	@echo "==> [3/5] Installing caveman"
	curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash

	@echo ""
	@echo "==> [4/5] Registering plugin marketplaces"
	claude plugin marketplace add https://github.com/anthropics/claude-plugins-official
	claude plugin marketplace add https://github.com/mixedbread-ai/mgrep
	claude plugin marketplace add mksglu/context-mode
	claude plugin marketplace add JuliusBrussee/caveman

	@echo ""
	@echo "==> [5/5] Installing Claude Code plugins"
	claude plugin install context-mode@context-mode
	claude plugin install caveman@caveman

	@echo ""
	@echo "✓ Plugins installed. Run /plugins inside Claude Code to verify."

# -----------------------------------------------------------------------------

shell-setup:
	@echo ""
	@echo "==> Configuring shell ($(SHELL_RC))"
	@if grep -qF '$(GIT_SYNC_LINE)' "$(SHELL_RC)" 2>/dev/null; then \
		echo "  → git-sync line already present, skipping."; \
	else \
		echo '' >> "$(SHELL_RC)"; \
		echo '# Claude Code git-sync' >> "$(SHELL_RC)"; \
		echo '$(GIT_SYNC_LINE)' >> "$(SHELL_RC)"; \
		echo "  → Added git-sync source line to $(SHELL_RC)"; \
	fi

# -----------------------------------------------------------------------------

help:
	@echo ""
	@echo "Usage:"
	@echo "  make              Run full setup (claude + plugins + shell)"
	@echo "  make install-claude   Install Claude Code only"
	@echo "  make install-plugins  Install all plugins only"
	@echo "  make shell-setup      Add git-sync line to shell RC only"
	@echo ""
