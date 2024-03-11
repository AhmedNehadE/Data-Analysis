--Data analysis by sql for https://www.kaggle.com/datasets/abdulmajid115/yelp-dataset-contains-1-million-rows

select *
from reviewss

--#######################################Answering Questions#############################################

--Q1: Are there any significant differences in rating distribution by category?
select Category ,  Count(Category) as total_number
from reviews
group by Category
order by total_number DESC

--Q2: How many businesses have a phone number listed?
select count(Distinct Organization)
from reviews 
where Phone is not null 

--number of businesses without a phone number listed
select count(Distinct Organization)
from reviews 
where Phone is null 

--Q3:Which countries do you are in the data?
select Distinct Country
from reviews

select count(*)
from reviews
where Country is null
--we have only one country so the column is useless

ALTER table reviews
DROP column Country , CountryCode

--Q4: How many businesses have zero reviews? What percentage is this of the total?
-- delete al the records which has zero number of reviews
delete
from reviews
where NumberReview = 0

 
select count(*)
from reviews
where Rating = 0

--Q5: What is the average star rating for all businesses? How does this vary by category?
select avg(Rating)
from reviews

select Category , avg(Rating) as Average_Rating
from reviews
group by Category
order by Average_Rating DESC

--Q6: identify the average rating based on overall sentiment (positive, negative)?

alter table reviews
add overall_sentiment varchar(20)

update reviews
set overall_sentiment =
CASE 
	WHEN Rating > 3 THEN 'Positive'
	ELSE 'Negative'
END

select overall_sentiment , avg(Rating) as Average_Rating
from reviews
group by overall_sentiment
order by Average_Rating DESC


--Q7: Do businesses with a higher number of reviews tend to have higher or lower average ratings

select Distinct Organization , SUM(NumberReview) as total_number_reviews, AVG(Rating) as average_rating
from reviews
group by Organization
order by total_number_reviews DESC

--