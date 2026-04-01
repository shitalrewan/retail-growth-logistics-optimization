**Context:** This particular business case focuses on the operations of Target in Brazil and provides insightful information about 100,000 orders placed between 2016 and 2018. The dataset offers a comprehensive view of various dimensions including the order status, price, payment and freight performance, customer location, product attributes, and customer reviews.

By analyzing this extensive dataset, it becomes possible to gain valuable insights into Target's operations in Brazil. The information can shed light on various aspects of the business, such as order processing, pricing strategies, payment and shipping efficiency, customer demographics, product characteristics, and customer satisfaction levels.

## 📂 Project Structure

```text
retail-growth-logistics-optimization/
├── assets/                  # Key visualizations (Peak hours, etc.)
├── docs/                    # Data architecture & Target dataset schema
├── reports/                 # Executive deliverables & Deep dives
│   ├── ecommerce_analysis_insights.pdf
│   ├── analytics_report.pdf
│   └── project_deep_dive.pdf
├── sql_scripts/             # End-to-end SQL pipeline (01 to 04)
│   ├── 01_eda_base_exploration.sql
│   ├── 02_mart_customer_segmentation.sql
│   ├── 03_fct_logistics_efficiency.sql
│   └── 04_dim_payment_behavior.sql
└── README.md                # Project documentation
```

### 🚀 Key Deliverables

* 📊 **[Executive Summary & Insights (PDF)](reports/ecommerce_analysis_insights.pdf)** — *Strategic business findings and recommendations.*
* 📑 **[Professional Analytics Report (PDF)](reports/analytics_report.pdf)** — *Detailed technical analysis and data methodology.*
* 🔍 **[Technical Deep Dive (PDF)](reports/project_deep_dive.pdf)** — *Extended visualizations and edge-case exploration.*
* 💾 **[SQL Data Pipeline](sql_scripts/)** — *Production-ready scripts for data transformation (01-04).*

### Phase 1: Exploratory Data Analysis (Foundation)
Before performing deep analysis, I conducted a comprehensive audit of the dataset to ensure data quality and integrity.

**Key Technical Achievements:**
* **Schema Validation:** Verified data types for 5+ core tables to ensure financial metrics (FLOAT64) and keys (STRING) were correctly assigned.
* **Integrity Audit:** Confirmed 100% uniqueness for Primary Keys (`customer_id`, `order_id`) and identified data gaps in `payment_type`.
* **Chronological Scope:** Established a 25-month analysis window (2016-2018), verifying a complete 24-hour cycle of business operations.
* **Data Quality:** Confirmed that <1% of records contained illogical delivery dates, ensuring high reliability for logistics metrics.
 
| **Category** | **Technical Implementation** | **Key Business Insight** |
| :--- | :--- | :--- |
| **Data Audit** | `CROSS JOIN UNNEST` with `COUNTIF` logic. | **High Integrity:** 100% population of primary IDs; 2.98% logical nulls in delivery dates identified and validated. |



 ### Phase 2: Growth Trends & Customer Segmentation
Analyzed 100k+ records to map the trajectory of the platform and define the core consumer profile.

| **Category** | **Technical Implementation** | **Key Business Insight** |
| :--- | :--- | :--- |
| **Growth Trends** | `EXTRACT(YEAR/MONTH)` to develop YoY Growth KPIs. | **160x Scale:** Jumped from 329 (2016) to 54k+ (2018) orders. |
| **Geography** | `COUNT(DISTINCT)` with state-level grouping. | **Power Triangle:** 60% of volume is in **SP, RJ, and MG**. |
| **Consumer Rhythm** | `CASE WHEN` logic for diurnal (Time-of-Day) bucketing. | **Night Owls:** 70% of transactions occur in the Afternoon/Night. |

**Strategic Impact**
**Infrastructure:** The massive concentration in the Southeast (SP/RJ/MG) validates the need for localized distribution centers to lower freight costs.

**Operations:** Half of all shopping activity occurs after 19:00, suggesting that high-impact marketing and IT support should be prioritized for the evening window.

| **Category** | **Technical Implementation** | **Key Business Insight** |
| :--- | :--- | :--- |
| **Market Share** | `SUM() OVER()` Window Functions for Pareto Analysis. | **The 80/20 Rule:** 80% of customers are concentrated in just 6 states, confirming high Southeast-South market maturity. |


### Phase 3: Economic Impact & Logistics Performance
* **Goal:** Evaluate the financial health of the platform and the efficiency of the national delivery network.

| **Category** | **Technical Implementation** | **Key Business Insight** |
| :--- | :--- | :--- |
| **Revenue Growth** | `SUM()` & `JOIN` with Jan-Aug date filters. | **52% Revenue Surge:** 2018 outperformed 2017 by over $3.5M in the same 8-month window. |
| **Logistics** | `DATE_DIFF()` to measure Actual vs. Estimated delivery. | **Under-Promise, Over-Deliver:** High safety buffers are used to manage customer expectations effectively. |
| **Shipping Costs** | `AVG()` freight cost aggregated by state. | **The 2.8x Gap:** Freight in the North (RR/PB) is nearly triple the cost of the Southeast (SP). |

| **Category** | **Technical Implementation** | **Key Business Insight** |
| :--- | :--- | :--- |
| **SLA Performance** | `CASE` bucketing & Window Functions for % share. | **76% Healthy Delivery:** Identified that 1 in 4 customers experiences shipping lag, highlighting a clear area for regional optimization. |

### Phase 4: Payment Behavior & Psychology
* **Goal:** Analyze how credit availability and installment plans drive high-ticket sales.

| **Category** | **Technical Implementation** | **Key Business Insight** |
| :--- | :--- | :--- |
| **Payment Mix** | Volume distribution across payment types. | **Credit Dominance:** 75% of all transactions are powered by Credit Cards. |
| **Credit Reliance** | Frequency analysis of `payment_installments`. | **The 10-Slice Trend:** Significant consumer clusters at 1, 5, and 10 installments. |
| **Price Correlation** | `AVG()` value vs. installment count. | **Financing Strategy:** Average Order Value (AOV) triples when 10+ installments are used. |

| **Category** | **Technical Implementation** | **Key Business Insight** |
| :--- | :--- | :--- |
| **Regional Rank** | `CTE` with `RANK() OVER(PARTITION BY)`. | **National Consensus:** Credit cards are the #1 payment method in 100% of states, confirming a unified financial strategy is viable nationwide. |

## ⚙️ SQL Data Pipeline

To ensure a reproducible and modular analysis, I developed a 4-stage SQL pipeline. This approach transforms raw data into structured tables (Marts and Dimensions) for optimized querying.

| Script ID | Module Name | Primary Objective |
| :--- | :--- | :--- |
| **01** | `eda_base_exploration` | Initial data auditing, summary statistics, and identifying missing values. |
| **02** | `mart_customer_seg` | Creating a centralized table for customer behavior and regional distribution. |
| **03** | `fct_logistics_eff` | Calculating shipping lead times, carrier performance, and freight-to-price ratios. |
| **04** | `dim_payment_beh` | Segmenting orders by payment method and analyzing installment trends. |

> **Technical Note:** These scripts are designed to be run sequentially to maintain data integrity and handle dependencies between tables.

### Final Strategic Recommendations
* **Regional Fulfillment:** Establishing "Satelite Warehouses" in the North/Northeast could reduce freight by 30-40% and unlock market share in high-cost states like RR and PB.

* **Payment Optimization:** Since high-ticket items rely on 10+ installments, marketing should prioritize "Interest-Free" messaging for any product over $150.

* **Operational Scheduling:** Shift IT maintenance and marketing deployments to the morning hours to protect the high-traffic "Afternoon/Night" revenue window.

-------------------------------------------------------------------------------------------------------------------------------

## 👤 About the Analyst

**Shital** | *Lead Data Science Instructor & Data Analyst*

With over **7 years of professional experience** in Business and EdTech, Where **1,500+ technical hands-on sessions** conducted globally (USA,UK,Canada,Australia,India), I specialize in bridging the gap between complex technical jargon and strategic business communication. This project demonstrates my dual expertise: high-precision technical implementation in **SQL/BigQuery** and the ability to translate raw data into actionable narratives for non-technical stakeholders.

* 🎓 **Education:** Master of Computer Science (Major in Data Science & Machine Learning)
* 📜 **Certifications:** Microsoft Certified: Power BI Data Analytics Associate (PL-300)
* 🛠️ **Core Strengths:** Workflow Automation, Strategic Data Storytelling, and Project-Based Technical Mentoring.

---
