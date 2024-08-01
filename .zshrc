# >>>   :<startline>,<endline>s/^/# /    <<<
# >>>   :<startline>,<endline>s/^# //    <<<
function is_exist() {
  command -v "$1" >/dev/null 2>&1
}
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
# ++++++++ brew ++++++++
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# -------- brew install -------------------
# z #
. /home/linuxbrew/.linuxbrew/etc/profile.d/z.sh

# mysql #
export PATH="/home/linuxbrew/.linuxbrew/opt/mysql@5.7/bin:$PATH"

# fnm #
eval "$(fnm env --use-on-cd)"

# fzf #
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

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

# --------------- Aliases and Functions -------------------
alias grep='grep --color=auto'
# better ls
if is_exist eza; then
  alias ls='eza --icons=always'
else
  alias ls='ls --color=auto'
fi
alias l='ls -F'
alias ll='ls -alF'
alias la='ls -a'

# manage dotfiles
if is_exist yadm; then
  alias dot='yadm'
  if is_exist lazygit; then
    alias lazydot='yadm enter lazygit'
  fi
fi
# 实现当调用`blog PAGE`时，执行`hugo new post/PAGE/index.md`
if is_exist hugo; then
  function blog() {
    local blog_name="$1"
    if [[ "$blog_name" == "" ]]; then
      echo "请输入博客文章名称"
      return 1
    fi
    hugo new "post/$blog_name/index.md"
  }
fi

# 清理缓存
function clear_cache() {
  # 检查是否以 sudo 身份执行
  if [[ $EUID -eq 0 ]]; then
    echo "请勿使用 sudo 执行此函数!"
    exit 1
  fi
  eval "sync; sudo sysctl vm.drop_caches=1"
}

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

# ++++++++ nvm
# export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
