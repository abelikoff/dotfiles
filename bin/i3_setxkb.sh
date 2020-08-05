#!/bin/bash

# turn Caps Lock into Control
setxkbmap -option ctrl:nocaps

# keyboard layout
setxkbmap -option grp:switch,grp:rctrl_toggle,grp_led:scroll,compose:menu -layout 'us,ru' -variant ',phonetic_mac'
