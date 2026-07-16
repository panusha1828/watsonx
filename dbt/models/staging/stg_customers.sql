with source as (

    select * from {{ source('raw', 'customers') }}

),

renamed as (

    select
        customer_id,
        first_name,
        last_name,
        lower(trim(email)) as email,
        phone_number,
        try_to_date(signup_date) as signup_date,
        coalesce(loyalty_tier, 'none') as loyalty_tier,
        _loaded_at
    from source
    where customer_id is not null

)

select * from renamed
