SELECT
   t.rok,
   t.kategorie,
   ROUND(AVG(t.prum_mzda) / AVG(t.prum_cena), 2) vysledok 
FROM
   t_igor_domeny_project_sql_primary_final t 
GROUP BY
   t.rok,
   t.kategorie 
HAVING
   t.rok IN 
   (
      2006,
      2018
   )
   AND 
   (
      t.kategorie LIKE 'Mléko%' 
      OR t.kategorie LIKE 'Chl%'
   )
ORDER BY
   t.rok;
