/***********************************************************************
PROCEDURE:				spSvc_PopulateHRTurnoverDashboard
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Dashboard
AUTHOR:					Milan Hurtado
IMPLEMENTOR:			Milan Hurtado
DATE IMPLEMENTED:		11/20/2019
DESCRIPTION:			Used to populate the dbHRTurnover table with YTD data
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_PopulateHRTurnoverDashboard
***********************************************************************/
CREATE PROCEDURE spSvc_PopulateHRTurnoverDashboard
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @CurrentDate DATETIME
,		@StartDate DATETIME
,		@EndDate DATETIME


SET @CurrentDate = CURRENT_TIMESTAMP
SET @StartDate = DATEADD(YEAR, DATEDIFF(YEAR, 0, @CurrentDate), 0)
SET @EndDate = DATEADD(YEAR, 1, DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, @CurrentDate), 0)))


TRUNCATE TABLE dbHRTurnover


INSERT	INTO dbHRTurnover
		SELECT	ht.EmployeeFullName
		,		ht.CenterID
		,		ht.DepartmentNumber
		,		ht.CenterDescription
		,		ht.Area
		,		ht.EmployeeID
		,		ht.EmployeeStatus
		,		ht.VoluntaryInvoluntary
		,		ht.EmployeeOriginalHire
		,		ht.EmployeeCurrentHire
		,		ht.EmployeeTermination
		,		ht.OriginalTermReason
		,		ht.ReportMonth
		,		ht.ReportYear
		,		ht.ReportDate
		FROM	datHRTurnover ht
		WHERE	ht.ReportDate BETWEEN @StartDate AND @EndDate

END
