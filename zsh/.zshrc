# --- [ Environment & Path ] ---
# (Wszystkie ścieżki muszą być ustawione jako pierwsze, by reszta skryptów je widziała)
# Keep PATH clean (dedupe while preserving first-occurrence order).
typeset -U path

export EDITOR='nvim'
export VISUAL='nvim'
[[ -n "$SSH_CONNECTION" ]] && export EDITOR='vim'

# Prefer user-level bins early.
path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  $path
)

# Herd Lite (PHP + composer)
if [[ -d "$HOME/.config/herd-lite/bin" ]]; then
  path=("$HOME/.config/herd-lite/bin" $path)
  # Ensure herd-lite's ini scan dir is present exactly once.
  if [[ ":${PHP_INI_SCAN_DIR:-}:" != *":$HOME/.config/herd-lite/bin:"* ]]; then
    export PHP_INI_SCAN_DIR="$HOME/.config/herd-lite/bin${PHP_INI_SCAN_DIR:+:$PHP_INI_SCAN_DIR}"
  fi
fi

# Bun: only wire local install when it exists (system bun lives in /usr/bin).
if [[ -d "$HOME/.bun/bin" ]]; then
  export BUN_INSTALL="$HOME/.bun"
  path=("$BUN_INSTALL/bin" $path)
fi

# LM Studio
[[ -d "$HOME/.lmstudio/bin" ]] && path+=("$HOME/.lmstudio/bin")

# Drop non-existent PATH entries (they often leak in from the desktop session).
typeset -a _path_clean
_path_clean=()
for _p in $path; do
  [[ -d "$_p" ]] && _path_clean+=("$_p")
done
path=("${_path_clean[@]}")
unset _path_clean _p

export GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE="$HOME/.config/gws/client_secret.json"

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# --- [ Zinit Setup ] ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# If a plugin manager is also managing $plugins, avoid accidental double-loading.
unset plugins

# --- [ Completions (MUST be before compinit) ] ---
zinit light zsh-users/zsh-completions
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# --- [ Autoload & Compinit ] ---
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# --- [ Shell Integrations & Prompts ] ---
eval "$(starship init zsh)"
eval "$(zoxide init zsh --cmd cd)"

# Prefer standard cd completion (so fzf-tab can enhance it)
(( ${+functions[compdef]} )) && compdef _cd cd
eval "$(fzf --zsh)"

# --- [ Configuration & Keybindings ] ---
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# --- [ Aliases ] ---
alias ls="eza -l --icons --group-directories-first --no-user"
alias l="eza -laB --icons --group-directories-first" 
alias cat="bat -pp"
alias grep="rg"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# --- [ Functions ] ---
zshaddhistory() {
    local line="${1%%$'\n'}"
    case "$line" in
        ls|l|clear|exit|history) return 1 ;;
        *) return 0 ;;
    esac
}

# --- [ Completion Styling ] ---
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'command ls --color=auto -- "$realpath"'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'command ls --color=auto -- "$realpath"'

zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

# >>> forge initialize >>>
# !! Contents within this block are managed by 'forge zsh setup' !!
# !! Do not edit manually - changes will be overwritten !!

# Load forge shell plugin (commands, completions, keybindings) if not already loaded
if [[ -z "$_FORGE_PLUGIN_LOADED" ]]; then
    eval "$(forge zsh plugin)"
fi

# Load forge shell theme (prompt with AI context) if not already loaded
if [[ -z "$_FORGE_THEME_LOADED" ]]; then
    eval "$(forge zsh theme)"
fi
# <<< forge initialize <<<

# Tab dispatch: keep fzf-tab as default, but allow forge-completion when it applies
function __tab_complete_dispatch() {
    local current_word="${LBUFFER##* }"
    if (( ${+functions[forge-completion]} )) && { [[ "$current_word" == @* ]] || [[ "${LBUFFER}" =~ "^:([a-zA-Z][a-zA-Z0-9_-]*)?$" ]]; }; then
        zle forge-completion
    elif (( ${+functions[fzf-tab-complete]} )); then
        zle fzf-tab-complete
    else
        zle expand-or-complete
    fi
}
zle -N __tab_complete_dispatch
bindkey '^I' __tab_complete_dispatch
