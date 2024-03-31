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






