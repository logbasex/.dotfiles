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

if [ ! -d gitstatus ]; then
    git clone https://github.com/romkatv/gitstatus.git
fi

if [ ! -d powerlevel10k ]; then
    git clone https://github.com/romkatv/powerlevel10k.git
fi

yay -S --needed \
    google-chrome \
    spotify \
    visual-studio-code-bin  \
    teamviewer  \
    slack-desktop  \
    dropbox  \
    polybar  \
    dolphin  \
    redshift  \
    vlc  \
    spectacle  \
    kwalletmanager  \
    kinfocenter  \
    ark  \
    thunderbird \
    terminator \
    latte-dock \
    grc-solarized \
    yubico-pam \
    openvpn \
    networkmanager-openvpn \
    plasma-pa \
    pulseaudio \
    bluez \
    bluez-utils \
    throttled \
    cryfs \
    dnscrypt-proxy \
    dnsmasq \
    sudo \
    zsh \
    wget \
    powertop \
    tlp \
    python \
    python-pip \
    dnsutils \
    yubikey-full-disk-encryption \
    libinput \
    rts5227-dkms \
    hunspell-da \
    hunspell \
    aspell-da \
    aspell-en \
    binutils \
    fakeroot \
    thermald \
    lm_sensor \
    kscreen \
    plasma-vault \
    plasma-thunderbolt \
    powerdevil \
    user-manager \
    fwupd \
    ttf-dejavu \
    ttf-liberation \
    virtualbox \
    virtualbox-ext-oracle

sudo pip install dotbot
sudo dotbot -c ~/.dotfiles/archlinux/install.conf.yaml

chsh -s /usr/bin/zsh
sudo sensors-detect

sudo systemctl enable lenovo_fix.service tlp dnscrypt-proxy dnsmasq reflector.service reflector.timer thermald
sudo systemctl start lenovo_fix.service tlp dnscrypt-proxy dnsmasq reflector.service reflector.timer thermald

#if [ ! -d cryptboot ]; then
#    git clone https://github.com/xmikos/cryptboot.git
#    cd cryptboot
#    makepkg -si --skipchecksums
#    cd ~
#    sudo cryptboot-efikeys create
#    sudo cryptboot-efikeys enroll
#    sudo cryptboot update-grub
#fi

yay -Yc
