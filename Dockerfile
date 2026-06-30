# TODO: base image + build for mqtt. Mirror jellyfin/Dockerfile conventions.
FROM debian:12-slim
LABEL org.opencontainers.image.source="https://github.com/argyle-labs/mqtt"
EXPOSE 1883
