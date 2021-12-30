/* CreateDate: 08/21/2018 14:04:47.973 , ModifyDate: 12/15/2020 10:36:32.487 */
GO
/***********************************************************************
PROCEDURE:				spSvc_MediaBuyerTaskExport
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

EXEC spSvc_MediaBuyerTaskExport NULL, NULL
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_MediaBuyerTaskExport]
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


--SET @StartDate = '9/8/2020'
--SET @EndDate = '9/8/2020'


-- Get Source Codes
TRUNCATE TABLE datSourceCode


INSERT	INTO datSourceCode
		EXEC spSvc_MediaBuyerSourceCodeExport


-- Get Data
SELECT  l.Id AS 'SalesforceRecordID'
,		CASE WHEN t.Action__c IN ( 'Appointment', 'In House' ) THEN 1 ELSE 0 END AS 'Appointment'
,		CASE WHEN t.Action__c IN ( 'Appointment', 'In House' ) THEN CONVERT(DATETIME, CONVERT(CHAR(10), t.ActivityDate, 101)) ELSE NULL END AS 'Appointment_Date'
,		CASE WHEN t.Result__c IN ( 'Show No Sale', 'Show Sale' ) THEN 1 ELSE 0 END AS 'Show'
,		CASE WHEN t.Result__c IN ( 'Show No Sale', 'Show Sale' ) THEN CONVERT(DATETIME, CONVERT(CHAR(10), t.ActivityDate, 101)) ELSE NULL END AS 'Show_Date'
,		CASE WHEN t.Result__c IN ( 'Show Sale' ) THEN 1 ELSE 0 END AS 'Sale'
,		CASE WHEN t.Result__c IN ( 'Show Sale' ) THEN CONVERT(DATETIME, CONVERT(CHAR(10), t.ActivityDate, 101)) ELSE NULL END AS 'Sale_Date'
,		ISNULL(t.CenterNumber__c, t.CenterID__c) AS 'Center'
,		l.ContactID__c AS 'RecordID'
,		ISNULL(t.SourceCode__c, '') AS 'ActivitySource'
,		CASE WHEN t.SaleTypeCode__c > 0 THEN t.SaleTypeCode__c ELSE '' END AS 'SaleTypeID'
,		ISNULL(l.Gender__c, '') AS 'Gender'
,		ISNULL(l.MaritalStatus__c, '') AS 'MaritalStatus'
,		ISNULL(l.Ethnicity__c, '') AS 'Ethnicity'
,		ISNULL(l.Occupation__c, '') AS 'Occupation'
,		ISNULL(l.AgeRange__c, '') AS 'Age'
,		ISNULL(sc.Media, '') AS 'MediaType'
,		ISNULL(sc.Location, '') AS 'Location'
,		ISNULL(sc.Language, '') AS 'Language'
,		ISNULL(sc.Format, '') AS 'Format'
,		ISNULL(sc.Creative, '') AS 'Creative'
,		ISNULL(sc.Number, '') AS '800 Number'
,		ISNULL(l.GCLID__c, '') AS 'GCLID'
,		CAST(ISNULL(l.HTTPReferrer__c, '') AS NVARCHAR(4000)) AS 'HTTPReferrer'
FROM    HC_BI_SFDC.dbo.Task t
		INNER JOIN HC_BI_SFDC.dbo.Lead l
			ON l.Id = t.WhoId
		LEFT OUTER JOIN datSourceCode sc
			ON sc.SourceCode = t.SourceCode__c
WHERE   ( t.ActivityDate BETWEEN @StartDate AND  @EndDate + ' 23:59:59'
			OR t.LastModifiedDate BETWEEN @StartDate AND  @EndDate + ' 23:59:59' )
		AND t.Action__c IN ( 'Appointment', 'In House', 'Be Back', 'Deleted' )
		AND ISNULL(t.Result__c, '') IN ( '', 'No Show', 'Show No Sale', 'Show Sale', 'Prank', 'Deleted' )
		AND l.Status IN ( 'Lead', 'Client', 'Deleted', 'Invalid', 'Merged', 'HWLead', 'HWClient','NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION' )
		AND ISNULL(t.CenterID__c, t.CenterNumber__c) <> '355' -- Exclude Hans Wiemann

END
GO
