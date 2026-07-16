# Retail360 Analytics — Enterprise Data Platform

![dbt](https://img.shields.io/badge/dbt-1.7-orange)
![Snowflake](https://img.shields.io/badge/Snowflake-Data%20Cloud-29B5E8)
![Airflow](https://img.shields.io/badge/Airflow-2.8-017CEE)
![License](https://img.shields.io/badge/license-Internal-lightgrey)

Retail360 Analytics is the modern data platform powering analytics for an omnichannel retailer
selling through e-commerce and physical stores. The platform ingests raw operational data,
transforms it through a layered dbt architecture, and serves curated marts to Power BI for
Sales, Customer 360, Product, Inventory, Marketing, and Executive reporting.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Repository Structure](#repository-structure)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Data Domains](#data-domains)
- [Documentation](#documentation)
- [Contributing](#contributing)

## Overview

Retail360 Analytics ingests data from e-commerce, POS, CRM, and marketing systems into
Snowflake via S3 + Snowpipe, then transforms it through a `raw -> staging -> intermediate ->
marts` layering pattern using dbt Core. Business users consume curated marts through Power BI
dashboards.

## Architecture

```
CSV / JSON Files
      |
      v
   AWS S3
      |
      v
  Snowpipe
      |
      v
  RAW Layer  (Snowflake)
      |
      v
  STAGING Layer (dbt)
      |
      v
  INTERMEDIATE Layer (dbt)
      |
      v
  MARTS Layer (dbt)
      |
      v
  Power BI Dashboards
```

See [docs/architecture.md](docs/architecture.md) for the full architecture writeup.

## Repository Structure

```
retail360-analytics/
├── docs/           Documentation: architecture, onboarding, standards, governance
├── snowflake/      DDL: databases, schemas, warehouses, roles, stages, tasks, streams
├── dbt/            dbt Core project: models, macros, seeds, snapshots, tests
├── sample_data/    Sample seed CSVs used for local development
├── airflow/        Orchestration DAGs for ingestion + dbt runs
├── powerbi/        Power BI dataset/dashboard metadata
├── .github/        CI/CD workflows for dbt + SQL linting
└── jira/           Backlog of good-first-issues for new engineers
```

## Tech Stack

| Layer            | Technology        |
|------------------|--------------------|
| Cloud Storage    | AWS S3             |
| Warehouse        | Snowflake          |
| Transformation   | dbt Core 1.7       |
| Orchestration    | Apache Airflow 2.8 |
| Languages        | SQL, Python         |
| Visualization    | Power BI           |
| Version Control  | GitHub             |

## Getting Started

1. Clone the repository.
2. Copy `dbt/profiles.example.yml` to `~/.dbt/profiles.yml` and fill in your Snowflake
   credentials.
3. Install dependencies:
   ```bash
   cd dbt
   dbt deps
   ```
4. Seed sample data and run models:
   ```bash
   dbt seed
   dbt run
   dbt test
   ```
5. Generate docs:
   ```bash
   dbt docs generate
   dbt docs serve
   ```

New engineers should start with [docs/onboarding-guide.md](docs/onboarding-guide.md), a 5-day
guided ramp-up plan.

## Data Domains

- **Sales Analytics** — `fact_orders`, `fact_sales`
- **Customer 360** — `dim_customer`, `int_customer_orders`
- **Product Analytics** — `dim_product`
- **Inventory Analytics** — `fact_inventory`, `int_inventory_metrics`
- **Marketing Analytics** — campaign attribution models (in progress, see backlog)
- **Executive Dashboards** — Power BI reports built on top of the marts layer

## Documentation

| Doc | Purpose |
|-----|---------|
| [architecture.md](docs/architecture.md) | Full platform architecture |
| [onboarding-guide.md](docs/onboarding-guide.md) | 5-day new-hire ramp-up |
| [coding-standards.md](docs/coding-standards.md) | SQL/dbt style guide |
| [naming-conventions.md](docs/naming-conventions.md) | Naming standards |
| [data-governance.md](docs/data-governance.md) | Access control & PII policy |
| [deployment.md](docs/deployment.md) | CI/CD and release process |
| [troubleshooting.md](docs/troubleshooting.md) | Common issues & fixes |

## Contributing

See open issues in [jira/backlog.md](jira/backlog.md) — issues tagged `good-first-issue` are
ideal starting points for new Data Engineers. Follow the SQL and dbt conventions in
[docs/coding-standards.md](docs/coding-standards.md) before opening a PR.

---
Maintained by the Retail360 Data Engineering team.
