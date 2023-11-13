
-- Total Attrition

SELECT SUM(convert(numeric,Attrition)) as total_attrition
FROM  [Portfolio].[dbo].[HR_Employee]


-- Attrition Rate

SELECT ROUND((SUM(convert(numeric,Attrition))/SUM(EmployeeCount))*100,2) as attrtion_rate
FROM  [Portfolio].[dbo].[HR_Employee]


-- Current Employee

SELECT	
		SUM (CASE
				WHEN Attrition = 1 THEN 0
				ELSE 1
				END) as current_employee
FROM  [Portfolio].[dbo].[HR_Employee]


-- Attrition number by Department 

SELECT	Department
		,SUM(convert(numeric,Attrition)) as attrition_number
FROM  [Portfolio].[dbo].[HR_Employee]
GROUP BY Department
ORDER BY 2 DESC


-- Attrition number by Job Role

SELECT	JobRole
		,SUM(convert(numeric,Attrition)) as attrition_number
FROM  [Portfolio].[dbo].[HR_Employee]
GROUP BY JobRole
ORDER BY attrition_number DESC


-- Attrtion number by Gender
SELECT	Gender
		,(CASE 
			WHEN Attrition = 1 THEN 'Attrtion'
			ELSE 'Retention'
			END) as status
		,COUNT(Attrition) as number
FROM  [Portfolio].[dbo].[HR_Employee]
GROUP BY Gender
		,(CASE 
			WHEN Attrition = 1 THEN 'Attrtion'
			ELSE 'Retention'
			END)
ORDER BY 1,2  DESC


-- Attrtion number by Age Group
SELECT	(CASE 
			WHEN Age <= 25  THEN '<25'
			WHEN Age <= 35 THEN '26-35'
			WHEN Age <= 45 THEN '36-45'
			ELSE '>46'
			END) as age_group
		,SUM(convert(numeric,Attrition)) as number_attrtion
		,SUM (CASE
				WHEN Attrition = 1 THEN 0
				ELSE 1
				END) as number_retension
FROM  [Portfolio].[dbo].[HR_Employee]
GROUP BY (CASE 
			WHEN Age <= 25  THEN '<25'
			WHEN Age <= 35 THEN '26-35'
			WHEN Age <= 45 THEN '36-45'
			ELSE '>46'
			END) 
ORDER BY 1


-- Survey Score


Select (CASE 
			WHEN Attrition = 1 THEN 'Attrtion'
			ELSE 'Retention'
			END) as status
		,(CASE 
			WHEN WorkLifeBalance = 1  THEN '1-Bad'
			WHEN WorkLifeBalance = 2  THEN '2-Good'
			WHEN WorkLifeBalance = 3  THEN '3-Better'
			ELSE '4-Best'
			END) WorkLifeBalance
		,COUNT(WorkLifeBalance) as number
FROM  [Portfolio].[dbo].[HR_Employee] 
GROUP BY (CASE 
			WHEN Attrition = 1 THEN 'Attrtion'
			ELSE 'Retention'
			END)
		,(CASE 
			WHEN WorkLifeBalance = 1  THEN '1-Bad'
			WHEN WorkLifeBalance = 2  THEN '2-Good'
			WHEN WorkLifeBalance = 3  THEN '3-Better'
			ELSE '4-Best'
			END)
ORDER BY 1,2 ASC


Select (CASE 
			WHEN Attrition = 1 THEN 'Attrtion'
			ELSE 'Retention'
			END) as status
		,(CASE 
			WHEN RelationshipSatisfaction = 1  THEN '1-Low'
			WHEN RelationshipSatisfaction = 2  THEN '2-Mediam'
			WHEN RelationshipSatisfaction = 3  THEN '3-High'
			ELSE '4-Very High'
			END) RelationshipSatisfaction
		,COUNT(WorkLifeBalance) as number
FROM  [Portfolio].[dbo].[HR_Employee] 
GROUP BY (CASE 
			WHEN Attrition = 1 THEN 'Attrtion'
			ELSE 'Retention'
			END)
		,(CASE WHEN RelationshipSatisfaction = 1  THEN '1-Low'
			WHEN RelationshipSatisfaction = 2  THEN '2-Mediam'
			WHEN RelationshipSatisfaction = 3  THEN '3-High'
			ELSE '4-Very High'
			END)
ORDER BY 1,2 ASC

Select (CASE 
			WHEN Attrition = 1 THEN 'Attrtion'
			ELSE 'Retention'
			END) as status
		,(CASE 
			WHEN JobInvolvement = 1  THEN '1-Low'
			WHEN JobInvolvement = 2  THEN '2-Mediam'
			WHEN JobInvolvement = 3  THEN '3-High'
			ELSE '4-Very High'
			END) JobInvolvement
		,COUNT(JobInvolvement) as number
FROM  [Portfolio].[dbo].[HR_Employee] 
GROUP BY (CASE 
			WHEN Attrition = 1 THEN 'Attrtion'
			ELSE 'Retention'
			END)
		,(CASE 
			WHEN JobInvolvement = 1  THEN '1-Low'
			WHEN JobInvolvement = 2  THEN '2-Mediam'
			WHEN JobInvolvement = 3  THEN '3-High'
			ELSE '4-Very High'
			END)
ORDER BY 1,2 ASC

Select (CASE 
			WHEN Attrition = 1 THEN 'Attrtion'
			ELSE 'Retention'
			END) as status
		,(CASE 
			WHEN JobSatisfaction = 1  THEN '1-Low'
			WHEN JobSatisfaction = 2  THEN '2-Mediam'
			WHEN JobSatisfaction = 3  THEN '3-High'
			ELSE '4-Very High'
			END) JobSatisfaction
		,COUNT(JobSatisfaction) as number
FROM  [Portfolio].[dbo].[HR_Employee] 
GROUP BY (CASE 
			WHEN Attrition = 1 THEN 'Attrtion'
			ELSE 'Retention'
			END)
		,(CASE 
			WHEN JobSatisfaction = 1  THEN '1-Low'
			WHEN JobSatisfaction = 2  THEN '2-Mediam'
			WHEN JobSatisfaction = 3  THEN '3-High'
			ELSE '4-Very High'
			END)
ORDER BY 1,2 ASC

Select (CASE 
			WHEN Attrition = 1 THEN 'Attrtion'
			ELSE 'Retention'
			END) as status
		,(CASE 
			WHEN PerformanceRating = 1  THEN '1-Low'
			WHEN PerformanceRating = 2  THEN '2-Good'
			WHEN PerformanceRating = 3  THEN '3-Excellent'
			ELSE '4-Outstanding'
			END) PerformanceRating
		,COUNT(PerformanceRating) as number
FROM  [Portfolio].[dbo].[HR_Employee] 
GROUP BY (CASE 
			WHEN Attrition = 1 THEN 'Attrtion'
			ELSE 'Retention'
			END)
		,(CASE 
			WHEN PerformanceRating = 1  THEN '1-Low'
			WHEN PerformanceRating = 2  THEN '2-Good'
			WHEN PerformanceRating = 3  THEN '3-Excellent'
			ELSE '4-Outstanding'
			END)
ORDER BY 1,2 ASC


