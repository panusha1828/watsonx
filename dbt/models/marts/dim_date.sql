{{
    config(
        tags=['sales']
    )
}}

-- Standard date spine dimension, generated via dbt_utils.date_spine.
-- Range controlled by the `start_date` var in dbt_project.yml.

with date_spine as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('" ~ var('start_date') ~ "' as date)",
        end_date="dateadd(year, 2, current_date())"
    ) }}

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['date_day']) }} as date_sk,
        date_day as full_date,
        year(date_day) as year,
        quarter(date_day) as quarter,
        month(date_day) as month,
        monthname(date_day) as month_name,
        day(date_day) as day_of_month,
        dayname(date_day) as day_name,
        weekofyear(date_day) as week_of_year,
        case when dayofweek(date_day) in (0, 6) then true else false end as is_weekend
    from date_spine

)

select * from final
