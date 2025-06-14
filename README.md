# Miniflux

Miniflux is a minimalist and opinionated feed reader:

* Written in Go (Golang).
* Works only with Postgresql.
* Doesn't use any ORM.
* Doesn't use any complicated framework.
* Use only modern vanilla Javascript (ES6 and Fetch API).
* Single binary compiled statically without dependency.
* The number of features is voluntarily limited.

It's simple, fast, lightweight and super easy to install.

miniflux.app

![miniflux logo](https://miniflux.app/images/overview.png)

## How to use this Makejail

```sh
appjail makejail \
    -j miniflux-postgres \
    -f gh+AppJail-makejails/postgres \
    -o virtualnet=":<random> default" \
    -o nat \
    -o template="$PWD/template.conf" \
    -V POSTGRES_USER=miniflux \
    -V POSTGRES_PASSWORD=miniflux \
    -V POSTGRES_DB=miniflux \
    -o pkg=postgresql16-contrib \
    -o copydir=/ \
    -o file=/usr/local/etc/pkg/repos/Latest.conf \
        -- \
        --postgres_tag 13.5-16
appjail makejail \
    -j miniflux \
    -f gh+AppJail-makejails/miniflux \
    -o virtualnet=":<random> default" \
    -o nat
appjail start \
    -V DATABASE_URL="postgres://miniflux:miniflux@miniflux-postgres/miniflux?sslmode=disable" \
    -V CREATE_ADMIN=1 \
    -V ADMIN_USERNAME="admin" \
    -V ADMIN_PASSWORD=admin123456@ \
    -V RUN_MIGRATIONS=1 \
    miniflux
```

**template.conf**:

```
exec.start: "/bin/sh /etc/rc"
exec.stop: "/bin/sh /etc/rc.shutdown jail"
sysvmsg: new
sysvsem: new
sysvshm: new
mount.devfs
```

### Arguments (stage: build):

* `miniflux_tag` (default: `13.5`): see [#tags](#tags).
* `miniflux_ajspec` (default: `gh+AppJail-makejails/miniflux`): Entry point where the `appjail-ajspec(5)` file is located.

### Check current status

The custom stage `miniflux_status` can be used to run `top(1)` to check the status of Miniflux.

```sh
appjail run -s miniflux_status miniflux
```

### Log

To view the log generated by the web application, run the custom stage `miniflux_log`.

```sh
appjail run -s miniflux_log miniflux
```

## Tags

| Tag    | Arch    | Version        | Type   |
| ------ | ------- | -------------- | ------ |
| `13.5` | `amd64` | `13.5-RELEASE` | `thin` |
| `14.3` | `amd64` | `14.3-RELEASE` | `thin` |
