# Deployment Guide

## Environments

| Environment | Snowflake DB | Purpose |
|-------------|--------------|---------|
| `dev` | `RETAIL360_DEV` | Individual developer sandboxes (schema-per-developer) |
| `ci` | `RETAIL360_CI` | Ephemeral, built and torn down per pull request |
| `prod` | `RETAIL360` | Production, deployed from `main` only |

## CI/CD Pipeline

Defined in `.github/workflows/dbt_ci.yml`:

1. **Lint** — `sqlfluff lint models/` against the dbt Snowflake dialect.
2. **Build** — `dbt deps && dbt seed && dbt run` against the `ci` target.
3. **Test** — `dbt test` — all tests must pass.
4. **Docs** — `dbt docs generate` artifact is uploaded for review.

Merges to `main` trigger `.github/workflows/dbt_deploy.yml`, which runs `dbt run --target prod`
followed by `dbt test --target prod`.

## Release Cadence

- Production dbt runs are scheduled nightly at 02:00 UTC via the Airflow DAG
  `retail360_daily_dag.py`.
- Hotfixes may be deployed ad hoc following approval from the on-call Data Engineer.

## Rollback

Because dbt models are declarative, rollback is performed by reverting the offending commit on
`main` and re-running the deploy workflow. Snapshots (`dbt/snapshots/`) preserve historical
state for slowly changing dimensions in case a downstream consumer needs point-in-time data
during a rollback window.

## Secrets Management

Snowflake credentials for the CI/CD service account are stored in GitHub Actions secrets
(`SNOWFLAKE_ACCOUNT`, `SNOWFLAKE_USER`, `SNOWFLAKE_PRIVATE_KEY`, `SNOWFLAKE_ROLE`). Never commit
credentials to `profiles.yml` — use `profiles.example.yml` as a template only.
