# Architecture Guide

## 1. Purpose

This document describes the end-to-end architecture of the Retail360 Analytics data platform,
from raw file ingestion through to Power BI consumption.

## 2. High-Level Flow

```
Source Systems (E-commerce, POS, CRM, Marketing)
        |
        v
   CSV / JSON extracts landed in AWS S3 (per-domain buckets/prefixes)
        |
        v
   Snowpipe (auto-ingest via SQS notifications)
        |
        v
   RAW schema (RETAIL360.RAW) — untransformed, append-only landing tables
        |
        v
   STAGING models (dbt) — 1:1 with source tables, light typing/renaming
        |
        v
   INTERMEDIATE models (dbt) — joins, business logic building blocks
        |
        v
   MARTS models (dbt) — star-schema facts & dimensions
        |
        v
   Power BI — semantic layer / dashboards
```

## 3. Snowflake Layout

| Database | Schema | Purpose |
|----------|--------|---------|
| RETAIL360 | RAW | Landing zone for Snowpipe-ingested data |
| RETAIL360 | STAGING | dbt staging models |
| RETAIL360 | INTERMEDIATE | dbt intermediate models |
| RETAIL360 | MARTS | dbt mart models (facts/dims) |
| RETAIL360 | ANALYTICS_SANDBOX | Ad hoc analyst workspace |

## 4. Compute

Three warehouses are provisioned to isolate workload types:

- `LOADING_WH` — X-SMALL, used by Snowpipe and raw ingestion tasks
- `TRANSFORM_WH` — MEDIUM, used by dbt Cloud/CI runs
- `REPORTING_WH` — SMALL, used by Power BI query workloads

See `snowflake/warehouses/` for DDL.

## 5. Ingestion

Files are dropped into S3 by upstream extract jobs (outside the scope of this repo). Snowpipe
is configured per source table with an associated stage, file format, and pipe object. See
`snowflake/stages/`, `snowflake/file_formats/`, and `snowflake/streams/` for definitions.

## 6. Transformation Layers

- **Staging** (`dbt/models/staging`): one model per source table. Renames columns, casts types,
  applies light cleaning. No joins.
- **Intermediate** (`dbt/models/intermediate`): reusable joins and business-logic building
  blocks that are not meant to be queried directly by BI tools.
- **Marts** (`dbt/models/marts`): final dimensional models (facts and dimensions) consumed by
  Power BI and analysts.

## 7. Orchestration

Airflow DAGs in `airflow/dags/` trigger dbt runs on a schedule, coordinate Snowpipe backfills,
and handle alerting on failures. See `docs/deployment.md` for the release pipeline.

## 8. Data Lineage

`fact_sales` is derived from `int_sales_metrics`, which combines `stg_orders`, `stg_payments`,
and `stg_products`. Run `dbt docs generate && dbt docs serve` for the full interactive lineage
graph.

## 9. Known Limitations / Technical Debt

- Marketing Analytics domain is not yet modeled (see backlog).
- `int_inventory_metrics` currently recomputes full history on each run; incremental strategy
  is a planned improvement (see Jira `R360-014`).
