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
yearly_wages AS (
	SELECT
		year,
		avg(average_wage) AS average_wage
	FROM wages
	GROUP BY year
),
yearly_prices AS (
	SELECT
		year,
		avg(average_price) AS average_price
	FROM prices
	GROUP BY year
),
yearly_data AS (
	SELECT
		w.year,
		w.average_wage,
		p.average_price,
		e.gdp
	FROM yearly_wages w
	JOIN yearly_prices p
		ON w.year = p.year
	JOIN t_angelika_kirchen_project_sql_secondary_final e
		ON w.year = e.year
	WHERE e.country = 'Czech Republic'
),
comparison AS (
	SELECT
		year,
		average_wage,
		average_price,
		gdp,
		LAG(average_wage) OVER (ORDER BY year) AS previous_wage,
		LAG(average_price) OVER (ORDER BY year) AS previous_price,
		LAG(gdp) OVER (ORDER BY year) AS previous_gdp
	FROM yearly_data
)
SELECT
	year,
	round(((gdp - previous_gdp) / previous_gdp * 100)::numeric, 2) AS gdp_growth,
	round(((average_wage - previous_wage) / previous_wage * 100)::numeric, 2) AS wage_growth,
	round(((average_price - previous_price) / previous_price * 100)::numeric, 2) AS price_growth
FROM comparison
ORDER BY year;
