#!/bin/bash
echo "Starting tmate..."

# Create a new detached tmate session
tmate -S /tmp/tmate.sock new-session -d

# Wait until session is ready
tmate -S /tmp/tmate.sock wait tmate-ready

# Print links directly to Render logs
SSH_LINK=$(tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}')
WEB_LINK=$(tmate -S /tmp/tmate.sock display -p '#{tmate_web}')

echo "========================================"
echo "Tmate session is ready!"
echo "SSH: $SSH_LINK"
echo "Web: $WEB_LINK"
echo "========================================"

# Also expose on web page
mkdir -p /var/www/html
{
  echo "<h1>Tmate Session</h1>"
  echo "<p>SSH: <code>$SSH_LINK</code></p>"
  echo "<p>Web: <a href='$WEB_LINK'>$WEB_LINK</a></p>"
} > /var/www/html/index.html

# Start web server immediately (so Render sees the port)
PORT=${PORT:-10000}
echo "Starting web server on 0.0.0.0:$PORT..."
python3 -m http.server "$PORT" --bind 0.0.0.0 --directory /var/www/html
