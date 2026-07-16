{{
    config(
        tags=['sales']
    )
}}

with stores as (

    select * from {{ ref('stg_stores') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['store_id']) }} as store_sk,
        store_id,
        store_name,
        store_type,
        city,
        state,
        region,
        opened_date,
        {{ audit_columns() }}
    from stores

)

select * from final
