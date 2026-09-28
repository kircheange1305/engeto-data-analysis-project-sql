SELECT
	prices.year,
	prices.food_category,
	prices.price_value,
	prices.price_unit,
	prices.average_price,
	wages.industry,
	wages.average_wage
FROM (
	SELECT
		date_part('year', cp.date_from) AS year,
		cpc.name AS food_category,
		cpc.price_value,
		cpc.price_unit,
		avg(cp.value) AS average_price
	FROM
		czechia_price cp
	JOIN czechia_price_category cpc
		ON cp.category_code = cpc.code
	WHERE
		date_part('year', cp.date_from) BETWEEN 2006 AND 2018
	GROUP BY
		date_part('year', cp.date_from),
		cpc.name,
		cpc.price_value,
		cpc.price_unit
) AS prices
JOIN (
	SELECT
		cp.payroll_year AS year,
		cpib.name AS industry,
		avg(cp.value) AS average_wage
	FROM
		czechia_payroll cp
	JOIN czechia_payroll_industry_branch cpib
		ON cp.industry_branch_code = cpib.code
	WHERE
		cp.value_type_code = 5958
		AND cp.unit_code = 200
		AND cp.calculation_code = 200
		AND cp.payroll_year BETWEEN 2006 AND 2018
	GROUP BY
		cp.payroll_year,
		cpib.name
) AS wages
	ON prices.year = wages.year
ORDER BY
	prices.year,
	prices.food_category,
	wages.industry;
