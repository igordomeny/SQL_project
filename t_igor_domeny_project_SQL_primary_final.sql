CREATE TABLE t_igor_domeny_project_SQL_primary_final AS 
(
   SELECT
      cp2.payroll_year rok,
      cpc.name kategorie,
      ROUND(AVG(cp.VALUE)::NUMERIC, 2) prum_cena,
      cpib.name industry_branch,
      ROUND(AVG(cp2.VALUE)::NUMERIC, 0) prum_mzda 
   FROM
      czechia_price cp 
      JOIN
         czechia_price_category cpc 
         ON cp.category_code = cpc.code 
      JOIN
         czechia_payroll cp2 
         ON EXTRACT(YEAR 
   FROM
      (
         cp.date_from 
      )
) = cp2.payroll_year 
      LEFT JOIN
         czechia_payroll_calculation cpc2 
         ON cp2.calculation_code = cpc2.code 
      JOIN
         czechia_payroll_industry_branch cpib 
         ON cp2.industry_branch_code = cpib.code 
   WHERE
      cp2.VALUE IS NOT NULL 
      AND cp2.value_type_code = 5958 
      AND cp2.calculation_code = 100 
   GROUP BY
      cpc.name,
      cpib.name,
      cp2.payroll_year 
   ORDER BY
      cp2.payroll_year
);