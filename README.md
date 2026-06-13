# 📈 Walmart-Sales-Analysis: End-to-End Python + SQL Project


## ♦️ Project Overview

This project is an end-to-end data analysis solution designed to extract critical business insights from Walmart sales data. 
We utilize Python for data processing and analysis, SQL for advanced querying, and structured problem-solving techniques to solve key business questions. 
The project helped me to develop skills in data manipulation, SQL querying, and data pipeline creation.

***

## 📍 Project Objectives

- Reveal revenue trends across branches and categories.
- Identify best-selling product categories.
- Study sales performance by time, city, and payment method.
- Analyze peak sales periods and customer buying patterns.
- Evaluate profit margin analysis by branch and category.

***

## 🛠️ Tools & Technologies Used

- Python (Pandas, Pymysql, SQLAlchemey)
- MySQL (SQL querying)
- Kaggel API token(for data downloading)
- Data Ingestion and Pipeline
- Data Cleaning & Transformation

***

## 📂 Dataset Description

The dataset contains:
- Invoice id
- Branch
- City
- Category
- Unit price
- Quantity
- Date
- Time
- Payment method
- Rating
- Profit margin
- Total price

***

## 📝 Project Steps

### 1. Set Up the Environment
- **Tools Used:** Visual Studio Code (VS Code), Python, SQL (MySQL)
- **Goal:** Create a structured workspace within VS Code and organize project folders for smooth development and data handling.
  
### 2. Set Up Kaggle API
- **API Setup:** Obtained Kaggle API token from Kaggle by navigating to the profile settings and copying the link for API token access.
Set up the new environment variable.
- **Configure Kaggle:** 
Used the command ```kaggle datasets download -d <dataset-path>``` to pull datasets directly into the project.

### 3. Download Walmart Sales Data
- **Data Source:** Used the Kaggle API to download the Walmart sales datasets from Kaggle.
- **Dataset Link:** [Walmart Sales Dataset](https://www.kaggle.com/datasets/najir0123/walmart-10k-sales-datasets)
- **Storage:** Saved the data in the data/ folder for easy reference and access.

### 4. Install Required Libraries and Load Data
- **Libraries:** Installed necessary Python libraries.
- **Loading Data:** Read the data into a Pandas DataFrame for initial analysis and transformations.

### 5. Exploring the Data
- **Goal:** Conduct an initial data exploration to understand data distribution, check column names, types, and identify potential issues.
- **Analysis:** Used functions like ```.info()```, ```.describe()```, and ```.head()``` to get a quick overview of the data structure and statistics.

### 6. Data Cleaning
- **Remove Duplicates:** Identified and removed duplicate entries to avoid skewed results.
- **Handle Missing Values:** Dropped rows with missing values if they are insignificant.
- **Fix Data Types:** Ensured all columns have consistent data types (e.g., dates as ```datetime```, prices as ```float```).
- **Currency Formatting:** Used ```.replace()``` to handle and format currency values for analysis.
- **Validation:** Checked for any remaining inconsistencies and verify the cleaned data.

### 7. Feature Engineering
- **Create New Columns:** Calculated the ```Total Revenue``` for each transaction by multiplying ```unit_price``` by ```quantity``` and adding this as a new column.
- **Enhance Dataset:** Adding this calculated field streamlined further SQL analysis and aggregation tasks.

### 8. Loading Data into MySQL
- **Set Up Connections:** Connect to MySQL using ```pymysql```, ```sqlalchemy``` and loaded the cleaned data into the database.
- **Table Creation:** Set up table in MySQL using Python SQLAlchemy to automate table creation and data insertion.
- **Verification:** Ran initial SQL queries to confirm that the data has been loaded accurately.
  
### 9. SQL Analysis: Complex Queries and Business Problem Solving
- **Business Problem-Solving:** Executed complex SQL queries to answer critical business questions, such as:
  - **Sales Insights:** Key categories, branches with highest sales, and critical selling months.
  - **Product & Pricing Analysis:** Expensive categories, highest selling categories.
  - **Time based Trends:** Highest revenue generating day, yearly, monthly branch revenue trends and shift-wise sales. 
  - **Profitability:** Insights into the most profitable product categories and locations.
  - **Customer Behavior Analysis:** Trends in ratings, payment method preferences, and peak shopping hours.
- **Documentation:** Kept clear notes of each query's objective, approach, and results.

***

## Project Structure

```
|-- data/                     # Raw data and transformed data
|-- sql_queries/              # SQL scripts for analysis and queries
|-- notebooks/                # Jupyter notebook for Python analysis
|-- README.md                 # Project documentation
|-- requirements.txt          # List of required Python libraries
|-- main.py                   # Main script for loading, cleaning, and processing data
```
***

## 📌 Results and Insights

- McKinney city generates the highest average transactions.
- Credit card is the most preferred payment method.
- Branch 053 produces maximum profits.
- December is the most revenue generating month while April does least revenue.
- Average categorical ratings determined.
- Analysed most popular category of each city.
- Top 5 most expensive categories identified.
- Fashion accessories and home & lifestyle are the most popular categories.
- Wednesday is the highest revenue generating day of the week.
- Identified branches suffering from highest revenue decline over the year.
- Analysed monthly revenue trend of each branch.
- Profit analysis performed categorically and as per different branches.
- Identified bulk purchases.
- Identified branches that need to improve their customer satisfaction practices.
  

***

## 📍 Key Recommendations

- Improve marketing strategies by targeting popular categories of each branch and supply of these categories maintained at all times.
- Work around the most profitable branches to further boost its sales and focused planning of its management and facilities.
- Create strategies to boost sales or mitigate losses of the branches having declining revenue over the year. Can assign time-framed targets to low performing branches as to uplift their sales.
- Enhance store management during the high revenue months such as December and improvise sale discounts during least sale months like April to improve its revenue.
- Guide city-level promotions to address regional preferences and improve customer experiences.
- Track expensive categories sales' and their revenue, introduc them in marketing campaigns to make people familiar with these product categories therefore, improving its sales.
- Manage staff shifts and stock replenishment schedules effectively during high-sales periods of the day.
- Optimize staffing, financial systems and inventory management during peak days like Wednesday as it is the most revenue generating day of the week.
- Keep track of the monthly revenue trends and build strategies to improve upcoming profits compared to the less profitable last months and maintain growth balance.
- Expand high-profit category products and manage its pricing strategies effectively.

***

## 🏷️ Future Enhancements
Possible extensions to this project:
- Integration with a dashboard tool (e.g., Power BI or Tableau) for interactive visualization.
- Additional data sources to enhance analysis depth.
- Automation of the data pipeline for real-time data ingestion and analysis.

***

### Acknowledgments
- Data Source: Kaggle’s Walmart Sales Dataset
- Inspiration: Walmart’s business case studies on sales and supply chain optimization.
***
