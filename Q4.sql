WITH wages AS (
	SELECT DISTINCT
		year,
		industry,
		average_wage
	FROM t_angelika_kirchen_project_sql_primary_final
),
prices AS (
	SELECT DISTINCT
		year,
		food_category,
		average_price
	FROM t_angelika_kirchen_project_sql_primary_final
),
yearly_data AS (
	SELECT
		w.year,
		avg(w.average_wage) AS average_wage,
		p.average_price
	FROM wages w
	JOIN (
		SELECT
			year,
			avg(average_price) AS average_price
		FROM prices
		GROUP BY year
	) p
		ON w.year = p.year
	GROUP BY
		w.year,
		p.average_price
),
comparison AS (
	SELECT
		year,
		average_wage,
		average_price,
		LAG(average_wage) OVER (ORDER BY year) AS previous_wage,
		LAG(average_price) OVER (ORDER BY year) AS previous_price
	FROM yearly_data
),
growth AS (
	SELECT
		year,
		round(((average_wage - previous_wage) / previous_wage * 100)::numeric, 2) AS wage_growth,
		round(((average_price - previous_price) / previous_price * 100)::numeric, 2) AS price_growth
	FROM comparison
)
SELECT
	year,
	wage_growth,
	price_growth,
	round(price_growth - wage_growth, 2) AS difference
FROM growth
WHERE price_growth - wage_growth > 10
ORDER BY year;
