/* CreateDate: 08/21/2018 14:06:01.487 , ModifyDate: 12/15/2020 10:36:52.060 */
GO
/***********************************************************************
PROCEDURE:				spSvc_MediaBuyerTaskSummaryExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		4/5/2018
DESCRIPTION:			4/5/2018
------------------------------------------------------------------------
NOTES:

09/08/2020	KMurdoch	Added new Lead Statuses 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION'
10/01/2020	DLeiba		Added function for Lead Validation
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_MediaBuyerTaskSummaryExport NULL, NULL
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_MediaBuyerTaskSummaryExport]
(
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @CurrentDate DATETIME


SET @CurrentDate = GETDATE()


-- Set Dates If Parameters are NULL
IF ( @StartDate IS NULL OR @EndDate IS NULL )
   BEGIN
		SET @StartDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, @CurrentDate, 10) AS DATETIME))
		SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, @CurrentDate, 10) AS DATETIME))
   END


-- Get Data
SELECT  ISNULL(SUM(CASE WHEN t.Action__c IN ( 'Appointment', 'In House' ) THEN 1 ELSE 0 END), 0) AS 'Appointments'
,		ISNULL(SUM(CASE WHEN t.Result__c IN ( 'Show No Sale', 'Show Sale' ) THEN 1 ELSE 0 END), 0) AS 'Shows'
,		ISNULL(SUM(CASE WHEN t.Result__c IN ( 'Show Sale' ) THEN 1 ELSE 0 END), 0) AS 'Sales'
FROM    HC_BI_SFDC.dbo.Task t
		INNER JOIN HC_BI_SFDC.dbo.Lead l
			ON l.Id = t.WhoId
WHERE   ( t.ActivityDate BETWEEN @StartDate AND  @EndDate + ' 23:59:59'
			OR t.LastModifiedDate BETWEEN @StartDate AND  @EndDate + ' 23:59:59' )
		AND t.Action__c IN ( 'Appointment', 'In House', 'Be Back', 'Deleted' )
		AND ISNULL(t.Result__c, '') IN ( '', 'No Show', 'Show No Sale', 'Show Sale', 'Prank', 'Deleted' )
		AND l.Status IN ( 'Lead', 'Client', 'Deleted', 'Invalid', 'Merged', 'HWLead', 'HWClient', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION' )
		AND ISNULL(t.CenterID__c, t.CenterNumber__c) <> 355 --Exclude Hans Wiemann

END
GO
