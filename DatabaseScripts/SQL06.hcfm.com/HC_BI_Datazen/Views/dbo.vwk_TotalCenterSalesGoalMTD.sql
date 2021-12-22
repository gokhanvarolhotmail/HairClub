/* CreateDate: 08/12/2015 14:49:58.813 , ModifyDate: 08/12/2015 17:17:03.733 */
GO
/***********************************************************************
VIEW:					vwk_TotalCenterSalesGoalMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		08/12/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT Goal FROM vwk_TotalCenterSalesGoalMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_TotalCenterSalesGoalMTD]
AS

SELECT SUM(TotalRevenue_Budget) AS 'Goal'
	FROM  dbo.dashRecurringBusiness
	WHERE   FirstDateOfMonth BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
			AND DATEADD(ms, -3, DATEADD(mm, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) +1, 0)))
	AND CenterSSID = 100
GO
