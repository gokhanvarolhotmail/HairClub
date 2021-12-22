/* CreateDate: 11/20/2019 11:55:10.017 , ModifyDate: 11/20/2019 11:55:10.017 */
GO
/***********************************************************************
PROCEDURE:				spSvc_PopulateHROvertimeDashboard
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Dashboard
AUTHOR:					Milan Hurtado
IMPLEMENTOR:			Milan Hurtado
DATE IMPLEMENTED:		11/20/2019
DESCRIPTION:			Used to populate the dbHROvertime table with YTD data
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_PopulateHROvertimeDashboard
***********************************************************************/
CREATE PROCEDURE spSvc_PopulateHROvertimeDashboard
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


TRUNCATE TABLE dbHROvertime


INSERT	INTO dbHROvertime
		SELECT	ho.CenterNumber
		,		ho.TotalHours
		,		ho.DoubleOvertimeHours
		,		ho.PayDate
		FROM	datHROvertime ho
		WHERE	ho.PayDate BETWEEN @StartDate AND @EndDate

END
GO
