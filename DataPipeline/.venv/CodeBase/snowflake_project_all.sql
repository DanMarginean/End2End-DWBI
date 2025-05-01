
-- =======================================
-- DDL: Create Tables
-- =======================================

CREATE OR REPLACE TABLE TEST_DB.TEST_DB_SCHEMA.DIMCUSTOMER (
    CUSTOMERID NUMBER(38,0) AUTOINCREMENT START 1 INCREMENT 1 NOORDER,
    FIRSTNAME VARCHAR(16777216),
    LASTNAME VARCHAR(16777216),
    GENDER VARCHAR(16777216),
    DATEOFBIRTH DATE,
    EMAIL VARCHAR(16777216),
    PHONENUMBER VARCHAR(16777216),
    ADDRESS VARCHAR(16777216),
    CITY VARCHAR(16777216),
    STATE VARCHAR(16777216),
    ZIPCODE VARCHAR(16777216),
    COUNTRY VARCHAR(16777216),
    LOYALTYPROGRAMID NUMBER(38,0)
);

CREATE OR REPLACE TABLE TEST_DB.TEST_DB_SCHEMA.DIMDATE (
    DATEID NUMBER(38,0) NOT NULL,
    DATE DATE,
    DAYOFWEEK VARCHAR(10),
    MONTH VARCHAR(10),
    QUARTER NUMBER(38,0),
    YEAR NUMBER(38,0),
    ISWEEKEND BOOLEAN,
    PRIMARY KEY (DATEID)
);

CREATE OR REPLACE TABLE TEST_DB.TEST_DB_SCHEMA.DIMLOYALTYPROGRAM (
    LOYALTYPROGRAMID NUMBER(38,0) NOT NULL,
    PROGRAMNAME VARCHAR(100),
    PROGRAMTIER VARCHAR(50),
    POINTSACCRUED NUMBER(38,0),
    PRIMARY KEY (LOYALTYPROGRAMID)
);

CREATE OR REPLACE TABLE TEST_DB.TEST_DB_SCHEMA.DIMPRODUCT (
    PRODUCTID NUMBER(38,0) NOT NULL AUTOINCREMENT START 1 INCREMENT 1 NOORDER,
    PRODUCTNAME VARCHAR(100),
    CATEGORY VARCHAR(50),
    BRAND VARCHAR(50),
    UNITPRICE NUMBER(10,2),
    PRIMARY KEY (PRODUCTID)
);

CREATE OR REPLACE TABLE TEST_DB.TEST_DB_SCHEMA.DIMSTORE (
    STOREID NUMBER(38,0) NOT NULL AUTOINCREMENT START 1 INCREMENT 1 NOORDER,
    STORENAME VARCHAR(100),
    STORETYPE VARCHAR(50),
    STOREOPENINGDATE DATE,
    ADDRESS VARCHAR(255),
    CITY VARCHAR(50),
    STATE VARCHAR(255),
    COUNTRY VARCHAR(50),
    MANAGERNAME VARCHAR(100),
    REGION VARCHAR(50),
    PRIMARY KEY (STOREID)
);

CREATE OR REPLACE TABLE TEST_DB.TEST_DB_SCHEMA.FACTORDERS (
    ORDERID NUMBER(38,0) NOT NULL AUTOINCREMENT START 1 INCREMENT 1 NOORDER,
    DATEID NUMBER(38,0),
    CUSTOMERID NUMBER(38,0),
    PRODUCTID NUMBER(38,0),
    STOREID NUMBER(38,0),
    QUANTITYORDERED NUMBER(38,0),
    ORDERAMOUNT NUMBER(10,2),
    DISCOUNTAMOUNT NUMBER(10,2),
    SHIPPINGCOST NUMBER(10,2),
    TOTALAMOUNT NUMBER(10,2),
    PRIMARY KEY (ORDERID),
    FOREIGN KEY (DATEID) REFERENCES TEST_DB.TEST_DB_SCHEMA.DIMDATE(DATEID),
    FOREIGN KEY (PRODUCTID) REFERENCES TEST_DB.TEST_DB_SCHEMA.DIMPRODUCT(PRODUCTID),
    FOREIGN KEY (STOREID) REFERENCES TEST_DB.TEST_DB_SCHEMA.DIMSTORE(STOREID)
);

-- =======================================
-- Data Load: PUT and COPY Statements
-- =======================================

-- PUT and COPY for DIMCUSTOMER
PUT 'DataIntegrationDWBI/.venv/CodeBase/ExcelData/DimCustomerData.csv'
    @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimCustomerData/ AUTO_COMPRESS=FALSE;

COPY INTO TEST_DB.TEST_DB_SCHEMA.DIMCUSTOMER(FIRSTNAME, LASTNAME, GENDER, DATEOFBIRTH, EMAIL, PHONENUMBER, ADDRESS, CITY, STATE, ZIPCODE, COUNTRY, LOYALTYPROGRAMID)
FROM @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimCustomerData/DimCustomerData.csv 
FILE_FORMAT = (FORMAT_NAME = 'CSV_SOURCE_FILE_FORMAT');

-- PUT and COPY for DIMSTORE
PUT 'DataIntegrationDWBI/.venv/CodeBase/ExcelData/DimStoreData.csv'
    @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimStoreData/ AUTO_COMPRESS=FALSE;

COPY INTO TEST_DB.TEST_DB_SCHEMA.DIMSTORE(STORENAME, STORETYPE, STOREOPENINGDATE, ADDRESS, CITY, STATE, COUNTRY, MANAGERNAME, REGION)
FROM @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimStoreData/DimStoreData.csv
FILE_FORMAT = (FORMAT_NAME = 'CSV_SOURCE_FILE_FORMAT');

-- PUT and COPY for DIMDATE
PUT 'DataIntegrationDWBI/.venv/CodeBase/ExcelData/DimDate.csv'
    @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimDate/ AUTO_COMPRESS=FALSE;

COPY INTO TEST_DB.TEST_DB_SCHEMA.DIMDATE(DATEID, DATE, DAYOFWEEK, MONTH, QUARTER, YEAR, ISWEEKEND)
FROM @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimDate/DimDate.csv
FILE_FORMAT = (FORMAT_NAME = 'CSV_SOURCE_FILE_FORMAT');

-- PUT and COPY for DIMPRODUCT
PUT 'DataIntegrationDWBI/.venv/CodeBase/ExcelData/DimProductData.csv'
    @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimProductData/ AUTO_COMPRESS=FALSE;

COPY INTO TEST_DB.TEST_DB_SCHEMA.DIMPRODUCT(PRODUCTNAME, CATEGORY, BRAND, UNITPRICE)
FROM @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimProductData/DimProductData.csv
FILE_FORMAT = (FORMAT_NAME = 'CSV_SOURCE_FILE_FORMAT');

-- PUT and COPY for DIMLOYALTYPROGRAM
PUT 'DataIntegrationDWBI/.venv/CodeBase/ExcelData/DimLoyaltyInfo.csv'
    @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimLoyaltyInfo/ AUTO_COMPRESS=FALSE;

COPY INTO TEST_DB.TEST_DB_SCHEMA.DIMLOYALTYPROGRAM(LOYALTYPROGRAMID, PROGRAMNAME, PROGRAMTIER, POINTSACCRUED)
FROM @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimLoyaltyInfo/DimLoyaltyInfo.csv
FILE_FORMAT = (FORMAT_NAME = 'CSV_SOURCE_FILE_FORMAT');

-- PUT and COPY for FACTORDERS
PUT 'DataIntegrationDWBI/.venv/CodeBase/ExcelData/factorders.csv'
    @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/factorders/ AUTO_COMPRESS=FALSE;

COPY INTO TEST_DB.TEST_DB_SCHEMA.FACTORDERS(DATEID, PRODUCTID, STOREID, CUSTOMERID, QUANTITYORDERED, ORDERAMOUNT, DISCOUNTAMOUNT, SHIPPINGCOST, TOTALAMOUNT)
FROM @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/factorders/factorders.csv
FILE_FORMAT = (FORMAT_NAME = 'CSV_SOURCE_FILE_FORMAT');



-- =======================================
-- Project: Snowflake Data Pipeline for Retail Analytics
-- Description: Consolidated SQL script with staging, loading, transformation, and analysis queries
-- =======================================

-- Use Database and Schema
USE TEST_DB;
USE SCHEMA TEST_DB_SCHEMA;
USE ROLE ACCOUNTADMIN;

-- Create File Format
CREATE OR REPLACE FILE FORMAT CSV_SOURCE_FILE_FORMAT
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    DATE_FORMAT = 'YYYY-MM-DD';

-- Create Power BI User
CREATE OR REPLACE USER PowerBI_User
    PASSWORD = ''
    LOGIN_NAME = 'PowerBI User'
    DEFAULT_ROLE = 'ACCOUNTADMIN'
    DEFAULT_WAREHOUSE = 'COMPUTE_WH'
    MUST_CHANGE_PASSWORD = TRUE;

SELECT * FROM dimcustomer WHERE customerid NOT IN (
    SELECT DISTINCT c.Customerid FROM dimcustomer c
    JOIN factorders f ON c.customerid = f.customerid
    JOIN dimdate d ON f.dateid = d.dateid
    WHERE d.date >= DATEADD(MONTH,-1,CURRENT_DATE)
);


-- =======================================
-- Q1: Update DIMSTORE with randomized store opening dates
-- =======================================
UPDATE DIMSTORE 
SET STOREOPENINGDATE = DATEADD(DAY, UNIFORM(0, 3000, RANDOM()), '2015-01-01');

-- Q2: Update opening dates for specific store IDs
UPDATE DIMSTORE
SET STOREOPENINGDATE = DATEADD(DAY, UNIFORM(0, 360, RANDOM()), '2023-07-30')
WHERE STOREID BETWEEN 91 AND 100;

-- Q3: Fix dates of birth under 12 years
UPDATE DIMCUSTOMER 
SET DATEOFBIRTH = DATEOFBIRTH 
WHERE DATEOFBIRTH >= DATEADD(YEAR, -12, CURRENT_DATE);

-- Q4: Replace invalid dateids in FACTORDERS based on store opening
UPDATE TEST_DB.TEST_DB_SCHEMA.FACTORDERS f
SET DATEID = r.new_dateid
FROM (
    SELECT 
        f.ORDERID,
        d_new.DATEID AS new_dateid
    FROM TEST_DB.TEST_DB_SCHEMA.FACTORDERS f
    JOIN TEST_DB.TEST_DB_SCHEMA.DIMDATE d_old ON f.DATEID = d_old.DATEID
    JOIN TEST_DB.TEST_DB_SCHEMA.DIMSTORE s ON f.STOREID = s.STOREID
    JOIN TEST_DB.TEST_DB_SCHEMA.DIMDATE d_new ON 
        d_new.DATE = DATEADD(
            DAY, 
            CAST(UNIFORM(1, 10, RANDOM()) AS INT), 
            s.STOREOPENINGDATE
        )
    WHERE d_old.DATE < s.STOREOPENINGDATE
) r
WHERE f.ORDERID = r.ORDERID;

-- Q5: Customers without recent orders
SELECT * FROM dimcustomer 
WHERE customerid NOT IN (
    SELECT DISTINCT c.Customerid FROM dimcustomer c
    JOIN factorders f ON c.customerid = f.customerid
    JOIN dimdate d ON f.dateid = d.dateid
    WHERE d.date >= DATEADD(MONTH, -1, CURRENT_DATE)
);

-- Q6: Most recently opened store and its total sales
WITH store_rank AS (
    SELECT storeid, storeopeningdate, ROW_NUMBER() OVER (ORDER BY storeopeningdate DESC) AS final_rank 
    FROM DIMSTORE
),
most_recent_store AS (
    SELECT storeid FROM store_rank WHERE final_rank = 1
),
store_amount AS (
    SELECT o.storeid, SUM(totalamount) AS totalamount 
    FROM factorders o 
    JOIN most_recent_store s ON o.storeid = s.storeid 
    GROUP BY o.storeid
)
SELECT s.*, a.totalamount 
FROM dimstore s 
JOIN store_amount a ON s.storeid = a.storeid;

-- Q7: Customers who bought from more than 3 categories in last 6 months
WITH BASE_DATA AS (
    SELECT o.customerid, p.category 
    FROM factorders o 
    JOIN dimdate d ON o.dateid = d.dateid
    JOIN dimproduct p ON o.productid = p.productid
    WHERE d.date >= DATEADD(MONTH, -6, CURRENT_DATE)
    GROUP BY o.customerid, p.category
)
SELECT customerid 
FROM BASE_DATA 
GROUP BY customerid 
HAVING COUNT(DISTINCT category) > 3;

-- Q8: Monthly sales this year
SELECT 
    d.month, 
    SUM(o.totalamount) AS monthly_amount
FROM factorders o
JOIN dimdate d ON o.dateid = d.dateid
WHERE d.year = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY d.month
ORDER BY d.month;

-- Q9: Highest discount amount in last year
WITH base_data AS (
    SELECT discountamount, ROW_NUMBER() OVER (ORDER BY discountamount DESC) AS discount_rank 
    FROM factorders o 
    JOIN dimdate d ON o.dateid = d.dateid 
    WHERE d.date >= DATEADD(YEAR, -1, CURRENT_DATE)
)
SELECT * FROM base_data WHERE discount_rank = 1;

-- Q10: Total sales based on unit price * quantity
SELECT 
    SUM(o.quantityordered * p.unitprice) AS total_sales
FROM factorders o
JOIN dimproduct p ON o.productid = p.productid;

-- Q11: Customer with the highest total discount
SELECT 
    customerid,
    SUM(discountamount) AS total_discount
FROM factorders
GROUP BY customerid
ORDER BY total_discount DESC
LIMIT 1;

-- Q12: Customer with most orders
WITH base_data AS (
    SELECT customerid, COUNT(orderid) AS order_count 
    FROM factorders
    GROUP BY customerid
),
order_rank_data AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY order_count DESC) AS order_rank 
    FROM base_data
)
SELECT customerid, order_count FROM order_rank_data WHERE order_rank = 1;

-- Q13: Top 3 brands by sales in the past year
WITH brand_sales AS (
    SELECT p.brand, SUM(f.totalamount) AS total_sales 
    FROM factorders f
    JOIN dimdate d ON f.dateid = d.dateid
    JOIN dimproduct p ON f.productid = p.productid
    WHERE d.date >= DATEADD(YEAR, -1, CURRENT_DATE)
    GROUP BY p.brand
),
brand_sales_rank AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY total_sales DESC) AS sales_rank 
    FROM brand_sales
)
SELECT brand, total_sales FROM brand_sales_rank WHERE sales_rank <= 3;

-- Q14: Validate totalamount formula
SELECT 
    CASE 
        WHEN SUM(orderamount + orderamount * 0.05 - orderamount * 0.08) > SUM(totalamount) 
        THEN 'yes' ELSE 'no' 
    END 
FROM factorders;

-- Q15: Count of customers by loyalty program tier
SELECT 
    l.programtier, 
    COUNT(d.customerid) AS customer_count
FROM dimcustomer d
JOIN dimloyaltyprogram l ON d.loyaltyprogramid = l.loyaltyprogramid
GROUP BY l.programtier;

-- Q16: Regional sales by product category (last 6 months)
SELECT 
    s.region, 
    p.category, 
    SUM(f.totalamount) AS total_sales
FROM factorders f
JOIN dimdate d ON f.dateid = d.dateid
JOIN dimproduct p ON f.productid = p.productid
JOIN dimstore s ON f.storeid = s.storeid
WHERE d.date >= DATEADD(MONTH, -6, CURRENT_DATE)
GROUP BY s.region, p.category;

-- Q17: Top 5 products by quantity sold (last 3 years)
WITH quantity_data AS (
    SELECT f.productid, SUM(f.quantityordered) AS total_quantity 
    FROM factorders f
    JOIN dimdate d ON f.dateid = d.dateid
    WHERE d.date >= DATEADD(YEAR, -3, CURRENT_DATE)
    GROUP BY f.productid
),
quantity_rank_data AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY total_quantity DESC) AS rank 
    FROM quantity_data
)
SELECT productid, total_quantity FROM quantity_rank_data WHERE rank <= 5;

-- Q18: Total sales by loyalty program since 2023
SELECT 
    p.programname, 
    SUM(f.totalamount) AS total_sales 
FROM factorders f
JOIN dimdate d ON f.dateid = d.dateid
JOIN dimcustomer c ON f.customerid = c.customerid
JOIN dimloyaltyprogram p ON c.loyaltyprogramid = p.loyaltyprogramid
WHERE EXTRACT(YEAR FROM d.date) >= 2023
GROUP BY p.programname;

-- Q19: Total sales by manager in June 2024
SELECT 
    s.managername, 
    SUM(f.totalamount) AS total_sales 
FROM factorders f
JOIN dimdate d ON f.dateid = d.dateid
JOIN dimstore s ON f.storeid = s.storeid
WHERE EXTRACT(YEAR FROM d.date) = 2024 AND EXTRACT(MONTH FROM d.date) = 6
GROUP BY s.managername;

-- Q20: Average sales by store in 2024
SELECT 
    s.storename, 
    s.storetype, 
    AVG(f.totalamount) AS total_sales
FROM factorders f
JOIN dimdate d ON f.dateid = d.dateid
JOIN dimstore s ON f.storeid = s.storeid
WHERE EXTRACT(YEAR FROM d.date) = 2024
GROUP BY s.storename, s.storetype;

-- Q22: Preview CSV file contents
SELECT $1, $2, $3 
FROM @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimCustomerData/DimCustomerData.csv 
(FILE_FORMAT => 'CSV_SOURCE_FILE_FORMAT');

-- Q23: Count rows in CSV
SELECT COUNT($1) 
FROM @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/"DimCustomerData/DimCustomerData.csv" 
(FILE_FORMAT => 'CSV_SOURCE_FILE_FORMAT');

-- Q24: Filter CSV rows with recent birth dates
SELECT $1, $2, $3, $4, $5, $6, $7, $8 
FROM @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/"DimCustomerData/DimCustomerData.csv" 
(FILE_FORMAT => 'CSV_SOURCE_FILE_FORMAT') 
WHERE $6 > '2000-01-01';

-- Q25: Join loyalty info with customer data from staged files
WITH customer_data AS (
    SELECT $1 AS first_name, $12 AS loyalty_program_id
    FROM @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/"DimCustomerData/DimCustomerData.csv"
    (FILE_FORMAT => 'CSV_SOURCE_FILE_FORMAT')
),
loyalty_data AS (
    SELECT $1 AS loyalty_program_id, $3 AS program_tier
    FROM @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/"DimLoyaltyInfo/DimLoyaltyInfo.csv"
    (FILE_FORMAT => 'CSV_SOURCE_FILE_FORMAT')
)
SELECT c.first_name, l.program_tier
FROM customer_data c
JOIN loyalty_data l ON c.loyalty_program_id = l.loyalty_program_id;
