# Mosquitto MQTT on a Proxmox LXC (native)

A standalone deployment: the Eclipse Mosquitto MQTT broker running **natively**
(not in Docker) inside an **unprivileged Debian LXC** on Proxmox. This is the
message bus that Zigbee2MQTT, Z-Wave JS UI, and Home Assistant publish to.
Nothing here needs orca.

> Placeholders: `<proxmox-host>` = your Proxmox node, `<ip>` = a LAN address,
> `<pool>` = your ZFS/backup pool. Pick the CT ID with
> `pvesh get /cluster/nextid` (shown as `<CTID>`); never hard-code one.

- **Ports**: 1883 (MQTT), 9001 (MQTT over WebSockets)
- **Type**: Proxmox LXC — Debian minimal, **unprivileged**
- **Footprint**: 1 core / 256 MB RAM / 2 GB disk — Mosquitto is tiny

---

## Step 1 — Create the LXC

```bash
pveam available | grep debian-12   # find the current template
pct create "$(pvesh get /cluster/nextid)" \
  local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst \
  --hostname mqtt \
  --storage local-lvm \
  --rootfs local-lvm:2 \
  --cores 1 --memory 256 --swap 512 \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp \
  --features nesting=1,keyctl=1 \
  --unprivileged 1 \
  --onboot 1
```

A full sample config is in [`lxc/mqtt.conf.example`](../lxc/mqtt.conf.example) —
copy the fields you want into `/etc/pve/lxc/<CTID>.conf` on `<proxmox-host>`
(the CT must be stopped to edit).

## Step 2 — Install Mosquitto

```bash
pct start <CTID>
pct enter <CTID>

apt-get update && apt-get upgrade -y
apt-get install -y --no-install-recommends mosquitto mosquitto-clients
systemctl enable --now mosquitto
```

## Step 3 — Enable auth + WebSockets

Anonymous access is fine on a trusted VLAN, but for anything shared set a
password and open the WebSocket listener:

```bash
mosquitto_passwd -c /etc/mosquitto/passwd homeassistant

cat > /etc/mosquitto/conf.d/local.conf << 'EOF'
listener 1883
listener 9001
protocol websockets
allow_anonymous false
password_file /etc/mosquitto/passwd
EOF
systemctl restart mosquitto
```

## Step 4 — Verify

```bash
# subscribe in one shell
mosquitto_sub -h localhost -u homeassistant -P <pass> -t 'test/#' -v
# publish from another
mosquitto_pub -h localhost -u homeassistant -P <pass> -t 'test/hello' -m 'ok'
```

Point Zigbee2MQTT / Z-Wave JS UI / Home Assistant at `mqtt://<ip>:1883`.

## Step 5 — Static IP

Set a static DHCP lease (`<ip>`) for the LXC's MAC (`ip link show eth0`) so the
broker address is stable for every client.

## Troubleshooting

**Clients can't connect** — confirm the broker is listening:
`ss -tlnp | grep -E '1883|9001'`, and check the firewall on `<proxmox-host>`.

**Auth failures after enabling `allow_anonymous false`** — every client now
needs credentials; re-check each integration's MQTT username/password.
