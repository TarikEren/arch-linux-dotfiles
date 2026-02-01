#usr/bin/env bash

# Constants
POWER="  Power"
HEALTH="  Health"

opt=$(echo -e "$POWER\n$HEALTH" | walker --dmenu -H)

case "$opt" in
"$POWER")
  ~/.config/scripts/power-menu.sh
  ;;

"$HEALTH")
  ~/.config/scripts/health-menu.sh
  ;;

*)
  exit 1
  ;;
esac
