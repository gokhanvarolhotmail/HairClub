/* CreateDate: 08/21/2018 13:59:56.483 , ModifyDate: 10/02/2020 13:46:04.007 */
GO
/***********************************************************************
PROCEDURE:				spSvc_MediaBuyerLeadSummaryExport
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

EXEC spSvc_MediaBuyerLeadSummaryExport NULL, NULL
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_MediaBuyerLeadSummaryExport]
(
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @Center AS TABLE (
	Area VARCHAR(50)
,	CenterKey INT
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	CenterType NVARCHAR(50)
)

DECLARE @Lead AS TABLE (
	Id NVARCHAR(18)
,	CreationDate DATETIME
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(80)
,	Gender NVARCHAR(50)
,	CenterID NVARCHAR(50)
,	CenterNumber NVARCHAR(50)
,	SourceCode NVARCHAR(50)
,	RecordID NVARCHAR(18)
,	GCLID NVARCHAR(100)
,	AffiliateID NVARCHAR(150)
,	Status NVARCHAR(50)
,	IsInvalidLead BIT
)

DECLARE @Summary AS TABLE (
	RowID INT IDENTITY(1, 1)
,	Leads INT
,	Date DATETIME
,	Source_Code_Legacy__c NVARCHAR(50)
,	Number NVARCHAR(50)
)


DECLARE @CurrentDate DATETIME


SET @CurrentDate = GETDATE()


-- Set Dates If Parameters are NULL
IF ( @StartDate IS NULL OR @EndDate IS NULL )
   BEGIN
		SET @StartDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, @CurrentDate, 10) AS DATETIME))
		SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, @CurrentDate, 10) AS DATETIME))
   END


-- Get Centers
INSERT	INTO @Center
		SELECT	CASE WHEN ct.CenterTypeDescriptionShort IN ( 'JV', 'F' ) THEN r.RegionDescription ELSE ISNULL(cma.CenterManagementAreaDescription, 'Corporate') END AS 'Area'
		,		ctr.CenterKey
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		ct.CenterTypeDescription AS 'CenterType'
		FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
					ON ct.CenterTypeKey = ctr.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
					ON r.RegionKey = ctr.RegionKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
					ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
		WHERE	ct.CenterTypeDescriptionShort IN ( 'C', 'JV', 'F' )
				AND ( ctr.CenterNumber = 199 OR ctr.Active = 'Y' )


-- Get Source Codes
TRUNCATE TABLE datSourceCode


INSERT	INTO datSourceCode
		EXEC spSvc_MediaBuyerSourceCodeExport


-- Get Created Leads
INSERT	INTO @Lead
		SELECT	l.Id
		,		l.ReportCreateDate__c
		,		l.FirstName
		,		l.LastName
		,		ISNULL(l.Gender__c, 'Male') AS 'Gender'
		,		l.CenterID__c
		,		l.CenterNumber__c
		,		ISNULL(l.Source_Code_Legacy__c, '') AS 'SourceCode'
		,		ISNULL(l.ContactID__c, l.Id) AS 'RecordID'
		,		ISNULL(l.GCLID__c, '') AS 'GCLID'
		,		ISNULL(l.OnCAffiliateID__c, '') AS 'AffiliateID'
		,		l.Status AS 'Status'
		,		ISNULL(fil.IsInvalidLead, 0) AS 'IsInvalidLead'
		FROM    HC_BI_SFDC.dbo.Lead l
				INNER JOIN @Center c
					ON c.CenterNumber = ISNULL(l.CenterNumber__c, l.CenterID__c)
				OUTER APPLY HC_BI_SFDC.dbo.fnIsInvalidLead(l.Id) fil
		WHERE   l.ReportCreateDate__c BETWEEN @StartDate AND @EndDate + ' 23:59:59'
				AND l.Status IN ( 'Lead', 'Client', 'Deleted', 'Invalid', 'Merged', 'Test', 'HWLead', 'HWClient', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION' )


-- Get Data
INSERT	INTO @Summary
		SELECT  COUNT(l.Id) AS 'Leads'
		,       CONVERT(DATETIME, CONVERT(CHAR(10), l.CreationDate, 101)) AS 'Date'
		,		l.SourceCode AS 'Source'
		,		sc.Number AS '800 Number'
		FROM    @Lead l
				LEFT OUTER JOIN datSourceCode sc
					ON sc.SourceCode = l.SourceCode
		WHERE   l.IsInvalidLead = 0
		GROUP BY CONVERT(DATETIME, CONVERT(CHAR(10), l.CreationDate, 101))
		,       l.SourceCode
		,		sc.Number


INSERT	INTO @Summary
		SELECT  COUNT(l.Id) AS 'Leads'
		,       @EndDate
		,       'TOTAL LEADS'
		,       'N/A'
		FROM    @Lead l
		WHERE   l.IsInvalidLead = 0


INSERT	INTO @Summary
		SELECT  COUNT(l.Id) AS 'Leads'
		,       @EndDate
		,       'TOTAL EXCEPTIONS'
		,       'N/A'
		FROM    @Lead l
		WHERE   l.IsInvalidLead = 0
				AND l.Status IN ( 'Deleted', 'Invalid', 'Merged', 'Test' )


INSERT	INTO @Summary
		SELECT  COUNT(l.Id) AS 'Leads'
		,       @EndDate
		,       'TOTAL NET LEADS'
		,       'N/A'
		FROM    @Lead l
		WHERE   l.IsInvalidLead = 0
				AND l.Status IN ( 'Lead', 'Client', 'HWLead', 'HWClient', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION' )


-- Return Data
SELECT  s.Leads
,       s.Date
,       ISNULL(s.Source_Code_Legacy__c, '') AS 'Source'
,       ISNULL(s.Number, '') AS '800 Number'
FROM    @Summary s
ORDER BY s.RowID

END
GO
