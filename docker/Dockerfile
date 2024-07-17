FROM ubuntu:latest

# Install dependencies and set up Zscaler certificate
RUN apt-get update && \
    apt-get install -y \
    neovim \
    tmux \
    git \
    sudo \
    dos2unix \
    iputils-ping \
    curl \
    wget \
    apt-transport-https \
    ca-certificates && \
    apt-get clean

RUN apt-get update && apt-get install -y locales && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

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

    # Create the devuser user and set up sudo
RUN useradd -ms /bin/bash devuser
RUN usermod -aG sudo devuser
RUN echo "devuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Create necessary directories and set permissions
RUN mkdir -p /mnt/dev-env-setup /mnt/project

# Copy the scripts to the container to prevent permission problems on the host system
COPY scripts/ /home/devuser/scripts_setup_env/

# set all scripts just copied to be executable and have line endings in unix style
# RUN find /home/devuser/scripts_setup_env/ -type f -name "*.sh" -exec file {}     \; > /home/devuser/before_dos2unix.txt         && \
#     find /home/devuser/scripts_setup_env/ -type f -name "*.sh" -exec dos2unix {} \;                                             && \
#     find /home/devuser/scripts_setup_env/ -type f -name "*.sh" -exec chmod +x {} \;                                             && \
#     find /home/devuser/scripts_setup_env/ -type f -name "*.sh" -exec file {}     \; > /home/devuser/after_dos2unix.txt

# Add debugging command to print contents of the text files during build
# RUN echo "Contents of before_dos2unix.txt:" && cat /home/devuser/before_dos2unix.txt && \
#     echo "Contents of after_dos2unix.txt:" && cat /home/devuser/after_dos2unix.txt

#RUN chmod +x /home/devuser/scripts_setup_env/*.sh && \
#    chown -R devuser:devuser /mnt/dev-env-setup /mnt/project /home/devuser/scripts_setup_env

# Ensure devuser has ownership of the mounted volumes
#RUN mkdir -p /home/devuser/.config/nvim /home/devuser/.local/state/nvim /home/devuser/.local/share/nvim && \
#    chown -R devuser:devuser /home/devuser/.config/nvim /home/devuser/.local/state/nvim /home/devuser/.local/share/nvim

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
WORKDIR /home/devuser/scripts_setup_env/

# entrypoint irrelevant since override in docker-compose.yml
ENTRYPOINT ["/bin/bash", "-c", "/home/devuser/scripts_setup_env/postCreateScript.sh && /bin/bash"]
