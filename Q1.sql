WITH wages AS (
	SELECT DISTINCT
		year,
		industry,
		average_wage
	FROM t_angelika_kirchen_project_sql_primary_final
),
wages_comparison AS (
	SELECT
		year,
		industry,
		average_wage,
		LAG(average_wage) OVER (
			PARTITION BY industry
			ORDER BY year
		) AS previous_year_wage
	FROM wages
),
wages_growth AS (
	SELECT
		year,
		industry,
		average_wage,
		previous_year_wage,
		round(((average_wage - previous_year_wage) / previous_year_wage * 100)::numeric, 2) AS wage_growth
	FROM wages_comparison
)
SELECT *
FROM wages_growth
WHERE wage_growth < 0
ORDER BY year, industry;
