{#
    Post-hook macro that applies column masking policies to PII columns on
    dim_customer after each run. See snowflake/ddl/02_masking_policies.sql
    for the policy definitions and docs/data-governance.md for the policy.

    Usage (in dbt_project.yml or model config):
    post-hook: "{{ apply_masking_policies() }}"
#}

{% macro apply_masking_policies() %}
    {% set sql %}
        alter table {{ this }} modify column email set masking policy email_mask;
        alter table {{ this }} modify column phone_number set masking policy phone_mask;
    {% endset %}
    {% do run_query(sql) %}
{% endmacro %}
