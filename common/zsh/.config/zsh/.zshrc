typeset -U path
path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  $path
)

[[ -d "$HOME/.config/herd-lite/bin" ]] && path=("$HOME/.config/herd-lite/bin" $path)
[[ -d "$HOME/.bun/bin" ]] && path=("$HOME/.bun/bin" $path)
[[ -d "$HOME/.lmstudio/bin" ]] && path+=("$HOME/.lmstudio/bin")

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
export BAT_THEME="tokyonight_moon"

export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git --type d'
export FZF_CTRL_T_OPTS='--preview "bat --color=always --style=numbers --line-range=:500 {}"'
export FZF_ALT_C_OPTS='--preview "eza -T -L 3 --icons --color=always {}"'

HISTSIZE=10000
HISTFILE="$ZDOTDIR/.zsh_history"
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt extended_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

setopt auto_cd
setopt auto_push_d
setopt push_d_ignore_dups

zshaddhistory() {
    local line="${1%%$'\n'}"
    case "$line" in
        ls|l|clear|exit|history) return 1 ;;
        *) return 0 ;;
    esac
}

alias ls="eza -l --icons --group-directories-first --no-user --no-time --no-permissions --no-filesize --color=always --git"
alias l="eza -laB --icons --group-directories-first"
alias cat="bat -pp"
alias grep="rg"
alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"
alias ......="cd ../../../../../"

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

fpath=(~/.config/zsh/functions $fpath)

zinit light zsh-users/zsh-completions

autoload -Uz compinit
setopt extended_glob
local -a zcompdump_stale=("$ZDOTDIR/.zcompdump"(#qN.mh+24))
unsetopt extended_glob

if (( ${#zcompdump_stale} )); then
  compinit -d "$ZDOTDIR/.zcompdump"
else
  compinit -C -d "$ZDOTDIR/.zcompdump"
fi

if [[ -s "$ZDOTDIR/.zcompdump" && (! -s "$ZDOTDIR/.zcompdump.zwc" || "$ZDOTDIR/.zcompdump" -nt "$ZDOTDIR/.zcompdump.zwc") ]]; then
  zcompile "$ZDOTDIR/.zcompdump"
fi

[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

[[ -f ~/.config/zsh/.dircolors.zsh ]] && source ~/.config/zsh/.dircolors.zsh

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*:*:*:*:processes' command 'ps -ef'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'command ls --color=auto -- "$realpath"'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'command ls --color=auto -- "$realpath"'

zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

[[ -f ~/.config/zsh/.starship.zsh ]] && source ~/.config/zsh/.starship.zsh
[[ -f ~/.config/zsh/.zoxide.zsh ]] && source ~/.config/zsh/.zoxide.zsh
[[ -f ~/.config/zsh/.fzf.zsh ]] && source ~/.config/zsh/.fzf.zsh

(( ${+functions[compdef]} )) && compdef _cd cd

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

function __tab_complete_dispatch() {
    if (( ${+functions[fzf-tab-complete]} )); then
        zle fzf-tab-complete
    else
        zle expand-or-complete
    fi
}
zle -N __tab_complete_dispatch
bindkey '^I' __tab_complete_dispatch

if [ -z "${DISPLAY}" ] && [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec start-hyprland
fi

ssh-add -l &>/dev/null || ssh-add
