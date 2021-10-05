DISABLE_MAGIC_FUNCTIONS="true"
  export ZSH="/home/admin/.oh-my-zsh"

ZSH_THEME="agnoster"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting vi-mode)

source $ZSH/oh-my-zsh.sh

#default editor
export EDITOR='nvim'
export VISUAL='vscodium'

# Alias for vscode
alias code="vscodium"
alias vim="nvim"

# Open file in vscode
ct() {find . -type f -not -path '*/\.git/*' ! -path "*/\.vscode/*"  ! -path "*/\node_modules/*" | fzf | xargs -r -I % $VISUAL % ;}
vt() {find . -type f -not -path '*/\.git/*' ! -path "*/\.vscode/*"  ! -path "*/\node_modules/*" | fzf | xargs -r -I % $EDITOR % ;}

# Alias for ranger
ra() {ranger}

CURRENT_BG='NONE'
if [[ -z "$PRIMARY_FG" ]]; then
	PRIMARY_FG=black
fi

# Characters
SEGMENT_SEPARATOR="\ue0b0"
PLUSMINUS="\u00b1"
BRANCH="\ue0a0"
DETACHED="\u27a6"
CROSS="\u2718"
LIGHTNING="\u26a1"
GEAR="\u2699"

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    print -n "%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
  else
    print -n "%{$bg%}%{$fg%}"
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && print -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    print -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    print -n "%{%k%}"
  fi
  print -n "%{%f%}"
  CURRENT_BG=''
}

DEFAULT_USER=admin@pc
prompt_context() {
  # Custom (Random emoji)
  emojis=(" 🧳" " 🔥" " 🐵" " 🦊" " 🐢" " 🦍" " 🦧" " 🦥" " 🦉" " 🌚" " 🦔" " 🎯" " 🐣" " 🦫" " 🐊" )
  RAND_EMOJI_N=$(( $RANDOM % ${#emojis[@]} + 1))
  prompt_segment black default "${emojis[$RAND_EMOJI_N]} "
}

# Git: branch/detached head, dirty status
prompt_git() {
  local color ref
  is_dirty() {
    test -n "$(git status --porcelain --ignore-submodules)"
  }
  ref="$vcs_info_msg_0_"
  if [[ -n "$ref" ]]; then
    if is_dirty; then
      color=yellow
      ref="${ref} $PLUSMINUS"
    else
      color=green
      ref="${ref} "
    fi
    if [[ "${ref/.../}" == "$ref" ]]; then
      ref="$BRANCH $ref"
    else
      ref="$DETACHED ${ref/.../}"
    fi
    prompt_segment $color $PRIMARY_FG
    print -n " $ref"
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment blue $PRIMARY_FG ' %2~ '
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}$CROSS"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}$LIGHTNING"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}$GEAR"

  [[ -n "$symbols" ]] && prompt_segment $PRIMARY_FG default " $symbols "
}

# Display current virtual environment
prompt_virtualenv() {
  if [[ -n $VIRTUAL_ENV ]]; then
    color=cyan
    prompt_segment $color $PRIMARY_FG
    print -Pn " $(basename $VIRTUAL_ENV) "
  fi
}

## Main prompt
prompt_agnoster_main() {
  RETVAL=$?
  CURRENT_BG='NONE'
  prompt_status
  prompt_context
  prompt_virtualenv
  prompt_dir
  prompt_git
  prompt_end
}

prompt_agnoster_precmd() {
  vcs_info
  PROMPT='%{%f%b%k%}$(prompt_agnoster_main) '
}

prompt_agnoster_setup() {
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info

  prompt_opts=(cr subst percent)

  add-zsh-hook precmd prompt_agnoster_precmd

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' check-for-changes false
  zstyle ':vcs_info:git*' formats '%b'
  zstyle ':vcs_info:git*' actionformats '%b (%a)'
}

prompt_agnoster_setup "$@"

PATH="/home/admin/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/admin/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/admin/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/admin/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/admin/perl5"; export PERL_MM_OPT;

bindkey -v
bindkey 'jk' vi-cmd-mode
ZSH_AUTOSUGGEST_STRATEGY=(history completion )
VI_MODE_SET_CURSOR=true
