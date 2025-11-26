# Welcome to my dotfiles!

Here you can find the configs for the tools I use on my dev workflow. This process is a lot easier by using GNU Stow to create symlinks between this repository and your actual .config/ diretory. You can learn more about it [here](https://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html).

## Installation
### 1. Requirements
>Use your package manager of choice.

```bash
# Arch
sudo pacman -S git stow

# Debian
sudo apt install git stow

# Fedora
sudo dnf install git stow
```

### 2. Clone the dotfiles

``` bash
cd ~
git clone https://github.com/Vittv/dotfiles.git
cd dotfiles
```

### 3. Choose what to install

Use GNU Stow to symlink the configs you want. Each command creates symlinks from `~/dotfiles/` to your `~/.config` directory.

Make sure to check each application's [requirements](#neovim) before installing any of the below.

*Install everything:*

`stow */`

*Or install selectively:*
```bash
stow nvim
stow rofi
stow tmux
```

```
├── bashrc
│   └── .bashrc
├── cutefetch
│   └── cutefetch
├── kitty
│   └── .config
│       └── kitty
│           ├── current-theme.conf
│           └── kitty.conf
├── nvim
│   └── .config
│       └── nvim
│           ├── colors
│           ├── init.lua
│           ├── lazy-lock.json
│           └── lua
├── rofi
│   └── .config
│       └── rofi
│           ├── colors.rasi
│           └── config.rasi
├── starship
│   └── .config
│       └── starship.toml
├── tmux
│   └── .config
│       └── tmux
│           └── tmux.conf
└── wint
    └── settings.json
```

## Neovim

I always build nvim from source. Because I'm not sure which plugin needs nvim to be at a more recent version, I recommend also building it from source to use my configs properly. You can follow [this](https://neovim.io/doc/build/) along to build it yourself.

If you have an existing nvim installation, delete any existing runtime dir you have for nvim to prevent errors in your new version. `usr/local/nvim/runtime`. See `:checkhealth` for your current neovim install to confirm what the path is on your machine.

### Requirements
- `nvim -v >= 0.11.5`
- `gcc or clang` (C compiler for Treesitter)
- `node.js` and `npm` (for LSP servers and other plugins)
- `ripgrep` (Telescope fuzzy finding)
- `fd` (Telescope file finding)
- A [Nerd Font](https://www.nerdfonts.com/) for icons used by plugins

Everything, including other dependencies, should be automatically installed when you first open nvim with these configs!

## Tmux

1. [Install tpm](https://github.com/tmux-plugins/tpm?tab=readme-ov-file#installation)
2. Add plugins to ~/.config/tmux/tmux.conf
3. Run tmux (or reload tmux env `tmux source ~/.config/tmux/tmux.conf`)
4. Install plugins with `prefix + I`
