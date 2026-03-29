/*
===============================================================================
E-COMMERCE DATA ANALYSIS PROJECT: ECONOMIC IMPACT & LOGISTICS PERFORMANCE
===============================================================================
Purpose: 
    - Compare revenue growth between 2017 and 2018 (Jan-Aug).
    - Analyze freight cost distribution across Brazilian states.
    - Measure delivery efficiency (Actual vs. Estimated delivery dates).
    
Tables used: orders, payments, order_items, customers
===============================================================================
*/
-- 1. Revenue Growth Comparison (Jan-Aug 2017 vs 2018)
-- Goal: Measure the "Real-World" scaling of payment volume for the same period.
SELECT 
    EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
    ROUND(SUM(p.payment_value), 2) AS total_revenue
FROM `Project1.orders` AS o
JOIN `Project1.payments` AS p ON o.order_id = p.order_id
WHERE EXTRACT(MONTH FROM o.order_purchase_timestamp) BETWEEN 1 AND 8
  AND EXTRACT(YEAR FROM o.order_purchase_timestamp) IN (2017, 2018)
GROUP BY 1
ORDER BY 1;

/*
year	total_revenue
2017	3669022.12
2018	8694733.84
*/

/* INSIGHT: 
Revenue for the Jan-Aug period grew from $3669022.12 in 2017 to $8694733.84 in 2018. 
This increase in revenue confirms that the platform is not just getting 
more orders, but higher-value transactions.
*/


-- 2. Logistics Efficiency: Delivery Lead Time vs. Expectations
-- Goal: Calculate the "Expectation Buffer" (How much earlier/later we deliver).
SELECT 
    customer_state,
    ROUND(AVG(DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY)), 2) AS avg_delivery_days,
    ROUND(AVG(DATE_DIFF(order_estimated_delivery_date, order_delivered_customer_date, DAY)), 2) AS avg_buffer_days
FROM `Project1.orders` AS o
JOIN `Project1.customers` AS c ON o.customer_id = c.customer_id
WHERE order_status = 'delivered'
GROUP BY 1
ORDER BY 2 DESC;

/* OUTPUT: 
customer_state	avg_delivery_days	avg_buffer_days
	RR				28.98				16.41
	AP				26.73				18.73
	AM				25.99				18.61
	AL				24.04				7.95
	PA				23.32				13.19
	MA				21.12				8.77
	SE				21.03				9.17
	CE				20.82				9.96
	AC				20.64				19.76
	PB				19.95				12.37
	PI				18.99				10.47
	RO				18.91				19.13
	BA				18.87				9.93
	RN				18.82				12.76
	PE				17.97				12.4
	MT				17.59				13.43
	TO				17.23				11.26
	ES				15.33				9.62
	MS				15.19				10.17
	GO				15.15				11.27
	RJ				14.85				10.9
	RS				14.82				12.98
	SC				14.48				10.6
	DF				12.51				11.12
	MG				11.54				12.3
	PR				11.53				12.36
	SP	 			8.3					10.13
*/

/* INSIGHT: 
States in the North (like RR and AP) have the longest delivery times (20+ days). 
However, the high "buffer_days" across all states suggests the company is 
purposefully over-estimating delivery dates to improve customer satisfaction.
*/


-- 3. Freight Cost Analysis by Region
-- Goal: Identify which states are the most expensive to ship to.
SELECT 
    c.customer_state,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight_cost
FROM `Project1.order_items` AS oi
JOIN `Project1.orders` AS o ON oi.order_id = o.order_id
JOIN `Project1.customers` AS c ON o.customer_id = c.customer_id
GROUP BY 1
ORDER BY 2 DESC;

/* 
customer_state	avg_freight_cost
	RR				42.98
	PB				42.72
	RO				41.07
	AC				40.07
	PI				39.15
	MA				38.26
	TO				37.25
	SE				36.65
	AL				35.84
	PA				35.83
	RN				35.65
	AP				34.01
	AM				33.21
	PE				32.92
	CE				32.71
	MT				28.17
	BA				26.36
	MS				23.37
	GO				22.77
	ES				22.06
	RS				21.74
	SC				21.47
	DF				21.04
	RJ				20.96
	MG				20.63
	PR				20.53
	SP				15.15
*/

/* INSIGHT: 
Freight costs in PB and RR are nearly 3x higher than in SP. 
This highlights a massive "Logistics Tax" on Northern regions, 
impacting price competitiveness outside the Southeast.
*/



-- Advanced Logistics: Categorizing Shipping Speed Efficiency
-- Goal: Identify the percentage of "Success" (Fast) vs. "Failure" (Late) deliveries.
SELECT 
    CASE 
        WHEN DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY) <= 7 THEN 'Fast (Under 1 Week)'
        WHEN DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY) <= 15 THEN 'Standard (1-2 Weeks)'
        WHEN DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY) <= 30 THEN 'Slow (2-4 Weeks)'
        ELSE 'Critical (30+ Days)'
    END AS delivery_speed_segment,
    COUNT(order_id) AS order_count,
    ROUND(COUNT(order_id) * 100 / SUM(COUNT(order_id)) OVER(), 2) AS pct_of_total
FROM `Project1.orders`
WHERE order_status = 'delivered' 
  AND order_delivered_customer_date IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;

/* OUTPUT:
delivery_speed_segment	order_count	pct_of_total
	Standard (1-2 Weeks)	39567	41.01
	Fast (Under 1 Week)		33696	34.93
	Slow (2-4 Weeks)		19090	19.79
	Critical (30+ Days)		4117	4.27
*/

/* INSIGHT: 
The platform maintains a 75.9% 'Healthy Delivery' rate (Under 15 days). 
However, 24% of the business experiences delivery times exceeding 2 weeks, 
with 4.27% in the 'Critical' category (30+ days). This distribution confirms 
that logistics friction is not an outlier but a systemic issue for nearly 
a quarter of all transactions.
*/
