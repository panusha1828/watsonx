# Naming Conventions

## Model Prefixes

| Prefix | Layer | Example |
|--------|-------|---------|
| `stg_` | Staging | `stg_customers.sql` |
| `int_` | Intermediate | `int_sales_metrics.sql` |
| `dim_` | Mart — Dimension | `dim_customer.sql` |
| `fact_` | Mart — Fact | `fact_orders.sql` |

## Snowflake Objects

- Databases: `UPPER_SNAKE_CASE` — e.g. `RETAIL360`
- Schemas: `UPPER_SNAKE_CASE` — e.g. `RAW`, `STAGING`, `MARTS`
- Warehouses: `<PURPOSE>_WH` — e.g. `TRANSFORM_WH`
- Roles: `RETAIL360_<FUNCTION>` — e.g. `RETAIL360_TRANSFORMER`
- Stages: `<SOURCE>_STAGE` — e.g. `ORDERS_STAGE`
- File formats: `<TYPE>_FORMAT` — e.g. `CSV_FORMAT`, `JSON_FORMAT`
- Tasks: `<MODEL>_TASK` — e.g. `REFRESH_INVENTORY_TASK`

## Column Naming

- Primary keys: `<entity>_id` — e.g. `customer_id`, `order_id`
- Foreign keys: `<referenced_entity>_id` — e.g. `customer_id` on `fact_orders`
- Booleans: `is_<condition>` — e.g. `is_active`, `is_returned`
- Timestamps: `<event>_at` — e.g. `created_at`, `updated_at`
- Dates: `<event>_date` — e.g. `order_date`, `ship_date`
- Surrogate keys generated via `generate_surrogate_key` macro: `<entity>_sk`

## File & Folder Naming

- All lowercase, hyphen-separated for docs (`coding-standards.md`), snake_case for SQL/Python
  files (`stg_orders.sql`, `retail360_daily_dag.py`).

## Tags

Models are tagged by business domain: `sales`, `customer`, `product`, `inventory`,
`marketing`. Use these tags for selective `dbt run --select tag:sales`.
