FROM ubuntu:latest

# Install dependencies and set up Zscaler certificate
RUN apt-get update && \
    apt-get install -y \
    neovim \
    tmux \
    git \
    sudo \
    curl \
    wget \
    apt-transport-https \
    ca-certificates && \
    apt-get clean

# Copy setup scripts to the image
COPY scripts/setup_zscaler.sh /mnt/dev-env-setup/scripts/setup_zscaler.sh

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

# Add user and set up home directory
RUN useradd -ms /bin/bash devuser

# Set up sudo for devuser
RUN usermod -aG sudo devuser
RUN echo "devuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Ensure the devuser has the necessary permissions for the tmux directory
RUN mkdir -p /tmp/tmux-0 && chown -R devuser:devuser /tmp/tmux-0

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

# Ensure the postCreateScript is executable and run it
ENTRYPOINT ["/bin/bash", "-c",                                       \
            "chmod +x /mnt/dev-env-setup/scripts/postCreateScript.sh \
            && /mnt/dev-env-setup/scripts/postCreateScript.sh"]
