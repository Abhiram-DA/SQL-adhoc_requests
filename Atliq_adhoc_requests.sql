#1.Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.
 
 select distinct(market) 
 from dim_customer 
 where customer = "Atliq Exclusive" and region = "APAC";
 
 #2. What is the percentage of unique product increase in 2021 vs. 2020? 
 # The final output contains these fields, unique_products_2020 unique_products_2021 percentage_chg
 with unique_products_2021 as (
 select count(distinct(product_code)) as unique_products_2021  from fact_sales_monthly where fiscal_year = 2021),
 unique_products_2020 as(
 select count(distinct(product_code)) as unique_products_2020  from fact_sales_monthly where fiscal_year = 2020)
 select *,((unique_products_2021 -unique_products_2020)/unique_products_2020)*100 as percentage_chg from unique_products_2021,unique_products_2020
 ;
 
 #3. Provide a report with all the unique product counts for each segment and sort them in descending order of product counts. 
 # The final output contains 2 fields,segment product_count
 
 select 
 segment,
 count(distinct(product)) as product_count
 from dim_product
 group by segment
 order by product_count;

-- 4. Follow-up: Which segment had the most increase in unique products in 2021 vs 2020? 
-- The final output contains these fields, segment product_count_2020 product_count_2021 difference
 with product_count_2021 as (
 select 
	 p.segment,
	 count(distinct(product)) as product_count_2021
 from dim_product p
 join fact_sales_monthly s
 on p.product_code=s.product_code
 where s.fiscal_year = 2021
 group by segment
 order by product_count_2021),
 product_count_2020 as (
 select 
 p.segment,
 count(distinct(product)) as product_count_2020
 from dim_product p
 join fact_sales_monthly s
 on p.product_code=s.product_code
 where s.fiscal_year = 2020
 group by segment
 order by product_count_2020)
 
 select
 p21.segment,
 p21.product_count_2021,
 p20.product_count_2020,
 (p21.product_count_2021-p20.product_count_2020) as difference
 from product_count_2021 p21
 join product_count_2020 p20 
 on p21.segment=p20.segment;
 
-- 5. Get the products that have the highest and lowest manufacturing costs.
-- The final output should contain these fields, product_code product manufacturing_cost
with max_cost as ( 
select  
product_code,
max(manufacturing_cost) as manufacturing_cost
from fact_manufacturing_cost),
min_cost as ( 
select  
product_code,
min(manufacturing_cost) as manufacturing_cost
from fact_manufacturing_cost)
select * from max_cost
union
select * from min_cost;

-- 6. Generate a report which contains the top 5 customers 
-- who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market. 
-- The final output contains these fields, customer_code customer average_discount_percentage
select 
pi.customer_code,
c.customer,
avg(pi.pre_invoice_discount_pct) as average_discount_percentage
from fact_pre_invoice_deductions pi
join dim_customer c
on pi.customer_code = c.customer_code
where 
pi.fiscal_year = 2021
and c.market = "India"
group by pi.customer_code,c.customer_code
order by average_discount_percentage desc
limit 5;

-- 7. Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month .
-- This analysis helps to get an idea of low and high-performing months and take strategic decisions.
-- The final report contains these columns: Month Year Gross sales Amount


select 
month(date_add(`date` , interval 4 month)) as month,
fiscal_year,
sum(gross_sales) as gross_sales
from gross_sales 
where customer = "Atliq Exclusive"
group by fiscal_year,month;

-- 8. In which quarter of 2020, got the maximum total_sold_quantity? 
-- The final output contains these fields sorted by the total_sold_quantity, Quarter total_sold_quantity


select 
get_fiscal_qtr(date) as Quarter,
sum(sold_quantity) as total_sold_quantity
from fact_sales_monthly
where fiscal_year = 2020
group by Quarter
order by total_sold_quantity desc;

-- 9. Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution? 
-- The final output contains these fields, channel gross_sales_mln percentage

with gs as(
select 
c.channel,
round(sum(s.sold_quantity*g.gross_price)/1000000,2) as gross_sales_mln
from dim_customer c
join fact_sales_monthly s using(customer_code)
join fact_gross_price g using(product_code)
where s.fiscal_year = 2021
group by c.channel)
select 
channel,
gross_sales_mln,
round((gross_sales_mln/(select sum(gross_sales_mln) from gs))*100,2) as percentage
from gs
order by gross_sales_mln desc;

-- 10.Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021? 
-- The final output contains these fields, division product_code product total_sold_quantity rank_order

select * from dim_product;
with sd as(
select 
p.division,
p.product_code,
p.product,
format(sum(sold_quantity),0)as total_sold_quantity,
dense_rank() over(partition by division order by sum(sold_quantity) desc) as rank_order
from dim_product p
join fact_sales_monthly s
using (product_code)
where fiscal_year = 2021
group by p.product_code)
select
*
from sd
where rank_order <= 3 ;