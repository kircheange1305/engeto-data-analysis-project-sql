CREATE TABLE t_angelika_kirchen_project_sql_secondary_final AS
SELECT
    e.country,
    e.year,
    e.gdp,
    e.gini,
    e.population
FROM economies e
JOIN countries c
    ON e.country = c.country
WHERE c.continent = 'Europe'
    AND e.year BETWEEN 2006 AND 2018
ORDER BY
    e.country,
    e.year;
