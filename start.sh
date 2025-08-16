#!/bin/bash
echo "Starting tmate session..."

# Run tmate in foreground mode
tmate -F > /tmp/tmate.log 2>&1 &

# Wait until tmate prints SSH/web link
sleep 5
grep -m1 "ssh" /tmp/tmate.log
grep -m1 "https" /tmp/tmate.log

# Keep container alive forever
tail -f /dev/null
