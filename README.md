# Superstore-Sales
Overview
This project involves analyzing and normalizing a sales database. The main goal is to build a predictive model to forecast sales for the next quarter based on historical data, and to understand various sales trends and relationships.

Files
1. Case Study Power BI Report (Case_Study.pbix)
This Power BI file contains various visualizations and analyses based on the sales data.

2. SQL Script (CS.sql)
This script includes SQL queries used for data analysis and transformation.

3. Entity-Relationship Diagram (ERD.png)
This image shows the ERD of the database schema, illustrating the relationships between different entities.

4. Mapping (Mapping.txt)
This file lists the schema and relationships between tables in the database.

5. Normalization (Normalization.txt)
This file outlines the normalization process, ensuring the database is in 3rd Normal Form (3NF).

Database Schema
Tables and Relationships
Orders

Columns: Order_ID, Order_Date, Ship_Date, Customer_ID (fk), Territory_ID (fk)
Customer

Columns: Customer_ID, Customer_Name, Segment
Territory

Columns: Territory_ID, Territory_Name, Territory_Group
Product

Columns: Product_ID, Product_name, Category, Sub_category
Returns

Columns: order_ID (fk)
OrderProduct

Columns: Order_ID (fk), Product_ID (fk), Sales, Quantity, Discount, Profit, Status_Name, Status_ID
Status

Columns: Status_ID, Status_Name
ERD
The ERD illustrates the connections between the above tables. Key relationships:

Orders are linked to Customers and Territories.
Orders have many OrderProducts.
Products are linked to OrderProducts.
Returns are linked to Orders.
Status is linked to OrderProducts.
