SELECT
   t2.kategorie,
   AVG(t2.mezirocni_index) AS avg_mezirocni_index 
FROM
   (
      SELECT
         t.kategorie,
         t.rok,
         t.prum_cena,
         LAG(t.prum_cena) OVER (PARTITION BY t.kategorie 
      ORDER BY
         t.rok) AS predchozi_rok,
         ROUND(t.prum_cena / LAG(t.prum_cena) OVER (PARTITION BY t.kategorie 
      ORDER BY
         t.rok), 2) AS mezirocni_index 
      FROM
         (
            SELECT
               t1.rok,
               t1.kategorie,
               AVG(t1.prum_cena) AS prum_cena 
            FROM
               t_igor_domeny_project_sql_primary_final t1 
            GROUP BY
               t1.rok,
               t1.kategorie 
         )
         t 
   )
   t2 
GROUP BY
   t2.kategorie 
ORDER BY
   avg_mezirocni_index DESC;