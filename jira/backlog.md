# Retail360 Analytics — Backlog

Issues tagged `good-first-issue` are ideal for new Data Engineers completing
the [5-day onboarding guide](../docs/onboarding-guide.md). Difficulty and
time estimates assume familiarity with the codebase from Days 1-4.

---

### R360-001 — Add missing not_null test to stg_stores.city
**Difficulty:** Easy | **Estimate:** 30 min | **Tags:** good-first-issue, testing
**Affected files:** `dbt/models/staging/schema.yml`
**Description:** `stg_stores.city` has no test coverage. Add a `not_null` test
and confirm it passes against current seed data.
**Business value:** Prevents downstream `dim_store` records with missing
city values from silently reaching Power BI location-based visuals.

---

### R360-002 — Fix SQL formatting in int_sales_metrics.sql
**Difficulty:** Easy | **Estimate:** 20 min | **Tags:** good-first-issue, code-quality
**Affected files:** `dbt/models/intermediate/int_sales_metrics.sql`
**Description:** Inconsistent indentation and trailing whitespace. Run
`sqlfluff fix` and manually verify the diff is purely cosmetic.
**Business value:** Improves readability and code review speed for the team.

---

### R360-003 — Document dim_date grain and range in schema.yml
**Difficulty:** Easy | **Estimate:** 30 min | **Tags:** good-first-issue, documentation
**Affected files:** `dbt/models/marts/schema.yml`
**Description:** `dim_date`'s description doesn't mention the configurable
`start_date` var. Update the description to explain the date range logic.
**Business value:** Reduces confusion for analysts unsure why historical
dates before 2023 aren't available.

---

### R360-004 — Add accepted_values test to fact_orders.order_channel
**Difficulty:** Easy | **Estimate:** 30 min | **Tags:** good-first-issue, testing
**Affected files:** `dbt/models/marts/schema.yml`
**Description:** Add an `accepted_values` test (`web`, `mobile_app`,
`in_store`) to catch channel values from new, unplanned source systems.
**Business value:** Early warning when a new sales channel needs modeling.

---

### R360-005 — Improve naming: rename int_sales_metrics columns for consistency
**Difficulty:** Medium | **Estimate:** 1.5 hr | **Tags:** good-first-issue, refactor
**Affected files:** `dbt/models/intermediate/int_sales_metrics.sql`, `dbt/models/marts/fact_sales.sql`
**Description:** `order_status` in this model overlaps in name but not
meaning with a status field planned for `fact_inventory`. Rename to
`order_fulfillment_status` for clarity and update all downstream refs.
**Business value:** Prevents future ambiguity as more `_status` columns are
added across domains.

---

### R360-006 — Add source freshness test to raw.products
**Difficulty:** Easy | **Estimate:** 20 min | **Tags:** good-first-issue, testing
**Affected files:** `dbt/sources.yml`
**Description:** `raw.products` has no freshness block, unlike `customers`
and `payments`. Add a reasonable warn/error threshold.
**Business value:** Alerts the team if the product catalog feed silently
stops updating.

---

### R360-007 — Improve generate_surrogate_key macro with input validation
**Difficulty:** Medium | **Estimate:** 1 hr | **Tags:** good-first-issue, macros
**Affected files:** `dbt/macros/generate_surrogate_key.sql`
**Description:** Add a check that raises a clear compile error if
`field_list` is empty, instead of silently hashing nothing.
**Business value:** Fails fast with a clear message instead of producing a
meaningless constant surrogate key.

---

### R360-008 — Refactor stg_stores.sql to standardize store_type casing
**Difficulty:** Medium | **Estimate:** 1 hr | **Tags:** good-first-issue, bug
**Affected files:** `dbt/models/staging/stg_stores.sql`
**Description:** Resolves the TODO in the model: lowercase `store_type` on
ingestion so the `accepted_values` test in `schema.yml` stops failing
intermittently.
**Business value:** Fixes a known flaky test blocking CI (see
`docs/troubleshooting.md`).

---

### R360-009 — Update schema.yml descriptions for all staging models
**Difficulty:** Easy | **Estimate:** 45 min | **Tags:** good-first-issue, documentation
**Affected files:** `dbt/models/staging/schema.yml`
**Description:** Several staging models are missing column-level
descriptions. Fill in descriptions for all undocumented columns.
**Business value:** Improves `dbt docs` output for new engineers and IBM Bob
onboarding queries.

---

### R360-010 — Add unique test to dim_date.full_date
**Difficulty:** Easy | **Estimate:** 15 min | **Tags:** good-first-issue, testing
**Affected files:** `dbt/models/marts/schema.yml`
**Description:** Verify this test already exists (it does) - if this ticket
is picked up, use it as a template to add an equivalent test to any newly
added dimension.
**Business value:** Template ticket for onboarding practice.

---

### R360-011 — Improve macro documentation with usage examples
**Difficulty:** Easy | **Estimate:** 30 min | **Tags:** good-first-issue, documentation
**Affected files:** `dbt/macros/standardize_dates.sql`, `dbt/macros/audit_columns.sql`
**Description:** Add a `{% docs %}` block for each macro so descriptions
show up properly in generated dbt docs, not just inline comments.
**Business value:** Makes macros self-explanatory in the dbt docs UI.

---

### R360-012 — Optimize warehouse usage for REPORTING_WH
**Difficulty:** Medium | **Estimate:** 2 hr | **Tags:** good-first-issue, performance
**Affected files:** `snowflake/warehouses/warehouses.sql`
**Description:** Analyze query history for `REPORTING_WH` and evaluate
whether `AUTO_SUSPEND` should be lowered from 300s to 120s to reduce idle
compute cost.
**Business value:** Potential cost savings on Snowflake compute spend.

---

### R360-013 — Add a clustering key to fact_sales
**Difficulty:** Medium | **Estimate:** 2 hr | **Tags:** good-first-issue, performance
**Affected files:** `dbt/models/marts/fact_sales.sql`
**Description:** As `fact_sales` grows, full-table scans on `order_date`
range filters will get expensive. Add a clustering key config on
`order_date`.
**Business value:** Keeps query performance predictable as data volume grows.

---

### R360-014 — Convert int_inventory_metrics to an incremental model
**Difficulty:** Hard | **Estimate:** 4-6 hr | **Tags:** performance, tech-debt
**Affected files:** `dbt/models/intermediate/int_inventory_metrics.sql`, `dbt/models/marts/fact_inventory.sql`
**Description:** This model currently recomputes full history on every run
(see the model's header comment). Convert to `materialized='incremental'`
once a proper `updated_at`-style column is available from source.
**Business value:** Reduces dbt run time and warehouse cost as inventory
data volume grows.

---

### R360-015 — Refactor dim_customer to use a single CTE for PII columns
**Difficulty:** Medium | **Estimate:** 1.5 hr | **Tags:** good-first-issue, refactor
**Affected files:** `dbt/models/marts/dim_customer.sql`
**Description:** Isolate PII columns (`email`, `phone_number`) into their
own CTE ahead of the final select to make masking-policy application (see
`apply_masking_policies` macro) easier to audit.
**Business value:** Simplifies compliance review of PII handling.

---

### R360-016 — Add dbt_expectations test for unit_price range on dim_product
**Difficulty:** Easy | **Estimate:** 30 min | **Tags:** good-first-issue, testing
**Affected files:** `dbt/models/marts/schema.yml`
**Description:** Add a `dbt_expectations.expect_column_values_to_be_between`
test on `dim_product.unit_price`, mirroring the existing test on
`stg_products`.
**Business value:** Catches obviously erroneous prices before they reach
Power BI.

---

### R360-017 — Outdated documentation: update deployment.md release cadence
**Difficulty:** Easy | **Estimate:** 20 min | **Tags:** good-first-issue, documentation
**Affected files:** `docs/deployment.md`
**Description:** The nightly run time recently moved from 03:00 UTC to
02:00 UTC in the Airflow DAG but the doc wasn't updated. Fix the
discrepancy.
**Business value:** Keeps onboarding documentation trustworthy.

---

### R360-018 — Fix store_type casing inconsistency (root cause)
**Difficulty:** Medium | **Estimate:** 1 hr | **Tags:** bug, data-quality
**Affected files:** `dbt/models/staging/stg_stores.sql`
**Description:** Duplicate/related to R360-008 - root-caused to an upstream
CRM export change. Coordinate with the source system team in addition to
the dbt-side fix.
**Business value:** Prevents recurrence after the dbt-side fix in R360-008.

---

### R360-019 — Remove unused legacy macro: dbt_current_timestamp
**Difficulty:** Easy | **Estimate:** 20 min | **Tags:** good-first-issue, tech-debt
**Affected files:** `dbt/macros/current_timestamp.sql`
**Description:** This macro is not referenced by any model. Confirm via
`grep -r "dbt_current_timestamp" dbt/models` and remove if truly unused, or
document why it's kept for future multi-warehouse support.
**Business value:** Reduces maintenance surface area / dead code.

---

### R360-020 — Improve PR template with lineage screenshot reminder
**Difficulty:** Easy | **Estimate:** 15 min | **Tags:** good-first-issue, dx
**Affected files:** `.github/PULL_REQUEST_TEMPLATE.md`
**Description:** Add a checklist item reminding contributors to attach a
`dbt docs` lineage screenshot when a PR changes model dependencies.
**Business value:** Speeds up PR review for structural changes.

---

### R360-021 — Evaluate multi-cluster warehouse for REPORTING_WH
**Difficulty:** Medium | **Estimate:** 3 hr | **Tags:** performance
**Affected files:** `snowflake/warehouses/warehouses.sql`
**Description:** See TODO in the warehouse DDL. Investigate whether
month-end close concurrency spikes justify enabling multi-cluster warehouse
mode.
**Business value:** Improves dashboard responsiveness during month-end
close without over-provisioning compute year-round.

---

### R360-022 — Add a good-first-issue label audit script
**Difficulty:** Easy | **Estimate:** 45 min | **Tags:** good-first-issue, tooling
**Affected files:** `jira/` (new script, not yet in repo)
**Description:** Write a small Python script that flags backlog items
missing one of the required fields (Difficulty, Estimate, Affected Files).
**Business value:** Keeps the backlog format consistent as it grows.

---

### R360-023 — Add relationships test between fact_inventory and dim_product
**Difficulty:** Easy | **Estimate:** 30 min | **Tags:** good-first-issue, testing
**Affected files:** `dbt/models/marts/schema.yml`
**Description:** `fact_inventory.product_id` has no `relationships` test
tying it back to `dim_product.product_id`. Add one.
**Business value:** Catches referential integrity issues between the
inventory fact and product dimension.

---

### R360-024 — Marketing Analytics domain: scope initial data model
**Difficulty:** Hard | **Estimate:** 1-2 days | **Tags:** epic, new-domain
**Affected files:** New models under `dbt/models/staging/` and
`dbt/models/marts/` (marketing domain)
**Description:** Marketing Analytics is listed as a target domain in the
README but has no models yet. Scope a `stg_campaigns` /
`fact_campaign_performance` starting point.
**Business value:** Unlocks the final planned reporting domain from the
original platform charter.

---

### R360-025 — Improve troubleshooting.md with Snowpipe latency guidance
**Difficulty:** Easy | **Estimate:** 30 min | **Tags:** good-first-issue, documentation
**Affected files:** `docs/troubleshooting.md`
**Description:** Add a section on diagnosing Snowpipe ingestion latency
using `SNOWPIPE_HISTORY` in `INFORMATION_SCHEMA`.
**Business value:** Reduces on-call time troubleshooting ingestion delays.

---

### R360-026 — Add CI check for missing schema.yml documentation
**Difficulty:** Medium | **Estimate:** 2 hr | **Tags:** dx, ci
**Affected files:** `.github/workflows/dbt_ci.yml`
**Description:** Add a step using `dbt-coverage` or a custom script to fail
CI if a new model is added without a corresponding `schema.yml` entry.
**Business value:** Enforces the documentation standard in
`coding-standards.md` automatically instead of relying on manual review.

---

### R360-027 — Connect true inventory-on-hand source feed
**Difficulty:** Hard | **Estimate:** 3-5 days | **Tags:** epic, tech-debt
**Affected files:** `snowflake/schemas/raw_tables.sql`, `dbt/models/staging/`,
`dbt/models/intermediate/int_inventory_metrics.sql`
**Description:** `int_inventory_metrics` currently uses a placeholder join
(see FIXME) because no real inventory-on-hand source exists yet. Requires
coordination with the warehouse management system team to land a new feed.
**Business value:** Enables accurate `fact_inventory` reporting instead of
an estimate.

---

### R360-032 — Fix missing table creation in payment reconciliation task
**Difficulty:** Medium | **Estimate:** 1 hr | **Tags:** bug
**Affected files:** `snowflake/tasks/tasks.sql`
**Description:** Resolves the FIXME - add an `IF NOT EXISTS` create
statement for `RAW.PAYMENT_RECONCILIATION` before the task's `MERGE`
statement so the task works in a freshly provisioned environment.
**Business value:** Unblocks environment rebuilds (e.g. disaster recovery
drills) from failing on this task.

---

### R360-041 — Replace placeholder Power BI refresh task with real operator
**Difficulty:** Medium | **Estimate:** 2 hr | **Tags:** tech-debt
**Affected files:** `airflow/dags/retail360_daily_dag.py`
**Description:** Resolves the TODO - swap the placeholder
`trigger_powerbi_refresh` task body for a proper call to the Power BI REST
API (or an existing community Airflow provider) using the stored service
principal credentials.
**Business value:** Removes a manual step currently required after each
nightly DAG run.
