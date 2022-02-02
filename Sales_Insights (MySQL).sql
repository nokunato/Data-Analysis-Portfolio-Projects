-- Show all customer records
select * from sales.customers;

-- Show total number of customers
select count(*) from customers;

-- WHich transactions are made in Chennei
SELECT * FROM sales.transactions
where market_code = 'Mark001';

-- How many transactions have USD currency
SELECT count(*) FROM sales.transactions
where currency = 'USD';

-- Transactions in 2020 joined by date table
select * from sales.transactions
join sales.date 
on sales.transactions.order_date = sales.date.date
where sales.date.year = '2020';

-- Total revenue or total sales in the year 2020
select sum(sales.transactions.sales_amount) as total_revenue, sales.date.year as year from sales.transactions
join sales.date 
on sales.transactions.order_date = sales.date.date
where sales.date.year = '2020';

-- Total revenue in Chennei
select sum(sales.transactions.sales_amount) as total_revenue, sales.date.year as year from sales.transactions
join sales.date 
on sales.transactions.order_date = sales.date.date
where sales.transactions.market_code = 'Mark001'
group by year;

-- Distinct products sold in Chennei
select distinct product_code from sales.transactions
where market_code = 'Mark001';

