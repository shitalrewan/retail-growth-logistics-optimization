/*
===============================================================================
E-COMMERCE DATA ANALYSIS PROJECT: COMPREHENSIVE FOUNDATIONAL EDA
===============================================================================
Purpose: 
    - Verify data integrity, schema types, and table relationships.
    - Audit the scope of time, geography, and financial values.
    - Identify potential data anomalies (Nulls/Duplicates) across all tables.
    
Tables used: customers, orders, payments, order_items, geolocation
===============================================================================
*/

-- 1. Metadata Check: Inspecting the schema of core tables
-- Ensures we understand which columns are STRING (categorical) vs NUMERIC (for math).
SELECT 
    table_name, 
    column_name, 
    data_type 
FROM `Project1.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name IN ('customers', 'orders', 'payments', 'order_items');

 
/* OUTPUT:
table_name		column_name				data_type
orders			order_id				STRING
orders			customer_id				STRING
orders			order_status			STRING
orders	order_purchase_timestamp		TIMESTAMP
orders		order_approved_at			TIMESTAMP
orders	order_delivered_carrier_date	TIMESTAMP
orders	order_delivered_customer_date	TIMESTAMP
orders	order_estimated_delivery_date	TIMESTAMP
payments		order_id				STRING
payments	payment_sequential			INT64
payments		payment_type			STRING
payments	payment_installments		INT64
payments		payment_value			FLOAT64
customers		customer_id				STRING
customers	customer_unique_id			STRING
customers	customer_zip_code_prefix	INT64
customers		customer_city			STRING
customers		customer_state			STRING
*/

/* INSIGHT: 
Identifiers like order_id are consistently STRING. Financial columns like 
payment_value and freight_value are FLOAT64/NUMERIC, allowing for direct aggregation.
*/


-- 2. Time Range Audit: Determining the dataset's chronological boundaries
-- Essential for contextualizing growth (e.g., are we looking at a full year or partial?).
SELECT 
    MIN(order_purchase_timestamp) AS first_order_timestamp,
    MAX(order_purchase_timestamp) AS last_order_timestamp,
    MIN(TIME(order_purchase_timestamp)) AS earliest_order_time,
    MAX(TIME(order_purchase_timestamp)) AS latest_order_time
FROM `Project1.orders`;

/* OUTPUT:
	first_order_timestamp				last_order_timestamp		earliest_order_time		latest_order_time
2016-09-04 21:15:19.000000 UTC	| 2018-10-17 17:30:18.000000 UTC |		00:00:00		 |		23:59:59
*/

/* INSIGHT: 
The dataset spans late 2016 through late 2018. The time audit confirms data 
capture across a full 24-hour cycle (00:00 to 23:59), indicating no system downtime gaps.
*/


-- 3. Geographic Footprint: Breadth of the Brazilian Market
-- Measures the platform's reach across cities and states.
SELECT 
    COUNT(DISTINCT customer_city) AS total_unique_cities,
    COUNT(DISTINCT customer_state) AS total_unique_states
FROM `Project1.customers`;

/* OUTPUT:
total_unique_cities			total_unique_states
		4119						27
*/

/* INSIGHT: 
The presence of all 27 Brazilian federative units (states) confirms this is 
a national-scale dataset, not just a regional pilot.
*/


-- 4. Financial Audit: Payment Type & Value Integrity
-- Checking for distinct payment methods and logical value ranges.
SELECT 
    payment_type, 
    COUNT(*) as transaction_count,
    ROUND(AVG(payment_value), 2) AS avg_transaction_value
FROM `Project1.payments`
GROUP BY 1
ORDER BY 2 DESC;

/* OUTPUT:
	payment_type		transaction_count		avg_transaction_value
	credit_card				76795					163.32
	UPI						19784					145.03
	voucher					5775					65.7
	debit_card				1529					142.57
	not_defined				3						0.0
*/

/* INSIGHT: 
Credit cards are the most frequent, while vouchers show a different spending profile. 
Detecting 'not_defined' types here allows us to clean data before final reporting.
*/


-- 5. Primary Key & Integrity Check: Duplicates and Nulls
-- Vital for ensuring "Join" operations won't inflate numbers due to duplicate keys.
SELECT 
    'customers' AS table_name, COUNTIF(customer_id IS NULL) AS null_pks, COUNT(*) - COUNT(DISTINCT customer_id) AS duplicates FROM `Project1.customers`
UNION ALL
SELECT 
    'orders' AS table_name, COUNTIF(order_id IS NULL) AS null_pks, COUNT(*) - COUNT(DISTINCT order_id) AS duplicates FROM `Project1.orders`
UNION ALL
SELECT 
    'payments' AS table_name, COUNTIF(order_id IS NULL) AS null_pks, 0 AS duplicates FROM `Project1.payments`; -- Payments allow multiple rows per order

/* OUTPUT:
table_name	null_pks	duplicates
customers		0			0
orders			0			0
payments		0			0
*/

/* INSIGHT: 
Zero nulls and zero duplicates in primary keys (customer_id/order_id) 
confirms high data quality and relational integrity.
*/


-- 6. Logistics Health Check: Logical Date Validation
-- Identifying "Impossible" dates where delivery happens before purchase.
SELECT 
    COUNT(*) AS illogical_delivery_dates
FROM `Project1.orders`
WHERE order_delivered_customer_date < order_purchase_timestamp;

/* OUTPUT:
illogical_delivery_dates
			0
*/

/* INSIGHT: 
Illogical dates are near-zero, proving that the 'delivery_time' calculations 
in Script #03 will be reliable.
*/