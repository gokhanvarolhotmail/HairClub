/* CreateDate: 01/20/2020 15:38:48.110 , ModifyDate: 09/14/2020 11:35:04.537 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetClientMilestoneData
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/20/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

DECLARE @SessionID UNIQUEIDENTIFIER = NEWID()

EXEC spSvc_GetClientMilestoneData @SessionID
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetClientMilestoneData]
(
	@SessionID NVARCHAR(100)
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @CurrentDate DATE
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @CurrentDate = GETDATE()


/********************************** Date Parameters *************************************/
IF ( @StartDate IS NULL OR @EndDate IS NULL )
   BEGIN
		SET @StartDate = DATEADD(DAY, -5, CAST(CONVERT(VARCHAR, @CurrentDate, 10) AS DATETIME))
		SET @EndDate = DATEADD(dd, 0, CAST(CONVERT(VARCHAR, @CurrentDate, 10) AS DATETIME))
		SET @EndDate = @EndDate + ' 23:59:59'
   END


/********************************** Create temp table objects *************************************/
DECLARE @Center AS TABLE (
	RegionSSID INT
,	RegionDescription NVARCHAR(50)
,	AreaDescription NVARCHAR(100)
,	CenterSSID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	CenterType NVARCHAR(50)
,	Center__c NVARCHAR(18)
)

DECLARE @Client AS TABLE (
	RowID INT
,	CenterID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	ClientIdentifier INT
,	SalesforceContactID NVARCHAR(18)
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	SourceCode NVARCHAR(50)
,	EmailAddress NVARCHAR(100)
,	MembershipID INT
,	ClientMembershipGUID UNIQUEIDENTIFIER
,	ClientMembershipIdentifier NVARCHAR(50)
,	MembershipDescription NVARCHAR(50)
,	BusinessSegmentID INT
,	BeginDate DATETIME
,	EndDate DATETIME
,	DoNotContactFlag BIT
,	CanContactForPromotionsByEmail BIT
)

DECLARE @Task AS TABLE (
	ActivityID__c NVARCHAR(10)
,	WhoId NVARCHAR(18)
,	Lead__c NVARCHAR(18)
,	Customer__c NVARCHAR(18)
,	Center__c NVARCHAR(18)
,	CenterID__c INT
,	CenterNumber__c INT
,	ClientIdentifier INT
,	DoNotContactFlag BIT
,	CanContactForPromotionsByEmail BIT
,	Action__c NVARCHAR(50)
,	Result__c NVARCHAR(50)
,	Subject NVARCHAR(50)
,	Status NVARCHAR(50)
,	ActivityType__c NVARCHAR(50)
,	SourceCode__c NVARCHAR(50)
,	SalesOrderDetailKey INT
,	AppointmentDate__c DATE
,	ActivityDate DATE
,	StartTime__c VARCHAR(5)
,	CompletionDate__c DATETIME
,	EndTime__c VARCHAR(5)
,	OwnerId NVARCHAR(18)
,	LeadFirstName__c NVARCHAR(50)
,	Email__c NVARCHAR(100)
,	Performer__c NVARCHAR(102)
,	Type NVARCHAR(50)
,	ReportCreateDate__c DATETIME
,	OncCreatedDate__c DATETIME
,	OncUpdatedDate__c DATETIME
)


-- Get Center Data
INSERT  INTO @Center
		SELECT  r.RegionSSID
		,		r.RegionDescription
		,		ISNULL(cma.CenterManagementAreaDescription, '') AS 'AreaDescription'
		,		ctr.CenterSSID
		,		ctr.CenterNumber
		,		ctr.CenterDescriptionNumber
		,		ct.CenterTypeDescriptionShort
		,		a.Id AS 'Center__c'
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
					ON ct.CenterTypeKey = ctr.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
					ON r.RegionKey = ctr.RegionSSID
				LEFT OUTER JOIN HC_BI_SFDC.dbo.Account a
					ON a.AccountNumber = ctr.CenterNumber
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
					ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
		WHERE   ct.CenterTypeDescriptionShort = 'C'
				AND ctr.Active = 'Y'


--INSERT  INTO @Center
--		SELECT  r.RegionSSID
--		,		r.RegionDescription
--		,		ISNULL(cma.CenterManagementAreaDescription, '') AS 'AreaDescription'
--		,		ctr.CenterSSID
--		,		ctr.CenterNumber
--		,		ctr.CenterDescriptionNumber
--		,		ct.CenterTypeDescriptionShort
--		,		a.Id AS 'Center__c'
--		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
--				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
--					ON ct.CenterTypeKey = ctr.CenterTypeKey
--				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
--					ON r.RegionKey = ctr.RegionKey
--				LEFT OUTER JOIN HC_BI_SFDC.dbo.Account a
--					ON a.AccountNumber = ctr.CenterNumber
--				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea cma
--					ON cma.CenterManagementAreaSSID = ctr.CenterManagementAreaSSID
--		WHERE   ct.CenterTypeDescriptionShort IN ( 'JV', 'F' )
--				AND ctr.Active = 'Y'


-- Get First Services Data
INSERT	INTO @Client
		SELECT  ROW_NUMBER() OVER ( PARTITION BY dc.ClientSSID, m.BusinessSegmentSSID ORDER BY cm.ClientMembershipEndDate DESC )
		,		c.CenterSSID
		,		c.CenterNumber
		,		c.CenterDescription
		,		dc.ClientIdentifier
		,		clt.SalesforceContactID
		,		clt.FirstName
		,		clt.LastName
		,		COALESCE(l.RecentSourceCode__c, l.Source_Code_Legacy__c, '') AS 'SourceCode'
		,		clt.EMailAddress
		,		m.MembershipSSID
		,		cm.ClientMembershipSSID
		,		cm.ClientMembershipIdentifier
		,		m.MembershipDescription
		,		m.BusinessSegmentSSID
		,		cm.ClientMembershipBeginDate AS 'BeginDate'
		,		cm.ClientMembershipEndDate AS 'EndDate'
		,		clt.DoNotContactFlag
		,		clt.CanContactForPromotionsByEmail
		FROM    HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON m.MembershipSSID = cm.MembershipSSID
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient dc
					ON dc.ClientSSID = cm.ClientSSID
				INNER JOIN HairClubCMS.dbo.datClient clt
					ON clt.ClientGUID = dc.ClientSSID
				INNER JOIN @Center c
					ON c.CenterSSID = dc.CenterSSID
				LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l
					ON l.Id = clt.SalesforceContactID
		WHERE	m.RevenueGroupSSID = 1 -- New Business
				AND m.BusinessSegmentSSID IN ( 1, 2, 6 ) -- Xtrands+, EXT, Xtrands
				AND m.MembershipDescriptionShort NOT IN ( 'POSTEXT', 'RETAIL', 'SHOWNOSALE', 'EXT9BOS', 'EXT9BOSSOL', 'POSTEXTBOS', 'EMPLOYRET' )
				AND cm.ClientMembershipStatusDescription = 'Active'


DELETE c FROM @Client c WHERE RowID <> 1


INSERT  INTO @Task
		SELECT	s.ActivityID__c
		,		s.WhoId
		,		s.Lead__c
		,		s.Customer__c
		,		s.Center__c
		,		s.CenterID__c
		,		s.CenterNumber__c
		,		s.ClientIdentifier
		,		s.DoNotContactFlag
		,		s.CanContactForPromotionsByEmail
		,		s.Action__c
		,		s.Result__c
		,		s.Subject
		,		s.Status
		,		s.ActivityType__c
		,		s.SourceCode__c
		,		s.SalesOrderDetailKey
		,		s.AppointmentDate__c
		,		s.ActivityDate
		,		s.StartTime__c
		,		s.CompletionDate__c
		,		s.EndTime__c
		,		s.OwnerId
		,		s.LeadFirstName__c
		,		s.Email
		,		s.Performer__c
		,		s.Type
		,		s.ReportCreateDate__c
		,		s.OncCreatedDate__c
		,		s.OncUpdatedDate__c
		FROM	(
					SELECT  ROW_NUMBER() OVER ( PARTITION BY clt.ClientIdentifier ORDER BY so.OrderDate ASC ) AS 'RowID'
					,		'' AS 'ActivityID__c'
					,		CASE WHEN ( l.ConvertedContactId IS NOT NULL OR LEFT(clt.SalesforceContactID, 3) = '003' ) THEN ISNULL(l.ConvertedContactId, clt.SalesforceContactID) ELSE l.Id END AS 'WhoId'
					,		CASE WHEN LEFT(clt.SalesforceContactID, 3) = '003' THEN '' ELSE clt.SalesforceContactID END AS 'Lead__c'
					,		CASE WHEN ( l.ConvertedContactId IS NOT NULL OR LEFT(clt.SalesforceContactID, 3) = '003' ) THEN ISNULL(l.ConvertedContactId, clt.SalesforceContactID) ELSE '' END AS 'Customer__c'
					,		c.Center__c
					,		c.CenterSSID AS 'CenterID__c'
					,		c.CenterNumber AS 'CenterNumber__c'
					,		clt.ClientIdentifier
					,		clt.DoNotContactFlag
					,		clt.CanContactForPromotionsByEmail
					,		'First Service' AS 'Action__c'
					,		'Survey' AS 'Result__c'
					,		'Milestone' AS 'Subject'
					,		'Completed' AS 'Status'
					,		'Internal' AS 'ActivityType__c'
					,		clt.SourceCode AS 'SourceCode__c'
					,		sod.SalesOrderDetailKey
					,		CAST(dd.FullDate AS DATE) AS 'AppointmentDate__c'
					,		CAST(dd.FullDate AS DATE) AS 'ActivityDate'
					,		CAST(CAST(so.OrderDate AS TIME) AS NVARCHAR(5)) AS 'StartTime__c'
					,		so.OrderDate AS 'CompletionDate__c'
					,		'' AS 'EndTime__c'
					,		'0051V000006yi18QAA' AS 'OwnerId'
					,		clt.FirstName AS 'LeadFirstName__c'
					,		CASE WHEN PATINDEX('%[&'',":;!+=\/()<>]%', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', '')))) > 0  -- Invalid characters
								OR PATINDEX('[@.-_]%', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', '')))) > 0        -- Valid but cannot be starting character
								OR PATINDEX('%[@.-_]', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', '')))) > 0        -- Valid but cannot be ending character
								OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', ''))) NOT LIKE '%@%.%'                 -- Must contain at least one @ and one .
								OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%..%'                      -- Cannot have two periods in a row
								OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%@%@%'                     -- Cannot have two @ anywhere
								OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.@%'
								OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%@.%' -- Cannot have @ and . next to each other
								OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.cm'
								OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.co' -- Camaroon or Colombia? Unlikely. Probably typos
								OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.or'
								OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.ne' -- Missing last letter
								THEN ''
								ELSE LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', '')))
							END AS 'Email'
					,		ISNULL(sty.EmployeeFullName, '') AS 'Performer__c'
					,		'GF3' AS 'Type'
					,		so.OrderDate AS 'ReportCreateDate__c'
					,		so.OrderDate AS 'OncCreatedDate__c'
					,		so.OrderDate AS 'OncUpdatedDate__c'
					,		sc.SalesCodeTypeDescriptionShort
					,		sc.SalesCodeDescription
					FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
							INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
								ON dd.DateKey = fst.OrderDateKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient dc
								ON dc.ClientKey = fst.ClientKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
								ON sc.SalesCodeKey = fst.SalesCodeKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment dep
								ON dep.SalesCodeDepartmentSSID = sc.SalesCodeDepartmentSSID
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision div
								ON div.SalesCodeDivisionSSID = dep.SalesCodeDivisionSSID
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
								ON so.SalesOrderKey = fst.SalesOrderKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
								ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderType sot
								ON sot.SalesOrderTypeKey = so.SalesOrderTypeKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
								ON cm.ClientMembershipKey = so.ClientMembershipKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
								ON m.MembershipKey = cm.MembershipKey
							INNER JOIN @Client clt
								ON clt.ClientIdentifier = dc.ClientIdentifier
									AND clt.ClientMembershipGUID = cm.ClientMembershipSSID
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
								ON ctr.CenterKey = cm.CenterKey
							INNER JOIN @Center c
								ON c.CenterSSID = ctr.CenterSSID
							LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l
								ON l.Id = clt.SalesforceContactID
							LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee sty
								ON sty.EmployeeKey = fst.Employee2Key
					WHERE   dd.FullDate BETWEEN @StartDate AND @EndDate
							AND ( div.SalesCodeDivisionDescriptionShort = 'Services'
									AND sc.SalesCodeDescriptionShort <> 'SALECNSLT' )
							AND ISNULL(clt.EMailAddress, '') <> ''
							AND clt.SalesforceContactID IS NOT NULL
							AND so.IsVoidedFlag = 0
				) s
		WHERE	s.RowID = 1


-- Get Conversion Data
INSERT  INTO @Task
		SELECT	c.ActivityID__c
		,		c.WhoId
		,		c.Lead__c
		,		c.Customer__c
		,		c.Center__c
		,		c.CenterID__c
		,		c.CenterNumber__c
		,		c.ClientIdentifier
		,		c.DoNotContactFlag
		,		c.CanContactForPromotionsByEmail
		,		c.Action__c
		,		c.Result__c
		,		c.Subject
		,		c.Status
		,		c.ActivityType__c
		,		c.SourceCode__c
		,		c.SalesOrderDetailKey
		,		c.AppointmentDate__c
		,		c.ActivityDate
		,		c.StartTime__c
		,		c.CompletionDate__c
		,		c.EndTime__c
		,		c.OwnerId
		,		c.LeadFirstName__c
		,		c.Email
		,		c.Performer__c
		,		c.Type
		,		c.ReportCreateDate__c
		,		c.OncCreatedDate__c
		,		c.OncUpdatedDate__c
		FROM	(
					SELECT  ROW_NUMBER() OVER ( PARTITION BY clt.ClientIdentifier ORDER BY so.OrderDate ASC ) AS 'RowID'
					,		'' AS 'ActivityID__c'
					,		CASE WHEN ( l.ConvertedContactId IS NOT NULL OR LEFT(clt.SalesforceContactID, 3) = '003' ) THEN ISNULL(l.ConvertedContactId, clt.SalesforceContactID) ELSE l.Id END AS 'WhoId'
					,		CASE WHEN LEFT(clt.SalesforceContactID, 3) = '003' THEN '' ELSE clt.SalesforceContactID END AS 'Lead__c'
					,		CASE WHEN ( l.ConvertedContactId IS NOT NULL OR LEFT(clt.SalesforceContactID, 3) = '003' ) THEN ISNULL(l.ConvertedContactId, clt.SalesforceContactID) ELSE '' END AS 'Customer__c'
					,		c.Center__c
					,		c.CenterSSID AS 'CenterID__c'
					,		c.CenterNumber AS 'CenterNumber__c'
					,		clt.ClientIdentifier
					,		clt.DoNotContactFlag
					,		clt.CanContactForPromotionsByEmail
					,		'Conversion' AS 'Action__c'
					,		'Survey' AS 'Result__c'
					,		'Milestone' AS 'Subject'
					,		'Completed' AS 'Status'
					,		'Internal' AS 'ActivityType__c'
					,		COALESCE(l.RecentSourceCode__c, l.Source_Code_Legacy__c, '') AS 'SourceCode__c'
					,		sod.SalesOrderDetailKey
					,		CAST(dd.FullDate AS DATE) AS 'AppointmentDate__c'
					,		CAST(dd.FullDate AS DATE) AS 'ActivityDate'
					,		CAST(CAST(so.OrderDate AS TIME) AS NVARCHAR(5)) AS 'StartTime__c'
					,		so.OrderDate AS 'CompletionDate__c'
					,		'' AS 'EndTime__c'
					,		'0051V000006yi18QAA' AS 'OwnerId'
					,		clt.FirstName AS 'LeadFirstName__c'
					,		CASE WHEN PATINDEX('%[&'',":;!+=\/()<>]%', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', '')))) > 0  -- Invalid characters
								OR PATINDEX('[@.-_]%', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', '')))) > 0        -- Valid but cannot be starting character
								OR PATINDEX('%[@.-_]', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', '')))) > 0        -- Valid but cannot be ending character
								OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', ''))) NOT LIKE '%@%.%'                 -- Must contain at least one @ and one .
								OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%..%'                      -- Cannot have two periods in a row
								OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%@%@%'                     -- Cannot have two @ anywhere
								OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.@%'
								OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%@.%' -- Cannot have @ and . next to each other
								OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.cm'
								OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.co' -- Camaroon or Colombia? Unlikely. Probably typos
								OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.or'
								OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', ''))) LIKE '%.ne' -- Missing last letter
								THEN ''
								ELSE LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(clt.EMailAddress, ''), ']', ''), '[', '')))
							END AS 'Email'
					,		ISNULL(con.EmployeeFullName, '') AS 'Performer__c'
					,		'GF4' AS 'Type'
					,		so.OrderDate AS 'ReportCreateDate__c'
					,		so.OrderDate AS 'OncCreatedDate__c'
					,		so.OrderDate AS 'OncUpdatedDate__c'
					FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
							INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
								ON dd.DateKey = fst.OrderDateKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient dc
								ON dc.ClientKey = fst.ClientKey
							INNER JOIN HairClubCMS.dbo.datClient clt
								ON clt.ClientGUID = dc.ClientSSID
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
								ON sc.SalesCodeKey = fst.SalesCodeKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
								ON so.SalesOrderKey = fst.SalesOrderKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
								ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderType sot
								ON sot.SalesOrderTypeKey = so.SalesOrderTypeKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
								ON cm.ClientMembershipKey = so.ClientMembershipKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
								ON m.MembershipKey = cm.MembershipKey
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
								ON ctr.CenterKey = cm.CenterKey
							INNER JOIN @Center c
								ON c.CenterSSID = ctr.CenterSSID
							LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l
								ON l.Id = clt.SalesforceContactID
							LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee con
								ON con.EmployeeKey = fst.Employee1Key
					WHERE   dd.FullDate BETWEEN @StartDate AND @EndDate
							AND sc.SalesCodeDescriptionShort = 'CONV'
							AND ISNULL(clt.EMailAddress, '') <> ''
							AND clt.SalesforceContactID IS NOT NULL
							AND so.IsVoidedFlag = 0
		) c
		WHERE	c.RowID = 1


-- Return data for import into Salesforce
INSERT INTO datClientMilestoneLog (
	ClientMilestoneProcessID
,	SessionGUID
,	BatchID
,	ActivityID__c
,	WhoId
,	Lead__c
,	Customer__c
,	Center__c
,	CenterID__c
,	CenterNumber__c
,	ClientIdentifier
,	DoNotContactFlag
,	CanContactForPromotionsByEmail
,	Action__c
,	Result__c
,	Subject
,	Status
,	ActivityType__c
,	SourceCode__c
,	SalesOrderDetailKey
,	AppointmentDate__c
,	ActivityDate
,	StartTime__c
,	CompletionDate__c
,	EndTime__c
,	OwnerId
,	LeadFirstName__c
,	Email
,	Performer__c
,	Type
,	ReportCreateDate__c
,	OncCreatedDate__c
,	OncUpdatedDate__c
,	ClientMilestoneStatusID
,	OriginalClientMilestoneLogID
,	IsReprocessFlag
,	CreateDate
,	CreateUser
,	LastUpdate
,	LastUpdateUser
)
SELECT	cmp.ClientMilestoneProcessID
,		@SessionID AS 'SessionID'
,		-1 AS 'BatchID'
,		t.ActivityID__c
,		t.WhoId
,		t.Lead__c
,		t.Customer__c
,		t.Center__c
,		t.CenterID__c
,		t.CenterNumber__c
,		t.ClientIdentifier
,		t.DoNotContactFlag
,		t.CanContactForPromotionsByEmail
,		t.Action__c
,		t.Result__c
,		t.Subject
,		t.Status
,		t.ActivityType__c
,		t.SourceCode__c
,		t.SalesOrderDetailKey
,		t.AppointmentDate__c
,		t.ActivityDate
,		t.StartTime__c
,		t.CompletionDate__c
,		t.EndTime__c
,		t.OwnerId
,		t.LeadFirstName__c
,		t.Email__c
,		t.Performer__c
,		t.Type
,		t.ReportCreateDate__c
,		t.OncCreatedDate__c
,		t.OncUpdatedDate__c
,		cms.ClientMilestoneStatusID
,		o_Ml.ClientMilestoneLogID AS 'OriginalClientMilestoneLogID'
,		0 AS 'IsReprocessFlag'
,		GETDATE() AS 'CreateDate'
,       'CLM-HC' AS 'CreateUser'
,       GETDATE() AS 'LastUpdate'
,       'CLM-HC' AS 'LastUpdateUser'
FROM	@Task t
        INNER JOIN HC_Marketing.dbo.lkpClientMilestoneProcess cmp
            ON cmp.ClientMilestoneProcessDescriptionShort = t.Type
        INNER JOIN HC_Marketing.dbo.lkpClientMilestoneStatus cms
            ON cms.ClientMilestoneStatusDescriptionShort = 'PENDING'
        OUTER APPLY (
			SELECT	TOP 1
					cml.ClientMilestoneLogID
			,		cml.SalesOrderDetailKey
			,		cml.ClientIdentifier
			,		cml.IsReprocessFlag
			FROM	HC_Marketing.dbo.datClientMilestoneLog cml
			WHERE	cml.ClientMilestoneProcessID = cmp.ClientMilestoneProcessID
					AND cml.ClientIdentifier = t.ClientIdentifier
			ORDER BY cml.CreateDate DESC
        ) o_Ml
WHERE   ( o_ML.ClientMilestoneLogID IS NULL OR o_ML.IsReprocessFlag = 1 )


-- Return All Pending records for specific Session ID
SELECT	cml.WhoId
,		cml.Lead__c
,		cml.Customer__c
,		cml.Center__c
,		cml.CenterID__c
,		cml.Action__c
,		cml.Result__c
,		cml.Subject
,		cml.Status
,		cml.ActivityType__c
,		cml.SourceCode__c
,		cml.AppointmentDate__c
,		cml.ActivityDate
,		cml.StartTime__c
,		cml.CompletionDate__c
,		cml.EndTime__c
,		cml.OwnerId
,		cml.Email AS 'Email__c'
,		cml.Performer__c
,		cml.Type
,		cml.ReportCreateDate__c
FROM	datClientMilestoneLog cml
        INNER JOIN lkpClientMilestoneStatus cms
            ON cms.ClientMilestoneStatusID = cml.ClientMilestoneStatusID
WHERE   cml.SessionGUID = @SessionID
        AND cms.ClientMilestoneStatusDescriptionShort = 'PENDING'
		AND ISNULL(cml.Email, '') <> ''
		AND ISNULL(cml.DoNotContactFlag, 0) = 0
ORDER BY cml.WhoId


-- Reset records marked for reprocessing
UPDATE	cml
SET		cml.IsReprocessFlag = 0
FROM	datClientMilestoneLog cml
		INNER JOIN datClientMilestoneLog cml2
			ON cml2.OriginalClientMilestoneLogID = cml.ClientMilestoneLogID
WHERE	cml2.OriginalClientMilestoneLogID IS NOT NULL
		AND cml.IsReprocessFlag = 1


END
GO
