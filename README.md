This repository relies on [GNU Stow](https://www.gnu.org/software/stow/) to centralize, manage, and distribute dotfiles across your machine. Each package is tied to a tool (or set of tools), and lives in its own directory that mimics the expected configuration structure relative to `$HOME`. When invoked, Stow will create symlinks to the specified packages in this repository throughout your machine, such that each tool may function as normal, while retaining a unified control hub for the user. It's recommended to make edits to the configs from the repository itself, rather than through the symlinks (to avoid artifacts that become out-of-sync over time). Naturally, you'll need to have a tool installed beforehand for the package to take effect (usually just `brew install X`;  refer to the official docs for further instruction). 

It goes without saying: all packages are configured to my personal liking, and are highly opinionated & biased. My general philosophy comes down to: 

- Keyboard-first, with a preference for TUIs and vim bindings
- Consistent & productive UI > ricing potential
  - Optimized with a single 27" monitor in mind
- Deep integration of plugins 
  - Bonus points if it's open-source, community-driven, and well-maintained

# Installation

## Prerequisites

1. **Install GNU Stow**:
   ```bash
   brew install stow
   ```

2. **Clone this repository**:
   ```bash
   git clone <repository-url> ~/dotfiles
   cd ~/dotfiles
   ```

3. **Make the install script executable** (first time only):
   ```bash
   chmod +x install.sh
   ```

## Usage

The installation script supports four commands:

| Command | Description |
|---------|-------------|
| `stow` | Create symlinks (default) |
| `unstow` | Remove symlinks |
| `restow` | Update symlinks (remove + create) |
| `dry-run` | Show what would happen without making changes |


Each command can be followed up with a space-separated list of packages to be operated on. If none are provided, all packages will be selected by default. 

**Examples:**

```bash
# Install all packages
./install.sh

# Install specific packages
./install.sh aerospace nvim zsh

# Uninstall specific packages
./install.sh unstow tmux

# Update all packages (useful after git pull)
./install.sh restow

# Preview changes without applying them
./install.sh dry-run
./install.sh dry-run nvim zsh
```

## Post-Installation

Note that some tools require additional setup. For example:

1. **Tmux plugins**: Open tmux and press `<prefix>+I` to install plugins via TPM
2. **Neovim plugins**: Open nvim and run `:Lazy sync`
3. **Oh-My-Zsh**: Install if not already present: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
4. **Powerlevel10k**: Install the theme and fonts if needed
5. **Karabiner-Elements**: Grant accessibility permissions in System Settings

etc.

Please reference the official docs if you're having trouble setting up a specific tool.

Further, if you'd like to add your own package: 

1. Create a new directory in this repository with the package name
2. Add your config files in the same structure as they appear in `$HOME`
3. Run `./install.sh <package-name>` to symlink it

Example:
```bash
mkdir -p my-tool/.config/my-tool
echo "config=true" > my-tool/.config/my-tool/config.toml
./install.sh my-tool
```

I found this [video](https://www.youtube.com/watch?v=dQw4w9WgXcQ)[^1] to be especially helpful for understanding the underlying workflow.

# Troubleshooting

**Stow conflicts**: If stow reports conflicts, you may need to back up existing configs:
```bash
mv ~/.config/nvim ~/.config/nvim.backup
./install.sh nvim
```

**Broken symlinks**: To fix broken symlinks after moving the repo:
```bash
./install.sh restow
```

**Check what would happen**: Always test with dry-run first:
```bash
./install.sh dry-run
```

# Package Overview

## Window Management & UI

- ### Aerospace
  - **i3-inspired tiling window manager for macOS**: [**nikitabobko/AeroSpace**](https://github.com/nikitabobko/AeroSpace)

- ### Sketchybar
  - **Highly customizable macOS menu bar replacement**: [**FelixKratz/SketchyBar**](https://github.com/FelixKratz/SketchyBar)

- ### Karabiner
  - **Powerful keyboard remapping for macOS**: [**pqrs-org/Karabiner-Elements**](https://github.com/pqrs-org/Karabiner-Elements)

## Shell & Terminal

- ### iTerm2
  - **Feature-rich terminal emulator for macOS**: [**gnachman/iTerm2**](https://github.com/gnachman/iTerm2)

- ### Zsh
  - **Interactive shell with extensive customization**: [**zsh-users/zsh**](https://github.com/zsh-users/zsh)

- ### Tmux
  - **Terminal multiplexer + management for sessions, windows, and panes**: [**tmux/tmux**](https://github.com/tmux/tmux)

- ### Envman
  - **Centralized management of shell variables, aliases, and functions**: [**tariibaba/envman**](https://github.com/tariibaba/envman)

## File Management & Navigation

- ### Yazi
  - **Modern TUI file manager with image previews**: [**sxyazi/yazi**](https://github.com/sxyazi/yazi)

- ### Fzf
  - **Interactive fuzzy search for files, commands, and more**: [**junegunn/fzf**](https://github.com/junegunn/fzf)

- ### Eza
  - **Enhanced `ls` with icons and git integration**: [**eza-community/eza**](https://github.com/eza-community/eza)

- ### Zoxide
  - **Smarter `cd` that learns your habits**: [**ajeetdsouza/zoxide**](https://github.com/ajeetdsouza/zoxide)

## Text Editing & Viewing

- ### Neovim
  - **Hyperextensible Vim-based text editor**: [**neovim/neovim**](https://github.com/neovim/neovim)

- ### Bat
  - **Enhanced `cat` with syntax highlighting**: [**sharkdp/bat**](https://github.com/sharkdp/bat)

- ### Sioyek
  - **Keyboard-focused PDF reader optimized for academic work**: [**ahrm/sioyek**](https://github.com/ahrm/sioyek)

## Development Tools

- ### Git
  - **Distributed version control system**: [**git/git**](https://github.com/git/git)

- ### SSH
  - **Secure shell configuration for remote access and authentication**

- ### GitHub CLI (gh)
  - **Official GitHub command-line tool**: [**cli/cli**](https://github.com/cli/cli)

## System Monitoring

- ### Btop
  - **Beautiful terminal-based system monitor**: [**aristocratos/btop**](https://github.com/aristocratos/btop)

- ### Htop
  - **Interactive process monitoring tool**: [**htop-dev/htop**](https://github.com/htop-dev/htop)

- ### S-tui
  - **CPU monitoring and stress testing**: [**amanusk/s-tui**](https://github.com/amanusk/s-tui)

- ### Fastfetch
  - **`Neofetch` alternative with faster performance**: [**fastfetch-cli/fastfetch**](https://github.com/fastfetch-cli/fastfetch)

## Productivity & Utilities

- ### iCalBuddy
  - **macOS calendar integration inside terminal and tmux**: [**dkaluta/icalBuddy64**](https://github.com/dkaluta/icalBuddy64)

- ### Thefuck
  - **Auto-correct mistyped commands**: [**nvbn/thefuck**](https://github.com/nvbn/thefuck)

- ### yt-dlp
  - **Download videos from YouTube and other platforms**: [**yt-dlp/yt-dlp**](https://github.com/yt-dlp/yt-dlp)
- ### Scripts
  - **Personal collection of maintenance and utility scripts**

# Security Note

Sensitive files were excluded via `.gitignore`. This includes, but is not limited to, login credentials, API keys, SSH public-private key pairs, secrets, environment variables, etc. 

Never commit credentials or secrets to version control!

# License

These are personal configurations. Feel free to use, modify, and adapt them for your own needs.

# Acknowledgments

Configurations inspired by the broader open-source & dotfiles community. Special thanks to:
- NVChad for the excellent Neovim framework
- The Catppuccin team for the beautiful color scheme
- The GNU Stow maintainers for the simple yet powerful tool

[^1]: jk lol, here you go: https://youtu.be/y6XCebnB9gs?si=APiYpB2Mvqn-gcA3
