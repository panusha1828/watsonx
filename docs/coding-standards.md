# Coding Standards

## SQL Style

- Keywords in `UPPERCASE` (`SELECT`, `FROM`, `WHERE`, `JOIN`).
- Identifiers in `snake_case`.
- One column per line in `SELECT` statements for anything beyond 3 columns.
- Always use explicit `JOIN ... ON`, never comma joins.
- Leading commas are NOT used; trailing commas only.
- CTEs are preferred over subqueries; name them descriptively (`orders_filtered`, not `cte1`).
- Every model ends with a single final `select * from final` pattern where practical.

```sql
-- Good
with orders_filtered as (

    select
        order_id,
        customer_id,
        order_date
    from {{ ref('stg_orders') }}
    where order_status != 'cancelled'

)

select * from orders_filtered
```

## dbt Conventions

- One model = one `.sql` file = one materialized table/view.
- Every model must have a corresponding entry in `schema.yml` with at least a `description` and
  a `not_null`/`unique` test on its primary key.
- Use `{{ ref() }}` and `{{ source() }}` exclusively — never hardcode fully qualified table
  names.
- Incremental models must define a unique_key and use the `is_incremental()` macro guard.
- Tag models by domain (`sales`, `customer`, `inventory`, `marketing`) using the `tags:` config.

## Python

- Follow PEP8.
- Airflow DAGs use the TaskFlow API (`@task` decorators) where possible.
- All DAGs must define `retries`, `retry_delay`, and an `on_failure_callback` for alerting.

## Git / PR Standards

- Branch naming: `feature/R360-<ticket>-short-description` or `fix/R360-<ticket>-...`.
- Commit messages: imperative mood, e.g. `Add freshness test to stg_orders`.
- PRs must reference a Jira ticket ID and pass CI (dbt build + sqlfluff lint) before merge.

## Review Checklist

- [ ] Model has tests (`not_null`, `unique` at minimum on the primary key)
- [ ] Model is documented in `schema.yml`
- [ ] No hardcoded database/schema names
- [ ] Follows naming conventions in `naming-conventions.md`
- [ ] No `select *` in staging/intermediate models (marts may select explicit `*` from a single
      final CTE only)
