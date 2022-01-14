#!/bin/bash

export PATH="${PATH}:$HOME/bin"
rsblocks &
nitrogen --restore &
ibus-daemon
ibus restart
xbindkeys &
picom &
