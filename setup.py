#!/usr/bin/env python3

"""Set up configuration files.

Every file under ./deploy is installed into the corresponding location
relative to the home directory by means of a symlink pointing back into
this repository (e.g. ./deploy/.config/foo/bar -> ~/.config/foo/bar).

Pre-existing files are preserved in a timestamped backup directory unless
they are identical to the file being installed.
"""

import argparse
import os
import shutil
import subprocess
import sys
from datetime import datetime
from pathlib import Path

PROGRAM_NAME = os.path.basename(sys.argv[0])
PROGRAM_VERSION = "2.0"


# Implementing locally to avoid non-stdlib dependencies.


class Colors:
    """ANSI color codes (empty when the terminal cannot handle them)."""

    def __init__(self, enabled):
        self.none = "\033[0m" if enabled else ""
        self.red = "\033[0;31m" if enabled else ""
        self.green = "\033[0;32m" if enabled else ""
        self.orange = "\033[0;33m" if enabled else ""
        self.blue = "\033[0;34m" if enabled else ""
        self.purple = "\033[0;35m" if enabled else ""
        self.cyan = "\033[0;36m" if enabled else ""
        self.yellow = "\033[1;33m" if enabled else ""


COLORS = Colors(
    sys.stderr.isatty()
    and not os.environ.get("NO_COLOR")
    and os.environ.get("TERM", "") != "dumb"
)

VERBOSE_MODE = False


def status_message(filename, status, color):
    print(
        f"{filename:<50}{color}{status}{COLORS.none}",
        file=sys.stderr,
    )


def verbose(*args):
    print(" ".join(str(a) for a in args))


def notice(*args):
    print(
        f"{COLORS.cyan}" + " ".join(str(a) for a in args) + f"{COLORS.none}",
        file=sys.stderr,
    )


def warning(*args):
    print(
        f"{COLORS.yellow}WARNING: " + " ".join(str(a) for a in args) + f"{COLORS.none}",
        file=sys.stderr,
    )


def error(*args):
    print(
        f"{COLORS.red}ERROR: " + " ".join(str(a) for a in args) + f"{COLORS.none}",
        file=sys.stderr,
    )


def fatal(*args):
    error(*args)
    sys.exit(1)


class Runner:
    """Executes (or merely describes) individual changes."""

    def __init__(self, dry_run, do_prompt):
        self.dry_run = dry_run
        self.do_prompt = do_prompt

    def run(self, description, action):
        """Perform `action` (a callable), honoring dry run/prompt modes."""

        if self.dry_run:
            notice("WILL RUN:", description)
            return False

        if self.do_prompt:
            try:
                response = input(f"Run command [ {description} ]? (y/N) ")
            except EOFError:
                response = ""

            if response not in ("y", "Y"):
                return False

        action()
        return True


def same_ignoring_whitespace(path1, path2):
    """Compare two files the way `diff -w` does."""

    try:
        lines1 = path1.read_text(errors="surrogateescape").splitlines()
        lines2 = path2.read_text(errors="surrogateescape").splitlines()
    except OSError:
        return False

    def strip_ws(lines):
        return ["".join(line.split()) for line in lines]

    return strip_ws(lines1) == strip_ws(lines2)


def install_file(src_file, tgt_file, backup_dir, home, runner):
    """Install a single file as a symlink at `tgt_file`."""

    tgt_dir = tgt_file.parent
    link_target = Path(os.path.relpath(src_file, tgt_dir))
    relative_dir = str(tgt_dir.relative_to(Path.cwd()))
    relative_path = str(tgt_file.relative_to(Path.cwd()))

    if tgt_dir.is_symlink() and not tgt_dir.exists():
        warning(f"removing broken symlink {tgt_dir}")
        runner.run(f"rm -f {tgt_dir}", lambda: tgt_dir.unlink())

    if not tgt_dir.is_dir():
        if tgt_dir.exists():
            status_message(
                str(relative_dir), "exists and not a directory (skipping)", COLORS.red
            )
            return

        if not runner.run(
            f"mkdir -p {tgt_dir}", lambda: tgt_dir.mkdir(parents=True, exist_ok=True)
        ):
            # Without the directory there is nothing to inspect - the link
            # would simply be created.
            notice(f"...then: ln -s {link_target} {tgt_file}")
            return

    if tgt_file.is_symlink():
        if os.readlink(tgt_file) == str(link_target):
            if VERBOSE_MODE:
                status_message(relative_path, "already set up", COLORS.green)
            return

        if not tgt_file.exists():
            warning(f"removing broken symlink {tgt_file}")
            runner.run(f"rm -f {tgt_file}", lambda: tgt_file.unlink())

    if tgt_file.is_symlink() or tgt_file.exists():
        if same_ignoring_whitespace(tgt_file, src_file):
            status_message(relative_path, "same as target", COLORS.green)
            runner.run(f"rm -f {tgt_file}", lambda: tgt_file.unlink())
        else:
            backup_file = backup_dir / tgt_file.relative_to(home)
            notice(f"{tgt_file} will be saved to {backup_file}")
            runner.run(
                f"mkdir -p {backup_file.parent}",
                lambda: backup_file.parent.mkdir(parents=True, exist_ok=True),
            )
            runner.run(
                f"mv {tgt_file} {backup_file}",
                lambda: shutil.move(str(tgt_file), str(backup_file)),
            )

    verbose(f"{tgt_file} -> {link_target}")
    runner.run(
        f"ln -s {link_target} {tgt_file}", lambda: tgt_file.symlink_to(link_target)
    )


def install_all(src_dir, home, backup_dir, runner):
    """Install every file found under `src_dir`."""

    for full_path in sorted(p for p in src_dir.rglob("*") if p.is_file()):
        rel_path = full_path.relative_to(src_dir)
        install_file(full_path, home / rel_path, backup_dir, home, runner)


def extra_setup(home, runner):
    """Perform the one-off setup steps unrelated to config file symlinks."""

    i3_workspace = home / ".i3-workspace"

    if not i3_workspace.is_dir():
        runner.run(f"mkdir {i3_workspace}", lambda: i3_workspace.mkdir())

    vundle_dir = home / ".vim" / "bundle" / "Vundle.vim"

    if not vundle_dir.is_dir():
        clone(runner, "https://github.com/VundleVim/Vundle.vim.git", vundle_dir)

    tmux_plugins = home / ".tmux" / "plugins"

    if not tmux_plugins.is_dir():
        clone(runner, "https://github.com/tmux-plugins/tpm", tmux_plugins / "tpm")
        notice("Make sure to run Ctrl-B I from within tmux")


def clone(runner, url, target):
    command = ["git", "clone", url, str(target)]
    runner.run(" ".join(command), lambda: subprocess.run(command, check=True))


def parse_args():
    parser = argparse.ArgumentParser(
        prog=PROGRAM_NAME,
        description=f"{PROGRAM_NAME} sets up configuration files",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "-f",
        dest="force",
        action="store_true",
        help="perform changes (default: dry run)",
    )
    parser.add_argument(
        "-i",
        dest="prompt",
        action="store_true",
        help="prompt interactively for each change",
    )
    parser.add_argument(
        "-v", dest="verbose", action="store_true", help="verbose operation"
    )
    parser.add_argument(
        "-V",
        action="version",
        version=f"{PROGRAM_NAME} {PROGRAM_VERSION}",
        help="display program version",
    )
    return parser.parse_args()


def main():
    global VERBOSE_MODE

    args = parse_args()
    VERBOSE_MODE = args.verbose
    runner = Runner(dry_run=not (args.force or args.prompt), do_prompt=args.prompt)

    src_dir = Path(__file__).resolve().parent / "deploy"

    if not src_dir.is_dir():
        fatal(f"{src_dir} does not exist")

    home = Path.home()
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    backup_dir = home / f"CONFIG_BACKUP.{timestamp}"

    install_all(src_dir, home, backup_dir, runner)
    extra_setup(home, runner)


if __name__ == "__main__":
    main()
