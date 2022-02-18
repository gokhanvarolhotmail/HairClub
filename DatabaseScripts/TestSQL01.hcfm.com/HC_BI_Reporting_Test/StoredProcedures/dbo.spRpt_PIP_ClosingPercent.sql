/* CreateDate: 05/06/2019 14:31:39.440 , ModifyDate: 05/07/2019 14:16:51.203 */
GO
/***********************************************************************
PROCEDURE:				spRpt_PIP_ClosingPercent	VERSION  1.0
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Dashboard/  HC_BI_Reporting
RELATED APPLICATION:	Email Subscription
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		5/3/2019
------------------------------------------------------------------------
NOTES:
------------------------------------------------------------------------
CHANGE HISTORY:

-----------------------------------------------------------------------
SAMPLE EXEC:

EXEC [spRpt_PIP_ClosingPercent] '201,202,206'
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_PIP_ClosingPercent] (
	@CenterNumber NVARCHAR(100)
)
AS

BEGIN

CREATE TABLE #CenterNumber (CenterNumber INT)


/*********************** Find CenterNumbers using fnSplit *****************************************************/

INSERT INTO #CenterNumber
SELECT SplitValue
FROM dbo.fnSplit(@CenterNumber,',')


/*********** Find Avg Closing Percent ************************************************/

SELECT q.EmployeeKey
,       q.EmployeeFullName
,       q.UserLogin
,       q.CenterNumber
,       q.CenterDescriptionNumber
,       q.CenterManagementAreaDescription
,       q.StartDate
,       q.EndDate
,		q.ClosingBudget
,		SUM(q.NetNB1Count) AS NetNB1Count
,		SUM(q.Consultations) AS Consultations
,		dbo.DIVIDE_NOROUND(SUM(q.NetNB1Count),SUM(q.Consultations)) AS AvgClosingPercent
INTO #PIP_Close
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
,		q.ClosingBudget


/************** Find employees that have less than 40% Avg Closing  *********/

SELECT EmployeeKey
,       EmployeeFullName
,       UserLogin
,       CenterNumber
,       CenterDescriptionNumber
,       CenterManagementAreaDescription
,       StartDate
,       EndDate
,		NetNB1Count
,		Consultations
,       AvgClosingPercent
FROM #PIP_Close
--WHERE (AvgClosingPercent > 0
--AND AvgClosingPercent < .4)
WHERE AvgClosingPercent < .4
ORDER BY EmployeeFullName

END
GO
