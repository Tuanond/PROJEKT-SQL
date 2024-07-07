-- Výzkumné otázky
-- 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

-- průměrné ceny produktů + průměrná mzda (2006, 2018)
SELECT 
	rok,
	kod_produktu,
	kategorie_potravin,
	round(avg(cena),2) AS prumerna_cena,
	round(avg(mzda),0) AS prumerny_plat
FROM t_tuan_anh_nguyen_project_sql_primary_final AS primary_final
WHERE kod_produktu IN ('111301', '114201') AND rok IN ('2006','2018')
GROUP BY rok, kategorie_potravin
ORDER BY kategorie_potravin, rok;


-- finale
SELECT 
	rok,
	kod_produktu,
	kategorie_potravin,
	round(mzda / cena,0) AS pocet_nakup,
	jednotka
FROM t_tuan_anh_nguyen_project_sql_primary_final AS primary_final
WHERE kod_produktu IN ('111301', '114201') AND rok IN ('2006','2018')
GROUP BY rok, kategorie_potravin
ORDER BY kategorie_potravin, rok;


