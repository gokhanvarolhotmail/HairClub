/* CreateDate: 11/20/2019 11:50:12.677 , ModifyDate: 11/20/2019 11:54:45.310 */
GO
/***********************************************************************
PROCEDURE:				spSvc_PopulateHROpenPositionDashboard
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Dashboard
AUTHOR:					Milan Hurtado
IMPLEMENTOR:			Milan Hurtado
DATE IMPLEMENTED:		11/20/2019
DESCRIPTION:			Used to populate the dbHROpenPosition table with YTD data
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_PopulateHROpenPositionDashboard
***********************************************************************/
CREATE PROCEDURE spSvc_PopulateHROpenPositionDashboard
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


TRUNCATE TABLE dbHROpenPosition


INSERT	INTO dbHROpenPosition
		SELECT	hop.Position
		,		hop.StartDate
		,		hop.JobStatus
		,		hop.Assigned
		,		hop.PositionCount
		,		hop.Priorities
		,		hop.Area
		,		hop.ReportDate
		,		hop.ReportWeek
		FROM	datHROpenPosition hop
		WHERE	hop.ReportDate BETWEEN @StartDate AND @EndDate

END
GO
