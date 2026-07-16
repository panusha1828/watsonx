-- ============================================================================
-- file_formats.sql
-- ============================================================================

USE DATABASE RETAIL360;
USE SCHEMA RAW;

CREATE FILE FORMAT IF NOT EXISTS CSV_FORMAT
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF = ('NULL', 'null', '')
    EMPTY_FIELD_AS_NULL = TRUE
    COMPRESSION = 'AUTO';

CREATE FILE FORMAT IF NOT EXISTS JSON_FORMAT
    TYPE = 'JSON'
    STRIP_OUTER_ARRAY = TRUE
    COMPRESSION = 'AUTO';
