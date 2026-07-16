{#
    Cross-warehouse-safe current timestamp helper. Currently Snowflake-only
    since this project targets Snowflake exclusively, but kept as a macro
    for consistency with multi-warehouse dbt projects and easier testing.
#}

{% macro dbt_current_timestamp() %}
    {{ return("current_timestamp()") }}
{% endmacro %}
