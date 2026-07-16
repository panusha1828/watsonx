{{
    config(
        tags=['product']
    )
}}

with products as (

    select * from {{ ref('stg_products') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_sk,
        product_id,
        product_name,
        category,
        sub_category,
        unit_price,
        unit_cost,
        round(unit_price - unit_cost, 2) as unit_margin,
        {{ audit_columns() }}
    from products

)

select * from final
