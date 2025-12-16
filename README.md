# 🏥 Health Clinic SQL Analytics Project

## 📌 Project Overview

This project analyzes **operational, clinical, and financial** data for a health clinic using SQL.

The goal is to extract meaningful insights related to patient care, doctor performance, billing, insurance coverage, and medical trends.

## 🎯 Objectives

- Design a relational healthcare database
- Analyze patient appointments and outcomes
- Evaluate doctor performance and clinic efficiency
- Assess billing and insurance coverage trends
- Identify medical diagnosis patterns
- Prepare data for visualization in Power BI

🛠️ **Tools & Technologies**
- SQL (PostgreSQL syntax)
- Power BI (for dashboard visualization)
- Git & GitHub (for version control and documnetation)

---
## 📥 Data Importation Process

- **Source:** CSV files containing health care records
- **Tool:** Postgresql
- **Steps:**
  1. A PostgreSQL database was created for the health clinic project
  2. Tables were created using CREATE TABLE
  3. Data was imported from CSV files
  4. Checked for consistency and converted to appropriate datatype

 
## 🗂️ Database Schema
The database consists of 6 core tables:

**1. patients**
Stores demographic and insurance information about patients.

| Column             | Description               |
| ------------------ | ------------------------- |
| patient_id         | Unique patient identifier |
| first_name         | Patient first name        |
| last_name          | Patient last name         |
| gender             | Patient gender            |
| date_of_birth      | Date of birth             |
| city               | Patient city              |
| insurance_provider | Insurance provider        |

**2. appointments**
Tracks patient visits to doctors.

| Column           | Description                     |
| ---------------- | ------------------------------- |
| appointment_id   | Unique appointment ID           |
| patient_id       | Linked patient                  |
| doctor_id        | Attending doctor                |
| appointment_date | Visit date                      |
| status           | Completed / No-show / Cancelled |
| visit_reason     | Reason for visit                |


**3. doctor**
Contains doctor and clinic information.

| Column          | Description       |
| --------------- | ----------------- |
| doctor_id       | Doctor ID         |
| doctor_name     | Doctor name       |
| specialty       | Medical specialty |
| clinic_location | Clinic branch     |

**4. diagnosis**
Medical diagnoses assigned during appointments.

| Column                | Description           |
| --------------------- | --------------------- |
| diagnosis_id          | Diagnosis record      |
| appointment_id        | Linked appointment    |
| diagnosis_code        | ICD-10 diagnosis code |
| diagnosis_description | Diagnosis details     |

**5. medications**
Medication prescriptions per patient.

| Column          | Description       |
| --------------- | ----------------- |
| med_id          | Medication ID     |
| patient_id      | Patient           |
| medication_name | Drug name         |
| dosage          | Dosage prescribed |
| start_date      | Start date        |
| end_date        | End date          |

**6. billing**
Financial transactions related to appointments.

| Column            | Description              |
| ----------------- | ------------------------ |
| bill_id           | Billing ID               |
| appointment_id    | Linked appointment       |
| amount            | Total bill               |
| insurance_covered | Amount paid by insurance |
| patient_paid      | Out-of-pocket payment    |


📈 **Business Outcomes:**
- Supports performance evaluation
- Helps in bonus, incentive, or promotion decisions
- Assists in resource allocation and clinic scheduling
- Highlights doctors contributing most to clinic profitability

---

## 🔍 Business Questions & SQL Solutions







.

🚀 Key SQL Concepts Demonstrated

- Inner joins
- Aggregate functions
- CTEs (WITH clauses)
- Window functions
- Date & time analysis
- Conditional logic (CASE)
- Subqueries
- Real-world healthcare analytics

👤 Author

Name: Chihurumnanya Chikaosoro Ikevude
Role: Data Analyst
Skills: SQL | Power BI | Data Analysis
🔗 **LinkedIn:** [linkedin.com/in/YOUR-LINKEDIN-USERNAME](https://www.linkedin.com/in/chihurumnanyaikevude/)








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



