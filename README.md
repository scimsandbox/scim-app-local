# SCIM Sandbox — App local

This repository contains a minimal, Docker Compose–driven local development stack for the SCIM Sandbox.

To rebuild all service dev images from scratch, run the helper script in `scripts/`:

```bash
./scripts/build-dev-images.sh [--no-cache]
```

## Quick start

Prerequisites:

- Docker (Desktop or compatible engine) with Compose v2 (the `docker compose` command)
- An Auth0 tenant — both UIs sign in through OIDC and have no local login fallback

Create your env files from the tracked templates (see [Environment files](#environment-files)):

```bash
for f in env/*.env.example; do cp -n "$f" "${f%.example}"; done
```

Then open `env/scim-server-ui-spring.env` and `env/scim-validator-ui-spring.env` and fill in the `AUTH0_*` values. The other files work as-is.

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

Compose reads one env file per service from `env/`. Those files hold credentials, so they are **not** checked in — `.gitignore` excludes `env/*.env`. What *is* checked in is a matching `*.env.example` template for each one:

| Template | Service | Needs editing? |
| --- | --- | --- |
| `postgres-server.env.example` | Playground PostgreSQL | no |
| `postgres-validator.env.example` | Validator PostgreSQL | no |
| `scim-server-db.env.example` | Flyway migrations (playground) | no |
| `scim-validator-db.env.example` | Flyway migrations (validator) | no |
| `scim-server-impl-spring.env.example` | SCIM API, Spring (`docker-compose-spring.yml`) | no |
| `scim-server-impl-go.env.example` | SCIM API, Go (`docker-compose-go.yml`) | no |
| `scim-server-ui-spring.env.example` | Management UI | **yes — Auth0** |
| `scim-validator-ui-spring.env.example` | Validator UI | **yes — Auth0** |
| `cloudflare.env.example` | Cloudflare tunnel sidecar | only for the `cloudflare` profile |

Copy them all in one go:

```bash
for f in env/*.env.example; do cp -n "$f" "${f%.example}"; done
```

`cp -n` will not overwrite env files you have already customised.

Each template documents its own variables inline. A missing env file for an active service makes compose fail immediately with `env file ... not found`, so copy them before the first `up`. `cloudflare.env` is the exception: it is only required when you pass `--profile cloudflare`.

### Auth0 setup

Both UIs authenticate through Auth0 and will not start without it. Register **two** Regular Web Applications in your tenant — one per UI, since each has its own callback URL — and add these to their respective *Allowed Callback URLs*:

- Management UI: `http://localhost:8081/login/oauth2/code/auth0`
- Validator UI: `http://localhost:8082/login/oauth2/code/auth0`

Copy each application's Client ID and Client Secret into the matching env file, and set `AUTH0_ISSUER_URI` to your tenant URL **including the trailing slash**.

Roles come from a namespaced custom claim on the ID token, not from Auth0's built-in roles. Add a Login Action that sets that claim, and use the same namespace in `APP_SECURITY_OIDC_ROLE_CLAIM` in both files:

```javascript
exports.onExecutePostLogin = async (event, api) => {
  const namespace = 'https://scimsandbox.local/roles';
  api.idToken.setCustomClaim(namespace, event.authorization?.roles ?? []);
};
```

Without a matching claim you can sign in but will have no permissions.

The values shipped in the templates are development defaults. Replace every secret, token, and audience before using this stack anywhere shared.

## What this repo provides

- Docker Compose definitions that bring up the locally runnable stack used for development and interoperability testing — `docker-compose-spring.yml` for the Spring API, `docker-compose-go.yml` for the Go API.
- Env file templates under `env/` (`*.env.example`) to make local runs simple. Copy them to `*.env` as described in [Environment files](#environment-files); the real env files are gitignored because they hold credentials.

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
