#!/usr/bin/env python3
"""
Create a single squashed patch for the current git branch by cloning the repo to
/tmp, squashing the feature branch there, generating a format-patch against the
repo's default branch, and copying the patch back to the current repo root.

Intended to be installed somewhere on PATH and run from inside a git working
copy.
"""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Optional


class CommandError(RuntimeError):
    pass


def run(
    args: list[str],
    *,
    cwd: Optional[Path] = None,
    capture: bool = True,
    check: bool = True,
) -> subprocess.CompletedProcess[str]:
    result = subprocess.run(
        args,
        cwd=str(cwd) if cwd else None,
        text=True,
        capture_output=capture,
    )
    if check and result.returncode != 0:
        cmd = " ".join(args)
        raise CommandError(
            f"Command failed ({result.returncode}): {cmd}\n"
            f"stdout:\n{result.stdout}\n"
            f"stderr:\n{result.stderr}"
        )
    return result



def git(*args: str, cwd: Optional[Path] = None, capture: bool = True) -> str:
    result = run(["git", *args], cwd=cwd, capture=capture)
    return result.stdout.strip()



def ensure_git_repo() -> Path:
    try:
        top = git("rev-parse", "--show-toplevel")
    except CommandError as exc:
        raise SystemExit("Not inside a git repository.") from exc
    return Path(top)



def current_branch(repo: Path) -> str:
    branch = git("rev-parse", "--abbrev-ref", "HEAD", cwd=repo)
    if branch == "HEAD":
        raise SystemExit("Detached HEAD is not supported.")
    return branch



def remote_url(repo: Path, remote: str) -> str:
    return git("remote", "get-url", remote, cwd=repo)



def remote_default_branch(repo: Path, remote: str) -> str:
    # Prefer the remote HEAD ref if available.
    try:
        ref = git("symbolic-ref", f"refs/remotes/{remote}/HEAD", cwd=repo)
        prefix = f"refs/remotes/{remote}/"
        if ref.startswith(prefix):
            return ref[len(prefix) :]
    except CommandError:
        pass

    # Fallback to parsing `git remote show`.
    try:
        output = git("remote", "show", remote, cwd=repo)
        for line in output.splitlines():
            stripped = line.strip()
            if stripped.startswith("HEAD branch:"):
                return stripped.split(":", 1)[1].strip()
    except CommandError:
        pass

    for candidate in ("main", "master"):
        try:
            git("show-ref", "--verify", f"refs/remotes/{remote}/{candidate}", cwd=repo)
            return candidate
        except CommandError:
            continue

    raise SystemExit(f"Could not determine default branch for remote '{remote}'.")



def clone_repo(url: str, destination: Path) -> Path:
    run(["git", "clone", url, str(destination)], capture=True)
    return destination



def fetch_branch(repo: Path, remote: str, branch: str) -> None:
    run(["git", "fetch", remote, branch], cwd=repo, capture=True)



def checkout_branch(repo: Path, remote: str, branch: str) -> None:
    remote_ref = f"{remote}/{branch}"
    run(["git", "checkout", "-B", branch, remote_ref], cwd=repo, capture=True)



def working_tree_clean(repo: Path) -> bool:
    return git("status", "--porcelain", cwd=repo) == ""



def squash_branch(repo: Path, remote: str, default_branch: str, feature_branch: str, message: str) -> None:
    merge_base = git("merge-base", f"{remote}/{default_branch}", feature_branch, cwd=repo)
    run(["git", "reset", "--soft", merge_base], cwd=repo, capture=True)
    # Commit all changes as one squashed commit.
    run(["git", "commit", "-m", message], cwd=repo, capture=True)



def generate_patch(repo: Path, remote: str, default_branch: str, output_dir: Path) -> Path:
    output_dir.mkdir(parents=True, exist_ok=True)
    before = {p.name for p in output_dir.iterdir() if p.is_file()}

    run(
        [
            "git",
            "format-patch",
            "-o",
            str(output_dir),
            f"{remote}/{default_branch}..HEAD",
        ],
        cwd=repo,
        capture=True,
    )

    after = [p for p in output_dir.iterdir() if p.is_file() and p.name not in before]
    if not after:
        raise SystemExit("No patch file was generated.")
    if len(after) != 1:
        names = ", ".join(sorted(p.name for p in after))
        raise SystemExit(f"Expected exactly one patch file, got {len(after)}: {names}")
    return after[0]



def copy_patch_to_repo(patch_file: Path, destination_repo: Path, rename_to: Optional[str]) -> Path:
    destination = destination_repo / (rename_to or patch_file.name)
    shutil.copy2(patch_file, destination)
    return destination



def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Squash current branch in a temp clone, generate a patch, and copy it back here."
    )
    parser.add_argument("--remote", default="origin", help="Remote to use. Default: origin")
    parser.add_argument(
        "--commit-message",
        default=None,
        help="Commit message for the squashed commit. Default: 'Squashed <branch>'",
    )
    parser.add_argument(
        "--output-name",
        default=None,
        help="Optional filename to use when copying the patch into the current repo root.",
    )
    parser.add_argument(
        "--keep-temp",
        action="store_true",
        help="Keep the temporary clone directory instead of deleting it.",
    )
    return parser.parse_args()



def main() -> int:
    args = parse_args()
    source_repo = ensure_git_repo()

    if not working_tree_clean(source_repo):
        print(
            "Warning: current repository has uncommitted changes. "
            "The patch will still be copied into the repo root.",
            file=sys.stderr,
        )

    branch = current_branch(source_repo)
    url = remote_url(source_repo, args.remote)
    default_branch = remote_default_branch(source_repo, args.remote)

    if branch == default_branch:
        raise SystemExit(
            f"Current branch '{branch}' is the same as the default branch; nothing to squash."
        )

    commit_message = args.commit_message or f"Squashed {branch}"

    temp_parent = Path(tempfile.mkdtemp(prefix="git-squash-patch-", dir="/tmp"))
    clone_dir = temp_parent / "repo"

    try:
        clone_repo(url, clone_dir)
        fetch_branch(clone_dir, args.remote, branch)
        checkout_branch(clone_dir, args.remote, branch)
        squash_branch(clone_dir, args.remote, default_branch, branch, commit_message)

        patch_dir = temp_parent / "patches"
        patch_file = generate_patch(clone_dir, args.remote, default_branch, patch_dir)
        copied_to = copy_patch_to_repo(patch_file, source_repo, args.output_name)

        print(f"Repo URL: {url}")
        print(f"Default branch: {default_branch}")
        print(f"Feature branch: {branch}")
        print(f"Patch created: {patch_file}")
        print(f"Patch copied to: {copied_to}")
    finally:
        if args.keep_temp:
            print(f"Kept temp directory: {temp_parent}", file=sys.stderr)
        else:
            shutil.rmtree(temp_parent, ignore_errors=True)

    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except CommandError as exc:
        print(str(exc), file=sys.stderr)
        raise SystemExit(1)
