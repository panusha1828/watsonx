{{
    config(
        tags=['sales']
    )
}}

with payments as (

    select * from {{ ref('stg_payments') }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['payment_id']) }} as payment_sk,
        payment_id,
        order_id,
        payment_method,
        payment_status,
        paid_at,
        {{ audit_columns() }}
    from payments

)

select * from final
