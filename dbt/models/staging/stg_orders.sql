with source as (

    select * from {{ source('raw', 'orders') }}

),

renamed as (

    select
        order_id,
        customer_id,
        store_id,
        try_to_date(order_date) as order_date,
        order_status,
        order_channel,
        try_to_decimal(total_amount, 12, 2) as total_amount,
        _loaded_at
    from source
    where order_id is not null

)

select * from renamed
