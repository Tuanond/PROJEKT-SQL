SELECT
	e.country,
	e.`year`,
	e.gdp,
	e.gini,
	e.population
FROM economies AS e 
JOIN countries AS c
	ON c.country = e.country
WHERE c.continent = 'Europe' AND e.`year` BETWEEN '2000' AND '2020'
ORDER BY e.country, e.`year`;