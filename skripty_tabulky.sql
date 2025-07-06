create table t_igor_domeny_project_sql_primary_final as (
select
cp2.payroll_year rok,
cpc."name" kategorie,
round(avg(cp.value)::numeric,2) prum_cena,
cpib."name"industry_branch,
round(avg(cp2.value)::numeric,0) prum_mzda
from czechia_price cp 
join czechia_price_category cpc on cp.category_code =cpc.code
join czechia_payroll cp2 on extract(year from(cp.date_from )) = cp2.payroll_year
left join czechia_payroll_calculation cpc2 on cp2.calculation_code = cpc2.code 
join czechia_payroll_industry_branch cpib on cp2.industry_branch_code = cpib.code
where cp2.value is not null and cp2.value_type_code = 5958 and cp2.calculation_code=100
group by cpc."name", cpib."name",cp2.payroll_year
order by cp2.payroll_year);

create table t_igor_domeny_project_sql_secondar_final as (
select 
e."year",
c.country,
c.population ,
e.gdp,
round((e.gdp/c.population)::numeric,2) gdp_per_capita
from countries c
join  economies e on c.country =e.country
where e."year" between 2006 and 2018
order by c.country, e."year"
) ;