FROM ubuntu:24.04

RUN apt-get update && apt-get install -y curl ca-certificates && \
    curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Add plex user to match UID
RUN useradd -U -d /config -s /bin/false plex

# Fetch and extract S6 overlay
ARG S6_OVERLAY_VERSION=v2.2.0.3
RUN curl -J -L -o /tmp/s6-overlay-amd64.tar.gz https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz && \
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude='./bin' && \
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin && \
    rm -rf /tmp/*

COPY root/ /

ENTRYPOINT ["/init"]
