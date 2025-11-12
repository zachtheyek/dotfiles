### This file is sourced by ALL shells (interactive, login, scripts)

# Deduplicate $PATH using zsh array semantics
typeset -U path PATH

# Function to safely add to path if it exists
add_to_path() {
  [[ -d "$1" ]] && path+="$1"
}

# System paths
add_to_path /usr/local/bin
add_to_path /usr/local/sbin
add_to_path /opt/local/bin
add_to_path /opt/local/sbin
add_to_path /usr/bin
add_to_path /usr/sbin
add_to_path /bin
add_to_path /sbin
add_to_path /System/Cryptexes/App/usr/bin
add_to_path /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin
add_to_path /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin
add_to_path /var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin
add_to_path /Library/Apple/usr/bin
add_to_path /opt/X11/bin
add_to_path /Library/TeX/texbin

# User-local binaries
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/.fzf/bin"
add_to_path "$HOME/.oh-my-zsh/custom/plugins/fzf-zsh-plugin/bin"
add_to_path "$HOME/Applications/iTerm.app/Contents/Resources/utilities"

# Language runtimes and package managers
add_to_path "$HOME/opt/miniconda3/bin"
add_to_path "$HOME/opt/miniconda3/condabin"
add_to_path "$HOME/.rbenv/bin"
add_to_path "$HOME/.rbenv/shims"
add_to_path "$HOME/.opam/default/bin"
add_to_path "/opt/homebrew/opt/openjdk/bin"

export PATH
