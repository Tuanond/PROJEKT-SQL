-- Výzkumná otázka č. 1
-- 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?


SELECT
	rok,
	kod_odvetvi,
	odvetvi,
	ROUND(avg(mzda),0) AS prumerna_rocni_mzda,
	ROUND(((avg(mzda) - lag(avg(mzda),1) OVER (PARTITION BY odvetvi ORDER BY rok)) / lag(avg(mzda),1) OVER (PARTITION BY odvetvi ORDER BY rok)) * 100,2) AS mezirocni_procentualni_rust,
	IF ((avg(mzda) - lag(avg(mzda),1) OVER (PARTITION BY odvetvi ORDER BY rok)) > 0, 1, 0) AS flag
FROM t_Tuan_Anh_Nguyen_project_SQL_primary_final
WHERE odvetvi IS NOT null
GROUP BY rok, odvetvi
ORDER BY odvetvi, rok;


-- Snížení mezd - Roky, kde došlo ke snížení platu

WITH mezirocni_rust AS (
SELECT
	rok,
	kod_odvetvi,
	odvetvi,
	ROUND(avg(mzda),0) AS prumerna_rocni_mzda,
	IF ((avg(mzda) - lag(avg(mzda),1) OVER (PARTITION BY odvetvi ORDER BY rok)) > 0, 1, 0) AS flag
FROM t_Tuan_Anh_Nguyen_project_SQL_primary_final
WHERE odvetvi IS NOT NULL AND rok != 2000
GROUP BY rok, odvetvi
ORDER BY odvetvi, rok
)
SELECT *
FROM mezirocni_rust
WHERE flag = '0';



