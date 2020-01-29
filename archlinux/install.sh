#!/bin/bash
cd ~

if [ ! -d yay ]; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ~
fi

if [ ! -d kwin-tiling ]; then
    git clone https://github.com/kwin-scripts/kwin-tiling.git
    cd kwin-tiling/
    plasmapkg2 --type kwinscript -i .
    cd ~
fi

yay -S --needed google-chrome spotify visual-studio-code-bin teamviewer slack-desktop dropbox polybar dolphin redshift vlc spectacle kwalletmanager kinfocenter ark thunderbird terminator latte-dock grc-solarized zsh-theme-powerlevel10k-git prezto-git yubico-pam
yay -S --needed openvpn networkmanager-openvpn plasma-pa pulseaudio bluez bluez-utils throttled cryfs dnscrypt-proxy dnsmasq sudo zsh wget powertop tlp konsole python python-pip openssh dnsutils yubikey-full-disk-encryption libinput rts5227-dkms hunspell-da hunspel aspell-da aspell-en binutils fakeroot
yay -S --needed papirus-icon-theme-kde
yay -S --needed ttf-dejavu ttf-liberation
yay -Yc

sudo pip install dotbot
sudo dotbot -c ~/.dotfiles/archlinux/install.conf.yaml

chsh -s /usr/bin/zsh

sudo systemctl enable lenovo_fix.service tlp dnscrypt-proxy dnsmasq reflector.service reflector.timer
sudo systemctl start lenovo_fix.service tlp dnscrypt-proxy dnsmasq reflector.service reflector.timer

if [ ! -d cryptboot ]; then
    git clone https://github.com/xmikos/cryptboot.git
    cd cryptboot
    makepkg -si --skipchecksums
    cd ~
    cryptboot-efikeys create
    cryptboot-efikeys enroll
    cryptboot update-grub
fi
