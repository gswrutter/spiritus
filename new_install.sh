##### Installation prior to chroot'ing #####




## This might be needed instead of the following method.
# https://stackoverflow.com/questions/8157931/bash-executing-commands-from-within-a-chroot-and-switch-user
#chroot /chroot_dir /bin/bash -c "su - -c ./startup.sh"

##### Set up commands to run in chroot environment #####
# https://stackoverflow.com/questions/8157931/bash-executing-commands-from-within-a-chroot-and-switch-user
cat << EOF | arch-chroot /mnt


sudo pacman -Syu chromium



##### Fix for Nemo's "Open Terminal Here" and Guake #####
# https://medium.com/cognitio/open-guake-terminal-here-nemo-plugin-cd8e1af9ec0a
sudo wget https://raw.githubusercontent.com/slgobinath/ubuntu-tweaks/master/open-terminal-here/open-terminal-here.py --output-document /usr/share/nemo-python/extensions/open-terminal-here.py
nemo -q

##### SublimeText3 - Standard #####
# https://www.sublimetext.com/docs/3/linux_repositories.html#pacman
# Install the GPG key:
curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
sudo pacman -Syu sublime-text






EOF
