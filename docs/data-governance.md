# Data Governance

## 1. Access Control Model

Access is role-based, following the principle of least privilege:

| Role | Access |
|------|--------|
| `RETAIL360_ADMIN` | Full DDL/DML on all schemas; used only by platform admins |
| `RETAIL360_TRANSFORMER` | Read on RAW, write on STAGING/INTERMEDIATE/MARTS; used by dbt CI/CD service account |
| `RETAIL360_ANALYST` | Read-only on MARTS and ANALYTICS_SANDBOX |
| `RETAIL360_READER` | Read-only on MARTS (used by Power BI service account) |

See `snowflake/roles/` for grant DDL.

## 2. PII Classification

| Column | Table(s) | Classification | Handling |
|--------|----------|------------------|----------|
| `email` | `stg_customers`, `dim_customer` | PII | Masked for non-admin roles via secure view |
| `phone_number` | `stg_customers`, `dim_customer` | PII | Masked for non-admin roles via secure view |
| `first_name`, `last_name` | `dim_customer` | PII | Restricted to `RETAIL360_ANALYST` and above |
| `payment_card_last4` | `stg_payments` | Sensitive | Never exposed to `RETAIL360_READER` |

Masking policies are defined alongside the relevant DDL in `snowflake/ddl/`.

## 3. Data Retention

- RAW layer: retained 13 months, then archived to a cold S3 tier.
- STAGING/INTERMEDIATE: ephemeral, rebuilt on each dbt run, no long-term retention requirement.
- MARTS: retained indefinitely (business requirement for year-over-year reporting).

## 4. Data Quality Ownership

Each mart has a designated owner responsible for triaging failing tests:

| Mart | Owner Team |
|------|------------|
| `fact_sales`, `fact_orders` | Sales Analytics |
| `dim_customer` | Customer Analytics |
| `fact_inventory` | Supply Chain Analytics |

## 5. Change Management

Any change to a source schema (new/removed/renamed column) must be reflected in `sources.yml`
and communicated to downstream mart owners before merge, per the review checklist in
`coding-standards.md`.
