-- Výzkumná otázka č. 5
-- 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
-- projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

SELECT *
FROM economies AS e
WHERE country = 'Czech republic';

-- celkovy prumerny mezirocni rust GDP (vysledek = 1.82)
WITH mezirocni_GDP AS (
SELECT
	`year` ,
	country,
	round(((GDP-lag(GDP) OVER (PARTITION BY country ORDER BY `year`)) / lag(GDP) OVER (PARTITION BY country ORDER BY `year`)) * 100,2) AS mezirocni_rozdil_GDP
FROM economies AS e
GROUP BY country, `year`
)
SELECT
	country,
	round(avg(mezirocni_rozdil_GDP),2) AS prumerny_mezirocni_rust_GDP
FROM mezirocni_GDP
WHERE country = 'Czech republic'
								

-- mezirocni rust
SELECT
	pf.rok,
	ROUND(((avg(e.GDP)-lag(avg(e.GDP),1) OVER (ORDER BY pf.rok)) / lag(avg(e.GDP),1) OVER (ORDER BY pf.rok)) * 100,2) AS mezirocni_rozdil_GPD,
	ROUND(((avg(pf.mzda)-lag(avg(pf.mzda),1) OVER (ORDER BY pf.rok)) / lag(avg(pf.mzda),1) OVER (ORDER BY pf.rok)) * 100,2) AS mezirocni_rozdil_mezd,
	ROUND(((avg(pf.cena)-lag(avg(pf.cena),1) OVER (ORDER BY pf.rok)) / lag(avg(pf.cena),1) OVER (ORDER BY pf.rok)) * 100,2) AS mezirocni_rozdil_cen
FROM t_tuan_anh_nguyen_project_sql_primary_final AS pf
LEFT JOIN economies AS e
	ON pf.rok = e.`year` 
WHERE country = 'Czech republic' 
GROUP BY pf.rok;

-- FINALE - porovnání ve stejném roce
								
WITH GDP_mzda_cena AS (
SELECT
	pf.rok,
	ROUND(((avg(e.GDP)-lag(avg(e.GDP),1) OVER (ORDER BY pf.rok)) / lag(avg(e.GDP),1) OVER (ORDER BY pf.rok)) * 100,2) AS mezirocni_rozdil_GPD,
	ROUND(((avg(pf.mzda)-lag(avg(pf.mzda),1) OVER (ORDER BY pf.rok)) / lag(avg(pf.mzda),1) OVER (ORDER BY pf.rok)) * 100,2) AS mezirocni_rozdil_mezd,
	ROUND(((avg(pf.cena)-lag(avg(pf.cena),1) OVER (ORDER BY pf.rok)) / lag(avg(pf.cena),1) OVER (ORDER BY pf.rok)) * 100,2) AS mezirocni_rozdil_cen
FROM t_tuan_anh_nguyen_project_sql_primary_final AS pf
LEFT JOIN economies AS e
	ON pf.rok = e.`year` 
WHERE country = 'Czech republic' 
GROUP BY pf.rok
)
		SELECT
			*
		FROM GDP_mzda_cena
		WHERE mezirocni_rozdil_cen IS NOT null
		AND mezirocni_rozdil_GPD > 1.82
		AND (mezirocni_rozdil_cen > 1.82 
		OR mezirocni_rozdil_mezd > 1.82);


-- FINALE_2 - porovnání GDP s následujícím rokem mezd a cen

	WITH GDP_mzda_cena AS (
SELECT
	pf.rok,
	ROUND(((avg(e.GDP)-lag(avg(e.GDP),1) OVER (ORDER BY pf.rok)) / lag(avg(e.GDP),1) OVER (ORDER BY pf.rok)) * 100,2) AS mezirocni_rozdil_GPD,
	ROUND(((avg(pf.mzda)-lag(avg(pf.mzda),1) OVER (ORDER BY pf.rok)) / lag(avg(pf.mzda),1) OVER (ORDER BY pf.rok)) * 100,2) AS mezirocni_rozdil_mezd,
	ROUND(((avg(pf.cena)-lag(avg(pf.cena),1) OVER (ORDER BY pf.rok)) / lag(avg(pf.cena),1) OVER (ORDER BY pf.rok)) * 100,2) AS mezirocni_rozdil_cen
FROM t_tuan_anh_nguyen_project_sql_primary_final AS pf
LEFT JOIN economies AS e
	ON pf.rok = e.`year` 
WHERE country = 'Czech republic' 
GROUP BY pf.rok
), nasledujici_rok AS 
(
		SELECT
			*,
			lead(mezirocni_rozdil_mezd,1) OVER (ORDER BY rok) AS nasledujici_rok_mezd,
			lead(mezirocni_rozdil_cen,1) OVER (ORDER BY rok) AS nasledujici_rok_ceny
		FROM GDP_mzda_cena)
					SELECT
						rok,
						mezirocni_rozdil_GPD,
						nasledujici_rok_mezd,
						nasledujici_rok_ceny
					FROM nasledujici_rok
				WHERE nasledujici_rok_ceny IS NOT NULL
				AND mezirocni_rozdil_GPD > 1.82
				AND (nasledujici_rok_ceny > 1.82
				OR nasledujici_rok_mezd > 1.82);
