#!/bin/bash
echo "Starting tmate session..."

# Run tmate in background
tmate -F > /tmp/tmate.log 2>&1 &

# Wait until tmate actually gives us a session
echo "Waiting for tmate session to be ready..."
while true; do
    if grep -q "ssh" /tmp/tmate.log && grep -q "https" /tmp/tmate.log; then
        break
    fi
    sleep 2
done

# Print links to Render logs
echo "========================================"
echo " Your tmate session is ready! "
echo "----------------------------------------"
grep -m1 "ssh" /tmp/tmate.log
grep -m1 "https" /tmp/tmate.log
echo "========================================"

# Also write to index.html (optional, so the web page works too)
mkdir -p /var/www/html
{
  echo "<h1>Tmate Session</h1>"
  grep -m1 "ssh" /tmp/tmate.log | sed 's/^/<p>SSH: <code>/' | sed 's/$/<\/code><\/p>/'
  grep -m1 "https" /tmp/tmate.log | sed 's/^/<p>Web: <a href=\"/' | sed 's/$/\">Open<\/a><\/p>/'
} > /var/www/html/index.html

# Start web server on required Render port
PORT=${PORT:-10000}
echo "Starting web server on 0.0.0.0:$PORT..."
python3 -m http.server "$PORT" --bind 0.0.0.0 --directory /var/www/html &

# Stream logs forever (so Render keeps container alive)
tail -f /tmp/tmate.log
