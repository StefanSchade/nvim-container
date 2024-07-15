FROM ubuntu:latest

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    neovim \
    tmux \
    git \
    sudo \
    curl \
    wget && \
    apt-get clean

# Add user and set up home directory
RUN useradd -ms /bin/bash devuser

# Set up sudo for devuser
RUN usermod -aG sudo devuser
RUN echo "devuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Ensure the devuser has the necessary permissions for the tmux directory
RUN mkdir -p /tmp/tmux-0 && chown -R devuser:devuser /tmp/tmux-0

# Switch to devuser
USER devuser
WORKDIR /home/devuser

# Ensure the postCreateScript is executable and run it
ENTRYPOINT ["/bin/bash", "-c",                                       \
            "chmod +x /mnt/dev-env-setup/scripts/postCreateScript.sh \
            && /mnt/dev-env-setup/scripts/postCreateScript.sh"]
