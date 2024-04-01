USE croma_analysis;

# Return the Cust ID that received the 5th highest number of campaigns for the entire duration (using only the campaign data)
SELECT CustID FROM (
SELECT CustID, COUNT(CustID) as No_of_Campaigns,
DENSE_RANK() OVER (ORDER BY COUNT(CustID) DESC) as Rank_Campaign
FROM campaign_data
GROUP BY CustID
ORDER BY No_of_Campaigns DESC) as tbl_rank
WHERE Rank_Campaign = 5;

# Find the States for which the average time of delivery from Sale Timestamp to Delivered Timestamp is the minimum and the maximum respectively.
# Use the Delivery data for this and only those records for which Sale Timestamp, Delivery Timestamp and Ship to State – all variables are populated. 

# Maximum Andaman And Nicobar Islands	12489 minutes = - 208.15 hrs
WITH data_table as (SELECT shiptostate as State, TIMESTAMPDIFF(MINUTE, STR_TO_DATE(sale_timestamp,"%d-%m-%Y %H:%i"), STR_TO_DATE(delivered_timestamp,"%d-%m-%Y %H:%i")) as TimeDelta
FROM delivery_analysis
GROUP BY State)
SELECT State, ROUND(TimeDelta/60,2) as Hours FROM data_table
WHERE TimeDelta = (SELECT MAX(TimeDelta) FROM data_table);

# Minimum - Jammu And Kashmir	212 minutes = 3.53 hrs
WITH data_table as (SELECT shiptostate as State, TIMESTAMPDIFF(MINUTE, STR_TO_DATE(sale_timestamp,"%d-%m-%Y %H:%i"), STR_TO_DATE(delivered_timestamp,"%d-%m-%Y %H:%i")) as TimeDelta
FROM delivery_analysis
GROUP BY State)
SELECT State, ROUND(TimeDelta/60,2) as Hours FROM data_table
WHERE TimeDelta = (SELECT MIN(TimeDelta) FROM data_table);

# Create a dataset of customer ids whose monthly transaction amount has increased every month for at least 3 consecutive months. 
SELECT * FROM customer_transaction_data LIMIT 100;

SELECT CustID, ROUND(SUM(SaleValue),2) as Sales,
MONTHNAME(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Month, YEAR(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Year
FROM customer_transaction_data
GROUP BY CustID
LIMIT 100;

SELECT CustID, ROUND(SUM(SaleValue),2) as Sales,
MONTHNAME(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Month_Ordered,
YEAR(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Year_Ordered
FROM customer_transaction_data
GROUP BY CustID, Year_Ordered, Month_Ordered
LIMIT 100;

SELECT CustID, ROUND(SUM(SaleValue),2) as Sales,
MONTHNAME(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Month_Ordered,
YEAR(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Year_Ordered
FROM customer_transaction_data
GROUP BY CustID, Year_Ordered, Month_Ordered
-- HAVING Count(CustID)>=3 -- 714411 vs 178249
ORDER BY CustID, Year_Ordered, MONTH(STR_TO_DATE(OrderDate,"%Y-%m-%d"));

WITH cust_monthly_transaction as (SELECT CustID, ROUND(SUM(SaleValue),2) as Sales,
MONTHNAME(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Month_Ordered,
YEAR(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Year_Ordered
FROM customer_transaction_data
GROUP BY CustID, Year_Ordered, Month_Ordered
)
SELECT CustID, Sales, Month_Ordered, Year_Ordered
FROM cust_monthly_transaction
HAVING COUNT(Month_Ordered)>=3
ORDER BY CustID;


# 11111J11RREFG1VoGo1FejtGEVV88JtM
# 1111tMeEFtGAAFA11j1Vet111VJ1MtFM
# 1118jEVVjee8FJF118JAARt8Ejoj1toj
# checking something

SELECT CustID, ROUND(SUM(SaleValue),2) as Sales,
YEAR(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Year_Ordered,
MONTHNAME(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Month_Ordered
FROM customer_transaction_data
GROUP BY CustID, Year_Ordered, Month_Ordered
HAVING COUNT(CustID)>=3
ORDER BY CustID, Year_Ordered, MONTH(STR_TO_DATE(OrderDate,"%Y-%m-%d"));

-- dense rank not as good
SELECT *, DENSE_RANK() OVER(ORDER BY CustID) as r_number
FROM (SELECT CustID, ROUND(SUM(SaleValue),2) as Sales,
YEAR(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Year_Ordered,
MONTHNAME(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Month_Ordered
FROM customer_transaction_data
GROUP BY CustID, Year_Ordered, Month_Ordered
ORDER BY CustID, Year_Ordered, MONTH(STR_TO_DATE(OrderDate,"%Y-%m-%d"))) X;
----
SELECT *, DENSE_RANK() OVER(ORDER BY CustID) as r_number
FROM (SELECT CustID, ROUND(SUM(SaleValue),2) as Sales,
YEAR(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Year_Ordered,
MONTHNAME(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Month_Ordered
FROM customer_transaction_data
GROUP BY CustID, Year_Ordered, Month_Ordered
ORDER BY CustID, Year_Ordered, MONTH(STR_TO_DATE(OrderDate,"%Y-%m-%d"))) X;

-- cust ids who have purchased for greater than 3 months
SELECT CustID, COUNT(CustID) as Count_Cust FROM (SELECT CustID, ROUND(SUM(SaleValue),2) as Sales, 
YEAR(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Year_Ordered,
MONTHNAME(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Month_Ordered
FROM customer_transaction_data
GROUP BY CustID, Year_Ordered, Month_Ordered
-- HAVING Count_Cust>=3
ORDER BY CustID, Year_Ordered, MONTH(STR_TO_DATE(OrderDate,"%Y-%m-%d"))) as X
GROUP BY CustID
HAVING Count_Cust>=3;


-- cust ids who have purchased for greater than 3 months
-- create view to store these values
CREATE VIEW cust_list AS
SELECT CustID FROM (SELECT CustID, COUNT(CustID) as Count_Cust FROM (SELECT CustID, ROUND(SUM(SaleValue),2) as Sales, 
YEAR(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Year_Ordered,
MONTHNAME(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Month_Ordered
FROM customer_transaction_data
GROUP BY CustID, Year_Ordered, Month_Ordered
-- HAVING Count_Cust>=3
ORDER BY CustID, Year_Ordered, MONTH(STR_TO_DATE(OrderDate,"%Y-%m-%d"))) as X
GROUP BY CustID
HAVING Count_Cust>=3) as cust_l1;


-- checking number of orders by customer
SELECT CustID, COUNT(CustID) as Count_Cust FROM (SELECT CustID, ROUND(SUM(SaleValue),2) as Sales, 
YEAR(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Year_Ordered,
MONTHNAME(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Month_Ordered
FROM customer_transaction_data
GROUP BY CustID, Year_Ordered, Month_Ordered
-- HAVING Count_Cust>=3
ORDER BY CustID, Year_Ordered, MONTH(STR_TO_DATE(OrderDate,"%Y-%m-%d"))) as X
GROUP BY CustID
HAVING Count_Cust>=3
ORDER by Count_Cust DESC;


-- selected data for customers with greater than 3 months data
SELECT CustID, ROUND(SUM(SaleValue),2) as Sales, 
YEAR(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Year_Ordered,
MONTHNAME(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Month_Ordered
FROM customer_transaction_data
WHERE CustID in (SELECT CustID FROM cust_list)
GROUP BY CustID, Year_Ordered, Month_Ordered
ORDER BY CustID, Year_Ordered, MONTH(STR_TO_DATE(OrderDate,"%Y-%m-%d"));










SELECT CustID, ROUND(SUM(SaleValue),2) as Sales, 
YEAR(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Year_Ordered,
MONTHNAME(STR_TO_DATE(OrderDate,"%Y-%m-%d")) as Month_Ordered
FROM customer_transaction_data
GROUP BY CustID, Year_Ordered, Month_Ordered
-- HAVING Count_Cust>=3
ORDER BY CustID, Year_Ordered, MONTH(STR_TO_DATE(OrderDate,"%Y-%m-%d"));

