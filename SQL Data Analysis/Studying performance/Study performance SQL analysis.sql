--################## Group 1 (Basic info)

--Q1: What is the gender distribution of the students?
--By using temp table
CREATE TABLE #Gender_dist(
	gender varchar(10), 
	total_number int
)

insert into #Gender_dist
select gender , count(*)
from study_performance
group by gender

select gender , round(CAST(total_number as float) / (select sum(total_number) from #Gender_dist) , 3)
from #Gender_dist

drop TABLE if exists #Gender_dist

--Q2: How many students are in each group (B, C, etc.)?
select race_ethnicity , count(*) as total
from study_performance
group by race_ethnicity
order by total DESC

--Q3: What are the most common levels of parental education (e.g., high school diploma, bachelor's degree)?
select parental_level_of_education , count(*) as total
from study_performance
group by parental_level_of_education
order by total DESC

--Q4: How many students participated in lunch programs (standard vs. other)?
select lunch , count(*) as total
from study_performance
group by lunch
order by total DESC

--Q5: How many students took a test preparation course (completed vs. none)?
select test_preparation_course , count(*) as total
from study_performance
group by test_preparation_course
order by total DESC

--#########################Group 2 (Standardized Test Performance)
--Q6: Is there a correlation between gender and overall test score (average of math, reading, writing)?
select gender , avg(math_score + reading_score + writing_score) as average_total_score
,min(math_score + reading_score + writing_score) as min_total_score
,max(math_score + reading_score + writing_score) as max_total_score
from study_performance
group by gender 
order by average_total_score DESC

--Q7: Do students from different racial/ethnic backgrounds have statistically significant differences in average test scores?
select race_ethnicity , avg(math_score + reading_score + writing_score) as average_total_score
,min(math_score + reading_score + writing_score) as min_total_score
,max(math_score + reading_score + writing_score) as max_total_score
from study_performance
group by race_ethnicity 
order by average_total_score DESC

--Q8: What is the average test score for each subject (math, reading, writing)?
select avg(math_score) as avg_math , avg(reading_score) as avg_reading, avg(writing_score) as avg_writing
from study_performance

--Q9: Is there a relationship between parental education level and student test scores?
select parental_level_of_education , avg(math_score + reading_score + writing_score) as average_total_score
,min(math_score + reading_score + writing_score) as min_total_score
,max(math_score + reading_score + writing_score) as max_total_score
from study_performance
group by parental_level_of_education 
order by average_total_score DESC

--Q10: Do students who participate in lunch programs perform differently on standardized tests on average?
select lunch , avg(math_score + reading_score + writing_score) as average_total_score
,min(math_score + reading_score + writing_score) as min_total_score
,max(math_score + reading_score + writing_score) as max_total_score
from study_performance
group by lunch 
order by average_total_score DESC

--Q11: Do students who take test preparation courses score higher on average than those who don't?
select test_preparation_course , avg(math_score + reading_score + writing_score) as average_total_score
,min(math_score + reading_score + writing_score) as min_total_score
,max(math_score + reading_score + writing_score) as max_total_score
from study_performance
group by test_preparation_course 
order by average_total_score DESC

--Q12: represent the distribution of students over each category based on their total score (Excellent , very good , good , poor , fail)?
alter table study_performance
add overall_degree varchar(20)

update study_performance
set overall_degree = 
CASE
	WHEN (math_score + reading_score + writing_score) > 255 THEN 'Excellent'
	WHEN (math_score + reading_score + writing_score) > 210 THEN 'Very Good'
	WHEN (math_score + reading_score + writing_score) > 180 THEN 'Good'
	WHEN (math_score + reading_score + writing_score) > 150 THEN 'Poor'
	ELSE 'Fail'
END

select overall_degree , count(*) as total_students
from study_performance
group by overall_degree
order by total_students DESC

