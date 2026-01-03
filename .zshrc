# --- [ Environment & Path ] ---
export PATH="$HOME/.cargo/bin:$PATH"
export EDITOR='nvim'
[ -n "$SSH_CONNECTION" ] && export EDITOR='vim'

# --- [ Zinit Setup ] ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# --- [ Shell Integrations (Binary Tools) ] ---
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

# --- [ Load Plugins (Before Compinit) ] ---
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab
zinit wait lucid for zsh-users/zsh-autosuggestions

# --- [ Autoload & Compinit ] ---
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# --- [ Completion Styling ] ---
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# --- [ Syntax Highlighting (MUST BE LAST PLUGIN) ] ---
zinit light zsh-users/zsh-syntax-highlighting

# --- [ Prompt (Starship) ] ---
eval "$(starship init zsh)"

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
alias cd="z"
alias vim="nvim"
alias ls="eza --icons -l"
alias cat="bat"
alias l="eza -lah --icons" 

# --- [ Functions ] ---
zshaddhistory() {
    local line="${1%%$'\n'}"
    case "$line" in
        ls|l|clear|exit|history) return 1 ;;
        *) return 0 ;;
    esac
}
