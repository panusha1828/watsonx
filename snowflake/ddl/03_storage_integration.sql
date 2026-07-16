-- ============================================================================
-- 03_storage_integration.sql
-- AWS S3 storage integration used by all stages. Run as ACCOUNTADMIN.
-- Requires IAM role ARN to be created out-of-band in AWS and the trust
-- relationship updated with the STORAGE_AWS_IAM_USER_ARN / EXTERNAL_ID
-- returned by DESC INTEGRATION.
-- ============================================================================

CREATE STORAGE INTEGRATION IF NOT EXISTS RETAIL360_S3_INT
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = 'S3'
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::123456789012:role/retail360-snowflake-role'
    STORAGE_ALLOWED_LOCATIONS = (
        's3://retail360-raw-landing/orders/',
        's3://retail360-raw-landing/customers/',
        's3://retail360-raw-landing/products/',
        's3://retail360-raw-landing/stores/',
        's3://retail360-raw-landing/payments/'
    )
    COMMENT = 'Storage integration for Retail360 raw landing bucket';

-- DESC INTEGRATION RETAIL360_S3_INT;
