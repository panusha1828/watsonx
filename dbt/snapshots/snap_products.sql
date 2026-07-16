{% snapshot snap_products %}

{{
    config(
        target_schema='snapshots',
        unique_key='product_id',
        strategy='check',
        check_cols=['unit_price', 'unit_cost'],
    )
}}

-- Check strategy used here (rather than timestamp) because product price
-- changes don't reliably update a timestamp column in the source system.

select * from {{ source('raw', 'products') }}

{% endsnapshot %}
