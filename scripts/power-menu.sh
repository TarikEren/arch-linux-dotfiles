#usr/bin/env bash

# Constants
SHUTDOWN="  Shutdown"
RESTART="  Restart"
LOCK="  Lock"
HIBERNATE="󰤄  Hibernate"

opt=$(echo -e "$SHUTDOWN\n$RESTART\n$LOCK\n$HIBERNATE" | walker --dmenu -H)

case "$opt" in
"$SHUTDOWN")
  hyprshutdown -t "Shutting down" --post-cmd "shutdown now"
  ;;

"$RESTART")
  hyprshutdown -t "Restarting" --post-cmd "reboot"
  ;;

"$HIBERNATE")
  echo "Hibernating"
  ;;

"$LOCK")
  hyprlock
  ;;

*)
  exit 1
  ;;
esac
