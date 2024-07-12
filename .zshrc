# >>>   :<startline>,<endline>s/^/# /    <<<
# >>>   :<startline>,<endline>s/^# //    <<<

# ---------------- proxy --------------------
function set_proxy() {
  export http_proxy="http://127.0.0.1:7897/"
  export https_proxy="http://127.0.0.1:7897/"
  export all_proxy="socks://127.0.0.1:7897/"
  export no_proxy="localhost,127.0.0.1,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12,::1"
}
function unset_proxy() {
  unset http_proxy
  unset https_proxy
  unset all_proxy
  unset no_proxy
}
set_proxy
# ---------------- env ----------------
# Add my custom porfile
if [ -f "$HOME/.exports" ]; then
    . "$HOME/.exports"
fi
# -------------------------------------

# ------------>>>    zplug    <<<-------------
if [[ ! -d ~/.zplug ]];then
  git clone https://github.com/b4b4r07/zplug.git ~/.zplug
  source ~/.zplug/zplug
  zplug update --self
fi
source ~/.zplug/init.zsh

zplug "plugins/svn", from:oh-my-zsh
zplug "themes/ys", from:oh-my-zsh

zplug "lib/history", from:oh-my-zsh
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions", as:plugin
zplug "zsh-users/zsh-syntax-highlighting", as:plugin, defer:2
zplug "zsh-users/zsh-history-substring-search", as:plugin, defer:3

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install zplug plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# ---------------- Plugin config ----------------
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey '\e[5~' history-substring-search-up # Page Up
bindkey '\e[6~' history-substring-search-down # Page Down
# bindkey "$terminfo[kcuu1]" history-substring-search-up # up
# bindkey "$terminfo[kcud1]" history-substring-search-down # down

# ---------------- History ------------------
setopt HIST_IGNORE_DUPS # 不保存重复指令

# --------------- Aliases -------------------
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias l='ls -CF'
alias ll='ls -alF'
alias la='ls -A'
alias lh='ls -lh'

if command -v yadm >/dev/null 2>&1; then
  alias dot='yadm'
  if command -v lazygit >/dev/null 2>&1; then
    alias lazydot='yadm enter lazygit'
  fi
fi

# --------------- mappings -------------------
# vi mode
bindkey -v
bindkey "jk" vi-cmd-mode
bindkey -a "H" vi-first-non-blank
bindkey -a "L" vi-end-of-line

# Home and End keys
case $TERM in
    xterm*|rxvt*)
        bindkey '\e[H' beginning-of-line     # Home
        bindkey '\e[F' end-of-line           # End
        ;;
esac

# Delete, Insert keys
bindkey '\e[3~' delete-char # Delete
bindkey '\e[2~' overwrite-mode # Insert

# -------------- development environment ----------------
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi

# ++++++++ sdkman
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="$HOME/.sdkman"
# [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# ++++++++ brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# ++++++++ nvm
# export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export PATH="/home/linuxbrew/.linuxbrew/opt/mysql@5.7/bin:$PATH"

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd)"
fi
