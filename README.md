# PocketBase starter

[PocketBase](https://pocketbase.io) in a small container: an open-source backend in one
file, with a SQLite database, auth, file storage, realtime subscriptions and an admin
dashboard. This repo is the source of the
[PocketBase template](https://containify.net/templates/pocketbase) on Containify.

The Dockerfile downloads a pinned PocketBase release, checks it against the release's
SHA-256 checksum and runs it as a non-root user (uid 1000). Everything PocketBase stores
lives in `/pb/pb_data`: mount a volume there.

| Path            | What it's for                                                      |
| --------------- | ------------------------------------------------------------------ |
| `pb_migrations` | [JS migrations](https://pocketbase.io/docs/js-migrations/), run on start |
| `pb_hooks`      | [JS hooks and routes](https://pocketbase.io/docs/js-overview/) (`/hello` is an example) |
| `pb_public`     | Static files served at `/`: put your frontend here                 |

## Run locally

```bash
docker build -t pocketbase-starter .
docker run --rm -p 8090:8090 -v pb_data:/pb/pb_data \
  -e PB_ADMIN_EMAIL=you@example.com -e PB_ADMIN_PASSWORD=change-me-please \
  pocketbase-starter
```

Open http://localhost:8090/_/ and sign in. The health check is `GET /api/health`.

## Environment

| Variable            | Default | What it does                                                         |
| ------------------- | ------- | -------------------------------------------------------------------- |
| `PORT`              | `8090`  | The port PocketBase listens on, on every IPv4 and IPv6 address       |
| `PB_ADMIN_EMAIL`    |         | With `PB_ADMIN_PASSWORD`: create this superuser (or reset its password) on start |
| `PB_ADMIN_PASSWORD` |         | The superuser's password, at least 10 characters                     |

Without them, PocketBase logs a one-time installer link to create the first superuser.

## Deploy on Containify

Deploy the PocketBase template from the Containify catalogue: it builds this repo, mounts
a volume on `/pb/pb_data` and gives the app an HTTPS address. To change PocketBase itself
(migrations, hooks, a newer release), fork this repo and point the app at your fork.

## Upgrading PocketBase

Set `PB_VERSION` and both `PB_SHA256_*` values in the Dockerfile from the release's
`checksums.txt`, then rebuild. Read the release notes first: PocketBase is pre-1.0 and
minor releases can change its APIs.

## License

MIT for this repo. PocketBase itself is MIT licensed too.
