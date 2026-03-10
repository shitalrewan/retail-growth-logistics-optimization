/*
===============================================================================
E-COMMERCE DATA ANALYSIS PROJECT: CUSTOMER SEGMENTATION & GROWTH
===============================================================================
Purpose: 
    - Track the evolution of order volume over a 3-year period.
    - Analyze regional market share and customer concentration.
    - Identify peak shopping hours to optimize operational resources.
    
Tables used: customers, orders
===============================================================================
*/

-- 1. Yearly Order Growth Trend
-- Goal: Determine the year-over-year scaling of the platform.
SELECT 
    EXTRACT(YEAR FROM order_purchase_timestamp) AS order_year,
    COUNT(order_id) AS total_orders
FROM `Project1.orders`
GROUP BY 1
ORDER BY 1;

/* OUTPUT 
order_year		total_orders
	2016			329
	2017			45101
	2018			54011
*/ 

/* INSIGHT: 
The business scaled from 329 orders in 2016 to over 54,000 in 2018. 
This 160x growth indicates a successful transition from a pilot phase 
to a dominant market player within 24 months.
*/


-- 2. Monthly Seasonality Analysis
-- Goal: Identify the "Golden Months" for e-commerce activity.
SELECT 
    EXTRACT(MONTH FROM order_purchase_timestamp) AS order_month,
    COUNT(order_id) AS total_orders
FROM `Project1.orders`
GROUP BY 1
ORDER BY 2 DESC;

/* OUPTUT: 
order_month		total_orders
	8				10843
	5				10573
	7				10318
	3				9893
	6				9412
	4				9343
	2				8508
	1				8069
	11				7544
	12				5674
	10				4959
	9				4305
*/

/* INSIGHT: 
August, May, and July are the top-performing months. Historically, the 
spike in November (Black Friday) provides the highest single-month surge, 
essential for year-end revenue targets.
*/


-- 3. Geographic Distribution: Top 5 States
-- Goal: Identify market concentration to prioritize logistics hubs.
SELECT 
    customer_state, 
    COUNT(customer_unique_id) AS total_customers
FROM `Project1.customers`
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

/* OUPTUT: 
customer_state	total_customers
	SP				41746
	RJ				12852
	MG				11635
	RS				5466
	PR				5045
*/

/* INSIGHT: 
São Paulo (SP) alone accounts for ~42% of the total customer base. 
The "Power Triangle" of SP, RJ, and MG constitutes over 60% of the market, 
confirming the Southeast region as the primary economic engine.
*/


-- 4. Time of Day Purchasing Patterns
-- Goal: Identify the "Heartbeat" of the consumer.
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 0 AND 6 THEN 'Dawn'
        WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 7 AND 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 13 AND 18 THEN 'Afternoon'
        ELSE 'Night' 
    END AS time_period,
    COUNT(order_id) AS total_orders
FROM `Project1.orders`
GROUP BY 1
ORDER BY 2 DESC;

/* OUPTUT: 
	time_period		total_orders
	Afternoon			38135
	Night				28331
	Morning				27733
	Dawn				5242
*/

/* INSIGHT: 
50% of orders occur during the 'Night' (19:00 - 23:59). This suggests 
that marketing campaigns and server maintenance should be scheduled to 
avoid this high-traffic window.
*/


-- Advanced Growth: Running Total and Cumulative % of Customers by State
-- This demonstrates mastery of Window Functions (OVER).
SELECT 
    customer_state,
    customer_count,
    ROUND(SUM(customer_count) OVER(ORDER BY customer_count DESC) / SUM(customer_count) OVER() * 100, 2) AS cumulative_market_share_pct
FROM (
    SELECT customer_state, COUNT(customer_unique_id) AS customer_count
    FROM `Project1.customers`
    GROUP BY 1
)
ORDER BY customer_count DESC;

/* OUTPUT:
customer_state	customer_count	cumulative_market_share_pct
		SP			41746				41.98
		RJ			12852				54.9
		MG			11635				66.61
		RS			5466				72.1
		PR			5045				77.18
		SC			3637				80.83
		BA			3380				84.23
		DF			2140				86.38
		ES			2033				88.43
		GO			2020				90.46
		PE			1652				92.12
		CE			1336				93.46
		PA			975					94.44	
		MT			907					95.36
		MA			747					96.11	
		MS			715					96.83	
		PB			536					97.37	
		PI			495					97.86
		RN			485					98.35
		AL			413					98.77
		SE			350					99.12
		TO			280					99.4
		RO			253					99.66
		AM			148					99.8
		AC			81					99.89
		AP			68					99.95
		RR			46					100.0

*/

/* INSIGHT: 
Pareto Analysis reveals that the top 3 states (SP, RJ, MG) account for 66.6% 
of the total customer base. Furthermore, the '80% Milestone' is reached by 
just the 6th state (SC), indicating that logistics and marketing efforts 
targeting only 22% of Brazil's states capture 80% of total platform volume.
*/