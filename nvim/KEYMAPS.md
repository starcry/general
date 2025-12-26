# Neovim Keymaps – Quick Reference

> **Note:** `<leader>` is whatever you have configured as your leader key.

## Git / Merge Conflict Helpers (normal mode)

| Keys | Action |
|---|---|
| `<leader>gi` | Open Git diff view (`DiffviewOpen`). |
| `<leader>go` | Take **ours** for current conflict (`:diffget //2`). |
| `<leader>gt` | Take **theirs** for current conflict (`:diffget //3`). |
| `<leader>gd` | **Delete** the entire merge-conflict region under the cursor. |

## File Explorer (NvimTree) (normal mode)

| Keys | Action |
|---|---|
| `<leader>e` | Toggle file explorer (`NvimTreeToggle`). |
| `<leader>r` | Refresh file explorer (`NvimTreeRefresh`). |

## Diagnostics (LSP/Neovim) (normal mode)

| Keys | Action |
|---|---|
| `<leader>E` | Open floating diagnostic window. |
| `[d` | Jump to **previous** diagnostic. |
| `]d` | Jump to **next** diagnostic. |
| `<leader>q` | Send diagnostics to the **location list**. |

## System Clipboard (normal + visual modes where noted)

| Keys | Action |
|---|---|
| `<leader>y` (n/x) | Yank to **system clipboard**. |
| `<leader>Y` (n) | Yank **line** to system clipboard. |
| `<leader>ya` (n) | Yank **file** to system clipboard. |
| `<leader>d` (n/x) | Cut (delete) to system clipboard. |
| `<leader>D` (n) | Cut **line** to system clipboard. |
| `<leader>p` (n/x) | Paste from system clipboard **after** cursor. |
| `<leader>P` (n/x) | Paste from system clipboard **before** cursor. |

## Mouse Behavior

| Event | Action |
|---|---|
| Left click (normal mode) | Cursor **does not move**; echoes `Mouse Click Disabled`. *(Applied on `VimEnter`)* |

## LSP: Buffer‑local Mappings (apply only after a server attaches)

| Keys | Action |
|---|---|
| `gd` | Go to **definition**. |
| `gD` | Go to **declaration**. |
| `gi` | Go to **implementation**. |
| `<C-k>` | Show **signature help**. |
| `K` | Show **hover** information. |
| `gr` | Show **references**. |
| `<leader>wa` | **Add** workspace folder. |
| `<leader>wr` | **Remove** workspace folder. |
| `<leader>wl` | **List** workspace folders (prints to message area). |
| `<leader>ca` (n/v) | **Code actions**. |
| `<leader>rn` | **Rename** symbol. |
| `<leader>f` | **Format** buffer (async). |
| `<leader>D` | Go to **type definition**. *Note: This shadows `<leader>D` clipboard cut **in attached LSP buffers only***. |

## Debugging (nvim-dap) – normal mode

| Keys | Action |
|---|---|
| `F5` | Continue / start debugging. |
| `F10` | Step **over**. |
| `F11` | Step **into**. |
| `F12` | Step **out**. |
| `<leader>b` | Toggle **breakpoint**. |
| `<leader>B` | Set **conditional** breakpoint (prompts). |

## Whitespace / Trailing Spaces (normal mode)

| Keys | Action |
|---|---|
| `]t` | Jump to **next** trailing space. |
| `[t` | Jump to **previous** trailing space. |
| `<leader>tl` | **Trim** trailing spaces on **current line**. |
| `<leader>tf` | **Trim** trailing spaces in **entire file**. |

## 🤖 Copilot

| Key | Action |
|----|-------|
| `<leader>aa` | Open Copilot panel |
| `<leader>ca` | Open Copilot panel that automatically uses the current open file |
| `gd` | use from within copilot this will open the copilot diff |
| `]c` | go to next change |
| `[c` | go to previous change |
| `do` | do change |

---

### Notes
- Some mappings (e.g., LSP ones) are set only when a language server is attached, so they won’t be active in all buffers.
- Clipboard mappings use the `+` (system) register, so make sure Neovim is built with clipboard support on your OS.

