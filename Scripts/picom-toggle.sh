#!/bin/bash
if pgrep -x "picom" > /dev/null
then
	killall picom
else
    if [ -f $HOME/.config/picom/picom-private.conf ] ; then
        picom --config $HOME/.config/picom/picom-private.conf &
    elif [ -f $HOME/.config/picom/picom.conf ] ; then
            picom --config $HOME/.config/picom/picom.conf &
    fi
fi
