FROM debian:bullseye-slim

# Install tmate + Python (for web server) + deps
RUN apt-get update && apt-get install -y \
    tmate openssh-client curl git python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
