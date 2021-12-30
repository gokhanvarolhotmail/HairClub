/* CreateDate: 03/08/2018 13:56:45.393 , ModifyDate: 03/27/2018 14:04:34.463 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetFacebookAudienceActiveClientData
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		3/8/2018
DESCRIPTION:			3/8/2018
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetFacebookAudienceActiveClientData
***********************************************************************/
CREATE PROCEDURE spSvc_GetFacebookAudienceActiveClientData
AS
BEGIN

SET NOCOUNT ON;


TRUNCATE TABLE tmpFacebookActiveClients


/********************************** Create temp table objects *************************************/
CREATE TABLE #Center (
	CenterID INT
,	CenterNumber INT
,	CenterName NVARCHAR(50)
)

CREATE TABLE #Client (
	CenterID INT
,	ClientGUID UNIQUEIDENTIFIER
,	ZipCode NVARCHAR(10)
,	EmailAddress NVARCHAR(100)
,	CurrentBioMatrixClientMembershipGUID UNIQUEIDENTIFIER
,	CurrentExtremeTherapyClientMembershipGUID UNIQUEIDENTIFIER
,	CurrentXtrandsClientMembershipGUID UNIQUEIDENTIFIER
,	CurrentSurgeryClientMembershipGUID UNIQUEIDENTIFIER
,	ClientCreationDate VARCHAR(11)
)

CREATE TABLE #ClientMembership (
	ClientGUID UNIQUEIDENTIFIER
)

CREATE TABLE #ClientPhone (
	ClientGUID UNIQUEIDENTIFIER
,	PhoneNumber NVARCHAR(15)
)

CREATE TABLE #ClientRevenue (
	ClientGUID UNIQUEIDENTIFIER
,	Revenue MONEY
)


/********************************** Create temp table indexes *************************************/
CREATE NONCLUSTERED INDEX IDX_Center_CenterID ON #Center ( CenterID )
CREATE NONCLUSTERED INDEX IDX_Client_ClientGUID ON #Client ( ClientGUID )
CREATE NONCLUSTERED INDEX IDX_ClientMembership_ClientGUID ON #ClientMembership ( ClientGUID )
CREATE NONCLUSTERED INDEX IDX_ClientPhone_ClientGUID ON #ClientPhone ( ClientGUID )
CREATE NONCLUSTERED INDEX IDX_ClientRevenue_ClientGUID ON #ClientRevenue ( ClientGUID )


/********************************** Get Center Data *************************************/
INSERT  INTO #Center
		SELECT  ctr.CenterID
		,		ctr.CenterNumber
		,       ctr.CenterDescription AS 'CenterName'
		FROM    HairClubCMS.dbo.cfgCenter ctr
		WHERE   CONVERT(VARCHAR, ctr.CenterID) LIKE '[1278]%'
				AND ctr.IsActiveFlag = 1


/********************************** Get Client Membership Data *************************************/
INSERT	INTO #ClientMembership
		SELECT  DISTINCT
				cm.ClientGUID
		FROM    HairClubCMS.dbo.datClientMembership cm WITH ( NOLOCK )
				INNER JOIN HairClubCMS.dbo.cfgMembership m WITH ( NOLOCK )
					ON m.MembershipID = cm.MembershipID
		WHERE	m.MembershipDescriptionShort NOT IN ( 'HCFK', 'SHOWSALE', 'MODEL', 'EMPLOYEE', 'EMPLOYEXT', 'MODELEXT', 'SHOWNOSALE', 'SNSSURGOFF', 'EMPLOYXTR', 'MODELXTR', 'MDLEXTUG', 'MDLEXTUGSL' )
				AND cm.ClientMembershipStatusID = 1


/********************************** Get Client Data *************************************/
INSERT	INTO #Client
		SELECT  clt.CenterID
		,		clt.ClientGUID
		,		ISNULL(REPLACE(clt.PostalCode, '-', ''), '') AS 'ZipCode'
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
				END AS 'EmailAddress'
		,		clt.CurrentBioMatrixClientMembershipGUID
		,		clt.CurrentExtremeTherapyClientMembershipGUID
		,		clt.CurrentXtrandsClientMembershipGUID
		,		clt.CurrentSurgeryClientMembershipGUID
		,       CONVERT(VARCHAR(11), CAST(clt.CreateDate AS DATE), 101) AS 'ClientCreationDate'
		FROM    HairClubCMS.dbo.datClient clt WITH ( NOLOCK )
				INNER JOIN #ClientMembership cm
					ON cm.ClientGUID = clt.ClientGUID


/********************************** Get Client Phone Data *************************************/
INSERT	INTO #ClientPhone
		SELECT  dcp.ClientGUID
		,       dcp.PhoneNumber
		FROM    HairClubCMS.dbo.datClientPhone dcp WITH ( NOLOCK )
				INNER JOIN #ClientMembership cm
					ON cm.ClientGUID = dcp.ClientGUID
		WHERE	dcp.ClientPhoneSortOrder = 1
		GROUP BY dcp.ClientGUID
		,       dcp.PhoneNumber


/********************************** Get Client Revenue Data *************************************/
INSERT	INTO #ClientRevenue
		SELECT  so.ClientGUID
		,       SUM(sod.ExtendedPriceCalc) AS 'Revenue'
		FROM    HairClubCMS.dbo.datSalesOrderDetail sod
				INNER JOIN HairClubCMS.dbo.datSalesOrder so
					ON so.SalesOrderGUID = sod.SalesOrderGUID
				INNER JOIN HairClubCMS.dbo.cfgSalesCode sc
					ON sc.SalesCodeID = sod.SalesCodeID
				INNER JOIN #ClientMembership cm
					ON cm.ClientGUID = so.ClientGUID
		WHERE   sc.SalesCodeDepartmentID IN ( 2020, 2025 )
				AND so.IsVoidedFlag = 0
		GROUP BY so.ClientGUID


/********************************** Return Client Data *************************************/
INSERT	INTO tmpFacebookActiveClients
		SELECT  ctr.CenterName
		,		ctr.CenterNumber
		,		ISNULL(CONVERT(VARCHAR(11), CAST(clt.ClientCreationDate AS DATE), 101), '') AS 'ConsultationDate'
		,		COALESCE(m_xtrp.MembershipDescription, m_xtr.MembershipDescription, m_ext.MembershipDescription, m_sur.MembershipDescription) AS 'Membership'
		,       clt.ZipCode
		,       clt.EmailAddress
		,		ISNULL(p.PhoneNumber, '') AS 'PhoneNumber'
		,		ISNULL(ROUND(cr.Revenue, 2), 0) AS 'TotalRevenue'
		FROM    #Client clt
				INNER JOIN #Center ctr
					ON ctr.CenterID = clt.CenterID
				LEFT OUTER JOIN #ClientPhone p
					ON p.ClientGUID = clt.ClientGUID
				LEFT OUTER JOIN #ClientRevenue cr
					ON cr.ClientGUID = clt.ClientGUID
				LEFT OUTER JOIN HairClubCMS.dbo.datClientMembership cm_xtrp
					ON cm_xtrp.ClientMembershipGUID = clt.CurrentBioMatrixClientMembershipGUID
				LEFT OUTER JOIN HairClubCMS.dbo.cfgMembership m_xtrp
					ON m_xtrp.MembershipID = cm_xtrp.MembershipID
				LEFT OUTER JOIN HairClubCMS.dbo.datClientMembership cm_ext
					ON cm_ext.ClientMembershipGUID = clt.CurrentExtremeTherapyClientMembershipGUID
				LEFT OUTER JOIN HairClubCMS.dbo.cfgMembership m_ext
					ON m_ext.MembershipID = cm_ext.MembershipID
				LEFT OUTER JOIN HairClubCMS.dbo.datClientMembership cm_xtr
					ON cm_xtr.ClientMembershipGUID = clt.CurrentXtrandsClientMembershipGUID
				LEFT OUTER JOIN HairClubCMS.dbo.cfgMembership m_xtr
					ON m_xtr.MembershipID = cm_xtr.MembershipID
				LEFT OUTER JOIN HairClubCMS.dbo.datClientMembership cm_sur
					ON cm_sur.ClientMembershipGUID = clt.CurrentSurgeryClientMembershipGUID
				LEFT OUTER JOIN HairClubCMS.dbo.cfgMembership m_sur
					ON m_sur.MembershipID = cm_sur.MembershipID

END
GO
