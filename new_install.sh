##### Installation prior to chroot'ing #####




## This might be needed instead of the following method.
# https://stackoverflow.com/questions/8157931/bash-executing-commands-from-within-a-chroot-and-switch-user
#chroot /chroot_dir /bin/bash -c "su - -c ./startup.sh"

##### Set up commands to run in chroot environment #####
# https://stackoverflow.com/questions/8157931/bash-executing-commands-from-within-a-chroot-and-switch-user
# https://bbs.archlinux.org/viewtopic.php?id=154755
cat << EOF | arch-chroot /mnt


sudo pacman -Syu chromium wget -y


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
untar
unzip
cd ttf-iosevka
sudo makepkg -si ...


EOF
