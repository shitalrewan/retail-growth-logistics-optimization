### Phase 1: Exploratory Data Analysis (Foundation)
Before performing deep analysis, I conducted a comprehensive audit of the dataset to ensure data quality and integrity.

**Key Technical Achievements:**
* **Schema Validation:** Verified data types for 5+ core tables to ensure financial metrics (FLOAT64) and keys (STRING) were correctly assigned.
* **Integrity Audit:** Confirmed 100% uniqueness for Primary Keys (`customer_id`, `order_id`) and identified data gaps in `payment_type`.
* **Chronological Scope:** Established a 25-month analysis window (2016-2018), verifying a complete 24-hour cycle of business operations.
* **Data Quality:** Confirmed that <1% of records contained illogical delivery dates, ensuring high reliability for logistics metrics.
 
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