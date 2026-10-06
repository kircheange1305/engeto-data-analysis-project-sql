WITH wages AS (
	SELECT DISTINCT
		year,
		industry,
		average_wage
	FROM t_angelika_kirchen_project_sql_primary_final
),
average_wages AS (
	SELECT
		year,
		avg(average_wage) AS average_wage
	FROM wages
	WHERE year IN (2006, 2018)
	GROUP BY year
),
prices AS (
	SELECT DISTINCT
		year,
		food_category,
		average_price
	FROM t_angelika_kirchen_project_sql_primary_final
	WHERE food_category IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
		AND year IN (2006, 2018)
)
SELECT
	p.year,
	p.food_category,
	round(aw.average_wage::numeric, 2) AS average_wage,
	round(p.average_price::numeric, 2) AS average_price,
	round((aw.average_wage / p.average_price)::numeric, 2) AS amount
FROM prices p
JOIN average_wages aw
	ON p.year = aw.year
ORDER BY p.year, p.food_category;
