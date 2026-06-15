function pomo() {
    arg1=$1
    shift
    args="$*"

    min=${arg1:?Example: pomo 15 Take a break}
    sec=$((min * 60))
    msg="${args:?Example: pomo 15 Take a break}"

    printf "Remaining: "
    tput sc
    while true; do
      tput rc
      tput el
      printf "%d " $sec;
      sleep 1;
      sec=$((sec - 1));
      if [ $sec -le 0 ]; then
        break;
      fi
    done
    osascript -e "display notification \"${msg}\" with title \"Pomo CLI\" sound name \"Bottle.aiff\""
    # Inside tmux the macOS banner is easy to miss, so surface a popup too.
    if [ -n "$TMUX" ]; then
      tmux display-popup -T ' Pomo CLI ' -w 50 -h 6 -E \
        "printf '\\n  %s\\n\\n  press Enter to close ' '${msg}'; read"
    fi
    print "\n"
}
