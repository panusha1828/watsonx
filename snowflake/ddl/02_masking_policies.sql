-- ============================================================================
-- 02_masking_policies.sql
-- Column-level masking policies for PII fields. See docs/data-governance.md.
-- ============================================================================

USE DATABASE RETAIL360;
USE SCHEMA MARTS;

CREATE OR REPLACE MASKING POLICY email_mask AS (val STRING) RETURNS STRING ->
    CASE
        WHEN CURRENT_ROLE() IN ('RETAIL360_ADMIN', 'RETAIL360_ANALYST') THEN val
        ELSE REGEXP_REPLACE(val, '^(.).*(@.*)$', '\\1***\\2')
    END;

CREATE OR REPLACE MASKING POLICY phone_mask AS (val STRING) RETURNS STRING ->
    CASE
        WHEN CURRENT_ROLE() IN ('RETAIL360_ADMIN', 'RETAIL360_ANALYST') THEN val
        ELSE 'XXX-XXX-' || RIGHT(val, 4)
    END;

-- Applied post-hoc via dbt hooks; see dbt/macros/apply_masking_policies.sql
-- ALTER TABLE MARTS.DIM_CUSTOMER MODIFY COLUMN email SET MASKING POLICY email_mask;
-- ALTER TABLE MARTS.DIM_CUSTOMER MODIFY COLUMN phone_number SET MASKING POLICY phone_mask;
