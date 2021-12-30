/* CreateDate: 08/21/2018 13:55:14.130 , ModifyDate: 10/02/2020 13:45:29.923 */
GO
/***********************************************************************
PROCEDURE:				spSvc_MediaBuyerLeadExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		4/5/2018
DESCRIPTION:			4/5/2018
------------------------------------------------------------------------
NOTES:

09/08/2020	KMurdoch	Added new valid Lead Statuses, 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION'
10/01/2020	DLeiba		Added function for Lead Validation
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_MediaBuyerLeadExport NULL, NULL
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_MediaBuyerLeadExport]
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
,	CenterID INT
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

DECLARE @Address AS TABLE (
	RowID INT
,	Lead__c NVARCHAR(18)
,	Zip__c NVARCHAR(50)
)

DECLARE @Phone AS TABLE (
	RowID INT
,	Lead__c NVARCHAR(18)
,	PhoneAbr__c NVARCHAR(50)
)


DECLARE @CurrentDate DATETIME


SET @CurrentDate = GETDATE()


-- Set Dates If Parameters are NULL
IF ( @StartDate IS NULL OR @EndDate IS NULL )
   BEGIN
		SET @StartDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, @CurrentDate, 10) AS DATETIME))
		SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, @CurrentDate, 10) AS DATETIME))
   END


--SET @StartDate = '1/1/2017'


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


-- Get Lead Address Data
INSERT	INTO @Address
		SELECT	ROW_NUMBER() OVER ( PARTITION BY ac.Lead__c ORDER BY ac.CreatedDate ) AS 'RowID'
		,		ac.Lead__c
		,		ac.Zip__c
		FROM	HC_BI_SFDC.dbo.Address__c ac
				INNER JOIN @Lead l
					ON l.Id = ac.Lead__c
		WHERE	l.IsInvalidLead = 0
				AND ac.Primary__c = 1
				AND ac.IsDeleted = 0


-- Get Lead Phone Data
INSERT	INTO @Phone
		SELECT	ROW_NUMBER() OVER (PARTITION BY pc.Lead__c ORDER BY pc.CreatedDate) AS 'RowID'
		,		pc.Lead__c
		,		pc.PhoneAbr__c
		FROM	HC_BI_SFDC.dbo.Phone__c pc
				INNER JOIN @Lead l
					ON l.Id = pc.Lead__c
		WHERE	l.IsInvalidLead = 0
				AND pc.Primary__c = 1
				AND pc.IsDeleted = 0

-- Get Data
SELECT  l.Id AS 'SalesforceRecordID'
,		CONVERT(DATETIME, CONVERT(CHAR(10), l.CreationDate, 101)) AS 'Date'
,		CONVERT(CHAR(5),CONVERT(VARCHAR, l.CreationDate, 108)) AS 'Time'
,		ISNULL(a.Zip__c, '') AS 'Zip'
,		ISNULL(l.Gender, 'Male') AS 'Gender'
,		ISNULL(p.PhoneAbr__c, '') AS 'Phone'
,		ISNULL(l.CenterNumber, l.CenterID) AS 'Territory_Original'
,		ISNULL(l.CenterNumber, l.CenterID) AS 'Territory_Alternate'
,		ISNULL(l.SourceCode, '') AS 'Source'
,		ISNULL(sc.Number, '') AS '800 Number'
,		ISNULL(l.RecordID, l.Id) AS 'RecordID'
,		ISNULL(l.GCLID, '') AS 'SessionID'
,		ISNULL(l.AffiliateID, '') AS 'AffiliateID'
,		ISNULL(sc.Media, '') AS 'MediaType'
,		ISNULL(sc.Location, '') AS 'Location'
,		ISNULL(sc.Language, '') AS 'Language'
,		ISNULL(sc.Format, '') AS 'Format'
,		ISNULL(sc.Creative, '') AS 'Creative'
,		l.Status AS 'LeadStatus'
FROM    @Lead l
		LEFT OUTER JOIN datSourceCode sc
			ON sc.SourceCode = l.SourceCode
		LEFT OUTER JOIN @Address a
			ON a.Lead__c = l.Id
				AND a.RowID = 1
		LEFT OUTER JOIN @Phone p
			ON p.Lead__c = l.Id
				AND p.RowID = 1
WHERE	l.IsInvalidLead = 0

END
GO
