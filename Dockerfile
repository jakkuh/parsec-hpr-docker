FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y \
    curl \
    wget \
    gnupg \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /root/.gnupg && \
    chmod 700 /root/.gnupg

# Create directories
RUN mkdir -p /app/bin

# Copy scripts
COPY scripts/ /scripts/
RUN chmod +x /scripts/*

# Environment variables
ENV WAN_IP=0.0.0.0
ENV PUBLIC_IP=""
ENV PRIVATE_IP=""
ENV PUBLIC_PORT=5000
ENV PRIVATE_PORT=4900
ENV HPR_DOWNLOAD_URL="https://builds.parsec.app/hpr/parsechpr2.0.0.linux-amd64.tar.gz"
ENV HPR_VERSION=""
ENV VERIFY_SIGNATURE="true"
ENV HPR_DATA_DIR="/data"
ENV TEAM_ID=""
ENV SECRET=""

EXPOSE $PUBLIC_PORT
EXPOSE $PRIVATE_PORT

VOLUME ["/data"]
ENTRYPOINT ["/scripts/entrypoint.sh"]