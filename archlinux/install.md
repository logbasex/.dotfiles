# Fully Encrypted Arch Linux with LVM on LUKS, encrypted boot and suspend-to-disk

# Download the archlinux
Download the archlinux -*.iso image from https://www.archlinux.org/download/ and its GnuPG signature.
```
$ gpg -v archlinux-2019.11.01-x86_64.iso.sig
```

Burn the archlinux-*.iso  to a 1+ Gb USB stick.  On Mac, do something like:
```
$ diskutil unmountDisk /dev/disk4
$ sudo dd bs=4m of=/dev/rdisk4 if=archlinux-2020.01.01-x86_64.iso
```

-----------------------------------
# Installation
Set your keymap only if not you are not using the default English language.

```
$ loadkeys dk
```

Connect to WiFi using:

```
$ wifi-menu
```

Fix partition of the host

```
$ cfdisk /dev/sda
```

We need ONLY three partitions!
Partition 1 = 512 MiB EFI partition # Hex code EF00
Partition 2 = 1024 MiB Partition for Boot # Hex code 8300.
Partition 3 = Just size it to the last sector of your drive. # Hex code 8300.

Zero-out each of of your new partitions prior to creating filesystems on them.
```
$ cat /dev/zero > /dev/sda1
$ cat /dev/zero > /dev/sda2
$ cat /dev/zero > /dev/sda3
```

Create a filesystem for /efi
```
$ mkfs.vfat -F 32 -n EFI /dev/sda1
```

Encrypt and open your system partition
```
$ cryptsetup -c aes-xts-plain64 -h sha265 -s 256 --use-random --type luks1 luksFormat /dev/sda2
$ cryptsetup -c aes-xts-plain64 -h sha265 -s 256 --use-random --type luks1 luksFormat /dev/sda3
```

> Speedup boot loader: https://linux-blog.anracom.com/2018/11/30/full-encryption-with-luks-sha512-aes-xts-plain64-grub2-really-slow/

> Note our use of the critical '--type luks1' encryption switch.  The default Type 2 LUKS encryption PREVENTS Grub from
> being able to properly decrypt an encrypted /boot.  This is also precisely why an existing encrypted Arch system which used
> standard LUKS Type 2 encryption CANNOT be converted into an encrypted /boot system.  A clean install is necessary!

Open the encrypted device:

```
$ cryptsetup luksOpen /dev/sda2 encrypted-boot
$ cryptsetup luksOpen /dev/sda3 encrypted-lvm
```

## Create encrypted LVM partitions
Modify this structure only if you need additional, separate partitions.  The sizes used below are only suggestions.
The VG and LV labels 'Arch, root and swap' can be changed to anything memorable to you.  Use your labels consistently, below!

```
$ pvcreate /dev/mapper/encrypted-lvm
$ vgcreate luks /dev/mapper/encrypted-lvm
$ lvcreate -L 16G luks -n swap
$ lvcreate -l 100%FREE luks -n root
```

## Create filesystems on your encrypted partitions
```
$ mkswap /dev/mapper/luks-swap
$ mkfs.xfs /dev/mapper/luks-root
$ mkfs.ext2 /dev/mapper/encrypted-boot
```

## Mount the new system
```
$ mount /dev/mapper/luks-root /mnt
$ mkdir /mnt/boot
$ mount /dev/mapper/encrypted-boot /mnt/boot
$ mkdir /mnt/efi
$ mount /dev/sda1 /mnt/efi
$ swapon /dev/mapper/luks-swap
```

## Optional - Select the 10 most recently synchronized HTTPS mirrors
Using reflector we will get the 10 most recently HTTPS mirrors and sort them by download speed, and overwrite the file /etc/pacman.d/mirrorlist.
This is to make sure we only download packages using HTTPS.

```
$ pacman -Sy reflector
$ reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
```

# Install your Arch system
```
$ pacstrap /mnt base base-devel grub-efi-x86_64 efibootmgr dialog wpa_supplicant linux linux-headers dkms dhcpcd netctl lvm2 linux-firmware iw vim reflector mkinitcpio
```

## Create and review FSTAB
```
$ genfstab -U /mnt >> /mnt/etc/fstab
```

## Enter the new system
```
$ arch-chroot /mnt /bin/bash
```

## Set the system clock
```
$ ln -s /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime
$ hwclock --systohc --utc
$ timedatectl set-ntp true
$ localectl set-keymap dk
```

## Assign your hostname
```
$ hostnamectl set-hostname x1-carbon
$ echo x1-carbon > /etc/hostname
```

## Set or update your locale
If English is your native language, you need to edit exactly two lines to correctly configure your locale language settings:
a. In /etc/locale.gen **uncomment only**: en_US.UTF-8 UTF-8
b. In /etc/locale.conf, you should **only** have this line: LANG=en_US.UTF-8

Now run:
```
$ locale-gen
```

## Set keymap for console
```
$ echo "KEYMAP=dk" > /etc/vconsole.conf
```

## Set your root password
```
$ passwd
```

## Create a User
Assign appropriate Group membership, and set a User password.  'Wheel' is just one important Group.
```
$ useradd -m -G wheel,storage,power,network,uucp -s /bin/bash MyUserName
$ passwd MyUserName
```

> Type: visudo and find this line: # %wheel ALL=(ALL) ALL and delete # character

## Let's create our crypto keyfile:
```
$ mkdir -p /etc/initcpio/keys
$ dd bs=512 count=8 iflag=fullblock if=/dev/urandom of=/etc/initcpio/keys/encrypted-boot.key
$ dd bs=512 count=8 iflag=fullblock if=/dev/urandom of=/etc/initcpio/keys/encrypted-lvm.key
$ chmod 0000 /etc/initcpio/keys/*
$ chattr +i /etc/initcpio/keys/*
$ chmod 0400 /boot/initramfs-linux*
$ cryptsetup luksAddKey /dev/sda2 /etc/initcpio/keys/encrypted-boot.key
$ cryptsetup luksAddKey /dev/sda3 /etc/initcpio/keys/encrypted-lvm.key
```

# Create custom hook
decryption-keys is a custom hook we will implement ourselves in order to add files to the root of the initramfs without keeping the files in our root filesystem (as we have to if we use the FILES array). Create a new file at /etc/initcpio/install/decryption-keys, and fill it with the below.

```
#!/bin/bash
function build {
  for file in /etc/initcpio/keys/*; do
    add_file "$file" "/$(basename $file)" 0400
  done
}
```

Configure mkinitcpio with the correct FILES statement and proper HOOKS required for your initrd image:
```
$ vim /etc/mkinitcpio.conf
```

SET THE FOLLOWING OPTIONS
```
MODULES(xfs)
HOOKS=(base udev keyboard keymap consolefont autodetect modconf block encrypt lvm2 resume decryption-keys filesystems fsck)
```


## Generate your initrd image
```
$ mkinitcpio -p linux
```

## Install and Configure Grub-EFI
Since we need grub to decrypt our encrypted /boot, we first need to configure grub so that it knows we are working with a LUKS encrypted disk.

```
$ vim /etc/default/grub
```

UNCOMMENT this line:
`GRUB_ENABLE_CRYPTODISK=y`

The correct way to install grub on an UEFI computer, irrespective of your use of a HDD or SSD, and whether you are installing dedicated Arch, or multi-OS booting, for our encrypted /boot purposes is:

```
$ grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=ArchLinux --recheck
```

Edit /etc/default/grub so it includes a statement like this:

```
GRUB_CMDLINE_LINUX="cryptdevice=UUID=%uuid%:encrypted-lvm root=/dev/mapper/luks-root resume=/dev/mapper/luks-swap cryptkey=rootfs:/encrypted-lvm.key"
```

Then replace %uuid% with the UUID of the LVM partition. This can of course be done manually, but when stuck in a terminal, it might be easier to do with sed

$ sed -i s/%uuid%/$(blkid -o value -s UUID /dev/sda3)/ /etc/default/grub

> If you are not using swap, eliminate the 'resume' statement above.

## Generate Your Final Grub Configuration:
```
$ grub-mkconfig -o /boot/grub/grub.cfg
```

## Update crypttab
Create an entry in /etc/crypttab to make systemd decrypt and mount the boot partition automatically on successful boot using its keyfile
```
encrypted-boot UUID=%uuid% /etc/initcpio/keys/encrypted-boot.key luks
```
Again, replace %uuid% with the actual UUID of the boot partition at /dev/sda2
```
# sed -i s/%uuid%/$(blkid -o value -s UUID /dev/sda2)/ /etc/crypttab
```

## Exit Your New Arch System
```
$ exit
```

## Backup your headers
```
$ cryptsetup luksHeaderBackup /dev/sda2 --header-backup-file=/mnt/efi/luks-header
$ cp /mnt/etc/lvm /mnt/efi/lvm-backup -Rafv
```

## Unmount all partitions
```
$ umount -R /mnt
$ swapoff -a
```

## Reboot
Enjoy Your Encrypted BOOT Arch Linux System!
```
$ reboot
```

# The new Arch Linux System
If you have problems connecting to wifi, try start disable power save on the netcard:
```
$ iw dev wlan0 set power_save off
```

## Reconnect to wifi
```
$ wifi-menu
```

Log in as root, and not as a user, and setup Plasma.
Setup reflector again and install required packages.

```
$ reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
$ pacman -Sy plasma-desktop sddm networkmanager plasma-nm fwupd intel-ucode xf86-video-intel git openssh terminator
```

## Finalize setup
```
$ systemctl enable sddm NetworkManager
$ pacman -R netctl dhcpcd
$ reboot
```

Log in to sddm's GUI as your user
Complete the setup , by opening the Terminator shell and do:

```
$ git clone https://github.com/woopstar/dotfiles ~/.dotfiles
$ bash ~/.dotfiles/archlinux/install.sh
```

# References
https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS
https://blog.stigok.com/2018/05/03/lvm-in-luks-with-encrypted-boot-partition-and-suspend-to-disk.html
https://gist.github.com/HardenedArray/ee3041c04165926fca02deca675effe1
