#!/bin/bash
# Update Glance dashboard configuration from template
# This script reads credentials from .env and generates the config on the Glance VM

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOMELAB_DIR="$(dirname "$SCRIPT_DIR")"
GLANCE_VM="mark@10.0.0.13"

echo "Copying .env and template to Glance VM..."
scp "$HOMELAB_DIR/.env" "$GLANCE_VM:~/glance/.env"
scp "$HOMELAB_DIR/configs/glance.yml.template" "$GLANCE_VM:~/glance/config/glance.yml.template"

echo "Running config update on Glance VM..."
ssh "$GLANCE_VM" "cd ~/glance && ./update-config.sh"

echo "Glance configuration updated successfully"
