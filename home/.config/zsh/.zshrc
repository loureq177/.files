typeset -U path
[[ -d "$HOME/.config/herd-lite/bin" ]] && path=("$HOME/.config/herd-lite/bin" $path)
[[ -d "${BUN_INSTALL}/bin" ]] && path=("${BUN_INSTALL}/bin" $path)

export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git --type d'
export FZF_CTRL_T_OPTS='--no-height --preview "bat --color=always --style=numbers --line-range=:500 {}" --multi'
export FZF_ALT_C_OPTS='--no-height --preview "eza -T -L 3 --icons --color=always {}"'
# The ui.toml palette, by hand: macOS has no apply-ui.
fzf_colors='bg+:#21262d,bg:#0d1117,fg:#c9d1d9,hl:#58a6ff,fg+:#c9d1d9,hl+:#58a6ff,header:#58a6ff,info:#8b949e,pointer:#58a6ff,marker:#3fb950,prompt:#58a6ff,spinner:#58a6ff,border:#30363d'
export FZF_DEFAULT_OPTS="--layout=reverse --border --info=inline --bind 'ctrl-/:toggle-preview' --color=${fzf_colors}"

HISTFILE="${ZSH_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/zsh}/history"
[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}"
ZCOMP_DUMP="${ZSH_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/zsh}/.zcompdump"
HISTSIZE=10000
SAVEHIST=10000
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
alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"
alias ......="cd ../../../../../"

alias -s {txt,md,json,yaml,yml,toml,conf,ini,cfg,log,env,bash,zsh,lua,py,rb,js,ts,jsx,tsx,c,h,cpp,hpp,go,rs,tex,css,scss,sass,gitignore,editorconfig,xml,sql,svelte,vue}=nvim
if [[ "${OSTYPE:-}" == darwin* ]]; then
    alias -s html='open'
    alias -s {pdf,PDF}=open
    alias -s {png,jpg,jpeg,webp,gif,bmp,svg}=open
    alias -s {mp4,mov,avi,mkv,webm,MP4,MOV}=open
else
    alias -s html='firefox'
    alias -s {pdf,PDF}=firefox
    alias -s {png,jpg,jpeg,webp,gif,bmp,svg}=xdg-open
    alias -s {mp4,mov,avi,mkv,webm,MP4,MOV}=xdg-open
fi
alias -s {zip,rar,7z,tar,gz,xz,bz2,iso}=yazi

ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-completions

autoload -Uz compinit
local -a zcompdump_stale
local -i had_extended_glob=0
[[ -o extended_glob ]] && had_extended_glob=1
setopt extended_glob
zcompdump_stale=("$ZCOMP_DUMP"(#qN.mh+24))
(( had_extended_glob )) || unsetopt extended_glob

if (( ${#zcompdump_stale} )); then
  compinit -d "$ZCOMP_DUMP"
else
  compinit -C -d "$ZCOMP_DUMP"
fi

if [[ -s "$ZCOMP_DUMP" && (! -s "$ZCOMP_DUMP.zwc" || "$ZCOMP_DUMP" -nt "$ZCOMP_DUMP.zwc") ]]; then
  zcompile "$ZCOMP_DUMP"
fi

[[ -s "${BUN_INSTALL}/_bun" ]] && source "${BUN_INSTALL}/_bun"

eval "$(dircolors -b)"

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*:*:*:*:processes' command 'ps -ef'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'command ls --color=auto -- "$realpath"'

zinit light Aloxaf/fzf-tab
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
zinit ice wait lucid
zinit light zdharma-continuum/fast-syntax-highlighting

if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

if command -v fzf &>/dev/null; then
    eval "$(fzf --zsh 2>/dev/null)"
fi

if command -v zoxide &>/dev/null; then
    unalias zi 2>/dev/null
    eval "$(zoxide init zsh)"
fi

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

[ -f "$ZDOTDIR/.zshrc.local" ] && source "$ZDOTDIR/.zshrc.local"

autoload -Uz bashcompinit && bashcompinit
command -v aws >/dev/null 2>&1 && [ -x '/usr/bin/aws_completer' ] && complete -C '/usr/bin/aws_completer' aws
