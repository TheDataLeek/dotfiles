from pathlib import Path

import pytest

import main


def test_get_status_missing(tmp_path):
    src = tmp_path / "src.conf"
    src.write_text("content")
    dst = tmp_path / "dst.conf"
    assert main.get_status(src, dst) == "missing"


def test_get_status_linked(tmp_path):
    src = tmp_path / "src.conf"
    src.write_text("content")
    dst = tmp_path / "dst.conf"
    dst.symlink_to(src)
    assert main.get_status(src, dst) == "linked"


def test_get_status_identical(tmp_path):
    src = tmp_path / "src.conf"
    src.write_text("content")
    dst = tmp_path / "dst.conf"
    dst.write_text("content")
    assert main.get_status(src, dst) == "identical"


def test_get_status_conflict(tmp_path):
    src = tmp_path / "src.conf"
    src.write_text("repo content")
    dst = tmp_path / "dst.conf"
    dst.write_text("existing content")
    assert main.get_status(src, dst) == "conflict"


def test_link_file_missing_creates_symlink(tmp_path):
    src = tmp_path / "src.conf"
    src.write_text("content")
    dst = tmp_path / "subdir" / "dst.conf"
    main.link_file(src, dst, dry_run=False)
    assert dst.is_symlink()
    assert dst.resolve() == src.resolve()


def test_link_file_missing_dry_run(tmp_path):
    src = tmp_path / "src.conf"
    src.write_text("content")
    dst = tmp_path / "dst.conf"
    main.link_file(src, dst, dry_run=True)
    assert not dst.exists()


def test_link_file_already_linked_is_noop(tmp_path):
    src = tmp_path / "src.conf"
    src.write_text("content")
    dst = tmp_path / "dst.conf"
    dst.symlink_to(src)
    main.link_file(src, dst, dry_run=False)
    assert dst.is_symlink() and dst.resolve() == src.resolve()


def test_link_file_identical_replaces_with_symlink(tmp_path):
    src = tmp_path / "src.conf"
    src.write_text("content")
    dst = tmp_path / "dst.conf"
    dst.write_text("content")
    main.link_file(src, dst, dry_run=False)
    assert dst.is_symlink()
    assert dst.resolve() == src.resolve()


def test_link_file_conflict_skip(tmp_path, monkeypatch):
    src = tmp_path / "src.conf"
    src.write_text("repo")
    dst = tmp_path / "dst.conf"
    dst.write_text("existing")
    monkeypatch.setattr(main, "prompt_action", lambda: "s")
    main.link_file(src, dst, dry_run=False)
    assert not dst.is_symlink()
    assert dst.read_text() == "existing"


def test_link_file_conflict_backup_and_link(tmp_path, monkeypatch):
    src = tmp_path / "src.conf"
    src.write_text("repo")
    dst = tmp_path / "dst.conf"
    dst.write_text("existing")
    monkeypatch.setattr(main, "prompt_action", lambda: "b")
    main.link_file(src, dst, dry_run=False)
    assert dst.is_symlink()
    bak = dst.with_suffix(".conf.bak")
    assert bak.read_text() == "existing"


def test_run_step_skips_when_skip_if_exists(tmp_path):
    marker = tmp_path / "already_there"
    marker.mkdir()
    step = {"name": "Test step", "cmd": "false", "skip_if": str(marker)}
    main.run_step(step, dry_run=False)  # would fail if cmd ran (exit 1)


def test_run_step_dry_run_does_not_exec(tmp_path):
    marker = tmp_path / "not_there"
    sentinel = tmp_path / "sentinel"
    step = {"name": "Test step", "cmd": f"touch {sentinel}", "skip_if": str(marker)}
    main.run_step(step, dry_run=True)
    assert not sentinel.exists()


def test_run_step_runs_cmd(tmp_path):
    sentinel = tmp_path / "sentinel"
    step = {"name": "Test step", "cmd": f"touch {sentinel}"}
    main.run_step(step, dry_run=False)
    assert sentinel.exists()


def test_load_mappings(tmp_path, monkeypatch):
    (tmp_path / "dotfiles.toml").write_text(
        '[[files]]\nsrc = "foo.conf"\ndst = "~/.foo.conf"\n'
    )
    (tmp_path / "foo.conf").write_text("x")
    monkeypatch.setattr(main, "REPO_ROOT", tmp_path)
    mappings = main.load_mappings()
    assert len(mappings) == 1
    assert mappings[0][0] == tmp_path / "foo.conf"
    assert mappings[0][1] == Path("~/.foo.conf").expanduser()
