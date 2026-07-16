{{
    config(
        tags=['sales'],
        materialized='incremental',
        unique_key='order_id',
        on_schema_change='append_new_columns'
    )
}}

with orders as (

    select * from {{ ref('stg_orders') }}

)

select
    order_id,
    customer_id,
    store_id,
    order_date,
    order_status,
    order_channel,
    total_amount,
    {{ audit_columns() }}
from orders

{% if is_incremental() %}
where order_date > (select max(order_date) from {{ this }})
{% endif %}
