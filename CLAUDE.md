# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for a Linux terminal environment: Ghostty + tmux + zsh + vim. All configs share the Dracula theme.

## Deployment

Files are symlinked to their target locations manually:

| Source | Target |
|--------|--------|
| `.zshrc` | `~/.zshrc` |
| `.tmux.conf` | `~/.tmux.conf` |
| `.vimrc` | `~/.vimrc` |
| `ghostty/config` | `~/.config/ghostty/config` |

## Cross-config Dependencies

Pane title coordination — three configs work together to let tmux manage pane titles:
- `ghostty/config`: `shell-integration-features = ...,no-title` — prevents shell from overwriting titles
- `.tmux.conf`: `allow-rename off`, `automatic-rename off` — tmux keeps titles stable; `bind T` sets title interactively
- `.zshrc`: `DISABLE_AUTO_TITLE="true"` — oh-my-zsh doesn't touch titles

Clipboard chain — system clipboard flows through all layers:
- `ghostty/config`: `copy-on-select = clipboard`, `ctrl+v=unbind` (passthrough to apps)
- `.tmux.conf`: `tmux-yank` plugin syncs tmux buffers with system clipboard
- `.zshrc`: `c`/`v` aliases for `xclip`/`xclip -o`

## Plugin Managers

- **zsh**: oh-my-zsh (`~/.oh-my-zsh`) with powerlevel10k theme; plugins listed in `.zshrc` `plugins=(...)` array
- **tmux**: TPM (`~/.tmux/plugins/tpm`); plugins listed via `set -g @plugin` lines; install with `prefix + I`
- **vim**: no plugin manager, vanilla config

## Editing Conventions

- Config comments use the native format of each tool (`#` for zsh/tmux/ghostty, `"` for vim)
- Configs are grouped by logical sections with `# === Section ===` headers (ghostty) or `# Section` comments (tmux)
- `.tmux.conf`: TPM init (`run '~/.tmux/plugins/tpm/tpm'`) must stay at the bottom; post-plugin overrides go after it
- `.zshrc`: powerlevel10k instant prompt block must stay at the top; `typeset -U path` deduplicates PATH entries
