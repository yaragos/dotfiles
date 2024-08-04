# >>>   :<startline>,<endline>s/^/# /    <<<
# >>>   :<startline>,<endline>s/^# //    <<<
function is_exist() {
  command -v "$1" >/dev/null 2>&1
}
# --------------- mappings -------------------
# vi mode
bindkey -v
bindkey "jk" vi-cmd-mode
bindkey -a "H" vi-first-non-blank
bindkey -a "L" vi-end-of-line
# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi
# [PageUp] - Up a line of history
if [[ -n "${terminfo[kpp]}" ]]; then
  bindkey -M emacs "${terminfo[kpp]}" up-line-or-history
  bindkey -M viins "${terminfo[kpp]}" up-line-or-history
  bindkey -M vicmd "${terminfo[kpp]}" up-line-or-history
fi
# [PageDown] - Down a line of history
if [[ -n "${terminfo[knp]}" ]]; then
  bindkey -M emacs "${terminfo[knp]}" down-line-or-history
  bindkey -M viins "${terminfo[knp]}" down-line-or-history
  bindkey -M vicmd "${terminfo[knp]}" down-line-or-history
fi

# Start typing + [Up-Arrow] - fuzzy find history forward
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search

bindkey -M emacs "^[[A" up-line-or-beginning-search
bindkey -M viins "^[[A" up-line-or-beginning-search
bindkey -M vicmd "^[[A" up-line-or-beginning-search
if [[ -n "${terminfo[kcuu1]}" ]]; then
  bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# Start typing + [Down-Arrow] - fuzzy find history backward
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -M emacs "^[[B" down-line-or-beginning-search
bindkey -M viins "^[[B" down-line-or-beginning-search
bindkey -M vicmd "^[[B" down-line-or-beginning-search
if [[ -n "${terminfo[kcud1]}" ]]; then
  bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
fi
# [Home] - Go to beginning of line
if [[ -n "${terminfo[khome]}" ]]; then
  bindkey -M emacs "${terminfo[khome]}" beginning-of-line
  bindkey -M viins "${terminfo[khome]}" beginning-of-line
  bindkey -M vicmd "${terminfo[khome]}" beginning-of-line
fi
# [End] - Go to end of line
if [[ -n "${terminfo[kend]}" ]]; then
  bindkey -M emacs "${terminfo[kend]}"  end-of-line
  bindkey -M viins "${terminfo[kend]}"  end-of-line
  bindkey -M vicmd "${terminfo[kend]}"  end-of-line
fi
# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey -M emacs "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
fi
# [Backspace] - delete backward
bindkey -M emacs '^?' backward-delete-char
bindkey -M viins '^?' backward-delete-char
bindkey -M vicmd '^?' backward-delete-char
# [Delete] - delete forward
if [[ -n "${terminfo[kdch1]}" ]]; then
  bindkey -M emacs "${terminfo[kdch1]}" delete-char
  bindkey -M viins "${terminfo[kdch1]}" delete-char
  bindkey -M vicmd "${terminfo[kdch1]}" delete-char
else
  bindkey -M emacs "^[[3~" delete-char
  bindkey -M viins "^[[3~" delete-char
  bindkey -M vicmd "^[[3~" delete-char

  bindkey -M emacs "^[3;5~" delete-char
  bindkey -M viins "^[3;5~" delete-char
  bindkey -M vicmd "^[3;5~" delete-char
fi
# [Ctrl-Delete] - delete whole forward-word
bindkey -M emacs '^[[3;5~' kill-word
bindkey -M viins '^[[3;5~' kill-word
bindkey -M vicmd '^[[3;5~' kill-word
# [Ctrl-RightArrow] - move forward one word
bindkey -M emacs '^[[1;5C' forward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5C' forward-word
# [Ctrl-LeftArrow] - move backward one word
bindkey -M emacs '^[[1;5D' backward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M vicmd '^[[1;5D' backward-word

bindkey '\ew' kill-region                             # [Esc-w] - Kill from the cursor to the mark
# bindkey '^r' history-incremental-search-backward      # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.
bindkey ' ' magic-space                               # [Space] - don't do history expansion

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
# bindkey '^e' edit-command-line
bindkey -M vicmd 'vv' edit-command-line

# file rename magick, use <Esc>m
bindkey "^[m" copy-prev-shell-word

# ---------------- History ------------------
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

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust
# 语法高亮
zinit ice lucid wait='0'
zinit light zsh-users/zsh-syntax-highlighting
# 自动建议 && 补全
zinit ice lucid wait="0" atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
# zinit ice lucid
# zinit light zsh-users/zsh-history-substring-search
zinit ice lucid blockf
zinit light zsh-users/zsh-completions
zinit ice lucid wait="0"
zinit light Aloxaf/fzf-tab
# OMZ
# zinit snippet OMZ::lib/completion.zsh
# zinit snippet OMZ::lib/history.zsh
# zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
# 使用 <Esc><Esc> 快速添加 sudo
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh
zinit ice lucid wait='1'
zinit snippet OMZ::plugins/git/git.plugin.zsh
# theme
zinit snippet OMZ::lib/theme-and-appearance.zsh
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::lib/async_prompt.zsh
zinit snippet OMZ::plugins/svn/svn.plugin.zsh
zinit snippet OMZ::themes/ys.zsh-theme
#
### End of Zinit's installer chunk
#
# ---------------- Plugins config ----------------
# bindkey -M vicmd 'k' history-substring-search-up
# bindkey -M vicmd 'j' history-substring-search-down
# bindkey '\e[5~' history-substring-search-up # Page Up
# bindkey '\e[6~' history-substring-search-down # Page Down
# bindkey "$terminfo[kcuu1]" history-substring-search-up # up
# bindkey "$terminfo[kcud1]" history-substring-search-down # down

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

# nvim 
alias lzvim='NVIM_APPNAME="lazyvim" nvim'
alias anvim='NVIM_APPNAME="astronvim" nvim'

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

# -------------- development environment ----------------
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi

# ++++++++ sdkman
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="$HOME/.sdkman"
# [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# ++++++++ nvm
# export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
#

