FROM ghcr.io/linuxserver/baseimage-alpine:3.22

LABEL maintainer "Nicolas Coutin <ilshidur@gmail.com>"

ENV XDG_DATA_HOME="/config" \
    XDG_CONFIG_HOME="/config" \
    TZ="America/Los_Angeles"

RUN apk --no-cache add bash tzdata tor=0.4.8.17-r0

EXPOSE 9001 9030

# TOR configuration through environment variables.
ENV RELAY_TYPE relay
ENV TOR_ORPort 9001
ENV TOR_DirPort 9030
ENV TOR_DataDirectory /data
ENV TOR_ContactInfo "Random Person nobody@tor.org"

# Copy the default configurations.
COPY torrc.bridge.default /config/torrc.bridge.default
COPY torrc.relay.default /config/torrc.relay.default
COPY torrc.exit.default /config/torrc.exit.default

COPY entrypoint.sh /entrypoint.sh
COPY /root /

RUN chmod ugo+rx /entrypoint.sh /etc/cont-init.d/30-config /etc/services.d/tor/run

VOLUME /data
