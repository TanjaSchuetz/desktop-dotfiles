#!/usr/bin/env bash
cd ~
git checkout light-theme -f
xrdb -merge ~/.Xresources
