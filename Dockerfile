# Blank-canvas sandbox for AI agents and tools.
# No agent is preinstalled. Attach to the running container with `docker exec`.
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Common tooling. Kept small; add more at runtime or in a derived image.
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    sudo \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    jq \
    unzip \
    less \
    vim-tiny \
    && rm -rf /var/lib/apt/lists/*

# Ubuntu 24.04 ships a default user "ubuntu" with uid/gid 1000.
# Remove it so the "dev" user can take uid/gid 1000 (matches typical host user ownership of bind mounts).
RUN userdel -r ubuntu 2>/dev/null || true \
    && groupdel ubuntu 2>/dev/null || true \
    && groupadd -g 1000 dev \
    && useradd -m -u 1000 -g 1000 -s /bin/bash dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev \
    && chmod 0440 /etc/sudoers.d/dev

USER dev
ENV HOME=/home/dev
WORKDIR /data

# Keep the container alive; tools connect with `docker exec`.
CMD ["sleep", "infinity"]
