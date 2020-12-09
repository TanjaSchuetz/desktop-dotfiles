#!/usr/bin/env bash

# Function create a scale dialog
filesEdit="code -a --file-uri"
folderEdit="code -a --folder-uri"
# filesEdit="atom "
# folderEdit="atom "

get_config_list() {
    zenity --list \
           --width=400 \
           --height=850 \
           --title="Edit Konfiguation" \
           --text="Konfig file" \
           --column="Option" \
           --column="Datei" \
           --separator=" " \
           --print-column=2 \
           --hide-column=2 \
           --hide-header \
           "🇬 Workspace" "code -r $HOME/dotfiles.code-workspace" \
           "🇬 all (Git)" "$folderEdit $HOME" \
           "📁 config dir" "$folderEdit $HOME/.config" \
           "📁 awesome dir" "$folderEdit $HOME/.config/awesome" \
           "📑 x-files" "$filesEdit $HOME/.x* $HOME/.X*" \
           "📑 bash" "$filesEdit $HOME/.bashrc*" \
           "📑 profile" "$filesEdit $HOME/.profile*" \
           "📑 scripts autostart" "$filesEdit $SCRIPTS/autostart*.sh" \
           "📑 scripts install" "$filesEdit $SCRIPTS/install_all.sh $SCRIPTS/init_install.sh" \
           "📑 scripts ldap" "$filesEdit $SCRIPTS/ldap/*.sh" \
           "📁 scripts dir" "$folderEdit $SCRIPTS" \
           "📁 menu dir" "$folderEdit $SCRIPTS/menu" \
           "📑 ranger" "$filesEdit $HOME/.config/ranger/*.sh $HOME/.config/ranger/*.conf" \
           "📁 broot dir" "$folderEdit $HOME/.config/broot" \
           "📁 picom dir" "$folderEdit  $HOME/.config/picom" \
           "📑 polybar" "$filesEdit $HOME/.config/polybar/*.ini $HOME/.config/polybar/*.sh" \
           "☄ starship" "$filesEdit $HOME/.config/starship.toml" \
           "📑 alacritty" "$filesEdit $HOME/.config/alacritty/alacritty.yml"  \
           "📑 themes" "$filesEdit $HOME/.Xresources* $HOME/.gtkrc-2.0 $HOME/.config/gtk-3.0/* $HOME/.config/gtk-4.0 $HOME/.config/qt5ct/* $HOME/.config/fontconfig/*" \
           "📑 gitignoree" "$filesEdit $HOME/.gitignore"
}

choice=$(get_config_list)

if [ -z "$choice" ]; then
    echo "abort choice"
else
    echo $choice
    $choice &
fi
