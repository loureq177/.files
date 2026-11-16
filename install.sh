#!/usr/bin/env bash
# Links home/ into ~ with stow, after the programs: the Brewfile (and Homebrew) on
# macOS, packages-arch.txt on Arch. Kept to bash 3.2, which is what macOS ships.
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
    if command -v pacman &>/dev/null; then
        _log_info "Installing packages-arch.txt..."
        grep -vE '^[[:space:]]*(#|$)' packages-arch.txt | sudo pacman -S --needed --noconfirm -
    elif ! command -v stow &>/dev/null; then
        _log_error "Install stow first (and the programs of packages-arch.txt)."
        exit 1
    fi
    ;;
*)
    _log_error "Unsupported OS: $(uname -s)"
    exit 1
    ;;
esac

# macOS: kanata from its release with the Karabiner driver it was built for; raise both at once
# (1.13 needs the driver v8). Not from brew, so no upgrade splits them; a failed start leaves the keys as they are.
KANATA_VERSION=1.12.0
DRIVER_VERSION=6.2.0
DRIVER_ID=org.pqrs.Karabiner-DriverKit-VirtualHIDDevice

_sha256_is() { [ "$(shasum -a 256 "$1" | cut -d' ' -f1)" = "$2" ] || { _log_error "Checksum mismatch: $1"; return 1; }; }

# LABEL, the plist on stdin: written when it differs, then loaded.
_launch_daemon() {
    local plist="/Library/LaunchDaemons/$1.plist" new
    new="$(cat)"
    if [ "$(cat "$plist" 2>/dev/null)" != "$new" ]; then
        printf '%s\n' "$new" | sudo tee "$plist" >/dev/null
        sudo chown root:wheel "$plist"
        sudo launchctl bootout "system/$1" 2>/dev/null || true
    fi
    sudo launchctl print "system/$1" &>/dev/null || sudo launchctl bootstrap system "$plist"
}

macos_kanata() {
    local arch sum tmp bin=/usr/local/bin/kanata
    case "$(uname -m)" in
    arm64) arch=arm64 sum=839769d189911b5881e11550eaa2039705213fb725865d088f5a2e3a6c10de32 ;;
    *) arch=x64 sum=bdb8b2f7ae2a648336a2561c7c6c00a736cd76e012035df651114b304c5ffb01 ;;
    esac
    tmp="$(mktemp -d)"
    _log_info "kanata $KANATA_VERSION and its driver $DRIVER_VERSION..."
    # Two grabbers fight over the keyboard; Karabiner-Elements takes its own driver with it.
    if brew list --cask karabiner-elements &>/dev/null; then
        brew uninstall --cask karabiner-elements
    fi
    if brew list --formula kanata &>/dev/null; then
        brew unpin kanata 2>/dev/null || true
        brew uninstall --formula kanata
    fi
    if [ "$(pkgutil --pkg-info "$DRIVER_ID" 2>/dev/null | awk '/^version:/ { print $2 }')" != "$DRIVER_VERSION" ]; then
        curl -fsSL -o "$tmp/driver.pkg" "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v$DRIVER_VERSION/Karabiner-DriverKit-VirtualHIDDevice-$DRIVER_VERSION.pkg"
        _sha256_is "$tmp/driver.pkg" 9e8c46239f0748161241e42444857901224e5c82f5b58a1731df4c70bf0736a8 || return 1
        sudo installer -pkg "$tmp/driver.pkg" -target / || return 1
    fi
    sudo /Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate
    _launch_daemon org.pqrs.Karabiner-VirtualHIDDevice-Daemon <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>org.pqrs.Karabiner-VirtualHIDDevice-Daemon</string>
  <key>ProgramArguments</key><array><string>/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon</string></array>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><true/>
</dict></plist>
EOF
    if [ "$("$bin" --version 2>/dev/null | awk '{ print $2 }')" != "$KANATA_VERSION" ]; then
        curl -fsSL -o "$tmp/kanata.zip" "https://github.com/jtroo/kanata/releases/download/v$KANATA_VERSION/macos-binaries-$arch.zip"
        _sha256_is "$tmp/kanata.zip" "$sum" || return 1
        unzip -q -o "$tmp/kanata.zip" "kanata_macos_$arch" -d "$tmp" || return 1
        sudo install -d /usr/local/bin
        sudo install -m 755 "$tmp/kanata_macos_$arch" "$bin" || return 1
        sudo launchctl kickstart -k system/local.kanata 2>/dev/null || true
    fi
    rm -rf "$tmp"
    # Started again only after a crash: left Control+Space+Escape stops it until the next boot.
    _launch_daemon local.kanata <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>local.kanata</string>
  <key>ProgramArguments</key><array>
    <string>$bin</string><string>--nodelay</string><string>--cfg</string><string>$HOME/.config/kanata/kanata.kbd</string>
  </array>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><dict><key>SuccessfulExit</key><false/></dict>
</dict></plist>
EOF
    sleep 3
    if pgrep -x kanata >/dev/null; then
        _log_ok "kanata is running."
    else
        _log_warn "kanata is not running yet. Once, by hand: turn on the driver in Login Items & Extensions, Driver Extensions, and $bin in Privacy & Security, Input Monitoring (+). It starts by itself after that."
        systemextensionsctl list 2>/dev/null | grep -i pqrs || true
        open "x-apple.systempreferences:com.apple.LoginItems-Settings.extension" || true
        open "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent" || true
    fi
}

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

# After stow: the daemon reads ~/.config/kanata/kanata.kbd.
[ "$(uname -s)" = Darwin ] && { macos_kanata || _log_warn "kanata failed to install: the keys stay as they are."; }

# Language servers for Claude Code; Lua's and TypeScript's come with the packages above
_log_info "Installing language servers..."
uv tool install pyrefly || _log_warn "pyrefly failed to install."
npm install -g --prefix ~/.local --loglevel=error intelephense >/dev/null || _log_warn "intelephense failed to install."
if command -v claude &>/dev/null; then
    claude plugin marketplace add anthropics/claude-plugins-official >/dev/null || _log_warn "Claude Code's official marketplace failed to add."
    claude plugin marketplace add "$PWD/claude-plugins" >/dev/null || _log_warn "Claude Code's claude-plugins marketplace failed to add."
    plugins="lua-lsp@claude-plugins-official php-lsp@claude-plugins-official typescript-lsp@claude-plugins-official pyrefly-lsp@files"
    [ "$(uname -s)" = Linux ] && plugins="$plugins qml-lsp@files"
    for p in $plugins; do
        claude plugin install "$p" >/dev/null || _log_warn "Claude Code plugin $p failed to install."
    done
fi

# zsh reads .zshenv (ZDOTDIR) only as the login shell; macOS has it already.
zsh_path="$(command -v zsh || true)"
if [ "$(uname -s)" = Linux ] && [ -n "$zsh_path" ] && [ "$(getent passwd "$USER" | cut -d: -f7)" != "$zsh_path" ]; then
    _log_info "Making zsh the login shell..."
    sudo chsh -s "$zsh_path" "$USER" || _log_warn "Failed to change the login shell to zsh."
fi

if command -v bat &>/dev/null; then
    bat cache --build >/dev/null || _log_warn "bat cache build failed."
fi
# A Firefox that has never run has no profile yet; on the Arch desktop the
# session applies the defaults again at every login.
if command -v firefox &>/dev/null || [ -d "/Applications/Firefox.app" ]; then
    ~/.local/bin/firefox-apply || _log_warn "No Firefox profile yet: run firefox-apply after Firefox has run once."
fi

_log_ok "Done."
