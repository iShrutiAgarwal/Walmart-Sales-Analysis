-- Walmart project queries

SELECT * FROM walmart_db.walmart;
USE walmart_db;
SELECT payment_method, COUNT(*)
FROM walmart
GROUP BY payment_method;

SELECT COUNT(DISTINCT Branch) FROM walmart; #100
DROP TABLE walmart;
SHOW TABLES;

SELECT MAX(quantity) FROM walmart; #10
SELECT MIN(quantity) FROM walmart; #1

-- Business Problems :

-- Q-1 Which city generates the highest average total price?
SELECT
      city,
      AVG(total_price) AS highest_avg_trans
FROM walmart
GROUP BY city
ORDER BY AVG(total_price) DESC
LIMIT 1;

-- Q-2 Find different payment methods and number of transactions, number of qty sold for each of them
SELECT 
       payment_method, 
       COUNT(*) AS no_payments, 
       SUM(quantity) AS no_qty_sold
FROM walmart
GROUP BY payment_method;

-- Q-3 Determine the most common payment_method for each branch.
-- Display the branch and the preferred_payment_method.
WITH cte AS 
(SELECT 
      branch,
      payment_method AS preferred_payment_method,
      COUNT(*) AS total_transactions,
      RANK() OVER(PARTITION BY BRANCH ORDER BY COUNT(payment_method) DESC) AS ranking
 FROM walmart
 GROUP BY branch, payment_method
 ORDER BY branch
)
SELECT * FROM cte
WHERE ranking = 1;

-- Q-4 Find the top 3 best-selling categories by total revenue in each branch.
WITH category_rev AS
(SELECT
      branch,
      category,
      SUM(total_price) AS revenue,
      RANK() OVER(PARTITION BY branch ORDER BY SUM(total_price) DESC) AS ranking
FROM walmart
GROUP BY branch, category
order by branch
)
SELECT * FROM category_rev
WHERE ranking <= 3;

-- Q-5 Which branch has the highest average profit margin across all categories?
SELECT 
      branch,
      category,
      ROUND(AVG(profit_margin), 2) AS avg_profit_margin
FROM walmart
GROUP BY branch, category
ORDER BY avg_profit_margin DESC
LIMIT 1;

-- Q-6 Find months with the highest and lowest total sales revenue
(SELECT
      'highest' AS revenue_type,
      MONTHNAME(STR_TO_DATE(date, '%d/%m/%y')) AS month,
      SUM(total_price) AS total_rev
FROM walmart
GROUP BY month
ORDER BY total_rev DESC 
LIMIT 1
) 
UNION ALL
(SELECT
	  'lowest' AS reveneue_type,
      MONTHNAME(STR_TO_DATE(date, '%d/%m/%y')) AS month,
      SUM(total_price) AS total_rev
FROM walmart
GROUP BY month
ORDER BY total_rev ASC 
LIMIT 1
);

-- Q-7 Find categories along with their average ratings.
SELECT 
      category,
      ROUND(AVG(rating), 2) AS avg_rating
FROM walmart
GROUP BY category;

-- Q-8 Determine the average, minimum and maximum rating of category for each city.
-- List the city, avg_rating, min_rating and max_rating.
SELECT 
      city,
      category,
      AVG(rating) AS avg_rating,
      MIN(rating) AS min_rating,
      MAX(rating) AS max_rating
FROM walmart
GROUP BY city, category
ORDER BY city ASC;

-- Q-9 What is the most popular product category in each city based on quantity sold?
WITH category_quant AS
(SELECT
      city,
      category,
      SUM(quantity),
      RANK() OVER(PARTITION BY city ORDER BY SUM(quantity) DESC) AS ranking
FROM walmart
GROUP BY city, category
) 
SELECT * FROM category_quant
WHERE ranking = 1;

-- Q-10 Identify the highest-rated category in each branch, displaying the branch, category
-- and the AVG rating
SELECT * 
FROM
(      SELECT 
            branch,
            category,
            AVG(rating) AS avg_rating,
            RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS ranking
      FROM walmart
      GROUP BY branch, category
) AS ranked_categories
WHERE ranking = 1;

-- Q-11 Find the top 5 most expensive categories based on average unit price.
SELECT 
      category,
      ROUND(AVG(unit_price), 2) AS avg_unit_price
FROM walmart
GROUP BY category
ORDER BY avg_unit_price DESC
LIMIT 5;

-- Q-12 Which category has the highest quantity sold but lowest profit margin? 
SELECT 
      category,
      SUM(quantity) AS quantity_sold,
      SUM(profit_margin) AS profit_margin
FROM walmart
GROUP BY category;

-- Q-13 Find categories where total quantity sold exceeds the average quantity sold across all categories.
SELECT 
    category,
    SUM(quantity) AS total_quantity_sold,
    ROUND((
        SELECT AVG(total_qty)
        FROM (
            SELECT SUM(quantity) AS total_qty
            FROM walmart
            GROUP BY category
        ) AS category_totals
    ), 2) AS avg_quantity_benchmark
FROM walmart
GROUP BY category
HAVING SUM(quantity) > (
    SELECT AVG(total_qty)
    FROM (
        SELECT SUM(quantity) AS total_qty
        FROM walmart
        GROUP BY category
    ) AS category_totals
)
ORDER BY total_quantity_sold DESC;

-- Q-14 Which day of the week generates the highest total revenue across all branches?
SELECT 
      DAYNAME(STR_TO_DATE(date, '%d/%m/%y')) AS day_name,
      ROUND(SUM(total_price), 2) AS total_revenue
FROM walmart
GROUP BY day_name
ORDER BY day_name DESC
LIMIT 1;

-- Q-15 Identify the 5 branches with the highest descrease ratio in revenue compared to the 
-- last year(current year 2023 and last year 2022)
-- revenue_decrease_ratio == (last_rev - cr_rev)/last_rev * 100 

WITH 
revenue_2022 AS
(SELECT 
      branch,
      SUM(total_price) AS revenue
FROM walmart
WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2022
GROUP BY branch
),
revenue_2023 AS
(SELECT 
      branch,
      SUM(total_price) AS revenue
FROM walmart
WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2023
GROUP BY branch
)
SELECT 
      ls.branch, 
      ls.revenue AS last_year_rev, 
      cr.revenue AS current_year_rev,
      ROUND(((ls.revenue-cr.revenue)/ls.revenue * 100),2) AS rev_dec_ratio
FROM revenue_2022 AS ls
JOIN
revenue_2023 AS cr
ON ls.branch = cr.branch
WHERE ls.revenue > cr.revenue
ORDER BY rev_dec_ratio DESC
LIMIT 5;

-- Q-16 Find the month-over-month revenue growth for each branch
WITH monthly_revenue AS (
    SELECT 
        branch,
        MONTH(STR_TO_DATE(date, '%d/%m/%Y')) AS month_number,
        MONTHNAME(STR_TO_DATE(date, '%d/%m/%Y')) AS month_name,
        ROUND(SUM(total_price), 2) AS total_revenue
    FROM walmart
    GROUP BY branch, month_number, month_name
),
revenue_with_prev AS (
    SELECT 
        branch,
        month_number,
        month_name,
        total_revenue,
        LAG(total_revenue) OVER (
            PARTITION BY branch 
            ORDER BY month_number
        ) AS prev_month_revenue
    FROM monthly_revenue
)
SELECT 
    branch,
    month_name,
    total_revenue AS current_revenue,
    prev_month_revenue,
    ROUND(
        ((total_revenue - prev_month_revenue) / prev_month_revenue) * 100
    , 2) AS growth_percentage
FROM revenue_with_prev
ORDER BY branch, month_number;

-- Q-17 Categorize sales into 3 groups MORNING, AFTERNOON, EVENING.
-- Find out the number of invoices for each shift ih a branch.
SELECT
	  branch,
      CASE 
           WHEN HOUR(str_to_date(time, '%H:%i:%s')) < 12 THEN 'Morning'
           WHEN HOUR(str_to_date(time, '%H:%i:%s')) BETWEEN 12 AND 17 THEN 'Afternoon'
           ELSE 'Evening'
	  END shift,
      COUNT(*) AS no_of_invoices
FROM walmart
GROUP BY shift, branch
ORDER BY branch ASC, no_of_invoices DESC;

-- Q-18 Identify the busiest day for each branch based on the number of transcations

SELECT * 
FROM
(SELECT
      branch,
      DAYNAME(STR_TO_DATE(date, '%d/%m/%y')) AS day_name,
      COUNT(*) AS no_transactions,
      RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS ranking
 FROM walmart
 GROUP BY branch, day_name
 ORDER BY branch ASC , no_transactions DESC
) AS day_transactions
WHERE ranking = 1;

 -- Q-19 Calculate the total profit and total revenue for each category by considering total_profit as 
-- (unit_price * quantity * profit_margin).
-- List category and total_profit ordered from highest to lowest profit.
SELECT 
      category,
      SUM(total_price) AS revenue,
      SUM(total_price * profit_margin) AS total_profit
FROM walmart
GROUP BY category
ORDER BY total_profit DESC;
 
-- Q-20 Find branches where total profit exceeds the overall average profit
SELECT 
	 branch,
     ROUND(SUM(profit_margin), 2) AS total_profit
FROM walmart
GROUP BY branch
HAVING total_profit > (AVG(profit_margin))
ORDER BY branch;

-- Q-21 Rank all branches by total profit using window functions 
SELECT
      RANK() OVER(ORDER BY ROUND(SUM(profit_margin), 2) DESC) AS ranking,
	  branch,
      ROUND(SUM(profit_margin), 2) AS total_profit
FROM walmart
GROUP BY branch
ORDER BY ranking, branch;

-- Q-22 Find invoices where the total price is significantly higher than the average 
SELECT
      invoice_id,
      ROUND(total_price, 2) AS total_price
FROM walmart
WHERE total_price > (
     SELECT AVG(total_price) 
     FROM walmart );
     
-- Q-23 Which branch has the highest number of transactions with rating below 5?
WITH low_rated_trans AS
(SELECT 
      branch,
      COUNT(*) AS no_of_transactions
FROM walmart
WHERE rating < 5
GROUP BY branch
),
max_trans AS
( SELECT MAX(no_of_transactions) AS max_transactions
  FROM low_rated_trans
)
SELECT 
      branch,
      no_of_transactions
FROM low_rated_trans
WHERE no_of_transactions IN ( SELECT max_transactions FROM max_trans )
ORDER BY branch;

-- Q-24 Which categories have high quantity sold in only one specific city but not others?
WITH city_category_sales AS (
    SELECT 
        category,
        city,
        SUM(quantity) AS total_quantity
    FROM walmart
    GROUP BY category, city
),
ranked_categories AS (
    SELECT 
        category,
        city,
        total_quantity,
        RANK() OVER (
            PARTITION BY category 
            ORDER BY total_quantity DESC
        ) AS city_rank,
        COUNT(city) OVER (
            PARTITION BY category
        ) AS total_cities
    FROM city_category_sales
)
SELECT 
    category,
    city AS dominant_city,
    total_quantity
FROM ranked_categories
WHERE city_rank = 1
AND total_quantity > (
    SELECT AVG(total_quantity) * 2
    FROM city_category_sales ccs
    WHERE ccs.category = ranked_categories.category
    AND ccs.city != ranked_categories.city
)
ORDER BY total_quantity DESC;