# TODO: 
# write a shell script that randomly selects from a list of screensaver commands every hour
# the script should clear the screen after each interval 
# the same command can be selected consecutively
# currently need a way to launch and kill processes effectively (both via timeout & ctrl-c)

# #!/bin/bash
#
# commands=(
#     "cmatrix"
#     "cbonsai -L 60 -l -i"
#     "pipes.sh -t 0"
#     "asciiquarium"
# )
#
# # Trap Ctrl+C to clean up background process
# cleanup() {
#     if [ ! -z "$command_name" ]; then
#         pkill -P $$ 2>/dev/null  # Kill all child processes of this script
#     fi
#     clear
#     exit 0
# }
#
# trap cleanup SIGINT SIGTERM
#
# while true; do
#     random_index=$((RANDOM % ${#commands[@]}))
#     selected_command="${commands[$random_index]}"
#     command_name=$(echo "$selected_command" | awk '{print $1}')
#
#     clear
#
#     # Run the command in background
#     eval $selected_command &
#     command_pid=$!
#
#     # Sleep for 1 hour
#     # sleep 3600
#     sleep 5
#
#     # Kill all child processes of this script
#     pkill -P $$
#     wait $command_pid 2>/dev/null
# done
