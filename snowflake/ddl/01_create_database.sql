-- ============================================================================
-- 01_create_database.sql
-- Creates the primary Retail360 database and top-level schemas.
-- Run as SYSADMIN.
-- ============================================================================

CREATE DATABASE IF NOT EXISTS RETAIL360
    COMMENT = 'Retail360 Analytics - primary data platform database';

CREATE SCHEMA IF NOT EXISTS RETAIL360.RAW
    COMMENT = 'Landing zone for Snowpipe-ingested raw data. Append-only.';

CREATE SCHEMA IF NOT EXISTS RETAIL360.STAGING
    COMMENT = 'dbt staging models - 1:1 with source tables, lightly cleaned.';

CREATE SCHEMA IF NOT EXISTS RETAIL360.INTERMEDIATE
    COMMENT = 'dbt intermediate models - reusable business logic building blocks.';

CREATE SCHEMA IF NOT EXISTS RETAIL360.MARTS
    COMMENT = 'dbt mart models - facts and dimensions consumed by BI tools.';

CREATE SCHEMA IF NOT EXISTS RETAIL360.ANALYTICS_SANDBOX
    COMMENT = 'Ad hoc analyst workspace. Not part of the managed dbt DAG.';

CREATE SCHEMA IF NOT EXISTS RETAIL360.SNAPSHOTS
    COMMENT = 'dbt snapshot models for slowly changing dimensions.';
