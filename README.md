# 🏥 Health Clinic SQL Analytics Project

## 📌 Project Overview

This project analyzes **operational, clinical, and financial** data for a health clinic using SQL.

The goal is to extract meaningful insights related to patient care, doctor performance, billing, insurance coverage, and medical trends.

This project was completed as part of the **Digital SkillUp Africa (DSA)** Data Analytics training. The analysis focuses on historical sales data from **Kultra Mega Stores (KMS)** — a retail and corporate office supply chain based in Lagos, Nigeria — with operations across various regions from **2009 to 2012**.

KMS management tasked us with deriving **actionable insights** to improve business performance using **structured data analysis** and **SQL queries**. The goal was to understand:

- How different regions, customer segments, and products performed
- Where the company is losing money through shipping or underperforming customers
- What decisions can improve profitability and customer retention

As the **Data Analyst**, I led the end-to-end process:
- Data ingestion using SQL Server Management Studio
- Data cleaning, transformation, and type optimization
- Formulation of real business questions
- Writing SQL queries to extract insights
- Summarizing recommendations to support strategic decision-making

🛠 **Tools Used:**
- SQL Server Management Studio (SSMS)
- Flat File Import Wizard
- Microsoft Excel (for initial data prep)
- GitHub (for version control and documentation)

📈 **Business Outcomes:**
- Identified top- and bottom-performing customer segments and products
- Diagnosed costly shipping patterns and misaligned logistics
- Proposed recommendations for marketing, logistics, and operations teams

---
## 📥 Data Importation Process

- **Source:** CSV file containing order data from 2009–2012.
- **Tool:** SQL Server Management Studio (SSMS) Flat File Import Wizard.
- **Steps:**
  1. Imported the dataset using the SSMS Flat File Import Wizard.
  2. Changed column data types to optimize performance and ensure data consistency:
     - `Sales`, `Profit`, `Discount`, `Shipping_Cost` → `DECIMAL(10,2)`
     - `Quantity`, `Order_ID`, `Product Count` → `INT`
  3. Cleaned column names and removed blank rows.
  4. Verified the import success through sampling and quick queries.

📸 *Screenshots of the import process and outputs are available in the `/images` folder.*

---

## 🔍 Business Questions & SQL Solutions

### 1️⃣ Which product category had the highest number of entries?

```sql
SELECT Product_Category, SUM(Sales) as Total_Sales
FROM KMS_Sql_Case_Study
GROUP BY Product_Category
ORDER BY Total_Sales DESC;
```

### 2️⃣ What are the Top 3 and Bottom 3 regions in terms of sales? 

#### For Top 3 Regions

```sql
SELECT Region, SUM(Sales) as Top_sales
FROM KMS_Sql_Case_Study
GROUP BY Region
ORDER BY Top_sales DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;
```

#### For Bottom 3 Regions
```sql
SELECT REGION, SUM(Sales) as Bottom_sales
FROM KMS_Sql_Case_Study
GROUP BY Region
ORDER BY Bottom_sales 
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;
```

### 3️⃣ What were the total sales of appliances in Ontario? 

```sql
SELECT Region, SUM(Sales) as Ontario_total_sales
FROM KMS_Sql_Case_Study
WHERE Region = 'Ontario'
GROUP BY Region;
```

### 4️⃣ Advise the management of KMS on what to do to increase the revenue from the bottom 10 customers

```sql
SELECT Customer_Name, SUM(Sales) as Customer_bottom_sales
FROM KMS_Sql_Case_Study
GROUP BY Customer_Name
ORDER BY Customer_bottom_sales ASC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
```
KMS management should offer first-time bundle deals or limited-time discounts to encourage higher spend.

### 5️⃣ KMS incurred the most shipping cost using which shipping method? 

```sql
SELECT Ship_Mode, SUM(Shipping_Cost) as High_shipping_cost
FROM KMS_Sql_Case_Study
GROUP BY Ship_Mode
ORDER BY High_shipping_cost DESC;
```

### 6️⃣ Who are the most valuable customers, and what products or services do they typically purchase? 

#### To find top 3 customers.
```sql
SELECT Customer_Name, SUM(Sales) AS Total_Sales
FROM KMS_Sql_Case_Study
GROUP BY Customer_Name
ORDER BY Total_Sales DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;
```

#### To find the products or services they typically purchase

```sql
SELECT Customer_Name, Product_Category, Product_Sub_Category,  SUM(Sales) AS Customer_Total_Spent
FROM KMS_Sql_Case_Study
WHERE 
    Customer_Name IN (
        SELECT TOP 3 Customer_Name
        FROM KMS_Sql_Case_Study
        GROUP BY Customer_Name
        ORDER BY SUM(Sales) DESC
    )
GROUP BY 
    Customer_Name, Product_Category, Product_Sub_Category
ORDER BY 
    Customer_Name, Customer_Total_Spent DESC;
```

### 7️⃣ Which small business customer had the highest sales? 
```sql
SELECT Customer_Name, Customer_Segment, SUM(Sales) as Highest_Small_business
FROM KMS_Sql_Case_Study
WHERE Customer_Segment = 'Small Business'
GROUP BY Customer_Name, Customer_Segment
ORDER BY Highest_Small_business DESC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;
```

### 8️⃣ Which Corporate Customer placed the most number of orders in 2009 – 2012? 

```sql
SELECT Customer_Name, Customer_Segment, COUNT(Order_Quantity) as Highest_Orderby_corporate
FROM KMS_Sql_Case_Study
WHERE Customer_Segment = 'Corporate'
GROUP BY Customer_Name, Customer_Segment
ORDER BY Highest_Orderby_corporate DESC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;
```

### 9️⃣ Which consumer customer was the most profitable one? Ans => Emily Phan

```sql
SELECT Customer_Name, Customer_Segment, SUM(Profit) as Most_Profitable_custumer
FROM KMS_Sql_Case_Study
WHERE Customer_Segment = 'Consumer'
GROUP BY Customer_Name, Customer_Segment
ORDER BY Most_Profitable_custumer DESC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;
```

### 🔟 Which customer returned items, and what segment do they belong to? 

```sql
SELECT k.Customer_Name, k.Customer_Segment, o.Status
From KMS_Sql_Case_Study k
JOIN Order_Status o on k.Order_ID = o.Order_ID
GROUP BY k.Customer_Name, k.Customer_Segment, o.Status;
```

### 1️⃣1️⃣ If the delivery truck is the most economical but the slowest shipping method and Express Air is the fastest but the most expensive one, do you think the company appropriately spent shipping costs based on the Order Priority? Explain your answer

```sql
SELECT 
    Order_Priority,
    Ship_Mode,
    COUNT(Order_ID) AS Total_Orders,
    ROUND(SUM(Sales * Profit),2) AS Total_Shipping_Cost,
    AVG(datediff(day,[order_date],[ship_date])) AS Avg_Shipping_day
FROM 
    KMS_Sql_Case_Study
GROUP BY 
    Order_Priority, Ship_Mode
ORDER BY 
    Order_Priority, Avg_Shipping_day DESC;
```

```sql
SELECT 
    Order_Priority,
    Ship_Mode,
    COUNT(distinct Order_ID) AS Total_Orders,
    ROUND(SUM(Sales * Profit),2) AS Estimated_Shipping_Cost,
    AVG(datediff(day,[order_date],[ship_date])) AS Avg_Shipping_day
FROM 
    KMS_Sql_Case_Study
GROUP BY 
    Order_Priority, Ship_Mode
ORDER BY 
    Order_Priority, Ship_Mode DESC;
```

🧠 **Insight:**  
No, KMS did **not** appropriately align shipping cost with priority.  
- Express Air (best for high-priority orders) was underused.  
- Delivery Truck (slower, cheaper) was overused even for urgent orders.  
- This mismatch results in **wasted cost and delayed deliveries**.

---

## 📈 Summary of Findings

- **Most Sold Category:** Office Supplies  
- **Top Region by Sales:** West  
- **Least Performing Region:** Nunavut or Territories  
- **Most Profitable Segment:** Consumer  
- **Most Costly Shipping Mode:** Express Air  
- **Major Insight:** Misalignment between order priority and shipping method caused unnecessary costs.

---

## 🧠 Skills Demonstrated

- SQL Server T-SQL Querying  
- Flat File Data Import & Cleaning  
- Data Type Conversion & Optimization  
- Real-world BI Question Solving  
- Shipping Strategy Evaluation  
- Customer Value & Profitability Analysis  


