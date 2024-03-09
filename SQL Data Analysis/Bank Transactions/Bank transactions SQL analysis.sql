-- show all the data 
select * 
from transactions

-- change the datetime column to only_date
alter table transactions
add date_only date

update transactions
set date_only = CONVERT(date , transactions.Date)

alter table transactions
drop column Date

-- show the maximum transaction value 
select *
from transactions
where value in ( select max(Value) from transactions)

-- show the maximum transaction count 
select *
from transactions
where Transaction_count in ( select max(Transaction_count) from transactions)

-- average transaction value for each domain 
select Domain , Floor(AVG(Value)) as average_value
from transactions
group by Domain
order by average_value DESC

--###############################################################
-- divide the date into each of its field if the date was string 
alter table transactions
add day int , month int , year int , the_date varchar(12)

-- from date to days :
--update transactions
--set day = day(date_only)

update transactions
set the_date = convert(varchar , date_only)

update transactions
set year = convert(int , PARSENAME(REPLACE(the_date , '-' , '.'),3)),
 month = convert(int , PARSENAME(REPLACE(the_date , '-' , '.'),2)),
 day = convert(int , PARSENAME(REPLACE(the_date , '-' , '.'),1))

alter table transactions
drop column the_date

-- hence there's only one year so the column year is not useful
alter table transactions
drop column year


--##############################################################
--answering questions 

--Q1 : What was the total transaction value for all locations from 7-2022 to 8-2022
select Location , sum(Value) as total_transaction_value
from transactions
where date_only between '2022-07-01' and '2022-08-31'
group by Location
order by total_transaction_value


-- Q2 : Which location had the highest total transaction value in a specific year
select top(1) Location , sum(Value) as maximum_total_transaction_value
from transactions
where year(date_only) = 2022
group by Location
order by maximum_total_transaction_value

-- Q3 : Which domain had the most transactions on average per day for September 2022
select top(1) Domain ,floor(avg(Value)) as avg_transaction_value
from transactions
where year(date_only) = 2022 and month(date_only) = 9
group by Domain
order by avg_transaction_value

-- Q4 : What was the busiest day (most transactions) across all locations for 2022
select distinct date_only
from transactions
where year(date_only) = 2022 and Transaction_count in (select max(Transaction_count)
														from transactions)

-- Q5 : Compare the average transaction value for each domain across all locations
select Domain ,floor(avg(Value)) as average_transaction_value
from transactions
group by Domain
order by average_transaction_value

-- Q6 : Identify any locations with a significant increase or decrease in transaction count compared to the previous month
with CTE_transactions_count as 
(
	select month(date_only) as the_month , Location , sum(Transaction_count) as total_count
	from transactions
	group by month(date_only) , Location
	--order by the_month
)
select distinct(a.Location) 
from CTE_transactions_count a , CTE_transactions_count b
where a.Location = b.Location and a.the_month = b.the_month-1 
	and (a.total_count-b.total_count >= 400000 or b.total_count-a.total_count >= 400000)

--Q7 : Are there any correlations between the domain type and the location of transactions
select a.Location , a.Domain , CAST(a.c AS DECIMAL(10,2))/b.c as ratio
from (select Location , Domain , count(Location) as c
		from transactions
		group by Location , Domain) a 
		inner join 
		(select Location , COUNT(Location) as c
		from transactions
		group by Location)b 
on a.Location = b.Location
order by ratio DESC

--Q8 :segment the transactions based on value (e.g., low, medium, high) and analyze their distribution across locations and domains
alter table transactions
add segment varchar(9)

UPDATE transactions
SET segment =
  CASE 
    WHEN Value < 600000 THEN 'Low'
    WHEN Value < 1000000 THEN 'Medium'
    ELSE 'High'
  END

select Location , Domain , segment , count(segment) as Number_of_segments
from transactions
group by Location , Domain , segment 
order by Location , Domain , segment 

--Q9 : identify seasonal trends in transaction value
select day , floor(avg(Value)) as average_value, sum(Value) as total_value 
from transactions
group by day
order by average_value desc

select month ,floor(avg(Value)) as average_value
from transactions
group by month
order by average_value desc

select day , floor(avg(Value)) as restaurant_average_value
from transactions
where Domain = 'RESTRAUNT'
group by day
order by restaurant_average_value desc

select month , floor(avg(Value)) as education_average_value
from transactions
where Domain = 'EDUCATION'
group by month
order by education_average_value desc

select month ,Domain ,floor(avg(Value)) as average_value
from transactions
group by month , Domain
order by average_value desc

select day ,Domain ,floor(avg(Value)) as average_value
from transactions
group by day , Domain
order by average_value desc

select Domain ,floor(avg(Value)) as average_value
from transactions
group by Domain
order by average_value desc
