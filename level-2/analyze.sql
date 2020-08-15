-- provide the counts of all the tables
select count(*) from products;
-- 91593
select count(*) from customers;
-- 1135459

select count(*) from review_id_table;
-- 1890972

select count(*) from vine_table;
-- 1890972

-- Identify customers who have over 100 reviews.....consider that too many and remove them
CREATE TEMPORARY TABLE removed_reviews_from_overactive_customers(
   review_id text
);

CREATE TEMPORARY TABLE customers_that_provide_helpful_reviews(
   customer_id text
);

insert into removed_reviews_from_overactive_customers (review_id)
select review_id
from review_id_table t1
join customers c on t1.customer_id = c.customer_id
where c.customer_count >= 100;

select count(*) 
from removed_reviews_from_overactive_customers;
-- 17702

-- Identify counts of vine text
select vine, count(*)
from vine_table
group by vine
-- vine as a percentage is so infrequently used it is not valueable

-- identify average of helpful hints that a reviewer has
delete from customers_that_provide_helpful_reviews;
insert into customers_that_provide_helpful_reviews (customer_id)
select t1.customer_id
from (
select c.customer_id, avg(t1.helpful_votes) avg_helpful_votes
from vine_table t1
join review_id_table t2 on t1.review_id = t2.review_id
join customers c on t2.customer_id = c.customer_id 
group by c.customer_id) t1
where t1.avg_helpful_votes >= 5;

select count(*)
from customers_that_provide_helpful_reviews;
-- 106900




