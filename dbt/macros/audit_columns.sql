{#
    Standard audit columns appended to every mart model.
    Usage: select ..., {{ audit_columns() }} from ...
#}

{% macro audit_columns() %}
    current_timestamp() as _dbt_loaded_at,
    '{{ invocation_id }}' as _dbt_invocation_id
{% endmacro %}
