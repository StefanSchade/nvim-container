#!/bin/bash

# Create .ssh directory if it doesn't exist
mkdir -p /home/devuser/.ssh
chmod 700 /home/devuser/.ssh

# Start the SSH agent
eval "$(ssh-agent -s)"

# Fix permissions of the private key files if they exist
if ls /home/devuser/.ssh/*_rsa 1> /dev/null 2>&1; then
    chmod 600 /home/devuser/.ssh/*_rsa
else
    echo "No SSH private keys found in /home/devuser/.ssh"
fi

# Fix permissions of the .ssh/config file if it exists
if [ -f /home/devuser/.ssh/config ]; then
    chmod 600 /home/devuser/.ssh/config
fi

# Add all SSH keys to the agent if they exist
if ls /home/devuser/.ssh/*_rsa 1> /dev/null 2>&1; then
    for key in /home/devuser/.ssh/*_rsa; do
        ssh-add $key
    done
else
    echo "No SSH private keys found to add to the agent."
fi

# Ensure known_hosts file exists
touch /home/devuser/.ssh/known_hosts
chown devuser:devuser /home/devuser/.ssh/known_hosts
chmod 644 /home/devuser/.ssh/known_hosts

# Remove the offending key for GitHub from known_hosts if it exists
ssh-keygen -f "/home/devuser/.ssh/known_hosts" -R "github.com" || true

# Add GitHub's new RSA key to known_hosts
ssh-keyscan -H github.com >> /home/devuser/.ssh/known_hosts

# List all identities added to the SSH agent
echo "SSH Identities:"
ssh-add -l

# Print the contents of the known_hosts file for debugging
echo "Known Hosts:"
cat /home/devuser/.ssh/known_hosts

# Test the SSH connection to GitHub (optional, can be removed if not needed)
ssh -T git@github.com || true  # Add || true to avoid script failure
