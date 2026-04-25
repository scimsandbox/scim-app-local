# SCIM Sandbox — App local

This repository contains a minimal, Docker Compose–driven local development stack for the SCIM Sandbox.

To rebuild all service dev images from scratch, run the helper script in `scripts/`:

```bash
./scripts/build-dev-images.sh [--no-cache]
```

## Quick start

Prerequisites:

- Docker (Desktop or compatible engine) with Compose v2 (the `docker compose` command)

Start the full stack locally:

```bash
docker compose -f docker-compose-spring.yml up --build
```

Start with the optional Cloudflare sidecar/profile:

```bash
docker compose -f docker-compose-spring.yml --profile cloudflare up --build
```

Stop and remove containers and volumes:

```bash
docker compose -f docker-compose-spring.yml down --volumes
```

## Default ports

- API: http://localhost:8080
- Management UI: http://localhost:8081
- Validator UI: http://localhost:8082
- Playground PostgreSQL: 5432
- Validator PostgreSQL: 5433

## Environment files

Compose references env files under `env/`. The env files checked into this repository are development helpers only — replace any secrets, tokens, or audience values before using them in a shared or production environment.

## What this repo provides

- A Docker Compose definition (`docker-compose-spring.yml`) that brings up the locally runnable stack used for development and interoperability testing.
- Helper env files under `env/` to make local runs simple.

This repository does not contain the full service source code. If you need to work on the API, management UI, validator, or other components, find those projects in their respective component repositories.

## Notes

- Use the management UI (`http://localhost:8081`) to create workspaces and generate bearer tokens.
- When calling the SCIM API, include the workspace UUID in the route, for example:

```bash
curl -H "Authorization: Bearer ${SCIM_TOKEN}" \
  -H "Accept: application/scim+json" \
  http://localhost:8080/ws/${WORKSPACE_UUID}/scim/v2/ServiceProviderConfig
```

## Contributing

Contributions and fixes are welcome. See `CONTRIBUTING.md` if present.

## License

This project is licensed under the Apache License, Version 2.0. See [LICENSE](./LICENSE).
