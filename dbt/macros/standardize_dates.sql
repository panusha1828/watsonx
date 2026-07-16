{#
    Safely casts a string column to DATE, returning null on parse failure
    instead of erroring the whole model. Wraps Snowflake's TRY_TO_DATE.

    Usage: {{ standardize_dates('order_date') }}
#}

{% macro standardize_dates(column_name) %}
    try_to_date({{ column_name }})
{% endmacro %}
