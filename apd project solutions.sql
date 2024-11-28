select * from walmart`
### Generic Questions
1.	How many distinct cities are present in the dataset?
select
	distinct(city)
From
	walmart
--The dataset consist of three city which are	Naypyitaw,Yangon and Mandalay
			
2.	In which city is each branch situated?
select
	distinct(branch),
	city
From
	walmart
--Yangon represent branch A, Mandalay represent branch B and Naypyitaw represent branch C  

### Product Analysis
1.	How many distinct product lines are there in the dataset?
select
	distinct(product_line)
from
	walmart
-- the product line are six namely Fashion accessories, Health and Beauty, Electronic accessories, Food and Beverages,
Sports and Travel, Home and Lifestyle.
2.	What is the most common payment method?
Select
	payment,
	count(payment)
from	
	walmart
	group by 
		payment
Order by
	payment desc
--E_wallet is the most common payment method

3.	What is the most selling product line?
select
	product_line,
	sum(cogs) as Cost_Of_Goods_Sold
from
	walmart
group by
	product_line
order by
	product_line desc
--	Sport and travel are the most selling product line with total sum of 52497.90


4.	What is the total revenue by month?
select
	month(date) as Month_Number,
	sum(gross_income) as Total_revenue
from
	walmart
group by
	month(date)
order by 
	sum(gross_income) desc
--The highest revenue was archived in january 2019 
	
5.	Which month recorded the highest Cost of Goods Sold (COGS)?
select
	month(date) as Month_Number,
	sum(cogs) as Total_Goods_Sold
from
	walmart
group by
	month(date)
order by 
	sum(cogs) desc
-- january has the hishest cost of goods sold

6.	Which product line generated the highest revenue?
select
	product_line,
	sum(gross_income) as TOtal_revenue
from
	walmart
group by
	product_line
--fashion accessories as the highest revenue which is 2585.99
7.	Which city has the highest revenue?
select
	city,
	sum(gross_income) as Total_revenue
from
	walmart
group by
	city
--Naypyitaw is the city with the highest revenue
8.	Which product line incurred the highest VAT?
select 
	product_line,
	sum(tax_5) as VAT
from
	walmart
group by
	product_line
order by
	product_line desc
--Sports and Travels has the highest value tax

9.	Retrieve each product line and add a column product_category, indicating 'Good' or 'Bad,' based on whether its sales are above the average.
select 
	product_line,
	sum(total),
case
	when sum(total) > (select AVG(total) from walmart) then 'good'
	else 'bad' end as product_category
from
	walmart
group by
	product_line
--all the product are Good
10.	Which branch sold more products than average product sold?
with avgtotal as(
	select avg(cogs) as Average_product_Sold
from
	walmart
)
select 
	string_agg(branch,',') as Branches,
	count(branch) as Total_Branches,
	sum(total) as Total
from
	walmart
where
	cogs > (select average_product_sold from avgtotal)
group by
	branch
--Branch C sold mpore products

11.	What is the most common product line by gender?
WITH ProductLineByGender AS (
	SELECT 
        Gender,
        Product_Line,
        SUM(total) AS Total_Sold
    FROM walmart
    GROUP BY Gender, Product_Line
),
MostCommonProductLine AS (
    SELECT 
        Gender,
        Product_Line,
        Total_Sold,
        RANK() OVER (PARTITION BY Gender ORDER BY Total_Sold DESC) AS Rank
    FROM ProductLineByGender
)
SELECT 
    Gender, 
    Product_Line AS Most_Common_Product_Line, 
    Total_Sold
FROM MostCommonProductLine
WHERE Rank = 1;
--female has the most common product line which is Health and Beauty

12.	What is the average rating of each product line?
select
	product_line,
	avg(rating) as AvgRating
from
	walmart
group by
	product_line
-- the average rating for each product are as follows; Fashion accessories=7.03, Health and beauty=7.0, Electronic accessories=6.92,
--Food and beverages=7.1, Sports and travel=6.91, Home and lifestyle=6.83

### Sales Analysis
1.	Number of sales made in each time of the day per weekday
SELECT 
    CASE 
        WHEN time BETWEEN 0 AND 5 THEN 'Night (12 AM - 5 AM)'
        WHEN time BETWEEN 6 AND 11 THEN 'Morning (6 AM - 11 AM)'
        WHEN time BETWEEN 12 AND 17 THEN 'Afternoon (12 PM - 5 PM)'
        WHEN time BETWEEN 18 AND 23 THEN 'Evening (6 PM - 11 PM)'
    END AS time_of_day,
    date AS day_of_week,
    SUM(total) AS total_sales
FROM walmart
GROUP BY 
    time, date
ORDER BY 
    date, time;

2.	Identify the customer type that generates the highest revenue.
select
	customer_type,
	sum(gross_income) as Revenue
from 
	walmart
group by
	customer_type
order by
	sum(gross_income) desc
--member are the customers that generated the highest revenue
3.	Which city has the largest tax percent/ VAT (Value Added Tax)?
select
	city,
	SUM(tax_5) as Vat
from	
	walmart
GROUP by
	city
order by
	SUM(tax_5) desc
--Naypyitaw has the highest Value added tax 
	
4.	Which customer type pays the most VAT?
select
	customer_type,
	SUM(tax_5) as VAT
from	
	walmart
GROUP by
	customer_type
order by
	SUM(tax_5) desc
---	Member are the customer type that pays the most Vat

### Customer Analysis
1.	How many unique customer types does the data have?
SELECT	
	distinct(customer_type)
from	
	walmart
--we have tw customer type which are Normal and Member
2.	How many unique payment methods does the data have?
select
	distinct(payment)
from
	walmart
--we have three payment methgods which are E-wallet, Cash and Credit card
3.	Which is the most common customer type?
select
	distinct(customer_type) as customer_type,
	COUNT(customer_type) as count
from
	walmart
group by
	customer_type
--Member is the most common customer type 
4.	Which customer type buys the most?
select	
	distinct(customer_type),
	SUM(cogs) as Sales
from
	walmart
group by
	customer_type
order by
	customer_type desc
--Normal customer type buys the most

5.	What is the gender of most of the customers?
WITH Gender AS (
select
	distinct(customer_type),
	COUNT(gender) as Gender_count
from	
	walmart
GROUP by
	customer_type,
	gender
)
select
	distinct(gender) as gender
from
	walmart
--
6.	What is the gender distribution per branch?
select 
	distinct(branch),
	gender As Gender
from
	walmart
group by
	branch,gender

7.	Which time of the day do customers give most ratings?
select
	distinct(TIME),
	SUM(rating) as Rating
from	
	walmart
GROUp by
	time
8.	Which time of the day do customers give most ratings per branch?
9.	Which day of the week has the best avg ratings?
WITH date AS (
select
	day(date),
	AVG(rating) as rating
from
	walmart
group by
	DAY(date)
)
select
	MONTH(date) as month
from
	walmart
group by
	MONTH(date)
)

10.	Which day of the week has the best average ratings per branch?

