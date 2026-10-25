#!/usr/bin/env bats
# Every file parses with the program that will read it.

load helpers

shebang_files() {
    local f first
    repo_files | while IFS= read -r f; do
        IFS= read -r first <"$REPO/$f" || true
        [[ "$first" =~ ^#!.*[/\ ]($1)($|\ ) ]] && printf '%s\n' "$f"
    done
    return 0
}

# check_each CMD... : run CMD FILE for every file on stdin, report all failures.
check_each() {
    local f out bad=0
    while IFS= read -r f; do
        if ! out="$("$@" "$REPO/$f" 2>&1)"; then
            printf '%s\n%s\n' "FAILED: $f" "$out" >&2
            bad=1
        fi
    done
    return "$bad"
}

@test "scripts in .local/bin are executable and have a shebang" {
    local f first bad=0
    while IFS= read -r f; do
        IFS= read -r first <"$REPO/$f" || true
        [[ -x "$REPO/$f" ]] || { echo "not executable: $f" >&2; bad=1; }
        [[ "$first" == '#!'* ]] || { echo "no shebang: $f" >&2; bad=1; }
    done < <(repo_files 'home/.local/bin/*' install.sh)
    [[ "$bad" -eq 0 ]]
}

@test "bash and sh scripts parse" {
    { shebang_files 'bash'; repo_files '*.sh' '*.bash'; } | sort -u | check_each bash -n
    shebang_files 'sh' | check_each sh -n
}

@test "zsh config parses" {
    need zsh
    repo_files 'home/.zshenv' 'home/.config/zsh/.zshrc' | check_each zsh -n
}

@test "shellcheck finds no warnings" {
    need shellcheck
    cd "$REPO"
    { shebang_files 'bash|sh'; repo_files '*.sh'; } | sort -u |
        check_each shellcheck -S warning -s bash -x -e SC1090,SC1091
}

@test "lua files parse" {
    need luac
    repo_files '*.lua' | check_each luac -p
}

@test "json files parse" {
    repo_files '*.json' | check_each python3 -c 'import json, sys; json.load(open(sys.argv[1], encoding="utf-8"))'
}

@test "toml files parse" {
    repo_files '*.toml' | check_each python3 -c 'import sys, tomllib; tomllib.load(open(sys.argv[1], "rb"))'
}

@test "git config parses" {
    git config --file "$REPO/home/.config/git/config" --list >/dev/null
}

@test "ghostty config is valid" {
    need ghostty
    export HOME="$BATS_TEST_TMPDIR/home"
    mkdir -p "$HOME/.config/ghostty"
    cp -r "$REPO/home/.config/ghostty/." "$HOME/.config/ghostty/"
    run ghostty +validate-config --config-file="$HOME/.config/ghostty/config"
    assert_status 0
}
