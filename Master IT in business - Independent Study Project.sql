--Create Table for See the--
----------------------------

SELECT	Product_ID
		,Product_Category
		,convert(datetime,date_time) as Date_Time
		,ProductBalance
		,ProductCost
		,COGS
		,StockOut
FROM [Independent Study].[dbo].[Inventory_Fact$]


--Create Current product balance and Current total cost--
---------------------------------------------------------

WITH temp_1 AS (

SELECT  Distinct(Product_ID)
		,Date_Time
		,Product_Category
		,ProductBalance
		,ProductCost
		,LAG(ProductBalance, 1) OVER(PARTITION BY Product_ID
			ORDER BY Date_Time ASC) AS Prev_PDBalance
		,LAG(ProductCost, 1) OVER(PARTITION BY Product_ID
			ORDER BY Date_Time ASC) AS Prev_PDCost
FROM [Independent Study].[dbo].[Inventory_Fact]
--ORDER BY [Product_ID],[Date_Time]
 )
 
SELECT *
		,(ProductBalance + Prev_PDBalance)/2 as CurrentBalance
		,(ProductCost + Prev_PDCost)/2 as TotalCost
FROM temp_1
WHERE	Prev_PDBalance is not null
and		Prev_PDCost is not null


--Track repeat customer--
--we can see how long customer use the service from us again--
  --------------------------------------------------------

WITH temp_1 AS (

SELECT Distinct(Maintenance_ID)
	  ,Service_ID
      ,Customer_ID
	  ,LicensePlate
      ,Date_Time
	  ,LAG(Date_Time, 1) OVER(PARTITION BY Service_ID,Customer_id,LicensePlate
		ORDER BY Date_Time ASC) AS prev_date
FROM [Independent Study].[dbo].[Maintenance_Fact]
--WHERE Customer_ID = '000009'
--and LicensePlate <> ''
WHERE LicensePlate <> ''
--ORDER BY Service_ID,Customer_ID,LicensePlate,[Date_Time]
)

,temp_2 AS (
  
SELECT *
FROM temp_1
WHERE prev_date is not null
  and prev_date != Date_Time
  )

SELECT	*
		,DATEDIFF(DAY, Prev_date, Date_Time) as Diff_day
FROM temp_2


--Create and Review your last inventory stocktake--
--This one I use in dashboard to show 
---------------------------------------------------

SELECT	t1.Product_ID
		,t1.Product_Category
		,t1.Date_Time
		,t1.ProductBalance
		,t1.StockOut
		,t2.productname
		,YEAR(date_time) as year
		,LAG(productbalance,1) over (PARTITION BY t1.product_id
			ORDER BY year(date_time),month(date_time)
			) as prev
FROM [Independent Study].[dbo].[Inventory_Fact$] t1
	left join [Independent Study].[dbo].['Product Dimension_INV'] t2
	on t1.product_id = t2.product_id
 and t1.Product_Category = t2.Product_Category
 --WHERE  t1.Product_ID= '101/000/00127' 
 --ORDER BY YEAR(date_time),MONTH(date_time)


 ---Create Inventory turnover in each product----

SELECT	A.*
		,B.sum_productcost
		,B.sum_productcost/ avg_price as inventory_turnover
		,365/(B.sum_productcost/  avg_price ) as avg_inventory_day
FROM (
		SELECT	*
				,(prev+productCost)/2 as avg_price
		FROM (
				SELECT	T1.*
						,T2.productname
						,YEAR(date_time) as year
						,LAG(ProductCost,1) OVER (PARTITION BY t1.product_id
							ORDER BY year(date_time)
							) as prev
				FROM [Independent Study].[dbo].[Inventory_Fact$] t1
				left join [Independent Study].[dbo].['Product Dimension_INV'] t2
				on t1.product_id = t2.product_id
				and t1.Product_Category = t2.Product_Category
				WHERE month(date_time) = 12 
				--and t1.Product_ID= '101/000/00127'
				)O
		WHERE (prev+productCost)/2 >0 
		) A
		left join 
			(
			SELECT	T1.product_id
				,YEAR(date_time) as year
				,SUM(T1.ProductCost) as sum_productcost
			FROM [Independent Study].[dbo].[Inventory_Fact$] t1
			left join [Independent Study].[dbo].['Product Dimension_INV'] t2
			on t1.product_id = t2.product_id
			and t1.Product_Category = t2.Product_Category
			--WHERE t1.Product_ID= '101/000/00127'
			GROUP BY  T1.product_id,year(date_time)
			) B
		on A.Product_ID= B.Product_ID
		and A.year=B.year
		WHERE sum_productcost > 0
		

 -- Create Inventory turnover in each category--
 ----------------------------------------------

SELECT	*
		,sum_cogs/ avg_cost as inventory_turnover
		,365/(sum_cogs/  avg_cost) as avg_inventory_day
FROM (
		SELECT	t1.*
				,t2.sum_ordercost
				,t1.sum_productcost_prev+t2.sum_ordercost-t1.sum_productcost as sum_cogs
				,(t1.sum_productcost+t1.sum_productcost_prev)/2 as avg_cost

		FROM (
				SELECT	*
						,LAG(sum_productcost,1) over (PARTITION BY product_category
							ORDER BY year) as sum_productcost_prev
				FROM (
						SELECT	Product_Category
								,YEAR(date_time) as year
								,SUM(productcost) as sum_productcost
						FROM [Independent Study].[dbo].[Inventory_Fact_2]
						WHERE MONTH(date_time) = '12'
						GROUP BY  product_Category
								,YEAR(date_time)
					)  A
			) T1
		left join (
					SELECT  t2.Product_Category
							,YEAR(t1.time_date) as year
							,SUM(T1.ordercost) as sum_ordercost
					FROM [Independent Study].[dbo].['Purchasing_Fact'] t1
					right join [Independent Study].[dbo].['Product Dimension_INV'] t2
					on t1.product_id = t2.product_id
					--and t1.Product_Category = t2.Product_Category
					--WHERE t1.Product_ID= '101/000/00127'
					GROUP BY Product_Category
							,YEAR(t1.time_date)
					--ORDER BY 1,3
					) T2
		on T1.Product_Category=T2.Product_Category
		and t1.year = t2.year
		)Q
WHERE ISNULL(avg_cost,-99) > 0
and sum_cogs is not null
--and 
--Product_ID = '002/085/00033'


-- Compare current miles vs previous miles--
--------------------------------------------

WITH temp_1 AS (

SELECT distinct(T1.Maintenance_ID)
      ,T1.Service_ID
      ,T1.Customer_ID
	  ,T1.Date_Time
      ,T1.LicensePlate
      ,T2.current_mile
	  ,LAG(T2.current_mile, 1) OVER(PARTITION BY T1.Service_ID,T1.Customer_ID,T1.LicensePlate
		ORDER BY T1.[Date_Time] ASC) AS Prev_mile
FROM [Independent Study].[dbo].[Maintenance_Fact] T1
LEFT JOIN [Independent Study].[dbo].['Customer Dimension-1$'] T2
on T1.Customer_ID = T2.Customer_ID
and T1.[LicensePlate] = T2.[License Plate]
and T1.Date_Time = T2.Date_Time
WHERE  t1.LicensePlate <> ''
--and t1.LicensePlate = '¡Â4328'
-- ORDER BY Service_ID,[LicensePlate],[Date_Time],Customer_ID
) 

SELECT	Maintenance_ID
		,Service_ID
		,Customer_ID
		,Date_Time
		,LicensePlate
		,current_mile
		,Prev_mile
		,(current_mile - Prev_mile) as diff_distance
FROM temp_1
WHERE Prev_mile is not null 
and current_mile <> Prev_mile
and current_mile > Prev_mile
and (current_mile - Prev_mile) < 100000
   --ORDER BY 8