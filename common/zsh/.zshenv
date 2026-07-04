export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

ZDOTDIR="$XDG_CONFIG_HOME/zsh"
HISTFILE="$ZDOTDIR/.zsh_history"

export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export BUN_INSTALL="${XDG_DATA_HOME}/bun"
export NIMBLE_DIR="${XDG_DATA_HOME}/nimble"
export IPYTHONDIR="${XDG_CONFIG_HOME}/ipython"
export WGET_HSTS="${XDG_DATA_HOME}/wget-hsts"
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm"
export CUDA_CACHE_PATH="${XDG_CACHE_HOME}/nv"
export KERAS_HOME="${XDG_CONFIG_HOME}/keras"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java"
[[ -n "$XDG_RUNTIME_DIR" ]] && export PULSE_COOKIE="${XDG_RUNTIME_DIR}/pulse-cookie"

export PATH="$HOME/.local/bin:${CARGO_HOME}/bin:${BUN_INSTALL}/bin:$PATH"

export EDITOR='nvim'
export VISUAL='nvim'

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

[[ -n "$SSH_CONNECTION" ]] && export EDITOR='vim'

if [[ -d "$HOME/.config/herd-lite/bin" && ":${PHP_INI_SCAN_DIR:-}:" != *":$HOME/.config/herd-lite/bin:"* ]]; then
  export PHP_INI_SCAN_DIR="$HOME/.config/herd-lite/bin${PHP_INI_SCAN_DIR:+:$PHP_INI_SCAN_DIR}"
fi

export NSS_DEFAULT_DB_DIR="${XDG_DATA_HOME}/pki/nssdb"
export MATLAB_USERDIR="${XDG_CONFIG_HOME}/matlab"

export GOPATH="${XDG_DATA_HOME}/go"
export GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE="$HOME/.config/gws/client_secret.json"

