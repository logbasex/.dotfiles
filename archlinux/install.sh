#!/bin/bash
cd ~
git clone https://aur.archlinux.org/yay.git
git clone https://github.com/kwin-scripts/kwin-tiling.git
git clone https://github.com/woopstar/dotfiles ~/.dotfiles
cd yay
makepkg -si
cd ~
cd kwin-tiling/
plasmapkg2 --type kwinscript -i .
cd ~

chsh -s $(which zsh)
yay -S google-chrome spotify visual-studio-code-bin teamviewer slack-desktop dropbox polybar dolphin redshift vlc spectacle kwalletmanager kinfocenter ark thunderbird terminator latte-dock grc-solarized zsh-theme-powerlevel10k-git prezto-git yubico-pam
yay -S openvpn networkmanager-openvpn plasma-pa pulseaudio bluez bluez-utils throttled cryfs dnscrypt-proxy dnsmasq sudo zsh wget powertop tlp konsole python python-pip openssh
yay -S papirus-icon-theme-kde
yay -S ttf-dejavu ttf-liberation
yay -Yc

pip install dotbot
dotbot -c ~/.dotfiles/archlinux/install.conf.yaml

systemctl enable lenovo_fix.service tlp dnscrypt-proxy dnsmasq
systemctl start lenovo_fix.service tlp dnscrypt-proxy dnsmasq
