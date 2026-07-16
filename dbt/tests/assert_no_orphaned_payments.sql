-- Custom singular test: every payment must reference a real order.
-- (Complements the relationships test in staging/schema.yml but checks
-- at the mart layer as a defense-in-depth measure.)

select
    p.payment_id,
    p.order_id
from {{ ref('fact_payments') }} p
left join {{ ref('fact_orders') }} o
    on p.order_id = o.order_id
where o.order_id is null
