{{
    config(
        tags=['customer']
    )
}}

with customers as (

    select * from {{ ref('stg_customers') }}

),

customer_orders as (

    select * from {{ ref('int_customer_orders') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['customers.customer_id']) }} as customer_sk,
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customers.email,
        customers.phone_number,
        customers.signup_date,
        customers.loyalty_tier,
        customer_orders.lifetime_order_count,
        customer_orders.lifetime_order_value,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        {{ audit_columns() }}
    from customers
    left join customer_orders
        on customers.customer_id = customer_orders.customer_id

)

select * from final
