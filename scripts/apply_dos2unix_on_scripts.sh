#!/bin/bash

(
  cd /mnt/projects/workspace/scripts || {
    echo "Failed to change directory to /mnt/projects/workspace/scripts" >&2
    exit 1
  }
  find . -type f -name "*.sh" -exec dos2unix {} \;
)

