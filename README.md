# dotfiles

Personal dotfiles, managed by a small Python symlink manager (`main.py` +
`dotfiles.toml`). See `CLAUDE.md` for architecture and how to add a new dotfile.

## Install

```bash
./main.py install            # symlink everything + run one-time setup steps
./main.py install --dry-run  # preview without making changes
./main.py status             # show link status for all managed dotfiles
```

## Prerequisites

The manifest installs *config*, not *packages* — a few tools must already be on
the system (install once per machine, then run `./main.py install`):

| Tool | Install | Needed for |
| --- | --- | --- |
| [starship](https://starship.rs) | `brew install starship` | fish prompt — `fish/conf.d/starship.fish`, `starship/starship.toml` |
| FiraCode Nerd Font | `brew install --cask font-fira-code-nerd-font` | kitty prompt glyphs — `symbol_map` in `kitty/kitty.conf` |

Both have official non-Homebrew installers too (starship:
`curl -sS https://starship.rs/install.sh | sh`; Nerd Fonts:
<https://github.com/ryanoasis/nerd-fonts/releases>).

After installing the prerequisites and running `./main.py install`, restart the
shell (`exec fish`) to pick up the prompt.
