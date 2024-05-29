

-- 1)Fetch all painting which are not displayed in any museum

SELECT * FROM "work" w  
WHERE museum_id IS NULL;

-- 2)Are there museum without any paintings

SELECT m."name"  FROM museum m 
RIGHT JOIN "work" w using(museum_id)
WHERE  w.work_id IS null;

-- 3)how many paintings have an asking price more than regular price

SELECT count(ps.work_id) AS "No.of paintings" FROM product_size ps 
WHERE ps.sale_price > ps.regular_price;

-- 4)paintings with price less than 50% of their regular price

SELECT * FROM product_size ps 
WHERE ps.sale_price < (ps.regular_price/2);

-- 5)expensive canvas size

SELECT c.size_id FROM canvas_size c
JOIN product_size ps ON c.size_id =ps.size_id ::int
WHERE ps.sale_price=(SELECT max(ps2.sale_price) FROM product_size ps2);

-- 6)Identify the museums with invalid city information in the given dataset

SELECT city 
FROM museum
WHERE NOT city ~* '^[a-z\u00C0-\u017F -.]+$' OR city IS NULL;

-- 7)Top 10 most famous painting subject

SELECT DISTINCT s.subject, count(s.subject) FROM subject s
GROUP BY s.subject 
ORDER BY count DESC 
LIMIT 10;

-- 8)Identify the museums which are open on both Sunday and Monday. Display museum name, city

SELECT m."name" ,m.city FROM museum m JOIN museum_hours mh USING(museum_id)
WHERE mh."day" ~* 'sunday' AND 
	EXISTS(
		SELECT 1 FROM museum_hours mh2 
		WHERE mh2."day" ~* 'monday' AND mh.museum_id = mh2.museum_id);
	
	
	
-- 9)How many museums are open every single day?

SELECT count(total) FROM  
	(SELECT museum_id ,count(museum_id) total FROM museum_hours mh  
	GROUP BY museum_id )
WHERE total = 7;

-- 10)Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)

SELECT w.museum_id,m."name", count(w.work_id) FROM "work" w 
JOIN museum m USING(museum_id)
GROUP BY w.museum_id,m."name"
ORDER BY count DESC  
LIMIT 5;

-- 11)Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)

SELECT a.full_name,a.nationality ,count(work_id) AS "No of paintings" FROM artist a 
JOIN "work" w USING(artist_id) 
GROUP BY  a.full_name,a.nationality
ORDER BY "No of paintings" DESC 
LIMIT 5;  


-- 12)Which museum is open for the longest during a day. Dispay museum name, state and hours open and which day?

SELECT m."name" ,m.state ,to_timestamp(mh."close",'HH12:MI PM')-to_timestamp(mh."open",'HH12:MI AM') hours_open ,mh."day" 
FROM museum_hours mh JOIN museum m USING(museum_id)
ORDER BY hours_open DESC
LIMIT 1;

-- 13)Which museum has the most no of popular painting style?

SELECT m."name",count("style") FROM "work" w 
JOIN museum m USING(museum_id)
GROUP BY  m."name"
ORDER BY count DESC
LIMIT 1;

-- 14)Identify the artists whose paintings are displayed in multiple countries

select * FROM 
	(SELECT a.artist_id,a.full_name ,count(museum_id) FROM "work" w JOIN museum m using(museum_id)
	JOIN artist a using(artist_id)
	GROUP BY a.artist_id,a.full_name)
WHERE count>1
ORDER BY count; 	

--15)Which country has the 5th highest no of paintings?

SELECT m.country, count(w.work_id) FROM museum m 
JOIN "work" w using(museum_id)
GROUP BY m.country 
ORDER BY count DESC 
OFFSET 4
LIMIT 1;

--16)Which are the 3 most popular and 3 least popular painting styles?

(SELECT w."style" ,count(w."style") popularity FROM "work" w
GROUP BY w."style" having w."style"  IS NOT NULL ORDER BY popularity 
LIMIT 3)
UNION 
(SELECT w."style" ,count(w."style") popularity FROM "work" w
GROUP BY w."style" having w."style"  IS NOT NULL ORDER BY popularity desc 
LIMIT 3)
ORDER BY popularity ;

--17) Museum hours table has invalid entry ,identify & remove it

SELECT * FROM museum_hours mh 
WHERE "day" IS NULL OR 
"open" IS NULL OR 
"close" IS NULL OR 
"day" NOT IN ('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');

UPDATE museum_hours 
SET "day" = 'Thursday'
WHERE "day" ='Thusday'
RETURNING * ;

--18)Which artist has the most no of Portraits paintings outside USA?
--Display artist name, no of paintings and the artist nationality

SELECT p.full_name,count(p.subject) "No.of Paintings",p.nationality from
	(SELECT * FROM artist a JOIN "work" w USING(artist_id)
	JOIN museum m using(museum_id)
	JOIN subject s using(work_id)
	WHERE s.subject ~ 'Portraits' AND 
	m.country !='USA')AS p
GROUP BY p.full_name,p.nationality
ORDER BY "No.of Paintings" DESC 
LIMIT 1;

--19)isplay 3 least popular canvas sizes

SELECT DISTINCT cs.*,ps.sale_price  FROM canvas_size cs JOIN product_size ps ON cs.size_id=ps.size_id::int
ORDER BY ps.sale_price
LIMIT 3;

/* 20)Identify the artist and the museum where the most expensive and least expensive
painting is placed. Display the artist name, sale_price, painting name, museum
name, museum city and canvas LABEL*/


with cte AS (
	SELECT a.full_name AS artist_name,ps.sale_price,w.name AS painting_name,m.name AS museum_name ,m.city,cs."label",
	ROW_NUMBER() OVER(ORDER BY ps.sale_price ) row1,
	ROW_NUMBER() OVER(ORDER BY ps.sale_price DESC ) row2
	FROM product_size ps JOIN "work" w using(work_id)
	JOIN museum m USING(museum_id)
	JOIN artist a using(artist_id)
	JOIN canvas_size cs ON cs.size_id=ps.size_id::int)
SELECT * FROM cte
WHERE cte.row2=1 OR cte.row1 =1;


/* 21)Display the country and the city with most no of museums. 
 Output 2 seperate columns to mention the city and country. If there are multiple value, seperate them with comma.*/

with cte_country AS (
		SELECT country,count(country),
		RANK() over(ORDER BY count(country) desc) AS country_rnk
		FROM museum m
		GROUP BY country),
	cte_city AS (
		SELECT city,count(city),
		RANK() over(ORDER BY count(city) desc) AS city_rank
		FROM museum m
		GROUP BY city)
SELECT string_agg(DISTINCT country,',') country, string_agg(city,',') city
FROM cte_country
CROSS JOIN cte_city
WHERE country_rnk =1 AND city_rank=1
