# --- [ Environment & Path ] ---
export PATH="$HOME/.cargo/bin:$PATH"
export EDITOR='nvim'
export VISUAL='nvim'
[ -n "$SSH_CONNECTION" ] && export EDITOR='vim'

# --- [ Zinit Setup ] ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# --- [ Shell Integrations (Binary Tools) ] ---
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
alias ls="eza -l --icons --no-user"
alias l="eza -laB --icons" 
alias cat="bat -pp"
alias grep="rg"

# Dirs
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

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# bun completions
[ -s "/home/mlorenc/.bun/_bun" ] && source "/home/mlorenc/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/home/mlorenc/.config/herd-lite/bin:$PATH"

# Laravel
export PHP_INI_SCAN_DIR="/home/mlorenc/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/mlorenc/.lmstudio/bin"
# End of LM Studio CLI section


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/mlorenc/Downloads/google-cloud-cli-linux-x86_64/google-cloud-sdk/path.zsh.inc' ]; then . '/home/mlorenc/Downloads/google-cloud-cli-linux-x86_64/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/mlorenc/Downloads/google-cloud-cli-linux-x86_64/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/mlorenc/Downloads/google-cloud-cli-linux-x86_64/google-cloud-sdk/completion.zsh.inc'; fi
export GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE=~/.config/gws/client_secret.json
