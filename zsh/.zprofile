### Runs for login shells (e.g. iTerm launch)

# Set up Homebrew (Apple Silicon)
eval "$(/opt/homebrew/bin/brew shellenv)"

# rbenv login-time initialization
if command -v rbenv >/dev/null; then
  eval "$(rbenv init - --no-rehash zsh)"
fi

# Compiler flags for OpenJDK headers (for compilation)
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
