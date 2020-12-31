#!/usr/bin/env bash

myFileManager="thunar"
myTerminal="alacritty"
myBrowser="$BROWSER"
timeCmd="/usr/bin/time -v "

# Function create a scale dialog
select_application() {
    zenity --list \
        --width=400 \
        --height=700 \
        --title="Edit Konfiguation" \
        --text="APPLICATIONS" \
        --column=Option \
        --column="Aktion" \
        --separator=" " \
        --print-column=2 \
        --hide-column=2 \
        --hide-header \
        "🧩 Install Applications" "$myTerminal --hold -d 140 44 -t Sys:Install -e $timeCmd sh $SCRIPTS/install_all.sh" \
        "🧩 Install Updates" "$myTerminal --hold -d 140 44 -t Sys:Upall -e $timeCmd yay -Syu --noconfirm" \
        "🪣 Cleanup Installs" "$myTerminal --hold -d 140 44 -t Sys:Cleanup -e $timeCmd sudo pacman -Rns $(pacman -Qtdq)" \
        "🌍 Browser" "$myBrowser" \
        "😃 Emoji Test" "$myTerminal --hold -e curl https://unicode.org/Public/emoji/5.0/emoji-test.txt" \
        "☦ UTF8 Test" "$myTerminal --hold -e curl https://www.w3.org/2001/06/utf-8-test/UTF-8-demo.html" \
        "🌤 Wetter Brakel" "$myTerminal --hold -d 140 44 -t Wetter:Brakel -e curl wttr.in/33034?lang=de" \
        "🌤 Wetter Höxter" "$myTerminal --hold -d 140 44 -t Wetter:Höxter -e curl wttr.in/37671?lang=de" \
        "🌤 Wetter Mainz" "$myTerminal --hold -d 140 44 -t Wetter:Mainz -e curl wttr.in/Mainz?lang=de" \
        "♻ Matrix" "$myTerminal --hold -t matrix -e cmatrix" \
        "📛 xsession Errors" "$myTerminal -t AWMTT -d 140 44 -e multitail -i $HOME/.xsession-errors" \
        "🚧 Awmtt Default Start" "$myTerminal --hold -t AWMTT -d 140 44 -e awmtt start -N --size 1920x1080" \
        "🚧 Awmtt Default Restart" "$myTerminal -t AWMTT -d 140 44 -e awmtt restart" \
        "🚧 Awmtt Default Stop" "$myTerminal -t AWMTT -d 140 44 -e awmtt stop" \
        "🚧 Awmtt Xfce Start" "$myTerminal --hold -t AWMTT -d 140 44 -e awmtt start -C $HOME/.config/awesome/rc-xfce.lua -N -D 2 --size 1920x1080" \
        "🚧 Awmtt Xfce Restart" "$myTerminal --hold -t AWMTT -d 140 44 -e awmtt restart -C $HOME/.config/awesome/rc-xfce.lua -N -D 2 --size 1920x1080" \
        "🚧 Awmtt Xfce Stop" "awmtt stop"
}

choice=$(select_application)

if [ -z "$choice" ]; then
    echo "abort choice"
else
    echo exceute: $choice >>/dev/stderr
    $choice &
fi
