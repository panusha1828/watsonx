-- Custom singular test: total_amount on fact_sales should never be negative.

select
    order_id,
    total_amount
from {{ ref('fact_sales') }}
where total_amount < 0
