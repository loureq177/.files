#!/usr/bin/env bats
# What stow links, and what it must never link.

load helpers

@test "every referenced ~/.local/bin script exists and is executable" {
    local bad=0 file name
    while IFS=: read -r file name; do
        [[ -x "$REPO/home/.local/bin/$name" ]] || { echo "$file refers to .local/bin/$name, which does not exist" >&2; bad=1; }
    done < <(
        cd "$REPO" && repo_files | grep -v '^tests/' | tr '\n' '\0' |
            xargs -0 grep -IoE '\.local/bin/[A-Za-z0-9_-]+' 2>/dev/null |
            sed -E 's|:\.local/bin/|:|' | sort -u
    )
    [[ "$bad" -eq 0 ]]
}

@test "tracked symlinks point at files that exist" {
    # repo_files skips them (-f follows the link), so nothing else would notice.
    local f bad=0
    while IFS= read -r f; do
        [[ -e "$REPO/$f" ]] || { echo "$f -> $(readlink "$REPO/$f") is broken" >&2; bad=1; }
    done < <(git -C "$REPO" ls-files -s | awk '$1 == 120000 { print $4 }')
    [[ "$bad" -eq 0 ]]
}

@test "stow links every tracked file except the docs" {
    need stow
    # Every directory already present, so nothing hides behind a folded link.
    local target="$BATS_TEST_TMPDIR/target" dir path bad=0
    while IFS= read -r dir; do mkdir -p "$target/$dir"; done < <(cd "$REPO/home" && find . -type d -not -path '*/node_modules*')
    while IFS= read -r path; do
        [[ -n "$path" ]] || continue
        git -C "$REPO" ls-files --error-unmatch "home/$path" >/dev/null 2>&1 || continue
        [[ "$path" =~ ^(.*/)?README\.md$ ]] && continue
        echo "home/$path is tracked but .stowrc keeps stow from linking it" >&2
        bad=1
    done < <((cd "$REPO" && stow --verbose=4 --simulate --target "$target" home 2>&1) |
        sed -n 's/^ *Ignoring path \(.*\) due to .*/\1/p' | sort -u)
    [[ "$bad" -eq 0 ]]
}

@test "stow never links secrets or machine-local files" {
    need stow
    local pkgs="$BATS_TEST_TMPDIR/pkgs" target="$BATS_TEST_TMPDIR/home"
    mkdir -p "$pkgs/fix/.ssh" "$target/.ssh"
    cp "$REPO/.stowrc" "$pkgs/.stowrc"
    local secret=(.env .env.local .env-production .ssh/id_ed25519 .ssh/id_rsa .ssh/id_ed25519.pub .ssh/known_hosts
        .ssh/known_hosts.old service.json config.local .zshrc.local .zsh_history)
    local wanted=(.zshenv .ssh/config.example)
    local f
    for f in "${secret[@]}" "${wanted[@]}"; do : >"$pkgs/fix/$f"; done
    (cd "$pkgs" && stow --target "$target" fix)

    local bad=0
    for f in "${secret[@]}"; do
        [[ ! -e "$target/$f" ]] || { echo "linked although it must stay private: $f" >&2; bad=1; }
    done
    for f in "${wanted[@]}"; do
        [[ -e "$target/$f" ]] || { echo "not linked although it is an ordinary dotfile: $f" >&2; bad=1; }
    done
    [[ "$bad" -eq 0 ]]
}

@test "stowing home leaves no dangling links" {
    need stow
    local target="$BATS_TEST_TMPDIR/target"
    mkdir -p "$target"
    (cd "$REPO" && stow --target "$target" home)
    [[ -z "$(find "$target" -xtype l)" ]] || fail "dangling links:" "$(find "$target" -xtype l)"
}

@test "example files keep their real counterparts out of git" {
    local example real
    while IFS= read -r example; do
        real="${example%.example}"
        git -C "$REPO" check-ignore -q "$real" || fail "$real would be committed (not in .gitignore), but $example suggests it is machine-local"
    done < <(repo_files '*.example')
}
