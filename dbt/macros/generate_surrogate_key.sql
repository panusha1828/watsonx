{#
    Thin wrapper around dbt_utils.generate_surrogate_key so model code reads
    consistently across the project. Kept as our own macro (rather than
    calling dbt_utils directly everywhere) so we can swap hashing strategy
    project-wide in one place if needed.
#}

{% macro generate_surrogate_key(field_list) %}
    {{ dbt_utils.generate_surrogate_key(field_list) }}
{% endmacro %}
