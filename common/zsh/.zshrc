export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
export BAT_THEME="tokyonight_moon"

export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git --type d'
export FZF_CTRL_T_OPTS='--preview "bat --color=always --style=numbers --line-range=:500 {}"'
export FZF_ALT_C_OPTS='--preview "eza -T -L 3 --icons --color=always {}"'

HISTSIZE=10000
HISTFILE=~/.zsh_history
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

fpath=(~/.zfunc $fpath)

autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

command -v dircolors >/dev/null 2>&1 && eval "$(dircolors -b)"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*:*:*:*:processes' command 'ps -ef'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'command ls --color=auto -- "$realpath"'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'command ls --color=auto -- "$realpath"'

zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab

zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light zdharma-continuum/fast-syntax-highlighting

command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd cd)"
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

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

if [[ -d "/opt/google-cloud-cli" ]]; then
  source "/opt/google-cloud-cli/path.zsh.inc"
  source "/opt/google-cloud-cli/completion.zsh.inc"
fi

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec start-hyprland
fi

alias lava="lavat -gGk f9a600 -c a00000"
lavat() {
    local base_color=$(pastel random -n 1 | pastel saturate 1 | pastel darken 1)
    local angle=$(( 135 + RANDOM % 186 ))

    local rim=$(pastel rotate "$angle" "$base_color" | pastel lighten .64)
    local bubble=$(echo "$base_color" | pastel lighten .44)

    local bubble=$(echo "$bubble" | pastel format hex | tr -d '#')
    local rim=$(echo "$rim" | pastel format hex | tr -d '#')

    command lavat -Ggs7 -R1 -r8 -b12 -c "$bubble" -k "$rim" $*
}
