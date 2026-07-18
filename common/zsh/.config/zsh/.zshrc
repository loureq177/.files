typeset -U path
path=(
  $path
)

[[ -d "$HOME/.config/herd-lite/bin" ]] && path=("$HOME/.config/herd-lite/bin" $path)
[[ -d "${BUN_INSTALL}/bin" ]] && path=("${BUN_INSTALL}/bin" $path)

export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git --type d'
export FZF_CTRL_T_OPTS='--no-height --preview "bat --color=always --style=numbers --line-range=:500 {}" --preview-window=right:50%'
export FZF_ALT_C_OPTS='--no-height --preview "eza -T -L 3 --icons --color=always {}" --preview-window=right:50%'
export FZF_DEFAULT_OPTS="--layout=reverse --border=rounded --info=inline --bind 'ctrl-/:toggle-preview'"

HISTSIZE=10000
HISTDUP=erase
SAVEHIST=$HISTSIZE
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

alias -s {txt,md,json,yaml,yml,toml,conf,ini,cfg,log,env,bash,zsh,lua,py,rb,js,ts,jsx,tsx,c,h,cpp,hpp,go,rs,tex,css,scss,sass,gitignore,editorconfig,xml,sql,svelte,vue}=nvim
alias -s html='zen'
alias -s {pdf,PDF}=zen
alias -s {png,jpg,jpeg,webp,gif,bmp,svg}=xdg-open
alias -s {mp4,mov,avi,mkv,webm,MP4,MOV}=xdg-open
alias -s {zip,rar,7z,tar,gz,xz,bz2,iso}=yazi

ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
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

[[ -f "$ZDOTDIR/.dircolors.zsh" ]] && source "$ZDOTDIR/.dircolors.zsh"

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*:*:*:*:processes' command 'ps -ef'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'command ls --color=auto -- "$realpath"'

zinit light Aloxaf/fzf-tab
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zdharma-continuum/fast-syntax-highlighting

eval "$(starship init zsh)"
[[ -f "$ZDOTDIR/.fzf.zsh" ]] && source "$ZDOTDIR/.fzf.zsh"

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

if [ -z "${DISPLAY}" ] && [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR:-0}" -eq 1 ]; then
    exec Hyprland
fi

[ -f "$ZDOTDIR/.zshrc.local" ] && source "$ZDOTDIR/.zshrc.local"
