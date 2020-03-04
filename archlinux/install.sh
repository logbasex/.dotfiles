#!/bin/bash
cd ~ || exit

if [ ! -d yay ]; then
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -si
    cd ~ || exit
fi

if [ ! -d kwin-quick-tile-2 ]; then
    git clone https://github.com/tsoernes/kwin-quick-tile-2.git
    cd kwin-quick-tile-2 || exit
    sh install.sh
    cd ~ || exit
fi

if [ ! -d xmm7360-pci ]; then
    git clone https://github.com/xmm7360/xmm7360-pci.git
fi

yay -Syu --needed --noconfirm --nodiffmenu --batchinstall \
spotify \
visual-studio-code-bin \
teamviewer \
slack-desktop \
dropbox \
dolphin \
vlc \
spectacle \
kwalletmanager \
kinfocenter \
ark \
thunderbird \
konsole \
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
ufw \
freeoffice \
lastpass-cli \
xsel \
net-tools \
rtl8822bu-dkms-git \
docker \
k9s \
bluedevil \
korganizer \
kubectl \
npm \
shellcheck \
okular \
chromium-vaapi-bin \
libva-intel-driver \
libva-utils \
sddm-kcm \
plasma-wayland-session \
kio-gdrive \
telepathy-kde-accounts-kcm \
neofetch \
xorg-xrandr \
ethtool \
smartmontools \
acpi_call \
print-manager \
cups \
zip \
xorg-xlsfonts \
xorg-xdpyinfo \
xorg-xbacklight \
xorg-xkill \
unzip \
usbutils \
traceroute \
powerline-fonts \
chromium-widevine \
brightnessctl \
tlp-rdw \
ananicy-git \
usbguard \
dolphin-plugins \
system-config-printer \
pulseaudio-alsa \
pulseaudio-bluetooth \
bluez \
bluez-libs \
bluez-utils \
xprintidle \
tp_smapi \
tlpui \
nerd-fonts-complete \
khotkeys \
nss-mdns \
remmina \
freerdp \
remmina-plugin-rdesktop

sudo pip install dotbot ansible ipaddr pip-review pyroute2
sudo pip install --user ConfigArgParse
sudo dotbot -c /home/ak/.dotfiles/archlinux/install.conf.yaml

if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi

if [ "$SHELL" != "/usr/bin/zsh" ]; then
  chsh -s /usr/bin/zsh
fi

if [ ! -f /usr/local/bin/kubectl-login ]; then
  cd /usr/local/bin || exit
  sudo wget https://github.com/pasientskyhosting/ps-kubectl-login/releases/download/v1.1/kubectl-login-linux
  sudo mv kubectl-login-linux kubectl-login
  sudo chmod +x kubectl-login
  cd ~ || exit
fi

sudo sensors-detect --auto

balooctl suspend
balooctl disable

sudo systemctl stop systemd-rfkill systemd-resolved.service
sudo systemctl disable systemd-rfkill systemd-resolved.service
sudo systemctl mask systemd-rfkill.service systemd-rfkill.service
sudo systemctl enable ananicy ufw tlp dnscrypt-proxy dnsmasq thermald docker usbguard org.cups.cupsd.service avahi-daemon.service bluetooth
sudo systemctl start ananicy ufw tlp dnscrypt-proxy dnsmasq thermald docker usbguard org.cups.cupsd.service avahi-daemon.service bluetooth
sudo btmgmt ssp of

yay --noconfirm -Yc

#if [ ! -d cryptboot ]; then
#    git clone https://github.com/xmikos/cryptboot.git
#    cd cryptboot
#    makepkg -si --skipchecksums
#    cd ~
#    sudo cryptboot-efikeys create
#    sudo cryptboot-efikeys enroll
#    sudo cryptboot update-grub
#fi
