# Power BI Assets

This folder tracks metadata about Power BI datasets and dashboards built on
top of the `MARTS` schema. Actual `.pbix` files are stored in the team's
Power BI workspace, not in Git (binary format, not diff-friendly) - this
folder documents the semantic model layer so changes to marts can be
cross-referenced against dashboard impact.

## Datasets

| Dataset | Source Tables | Refresh Schedule |
|---------|---------------|-------------------|
| Executive Sales | `fact_sales`, `dim_customer`, `dim_store`, `dim_date` | Daily, 02:30 UTC |
| Customer 360 | `dim_customer`, `fact_orders` | Daily, 02:30 UTC |
| Inventory Overview | `fact_inventory`, `dim_product` | Daily, 02:30 UTC |

See `dataset_metadata.json` for the semantic model field mappings and
`dashboards.md` for a dashboard-to-mart dependency list (also captured as
dbt `exposures` in `dbt/models/marts/schema.yml`).
