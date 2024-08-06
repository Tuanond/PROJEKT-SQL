CREATE TABLE t_Tuan_Anh_Nguyen_project_SQL_primary_final AS
SELECT
	cpay.payroll_year AS rok,
	cpib.code AS kod_odvetvi,
	cpib.name AS odvetvi,
	cpay.value AS mzda,
	cp.category_code AS kod_produktu,
	cpc.name AS kategorie_potravin,
	cp.value AS cena,
	cpc.price_value,
	cpc.price_unit AS jednotka
FROM czechia_payroll AS cpay 
LEFT JOIN czechia_price AS cp
	ON cpay.payroll_year = year(cp.date_from)
LEFT JOIN czechia_price_category AS cpc 
	ON cp.category_code = cpc.code 
LEFT JOIN czechia_payroll_industry_branch AS cpib 
	ON cpay.industry_branch_code  = cpib.code 
WHERE cpay.value_type_code = '5958';