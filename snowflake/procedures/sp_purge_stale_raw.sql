-- ============================================================================
-- sp_purge_stale_raw.sql
-- Stored procedure to purge RAW records older than the retention window
-- defined in docs/data-governance.md (13 months).
-- ============================================================================

USE DATABASE RETAIL360;
USE SCHEMA RAW;

CREATE OR REPLACE PROCEDURE SP_PURGE_STALE_RAW(TABLE_NAME STRING, DATE_COLUMN STRING)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    row_count INTEGER;
BEGIN
    EXECUTE IMMEDIATE
        'DELETE FROM RAW.' || TABLE_NAME ||
        ' WHERE TRY_TO_DATE(' || DATE_COLUMN || ') < DATEADD(month, -13, CURRENT_DATE())';
    row_count := SQLROWCOUNT;
    RETURN 'Purged ' || row_count || ' rows from RAW.' || TABLE_NAME;
END;
$$;

-- Example usage:
-- CALL SP_PURGE_STALE_RAW('ORDERS', 'order_date');
