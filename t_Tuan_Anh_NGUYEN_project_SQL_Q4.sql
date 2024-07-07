-- Výzkumná otázka č. 4
-- 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

-- FINALE
WITH rozdil_cen_mezd AS (
SELECT
	rok,
	round(avg(mzda),0) AS prumerna_mzda,
	round(((avg(mzda) - lag(avg(mzda),1) OVER (PARTITION BY odvetvi ORDER BY rok)) / lag(avg(mzda),1) OVER (PARTITION BY odvetvi ORDER BY rok) * 100),2) AS rozdil_mezd,
	round(avg(cena),2) AS prumerna_cena,
	round(((avg(cena) - lag(avg(cena),1) OVER (PARTITION BY odvetvi ORDER BY rok)) / lag(avg(cena),1) OVER (PARTITION BY odvetvi ORDER BY rok) * 100),2) AS rozdil_cen
FROM t_tuan_anh_nguyen_project_sql_primary_final AS primary_finale
GROUP BY rok
)
	SELECT
		*,
		rozdil_cen - rozdil_mezd AS rozdil_cen_od_mezd
	FROM rozdil_cen_mezd
	WHERE rozdil_cen IS NOT null;