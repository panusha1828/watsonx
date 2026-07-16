{{
    config(
        tags=['sales'],
        materialized='incremental',
        unique_key='sales_sk',
        on_schema_change='append_new_columns'
    )
}}

-- Grain: one row per order. See docs/architecture.md for lineage:
-- stg_orders + stg_payments + stg_products -> int_sales_metrics -> fact_sales

with sales_metrics as (

    select * from {{ ref('int_sales_metrics') }}

)

select
    sales_sk,
    order_id,
    customer_id,
    store_id,
    order_date,
    order_channel,
    order_status,
    payment_method,
    payment_status,
    total_amount,
    {{ audit_columns() }}
from sales_metrics

{% if is_incremental() %}
where order_date > (select max(order_date) from {{ this }})
{% endif %}
