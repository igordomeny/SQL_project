CREATE TABLE t_igor_domeny_project_SQL_secondary_final AS 
(
   SELECT
      e.year,
      c.country,
      c.population,
      e.gdp,
      round((e.gdp / c.population)::NUMERIC, 2) gdp_per_capita 
   FROM
      countries c 
      JOIN
         economies e 
         ON c.country = e.country 
   WHERE
      e.year BETWEEN 2006 AND 2018 
   ORDER BY
      c.country,
      e.year 
);

