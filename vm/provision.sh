#!/usr/bin/env bash
# Creates and configures a mqtt VM on Proxmox VE. Run on the host as root.
set -euo pipefail
VMID="${1:?Usage: $0 <vmid> [options]}"
# TODO: qm create / cloud-init / install mqtt.
echo "[provision] mqtt VM $VMID — not yet implemented"
