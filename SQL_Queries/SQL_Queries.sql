CREATE TABLE dim_customer(
customer_id VARCHAR(250) PRIMARY KEY,
customer_unique_id VARCHAR(250));

CREATE TABLE dim_payments(
order_id VARCHAR(250),
payment_sequential INT,
payment_type VARCHAR(250),
payment_installments INT,
payment_value DECIMAL,
PRIMARY KEY (order_id, payment_sequential, payment_value));

-- Check combined unique key
SELECT order_id, payment_sequential, payment_value, COUNT(*)
FROM dim_payments
GROUP BY order_id, payment_sequential, payment_value
ORDER BY 2 DESC

CREATE TABLE dim_product(
product_id VARCHAR(250) PRIMARY KEY,
product_category_name VARCHAR(250),
product_name_lenght INT,
product_description_lenght INT,
product_photos_qty INT,
product_weight_g INT,
product_lenght_cm INT,
product_height_cm INT,
product_width_cm INT);

CREATE TABLE fct_order_item(
order_id VARCHAR(250),
order_item_id INT,
product_id VARCHAR(250) REFERENCES dim_product(product_id),
seller_id VARCHAR(250),
shipping_limit_date TIMESTAMP,
price DECIMAL,
freight_value DECIMAL,
PRIMARY KEY (order_id, order_item_id, product_id));

ALTER TABLE fct_order_item ALTER COLUMN shipping_limit_date TYPE DATE USING shipping_limit_date::DATE;

CREATE TABLE fct_orders(
order_id VARCHAR(250) PRIMARY KEY,
customer_id VARCHAR(250) REFERENCES dim_customer(customer_id),
order_status VARCHAR(250),
order_purchase_timestamp TIMESTAMP,
order_approved_at TIMESTAMP,
order_delivered_carrier_date TIMESTAMP,
order_delivered_customer_date TIMESTAMP,
order_estimated_delivery_date TIMESTAMP);

ALTER TABLE fct_orders ALTER COLUMN order_purchase_timestamp TYPE DATE USING order_purchase_timestamp::DATE;
ALTER TABLE fct_orders RENAME COLUMN order_purchase_timestamp TO order_purchase_date;
ALTER TABLE fct_orders ALTER COLUMN order_approved_at TYPE DATE USING order_approved_at::DATE;
ALTER TABLE fct_orders ALTER COLUMN order_delivered_carrier_date TYPE DATE USING order_delivered_carrier_date::DATE;
ALTER TABLE fct_orders ALTER COLUMN order_delivered_customer_date TYPE DATE USING order_delivered_customer_date::DATE;
ALTER TABLE fct_orders ALTER COLUMN order_estimated_delivery_date TYPE DATE USING order_estimated_delivery_date::DATE;

CREATE TABLE fct_order_joined AS(
SELECT fo.*, foi.product_id, foi.seller_id, foi.price, foi.freight_value
FROM fct_orders fo
JOIN fct_order_item foi ON fo.order_id = foi.order_id);

ALTER TABLE fct_order_joined DROP COLUMN order_approved_at;
ALTER TABLE fct_order_joined DROP COLUMN order_delivered_carrier_date;
ALTER TABLE fct_order_joined DROP COLUMN order_delivered_customer_date;
ALTER TABLE fct_order_joined DROP COLUMN order_estimated_delivery_date;
ALTER TABLE fct_order_joined DROP COLUMN product_id;
ALTER TABLE fct_order_joined DROP COLUMN seller_id;
ALTER TABLE fct_order_joined DROP COLUMN freight_value;
ALTER TABLE fct_order_joined DROP COLUMN order_status;

CREATE TABLE new_fct_tbl_v2 AS(
SELECT fo.order_id,
	dc.customer_unique_id,
	SUM(foi.price) AS total_paid,
	COUNT(foi.product_id) AS products,
	order_purchase_date
FROM fct_order_item foi
LEFT JOIN dim_product dp ON foi.product_id = dp.product_id
LEFT JOIN fct_orders fo ON foi.order_id = fo.order_id
LEFT JOIN dim_customer dc ON fo.customer_id = dc.customer_id
GROUP BY fo.order_id, dc.customer_unique_id
ORDER BY order_purchase_date DESC)

COPY new_fct_tbl_v2 TO 'C:\Users\Public\new_fct_tbl_v2.csv' WITH DELIMITER ',' CSV HEADER;
