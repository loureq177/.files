#!/usr/bin/env bash
# Links home/ into ~ with stow. On macOS it installs Homebrew and the Brewfile
# first. Kept to bash 3.2, which is what macOS ships.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]:-$0}")"

if [[ -t 1 ]]; then
    _C_BLUE=$'\033[0;34m' _C_GREEN=$'\033[0;32m' _C_YELLOW=$'\033[0;33m' _C_RED=$'\033[0;31m' _C_NC=$'\033[0m'
else
    _C_BLUE="" _C_GREEN="" _C_YELLOW="" _C_RED="" _C_NC=""
fi
_log_info() { printf '\n%s==>%s %s\n' "$_C_BLUE" "$_C_NC" "$*"; }
_log_ok() { printf '%s✓%s %s\n' "$_C_GREEN" "$_C_NC" "$*"; }
_log_warn() { printf '%s⚠%s  %s\n' "$_C_YELLOW" "$_C_NC" "$*"; }
_log_error() { printf '%s✗%s %s\n' "$_C_RED" "$_C_NC" "$*" >&2; }

case "$(uname -s)" in
Darwin)
    if ! command -v brew &>/dev/null; then
        _log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [ -x /opt/homebrew/bin/brew ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -x /usr/local/bin/brew ]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
    _log_info "Installing the Brewfile..."
    brew bundle --file=Brewfile
    command -v stow &>/dev/null || brew install stow
    ;;
Linux)
    if ! command -v stow &>/dev/null; then
        if command -v pacman &>/dev/null; then
            sudo pacman -S --needed --noconfirm stow
        else
            _log_error "Install stow first."
            exit 1
        fi
    fi
    ;;
*)
    _log_error "Unsupported OS: $(uname -s)"
    exit 1
    ;;
esac

_log_info "Linking home/ into ~..."
mkdir -p ~/.config ~/.local/share ~/.local/state ~/.local/bin ~/.cache
# Real dir, or stow links all of ~/.ssh into the repo and keys end up there
[ -e ~/.ssh ] || mkdir -m 700 ~/.ssh
if ! err="$(stow --simulate --restow --target ~ home 2>&1)"; then
    _log_error "stow pre-flight failed (existing files in the way):"
    printf '%s\n' "$err" >&2
    _log_error "Move them aside or back them up, then re-run."
    exit 1
fi
stow --verbose --restow --target ~ home

if command -v bat &>/dev/null; then
    bat cache --build >/dev/null || _log_warn "bat cache build failed."
fi
# A Firefox that has never run has no profile yet; on the Arch desktop the
# session applies the defaults again at every login.
if command -v firefox &>/dev/null || [ -d "/Applications/Firefox.app" ]; then
    ~/.local/bin/firefox-apply || _log_warn "No Firefox profile yet: run firefox-apply after Firefox has run once."
fi

_log_ok "Done."
