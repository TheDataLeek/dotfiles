#!/usr/bin/env -S uv run
import os
import shutil
import subprocess
import tempfile
import tomllib
from difflib import unified_diff
from pathlib import Path

import cyclopts
from rich.console import Console
from rich.panel import Panel
from rich.prompt import Prompt
from rich.table import Table
from rich.text import Text

app = cyclopts.App()
console = Console()
REPO_ROOT = Path(__file__).parent


@app.command
def install(*, dry_run: bool = False):
    """Symlink all dotfiles and run one-time setup steps."""
    mappings = load_mappings()
    for src, dst in mappings:
        link_file(src, dst, dry_run)
    for step in load_steps():
        run_step(step, dry_run)
    post_install(dry_run)


@app.command
def status():
    """Show the link status of all managed dotfiles."""
    mappings = load_mappings()
    table = Table(title="Dotfiles Status")
    table.add_column("File", style="cyan")
    table.add_column("Target", style="dim")
    table.add_column("Status")
    for src, dst in mappings:
        state = get_status(src, dst)
        color, icon = _status_style(state)
        table.add_row(
            str(src.relative_to(REPO_ROOT)),
            str(dst),
            Text(f"{icon} {state}", style=color),
        )
    console.print(table)


def link_file(src: Path, dst: Path, dry_run: bool) -> None:
    state = get_status(src, dst)
    label = str(dst)

    if state == "linked":
        console.print(f"[green]✓ already linked[/]  {label}")
        return

    if state == "missing":
        if not dry_run:
            dst.parent.mkdir(parents=True, exist_ok=True)
            dst.symlink_to(src)
        console.print(f"[green]✓ linked[/]  {label}" + (" [dim](dry run)[/]" if dry_run else ""))
        return

    if state == "identical":
        if not dry_run:
            dst.unlink()
            dst.symlink_to(src)
        console.print(f"[cyan]~ replaced with symlink[/]  {label}" + (" [dim](dry run)[/]" if dry_run else ""))
        return

    handle_conflict(src, dst, dry_run)


def handle_conflict(src: Path, dst: Path, dry_run: bool) -> None:
    label = str(dst)
    console.print(f"\n[red]! conflict[/]  {label}")
    show_diff(src, dst)
    if dry_run:
        console.print("  [dim](dry run — skipping prompt)[/]")
        return
    action = prompt_action()
    if action == "s":
        console.print("  [yellow]skipped[/]")
    elif action == "b":
        bak = dst.with_suffix(dst.suffix + ".bak")
        shutil.move(str(dst), str(bak))
        dst.symlink_to(src)
        console.print(f"  [green]backed up to {bak.name}, linked[/]")
    elif action == "e":
        _edit_merge(src, dst)


def show_diff(src: Path, dst: Path) -> None:
    existing = dst.read_text(errors="replace").splitlines(keepends=True)
    repo = src.read_text(errors="replace").splitlines(keepends=True)
    diff = list(unified_diff(existing, repo, fromfile="existing", tofile="repo", n=3))
    if not diff:
        return
    text = Text()
    for line in diff[:60]:
        if line.startswith("+") and not line.startswith("+++"):
            text.append(line, style="green")
        elif line.startswith("-") and not line.startswith("---"):
            text.append(line, style="red")
        else:
            text.append(line, style="dim")
    if len(diff) > 60:
        text.append(f"\n… {len(diff) - 60} more lines …\n", style="dim")
    console.print(Panel(text, title="diff  existing → repo", expand=False))


def prompt_action() -> str:
    while True:
        raw = Prompt.ask("  [bold]s[/bold]kip  [bold]b[/bold]ackup+link  [bold]e[/bold]dit", default="s")
        choice = raw.strip().lower()[:1] or "s"
        if choice in ("s", "b", "e"):
            return choice


def _edit_merge(src: Path, dst: Path) -> None:
    with tempfile.NamedTemporaryFile(
        suffix=dst.suffix or ".txt", mode="w", delete=False, encoding="utf-8"
    ) as tmp:
        tmp.write(dst.read_text(errors="replace"))
        tmp_path = Path(tmp.name)
    editor = os.environ.get("EDITOR", "vi")
    subprocess.run([editor, str(tmp_path)], check=False)
    src.write_text(tmp_path.read_text(errors="replace"))
    tmp_path.unlink(missing_ok=True)
    dst.unlink()
    dst.symlink_to(src)
    console.print("  [green]edited and linked[/] (repo updated — remember to commit)")


def run_step(step: dict, dry_run: bool) -> None:
    name = step["name"]
    skip_if = step.get("skip_if")
    if skip_if and Path(skip_if).expanduser().exists():
        console.print(f"[green]✓ already done[/]  {name}")
        return
    console.print(f"[cyan]→ running[/]  {name}" + (" [dim](dry run)[/]" if dry_run else ""))
    if not dry_run:
        result = subprocess.run(step["cmd"], shell=True)
        if result.returncode != 0:
            console.print(f"  [red]failed (exit {result.returncode})[/]")


TOUCH_FILES = [
    Path("~/.gitconfig.local").expanduser(),
    Path("~/.bashrc.local").expanduser(),
    Path("~/.bash_profile.local").expanduser(),
    Path("~/.config/fish/conf.d/local.fish").expanduser(),
    Path("~/.config/fish/conf.d/secrets.fish").expanduser(),
]


def post_install(dry_run: bool) -> None:
    """Touch files that should exist but are never committed."""
    for path in TOUCH_FILES:
        if not path.exists():
            if not dry_run:
                path.parent.mkdir(parents=True, exist_ok=True)
                path.touch()
            console.print(
                f"[green]✓ created[/]  {path}" + (" [dim](dry run)[/]" if dry_run else "")
            )


def get_status(src: Path, dst: Path) -> str:
    if not dst.exists() and not dst.is_symlink():
        return "missing"
    if dst.is_symlink() and dst.resolve() == src.resolve():
        return "linked"
    if dst.is_file() and dst.read_bytes() == src.read_bytes():
        return "identical"
    return "conflict"


def _status_style(state: str) -> tuple[str, str]:
    return {
        "linked": ("green", "✓"),
        "identical": ("cyan", "~"),
        "missing": ("yellow", "?"),
        "conflict": ("red", "!"),
    }.get(state, ("dim", "?"))


def load_steps() -> list[dict]:
    with open(REPO_ROOT / "dotfiles.toml", "rb") as f:
        config = tomllib.load(f)
    return config.get("steps", [])


def load_mappings() -> list[tuple[Path, Path]]:
    with open(REPO_ROOT / "dotfiles.toml", "rb") as f:
        config = tomllib.load(f)
    return [
        (REPO_ROOT / entry["src"], Path(entry["dst"]).expanduser())
        for entry in config.get("files", [])
    ]


if __name__ == "__main__":
    app()
