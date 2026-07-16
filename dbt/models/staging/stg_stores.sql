with source as (

    select * from {{ source('raw', 'stores') }}

),

renamed as (

    select
        store_id,
        store_name,
        store_type,
        city,
        state,
        region,
        try_to_date(opened_date) as opened_date,
        _loaded_at
    from source
    where store_id is not null

    -- TODO(R360-018): store_type has inconsistent casing in some historical
    -- loads ('online' vs 'Online'); add a standardization step here.

)

select * from renamed
