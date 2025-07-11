WITH agregovane AS 
(
   SELECT
      t.rok,
      AVG(t.prum_cena) AS prum_cena,
      AVG(t.prum_mzda) AS prum_mzda 
   FROM
      t_igor_domeny_project_sql_primary_final t 
   GROUP BY
      rok 
)
,
ekonom_indexy AS 
(
   SELECT
      rok,
      prum_cena,
      prum_mzda,
      LAG(prum_cena) OVER (
   ORDER BY
      rok) AS predchozi_cena,
      LAG(prum_mzda) OVER (
   ORDER BY
      rok) AS predchozi_mzda,
      prum_cena / LAG(prum_cena) OVER (
   ORDER BY
      rok) AS index_cena,
      prum_mzda / LAG(prum_mzda) OVER (
   ORDER BY
      rok) AS index_mzda 
   FROM
      agregovane 
)
,
hdp_index AS 
(
   SELECT
      t1.year AS rok,
      t1.gdp_per_capita,
      LAG(t1.gdp_per_capita) OVER (
   ORDER BY
      t1.year) AS predchozi_hdp,
      t1.gdp_per_capita / LAG(t1.gdp_per_capita) OVER (
   ORDER BY
      t1.year) AS index_hdp 
   FROM
      t_igor_domeny_project_sql_secondary_final t1 
   WHERE
      t1.country = 'Czech Republic' 
)
SELECT
   e.rok,
   ROUND(e.index_cena, 2) AS index_cena,
   ROUND(e.index_mzda, 2) AS index_mzda,
   ROUND(h.index_hdp, 2) AS index_hdp 
FROM
   ekonom_indexy e 
   JOIN
      hdp_index h 
      ON e.rok = h.rok 
WHERE
   e.index_cena IS NOT NULL 
   AND e.index_mzda IS NOT NULL 
   AND h.index_hdp IS NOT NULL 
ORDER BY
   e.rok;