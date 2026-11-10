-- 1. DATABASE EXPLORATION

select current_database();

select table_schema, table_name
from information_schema.tables
where table_schema = 'staging'
 and table_name = 'datacosupplychaindataset';

-- 2. DATASET EXPLORATION

select count(*) as total_records
from staging.datacosupplychaindataset;

select*
from staging.datacosupplychaindataset
limit 10;

SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'staging'
  AND table_name = 'datacosupplychaindataset'
  AND column_name ILIKE '%date%';

-- 3. SALES AND PROFIT ANALYSIS

select 
  SUM("Sales")as total_sales
 from staging.datacosupplychaindataset;

select
   SUM("Order Profit Per Order") as total_profit
from  staging.datacosupplychaindataset;

-- 4. DELIVERY STATUS ANALYSIS

select
   "Delivery Status",
   count(*) as total_order_items
from staging.datacosupplychaindataset
group by "Delivery Status"
order by total_order_items desc;

-- 5. SHIPPING MODE ANALYSIS

select
  "Shipping Mode",
  count(*) as total_order_items
from staging.datacosupplychaindataset
group by "Shipping Mode"
order by total_order_items desc;

SELECT
    "Shipping Mode",
    COUNT(*) AS total_order_items,
    ROUND(SUM("Sales")::numeric, 2) AS total_sales,
    ROUND(SUM("Order Profit Per Order")::numeric, 2) AS total_profit,
    ROUND(
        AVG("Days for shipping (real)")::numeric,
        2
    ) AS avg_shipping_days
FROM staging.datacosupplychaindataset
GROUP BY "Shipping Mode"
ORDER BY total_sales DESC;

-- 6. LATE DELIVERY RISK ANALYSIS

SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'staging'
  AND table_name = 'datacosupplychaindataset'
  AND column_name = 'Late_delivery_risk';

SELECT DISTINCT
    "Late_delivery_risk"
FROM staging.datacosupplychaindataset
ORDER BY 1;

SELECT
    "Shipping Mode",
    COUNT(*) AS total_order_items,
    SUM(
        CASE
            WHEN "Late_delivery_risk" = 1 THEN 1
            ELSE 0
        END
    ) AS late_risk_items,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN "Late_delivery_risk" = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS late_risk_percentage
FROM staging.datacosupplychaindataset
GROUP BY "Shipping Mode"
ORDER BY late_risk_percentage DESC;

-- 7. CATEGORY PERFORMANCE ANALYSIS

SELECT
    "Category Name",
    COUNT(*) AS total_order_items,
    ROUND(SUM("Sales")::numeric, 2) AS total_sales,
    ROUND(SUM("Order Profit Per Order")::numeric, 2) AS total_profit
FROM staging.datacosupplychaindataset
GROUP BY "Category Name"
ORDER BY total_profit DESC;

-- 8. MARKET PERFORMANCE ANALYSIS

SELECT
    "Market",
    COUNT(*) AS total_order_items,
    ROUND(SUM("Sales")::numeric, 2) AS total_sales,
    ROUND(SUM("Order Profit Per Order")::numeric, 2) AS total_profit
FROM staging.datacosupplychaindataset
GROUP BY "Market"
ORDER BY total_sales desc;


-- 9. REGIONAL PERFORMANCE ANALYSIS


SELECT
    "Order Region",
    COUNT(*) AS total_order_items,
    ROUND(SUM("Sales")::numeric, 2) AS total_sales,
    ROUND(SUM("Order Profit Per Order")::numeric, 2) AS total_profit
FROM staging.datacosupplychaindataset
GROUP BY "Order Region"
ORDER BY total_sales DESC;


-- END OF SUPPLY CHAIN ANALYTICS SQL PROJECT