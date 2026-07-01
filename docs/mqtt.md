# Mosquitto MQTT Broker

Message broker for smart home integrations. All Zigbee, Z-Wave, and other MQTT device messages route through here to Home Assistant.

---

## Instance

| Field | Value |
|---|---|
| LXC ID | 100 |
| Host | <host> (<ip>) |
| IP | <ip> |
| OS | Debian 12 |
| CPU | 1 core |
| RAM | 512 MB |
| Disk | 2 GB (local-lvm) |
| Unprivileged | yes |
| onboot | yes |
| Port | 1883 (MQTT), 9001 (WebSocket) |

---

## Service Management

```bash
pct enter 100   # on <host>

systemctl status mosquitto
systemctl restart mosquitto
journalctl -u mosquitto -f
```

---

## Configuration

Config at `/etc/mosquitto/mosquitto.conf` inside the LXC.

Clients that publish/subscribe:
- Zigbee2MQTT (LXC 107) → topic prefix `zigbee2mqtt/`
- Z-Wave JS UI (LXC 108) → topic prefix `zwave/`
- Home Assistant (VM 105) → subscribes to all device topics

---

## Related

- [home-assistant.md](home-assistant.md)
- [zigbee2mqtt.md](zigbee2mqtt.md)
- [zwave-js-ui.md](zwave-js-ui.md)
