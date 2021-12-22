/* CreateDate: 05/07/2019 15:33:14.933 , ModifyDate: 05/07/2019 15:33:40.170 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_PIP_Detail	VERSION  1.0
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

EXEC [spRpt_PIP_Detail] 15385

--***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_PIP_Detail] (
	@EmployeeKey INT
	)
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
WHERE EmployeeKey = @EmployeeKey

END
GO
