-- ============================================================================
-- warehouses.sql
-- Compute warehouses, isolated by workload type per docs/architecture.md
-- ============================================================================

CREATE WAREHOUSE IF NOT EXISTS LOADING_WH
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Used by Snowpipe and raw ingestion tasks';

CREATE WAREHOUSE IF NOT EXISTS TRANSFORM_WH
    WAREHOUSE_SIZE = 'MEDIUM'
    AUTO_SUSPEND = 120
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Used by dbt Cloud / CI-CD transformation runs';

CREATE WAREHOUSE IF NOT EXISTS REPORTING_WH
    WAREHOUSE_SIZE = 'SMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Used by Power BI query workloads';

-- TODO(R360-021): Evaluate multi-cluster warehouse for REPORTING_WH during
-- month-end close when concurrent Power BI refresh load spikes.
