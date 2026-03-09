### Phase 1: Exploratory Data Analysis (Foundation)
Before performing deep analysis, I conducted a comprehensive audit of the dataset to ensure data quality and integrity.

**Key Technical Achievements:**
* **Schema Validation:** Verified data types for 5+ core tables to ensure financial metrics (FLOAT64) and keys (STRING) were correctly assigned.
* **Integrity Audit:** Confirmed 100% uniqueness for Primary Keys (`customer_id`, `order_id`) and identified data gaps in `payment_type`.
* **Chronological Scope:** Established a 25-month analysis window (2016-2018), verifying a complete 24-hour cycle of business operations.
* **Data Quality:** Confirmed that <1% of records contained illogical delivery dates, ensuring high reliability for logistics metrics.
 