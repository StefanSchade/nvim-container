#!/bin/bash

CERT_PATH="/mnt/dev-env-setup/zscaler.crt"

if [ -f "$CERT_PATH" ]; then
    echo "ZScaler certificate found, copying to /usr/local/share/ca-certificates"
    sudo cp $CERT_PATH /usr/local/share/ca-certificates/zscaler.crt
    sudo chmod 644 /usr/local/share/ca-certificates/zscaler.crt
    sudo update-ca-certificates --fresh
    echo "ZScaler certificate added successfully"
else
    echo "ZScaler certificate not found. Skipping CA store update."
fi
