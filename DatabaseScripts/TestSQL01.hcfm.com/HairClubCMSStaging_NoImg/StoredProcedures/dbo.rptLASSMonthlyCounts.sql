/* CreateDate: 10/04/2010 12:09:07.963 , ModifyDate: 02/27/2017 09:49:28.503 */
GO
/*
==============================================================================
PROCEDURE:				rptLASSMonthlyCounts

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 5/26/2010

LAST REVISION DATE: 	 5/26/2010

==============================================================================
DESCRIPTION:	Used to populate data for charts showing Lead, Appointment, Show, Sale data for charts
==============================================================================
NOTES:
		* 5/26/10 PRM - Created stored proc

==============================================================================
SAMPLE EXECUTION:
EXEC rptLASSMonthlyCounts 201, NULL
==============================================================================
*/

CREATE PROCEDURE [dbo].rptLASSMonthlyCounts
@CenterID int,
@ReportDate datetime = NULL
AS
BEGIN

IF @ReportDate IS NULL
	SET @ReportDate = GETDATE()

DECLARE @Range int = 6
DECLARE @StartDate datetime
DECLARE @EndDate datetime

--assumes all periods are first of month, currently excluding the current month because there is no data (sets end date to first day of month and then subtracts a day)
SET @EndDate = DATEADD(dd, -1, CONVERT(VARCHAR(12), CONVERT(VARCHAR(2), MONTH(GETDATE())) + '/1/' + CONVERT(VARCHAR(4), YEAR(GETDATE())), 101))
SET @StartDate = DATEADD(dd, -1, (DATEADD(mm, -1 * @Range, @EndDate)))
--PRINT @EndDate
--PRINT @StartDate

SELECT Period,
	SUM(CASE Account WHEN 10155 THEN Flash ELSE 0 END) AS LeadCount,
	SUM(CASE Account WHEN 10100 THEN Flash ELSE 0 END) AS AppointmentCount,
	SUM(CASE Account WHEN 10120 THEN FlASh ELSE 0 END) AS ShowCount,
	SUM(CASE Account WHEN 10125 THEN Flash ELSE 0 END) AS SaleCount,
	SUM(CASE Account WHEN 10205 THEN Flash ELSE 0 END) AS ActualTraditional,
	SUM(CASE Account WHEN 6210 THEN Budget ELSE 0 END) AS BudgetTraditional,
	SUM(CASE Account WHEN 10210 THEN Flash ELSE 0 END) AS ActualGradual,
	SUM(CASE Account WHEN 6211 THEN Budget ELSE 0 END) AS BudgetGradual,
	SUM(CASE Account WHEN 10215 THEN Flash ELSE 0 END) AS ActualEXT,
	SUM(CASE Account WHEN 6212 THEN Budget ELSE 0 END) AS BudgetEXT,
	SUM(CASE Account WHEN 10220 THEN Flash ELSE 0 END) AS ActualSurgery,
	SUM(CASE Account WHEN 6213 THEN Flash ELSE 0 END) AS BudgetSurgery,
	SUM(CASE Account WHEN 10225 THEN Flash ELSE 0 END) AS ActualPostEXT,
	SUM(CASE Account WHEN 6216 THEN Flash ELSE 0 END) as BudgetPostEXT
FROM HCWarehouse..Accounting
WHERE Account IN (
			  10155 --Leads
			, 10100 --Appts
			, 10120 --Shows
			, 10125 --Sales
			, 10205 --NB Trad#
			, 10210 --NB Grad#
			, 10215 --NB EXT#
			, 10220 --NB Sur#
			, 10225 --NB PostExt#
			, 6210  --NB Budget Trad#
			, 6211  --NB Budget Grad#
			, 6212  --NB Budget EXT#
			, 6213  --NB Budget Sur#
			, 6216  --NB Budget PostExt#
		)
	AND Period BETWEEN @StartDate AND @EndDate
	AND Center = @CenterID
GROUP BY Period

END
GO
