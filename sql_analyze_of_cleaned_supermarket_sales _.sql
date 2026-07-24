create table cleaned_supermarket_sales (
    Sales_ID VARCHAR(200),
    Sales_Date DATE,
    Custumer_Name VARCHAR(200),
    Product VARCHAR(200),
    Category VARCHAR(200),
    Quantity numeric(10,1),
    Unit_Price numeric(10,2),
    Payment_Method VARCHAR(200)
)

select * from cleaned_supermarket_sales;


CREATE VIEW toptenselling_products AS
SELECT
Product,
sum(Quantity) total_sold
FROM cleaned_supermarket_sales
GROUP BY product
ORDER BY total_sold DESC
LIMIT 10;

SELECT * FROM toptenselling_products;


CREATE VIEW daily_sales_trend AS
SELECT
Sales_Date,
sum(Total) as daily_Sales
FROM cleaned_supermarket_sales
WHERE sales_date is not NULL
GROUP BY sales_Date
ORDER BY sales_date

select * from daily_sales_trend;



create VIEW sales_by_payment_method as
select
Payment_Method,
sum(total) as total_sales
from cleaned_supermarket_sales
Group by Payment_Method
ORDER by total_sales DESC

select* from sales_by_payment_method


create VIEW topfive_customer_by_spending as
select
Custumer_Name,
sum(total) as total_spending
from cleaned_supermarket_sales
Group by Custumer_Name
ORDER by total_spending DESC
LIMIT 5;

select * from topfive_customer_by_spending;


create VIEW monthly_sales as
select 
EXTRACT(month from sales_Date) as monthn,
sum(total) as monthly_sales
from cleaned_supermarket_sales
Group by monthn
ORDER by monthn

select * from monthly_sales
where monthn is not null;


create VIEW highest_revenue_product as
select
product,
sum(total) as highest_reve_by_product
from cleaned_supermarket_sales
group by product
ORDER by highest_reve_by_product DESC
LIMIT 1;

select * from highest_revenue_product;




