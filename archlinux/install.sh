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

if [ ! -d xmm7360-pci ]; then
    git clone https://github.com/xmm7360/xmm7360-pci.git
    make
    make load
fi

yay -S --needed --noconfirm \
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
    hunspell-da \
    hunspell \
    aspell-da \
    aspell-en \
    binutils \
    fakeroot \
    thermald \
    lm_sensors \
    kscreen \
    plasma-vault \
    plasma-thunderbolt \
    powerdevil \
    user-manager \
    fwupd \
    ttf-dejavu \
    ttf-liberation \
    virtualbox \
    virtualbox-ext-oracle \
    sof-firmware \
    udisks2 \
    alsa-utils \
    modemmanager \
    mobile-broadband-provider-info \
    usb_modeswitch \
    gufw \
    freeoffice \
    lastpass-cli \
    xsel \
    net-tools \
    rtl8822bu-dkms-git \
    docker \
    k9s \
    bluedevil \
    korganizer \
    kubectl

sudo pip install dotbot ansible ipaddr pip-review pyroute2
sudo pip install --user ConfigArgParse
sudo dotbot -c ~/.dotfiles/archlinux/install.conf.yaml

if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto"]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi

if [ "$SHELL" != "/usr/bin/zsh" ]; then
    chsh -s /usr/bin/zsh
fi

sudo sensors-detect --auto

sudo systemctl enable tlp dnscrypt-proxy dnsmasq reflector.service reflector.timer thermald docker
sudo systemctl start tlp dnscrypt-proxy dnsmasq reflector.service reflector.timer thermald docker

#if [ ! -d cryptboot ]; then
#    git clone https://github.com/xmikos/cryptboot.git
#    cd cryptboot
#    makepkg -si --skipchecksums
#    cd ~
#    sudo cryptboot-efikeys create
#    sudo cryptboot-efikeys enroll
#    sudo cryptboot update-grub
#fi

yay --noconfirm -Yc
