/***********************************************************************
PROCEDURE:				spRpt_PIP	VERSION  1.0
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Dashboard
RELATED APPLICATION:	Email Subscription
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		5/3/2019
------------------------------------------------------------------------
NOTES:
------------------------------------------------------------------------
CHANGE HISTORY:

--------------------------------------------------------------------------------------------------------
SAMPLE EXEC:

EXEC [spRpt_PIP]

--***********************************************************************/
CREATE PROCEDURE [dbo].spRpt_PIP
AS

BEGIN

SELECT EmployeeKey
,       EmployeeFullName
,       UserLogin
,       FullDate
,       CenterNumber
,       CenterDescriptionNumber
,       CenterManagementAreaDescription
,       Consultations
,       NetNB1Count
,       NetNB1Revenue
,		RevenueBudgetPerIC
,       RevenuePercent
,       ClosingBudget
,       ClosingPercentActual
,       StartDate
,       EndDate
FROM HC_BI_Dashboard.dbo.dbPIPCount

END
