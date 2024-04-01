# Capstone Project Croma Sales Analysis
Capstone Project for the Certificate of Master in Data Science and Analytics with AI

# Abstract
+ Croma is one of the top electronic retailers in India, which is a part of the Tata Group of Industries and offers both online and in-store purchasing.
+ With more than 150 physical locations in more than 40 major Indian cities, Croma also offers an online shopping platform.
+ The dataset is provided by Croma, as it looks to address a few business challenges for which a data driven approach is required. 
+ The requirements for this dataset are in the form of case studies.
  - **Case Study 1** aims to look at the sales distribution during special days/ seasons. 
  - **Case Study 2** aims to understand the effectiveness of marketing campaigns. 
  - **Case Study 3** aims to summarize and categorize reviews from customers for its various products. 
  - **Case Study 4** aims to understand the delivery process by looking at the time taken between each stop in the delivery process.

By the time of writing this report I have completed Case Studies 1 and 4, and given an attempt at Case Studies 2 and 3.

# Data Description
The dataset has been provided by  Croma. It consists of 6 files. The details of each are given below:

1. ***Transactional Data***: Contains details of transaction across any store, across India. Details captured include: customer id, sale value, ordered quantity, store id, city, state, order date.

2. ***Customer Master File***: Contains details of the customers such as gender, marital status, pincode.

3. ***Campaign Details***: Details of campaigns being run. Data includes date of campaign, customer id, campaign medium: email or sms, response of customer: whether viewed, delivered or clicked.

4. ***Customer Reviews***: Contains category, group, product, city and review by customer

5. ***Delivery Data***: Details of shipments and timestamps of each process involved in delivery

6. ***Festivals Data***: List of festivals for which seasonality effect needs to be found

# Tools/Python Libraries used to process data

+ pandas
+ numpy
+ nltk
+ spaCy
+ scikit-learn
+ jupyter notebook
+ notepad
+ Google Docs
+ SQL
+ PowerBI
+ Tableau
+ Excel

# Data Cleaning
1. Transactional Data
   + 2 Duplicate Columns were dropped
   + Null Values were replaced apprpriately
   + Filled Missing State Values where Cities were known
   + Replace incorrect spellings of States

2. Customer Master Data
   + Replace null values and incorrect spellings of States

3. Campaign Details
   + No changes

4. Customer Reviews
   + Dropped records with null reviews
   + Dropped one column

5. Delivery Data
   + Replaced Null text data with "Unknown"
   + Dropped one duplicate column
   + Cleaned Pincode
   + Filled Null state values where city was known
  
6. Festivals Data
   + No changes

# Case Study 1
## **Which Merchant Classes are Highly/Least Affected by Seasonal Variations:**
1. Data Processing
   + Converted Date (str) to Datetime data type
   + Turned negative Order and Sale Values to Positive
   + **Note:** From 24 Mar to 30 Apr 2019, the number of records is only 58. This is very less as compared to other records in the table. Usually each day has multiple records of sales, but for this period the records are missing or the number of records are very low for any given day. Looks like an issue with the Data.

2. Pivot Table (Pandas)
   + Created a Pivot Table; Rows contain Dates, Columns contain all Merch Classes. Each Cell contains the percentage of annual sale value for the specific merchant class.
![image](https://github.com/jobssaurabhmul/capstone_project_croma_sales_analysis/assets/152073191/39eba899-1a73-4e60-9291-8fbfed9b4467)

   + Transposed the Pivot Table
![image](https://github.com/jobssaurabhmul/capstone_project_croma_sales_analysis/assets/152073191/6e736c68-8207-41e6-b674-87dc367e5865)

   + For each Festive Season I have collated the top 10 and bottom 10 sales value by percentage of annual sales for all the years -2019,2020,2021
   + The data is saved in excel files
   + A Chart has been created to observe the sales trend of Merchant Classes over time
   ![image](https://github.com/jobssaurabhmul/capstone_project_croma_sales_analysis/assets/152073191/fafd8c96-9634-408e-b32e-439d2157032d)
   + Another Example: For Audio Systems
   ![image](https://github.com/jobssaurabhmul/capstone_project_croma_sales_analysis/assets/152073191/3d8fba9b-08d7-4c1e-9e47-f37bf8a28c54)

## **Product Segmentation:**
**Merchant Categories to be analysed for this exercise are: TVs, Laptops and Mobile Phones. Classify them as Premium (top 33%), Mainstream (middle 33%) and Value (bottom 33%) depending on the Price of the Product**

**Procedure Followed:**
1. First create groups for categories: TVs, Laptops and Mobile Phones
2. Divide the group into 3 segemnts as per salevalue/orderedqty ratio -> value, mainstream, premium
3. For all 3 segments - calculate sales volume and revenue for each category

+ Create Groups: I have considered the column MerchClassDescription to create the new groupings of TVs, Laptops and Mobile Phones. Listed below under each category are the MerchClassDescription values considered to be part of the category.
   + TVs
     - TV LCD
   + Laptops
     - Gaming Laptops
     - Mobile Computing
   + Mobile Phones
     - Smart Phones (OS Based)
     - Brand Free Mobiles
     - Refurbished Phones
     - Phones Mobile

   + Data Cleaning was a huge part for creating the above new groups. Each Group had to contain only the terms mentioned above. Some terms that were removed from the above data wer terms containig:
     - Carrycase, Bag
     - Accidental Damage Protection, SDP, Extended Warranty, ZIP
     - AppleCare, AC+, Apple Pro

+ The groups were divided into the 3 segemnts as per salevalue/orderedqty ratio . Value, Mainstream, and Premium segments were created for each group.
+ Sales Volume and Revenue for each category is displayed in an Excel Dashboard

![image](https://github.com/jobssaurabhmul/capstone_project_croma_sales_analysis/assets/152073191/760badf3-3fc4-4517-bced-a96fe52ffeeb)

## **SQL Queries:**
+ Return the Cust ID that received the 5th highest number of campaigns for the entire duration (using only the campaign data)

  - _SELECT CustID FROM (_
  - _SELECT CustID, COUNT(CustID) as No_of_Campaigns,_
  - _DENSE_RANK() OVER (ORDER BY COUNT(CustID) DESC) as Rank_Campaign_
  - _FROM campaign_data_
  - _GROUP BY CustID_
  - _ORDER BY No_of_Campaigns DESC) as tbl_rank_
  - _WHERE Rank_Campaign = 5;_
  - A list of Customer IDs has been generated. The data has been saved in a CSV File.

+ Find the States for which the average time of delivery from Sale Timestamp to Delivered Timestamp is the minimum and the maximum respectively. Use the Delivery data for this and only those records for which Sale Timestamp, Delivery Timestamp and Ship to State – all variables are populated.

**Maximum Andaman And Nicobar Islands	12489 minutes = 208.15 hrs**
  - _WITH data_table as (SELECT shiptostate as State, TIMESTAMPDIFF(MINUTE, STR_TO_DATE(sale_timestamp,"%d-%m-%Y %H:%i"), STR_TO_DATE(delivered_timestamp,"%d-%m-%Y %H:%i")) as TimeDelta_
  - _FROM delivery_analysis_
  - _GROUP BY State)_
  - _SELECT State, ROUND(TimeDelta/60,2) as Hours FROM data_table_
  - _WHERE TimeDelta = (SELECT MAX(TimeDelta) FROM data_table);_

**Minimum - Jammu And Kashmir	212 minutes = 3.53 hrs**
  - _WITH data_table as (SELECT shiptostate as State, TIMESTAMPDIFF(MINUTE, STR_TO_DATE(sale_timestamp,"%d-%m-%Y %H:%i"), STR_TO_DATE(delivered_timestamp,"%d-%m-%Y %H:%i")) as TimeDelta_
  - _FROM delivery_analysis_
  - _GROUP BY State)_
  - _SELECT State, ROUND(TimeDelta/60,2) as Hours FROM data_table_
  - _WHERE TimeDelta = (SELECT MIN(TimeDelta) FROM data_table);_

+ Create a dataset of customer ids whose monthly transaction amount has increased every month for at least 3 consecutive months.
## Return the Cust ID that received the 5th highest number of campaigns for the entire duration (using only the campaign data)

## Product Assortment:
For the top 5 Brick and Mortar Stores across India, what is the distribution of sales for the most recent 6 months of data across the different Merchant Categories and their corresponding segments (Premium, Mainstream, Value).

The Top 5 B&M stores by Sales were found using Pandas. An Interactive Dashboard is created which shows the sales across the last 6 months data.

![image](https://github.com/jobssaurabhmul/capstone_project_croma_sales_analysis/assets/152073191/f2f8e798-90ca-4668-b5cd-0c9f0792a74d)

## Product Evolution
Created a dashboard in Tableau. Selected a an SKU belonging to a Mechant Category and then displayed how the average price and corresponding demand for that SKU has changed across time.

![image](https://github.com/jobssaurabhmul/capstone_project_croma_sales_analysis/assets/152073191/b593e6bb-ac6f-4545-9646-a016844e34db)

## Mini Sales Dashboard Power BI
As per the requirement, the following problems were solved:
1. Number of Customers (New and Existing) every month for the last 6 months was found using the below DAX Query:

   + new_customers = 
     + VAR current_customers = VALUES(Transaction_Data[CustID])
     + VAR current_date = MIN('Date'[Date])
     + VAR past_customers = CALCULATETABLE(VALUES(Transaction_Data[CustID]),
                            ALL('Date'[Date].[Month],'Date'[Date].[MonthNo],'Date'[Date].[Year])
                            ,'Date'[Date]<current_date)

     + VAR new_customers =  EXCEPT(current_customers,past_customers)
     + RETURN COUNTROWS(DISTINCT(new_customers))

2. Monthly Sales Revenue every month for the last 6 months – comparison with previous year same months

![image](https://github.com/jobssaurabhmul/capstone_project_croma_sales_analysis/assets/152073191/1e89ef1d-6df8-4edc-a0fb-d862032e2632)

3. Average Transaction Value every month for the last 6 months
4. State-wise heat map of India for sales in INR (Ecom + B&M combined)

![image](https://github.com/jobssaurabhmul/capstone_project_croma_sales_analysis/assets/152073191/761ed134-bc57-44c2-a64c-d63348747187)

# Case Study 4
## Delivery Fulfilment Analysis
Created a dashboard that captures the average time duration between each stop in the delivery process. Finally, I have shown the average delay in Days between the Required Delivery Date and Actual Delivery Date.

![image](https://github.com/jobssaurabhmul/capstone_project_croma_sales_analysis/assets/152073191/e916ed28-c282-44d9-9651-4a1c47a842b1)






