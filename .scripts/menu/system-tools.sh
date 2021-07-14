#!/usr/bin/env bash

myFileManager="thunar"
myTerminal="kitty"
timeCmd="/usr/bin/time -v "
myTestLua=$(eval echo $HOME/.config/awesome/rc.test.lua)

ACTIONS=(
        "🪄 Install Updates" "$myTerminal --hold --title Sys:Upall $timeCmd paru" \
        "🪄 ReInstall All Packages" "$myTerminal --hold --title Sys:Upall $timeCmd pacman -Qqn | pacman -S -" \
        "🪄 Grub Update (BTRFS Snapshots)" "$myTerminal --hold --title Sys:Grubup $timeCmd sudo grub-mkconfig -o /boot/grub/grub.cfg" \
        "🔫 Snapper-Gui (BTRFS Snapshots)" "sudo snapper-gui" \
        "🕰 Timeshift" "timeshift-launcher" \
        "🕰 Timeshift create Snapshot" "$myTerminal --hold --title Sys:Install $timeCmd sudo timeshift --create" \
        "🗂 Belegung Verzeichnisse" "baobab" \
        "🖥 Monitor einrichten" "arandr" \
        "🎫 Erscheinungsbild" "xfce4-appearance-settings" \
        "🎫 Erscheinungsbild (Xfce4)" "xfce4-appearance-settings" \
        "🎫 Erscheinungsbild (Qt5)" "xfce4-appearance-settings" \
        "🧩 Install Base Packages" "$myTerminal --hold --title Sys:Install $timeCmd sh $SCRIPTS/install_base.zsh" \
        "🧩 Install Applications" "$myTerminal --hold --title Sys:Install $timeCmd sh $SCRIPTS/install_apps.zsh" \
        "🧩 Install Virtual Engines" "$myTerminal --hold --title Sys:Install $timeCmd sh $SCRIPTS/install_vm.zsh" \
        "📛 Boot Logs" "qjournalctl" \
        "📛 Log Viewer (Gui)" "glogg" \
        "📛 System Logs (Gui)" "sudo ksystemlog" \
        "📛 System Logs (Console)" "$myTerminal --hold --title Sys:Install $timeCmd journalctl" \
        "📛 xsession Errors" "$myTerminal --title AWMTT multitail -i $HOME/.xsession-errors" \
        "🚧 Awmtt Default Start" "$myTerminal --hold --title AWMTT awmtt start -N --size 1920x1080" \
        "🚧 Awmtt Default Restart" "$myTerminal --title AWMTT awmtt restart" \
        "🚧 Awmtt Default Stop" "$myTerminal --title AWMTT awmtt stop" \
        "🚧 Awmtt Test Start" "$myTerminal --hold --title AWMTT awmtt start -C $myTestLua -D 1 --size 1920x1080" \
        "🚧 Awmtt Test Restart" "awmtt restart" \
        "🚧 Awmtt Test Stop" "awmtt stop"
)


LINECOUNT=$(expr ${#ACTIONS[*]} / 2)
MLINEHEIGHT=$(($LINECOUNT * $LINEHEIGHT))
HEIGHT=$(($MLINEHEIGHT + $LINEOFFSET))


# Function create a scale dialog
select_application() {
    yad --center --on-top --sticky \
        --list \
        --no-headers \
        --width=500 \
        --height=$HEIGHT \
        --title="Edit Konfiguation" \
        --text="APPLICATIONS" \
        --column=Option \
        --column="Aktion" \
        --separator=" " \
        --print-column=2 \
        --hide-column=2 \
        "${ACTIONS[@]}"
}

choice=$(select_application)

if [ -z "$choice" ]; then
    echo "abort choice"
else
    echo excecute: $choice >>/dev/stderr
    $choice &
fi
