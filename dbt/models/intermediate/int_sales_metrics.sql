-- Feeds fact_sales. Joins orders, payments, and products to build
-- order-line-grain sales metrics.

with orders as (

    select * from {{ ref('stg_orders') }}

),

payments as (

    select * from {{ ref('stg_payments') }}

),

products as (

    select * from {{ ref('stg_products') }}

),

sales_base as (

    select
        orders.order_id,
        orders.customer_id,
        orders.store_id,
        orders.order_date,
        orders.order_channel,
        orders.order_status,
        payments.payment_method,
        payments.payment_status,
        orders.total_amount,
        {{ dbt_utils.generate_surrogate_key(['orders.order_id', 'orders.customer_id']) }}
            as sales_sk
    from orders
    left join payments
        on orders.order_id = payments.order_id

)

select * from sales_base
