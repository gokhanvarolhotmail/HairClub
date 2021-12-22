/* CreateDate: 02/15/2016 13:56:27.570 , ModifyDate: 02/25/2016 12:55:48.430 */
GO
/***********************************************************************
VIEW:					[vwd_AMConversions]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		08/25/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vwd_AMConversions]
***********************************************************************/
CREATE VIEW [dbo].[vwd_AMConversions]
AS


WITH AMConversions AS (SELECT FirstDateOfMonth
		,	YearNumber
		,	YearMonthNumber
		,	CenterSSID
		,	BIOConvCnt_Actual AS [XTR+ Conv]
		,	XtrandsConvCnt_Actual AS [XTR Conv]
		,	EXTConvCnt_Actual AS [EXT Conv]
		FROM dbo.dashRecurringBusiness
		WHERE FirstDateOfMonth > DATEADD(MM,-14,GETDATE())
		AND CenterSSID LIKE '[2]%'
		AND LEN(CenterSSID) = 3
)
,	AMConversionsUnpivot AS (SELECT *
		FROM(SELECT * FROM AMConversions
		)q
		UNPIVOT
		(QTY
		FOR Category
		IN ([XTR+ Conv],[XTR Conv],[EXT Conv])
		) pvt
)


, AMConversionsBudget AS (SELECT FirstDateOfMonth
		,	YearNumber
		,	YearMonthNumber
		,	CASE WHEN CenterSSID = -1 THEN 1 ELSE CenterSSID END AS 'CenterSSID'
		,	BIOConvCnt_Budget AS [XTR+ Conv]
		,	XtrandsConvCnt_Budget AS [XTR Conv]
		,	EXTConvCnt_Budget AS [EXT Conv]
		FROM dbo.dashRecurringBusiness
		WHERE FirstDateOfMonth > DATEADD(MM,-14,GETDATE())
		AND CenterSSID LIKE '[2]%'
		AND LEN(CenterSSID) = 3
)

, AMConversionsBudgetUnpivot AS (SELECT *
		FROM(
		SELECT * FROM AMConversionsBudget
		)r
		UNPIVOT
		(QTY_Budget
		FOR Category
		IN ([XTR+ Conv],[XTR Conv],[EXT Conv])
		) pvt2
)

SELECT AM.FirstDateOfMonth
     , AM.YearNumber
     , AM.YearMonthNumber
     , AM.CenterSSID
	,	AM.Category
	 ,	AM.QTY
	 ,	BUDGET.QTY_Budget
FROM AMConversionsUnpivot AM
INNER JOIN AMConversionsBudgetUnpivot BUDGET
	ON AM.CenterSSID = BUDGET.CenterSSID
	AND AM.FirstDateOfMonth = BUDGET.FirstDateOfMonth
	AND AM.Category = BUDGET.Category
GO
