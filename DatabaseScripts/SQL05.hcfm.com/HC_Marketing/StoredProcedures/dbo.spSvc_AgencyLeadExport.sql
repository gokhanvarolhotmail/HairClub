/* CreateDate: 09/30/2020 08:15:44.130 , ModifyDate: 09/30/2020 08:15:44.130 */
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
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_MediaBuyerLeadExport NULL, NULL
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_AgencyLeadExport]
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

DECLARE @DistinctLead AS TABLE (
	Id NVARCHAR(18)
)

DECLARE @Address AS TABLE (
	Lead__c NVARCHAR(18)
,	Zip__c NVARCHAR(50)
)

DECLARE @Phone AS TABLE (
	Lead__c NVARCHAR(18)
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
INSERT	INTO @DistinctLead
		SELECT DISTINCT
				l.Id
		FROM    HC_BI_SFDC.dbo.Lead l
				INNER JOIN @Center c
					ON c.CenterNumber = ISNULL(l.CenterNumber__c, l.CenterID__c)
		WHERE   l.ReportCreateDate__c BETWEEN @StartDate AND @EndDate + ' 23:59:59'


-- Get Lead Address Data
INSERT	INTO @Address
		SELECT  dl.Id
		,		o_A.Zip__c
		FROM    @DistinctLead dl
				OUTER APPLY ( SELECT TOP 1
										ac.Zip__c
							  FROM      HC_BI_SFDC.dbo.Address__c ac
							  WHERE     ac.Lead__c = dl.Id
										AND ac.Primary__c = 1
										AND ac.IsDeleted = 0
							  ORDER BY  ac.CreatedDate
							) o_A


-- Get Lead Phone Data
INSERT	INTO @Phone
		SELECT  dl.Id
		,		o_P.PhoneAbr__c
		FROM    @DistinctLead dl
				OUTER APPLY ( SELECT TOP 1
										pc.PhoneAbr__c
							  FROM      HC_BI_SFDC.dbo.Phone__c pc
							  WHERE     pc.Lead__c = dl.Id
										AND pc.Primary__c = 1
										AND pc.IsDeleted = 0
							  ORDER BY  pc.CreatedDate
							) o_P

-- Get Data
SELECT  l.Id AS 'SalesforceRecordID'
,		CONVERT(DATETIME, CONVERT(CHAR(10), l.ReportCreateDate__c, 101)) AS 'Date'
,		CONVERT(CHAR(5),CONVERT(VARCHAR, l.ReportCreateDate__c, 108)) AS 'Time'
,		ISNULL(a.Zip__c, '') AS 'Zip'
,		ISNULL(l.Gender__c, 'Male') AS 'Gender'
,		ISNULL(p.PhoneAbr__c, '') AS 'Phone'
,		ISNULL(l.CenterNumber__c, l.CenterID__c) AS 'Territory_Original'
,		ISNULL(l.CenterNumber__c, l.CenterID__c) AS 'Territory_Alternate'
,		ISNULL(l.Source_Code_Legacy__c, '') AS 'Source'
,		ISNULL(sc.Number, '') AS '800 Number'
,		ISNULL(l.ContactID__c, l.Id) AS 'RecordID'
,		ISNULL(l.GCLID__c, '') AS 'SessionID'
,		ISNULL(l.OnCAffiliateID__c, '') AS 'AffiliateID'
,		ISNULL(sc.Media, '') AS 'MediaType'
,		ISNULL(sc.Location, '') AS 'Location'
,		ISNULL(sc.Language, '') AS 'Language'
,		ISNULL(sc.Format, '') AS 'Format'
,		ISNULL(sc.Creative, '') AS 'Creative'
,		l.Status AS 'LeadStatus'
FROM    @DistinctLead dl
		INNER JOIN HC_BI_SFDC.dbo.Lead l
			ON l.Id = dl.Id
		LEFT OUTER JOIN datSourceCode sc
			ON sc.SourceCode = l.Source_Code_Legacy__c
		LEFT OUTER JOIN @Address a
			ON a.Lead__c = dl.Id
		LEFT OUTER JOIN @Phone p
			ON p.Lead__c = dl.Id
WHERE	l.Status IN ( 'Lead', 'Client', 'Deleted', 'Invalid', 'Merged', 'Test', 'HWLead', 'HWClient', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION' )
		AND ( ( l.LastName NOT BETWEEN '0000000001' AND '9999999999' AND ISNULL(l.FirstName, '') <> '' )
				OR ( l.LastName NOT BETWEEN '0000000001' AND '9999999999' AND ISNULL(l.FirstName, '') = '' )
				OR ( ISNULL(l.LastName, '') <> '' AND ISNULL(l.FirstName, '') <> '' ) )

END
GO
