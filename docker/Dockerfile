FROM ubuntu:latest

# Install dependencies and set up Zscaler certificate
RUN apt-get update && \
    apt-get install -y \
    neovim \
    tmux \
    git \
    sudo \
    iputils-ping \
    curl \
    wget \
    apt-transport-https \
    ca-certificates && \
    apt-get clean

# Create the devuser user and set up sudo
RUN useradd -ms /bin/bash devuser
RUN usermod -aG sudo devuser
RUN echo "devuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Copy setup scripts to the image
COPY scripts/ /mnt/dev-env-setup/scripts/

# Set permissions for the scripts
RUN chmod +x /mnt/dev-env-setup/scripts/*.sh

# Set up Zscaler certificate during build if it exists
ARG CERT_PATH=/workspace/zscaler.crt
RUN if [ -f "$CERT_PATH" ]; then \
        echo "ZScaler certificate found, copying to /usr/local/share/ca-certificates" && \
        cp $CERT_PATH /usr/local/share/ca-certificates/zscaler.crt && \
        chmod 644 /usr/local/share/ca-certificates/zscaler.crt && \
        update-ca-certificates --fresh && \
        echo "ZScaler certificate added successfully"; \
    else \
        echo "ZScaler certificate not found. Skipping CA store update."; \
    fi

# Create necessary directories and set permissions
RUN mkdir -p /mnt/dev-env-setup /mnt/project
COPY scripts/postCreateScript.sh /home/devuser/postCreateScript.sh
RUN chmod +x /home/devuser/postCreateScript.sh && \
    chown -R devuser:devuser /mnt/dev-env-setup /mnt/project

# Ensure devuser has ownership of the mounted volumes
RUN mkdir -p /home/devuser/.config/nvim /home/devuser/.local/state/nvim /home/devuser/.local/share/nvim && \
    chown -R devuser:devuser /home/devuser/.config/nvim /home/devuser/.local/state/nvim /home/devuser/.local/share/nvim

# Remove the Zscaler certificate if it was added
RUN echo "Checking for ZScaler certificate to remove" && \
    if [ -f /usr/local/share/ca-certificates/zscaler.crt ]; then \
        echo "ZScaler certificate found, removing" && \
        rm /usr/local/share/ca-certificates/zscaler.crt && \
        update-ca-certificates --fresh && \
        echo "ZScaler certificate removed successfully"; \
    else \
        echo "ZScaler certificate was not added, nothing to remove."; \
    fi

# Switch to devuser
USER devuser
WORKDIR /home/devuser

ENTRYPOINT ["/bin/bash", "-c", "/home/devuser/postCreateScript.sh && /bin/bash"]
