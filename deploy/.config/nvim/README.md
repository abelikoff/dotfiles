# Neovim 0.12 development config

A modular, lazy.nvim-free configuration built on Neovim 0.12's native `vim.pack` plugin manager and the native `vim.lsp.config()` / `vim.lsp.enable()` API. It targets Go, Python, Shell, JavaScript/TypeScript and C/C++ (plus Lua for editing the config itself), with Nerd Font icons that fall back to ASCII.

## Prerequisites

| Tool | Why |
| --- | --- |
| Neovim ≥ 0.12 | `vim.pack`, `:restart`, native LSP config |
| `git`, `curl`, `tar`, `unzip` | plugin + Mason downloads |
| A Nerd Font set in your terminal (e.g. JetBrainsMono Nerd Font) | icons; otherwise set `vim.g.have_nerd_font = false` |
| `ripgrep`, `fd`, `fzf` | fzf-lua pickers |
| A C compiler (`cc`, `gcc` or `clang`) | nvim-treesitter `main` compiles parsers locally |
| `tree-sitter` CLI **≥ 0.26.1** (optional) | installed automatically through Mason if missing or too old |
| Go toolchain | Mason builds `gopls`, `goimports`, `gofumpt`, `delve` with `go install` |
| Node.js + npm | `ts_ls`, `eslint`, `jsonls`, `bashls`, `prettierd` |
| Python 3 with `venv` | `basedpyright`, `ruff`, `debugpy` (Mason installs them from PyPI) |

macOS example:

```sh
brew install neovim git ripgrep fd fzf go node python
brew install tree-sitter-cli   # optional; the `tree-sitter` formula is now only the library
brew install --cask font-jetbrains-mono-nerd-font
```

Linux on arm64: Mason has no `clangd` build, so install `clangd` from your distro. The config auto-enables any server it finds on `PATH`.

## Install

```sh
# Try it side-by-side without touching your current setup
cp -r nvim ~/.config/nvim-dev
NVIM_APPNAME=nvim-dev nvim

# Or make it your main config (back up the old one first)
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
cp -r nvim ~/.config/nvim
nvim
```

On first launch `vim.pack` clones all plugins, then Mason installs LSP servers/tools and nvim-treesitter compiles parsers in the background (watch progress in the bottom-right corner). Run `:restart` once that finishes, then `:checkhealth`.

`vim.pack` writes `nvim-pack-lock.json` next to `init.lua`. Commit it to get identical plugin revisions on every machine.

## Layout

```
init.lua                 entry point: leaders, nerd-font flag, load order
lua/core/
  icons.lua              every Nerd Font glyph (+ ASCII fallback)
  options.lua            editor options
  keymaps.lua            plugin-independent mappings
  autocmds.lua           yank highlight, restore cursor, etc.
  pack.lua               vim.pack wrapper: shorthand, dedupe, build hooks
lua/plugins/             one module per concern: { specs = {...}, setup = fn }
  init.lua               collects specs -> single vim.pack.add() -> runs setups
  ui.lua                 tokyonight, mini.icons, lualine, which-key, fidget
  editor.lua             fzf-lua, oil, mini.ai/surround/pairs/indentscope, flash, trouble
  git.lua                gitsigns
  mason.lua              mason.nvim setup + `ensure()` installer helper
  treesitter.lua         nvim-treesitter (main), treesitter-context
  completion.lua         blink.cmp + friendly-snippets
  lsp.lua                mason-lspconfig, nvim-lspconfig, LSP keymaps
  format.lua             conform.nvim (format on save)
  lint.lua               nvim-lint
  debug.lua              nvim-dap, dap-ui, virtual text
lua/lang/                one module per language stack
  init.lua               registry + aggregation (edit `M.enabled` here)
  go.lua  python.lua  shell.lua  javascript.lua  cpp.lua  lua.lua
```

## Language stacks

| Language | LSP | Format | Lint | Debug |
| --- | --- | --- | --- | --- |
| Go | gopls | goimports, gofumpt | golangci-lint | delve (nvim-dap-go) |
| Python | basedpyright, ruff | ruff (fix, format, imports) | ruff (LSP) | debugpy (nvim-dap-python) |
| Shell | bashls (runs shellcheck) | shfmt | shellcheck | — |
| JS/TS | ts_ls, eslint, jsonls | prettierd / prettier | ESLint (LSP, fix on save) | js-debug-adapter |
| C/C++ | clangd (+clang-tidy), neocmake | clang-format | clang-tidy (via clangd) | codelldb |
| Lua | lua_ls | stylua | — | — |

### Adding a language

1. Create `lua/lang/rust.lua` returning any of: `treesitter`, `servers`, `on_attach`, `tools`, `formatters`, `formatter_opts`, `linters`, `filetypes`, `plugins`, `dap`. The existing files show each field.
2. Add `"rust"` to `M.enabled` in `lua/lang/init.lua`.
3. `:restart`.

Server names are nvim-lspconfig names (`rust_analyzer`); `tools` are Mason package names (`codelldb`).

## Key mappings

Leader is `<Space>`. Press it and wait for which-key to browse everything.

| Keys | Action |
| --- | --- |
| `<leader><space>` / `<leader>ff` | find files |
| `<leader>fg` / `<leader>fw` | live grep / grep word or selection |
| `<leader>fb` `<leader>fr` `<leader>fh` | buffers, recent files, help |
| `<leader>/` | search current buffer |
| `-` / `<leader>e` | oil: parent directory / floating explorer |
| `s` / `S` | flash jump / treesitter select |
| `gsa` `gsd` `gsr` | add / delete / replace surrounding |
| `gd` `gD` `gy` `grr` `gri` | definition, declaration, type def, references, implementations |
| `K` | hover |
| `<leader>ca` `<leader>cr` | code action, rename |
| `<leader>cf` | format buffer/selection |
| `<leader>ss` / `<leader>sS` | document / workspace symbols |
| `<leader>ch` | switch source/header (C/C++) |
| `<leader>uh` `<leader>uf` `<leader>ud` | toggle inlay hints, format-on-save, diagnostics |
| `]d` `[d` / `<leader>cd` | next/prev diagnostic / line diagnostics |
| `<leader>xx` `<leader>xs` | Trouble diagnostics / symbols outline |
| `]h` `[h` `<leader>hs` `<leader>hr` `<leader>hp` `<leader>hb` | git hunks: navigate, stage, reset, preview, blame |
| `<F5>` `<F10>` `<F11>` `<F12>` | debug continue / over / into / out |
| `<leader>db` `<leader>du` `<leader>de` | breakpoint, debug UI, evaluate |
| `<leader>dgt` / `<leader>dpm` | debug Go test / Python test method |
| `<leader>tt` | terminal split (`<Esc><Esc>` leaves terminal mode) |
| `<leader>pu` / `<leader>pl` | update plugins (`:w` to confirm, `:q` to cancel) / list plugins |
| `<leader>cm` / `<leader>cI` | Mason / LSP health |
| `<leader>qr` | `:restart` |

Completion (blink.cmp default preset): `<C-space>` open, `<C-n>`/`<C-p>` select, `<C-y>` accept, `<C-e>` close, `<Tab>`/`<S-Tab>` jump through snippet fields.

## Troubleshooting

- **tree-sitter CLI not found / too old:** the config installs `tree-sitter-cli` through Mason and then builds the parsers; `:restart` once it finishes. If Mason can't install it (unsupported platform, no network), install it yourself: `brew install tree-sitter-cli`, `sudo pacman -S tree-sitter-cli`, `cargo install --locked tree-sitter-cli`, or the prebuilt binary from the tree-sitter GitHub releases. Avoid npm, and avoid distro packages older than 0.26.1. Verify with `:checkhealth nvim-treesitter`.
- **`require('lspconfig')` framework is deprecated:** this config never calls it; something else loaded does. Find the caller with a traceback (see the chat notes) and check `~/.local/share/nvim/site/pack/*/start/` for leftovers from an old plugin manager.

## Maintenance

- Update plugins: `<leader>pu` (or `:lua vim.pack.update()`), review, `:w`, then `:restart`. Tree-sitter parsers are rebuilt automatically after nvim-treesitter updates.
- Remove a plugin: delete its spec, `:restart`, then `:lua vim.pack.del({ "name" })`.
- Update Mason packages: `:Mason`, then `U`.
- Disable format on save for one project: `:lua vim.b.disable_autoformat = true`, or `<leader>uF`.
