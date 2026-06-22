# Copilot Instructions

## Repository Overview

Personal dotfiles for macOS. Each tool's config lives in its own top-level directory, mirroring the path it would occupy under `$HOME`. Dotfiles are deployed by manually symlinking (or copying) the relevant subtrees — there is no automated symlink script.

```
git/        → ~/.gitconfig
kitty/      → ~/.config/kitty/
nvim/       → ~/.config/nvim/
yabai/      → ~/.config/yabai/ and ~/.config/skhd/
```

## Deployment / Installation

`install.sh` is not a shell script — it is a plain-text list of Homebrew and pip commands to run manually:

```
brew install nvm neovim ripgrep fd ruff
pip install debugpy
# For Java LSP: brew install openjdk
```

There are no build, lint, or test commands.

## Neovim Configuration

**Entry point:** `nvim/.config/nvim/init.lua` → loads `lua/rone/` module.

**Structure:**
- `lua/rone/lazy.lua` — plugin declarations (lazy.nvim)
- `lua/rone/remap.lua` — general keymaps (uses `lua/rone/keymap.lua` helper)
- `lua/rone/set.lua` — editor options (leader = `<Space>`, 4-space indent, 80-col ruler)
- `after/plugin/` — plugin-specific setup, loaded after plugins initialise

**Plugin manager:** [lazy.nvim](https://github.com/folke/lazy.nvim) (auto-bootstrapped on first launch).

**Key plugins and their config files:**
| Plugin | Config |
|---|---|
| nvim-lspconfig + Mason | `after/plugin/lsp.lua` |
| conform.nvim (formatting) | `after/plugin/conform.lua` |
| nvim-dap + dap-ui | `after/plugin/dap.lua` |
| Telescope | `after/plugin/telescospe.lua` *(note: intentional typo in filename)* |
| Harpoon | `after/plugin/harpoon.lua` |
| nvim-tree | `after/plugin/tree.lua` |
| nvim-jdtls (Java) | `ftplugin/java.lua` (attaches per-buffer) |

**LSP servers (managed by Mason):** `pyright`, `rust_analyzer`, `lua_ls`. Java uses `nvim-jdtls` via `ftplugin/java.lua`.

**Formatters (conform.nvim, runs on save):**
- Python → `ruff_format`
- Rust → `rustfmt`
- Java → `google-java-format` (jdtls built-in formatting is disabled to avoid conflicts)

**DAP:** Python uses system `python3` with `debugpy`. Java uses the `java-debug-adapter` bundle installed via Mason.

## Conventions

- All Neovim Lua is namespaced under `lua/rone/`.
- Keymaps use the `rone.keymap.map(mode, lhs, rhs, opts)` helper (sets `noremap = true` by default); use `vim.keymap.set` directly only when a closure is needed (e.g., DAP UI toggle).
- Plugin configs go in `after/plugin/` as standalone files, not inlined in `lazy.lua`.
- Java LSP attachment is handled by `ftplugin/java.lua`, not in `lsp.lua`, to get proper per-project workspace isolation.
- The `.gitignore` excludes `nvim/.config/nvim/plugi` (plugin cache) and `.DS_Store`.

## Yabai / skhd (macOS Window Manager)

- Layout: BSP, 12 px padding/gap.
- `alt + hjkl` — focus window; `shift + alt + hjkl` — swap window; `ctrl + alt + hjkl` — warp (move and split).
- `alt + s/g` — focus display west/east; `shift + alt + s/g` — move window to that display.
- `cmd + shift + 1-7` — move window to space 1-7.
