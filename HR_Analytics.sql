create database project3;
use project3;
rename table merged_data_csv to hr;

-- ALL 6 GIVEN KPIS 
-- 1. Department wise Attrition rate
 SELECT 
    Department,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) AS Employees_Left,
    CONCAT(ROUND((COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) / 
    COUNT(*)) * 100,2),'%') AS Attrition_Rate
FROM hr
GROUP BY department
ORDER BY Attrition_Rate Desc;

-- 2. Average Hourly rate of Male Research Scientist
SELECT round(AVG(HourlyRate),2) AS Avg_Hourly_Rate_of_Male_Research_Scientist
FROM hr
WHERE JobRole='Research Scientist' AND Gender='Male';

-- 3. Attrition rate Vs Monthly income stats
SELECT `Income Band`,
		 CONCAT(ROUND((COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) / 
    COUNT(*)) * 100,2),'%') AS Attrition_Rate
FROM hr
GROUP BY `Income Band`
ORDER BY Attrition_Rate DESC;
		
-- 4. Average working years for each Department
SELECT Department, round(AVG(TotalWorkingYears),2) AS Avg_Working_Years
FROM hr
GROUP BY Department
ORDER BY Avg_Working_Years DESC;

-- 5. Job Role Vs Work life balance
SELECT 
    JobRole,
    CONCAT(ROUND((100.0 * COUNT(CASE WHEN `WLB Category` = 'Bad' THEN 1 END) / COUNT(*)), 2), '%') AS Bad,
    CONCAT(ROUND((100.0 * COUNT(CASE WHEN `WLB Category` = 'Average' THEN 1 END) / COUNT(*)), 2), '%') AS Average,
	CONCAT(ROUND((100.0 * COUNT(CASE WHEN `WLB Category` = 'Good' THEN 1 END) / COUNT(*)), 2), '%') AS Good,
	CONCAT(ROUND((100.0 * COUNT(CASE WHEN `WLB Category` = 'Excellent' THEN 1 END) / COUNT(*)), 2), '%') AS Excellent
FROM hr
GROUP BY JobRole
ORDER BY JobRole;

-- 6. Attrition rate Vs Year since last promotion relation
SELECT YearsSinceLastPromotion,
		CONCAT(ROUND((COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) / 
		COUNT(*)) * 100,2),'%') AS Attrition_Rate
FROM Hr
GROUP BY YearsSinceLastPromotion
ORDER BY Attrition_Rate DESC;

-- 7. Gender wise Headcount
SELECT Gender, COUNT(*) AS Total_Employees
FROM hr
GROUP BY Gender
ORDER BY Total_Employees DESC;

-- 8. Age Bucket Wise HeadCount
SELECT `Age Bucket`, COUNT(*) AS Total_Employees
FROM hr
GROUP BY `Age Bucket`
ORDER BY Total_Employees DESC;

-- 9. Marital Status wise Headcount
SELECT MaritalStatus, COUNT(*) AS Total_Employees
FROM hr
GROUP BY MaritalStatus
ORDER BY Total_Employees;

-- 10. Job Role wise Monthly Income
SELECT JobRole, CONCAT(ROUND(SUM(MonthlyIncome)/1000000,2),' M') AS Monthly_Income
FROM hr
GROUP BY JobRole
ORDER BY Monthly_Income DESC;

-- 11. JobRole wise Attrition rate
 SELECT 
    JobRole,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) AS Employees_Left,
    CONCAT(ROUND((COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) / 
    COUNT(*)) * 100,2),'%') AS Attrition_Rate
FROM hr
GROUP BY JobRole
ORDER BY Attrition_Rate Desc;

-- OVERALL KPI CARDS
select 
	(select count(`employee id`) from hr) as 'Total Employees',
    
    (select count(attrition) from hr where Attrition='Yes') as 'Employees Left',
    
    (select count(attrition) from hr where Attrition='No') as 'Active Employees',
    
    concat((round((select count(attrition) from hr where Attrition='Yes')/
    (select count(`employee id`) from hr)*100,2)),'%') as 'Attrition Rate',
    
    concat((round((select count(attrition) from hr where Attrition='No')/
    (select count(`employee id`) from hr)*100,2)),'%') as 'Retention Rate',
    
	(round((select avg(age) from hr),0)) as 'Average Age',
    
    round((select avg(hourlyrate) from hr),2) as Avg_Hourly_Rate,
    
    round((select sum(PerformanceRating) from hr)/
    (select count(`employee id`) from hr),2) as 'Avg Job Performance Rating',
    
    round((select sum(jobSatisfaction) from hr)/
    (select count(`employee id`) from hr),2) as 'Avg Job Satisfaction Rating';

-- MALE KPI CARDS
select 
	(select count(`employee id`) from hr
	 where Gender='male') as 'Total Male Employees',
  
	(select count(attrition) from hr
    where Attrition='Yes' AND Gender='Male') as 'Male Employees Left',
    
    (select count(Attrition) from hr
    where attrition='No' and Gender='Male') as 'Active Male Employees',
    
    (concat(round((select count(`employee id`) from hr where Gender='male')/
    (select count(`employee id`) from hr)*100,2),'%')) as 'Male%',
    
	(concat(round((select count(attrition) from hr where Attrition='Yes' AND Gender='Male')/
    (select count(`employee id`) from hr where Gender='male')*100,2),'%')) as 'Attrition Rate',
    
    (concat(round((select count(attrition) from hr where Attrition='No' AND Gender='Male')/
    (select count(`employee id`) from hr where Gender='male')*100,2),'%')) as 'Retention Rate',
    
    (round((select avg(hourlyrate) from hr where gender ='male'),2)) as 'Average Hourly Rate',
    
    concat(round((select avg(MonthlyIncome*12) from hr 
    where gender='male')/1000,2),' K') as 'Average Annual Income';
     
-- FEMALE KPI CARDS
select 
	(select count(`employee id`) from hr
	 where Gender='female') as 'Total Female Employees',
  
	(select count(attrition) from hr
    where Attrition='Yes' AND Gender='female') as 'Female Employees Left',
    
    (select count(Attrition) from hr
    where attrition='No' and Gender='female') as 'Active Female Employees',
    
    (concat(round((select count(`employee id`) from hr where Gender='female')/
    (select count(`employee id`) from hr)*100,2),'%')) as 'Female%',
    
	(concat(round((select count(attrition) from hr where Attrition='Yes' AND Gender='female')/
    (select count(`employee id`) from hr where Gender='female')*100,2),'%')) as 'Attrition Rate',
    
    (concat(round((select count(attrition) from hr where Attrition='No' AND Gender='female')/
    (select count(`employee id`) from hr where Gender='female')*100,2),'%')) as 'Retention Rate',
    
    (round((select avg(hourlyrate) from hr where gender ='female'),2)) as 'Average Hourly Rate',
    
    concat(round((select avg(MonthlyIncome*12) from hr 
    where gender='female')/1000,2),' K') as 'Average Annual Income';
    

    





    

    
