typeset -U path
[[ -d "$HOME/.config/herd-lite/bin" ]] && path=("$HOME/.config/herd-lite/bin" $path)
[[ -d "${BUN_INSTALL}/bin" ]] && path=("${BUN_INSTALL}/bin" $path)

export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git --type d'
export FZF_CTRL_T_OPTS='--no-height --preview "bat --color=always --style=numbers --line-range=:500 {}" --multi'
export FZF_ALT_C_OPTS='--no-height --preview "eza -T -L 3 --icons --color=always {}"'
# The ui.toml palette, by hand: macOS has no apply-ui. No background of its
# own (bg, gutter: -1): the terminal's, translucent, shows through.
fzf_colors='bg+:#21262d,bg:-1,gutter:-1,fg:#c9d1d9,hl:#58a6ff,fg+:#c9d1d9,hl+:#58a6ff,header:#58a6ff,info:#8b949e,pointer:#58a6ff,marker:#3fb950,prompt:#58a6ff,spinner:#58a6ff,border:#30363d'
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
    alias -s html=xdg-open
    alias -s {pdf,PDF}=xdg-open
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

# Machine-specific setup comes first: it can put tools (ac-platform's kubectl and
# aws) on PATH and add completion dirs to fpath, and the completion setup below
# needs both.
[ -f "$ZDOTDIR/.zshrc.local" ] && source "$ZDOTDIR/.zshrc.local"

zinit light zsh-users/zsh-completions

# Completion scripts the tools generate themselves. They live in ZCOMP_GEN_DIR and
# are rebuilt whenever the tool's binary is newer than its file, so updating
# kubectl or Docker refreshes them with no manual step; an up-to-date shell pays
# one stat per tool. To cover another tool, add a line to the table.
ZCOMP_GEN_DIR="${XDG_DATA_HOME}/zsh/completions"
typeset -A zcomp_generators=(
  kubectl 'completion zsh'
  docker  'completion zsh'
  helm    'completion zsh'
)
typeset -i zcomp_regenerated=0
() {
  local tool args bin gen cand out
  [[ -d "$ZCOMP_GEN_DIR" ]] || mkdir -p "$ZCOMP_GEN_DIR"
  for tool args in "${(@kv)zcomp_generators}"; do
    bin="${commands[$tool]}"
    [[ -n "$bin" ]] || continue
    bin="${bin:A}"
    gen="$ZCOMP_GEN_DIR/_$tool"
    [[ "$gen" -nt "$bin" ]] && continue
    # The first binary on PATH may be broken (ac-platform's kubectl is killed by
    # macOS on some laptops), so try the others in order.
    for cand in ${(f)"$(whence -pa "$tool")"}; do
      out="$("$cand" ${=args} 2>/dev/null)"
      if [[ -n "$out" ]]; then
        print -r -- "$out" >| "$gen.tmp" && mv -f "$gen.tmp" "$gen" && zcomp_regenerated=1
        break
      fi
    done
  done
}

# Later entries end up first: generated files beat Homebrew's, which beat the rest.
() {
  local dir
  for dir in /opt/homebrew/share/zsh/site-functions /home/linuxbrew/.linuxbrew/share/zsh/site-functions "$ZCOMP_GEN_DIR"; do
    [[ -d "$dir" ]] && fpath=("$dir" $fpath)
  done
}

autoload -Uz compinit
local -a zcompdump_stale
local -i had_extended_glob=0
[[ -o extended_glob ]] && had_extended_glob=1
setopt extended_glob
zcompdump_stale=("$ZCOMP_DUMP"(#qN.mh+24))
(( had_extended_glob )) || unsetopt extended_glob

# -C trusts the cached dump and would not see a script that was just generated.
if (( ${#zcompdump_stale} || zcomp_regenerated )); then
  compinit -d "$ZCOMP_DUMP"
else
  compinit -C -d "$ZCOMP_DUMP"
fi

if [[ -s "$ZCOMP_DUMP" && (! -s "$ZCOMP_DUMP.zwc" || "$ZCOMP_DUMP" -nt "$ZCOMP_DUMP.zwc") ]]; then
  zcompile "$ZCOMP_DUMP"
fi

# aws has no zsh script, only a bash-style completer; take the one that sits next
# to the aws on PATH so the two versions match.
autoload -Uz bashcompinit && bashcompinit
() {
  local aws="${commands[aws]}" completer
  [[ -n "$aws" ]] || return
  completer="${aws:A:h}/aws_completer"
  [[ -x "$completer" ]] || completer="${commands[aws_completer]}"
  [[ -x "$completer" ]] && complete -C "$completer" aws
}

# Wrappers that sit next to kubectl (ac-platform's kubectl-staging and the like)
# complete as kubectl. The emptiness checks matter: ${:h} of nothing is ".".
() {
  local kubectl="${commands[kubectl]}"
  local -a wrappers
  [[ -n "$kubectl" ]] || return
  wrappers=(${kubectl:h}/kubectl-*(N:t))
  (( $#wrappers && $+functions[_kubectl] )) && compdef _kubectl $wrappers
}

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

# clear and its prompt in one frame (synchronized output), so Ghostty's cursor trail runs whole.
# The end hooks in at the first prompt, after Ghostty's cursor shape, which would restart the trail.
if [[ "${TERM_PROGRAM:-}" == ghostty ]]; then
    autoload -Uz add-zle-hook-widget add-zsh-hook
    clear() { print -n '\e[?2026h'; command clear "$@" }
    __sync_end() { print -n '\e[?2026l' }
    __sync_hook() { add-zle-hook-widget line-init __sync_end; add-zsh-hook -d precmd __sync_hook }
    add-zsh-hook precmd __sync_hook
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
