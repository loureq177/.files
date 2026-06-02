export ZDOTDIR="$HOME/.config/zsh"
export PATH="/home/mlorenc/.local/bin:$PATH"
typeset -U path
path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  $path
)

[[ -d "$HOME/.config/herd-lite/bin" ]] && path=("$HOME/.config/herd-lite/bin" $path)
[[ -d "$HOME/.bun/bin" ]] && path=("$HOME/.bun/bin" $path)
[[ -d "$HOME/.lmstudio/bin" ]] && path+=("$HOME/.lmstudio/bin")

export EDITOR='nvim'
export VISUAL='nvim'
[[ -n "$SSH_CONNECTION" ]] && export EDITOR='vim'

if [[ -d "$HOME/.config/herd-lite/bin" && ":${PHP_INI_SCAN_DIR:-}:" != *":$HOME/.config/herd-lite/bin:"* ]]; then
  export PHP_INI_SCAN_DIR="$HOME/.config/herd-lite/bin${PHP_INI_SCAN_DIR:+:$PHP_INI_SCAN_DIR}"
fi

[[ -d "$HOME/.bun/bin" ]] && export BUN_INSTALL="$HOME/.bun"

export GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE="$HOME/.config/gws/client_secret.json"
export GOPATH="$HOME/.go"
