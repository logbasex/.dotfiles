#!/bin/bash
cd ~
git clone https://aur.archlinux.org/yay.git
git clone https://github.com/kwin-scripts/kwin-tiling.git

if [ ! $(which yay) ]; then
    cd yay
    makepkg -si
    cd ~
fi

cd kwin-tiling/
plasmapkg2 --type kwinscript -i .
cd ~

yay -S google-chrome spotify visual-studio-code-bin teamviewer slack-desktop dropbox polybar dolphin redshift vlc spectacle kwalletmanager kinfocenter ark thunderbird terminator latte-dock grc-solarized zsh-theme-powerlevel10k-git prezto-git yubico-pam
yay -S openvpn networkmanager-openvpn plasma-pa pulseaudio bluez bluez-utils throttled cryfs dnscrypt-proxy dnsmasq sudo zsh wget powertop tlp konsole python python-pip openssh dnsutils yubikey-full-disk-encryption libinput rts5227-dkms hunspell-da hunspel aspell-da aspell-en
yay -S papirus-icon-theme-kde
yay -S ttf-dejavu ttf-liberation
yay -Yc

sudo pip install dotbot
sudo dotbot -c ~/.dotfiles/archlinux/install.conf.yaml

chsh -s /usr/bin/zsh

sudo systemctl enable lenovo_fix.service tlp dnscrypt-proxy dnsmasq reflector.service reflector.timer
sudo systemctl start lenovo_fix.service tlp dnscrypt-proxy dnsmasq reflector.service reflector.timer
sudo chattr +i /etc/resolv.conf
