with source as (

    select * from {{ source('raw', 'payments') }}

),

renamed as (

    select
        payment_id,
        order_id,
        payment_method,
        payment_card_last4,
        payment_status,
        try_to_timestamp(paid_at) as paid_at,
        _loaded_at
    from source
    where payment_id is not null

)

select * from renamed
