#!/bin/bash

function run() {
  if ! pgrep $1; then
    $@ &
  fi
}

(
  killall picom -s 9
  sleep 1
  sh $HOME/Scripts/picom-toggle-xmonad.sh &
) &

sh $HOME/.config/polybar/launch-xmonad.sh &
