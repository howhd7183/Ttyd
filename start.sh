#!/bin/bash
echo "Starting tmate session..."

# Run tmate in background
tmate -F > /tmp/tmate.log 2>&1 &
sleep 5

# Extract links
SSH_LINK=$(grep -m1 "ssh" /tmp/tmate.log)
WEB_LINK=$(grep -m1 "https" /tmp/tmate.log)

# Write links to index.html
mkdir -p /var/www/html
{
  echo "<h1>Tmate Session</h1>"
  echo "<p>SSH: $SSH_LINK</p>"
  echo "<p>Web: <a href='$WEB_LINK'>$WEB_LINK</a></p>"
} > /var/www/html/index.html

# Start simple HTTP server on $PORT
PORT=${PORT:-10000}
echo "Starting web server on port $PORT..."
python3 -m http.server "$PORT" --directory /var/www/html &
tail -f /tmp/tmate.log
