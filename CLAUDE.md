# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
uv run pytest          # run all tests
uv run pytest tests/test_main.py::test_get_status_linked  # run a single test
uv run main.py status  # show symlink status for all managed dotfiles
uv run main.py install # symlink dotfiles and run one-time setup steps
uv run main.py install --dry-run  # preview without making changes
```

`main.py` has a `#!/usr/bin/env -S uv run` shebang, so `./main.py <cmd>` works too.

## Architecture

Everything is driven by `dotfiles.toml`:

- `[[files]]` entries map `src` (repo-relative path) → `dst` (home-relative path). `install` creates symlinks from `dst` to the absolute `src`.
- `[[steps]]` entries are one-time shell commands. A `skip_if` path suppresses re-execution if it already exists.

All logic lives in `main.py`. The two CLI commands are `install` and `status`; both call `load_mappings()` to read `dotfiles.toml`.

`get_status(src, dst)` is the core primitive — returns one of `linked`, `identical`, `missing`, or `conflict`. Conflict resolution (interactive) offers skip / backup+link / edit-merge via `handle_conflict`.

To add a new dotfile, append a `[[files]]` block to `dotfiles.toml`.
