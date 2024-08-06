WITH nejnizsi AS (
SELECT
	rok,
	kod_produktu,
	kategorie_potravin,
	ROUND(avg(cena),2) AS prumerna_cena,
	round (((avg(cena) - lag(avg(cena),1) OVER (PARTITION BY kod_produktu ORDER BY rok)) / lag(avg(cena),1) OVER (PARTITION BY kod_produktu ORDER BY rok)) * 100,2) AS procentualni_zmena
FROM t_tuan_anh_nguyen_project_sql_primary_final AS primary_final
WHERE kod_produktu IS NOT NULL AND kategorie_potravin IS NOT NULL AND cena IS NOT null
GROUP BY rok, kod_produktu
ORDER BY kod_produktu, rok
)
SELECT
	rok,
	kod_produktu,
	kategorie_potravin,
	procentualni_zmena
FROM nejnizsi
WHERE procentualni_zmena IN (
							SELECT 
								min(procentualni_zmena)
							FROM nejnizsi
							WHERE procentualni_zmena > 0)
or procentualni_zmena IN (
							SELECT
								max(procentualni_zmena)
							FROM nejnizsi
							WHERE procentualni_zmena < 0);



-- nejnizsi prumerny percentualni narust za cele merene obdobi - FINALE 2

WITH zmena AS (
SELECT
	rok,
	kod_produktu,
	kategorie_potravin,
	ROUND(avg(cena),2) AS prumerna_cena,
	round (((avg(cena) - lag(avg(cena),1) OVER (PARTITION BY kod_produktu ORDER BY rok)) / lag(avg(cena),1) OVER (PARTITION BY kod_produktu ORDER BY rok)) * 100,2) AS procentualni_zmena
FROM t_tuan_anh_nguyen_project_sql_primary_final AS primary_final
WHERE kod_produktu IS NOT NULL AND kategorie_potravin IS NOT NULL AND cena IS NOT null
GROUP BY rok, kod_produktu
ORDER BY kod_produktu, rok
),
minimum AS (
SELECT
	rok,
	kod_produktu,
	kategorie_potravin,
	round(avg(procentualni_zmena),2) AS prumerna_procentualni_zmena
FROM zmena
GROUP BY kategorie_potravin)
SELECT
	rok,
	kod_produktu,
	kategorie_potravin,
	prumerna_procentualni_zmena
FROM minimum
WHERE prumerna_procentualni_zmena IN (
									SELECT 
										min(prumerna_procentualni_zmena)
									FROM minimum
									WHERE prumerna_procentualni_zmena > 0)
or prumerna_procentualni_zmena IN (
									SELECT 
										max(prumerna_procentualni_zmena)
									FROM minimum
									WHERE prumerna_procentualni_zmena < 0);