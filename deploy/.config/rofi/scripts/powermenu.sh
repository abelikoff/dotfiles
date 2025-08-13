#!/usr/bin/env bash

# Define the options for the power menu
# Each option is a string with an icon and a label.
# Icons are from a Nerd Font.
options=" Lock\n Logout\n Suspend\n Reboot\n Shutdown"

# Use rofi to display the menu.
# -dmenu: Run rofi in dmenu mode.
# -p: Set a prompt.
# -theme: Use a custom theme file.
selected_option=$(echo -e "$options" | rofi -dmenu -p "Power" -theme ~/.config/rofi/themes/powermenu.rasi)

# Execute a command based on the selected option.
case $selected_option in
" Lock")
    # Use i3lock or any other screen locker you have configured.
    i3lock-color -c 000000
    ;;
" Logout")
    # Log out of the i3 session.
    i3-msg exit
    ;;
" Suspend")
    # Suspend the system.
    systemctl suspend
    ;;
" Reboot")
    # Reboot the system.
    systemctl reboot
    ;;
" Shutdown")
    # Shut down the system.
    systemctl poweroff
    ;;
esac
