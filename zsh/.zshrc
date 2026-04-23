# --- [ Environment & Path ] ---
# (Wszystkie ścieżki muszą być ustawione jako pierwsze, by reszta skryptów je widziała)
export PATH="$HOME/.cargo/bin:$PATH"
export EDITOR='nvim'
export VISUAL='nvim'
[ -n "$SSH_CONNECTION" ] && export EDITOR='vim'

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/home/mlorenc/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/mlorenc/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
export PATH="$PATH:/home/mlorenc/.lmstudio/bin"

if [ -f '/home/mlorenc/Downloads/google-cloud-cli-linux-x86_64/google-cloud-sdk/path.zsh.inc' ]; then . '/home/mlorenc/Downloads/google-cloud-cli-linux-x86_64/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '/home/mlorenc/Downloads/google-cloud-cli-linux-x86_64/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/mlorenc/Downloads/google-cloud-cli-linux-x86_64/google-cloud-sdk/completion.zsh.inc'; fi
export GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE=~/.config/gws/client_secret.json

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# --- [ Zinit Setup ] ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# --- [ Completions (MUST be before compinit) ] ---
zinit light zsh-users/zsh-completions
[ -s "/home/mlorenc/.bun/_bun" ] && source "/home/mlorenc/.bun/_bun"

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
# alias cd="z"  # (wyłączone) cd jest obsługiwane przez zoxide --cmd cd
alias ls="eza -l --icons --no-user"
alias l="eza -laB --icons" 
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
