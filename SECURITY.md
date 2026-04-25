# Security Policy

## Supported Versions

Only the latest version on the `main` branch receives security updates.

## Reporting a Vulnerability

Do not report security vulnerabilities through public issues.

Use GitHub's private vulnerability reporting:
**Security → Report a vulnerability** on this repository.

Include:

- a description of the vulnerability
- the affected file or service configuration
- reproduction steps or a proof of concept
- any suggested mitigation

You will receive a response within a reasonable timeframe.

## Scope of Security Review

Areas that are security-sensitive in this repository:

- **Environment files**: The `env/` directory contains runtime
  configuration for local development. Production credentials must
  never be committed here.
- **Docker Compose overrides**: Override files may expose ports or
  disable security features that should not reach production.
- **Service dependencies**: Health check and startup ordering must
  prevent services from starting before their dependencies are ready.

## Secrets Handling

- Environment files in `env/` are git-ignored to prevent accidental
  credential exposure.
- Use `*.env.example` templates with placeholder values for
  documentation.
- Never commit Auth0 client secrets, database passwords, or API keys
  with real values.

## Security Testing Expectations

- Verify that `git diff` does not contain real credentials before pushing.
- Verify that new services do not expose unnecessary ports.
- Review volume mounts for unintended host filesystem access.
