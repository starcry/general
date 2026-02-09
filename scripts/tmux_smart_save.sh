#!/bin/bash

# 1. Iterate through all panes in the current session
tmux list-panes -s -F "#{pane_id} #{pane_current_command}" | while read -r pane_id cmd; do
    # 2. Check if the pane is running nvim
    if [[ "$cmd" == "nvim" ]]; then
        echo "Saving Neovim session in pane $pane_id..."
        # 3. Send Escape to ensure Normal mode
        tmux send-keys -t "$pane_id" Escape
        # 4. Send <space>ws to trigger auto-session save (adjust if leader is different)
        tmux send-keys -t "$pane_id" " ws"
        # 5. Send :wa to save all buffers
        tmux send-keys -t "$pane_id" ":wa" Enter
    fi
done

echo "Waiting for Neovim to save..."
sleep 2

# 6. Save tmux session using tmux-resurrect
echo "Saving Tmux session..."
~/.tmux/plugins/tmux-resurrect/scripts/save.sh

# 7. Kill the tmux server
echo "Killing Tmux server..."
tmux kill-server
