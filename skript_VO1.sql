WITH mzdy_mezirocni AS 
(
   SELECT
      t.rok,
      t.industry_branch,
      AVG(t.prum_mzda) AS prum_mzda 
   FROM
      t_igor_domeny_project_sql_primary_final t 
   GROUP BY
      t.industry_branch,
      t.rok 
)
,
index_mzdy AS 
(
   SELECT
      rok,
      industry_branch,
      prum_mzda,
      LAG(prum_mzda) OVER (PARTITION BY industry_branch 
   ORDER BY
      rok) AS predchozi_mzda,
      prum_mzda / LAG(prum_mzda) OVER (PARTITION BY industry_branch 
   ORDER BY
      rok) AS index_mzda 
   FROM
      mzdy_mezirocni 
)
SELECT
   rok,
   industry_branch,
   ROUND(index_mzda, 2) AS index_mzda 
FROM
   index_mzdy 
WHERE
   index_mzda IS NOT NULL 
   AND index_mzda < 1 
ORDER BY
   industry_branch;