SELECT
	rok,
	kod_produktu,
	kategorie_potravin,
	round(avg(mzda) / avg(cena),0) AS pocet_nakup,
	jednotka
FROM t_tuan_anh_nguyen_project_sql_primary_final AS primary_final
WHERE kod_produktu IN ('111301', '114201') AND rok IN ('2006','2018')
GROUP BY rok, kategorie_potravin
ORDER BY kategorie_potravin, rok;