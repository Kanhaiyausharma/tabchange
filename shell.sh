# sudo apt-get update
# sudo apt-get install xprintidle
# sudo apt-get install xdotool

# Wanted trigger timeout in milliseconds.
IDLE_TIME=$((180000))

# Sequence to execute when timeout triggers.
trigger_cmd() {
    echo "Triggered action $(date)"
    #xdotool click 3
    #xdotool keydown alt key Tab
    xdotool key ctrl+Tab
    ./shell.sh
}

sleep_time=$IDLE_TIME
triggered=false

# ceil() instead of floor()
while sleep $(((sleep_time+999)/1000)); do
    idle=$(xprintidle)
    if [ $idle -ge $IDLE_TIME ]; then
        if ! $triggered; then
            trigger_cmd
            triggered=true
            sleep_time=$IDLE_TIME
        fi
    else
        triggered=false
        # Give 100 ms buffer to avoid frantic loops shortly before triggers.
        sleep_time=$((IDLE_TIME-idle+100))
    fi
done