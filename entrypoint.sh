#!/bin/sh

. /lib.subr

set -e

if [ "${1#-}" != "$1" ]; then
    set -- miniflux "$@"
fi

if [ "$1" = "miniflux" ]; then
    create_user

    set -- su-exec noroot "$@"
fi

exec "$@"
