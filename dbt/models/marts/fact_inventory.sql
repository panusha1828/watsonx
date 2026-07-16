{{
    config(
        tags=['inventory']
        -- NOTE: full-refresh table for now; see R360-014 for the planned
        -- incremental conversion once a true inventory-on-hand source
        -- feed is available.
    )
}}

with inventory_metrics as (

    select * from {{ ref('int_inventory_metrics') }}

)

select
    product_id,
    category,
    unit_cost,
    units_sold_estimate,
    {{ audit_columns() }}
from inventory_metrics
