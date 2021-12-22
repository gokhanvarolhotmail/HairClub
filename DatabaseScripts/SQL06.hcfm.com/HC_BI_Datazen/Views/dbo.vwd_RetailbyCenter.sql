/* CreateDate: 08/25/2015 15:34:34.370 , ModifyDate: 08/26/2015 08:47:04.337 */
GO
/***********************************************************************
VIEW:					[vwd_RetailbyCenter]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		08/25/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vwd_RetailbyCenter]
***********************************************************************/
CREATE VIEW [dbo].[vwd_RetailbyCenter]
AS

WITH Rolling1Month AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	MAX(DD.MonthWorkdaysTotal) AS 'MonthWorkdaysTotal'
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FullDate BETWEEN DATEADD(MONTH,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of one month ago
					AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM
				GROUP BY DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				, DD.YearNumber
			 )
,	Actuals AS (
				SELECT  C.CenterSSID
				,		R.RegionDescription
				,       DD.FullDate
				,	SUM(ISNULL(FST.RetailAmt, 0)) AS 'RetailAmt'
				FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN Rolling1Month DD
						ON FST.OrderDateKey = DD.DateKey
					INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesOrderDetail sod
						ON FST.SalesOrderDetailKey = sod.SalesOrderDetailKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
						ON FST.CenterKey = C.CenterKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
						ON C.RegionKey = R.RegionKey
					INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCode SC
						ON FST.SalesCodeKey = SC.SalesCodeKey
					INNER JOIN HC_BI_CMS_DDS.BI_CMS_DDS.DimSalesCodeDepartment SCD
						ON SC.SalesCodeDepartmentKey = SCD.SalesCodeDepartmentKey
				WHERE   DD.FullDate BETWEEN DATEADD(MONTH,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of one month ago
						AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM
					AND C.CenterSSID LIKE '[2]%'
					AND (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) OR SC.SalesCodeDescriptionShort IN ( 'HM3V5','EXTPMTLC','EXTPMTLCP' ))
				GROUP BY C.CenterSSID
				,       DD.FullDate
				,		R.RegionDescription
   )


SELECT CenterSSID
,	RegionDescription
,	FullDate
,	RetailAmt
FROM
	(SELECT CAST(A.CenterSSID AS VARCHAR(3)) AS 'CenterSSID'
	,	A.RegionDescription
	,	A.FullDate
	,	A.RetailAmt
	,	ROW_NUMBER() OVER (PARTITION BY A.FullDate, A.RegionDescription ORDER BY A.RetailAmt DESC) AS 'Ranking'
	FROM Actuals A
	LEFT OUTER JOIN Rolling1Month ROLL
		ON A.FullDate = ROLL.FullDate
	WHERE A.RetailAmt <> '0.00')q
WHERE Ranking <= 18
GO
