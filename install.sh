#!/usr/bin/env bash
#
# Cross-platform dependency installer for these dotfiles (Neovim toolchain).
# Supports macOS (Homebrew) and Linux (apt / dnf / pacman).
#
# Usage: ./install.sh
#
set -euo pipefail

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

# ---------------------------------------------------------------------------
# Detect platform / package manager
# ---------------------------------------------------------------------------
OS="$(uname -s)"
PKG=""

if [ "$OS" = "Darwin" ]; then
    PKG="brew"
elif [ "$OS" = "Linux" ]; then
    if   have apt-get; then PKG="apt"
    elif have dnf;     then PKG="dnf"
    elif have pacman;  then PKG="pacman"
    else
        warn "No supported Linux package manager found (apt/dnf/pacman)."
        warn "Install neovim, ripgrep, fd and a JDK manually, then re-run."
        exit 1
    fi
else
    warn "Unsupported OS: $OS"
    exit 1
fi

log "Detected platform: $OS (package manager: $PKG)"

# ---------------------------------------------------------------------------
# Package-manager wrappers
# ---------------------------------------------------------------------------
pkg_install() {
    case "$PKG" in
        brew)   brew install "$@" ;;
        apt)    sudo apt-get install -y "$@" ;;
        dnf)    sudo dnf install -y "$@" ;;
        pacman) sudo pacman -S --needed --noconfirm "$@" ;;
    esac
}

if [ "$PKG" = "apt" ]; then
    log "Updating apt package index..."
    sudo apt-get update -y
fi

# ---------------------------------------------------------------------------
# Core CLI tools (package names differ per manager)
# ---------------------------------------------------------------------------
# Neovim
log "Installing Neovim..."
pkg_install neovim

# ripgrep (required by Telescope live_grep)
log "Installing ripgrep..."
pkg_install ripgrep

# fd (faster file finding for Telescope)
log "Installing fd..."
case "$PKG" in
    brew)   pkg_install fd ;;
    apt)    pkg_install fd-find ;;   # Debian/Ubuntu ship the binary as 'fdfind'
    dnf)    pkg_install fd-find ;;
    pacman) pkg_install fd ;;
esac

# On Debian/Ubuntu the binary is 'fdfind'; expose it as 'fd' for Telescope.
if [ "$PKG" = "apt" ] && have fdfind && ! have fd; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    log "Symlinked fdfind -> ~/.local/bin/fd (ensure ~/.local/bin is on PATH)"
fi

# ---------------------------------------------------------------------------
# Node version manager (nvm) -- for JS/TS tooling
# ---------------------------------------------------------------------------
if [ -s "$HOME/.nvm/nvm.sh" ] || have nvm; then
    log "nvm already present, skipping."
else
    log "Installing nvm..."
    if [ "$PKG" = "brew" ]; then
        brew install nvm
        mkdir -p "$HOME/.nvm"
    else
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    fi
    warn "Add nvm to your shell rc if the installer didn't (see nvm docs)."
fi

# ---------------------------------------------------------------------------
# JDK (required by jdtls / Java LSP)
# ---------------------------------------------------------------------------
if have java; then
    log "Java already installed ($(java -version 2>&1 | head -n1)), skipping JDK."
else
    log "Installing a JDK (required for jdtls / Java LSP)..."
    case "$PKG" in
        brew)   pkg_install openjdk ;;
        apt)    pkg_install default-jdk ;;
        dnf)    pkg_install java-latest-openjdk-devel ;;
        pacman) pkg_install jdk-openjdk ;;
    esac
fi

# ---------------------------------------------------------------------------
# Python tooling
# ---------------------------------------------------------------------------
# Modern distros / Homebrew Python mark the system environment as
# "externally managed" (PEP 668), so plain `pip install` is blocked. We use
# pipx for CLI tools and a dedicated venv for the debugpy *library*.

# Ensure pipx is available.
if ! have pipx; then
    log "Installing pipx..."
    case "$PKG" in
        brew)   pkg_install pipx ;;
        apt)    pkg_install pipx ;;
        dnf)    pkg_install pipx ;;
        pacman) pkg_install python-pipx ;;
    esac
fi
pipx ensurepath >/dev/null 2>&1 || true

# ruff -- Python formatter used by conform.nvim (ruff_format). Standalone CLI,
# so pipx is the right tool.
log "Installing ruff via pipx..."
pipx install ruff || warn "ruff may already be installed (pipx)."

# debugpy -- Python debug adapter imported by nvim-dap-python. It must be
# importable by the interpreter dap-python launches, so a pipx/--user install
# won't do. Install it into a dedicated venv that dap.lua points at.
DEBUGPY_VENV="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/debugpy-venv"
if [ ! -x "$DEBUGPY_VENV/bin/python" ]; then
    log "Creating debugpy venv at $DEBUGPY_VENV ..."
    python3 -m venv "$DEBUGPY_VENV"
fi
log "Installing debugpy into venv..."
"$DEBUGPY_VENV/bin/python" -m pip install --upgrade pip debugpy

log "Done. Open Neovim and run :Mason to verify LSP/DAP servers, and :checkhealth."
