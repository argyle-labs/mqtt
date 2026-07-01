<p align="center">
  <img src="assets/icon-256.png" width="120" alt="mqtt" />
</p>

# mqtt

Eclipse Mosquitto is a lightweight MQTT message broker.

A first-party [orca](https://github.com/argyle-labs/orca) plugin (service-backend).

This repo is **self-contained** — the steps below run mqtt **by hand, without orca**. orca automates exactly this (same image, ports, and data) through one generic surface.

---

## Run it without orca

### Docker / Podman

```yaml
# compose.yml
services:
  mqtt:
    image: eclipse-mosquitto:2
    container_name: mqtt
    restart: unless-stopped
    ports:
      - "1883:1883/tcp"   # MQTT
      - "9001:9001/tcp"   # websockets (optional)
    volumes:
      - ./config:/mosquitto/config
      - ./data:/mosquitto/data
      - ./log:/mosquitto/log
```

```sh
docker compose up -d
```

Podman: the same file with `podman-compose up -d`.

### Ports & data

| | |
|---|---|
| Default port | `1883` |
| Upstream | <https://mosquitto.org/> |
| Operator notes | [mqtt.md](docs/mqtt.md) |


### Backup & restore

Back up the config/data volume(s) above — that's the whole service state (stop the container first for a clean copy). Restore by putting them back and starting it.

> With orca this is **`service.backup` / `service.restore`** — location-agnostic (docker / podman / lxc / vm), one command regardless of where mqtt runs. No per-service backup script.

## With orca

orca drives this plugin through the single generic `service.*` surface — no per-plugin tools:

```sh
orca service.deploy mqtt      # render + launch on any supported runtime
orca service.status mqtt      # health + rich diagnostics (typed payload)
orca service.backup mqtt      # location-agnostic backup (tar; PBS on Proxmox)
orca service.configure mqtt   # apply config via the upstream API
```

## Layout

- `src/` — the plugin (pure Rust): the `ServiceBackend` descriptor + `configure` / `status`.
- `docs/` — standalone operator notes.
- [CAPABILITIES.md](CAPABILITIES.md) — the service-backend contract checklist.
- `assets/` — plugin icon.
