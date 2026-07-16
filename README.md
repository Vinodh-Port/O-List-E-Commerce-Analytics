# O-List E-Commerce Analytics Dashboard

An interactive, multi-page Power BI dashboard designed to analyze sales performance, optimize logistics operations, and evaluate customer-seller segmentations. This project showcases end-to-end data analytics—transforming raw transaction data into actionable business insights using star-schema modeling, advanced DAX, and SQL logic.

---

## 📊 Dashboard Pages & Insights

The dashboard is structured into three specialized views, connected seamlessly through interactive **Page Navigation** buttons:

### 1. Sales & Revenue View
* **Key Performance Indicators (KPIs):**
  * **Total Revenue:** $13.59M
  * **Average Order Value (AOV):** $136.69
  * **Total Orders:** 99K
  * **Total Items Sold:** 33K
  * **Total Customers:** 96K
  * **Total Sellers:** 3K
* **Revenue Growth Trend:** Strong YoY expansion, growing from **$49.79K (2016)** to **$6,155.81K (2017)** and reaching **$7,386.05K (2018)**.
* **Top Product Categories by Revenue:** Led by *beleza saude* ($1.3M) and *relogios presentes* ($1.2M), followed closely by *cama mesa banho* ($1.0M) and *esporte lazer* ($1.0M).
* **Payment Methods:** Highly dominated by **Credit Cards** driving **$12.54M (78.35%)** of total sales, with **Boleto** coming in second at **$2.87M (17.92%)**.
* **Regional Performance:** **SP (São Paulo)** is the ultimate sales powerhouse, bringing in **$8,753.4K** in revenue—far surpassing PR ($1,261.89K) and MG ($1,011.56K).

### 2. Operations & Logistics View
* **Key Performance Indicators (KPIs):**
  * **Average Delivery Days:** 12.50 Days
  * **Average Freight Cost:** $19.99
  * **Delayed Orders:** 8K
  * **On-Time Delivery Rate:** 92.13%
  * **Shipping Weight:** 75M
* **Logistics Efficiency:** Successfully reduced average delivery times over three years, dropping from **19.7 days (2016)** to **13.0 days (2017)**, and down to **12.1 days (2018)**.
* **Geographical Delivery Gaps:** Highlighted massive shipping delays in remote regions, with **RR** taking an average of **29 days**, **AP** taking **27 days**, and **AM** taking **26 days**—contrasting with **RS** which averages only **15 days**.
* **Order Status Breakdown:** Highly efficient completion cycle with **96.48K Delivered** orders, **1.11K Shipped**, and **0.63K Canceled** orders.
* **Freight Cost Disparities:** Sellers in **RO ($51)** and **CE ($46)** face the highest average freight costs, while **SP ($18)** maintains the lowest.

### 3. Customer Value & Segments (Marketing View)
* **Key Performance Indicators (KPIs):**
  * **Total Customers:** 96K
  * **Total Orders:** 99K
  * **Total State Sellers:** 3K
* **Customer & Seller Footprint:** 
  * **SP** state holds the highest density of both customers (**40K**) and registered sellers (**1,849**).
  * **RJ** (**12K customers**, **171 sellers**) and **MG** (**11K customers**, **244 sellers**) represent secondary high-volume markets.
* **Order Value Buckets (Revenue Segmentation):**
  * **Medium Value Orders:** Generates **$6,364.94K (46.83%)** of revenue.
  * **High Value Orders:** Generates **$6,005.24K (44.18%)** of revenue.
  * **Low Value Orders:** Generates **$1,221.47K (8.99%)** of revenue.
  * *Insight: Medium and High-value segments combined fuel over 91% of the total revenue flow.*
* **Top 10 Products by Sales Volume:** *cama mesa banho* leads with **3.0K items sold**, followed by *esporte lazer* (**2.9K**), and *moveis decoracao* (**2.7K**).

---

## 🛠️ Technical Implementation

* **Data Modeling:** Built a clean Star Schema linking factual transaction tables with geographic and product dimension tables.
* **SQL to DAX Transition:** Ported logical segmentations (originally formulated using SQL `CASE WHEN` and conditional aggregation scripts) into highly dynamic calculated columns and measures.
* **UX/UI Best Practices:** Applied a cohesive, color-coordinated palette, consistent container structures, and custom action-based Page Navigation buttons to provide an effortless end-user experience.
