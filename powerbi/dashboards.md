# Dashboard Inventory

## Executive Sales Dashboard
- **Owner:** Sales Analytics
- **Depends on:** `fact_sales`, `dim_customer`, `dim_store`, `dim_date`
- **Key visuals:** Revenue by channel, MoM growth, Top stores by revenue

## Customer 360 Dashboard
- **Owner:** Customer Analytics
- **Depends on:** `dim_customer`, `fact_orders`
- **Key visuals:** Loyalty tier distribution, Lifetime value ranking, Order
  frequency

## Inventory Overview Dashboard
- **Owner:** Supply Chain Analytics
- **Depends on:** `fact_inventory`, `dim_product`
- **Status:** In progress - blocked on `int_inventory_metrics` incremental
  conversion (see backlog `R360-014`)
