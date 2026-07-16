{% snapshot snap_customers %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_id',
        strategy='timestamp',
        updated_at='_loaded_at',
    )
}}

select * from {{ source('raw', 'customers') }}

{% endsnapshot %}
