# :coffee: .dotfiles

Configuration files managed using stow,

If you are on Arch Linux, installation is as simple as

```bash
sudo pacman -S --noconfirm - < requirements.txt
stow --target ${XDG_CONFIG_HOME:-$HOME/.config} config
```
