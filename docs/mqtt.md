# Mosquitto MQTT Broker

Operator notes for running the Eclipse Mosquitto MQTT broker deployed by this
plugin. Mosquitto is a lightweight message broker that speaks MQTT, commonly
used as the message bus for smart-home and IoT integrations.

---

## Ports

| Port | Purpose |
|---|---|
| 1883 | MQTT (plain) |
| 9001 | MQTT over WebSockets (optional) |

Enable and expose only the listeners you need. TLS listeners are typically
placed on 8883.

---

## Service Management

```bash
systemctl status mosquitto
systemctl restart mosquitto
journalctl -u mosquitto -f
```

---

## Configuration

The main config lives at `/etc/mosquitto/mosquitto.conf`, with drop-in files
under `/etc/mosquitto/conf.d/`. Define listeners, authentication, and
persistence there.

A minimal listener with authentication looks like:

```conf
listener 1883
allow_anonymous false
password_file /etc/mosquitto/passwd
persistence true
persistence_location /var/lib/mosquitto/
```

### Authentication

Anonymous access is disabled by setting `allow_anonymous false`. Create and
manage broker users with `mosquitto_passwd`:

```bash
mosquitto_passwd -c /etc/mosquitto/passwd <username>   # create file + first user
mosquitto_passwd    /etc/mosquitto/passwd <username>   # add/update a user
```

Reload the broker after changing credentials.

### Persistence

With `persistence true`, retained messages and durable subscriptions are
written to `persistence_location` (default `/var/lib/mosquitto/`) so they
survive a broker restart.

---

## Verifying

Publish and subscribe from the broker host to confirm it is routing messages:

```bash
mosquitto_sub -h localhost -p 1883 -u <username> -P <password> -t 'test/#' -v
mosquitto_pub -h localhost -p 1883 -u <username> -P <password> -t 'test/hello' -m 'ok'
```
