#!/usr/bin/env zsh

. ~/.scripts/defs.zsh

# Init Install
initInstall "install_init"
sound count-down &

#####################
# init distro check #
#####################

# Config pacman
if [ -f /etc/pacman.conf ]; then
	sed 's/^#Color$/Color/g' </etc/pacman.conf >pacman.conf
	sudo mv pacman.conf /etc/
	sed 's/^.*ParallelDownloads.*$/ParallelDownloads = 5/g' </etc/pacman.conf >pacman.conf
	sudo mv pacman.conf /etc/
	errorCheck "pacman config"
fi

# Config pamac
if [ -f /etc/pamac.conf ]; then
	sed 's/^.*ILoveCandy$/ILoveCandy/g' </etc/pamac.conf >pamac.conf
	sudo mv pamac.conf /etc/
	sed 's/^.*EnableAUR$/EnableAUR/g' </etc/pamac.conf >pamac.conf
	sudo mv pamac.conf /etc/
	sed 's/^.*KeepBuiltPkgs$/KeepBuiltPkgs/g' </etc/pamac.conf >pamac.conf
	sudo mv pamac.conf /etc/
	errorCheck "pamac config"
fi

sudo pacman -S --noconfirm --needed git base-devel colorgcc go ruby rust
errorCheck "installation base-devel"

# Prompt installieren
inst ttf-meslo-nerd-font-powerlevel10k
inst zsh-theme-powerlevel10k

# disable sudo password
echo "Cmnd_Alias INSTALL = /usr/bin/pacman, /usr/share/pacman
Cmnd_Alias POWER = /usr/bin/pm-hibernate, /usr/bin/pm-powersave, /usr/bin/pm-suspend-hybrid, /usr/bin/pm-suspend
Defaults timestamp_timeout=300
$USER ALL=(ALL) NOPASSWD:INSTALL,POWER
$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/100-myrules

chmod -R -v +x ~/.scripts
chmod -R -v +x ~/.bin
errorCheck "set script flags"

###############################
# uninstall unneeded packages #
###############################
fullUninstall

#################################
# install all (needed) packages #
#################################
fullInstall

## FINISHING #
finish

sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

sound complete
