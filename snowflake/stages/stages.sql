-- ============================================================================
-- stages.sql
-- External stages, one per source domain, backed by RETAIL360_S3_INT.
-- ============================================================================

USE DATABASE RETAIL360;
USE SCHEMA RAW;

CREATE STAGE IF NOT EXISTS ORDERS_STAGE
    STORAGE_INTEGRATION = RETAIL360_S3_INT
    URL = 's3://retail360-raw-landing/orders/'
    FILE_FORMAT = CSV_FORMAT;

CREATE STAGE IF NOT EXISTS CUSTOMERS_STAGE
    STORAGE_INTEGRATION = RETAIL360_S3_INT
    URL = 's3://retail360-raw-landing/customers/'
    FILE_FORMAT = CSV_FORMAT;

CREATE STAGE IF NOT EXISTS PRODUCTS_STAGE
    STORAGE_INTEGRATION = RETAIL360_S3_INT
    URL = 's3://retail360-raw-landing/products/'
    FILE_FORMAT = CSV_FORMAT;

CREATE STAGE IF NOT EXISTS STORES_STAGE
    STORAGE_INTEGRATION = RETAIL360_S3_INT
    URL = 's3://retail360-raw-landing/stores/'
    FILE_FORMAT = CSV_FORMAT;

CREATE STAGE IF NOT EXISTS PAYMENTS_STAGE
    STORAGE_INTEGRATION = RETAIL360_S3_INT
    URL = 's3://retail360-raw-landing/payments/'
    FILE_FORMAT = JSON_FORMAT;
