#!/bin/bash

export PATH="${PATH}:$HOME/bin"
rsblocks &
nitrogen --restore &
ibus-daemon -drxR
xbindkeys &
picom &
