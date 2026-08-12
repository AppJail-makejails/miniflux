# Miniflux

Miniflux is a minimalist and opinionated feed reader. It's simple, fast, lightweight and super easy to install.

miniflux.app

<img src="https://github.com/miniflux/v2/blob/main/internal/ui/static/bin/icon-512.png?raw=true" width="30%" height="auto" alt="Miniflux logo">

## How to use this Makejail

### Standalone

Pull the image and run the container:

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -e "DATABASE_URL=postgres://miniflux:*password*@*dbhost*/miniflux?sslmode=disable" \
    -e "RUN_MIGRATIONS=1" \
    -e "CREATE_ADMIN=1" \
    -e "ADMIN_USERNAME=*username*" \
    -e "ADMIN_PASSWORD=*password*" \
    ghcr.io/appjail-makejails/miniflux:latest miniflux
```

The command above will run the migrations and set up a new admin account with the chosen username and password.

Once the container is started, you should be able to access the application on the exposed port, which is port 80 in this example.

### Deploy using `appjail-director`

```yaml
options:
  - virtualnet: ':<random> default'
  - nat:
  - container: 'args:--pull'

services:
  miniflux:
    name: miniflux
    makejail: gh+AppJail-makejails/miniflux
    oci:
      environment:
        - DATABASE_URL: postgres://miniflux:secret@miniflux-db/miniflux?sslmode=disable
        - RUN_MIGRATIONS: 1
        - CREATE_ADMIN: 1
        - ADMIN_USERNAME: admin
        - ADMIN_PASSWORD: test123
    options:
      - expose: 8080
  db:
    name: miniflux-db
    makejail: gh+AppJail-makejails/postgres
    oci:
      environment:
        - POSTGRES_USER: miniflux
        - POSTGRES_PASSWORD: secret
        - POSTGRES_DB: miniflux
    volumes:
      - miniflux-db: /var/db/postgres
    options:
      - template: !ENV '${PWD}/template.conf'

volumes:
  miniflux-db:
    device: /var/appjail-volumes/miniflux/db
```

**template.conf**:

```
exec.start: "/bin/sh /etc/rc"
exec.stop: "/bin/sh /etc/rc.shutdown jail"
mount.devfs
persist
sysvmsg: new
sysvsem: new
sysvshm: new
```

* `DATABASE_URL` defines the database connection parameters.
* `RUN_MIGRATIONS=1` runs the SQL migrations automatically.
* `CREATE_ADMIN`, `ADMIN_USERNAME`, and `ADMIN_PASSWORD` allow the creation of the first admin user. These can be removed after the first initialization.

### Arguments (stage: build)

* `miniflux_from` (default: `ghcr.io/appjail-makejails/miniflux`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `miniflux_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

### Environment (OCI image)

* `PGID` (default: `1000`): Equivalent to `PUID` but for the Process Group ID.
* `PUID` (default: `1000`): Process User ID for the container's main process, allowing you to match the owner of files written to mounted host volumes to your host system's user. Writable volumes are changed based on this environment variable.

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```
