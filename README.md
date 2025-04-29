# Atliq Ad-Hoc SQL Project 📊

This project consists of real-world SQL-based ad-hoc business questions for the fictional company **Atliq Hardware**, covering domains such as:
- Product analysis
- Sales and marketing
- Finance and supply chain

## 👨‍💻 Analyst: Abhiram Malepati

## 📁 Project Overview
This project answers 10 business-driven SQL questions such as:
- Which products had the highest and lowest manufacturing cost?
- Which channel contributed the most to gross sales?
- Which customers received the highest pre-invoice discounts?
- Year-over-year product growth by segment, and more...

## 🧠 Skills Applied
- Joins, CTEs, Window Functions
- Aggregations, Grouping, Filtering
- Formatting, Ranking, Percentage calculations

## 📄 Files Included
- `Atliq_adhoc_requests.docx`: All question-wise solutions
- `SQL_Solutions.sql`: (Optional) All queries in one file

## 📌 Sample Query
```sql
SELECT 
  segment, 
  COUNT(DISTINCT product_code) AS product_count
FROM dim_product
GROUP BY segment
ORDER BY product_count DESC;
