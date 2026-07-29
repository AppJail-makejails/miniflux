ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/core:${FREEBSD_RELEASE}

ARG NO_PKGCLEAN

LABEL org.opencontainers.image.title="Miniflux" \
    org.opencontainers.image.description="Self-hosted software to read RSS/Atom/JSON feeds" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/miniflux" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/miniflux" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    pkg update; \
    pkg install -U miniflux; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/*; \
    fi; \
    rm -rf /var/db/pkg/repos/*

EXPOSE 8080

ENV LISTEN_ADDR=0.0.0.0:8080

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["miniflux"]
