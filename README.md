End-to-end retail data analytics project using Python, SQL and Power BI.

# 🛒 DMart Retail Performance Analysis
### End-to-End Data Analytics Project | Python • SQL • Power BI

![Python](https://img.shields.io/badge/Python-Pandas-blue?logo=python)
![SQL](https://img.shields.io/badge/SQL-Data%20Analysis-orange?logo=postgresql)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow?logo=powerbi)
![Status](https://img.shields.io/badge/Project-Completed-success)

## 📌 Project Overview

This project focuses on analyzing retail sales performance using synthetic DMart assignment datasets. The objective was to transform raw retail data into meaningful business insights through data cleaning, data validation, SQL analysis, and interactive dashboard development.

The project demonstrates an end-to-end data analytics workflow, starting from raw data preprocessing using Python and progressing towards business intelligence reporting using Power BI.

## 🎯 Business Objectives

- Analyze overall retail sales performance.
- Identify top-performing product categories and products.
- Understand sales distribution across different channels.
- Evaluate customer segments and purchasing patterns.
- Analyze geographical sales performance.
- Identify data quality issues and improve data reliability.
- Develop actionable business recommendations.

## 🛠️ Tools & Technologies

| Technology | Application |
|---|---|
| Python | Data cleaning and preprocessing |
| Pandas & NumPy | Data manipulation and validation |
| SQL | Data querying and business analysis |
| Power BI | Interactive dashboard development |
| Excel | Data inspection and quality auditing |
| Jupyter Notebook | Python development environment |

## 📂 Project Structure

```text
dmart-retail-performance-analysis/
│
├── README.md
│
├── python/
│   └── Cleaning_Preprocessing.ipynb
│
├── sql/
│   └── analysis_queries.sql
│
├── data/
│   └── processed/
│       ├── DMart_Transactions_Cleaned.csv
│       ├── DMart_Products_Cleaned.csv
│       ├── DMart_Data_Cleaning_Summary.csv
│       └── DMart_Data_Quality_Issue_Register.csv
│
├── powerbi/
│   └── screenshots/
│
├── reports/
│   └── DMart_Retail_Performance_Analysis_Report.docx
│
├── requirements.txt
└── .gitignore
```

## 🔍 Data Cleaning & Preprocessing

Python and Pandas were used to clean, validate, and prepare the supplied datasets.

### Data Preparation Summary

| Dataset | Original Rows | Processed Rows |
|---|---:|---:|
| Transactions | 15,035 | 15,025 |
| Customers | 3,226 | 3,200 |
| Products | 20 | 20 |

### Key Data Quality Issues Identified

- Missing customer IDs in transaction records.
- Invalid and missing transaction dates.
- Invalid discount rates.
- Negative transaction quantities.
- Non-positive product prices.
- Duplicate records.
- Missing customer attributes, including loyalty tiers.

Data quality issues were documented for transparency rather than silently replacing invalid or missing values.

*Note: Customer-level source files and customer-master exports are intentionally excluded from this public repository.*

## 🗄️ SQL Analysis

SQL queries were prepared to support retail business analysis and data validation.

Key analytical areas include:

- Dataset profiling and record counts.
- Total sales analysis.
- Category-wise sales performance.
- Top-performing products.
- Monthly sales trends.
- Sales channel contribution.
- Transaction status analysis.
- Data quality validation.
- Product relationship checks.

The SQL query pack is available in the `sql/` directory.

## 📊 Power BI Dashboard

The interactive Power BI dashboard provides an overview of retail performance through KPIs, charts, and filters.

### Dashboard Highlights

- Total Sales
- Transaction Lines
- Unique Customers
- Average Sales per Transaction Line
- Estimated Gross Profit
- Category-wise Sales
- Product-wise Sales
- Channel-wise Performance
- State-wise Sales
- Customer Segment Analysis
- Payment Method Analysis

### Dashboard Preview

<!-- Add your actual Power BI dashboard screenshots here -->

![Dashboard Preview](powerbi/screenshots/dashboard_overview.png)

## 📈 Key Business Insights

Based on the supplied assignment dataset and analysis report:

| Business Metric | Result |
|---|---:|
| Total Sales | ₹2.45 Million |
| Transaction Lines | 15,025 |
| Unique Customers | 3,200 |
| Average Sales per Transaction Line | ₹180.37 |
| Top Sales Category | Staples |
| Top Performing Product | Rice 5kg |
| Leading Sales Channel | App |
| Top Performing State | Maharashtra |

### Major Findings

**1. Category Performance**

Staples was the highest-performing product category, generating approximately ₹757K in sales.

**2. Product Performance**

Rice 5kg was the top displayed product, contributing approximately ₹332.83K in sales.

**3. Sales Channel Performance**

The App channel generated approximately ₹837.59K, contributing around 34.16% of total sales.

**4. Geographical Performance**

Maharashtra was the largest state contributor, generating approximately ₹1.07 million in sales.

**5. Customer Segmentation**

Sales across the five named customer segments were relatively similar, with Occasional customers recording the highest displayed sales.

## 💡 Business Recommendations

Based on the analysis, the following recommendations were identified:

1. Monitor inventory availability and replenishment for high-performing categories and products.
2. Evaluate sales channel performance using conversion rates, repeat purchases, and customer satisfaction.
3. Analyze state-level performance alongside store count and active customer information.
4. Develop targeted marketing campaigns for different customer segments.
5. Establish regular data quality monitoring to improve reporting accuracy.

## ⚠️ Project Limitations

- The analysis is based on the supplied synthetic assignment dataset and does not represent independently verified company-wide DMart figures.
- The transaction data is at product-line level; average sales per transaction line should not be interpreted as average order value.
- Estimated gross profit is not net profit and excludes operating expenses.
- The dashboard presents descriptive insights and does not establish causation.

## 🚀 Project Learning Outcomes

Through this project, I gained practical experience in:

- Handling and preprocessing multiple datasets using Python.
- Identifying and documenting data quality issues.
- Writing SQL queries for business analysis.
- Building interactive dashboards using Power BI.
- Translating raw data into actionable business insights.
- Communicating analytical findings through reports and visualizations.

## 👨‍💻 Author

**Yashraj Mohan Bhosale**

Aspiring Data Analyst | Python | SQL | Power BI | Advanced Excel

🎓 Department of Technology, Savitribai Phule Pune University

🔗 **GitHub:** [yashraj1656](https://github.com/yashraj1656)

🔗 **LinkedIn:** [Linkedin](https://www.linkedin.com/in/yashraj-bhosale/)

---

⭐ If you find this project useful, feel free to explore the repository and connect with me!
