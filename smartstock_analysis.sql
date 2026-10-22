USE smartstock_db;

-- 1. Check the number of records in each table
SELECT COUNT(*) AS total_sales FROM sales;
SELECT COUNT(*) AS total_products FROM products;
SELECT COUNT(*) AS total_inventory_records FROM inventory;

-- 2. Overall sales performance
SELECT
ROUND(SUM(quantity * unit_price), 2) AS total_revenue,
ROUND(SUM(quantity * unit_cost), 2) AS total_cost,
ROUND(SUM(quantity * (unit_price - unit_cost)), 2) AS total_profit,
ROUND(
SUM(quantity * (unit_price - unit_cost))
/ NULLIF(SUM(quantity * unit_price), 0) * 100,
2
) AS profit_margin_percent
FROM sales;

-- 3. Sales performance by product
SELECT
p.product_id,
p.product_name,
SUM(s.quantity) AS total_units_sold,
ROUND(SUM(s.quantity * s.unit_price), 2) AS total_revenue,
ROUND(SUM(s.quantity * s.unit_cost), 2) AS total_cost,
ROUND(SUM(s.quantity * (s.unit_price - s.unit_cost)), 2) AS total_profit
FROM sales s
JOIN products p
ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_profit DESC;

-- 4. Top five most profitable products
SELECT
p.product_id,
p.product_name,
ROUND(SUM(s.quantity * (s.unit_price - s.unit_cost)), 2) AS total_profit
FROM sales s
JOIN products p
ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_profit DESC
LIMIT 5;

-- 5. Products requiring replenishment
SELECT
p.product_id,
p.product_name,
i.stock_on_hand,
i.reorder_level,
(i.reorder_level - i.stock_on_hand) AS units_to_order
FROM inventory i
JOIN products p
ON i.product_id = p.product_id
WHERE i.stock_on_hand < i.reorder_level
ORDER BY units_to_order DESC;

-- 6. Inventory summary
SELECT
COUNT(*) AS total_inventory_records,
SUM(stock_on_hand) AS total_units_in_stock,
SUM(stock_on_hand < reorder_level) AS products_needing_reorder,
SUM(
CASE
WHEN stock_on_hand < reorder_level
THEN reorder_level - stock_on_hand
ELSE 0
END
) AS total_units_to_order
FROM inventory;

-- 7. Sales records without a matching product
SELECT
s.sale_line_id,
s.order_id,
s.product_id,
s.quantity,
s.unit_price
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
WHERE p.product_id IS NULL;

-- 8. Duplicate sales records
SELECT COUNT(*) AS duplicate_groups
FROM (
SELECT
sale_line_id, order_id, order_date, product_id,
quantity, unit_price, unit_cost
FROM sales
GROUP BY
sale_line_id, order_id, order_date, product_id,
quantity, unit_price, unit_cost
HAVING COUNT(*) > 1
) AS duplicates;

-- 9. Sales records with missing or invalid order dates
SELECT COUNT(*) AS missing_order_dates
FROM sales
WHERE order_date IS NULL;

-- 10. Sales records with negative quantities
SELECT *
FROM sales
WHERE quantity < 0;