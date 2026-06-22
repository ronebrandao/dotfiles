# Neovim Configuration

Personal Neovim setup, namespaced under `lua/rone/`. Built around
[lazy.nvim](https://github.com/folke/lazy.nvim), with native LSP, Mason-managed
servers, Treesitter highlighting, conform.nvim formatting, and nvim-dap
debugging.

Leader key is `<Space>`.

---

## Table of Contents

- [Layout](#layout)
- [How it loads](#how-it-loads)
- [Editor options](#editor-options-setlua)
- [Installed plugins (and why)](#installed-plugins-and-why)
- [LSP servers](#lsp-servers)
- [Formatters](#formatters-conformnvim)
- [Treesitter parsers](#treesitter-parsers)
- [Debugging (DAP)](#debugging-dap)
- [External dependencies](#external-dependencies)
- [Keybindings](#keybindings)

---

## Layout

```
.config/nvim/
├── init.lua                  -- entry point, requires 'rone'
├── lazy-lock.json            -- pinned plugin commits (lazy.nvim lockfile)
├── lua/rone/
│   ├── init.lua              -- loads set, remap, lazy (in order)
│   ├── set.lua               -- editor options (vim.opt)
│   ├── remap.lua             -- general keymaps
│   ├── keymap.lua            -- map() helper (noremap = true by default)
│   └── lazy.lua              -- plugin declarations (lazy.nvim setup)
├── after/plugin/             -- per-plugin config, loaded after plugins init
│   ├── colors.lua            -- catppuccin theme
│   ├── conform.lua           -- formatting on save
│   ├── dap.lua               -- debugger + dap-ui wiring
│   ├── harpoon.lua           -- quick file navigation
│   ├── lsp.lua               -- Mason, LSP keymaps, nvim-cmp completion
│   ├── statusline.lua        -- lualine
│   ├── telescope.lua         -- Telescope keymaps
│   ├── tree.lua              -- nvim-tree file explorer
│   ├── treesitter.lua        -- Treesitter parsers + highlight
│   └── trouble.lua           -- diagnostics quickfix panel
└── ftplugin/
    └── java.lua              -- nvim-jdtls per-buffer attach (Java LSP)
```

> **Note:** plugins are declared with **lazy.nvim** in `lazy.lua` (this file was
> historically named `packer.lua` — it has never used packer).

## How it loads

1. `init.lua` → `require('rone')`
2. `lua/rone/init.lua` requires, in order:
   - `rone.set` — editor options
   - `rone.remap` — global keymaps
   - `rone.lazy` — bootstraps lazy.nvim (clones it on first launch) and
     declares all plugins
3. Files under `after/plugin/` run automatically **after** all plugins are
   initialised, so each plugin's setup lives in its own file.
4. `ftplugin/java.lua` runs per Java buffer to attach the jdtls language server
   with project-isolated workspaces.

---

## Editor options (`set.lua`)

| Option | Value | Why |
|---|---|---|
| `nu` + `relativenumber` | on | Absolute current line + relative jumps. |
| `errorbells` | off | No audible bells. |
| `tabstop` / `softtabstop` / `shiftwidth` | 4 | 4-space indentation. |
| `expandtab` | on | Insert spaces, not tabs. |
| `smartindent` | on | Auto-indent new lines by context. |
| `wrap` | off | No soft line wrapping. |
| `swapfile` / `backup` | off | No swap/backup clutter. |
| `undodir` + `undofile` | `~/.vim/undodir` | Persistent undo history across sessions. |
| `hlsearch` | off | No lingering search highlight. |
| `incsearch` | on | Incremental search as you type. |
| `termguicolors` | on | True-color support (required by the theme). |
| `scrolloff` | 8 | Keep 8 lines of context around the cursor. |
| `signcolumn` | `yes` | Always show the sign column (no text shifting). |
| `isfname:append("@-@")` | — | Treat `@` as part of filenames (gf). |
| `updatetime` | 50 | Faster CursorHold / diagnostics refresh. |
| `shortmess:append("c")` | — | Quieter completion messages. |
| `colorcolumn` | 80 | Visual 80-column ruler. |
| `mapleader` | `" "` | Space is the leader key. |
| `loaded_netrw*` | 1 | Disable netrw — required so nvim-tree owns file browsing. |

---

## Installed plugins (and why)

Pinned commits live in `lazy-lock.json`. Run `:Lazy` to manage them.

### Theme & UI
| Plugin | Why |
|---|---|
| `catppuccin/nvim` | Colorscheme (mocha flavour, transparent background). High priority so it loads before other UI. |
| `nvim-lualine/lualine.nvim` | Status bar. |
| `nvim-tree/nvim-tree.lua` | File explorer sidebar (replaces netrw). |
| `nvim-tree/nvim-web-devicons` | Filetype icons used by nvim-tree and lualine. |
| `folke/trouble.nvim` | Pretty, navigable diagnostics / quickfix panel. |

### Editing & navigation
| Plugin | Why |
|---|---|
| `nvim-treesitter/nvim-treesitter` | Accurate syntax highlighting + indentation via parsers. `:TSUpdate` on build. |
| `nvim-telescope/telescope.nvim` | Fuzzy finder for files, grep, help, git files. |
| `nvim-lua/plenary.nvim` | Lua utility library; Telescope (and others) depend on it. |
| `theprimeagen/harpoon` | Pin a handful of files and jump between them instantly. |
| `MeanderingProgrammer/render-markdown.nvim` | In-buffer Markdown rendering (loads only for `markdown` filetype). |

### LSP & completion
| Plugin | Why |
|---|---|
| `neovim/nvim-lspconfig` | Base configs for language servers. |
| `williamboman/mason.nvim` | Installer for LSP servers, formatters, and DAP adapters. |
| `williamboman/mason-lspconfig.nvim` | Bridges Mason ↔ lspconfig; auto-installs the `ensure_installed` servers. |
| `hrsh7th/nvim-cmp` | Completion engine. |
| `hrsh7th/cmp-nvim-lsp` | LSP completion source. |
| `hrsh7th/cmp-buffer` | Buffer-words completion source. |
| `hrsh7th/cmp-path` | Filesystem path completion source. |
| `hrsh7th/cmp-nvim-lua` | Neovim Lua API completion source. |
| `saadparwaiz1/cmp_luasnip` | Snippet completion source bridging cmp ↔ LuaSnip. |
| `L3MON4D3/LuaSnip` | Snippet engine. |
| `rafamadriz/friendly-snippets` | Prebuilt snippet collection. |
| `mfussenegger/nvim-jdtls` | Dedicated Java LSP (Eclipse JDT) with per-project workspaces; attached via `ftplugin/java.lua` rather than lspconfig. |

### Debugging
| Plugin | Why |
|---|---|
| `mfussenegger/nvim-dap` | Debug Adapter Protocol client core. |
| `rcarriga/nvim-dap-ui` | Debugger UI (scopes, breakpoints, REPL). Auto-opens/closes with sessions. |
| `nvim-neotest/nvim-nio` | Async IO library required by dap-ui. |
| `mfussenegger/nvim-dap-python` | Python debugging via system `python3` + `debugpy`. |
| `jay-babu/mason-nvim-dap.nvim` | Installs/manages DAP adapters through Mason. |

---

## LSP servers

Configured in `after/plugin/lsp.lua`. Mason auto-installs:

| Server | Language | Notes |
|---|---|---|
| `pyright` | Python | Workspace diagnostics, auto search paths, library type inference. |
| `rust_analyzer` | Rust | Default config. |
| `lua_ls` | Lua | `vim` marked as a known global to silence false diagnostics. |
| `jdtls` | Java | Not in `ensure_installed`; attached per-buffer via `ftplugin/java.lua`. Built-in formatting disabled (conform handles it). Favourite static imports preconfigured for JUnit/Mockito. |

Diagnostics use lettered signs (`E`/`W`/`H`/`I`) and inline virtual text.

Completion (`nvim-cmp`) sources, in priority order: `nvim_lsp` → `luasnip` →
`nvim_lua` → `buffer` → `path`.

---

## Formatters (conform.nvim)

Configured in `after/plugin/conform.lua`. **Formats on save** (500 ms timeout,
falls back to LSP formatting if no formatter is configured).

| Filetype | Formatter |
|---|---|
| Python | `ruff_format` |
| Rust | `rustfmt` |
| Java | `google-java-format` |

---

## Treesitter parsers

Configured in `after/plugin/treesitter.lua`. Auto-installed parsers:

`bash`, `c`, `javascript`, `json`, `lua`, `python`, `typescript`, `tsx`,
`css`, `rust`, `java`, `yaml`, `markdown`, `markdown_inline`.

Highlighting and indentation are enabled. `phpdoc` is explicitly
ignored.

---

## Debugging (DAP)

Configured in `after/plugin/dap.lua`:

- **dap-ui** auto-opens when a session initialises and auto-closes on
  terminate/exit.
- **Python** uses the Python from a dedicated **debugpy venv**
  (`~/.local/share/nvim/debugpy-venv`, created by `install.sh`), falling back to
  the system `python3` if that venv is absent. The dedicated venv avoids PEP 668
  (`externally-managed-environment`) errors on modern distros and Homebrew.
- **Java** debugging is wired in `ftplugin/java.lua`, which loads the
  `java-debug-adapter` bundle (installed by Mason) into the jdtls session.

---

## External dependencies

Run `install.sh` at the repo root — it is a cross-platform script that detects
macOS (Homebrew) or Linux (apt / dnf / pacman) and installs the right packages:

```sh
./install.sh
```

It installs:

| Tool | Purpose |
|---|---|
| `neovim` | The editor itself. |
| `ripgrep` | Required by Telescope `live_grep`. |
| `fd` | Faster file finding for Telescope. On Debian/Ubuntu it ships as `fdfind`, so the script symlinks `~/.local/bin/fd`. |
| `nvm` | Node version manager (JS/TS tooling). Skipped if already present. |
| JDK | Required by jdtls (Java LSP). `openjdk` (brew) / `default-jdk` (apt) / etc. Skipped if `java` is already on PATH. |
| `ruff` | Python formatter (`ruff_format` in conform). Installed via **pipx** (PEP 668 distros block system pip). |
| `debugpy` | Python debug adapter for `nvim-dap-python`. Installed into a dedicated venv at `~/.local/share/nvim/debugpy-venv`; `dap.lua` points dap-python at that venv's Python (falls back to system `python3`). |

Mason additionally installs `pyright`, `rust_analyzer`, `lua_ls`, `jdtls`,
`java-debug-adapter`, and `google-java-format` on demand.

---

## Keybindings

Leader is `<Space>`. `<C-x>` means Ctrl+x.

### General (`remap.lua`)
| Key | Mode | Action |
|---|---|---|
| `<leader>e` | n | Toggle nvim-tree file explorer. |
| `<C-h/j/k/l>` | n | Move between windows (left/down/up/right). |
| `<leader>f` | n | Telescope find files. |
| `<C-t>` | n | Telescope live grep. |
| `J` / `K` | v | Move selected lines down / up (re-indents). |
| `:` ↔ `;` | n, v | Swap `:` and `;` so command mode is on `;`. |
| `<leader>p` | x | Paste over selection without clobbering the register. |
| `<leader>y` | n, v | Yank to system clipboard. |
| `<leader>Y` | n | Yank current line to system clipboard. |
| `<leader>d` | n, v | Delete to the black-hole register (no register pollution). |
| `oo` | n | Open a line below without entering insert mode. |
| `OO` | n | Open a line above without entering insert mode. |

### LSP (active in buffers with a server attached, `lsp.lua`)
| Key | Mode | Action |
|---|---|---|
| `gd` | n | Go to definition. |
| `K` | n | Hover documentation. |
| `<leader>vws` | n | Workspace symbol search. |
| `<leader>vd` | n | Open diagnostic float. |
| `[d` / `]d` | n | Previous / next diagnostic. |
| `<leader>vca` | n | Code action. |
| `<leader>vrr` | n | List references. |
| `<leader>vrn` | n | Rename symbol. |
| `<C-h>` | i | Signature help. |

### Completion (nvim-cmp, insert mode)
| Key | Action |
|---|---|
| `<C-p>` / `<C-n>` | Select previous / next item. |
| `<C-y>` | Confirm selection. |
| `<C-Space>` | Trigger completion. |

### Telescope (`telescope.lua`)
| Key | Action |
|---|---|
| `<leader>pf` | Find files. |
| `<C-p>` | Find git-tracked files. |
| `<leader>ps` | Grep for a prompted string. |
| `<leader>vh` | Search help tags. |

### Harpoon (`harpoon.lua`)
| Key | Action |
|---|---|
| `<leader>a` | Add current file to Harpoon. |
| `<C-e>` | Toggle Harpoon quick menu. |
| `<leader>r` | Remove current file from Harpoon. |
| `<leader>1`–`<leader>4` | Jump to Harpoon file 1–4. |

### Debugging (`remap.lua` + dap-ui)
| Key | Action |
|---|---|
| `<leader>db` | Toggle breakpoint. |
| `<leader>dc` | Continue / start. |
| `<leader>ds` | Step over. |
| `<leader>di` | Step into. |
| `<leader>do` | Step out. |
| `<leader>du` | Toggle dap-ui. |

### Diagnostics (`trouble.lua`)
| Key | Action |
|---|---|
| `<leader>xx` | Toggle Trouble diagnostics panel. |
| `<leader>xq` | Toggle Trouble quickfix panel. |
