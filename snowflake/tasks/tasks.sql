-- ============================================================================
-- tasks.sql
-- Scheduled Snowflake-native tasks. Most transformation happens in dbt;
-- these tasks handle lightweight pre-dbt reconciliation only.
-- ============================================================================

USE DATABASE RETAIL360;
USE SCHEMA RAW;

CREATE TASK IF NOT EXISTS REFRESH_PAYMENT_RECONCILIATION_TASK
    WAREHOUSE = LOADING_WH
    SCHEDULE = 'USING CRON 0 * * * * UTC'
    WHEN SYSTEM$STREAM_HAS_DATA('PAYMENTS_STREAM')
AS
    MERGE INTO RAW.PAYMENT_RECONCILIATION AS tgt
    USING PAYMENTS_STREAM AS src
    ON tgt.payment_id = src.payment_id
    WHEN NOT MATCHED THEN
        INSERT (payment_id, order_id, payment_status, paid_at)
        VALUES (src.payment_id, src.order_id, src.payment_status, src.paid_at);

-- FIXME(R360-032): This task assumes RAW.PAYMENT_RECONCILIATION already exists;
-- add an IF NOT EXISTS create statement before enabling in a fresh environment.

ALTER TASK IF EXISTS REFRESH_PAYMENT_RECONCILIATION_TASK RESUME;
