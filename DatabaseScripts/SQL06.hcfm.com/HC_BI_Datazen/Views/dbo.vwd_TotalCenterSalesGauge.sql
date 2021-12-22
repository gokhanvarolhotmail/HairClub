/* CreateDate: 08/13/2015 17:39:06.667 , ModifyDate: 08/13/2015 17:43:36.120 */
GO
/***********************************************************************
VIEW:					vwd_TotalCenterSalesGauge
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		08/12/2015
------------------------------------------------------------------------
NOTES:
This view populates the data for the Total Center Sales Gauge in the dashboard Recurring Business.
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwd_TotalCenterSalesGauge
***********************************************************************/
CREATE VIEW [dbo].[vwd_TotalCenterSalesGauge]
AS


WITH Rolling2Years AS (
	SELECT DateKey, FirstDateOfMonth, YearNumber, YearMonthNumber
	FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
	WHERE  DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 2 Years Ago
		  AND GETDATE() -- Today
)

SELECT CenterSSID
,	DRB.FirstDateOfMonth
,	TotalCenterSales AS 'TotalCenterSales'
,	TotalRevenue_Budget AS 'Goal'
FROM  dbo.dashRecurringBusiness DRB
INNER JOIN Rolling2Years ROLL
	ON DRB.YearMonthNumber = ROLL.YearMonthNumber
GROUP BY CenterSSID
,	DRB.FirstDateOfMonth
,	TotalCenterSales
,	TotalRevenue_Budget
GO
