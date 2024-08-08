-- 1. Which customer segment contributes the most to overall sales? 

select segment , "Total Sales" from (select segment , sum(sales) "Total Sales"
from customers c
join orders o 
on c.customer_id = o.customer_id
join orderproduct op
on o.order_id = op.order_id
where op.order_id not in (select order_id from returns) 
group by segment
order by "Total Sales" desc)
where ROWNUM = 1; 

-- 2. Which sub-category has the highest average profit margin? 

select sub_category , "Avg Profit Margin" from(select sub_category , round(avg((profit/sales) *100),2) "Avg Profit Margin"
from products p
join orderproduct op 
on p.product_id = op.product_id 
group by sub_category
order by "Avg Profit Margin" desc)
where ROWNUM = 1;


-- 3. How does the sales volume vary across different territories? 

select territory , sum(sales) "Total Sales"
from territory t
join orders o 
on t.territoryid = o.territoryid
join orderproduct op
on o.order_id = op.order_id
where op.order_id not in (select order_id from returns) 
group by territory
order by "Total Sales" desc ; 

-- 4. Is there a significant difference in sales volume between different order statuses? 

select status , sum(sales) "Total Sales"
from orderproduct op 
join status s on s.statusid = op.statusid
where order_id not in (select order_id from returns) 
group by status
order by "Total Sales" desc ; 

-- 5. What factors influence sales more: the customer segment, the territory, or the product category? Provide a detailed analysis using a decomposition tree or another BI visualization. 

Select Segment, Territory, Category, sum(Sales) AS "Total Sales"
from Customers C
join Orders O on C.Customer_ID = O.Customer_ID
join Territory T on O.TerritoryID = T.TerritoryID
join OrderProduct OP on O.Order_ID = OP.Order_ID
join Products P on OP.Product_ID = P.Product_ID
where op.order_id not in (select order_id from returns)
group by Segment, Territory, Category 
order by "Total Sales" desc;

-- 6. Identify any seasonal trends in sales volume by analyzing the order and ship dates. How do these trends vary across different product categories? 

select season , category ,sum(sales) "Total Sales" 
from ( select
        case
        when extract(month from order_date) in (12, 1, 2) then 'Winter'
        when extract(month from order_date) in (3, 4, 5) then 'Spring'
        when extract(month from order_date) in (6, 7, 8) then 'Summer'
        else 'Fall'
        end as Season, category , Sales
from orders o
join orderproduct op on o.order_id = op.order_id
join products p on p.product_id = op.product_id
where op.order_id not in (select order_id from returns))
group by season , category
order by season , "Total Sales" desc;


-- 7. Determine the relationship between discount rates and profit margins. How do different discount levels impact overall profitability? 

select Discount_levels, round(avg((profit/sales) *100),2) "Avg Profit Margin" 
from (select case 
when discount < 0.2 then '1'
when discount < 0.4 then '2'
when discount <0.6 then '3'
else '4'
end as Discount_levels , sales , profit
from orderproduct)
group by Discount_levels
order by "Avg Profit Margin" DESC;

-- 8. Analyze the effect of order status on delivery time. Is there a significant difference in delivery times for different order statuses? 

select status , round(avg(ship_date - order_date),3) as avg_delivery_time
from orders o
join orderproduct op on o.order_id = op.order_id
join status s on op.statusid = s.statusid
group by status
order by avg_delivery_time desc ;

-- 9. Which product sub-categories have shown the most growth in sales over the past years? Provide a yearover-year analysis. 

with sales as(
select extract(year from order_date) as year , sub_category , sum(sales)as Sales
from orders o
join orderproduct op on o.order_id = op.order_id
join products p on p.product_id = op.product_id
where op.order_id not in (select order_id from returns)
group by extract(year from order_date) , sub_category)

, prev_sales as (select year , sub_category,sales,lag(Sales) over(partition by sub_category order by sub_category , year ) as prev_sales
from sales)

select year, sub_category, round((sales - prev_sales) / prev_sales * 100 , 2) as "Growth_rate %" 
from prev_sales
order by  sub_category,year, "Growth_rate %" Desc ; 



-- 10. Develop a predictive model to forecast sales for the next quarter based on historical data. Consider factors such as product category, customer segment, and territory



WITH quarterly_sales AS (
Select Segment, Territory, Category, sum(Sales) AS total_sales , extract(year from order_date) as year , TO_CHAR(o.order_date, 'Q') AS quarter
from Customers C
join Orders O on C.Customer_ID = O.Customer_ID
join Territory T on O.TerritoryID = T.TerritoryID
join OrderProduct OP on O.Order_ID = OP.Order_ID
join Products P on OP.Product_ID = P.Product_ID
group by Segment, Territory, Category , extract(year from order_date), TO_CHAR(o.order_date, 'Q') )
, average_quarterly_sales AS (select category,segment,territory, avg(total_sales) AS avg_quarterly_sales 
        from quarterly_sales
        group by category,segment,territory)
        
select category, segment, territory,round(avg_quarterly_sales,2) AS predicted_sales_next_quarter
from average_quarterly_sales ; 









