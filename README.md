# neovim-config

Neovim as an IDE configuration.

## Setup

### Requirements

- True Color Terminal
    - MacOS: [iTerm2](https://iterm2.com/)
- [Git](https://git-scm.com/)
- [Neovim](https://neovim.io/)
- [Nerd Font](https://www.nerdfonts.com/)
- [Ripgrep](https://github.com/BurntSushi/ripgrep)

### MacOS (Homebrew)

iTerm2:

```sh
brew install --cask iterm2
```

Git:

```sh
brew install git
```

Nerd Font:

```sh
brew install --cask font-meslo-lg-nerd-font
```

Neovim:

```sh
brew install neovim
```

Ripgrep:

```sh
brew install ripgrep
```

XCode Command Line Tools:

```sh
xcode-select --install
```

### General Setup

1. Backup previous configuration (if any exists).

    Neovim's configurations are located under the following paths, depending on your OS:

    | OS | PATH |
    | :- | :--- |
    | Linux, MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
    | Windows (cmd)| `%localappdata%\nvim\` |
    | Windows (powershell)| `$env:LOCALAPPDATA\nvim\` |

1. Clone the repository onto your local machine.

```sh
git clone -depth=1 git@github.com:justinsimmons/neovim-config.git ~/.config/nvim
```

1. Remove git artifacts:
```sh
rm -rf ~/.config/nvim/.git
rm ~/.config/nvim/.gitignore
rm ~/.config/nvim/README.md
```

### Post Installation

Start Neovim:

```sh
nvim
```

That's it! Lazy will install all the plugins you have. Use `:Lazy` to view
current plugin status. Hit `q` to close the window.

Read through the `init.lua` file in your configuration folder for more
information about extending and exploring Neovim. That also includes
examples of adding popularly requested plugins.

