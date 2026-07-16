# Troubleshooting

## dbt run fails with "Database Error: Object does not exist"

- Confirm you've run `dbt seed` before `dbt run` if the model depends on a seed.
- Confirm your `profiles.yml` target database/schema matches your role's grants
  (`snowflake/roles/`).

## Snowpipe isn't loading new files

- Check `SYSTEM$PIPE_STATUS('<pipe_name>')` in a Snowflake worksheet.
- Confirm the S3 event notification (SQS) is still attached to the bucket — this is a common
  drift issue after bucket policy changes.
- See `snowflake/stages/` for the stage definition and confirm the storage integration is valid.

## A staging model test is failing intermittently

- Most commonly caused by late-arriving data in RAW. Check `sources.yml` freshness
  configuration — some sources allow a warn-only threshold that may need adjusting.

## `int_inventory_metrics` is slow

- This model is currently full-refresh only (see backlog issue `R360-014` for the incremental
  conversion). For local development, consider limiting the date range with a dbt variable.

## Power BI dashboard shows stale data

- Confirm the nightly Airflow DAG (`retail360_daily_dag.py`) completed successfully — check the
  Airflow UI for the latest `retail360_daily` run.
- Power BI datasets refresh 30 minutes after the scheduled dbt run completes; check the Power BI
  service refresh history.

## CI pipeline fails on sqlfluff lint

- Run `sqlfluff fix models/ --dialect snowflake` locally before pushing, then review the diff
  before committing (auto-fixes are not always semantically correct).
