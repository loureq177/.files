ZDOTDIR="$HOME/.config/zsh"
HISTFILE="$ZDOTDIR/.zsh_history"
export PATH="$HOME/.local/bin:$PATH"

export EDITOR='nvim'
export VISUAL='nvim'

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
[[ -n "$SSH_CONNECTION" ]] && export EDITOR='vim'

if [[ -d "$HOME/.config/herd-lite/bin" && ":${PHP_INI_SCAN_DIR:-}:" != *":$HOME/.config/herd-lite/bin:"* ]]; then
  export PHP_INI_SCAN_DIR="$HOME/.config/herd-lite/bin${PHP_INI_SCAN_DIR:+:$PHP_INI_SCAN_DIR}"
fi

[[ -d "$HOME/.bun/bin" ]] && export BUN_INSTALL="$HOME/.bun"

export GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE="$HOME/.config/gws/client_secret.json"
export GOPATH="$HOME/.go"

# bun completions
[ -s "/home/mlorenc/.bun/_bun" ] && source "/home/mlorenc/.bun/_bun"
