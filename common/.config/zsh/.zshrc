typeset -U path
path=(
  $path
)

[[ -d "$HOME/.config/herd-lite/bin" ]] && path=("$HOME/.config/herd-lite/bin" $path)
[[ -d "${BUN_INSTALL}/bin" ]] && path=("${BUN_INSTALL}/bin" $path)

export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git --type d'
export FZF_CTRL_T_OPTS='--no-height --preview "bat --color=always --style=numbers --line-range=:500 {}" --preview-window=right:50% --multi'
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
alias -s html='firefox'
alias -s {pdf,PDF}=firefox
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

export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.7z=01;31:*.ace=01;31:*.alz=01;31:*.apk=01;31:*.arc=01;31:*.arj=01;31:*.bz=01;31:*.bz2=01;31:*.cab=01;31:*.cpio=01;31:*.crate=01;31:*.deb=01;31:*.drpm=01;31:*.dwm=01;31:*.dz=01;31:*.ear=01;31:*.egg=01;31:*.esd=01;31:*.gz=01;31:*.jar=01;31:*.lha=01;31:*.lrz=01;31:*.lz=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.lzo=01;31:*.pyz=01;31:*.rar=01;31:*.rpm=01;31:*.rz=01;31:*.sar=01;31:*.swm=01;31:*.t7z=01;31:*.tar=01;31:*.taz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tgz=01;31:*.tlz=01;31:*.txz=01;31:*.tz=01;31:*.tzo=01;31:*.tzst=01;31:*.udeb=01;31:*.war=01;31:*.whl=01;31:*.wim=01;31:*.xz=01;31:*.z=01;31:*.zip=01;31:*.zoo=01;31:*.zst=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.jxl=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:'

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
