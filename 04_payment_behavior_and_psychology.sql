/*
===============================================================================
E-COMMERCE DATA ANALYSIS PROJECT: PAYMENT BEHAVIOR & PSYCHOLOGY
===============================================================================
Purpose: 
    - Identify the dominant payment methods used by consumers.
    - Analyze the distribution of installments (Buy Now, Pay Later behavior).
    - Correlate payment value with the number of installments.
    
Tables used: payments
===============================================================================
*/

-- 1. Payment Method Distribution
-- Goal: Determine which payment channels drive the most volume.
SELECT 
    payment_type, 
    COUNT(order_id) AS total_transactions,
    ROUND(SUM(payment_value), 2) AS total_value
FROM `Project1.payments`
GROUP BY 1
ORDER BY 2 DESC;

/* OUTPUT:
payment_type	total_transactions	total_value
credit_card			76795			12542084.19
UPI					19784			2869361.27
voucher				5775			379436.87
debit_card			1529			217989.79
not_defined			3				0.0
*/ 

/* INSIGHT: 
Credit cards are the undisputed leader, accounting for ~75% of transactions. 
The presence of 'boleto' (voucher/ticket) as a secondary method highlights 
the importance of providing offline-to-online payment options in Brazil.
*/


-- 2. Installment Deep-Dive: Consumer Credit Reliance
-- Goal: Understand how many "slices" customers prefer to pay in.
SELECT 
    payment_installments, 
    COUNT(order_id) AS order_count
FROM `Project1.payments`
WHERE payment_type = 'credit_card'
GROUP BY 1
ORDER BY 1 ASC;

/* OUTPUT:
payment_installments	order_count
0							2
1						25455
2						12413
3						10461
4						7098
5						5239
6						3920
7						1626
8						4268
9						644
10						5328
11						23
12						133
13						16
14						15
15						74
16						5
17						8
18						27
20						17
21						3
22						1
23						1
24						18
*/

/* INSIGHT: 
While 1-installment (full payment) is common, there is a significant "long tail" 
of 10+ installments. This suggests that high-ticket items are heavily 
dependent on credit availability.
*/


-- 3. Average Order Value (AOV) vs. Installments
-- Goal: Does the cost of an item dictate the number of installments?
SELECT 
    payment_installments,
    ROUND(AVG(payment_value), 2) AS avg_payment_value
FROM `Project1.payments`
WHERE payment_type = 'credit_card'
GROUP BY 1
ORDER BY 1;

/* OUTPUT:
payment_installments	avg_payment_value
0							94.31
1							95.87
2							127.23
3							142.54
4							163.98
5							183.47
6							209.85
7							187.67
8							307.74
9							203.44
10							415.09
11							124.93
12							321.68
13							150.46
14							167.96
15							445.55
16							292.69
17							174.6
18							486.48
20							615.8
21							243.7
22							228.71
23							236.48
24							610.05
*/

/* INSIGHT: 
There is a direct positive correlation: as the price of the order increases, 
the number of installments increases. Orders paid in 10 installments are, 
on average, 3x more expensive than those paid in full.
*/


-- Advanced Payments: Localized Payment Dominance
-- Goal: Identify the #1 payment method for each state to guide regional marketing.
WITH StatePaymentVolumes AS (
    SELECT 
        c.customer_state,
        p.payment_type,
        COUNT(p.order_id) AS transaction_count,
        RANK() OVER(PARTITION BY c.customer_state ORDER BY COUNT(p.order_id) DESC) AS local_rank
    FROM `Project1.payments` AS p
    JOIN `Project1.orders` AS o ON p.order_id = o.order_id
    JOIN `Project1.customers` AS c ON o.customer_id = c.customer_id
    GROUP BY 1, 2
)
SELECT 
    customer_state,
    payment_type,
    transaction_count
FROM StatePaymentVolumes
WHERE local_rank = 1
ORDER BY transaction_count DESC;

/* OUTPUT:
customer_state	payment_type	transaction_count
	SP			credit_card			32168
	RJ			credit_card			10288
	MG			credit_card			9070
	RS			credit_card			3985
	PR			credit_card			3786
	SC			credit_card			2713
	BA			credit_card			2662	
	DF			credit_card			1700
	ES			credit_card			1573
	GO			credit_card			1520
	PE			credit_card			1334
	CE			credit_card			1091
	PA			credit_card			728
	MT			credit_card			659
	MA			credit_card			535
	MS			credit_card			519
	PB			credit_card			428
	RN			credit_card			394
	PI			credit_card			389
	AL			credit_card			341
	SE			credit_card			264
	TO			credit_card			197
	RO			credit_card			186
	AM			credit_card			124
	AC			credit_card			61
	AP			credit_card			47
	RR			credit_card			33
*/

/* INSIGHT: 
Using RANK() and PARTITION BY, the audit reveals a 100% regional consensus. 
Credit cards are the #1 payment method in every single Brazilian state (27/27).
In the primary hub of SP, credit transactions outpace the next state (RJ) 
by a 3:1 margin, confirming that platform scalability is fundamentally 
linked to credit card processing and installment availability.
*/