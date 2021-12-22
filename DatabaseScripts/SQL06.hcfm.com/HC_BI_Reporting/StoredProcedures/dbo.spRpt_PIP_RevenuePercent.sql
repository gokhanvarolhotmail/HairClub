/* CreateDate: 05/06/2019 15:11:41.997 , ModifyDate: 05/07/2019 14:16:36.390 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_PIP_RevenuePercent	VERSION  1.0
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Dashboard
RELATED APPLICATION:	Email Subscription
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		5/3/2019
------------------------------------------------------------------------
NOTES:
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXEC:

EXEC [spRpt_PIP_RevenuePercent] '201,202,206'
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_PIP_RevenuePercent](
	@CenterNumber NVARCHAR(100)
)
AS

BEGIN

CREATE TABLE #CenterNumber (CenterNumber INT)


/*********************** Find CenterNumbers using fnSplit *****************************************************/

INSERT INTO #CenterNumber
SELECT SplitValue
FROM dbo.fnSplit(@CenterNumber,',')

/************** Select from dbPIPCount *********/

SELECT q.EmployeeKey
,       q.EmployeeFullName
,       q.UserLogin
,       q.CenterNumber
,       q.CenterDescriptionNumber
,       q.CenterManagementAreaDescription
,       q.StartDate
,       q.EndDate
,		SUM(NetNB1Revenue) AS NetNB1Revenue
,		SUM(RevenueBudgetPerIC) AS RevenueBudgetPerIC
,		dbo.DIVIDE_NOROUND(SUM(NetNB1Revenue),SUM(RevenueBudgetPerIC)) AS AvgRevenuePercent
INTO #PIP_Revenue
FROM
		(SELECT PIP.EmployeeKey
		,        PIP.EmployeeFullName
		,        PIP.UserLogin
		,        PIP.FullDate
		,        PIP.CenterNumber
		,        PIP.CenterDescriptionNumber
		,        PIP.CenterManagementAreaDescription
		,        PIP.Consultations
		,        PIP.NetNB1Count
		,        PIP.NetNB1Revenue
		,		 PIP.RevenueBudgetPerIC
		,        PIP.RevenuePercent
		,        PIP.ClosingBudget
		,        PIP.ClosingPercentActual
		,        PIP.StartDate
		,        PIP.EndDate
		FROM HC_BI_Dashboard.dbo.dbPIPCount PIP
		INNER JOIN #CenterNumber CTR
			ON CTR.CenterNumber = PIP.CenterNumber
		)q
GROUP BY q.EmployeeKey
,       q.EmployeeFullName
,       q.UserLogin
,       q.CenterNumber
,       q.CenterDescriptionNumber
,       q.CenterManagementAreaDescription
,       q.StartDate
,       q.EndDate


/************** Find employees that have less than 40% Avg Closing  *********/

SELECT EmployeeKey
,       EmployeeFullName
,       UserLogin
,       CenterNumber
,       CenterDescriptionNumber
,       CenterManagementAreaDescription
,       StartDate
,       EndDate
,		NetNB1Revenue
,		RevenueBudgetPerIC
,       AvgRevenuePercent
FROM #PIP_Revenue
WHERE AvgRevenuePercent < .9


END
GO
