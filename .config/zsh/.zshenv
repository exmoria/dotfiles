#!/usr/bin/zsh

export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}

export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
export ZDOTDIR="$HOME"/.config/zsh
export HISTFILE="$XDG_CACHE_HOME"/zsh/history
export GOPATH="$HOME"/go
export GOBIN="$GOPATH"/bin
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export NODE_ENV=development
export SDKMAN_DIR="$HOME"/.sdkman
export VOLTA_HOME="$HOME"/.volta
export EDITOR="code --wait"

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# export JAVA_HOME=/usr/lib/jvm/java
# export JAVA_HOME="$SDKMAN_DIR/candidates/java/current"

# Path
typeset -U PATH path
path=("$VOLTA_HOME/bin" "$HOME/go/bin" "$JAVA_HOME/bin" "$XDG_DATA_HOME/npm/bin" "$XDG_DATA_HOME/JetBrains/Toolbox/scripts" "$HOME/.local/bin" "$HOME/.dotnet/tools" "$path[@]")
export PATH
