-- Task 1
SELECT SUM(i.INDEX_LENGTH) / SUM(i.DATA_LENGTH) * 100 AS 'Percentage ratio'
FROM information_schema.TABLES AS i
WHERE table_schema = "sakila";

-- Task 2
EXPLAIN
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id;

-- Weak points
-- 1	SIMPLE	f		index		Using index; Using temporary; Using filesort
-- 1	SIMPLE	p		ALL			Using where; Using join buffer (hash join)
-- 1	SIMPLE	r		ref	    	Using index
-- 1	SIMPLE	c		eq_ref
-- 1	SIMPLE	i		eq_ref		Using index

-- 
EXPLAIN ANALYZE
SELECT c.last_name 'Lastname', c.first_name 'Name', sum(p.amount) 'Sum'
FROM payment p
JOIN rental r ON p.payment_date = r.rental_date
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE date(p.payment_date) = '2005-07-30'
GROUP BY c.customer_id;
