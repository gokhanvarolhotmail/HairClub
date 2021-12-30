/* CreateDate: 08/21/2018 14:42:51.977 , ModifyDate: 12/18/2018 13:02:24.723 */
GO
/***********************************************************************
PROCEDURE:				spSvc_FacebookAudienceLeadEmailExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		8/21/2018
DESCRIPTION:			8/21/2018
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_FacebookAudienceLeadEmailExport
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_FacebookAudienceLeadEmailExport]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @StartDate = DATEADD(dd, -30, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))


CREATE TABLE #DistinctLead (
	Id NVARCHAR(18)
)

CREATE TABLE #Email (
	Lead__c NVARCHAR(18)
,	Name NVARCHAR(100)
)


/********************************** Create temp table indexes *************************************/
CREATE NONCLUSTERED INDEX IDX_DistinctLead_Id ON #DistinctLead ( Id )
CREATE NONCLUSTERED INDEX IDX_Email_Lead__c ON #Email ( Lead__c )


-- Get Created/Updated Leads
INSERT	INTO #DistinctLead
		SELECT DISTINCT
				l.Id
		FROM    HC_BI_SFDC.dbo.Lead l
		WHERE   l.ReportCreateDate__c BETWEEN @StartDate AND @EndDate + ' 23:59:59'
				OR l.LastModifiedDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
				AND l.IsDeleted = 0
		UNION
		SELECT DISTINCT
				pc.Lead__c
		FROM    HC_BI_SFDC.dbo.Phone__c pc
		WHERE   pc.LastModifiedDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
				AND pc.IsDeleted = 0
		UNION
		SELECT DISTINCT
				ec.Lead__c
		FROM    HC_BI_SFDC.dbo.Email__c ec
		WHERE   ec.LastModifiedDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
				AND ec.IsDeleted = 0


-- Get Lead Email Data
INSERT	INTO #Email
		SELECT  dl.Id
		,		o_E.Name
		FROM    #DistinctLead dl
				OUTER APPLY ( SELECT TOP 1
										ec.Name
							  FROM      HC_BI_SFDC.dbo.Email__c ec
							  WHERE     ec.Lead__c = dl.Id
										AND ec.Primary__c = 1
										AND ec.IsDeleted = 0
							  ORDER BY  ec.CreatedDate
							) o_E

-- Return Lead Email Data
SELECT  DISTINCT
		ISNULL(LOWER(e.Name), '') AS 'Email'
FROM    #DistinctLead dl
		INNER JOIN HC_BI_SFDC.dbo.Lead l
			ON l.Id = dl.Id
		LEFT OUTER JOIN #Email e
			ON e.Lead__c = dl.Id
WHERE	l.Status IN ( 'Lead', 'Client' )
		AND ISNULL(LOWER(e.Name), '') <> ''
		AND l.IsDeleted = 0

END
GO
