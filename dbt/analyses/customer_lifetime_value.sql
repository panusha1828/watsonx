-- Ad hoc analysis (not materialized): approximate Customer Lifetime Value
-- ranking used to answer "which customers are most valuable" questions.
-- Run with: dbt compile --select analysis:customer_lifetime_value

select
    customer_id,
    loyalty_tier,
    lifetime_order_count,
    lifetime_order_value,
    lifetime_order_value / nullif(lifetime_order_count, 0) as avg_order_value,
    rank() over (order by lifetime_order_value desc) as clv_rank
from {{ ref('dim_customer') }}
order by clv_rank
