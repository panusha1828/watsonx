# 5-Day Onboarding Guide — New Data Engineer

Welcome to the Retail360 Data Engineering team. This guide gets you from zero context to your
first merged pull request in five days.

## Day 1 — Snowflake Foundations

**Goals:** Understand the warehouse, schema, and role layout.

- Read [architecture.md](architecture.md) end to end.
- Review `snowflake/ddl/` — database and schema creation scripts.
- Review `snowflake/warehouses/` — understand `LOADING_WH`, `TRANSFORM_WH`, `REPORTING_WH`
  and why workloads are isolated.
- Review `snowflake/roles/` — RBAC hierarchy (`SYSADMIN` -> `RETAIL360_ADMIN` ->
  `RETAIL360_TRANSFORMER` -> `RETAIL360_READER`).
- **Exercise:** Trace which role you'd need to query `MARTS.FACT_SALES` vs. load into
  `RAW.ORDERS`.

## Day 2 — The dbt Project

**Goals:** Understand how raw data becomes staging models.

- Read `dbt/dbt_project.yml` and `dbt/sources.yml`.
- Review `dbt/models/staging/` — pick `stg_orders.sql` and read it line by line.
- Review 2-3 macros in `dbt/macros/` (`generate_surrogate_key`, `audit_columns`).
- Run locally: `dbt seed && dbt run --select staging.*`.
- **Exercise:** Add a new column pass-through to `stg_stores.sql` and confirm it compiles.

## Day 3 — Business Logic

**Goals:** Understand how facts and dimensions are built.

- Review `dbt/models/intermediate/int_customer_orders.sql` and
  `int_sales_metrics.sql`.
- Review `dbt/models/marts/fact_sales.sql` and `dim_customer.sql`.
- Read `docs/naming-conventions.md` to understand `fact_`/`dim_`/`int_`/`stg_` prefixes.
- **Exercise:** Explain, in your own words, how `fact_sales` grain (one row per order line) is
  established.

## Day 4 — Pipelines & Orchestration

**Goals:** Understand how data actually gets in and moves through the system.

- Review `airflow/dags/retail360_daily_dag.py`.
- Review `snowflake/stages/` and `snowflake/file_formats/` to see how Snowpipe is configured.
- Review `snowflake/tasks/` for scheduled Snowflake-native transformations.
- **Exercise:** Diagram (on paper or in Miro) the path of a single order from a POS terminal to
  `fact_sales`.

## Day 5 — First Good Issue & Pull Request

**Goals:** Ship your first change.

- Open [jira/backlog.md](../jira/backlog.md) and pick an issue tagged `good-first-issue` and
  `difficulty: easy`.
- Follow [coding-standards.md](coding-standards.md) while making your change.
- Open a PR using the template in `.github/PULL_REQUEST_TEMPLATE.md`.
- Request review from your onboarding buddy.

**Congratulations — you've shipped your first commit to Retail360 Analytics.**
