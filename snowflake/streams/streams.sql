-- ============================================================================
-- streams.sql
-- Streams on RAW tables, used for CDC-style incremental processing by
-- Snowflake tasks ahead of the dbt incremental layer.
-- ============================================================================

USE DATABASE RETAIL360;
USE SCHEMA RAW;

CREATE STREAM IF NOT EXISTS ORDERS_STREAM ON TABLE RAW.ORDERS
    APPEND_ONLY = TRUE
    COMMENT = 'Tracks new order rows landed by Snowpipe for incremental processing';

CREATE STREAM IF NOT EXISTS PAYMENTS_STREAM ON TABLE RAW.PAYMENTS
    APPEND_ONLY = TRUE
    COMMENT = 'Tracks new payment rows for downstream reconciliation task';
