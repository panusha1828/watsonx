-- ============================================================================
-- raw_tables.sql
-- RAW layer table definitions. Snowpipe loads directly into these tables.
-- ============================================================================

USE DATABASE RETAIL360;
USE SCHEMA RAW;

CREATE TABLE IF NOT EXISTS RAW.CUSTOMERS (
    customer_id STRING,
    first_name STRING,
    last_name STRING,
    email STRING,
    phone_number STRING,
    signup_date STRING,
    loyalty_tier STRING,
    _loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    _file_name STRING
);

CREATE TABLE IF NOT EXISTS RAW.ORDERS (
    order_id STRING,
    customer_id STRING,
    store_id STRING,
    order_date STRING,
    order_status STRING,
    order_channel STRING,
    total_amount STRING,
    _loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    _file_name STRING
);

CREATE TABLE IF NOT EXISTS RAW.PRODUCTS (
    product_id STRING,
    product_name STRING,
    category STRING,
    sub_category STRING,
    unit_price STRING,
    unit_cost STRING,
    _loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    _file_name STRING
);

CREATE TABLE IF NOT EXISTS RAW.STORES (
    store_id STRING,
    store_name STRING,
    store_type STRING,
    city STRING,
    state STRING,
    region STRING,
    opened_date STRING,
    _loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    _file_name STRING
);

CREATE TABLE IF NOT EXISTS RAW.PAYMENTS (
    payment_id STRING,
    order_id STRING,
    payment_method STRING,
    payment_card_last4 STRING,
    payment_status STRING,
    paid_at STRING,
    _loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    _file_name STRING
);
