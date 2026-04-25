# Contributing

Thanks for contributing to scim-app-local.

This repository contains the Docker Compose configuration and environment
files for running the SCIM Sandbox locally. Keep changes focused on
compose services, environment configuration, or documentation that
matches the live repository structure.

## Ground Rules

- Keep each change narrow and intentional.
- Do not mix unrelated refactors into compose, environment, or
  documentation changes.
- Do not commit production credentials, Auth0 secrets, or
  machine-specific overrides.
- Prefer the existing service and environment file layout over new
  abstractions unless there is a clear gain.
- Update docs when service configuration or startup behavior changes.

## Before You Start

1. Check for existing issues or pull requests that already cover the same work.
2. Read [README.md](./README.md) before changing compose services or environment files.
3. If the change adds a new service, verify it integrates with existing health checks and dependency ordering.

## Validation

Validate changes before opening a PR.

Common checks:

- run `docker compose -f docker-compose-spring.yml config` to verify the compose file is valid
- verify that the stack starts cleanly with `docker compose up`
- check that no production credentials appear in the diff

## Pull Request Checklist

- explains the compose or environment change and why it is needed
- updates docs when service configuration changes
- keeps secrets and machine-specific values out of the diff
- avoids unrelated cleanup
- passes the relevant validation steps

## Reporting Bugs

When reporting a local setup issue, include:

- the affected service or configuration file
- the Docker and Docker Compose versions
- the expected and actual behavior
- relevant logs with secrets removed

## Security Issues

Do not report vulnerabilities through public issues.

Follow [SECURITY.md](./SECURITY.md) instead.
