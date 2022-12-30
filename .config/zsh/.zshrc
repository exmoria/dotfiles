# ================================ General ================================== #
# Should be called before compinit.
zmodload zsh/complist 

autoload -U compinit promptinit \
    && compinit \
    && promptinit
 
# With hidden files.
_comp_options+=(globdots)

# Load vcs_info function.
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Gathering-information-from-version-control-systems
autoload -Uz vcs_info

# Hook Functions are executed before each prompt
# http://zsh.sourceforge.net/Doc/Release/Functions.html#Hook-Functions
# Executed before each prompt
precmd () {
  # Add vsc_info to executed before each prompt
  # http://zsh.sourceforge.net/Doc/Release/Functions.html#Hook-Functions
  vcs_info
}

# ================================ Prompt =================================== #
# Enable parameter expansion, command substitution and arithmetic expansion in prompts
# http://zsh.sourceforge.net/Doc/Release/Options.html#Prompting
setopt PROMPT_SUBST

# Enable git only.
# Enable info about uncommited changes in the working directory.
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Quickstart
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr "%F{black} (dirty)%f" # styling for %u
zstyle ':vcs_info:*' stagedstr "%F{white} (staged files)%f" # styling for %c
zstyle ':vcs_info:*' patch-format "%F{purple} (rebase)%f" # styling for %m

zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

# Format vsc info message
zstyle ':vcs_info:git:*' formats "%F{yellow}%r → %b%F{cyan}%u%c%m%f%f "
zstyle ':vcs_info:git:*' actionformats "%F{yellow}%r → %b%F{cyan}%u%c%m%f%f "


+vi-git-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && git status --porcelain | grep -m 1 '^??' &>/dev/null
  then
    hook_com[misc]='%F{white} (untracked files)%f'
  fi
}

prompt() {
  if [ -d .git ]; then
    echo ${vcs_info_msg_0_}
  else
    echo '%F{yellow}%m %B:: %b%3~ %B%(!.%F{red}.)»%f%b '
  fi;
}

rprompt() {
  echo '%F{white}%n, %*%f'
}

PROMPT='$(prompt)'
RPROMPT='$(rprompt)'


# By default, Ctrl+d will not close your shell if the command line is filled.
# This fixes it. 
exit_zsh() { exit }
zle -N exit_zsh
bindkey '^D' exit_zsh

# History in cache directory.
HISTFILE=~/.cache/zsh/history
HISTSIZE=1000
SAVEHIST=1000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# ================================ Options ================================== #

setopt AUTO_CD                # Automatically cd into typed directory.
setopt AUTO_PUSHD             # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS      # Do not store duplicates in the stack.
setopt PUSHD_SILENT           # Do not print the directory stack after pushd or popd.
setopt NO_CASE_GLOB           # Make globbing case insensitive.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first.
setopt HIST_IGNORE_DUPS       # Do not store duplications.
setopt HIST_REDUCE_BLANKS     # Remove blank lines from history.


# ============================== Completions ================================ #

# Define completers.
zstyle ':completion:*' completer _extensions _complete _approximate

# Auto/tab complete.
zstyle ':completion:*' menu select

# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'

# =============================== Keybinds ================================== #
### Ref: https://wiki.archlinux.org/title/Zsh?useskinversion=1#Key_bindings 

typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# ============================ Autosuggestions ============================== #

local FILE="/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f $FILE ]] && source $FILE

# ================================ Aliases ================================== #

# make
alias m="make"

# .zshrc
alias zrc='code ~/.config/zsh/.zshrc'

# pacman
alias paci='sudo pacman -S'
alias pacu='sudo pacman -Syu'
alias pacr='sudo pacman -Rs'
alias pacs='sudo pacman -Ss'

# yay
alias yu='yay -Syu --combinedupgrade'
alias ys='yay -Ss'
alias yi='yay -S'
alias yr='yay -Rs'

# kubectl
alias k='kubectl'
alias kg='kubectl get'
alias kdel="kubectl delete $1 $2"

# maven
alias mvn='mvnd'

# git
alias gc='git clone'

# docker
alias di="docker images"
alias dia="docker images -a"
alias dirm="docker image remove"
alias dps="docker ps -a" 
alias lsvol="docker volume ls"
alias rmvol='docker volume rm "$(docker volume ls -q)"'
alias dprune="docker system prune -f"
alias dex="docker ps -f 'status=exited'"
dstop() { docker stop $(docker ps -a -q); } # Stop all containers.
drall() { docker rm $(docker ps -a -q); } # Remove all containers.

# youtubedl
alias ydlF='youtube-dl -F'
alias ydla='youtube-dl -x --audio-quality 0'

# Misc
alias mkdir='mkdir -pv'
alias l='ls -ghAFG --color=auto --group-directories-first'
alias ls='ls -ghAFG --color=auto --group-directories-first'
alias grep='grep -iF'
alias dirty='watch grep -e Dirty: -e Writeback: /proc/meminfo'
alias gin='npx gitignosource /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/exmoria/.sdkman"
[[ -s "/home/exmoria/.sdkman/bin/sdkman-init.sh" ]] && source "/home/exmoria/.sdkman/bin/sdkman-init.sh"
