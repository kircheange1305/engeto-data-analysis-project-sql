WITH prices AS (
	SELECT DISTINCT
		year,
		food_category,
		average_price
	FROM t_angelika_kirchen_project_sql_primary_final
),
prices_comparison AS (
	SELECT
		year,
		food_category,
		average_price,
		LAG(average_price) OVER (
			PARTITION BY food_category
			ORDER BY year
		) AS previous_year_price
	FROM prices
),
price_growth AS (
	SELECT
		year,
		food_category,
		round(((average_price - previous_year_price) / previous_year_price * 100)::numeric, 2) AS growth
	FROM prices_comparison
)
SELECT
	food_category,
	round(avg(growth), 2) AS average_growth
FROM price_growth
WHERE growth IS NOT NULL
GROUP BY food_category
ORDER BY average_growth;
