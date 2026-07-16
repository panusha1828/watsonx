with orders as (

    select * from {{ ref('stg_orders') }}

),

customers as (

    select * from {{ ref('stg_customers') }}

),

customer_order_agg as (

    select
        customers.customer_id,
        customers.loyalty_tier,
        count(orders.order_id) as lifetime_order_count,
        sum(orders.total_amount) as lifetime_order_value,
        min(orders.order_date) as first_order_date,
        max(orders.order_date) as most_recent_order_date
    from customers
    left join orders
        on customers.customer_id = orders.customer_id
        and orders.order_status != 'cancelled'
    group by 1, 2

)

select * from customer_order_agg
