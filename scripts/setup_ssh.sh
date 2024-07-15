#!/bin/bash

# Start the SSH agent
eval "$(ssh-agent -s)"

# Fix permissions of the private key files
chmod 600 /home/devuser/.ssh/*_rsa

# Fix permissions of the .ssh/config file if it exists
if [ -f /home/devuser/.ssh/config ]; then
    chmod 600 /home/devuser/.ssh/config
fi

# Add all SSH keys to the agent
for key in /home/devuser/.ssh/*_rsa; do
    ssh-add $key
done

# Remove the offending key for GitHub from known_hosts
ssh-keygen -f "/home/devuser/.ssh/known_hosts" -R "github.com"

# Add GitHub's new RSA key to known_hosts
ssh-keyscan -t rsa github.com >> /home/devuser/.ssh/known_hosts

# List all identities added to the SSH agent
echo "SSH Identities:"
ssh-add -l

# Print the contents of the known_hosts file for debugging
echo "Known Hosts:"
cat /home/devuser/.ssh/known_hosts

# Test the SSH connection to GitHub (optional, can be removed if not needed)
ssh -T git@github.com || true  # Add || true to avoid script failure
