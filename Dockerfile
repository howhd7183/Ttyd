FROM debian:bullseye-slim

# Install tmate + dependencies
RUN apt-get update && apt-get install -y \
    tmate openssh-client curl git \
    && rm -rf /var/lib/apt/lists/*

# Default working directory
WORKDIR /root

# Startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
