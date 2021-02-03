#!/usr/bin/env zsh

. ~/.scripts/defs.zsh

errorCheck() {
    retVal=$?
    if [ $retVal -ne 0 ]; then
        print "abort installation script 'install_all': $1"
        exit $retVal
    fi
}

## FINISHING #

sudo rm /var/lib/pacman/db.lck

# refresh icons
sudo gdk-pixbuf-query-loaders --update-cache

if [ ! -f $HOME/.screenlayout/screenlayout.sh ]; then
	print 'Fehler: keine .screenlayout.sh gefunden'
	exit -1
fi

# config lightdm config
sudo mkdir -p /etc/lightdm/lightdm.conf.d
echo "[LightDM]
log-directory=/var/log/lightdm
run-directory=/run/lightdm

[Seat:*]
greeter-session=lightdm-slick-greeter
user-session=xfce
display-setup-script=/opt/screenlayout.sh
"  | sudo tee /etc/lightdm/lightdm.conf.d/10-my-lightdm.conf
errorCheck "lightdm config"

# config slick-greeter
echo "[Greeter]
background=/usr/share/backgrounds/manjaro-wallpapers-18.0/Manjaro-Light2.jpg
theme-name=Materia-dark
icon-theme-name=Papirus-Dark
activate-numlock=true
" | sudo tee /etc/lightdm/slick-greeter.conf
errorCheck "lightdm greeter config"

# powerline in linux console
eval "$PACKER -S --needed --noconfirm terminus-font powerline-fonts"
if [ $IS_GARUDA = true ]; then
    eval "$PACKER -S $PAKKU_ALL terminess-powerline-font-git terminus-font powerline-fonts"
else
    eval "$PACKER -S $PAKKU_ALL terminus-font powerline-fonts"
fi

echo "KEYMAP=de
FONT=ter-powerline-v12n
FONT_MAP=" | sudo tee /etc/vconsole.conf

# grub config

sed 's/.*GRUB_GFXMODE=.*$/GRUB_GFXMODE="1920x1080,auto"/g' </etc/default/grub >grub
sudo mv -f grub /etc/default
if [ $IS_GARUDA = true ]; then
	sudo cp /usr/share/wallpapers/garuda-wallpapers/garuda-boot.png /usr/share/grub/themes/garuda
	sed 's/.*GRUB_THEME=.*$/GRUB_THEME="\/usr\/share\/grub\/themes\/garuda\/theme.txt"/g' </etc/default/grub >grub
	sudo mv -f grub /etc/default
	sed 's/.*desktop-image:.*$/desktop-image: "garuda-boot.png"/g' </usr/share/grub/themes/garuda/theme.txt >theme.txt
	sudo mv -f theme.txt /usr/share/grub/themes/garuda
fi

if [ $IS_MANJARO = true ]; then
	sed 's/.*GRUB_THEME=.*$/GRUB_THEME="\/usr\/share\/grub\/themes\/manjaro\/theme.txt"/g' </etc/default/grub >grub
	sudo mv -f grub /etc/default
fi

if [ $IS_MANJARO != true ]; then
	sed 's/.*GRUB_THEME=.*$/GRUB_THEME="\/boot\/grub\/themes\/Stylish\/theme.txt"/g' </etc/default/grub >grub
	sudo mv -f grub /etc/default
fi
errorCheck "grub config"

micro /etc/default/grub

sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg
errorCheck "grub mkconfig"

# login screen console
sudo cp $SCRIPTS/issue /etc

# Git config for Visual Studio Code
git config --global diff.tool code
git config --global difftool.code.cmd "$(which code) --wait --diff \"\$LOCAL\" \"\$BASE\" \"\$REMOTE\""
git config --global difftool.prompt false

git config --global merge.tool code
git config --global mergetool.code.cmd "$(which code) --wait \"\$MERGED\""
git config --global mergetool.prompt false

git config --global core.editor micro

git config --global user.name "stira"
git config --global user.email "ralf.stich@infoniqa.com"

sudo git config --system core.editor micro

git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=25000'
git config --global push.default simple

git config pull.rebase true   # merge (the default strategy)

git config --global credential.helper /usr/lib/git-core/git-credential-libsecret

# nodejs tools for editors
sudo npm install -g eslint jshint jsxhint stylelint sass-lint markdownlint-cli raml-cop typescript tern js-beautify iconv-lite
errorCheck "install required nodejs-tools"

# Default Browser setzen (vorher $BROWSER Variable entfernen)
export BROWSER=
xdg-settings set default-web-browser google-chrome.desktop

sudo fc-cache -fv
errorCheck "fontcache"

rm -f $PKG_FILE
rm -f $PKG_UNINST_FILE

sudo usermod -aG docker $USER

###########################
# enable services

# printer Service
sudo systemctl enable --now cups
errorCheck "printer service"

# docker
sudo systemctl enable --now docker
errorCheck "docker service"

# webmin
sudo systemctl enable --now webmin
errorCheck "webmin service"

sudo systemctl enable --now bluetooth-autoconnect
errorCheck "bluetooth-autoconnect service"

# pamac
sudo systemctl enable --now snapd.socket
sudo systemctl enable --now apparmor.service
sudo systemctl enable --now snapd.apparmor.service

mkdir -p ~/.config/systemd/user/
sudo cp /usr/lib/systemd/user/pulseaudio-bluetooth-autoconnect.service /etc/systemd/user
systemctl enable pulseaudio-bluetooth-autoconnect --user --now
errorCheck "pulseaudio-bluetooth-autoconnect service"
