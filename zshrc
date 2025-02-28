HISTSIZE="50000"
SAVEHIST="10000"

HISTFILE="$HOME/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
unsetopt APPEND_HISTORY
unsetopt HIST_FIND_NO_DUPS

setopt interactivecomments
bindkey -v

export EDITOR="nvim"

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[OA' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OB' history-substring-search-down

alias -- cd=z
alias -- eza='eza --icons auto --git'
alias -- l='eza -alh'
alias -- la='eza -a'
alias -- ll='eza -l'
alias -- lla='eza -la'
alias -- ls=eza
alias -- lt='eza --tree'
alias -- tree='eza -T'
alias -- v=nvim
alias -- vim=nvim
alias -- vimdiff='nvim -d'

# starship
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"

# fzf
eval "$(fzf --zsh)"
export FZF_DEFAULT_OPTS="--height=~100% --color bg+:#434C5E,fg:#D8DEE9,fg+:#D8DEE9,header:#4C566A,hl:#A3BE8C,hl+:#A3BE8C,info:#4C566A,marker:#EBCB8B,pointer:#BF616A,prompt:#81A1C1,spinner:#4C566A"
zstyle ':fzf-tab:*' fzf-flags ${(z)FZF_DEFAULT_OPTS}

# mihomo
function proxy() {
  export https_proxy="http://127.0.0.1:7890" http_proxy="http://127.0.0.1:7890" all_proxy="socks5://127.0.0.1:7890"
}

function unset-proxy() {
  unset https_proxy http_proxy all_proxy
}

if [ $(pgrep mihomo) ]; then
  proxy
fi

