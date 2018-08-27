#################################
# Purpose of this Script:
# This will get a basic install of Arch Linux up with Cinnamor desktop, Bluetooth, Zsh, KVM, and sane defaults .

##### Installation prior to chroot'ing #####




## This might be needed instead of the following method.
# https://stackoverflow.com/questions/8157931/bash-executing-commands-from-within-a-chroot-and-switch-user
#chroot /chroot_dir /bin/bash -c "su - -c ./startup.sh"

##### Set up commands to run in chroot environment #####
# https://stackoverflow.com/questions/8157931/bash-executing-commands-from-within-a-chroot-and-switch-user
# https://bbs.archlinux.org/viewtopic.php?id=154755
cat << EOF | arch-chroot /mnt


sudo pacman -Syu chromium wget -y

# Chromium
# https://wiki.archlinux.org/index.php/chromium
# https://aur.archlinux.org/packages/chromium-widevine/
sudo pacman -Syu chromium wget -y
wget https://aur.archlinux.org/cgit/aur.git/snapshot/chromium-widevine.tar.gz
tar -xvf chromium-widevine.tar.gz
cd chromium-widevine
makepkg -sri PKGBUILD


##### Fix for Nemo's "Open Terminal Here" and Guake #####
# https://medium.com/cognitio/open-guake-terminal-here-nemo-plugin-cd8e1af9ec0a
# https://github.com/slgobinath/ubuntu-tweaks/blob/master/open-terminal-here/open-terminal-here.py
# https://github.com/Guake/guake/issues/424
# https://forums.linuxmint.com/viewtopic.php?t=240669
# https://github.com/linuxmint/nemo-extensions/blob/master/nemo-python/README
sudo mkdir /usr/share/nemo-python
sudo mkdir /usr/share/nemo-python/extensions
sudo wget https://raw.githubusercontent.com/slgobinath/ubuntu-tweaks/master/open-terminal-here/open-terminal-here.py --output-document /usr/share/nemo-python/extensions/open-terminal-here.py
nemo -q

##### SublimeText3 - Standard #####
# https://www.sublimetext.com/docs/3/linux_repositories.html#pacman
# Install the GPG key:
curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
sudo pacman -Syu sublime-text

##### Font - Iosevka #####
# Will need to set this as system default font . . .  Somehow.
# https://github.com/be5invis/Iosevka
# https://aur.archlinux.org/packages/ttf-iosevka
cd /home/$USERNAME/
mkdir new_install
cd new_install
wget https://aur.archlinux.org/cgit/aur.git/snapshot/ttf-iosevka.tar.gz
unzip ttf-iosevka.tar.gz
tar -xvf ttf-iosevka.tar
cd ttf-iosevka
sudo makepkg -si PKGBUILD

##### Bluetooth #####
# https://github.com/blueman-project/blueman/issues/547
# https://wiki.archlinux.org/index.php/Bluetooth_headset
# https://wiki.archlinux.org/index.php/bluetooth
sudo pacman -Syul pulseaudio pulseaudio-bluetooth pulseaudio-alsa bluez bluez-libs bluez-utils bluez-firmware pavucontrol blueman
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service




##### Scanning
sudo pacman -Syu sane
# Install driver for ADS-2000
wget https://aur.archlinux.org/cgit/aur.git/snapshot/brscan4.tar.gz
gunzip brscan4.tar.gz
tar -xvf brscan4.tar
cd brscan4
makepkg -si PKGBUILD

# Permission problem for the scanner. Needs sudo to run. The below fixes that.
sudo echo 'ATTRS{idVendor}=="04f9", ATTRS{idProduct}=="60a0", MODE="0664", GROUP="scanner", ENV{libsane_matched}="yes"' /usr/lib/udev/rules.d/49-sane-missing-scanner.rules
# Unplug and plug scanner back in.

##### KVM
# Nested Virtualization
sudo touch /etc/modprobe.d/kvm_intel.conf
sudo echo "options kvm_intel nested=1" >> /etc/modprobe.d/kvm_intel.conf
###
<<COMMENT
Enable the "host passthrough" mode to forward all CPU features to the guest system:
# - If using QEMU, run the guest virtual machine with the following command: qemu-system-x86_64 -enable-kvm -cpu host.
# - If using virt-manager, change the CPU model to host-passthrough (it will not be in the list, just write it in the box).
# - If using virsh, use virsh edit vm-name and change the CPU line to <cpu mode='host-passthrough' check='partial'/>
COMMENT
### Install QEMU core and libvirt abstraction CLI.
sudo pacman -Syu qemu libvirt -y
## Install tools to manage basic networking for VMs.
sudo pacman -Syu ebtables dnsmasq bridge-utils openbsd-netcat -y
## Install libvirt GUI management.
sudo pacman -Syu q virt-manager -y
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service

sudo touch /etc/modprobe.d/blacklist-ipv6.conf
sudo echo "install ipv6 /bin/true" >> /etc/modprobe.d/blacklist-ipv6.conf
sudo echo "blacklist ipv6" >> /etc/modprobe.d/blacklist-ipv6.conf
# reboot system


# Edit /etc/lvm/lvm.conf
issue_discards = 1 # enables TRIM

# Ensure package "lvm2" is installed.

# See what is accessing a certain device:
sudo  fuser -m -v /dev/sda5


EOF
