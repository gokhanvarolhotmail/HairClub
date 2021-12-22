/***********************************************************************
VIEW:					[vwd_FranchiseActualRevenuePerBusinessSegment]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
CREATED DATE:			05/20/2016
------------------------------------------------------------------------
NOTES: This view is being used in the Franchise Datazen dashboards
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vwd_FranchiseActualRevenuePerBusinessSegment] ORDER BY CenterSSID, FirstDateOfMonth
***********************************************************************/
CREATE VIEW [dbo].[vwd_FranchiseActualRevenuePerBusinessSegment]
AS

SELECT CenterSSID, FirstDateOfMonth,  Trad, Grad, EXT, Xtrands
FROM (
SELECT CenterSSID, FirstDateOfMonth, BusinessSegment, Revenue
FROM dbo.dashSalesMix
WHERE CenterSSID = 101 OR CenterSSID LIKE '[78]%'
AND FirstDateOfMonth >= DATEADD(YEAR,-2,GETUTCDATE())
) up

PIVOT (SUM(Revenue) FOR BusinessSegment IN (Grad, Trad, Xtrands, EXT))AS pvt
