# NOTE: what is this? where is it used? why is it not in ~/.fzf or ~/.config/fzf?

# Setup fzf
# ---------
if [[ ! "$PATH" == *${FZF_PATH}/bin* ]]; then
  export PATH="$PATH:${FZF_PATH}/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${FZF_PATH}/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${FZF_PATH}/shell/key-bindings.zsh"
