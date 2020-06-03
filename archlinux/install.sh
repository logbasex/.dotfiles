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

if [ ! -f /usr/local/bin/kubectl-login ]; then
  sudo wget https://github.com/pasientskyhosting/ps-kubectl-login/releases/download/v1.1/kubectl-login-linux -o /usr/local/bin/kubectl-login
  sudo chmod +x /usr/local/bin/kubectl-login
fi

if [ ! -f /usr/local/bin/dropbox.py ]; then
  sudo wget https://www.dropbox.com/download?dl=packages/dropbox.py -o /usr/local/bin/dropbox.py
  sudo chmod +x /usr/local/bin/dropbox.py
fi

yay -Syu --needed --noconfirm --nodiffmenu --batchinstall \
acpid \
acpi_call \
alsa-utils \
ananicy-git \
ark \
archlinuxcn-keyring \
aspell-da \
aspell-en \
binutils \
bluedevil \
bluez \
bluez \
bluez-libs \
bluez-utils \
bluez-utils \
brightnessctl \
bzip2 \
chromium-vaapi \
chromium-widevine \
cryfs \
cups \
dmenu \
dmenu-lpass-nu \
dnscrypt-proxy \
dnsmasq \
dnsutils \
docker \
dolphin \
dolphin-plugins \
dropbox \
ethtool \
fakeroot \
freeoffice \
freerdp \
fwupd \
git \
git-crypt \
grc-solarized \
gufw \
hunspell \
hunspell-da \
k9s \
khotkeys \
kinfocenter \
kio-gdrive \
konsole \
korganizer \
kscreen \
kubectl \
kubectx \
kwalletmanager \
lastpass-cli \
latte-dock \
libinput \
libva-intel-driver \
libva-utils \
libu2f-host \
lm_sensors \
mobile-broadband-provider-info \
modemmanager \
neofetch \
nerd-fonts-complete \
net-tools \
networkmanager-openvpn \
nodejs \
npm \
nss-mdns \
okular \
openvpn \
plasma-pa \
plasma-thunderbolt \
plasma-vault \
plasma-wayland-session \
powerdevil \
powerline-fonts \
powertop \
print-manager \
pulseaudio \
pulseaudio-alsa \
pulseaudio-modules-bt \
libavcodec.so \
libldac \
python \
python-gpgme \
python-pip \
remmina \
remmina-plugin-rdesktop \
rtl8822bu-dkms-git \
sddm-kcm \
shellcheck \
slack-desktop \
smartmontools \
sof-firmware \
spectacle \
spotify \
sslscan \
sudo \
system-config-printer \
teamviewer \
telepathy-kde-accounts-kcm \
thermald \
thunderbird \
tlp \
tlp-rdw \
tlpui-git \
tpacpi-bat \
traceroute \
ttf-dejavu \
ttf-liberation \
udisks2 \
ufw \
unzip \
usbguard \
usb_modeswitch \
usbutils \
user-manager \
virtualbox \
virtualbox-ext-oracle \
visual-studio-code-bin \
vlc \
wget \
whatmask \
xorg-xbacklight \
xorg-xdpyinfo \
xorg-xkill \
xorg-xlsfonts \
xorg-xrandr \
xprintidle \
xsel \
yubico-pam \
yubikey-full-disk-encryption \
zip \
zsh \
awesome-terminal-fonts \
ttf-camingocode \
pyenv \
pyenv-virtualenv

sudo pip install dotbot ansible ipaddr pip-review pyroute2
sudo pip install --user ConfigArgParse
sudo dotbot -c /home/ak/.dotfiles/archlinux/install.conf.yaml

if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi

if [ "$SHELL" != "/usr/bin/zsh" ]; then
  chsh -s /usr/bin/zsh
fi

sudo systemctl stop systemd-rfkill systemd-resolved.service
sudo systemctl disable systemd-rfkill systemd-resolved.service
sudo systemctl mask systemd-rfkill.service systemd-rfkill.service
sudo systemctl enable ananicy ufw tlp dnscrypt-proxy dnsmasq thermald docker usbguard org.cups.cupsd.service avahi-daemon.service bluetooth acpid
sudo systemctl start ananicy ufw tlp dnscrypt-proxy dnsmasq thermald docker usbguard org.cups.cupsd.service avahi-daemon.service bluetooth acpid

#sudo btmgmt ssp of
sudo pip-review --local
sudo sensors-detect --auto

balooctl suspend
balooctl disable

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
