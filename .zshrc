# >>>   Yaragos's zsh configure    <<<
function is_exist() {
  command -v "$1" >/dev/null 2>&1
}
# --------------- | keybindings | -------------------
[[ -s "${HOME}/.zsh/keybindings.zsh" ]] && source "${HOME}/.zsh/keybindings.zsh"

# ---------------- | History | ------------------
## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data
#
# ---------------- | proxy | --------------------
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

# ---------------- | env | ----------------
# Add my custom porfile
if [ -f "$HOME/.zprofile" ]; then
    . "$HOME/.zprofile"
fi
# ++++++++ brew ++++++++
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# # ------------>>>    zinit    <<<-------------
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# OMZ
zinit ice lucid wait='1'
zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
# Add `sudo` with press `<Esc><Esc>`
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh
#
### End of Zinit's installer chunk
#
# ---------------- | Plugins config | ----------------

# ---------------- | brew install | -------------------
# z #
. /home/linuxbrew/.linuxbrew/etc/profile.d/z.sh

# mysql #
export PATH="/home/linuxbrew/.linuxbrew/opt/mysql@5.7/bin:$PATH"

# fnm #
eval "$(fnm env --use-on-cd)"

# fzf #
# In order to use `fzf-history-widget`, 
# it must he loaded before `zsh-vi-mode`.
# source <(fzf --zsh)

# starship #
eval "$(starship init zsh)"

# ------------- | Better command line | ---------------------
# zsh-vi-mode
function zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
  ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
}
function zvm_after_init() {
  bindkey -M vicmd "H" vi-first-non-blank
  bindkey -M vicmd "L" vi-end-of-line
  bindkey ' ' magic-space             # [Space] - don't do history expansion
  bindkey "\C-j" copy-prev-shell-word # file rename magick, use <C-m>
  source <(fzf --zsh)
}
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode
# syntax highlight
zinit ice lucid wait='0'
zinit light zsh-users/zsh-syntax-highlighting
# auto-suggestion
zinit ice lucid wait="0" atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=yellow,bold"
zinit ice lucid wait
zinit light Aloxaf/fzf-tab
# To activate these completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  autoload -Uz compinit
  compinit
fi

# --------------- | Aliases and Functions | -------------------
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

alias ra='ranger'

# my nvim
alias mvim='NVIM_APPNAME="mvim" nvim'

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
# Change the current working directory when exiting Yazi.
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
# -------------- | Development Environment | ----------------
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi

# ++++++++ sdkman
# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="$HOME/.sdkman"
# [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# ++++++++ gvm
# [[ -s "${HOME}/.gvm/scripts/gvm" ]] && source "${HOME}/.gvm/scripts/gvm"
