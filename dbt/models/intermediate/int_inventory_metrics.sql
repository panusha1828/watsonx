-- NOTE: this model performs a full recompute on every run. See
-- docs/architecture.md "Known Limitations" and Jira R360-014 for the
-- planned incremental conversion.

with products as (

    select * from {{ ref('stg_products') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

-- Placeholder inventory-on-hand logic until a dedicated inventory source
-- system feed is connected (tracked in backlog R360-027).
inventory_estimate as (

    select
        products.product_id,
        products.category,
        products.unit_cost,
        count(orders.order_id) as units_sold_estimate
    from products
    left join orders
        on true  -- FIXME(R360-027): placeholder join until order_lines exist
    group by 1, 2, 3

)

select * from inventory_estimate
