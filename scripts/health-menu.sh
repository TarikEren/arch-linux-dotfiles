# usr/bin/env bash

# Constants
GDU="  GNU Disk Utility"
BTOP="  BTOP"
UPDATE="󰚰  Check for updates"
SAVE_SNAPSHOT="  Create snapshot"

opt=$(echo -e "$GDU\n$BTOP\n$UPDATE\n$SAVE_SNAPSHOT" | walker --dmenu -H)

case "$opt" in
"$UPDATE")
  echo "update"
  ;;
"$GDU")
  kitty gdu
  ;;

"$BTOP")
  kitty btop
  ;;

"$SAVE_SNAPSHOT")
  echo "snapshot"
  ;;

*)
  exit 1
  ;;
esac
