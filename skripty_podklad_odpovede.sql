WITH mzdy_mezirocni AS (
SELECT
t.rok,
t.industry_branch,
AVG(t.prum_mzda) AS prum_mzda
FROM t_igor_domeny_project_sql_primary_final t
GROUP BY t.industry_branch,t.rok
),
index_mzdy AS (
SELECT
rok,
industry_branch ,
prum_mzda ,
LAG(prum_mzda) OVER (partition by industry_branch ORDER BY rok) AS predchozi_mzda,
prum_mzda/ LAG(prum_mzda) OVER (partition by industry_branch ORDER BY rok) AS index_mzda
FROM mzdy_mezirocni
)
SELECT
rok,
industry_branch,
ROUND(index_mzda, 2) AS index_mzda
FROM index_mzdy
WHERE index_mzda IS NOT null and index_mzda <1
ORDER BY industry_branch;

select 
t.rok,
t.kategorie ,
round(avg(t.prum_mzda)/avg(t.prum_cena),2) vysledok
from t_igor_domeny_project_sql_primary_final t 
group by t.rok, t.kategorie
having t.rok in (2006,2018) and (t.kategorie like 'Mléko%' or t.kategorie like 'Chl%')
order by t.rok;

select 
t2.kategorie,
AVG(t2.mezirocni_index) AS avg_mezirocni_index
FROM (
SELECT 
t.kategorie,
t.rok,
t.prum_cena,
LAG(t.prum_cena) OVER (PARTITION BY t.kategorie ORDER BY t.rok) AS predchozi_rok,
ROUND(t.prum_cena / LAG(t.prum_cena) OVER (PARTITION BY t.kategorie ORDER BY t.rok), 2) AS mezirocni_index
FROM (
SELECT 
t1.rok,
t1.kategorie,
AVG(t1.prum_cena) AS prum_cena
FROM t_igor_domeny_project_sql_primary_final t1
GROUP BY t1.rok, t1.kategorie
) t
) t2
GROUP BY t2.kategorie
ORDER BY avg_mezirocni_index desc;

WITH agregovane AS (
SELECT
t.rok,
AVG(t.prum_cena) AS prum_cena,
AVG(t.prum_mzda) AS prum_mzda
FROM t_igor_domeny_project_sql_primary_final t
GROUP BY rok
),
ekonom_indexy AS (
SELECT
rok,
prum_cena,
prum_mzda,
LAG(prum_cena) OVER (ORDER BY rok) AS predchozi_cena,
LAG(prum_mzda) OVER (ORDER BY rok) AS predchozi_mzda,
prum_cena / LAG(prum_cena) OVER (ORDER BY rok) AS index_cena,
prum_mzda / LAG(prum_mzda) OVER (ORDER BY rok) AS index_mzda
FROM agregovane
),
hdp_index AS (
SELECT
t1."year" AS rok,
t1.gdp_per_capita,
LAG(t1.gdp_per_capita) OVER (ORDER BY t1."year") AS predchozi_hdp,
t1.gdp_per_capita / LAG(t1.gdp_per_capita) OVER (ORDER BY t1."year") AS index_hdp
FROM t_igor_domeny_project_sql_secondar_final t1
WHERE t1.country = 'Czech Republic'
)
SELECT
e.rok,
ROUND(e.index_cena, 2) AS index_cena,
ROUND(e.index_mzda, 2) AS index_mzda,
ROUND(h.index_hdp, 2) AS index_hdp
FROM ekonom_indexy e
JOIN hdp_index h ON e.rok = h.rok
WHERE e.index_cena IS NOT NULL AND e.index_mzda IS NOT NULL AND h.index_hdp IS NOT NULL
ORDER BY e.rok; 