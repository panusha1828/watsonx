with source as (

    select * from {{ source('raw', 'products') }}

),

renamed as (

    select
        product_id,
        product_name,
        category,
        sub_category,
        try_to_decimal(unit_price, 12, 2) as unit_price,
        try_to_decimal(unit_cost, 12, 2) as unit_cost,
        _loaded_at
    from source
    where product_id is not null

)

select * from renamed
