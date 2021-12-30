/* CreateDate: 05/11/2018 11:51:18.447 , ModifyDate: 05/11/2018 13:48:14.573 */
GO
/***********************************************************************
PROCEDURE:				extGetActiveClients
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		5/11/2018
DESCRIPTION:			5/11/2018
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extGetActiveClients
***********************************************************************/
CREATE PROCEDURE extGetActiveClients
AS
BEGIN

SET NOCOUNT ON;

CREATE TABLE #Center (
	CenterID INT
,	CompanyID NCHAR(10)
,	CenterName NVARCHAR(50)
,	CenterType NVARCHAR(100)
,	RegionID INT
,	RegionName NVARCHAR(100)
,	Address1 NVARCHAR(50)
,   Address2 NVARCHAR(50)
,   City NVARCHAR(50)
,   StateCode NVARCHAR(10)
,   ZipCode NVARCHAR(15)
,   Country NVARCHAR(100)
,	Timezone NVARCHAR(100)
,	PhoneNumber NVARCHAR(15)
,	ManagingDirector NVARCHAR(102)
,	RegionalVicePresident NVARCHAR(102)
)

CREATE TABLE #Client (
	ClientGUID UNIQUEIDENTIFIER
)

CREATE TABLE #ClientMembership (
	ClientMembershipGUID UNIQUEIDENTIFIER
,	ClientGUID UNIQUEIDENTIFIER
,	Membership NVARCHAR(50)
,	BusinessSegment NVARCHAR(100)
,	RevenueGroup NVARCHAR(100)
,	BeginDate DATETIME
,	EndDate DATETIME
,	MembershipStatus NVARCHAR(100)
)

CREATE TABLE #ClientPhone (
	ClientGUID UNIQUEIDENTIFIER
,	PhoneNumber NVARCHAR(15)
,	PhoneType NVARCHAR(100)
,	CanConfirmAppointmentByCall BIT
,	CanConfirmAppointmentByText BIT
,	CanContactForPromotionsByCall BIT
,	CanContactForPromotionsByText BIT
,	ClientPhoneSortOrder INT
)


/********************************** Create temp table indexes *************************************/
CREATE NONCLUSTERED INDEX IDX_Center_CenterID ON #Center ( CenterID )
CREATE NONCLUSTERED INDEX IDX_Client_ClientGUID ON #Client ( ClientGUID )
CREATE NONCLUSTERED INDEX IDX_ClientPhone_ClientGUID ON #ClientPhone ( ClientGUID )


/********************************** Get Center Data *************************************/
INSERT  INTO #Center
		SELECT  ctr.CenterID
		,		ISNULL(co.company_id, '') AS 'CompanyID'
		,       ctr.CenterDescription AS 'CenterName'
		,       dct.CenterTypeDescription AS 'CenterType'
		,       ISNULL(lr.RegionID, 1) AS 'RegionID'
		,       ISNULL(lr.RegionDescription, 'Corporate') AS 'RegionName'
		,       ctr.Address1
		,       ctr.Address2
		,       ctr.City
		,       ls.StateDescriptionShort AS 'StateCode'
		,       ctr.PostalCode AS 'ZipCode'
		,       lc.CountryDescription AS 'Country'
		,		tz.TimeZoneDescriptionShort AS 'Timezone'
		,       ctr.Phone1 AS 'PhoneNumber'
		,       CASE ctr.CenterID
				  WHEN 201 THEN 'Susan Greenspan'
				  WHEN 205 THEN ''
				  WHEN 212 THEN ''
				  WHEN 213 THEN ''
				  WHEN 228 THEN 'Simon D''Souza'
				  WHEN 229 THEN 'Chris Terkalas'
				  WHEN 250 THEN ''
				  WHEN 239 THEN 'Tarrah-Lee Lawrence'
				  WHEN 255 THEN 'Kadisha Esperanto'
				  WHEN 260 THEN 'Jim Loar'
				  WHEN 283 THEN 'Ashley Zielke'
				  ELSE ISNULL(o_MD.ManagingDirector, '')
				END AS 'ManagingDirector'
		,		ISNULL(co.cst_director_name, '') AS 'RegionalVicePresident'
		FROM    HairClubCMS.dbo.cfgCenter ctr
				INNER JOIN HairClubCMS.dbo.lkpCenterType dct
					ON dct.CenterTypeID = ctr.CenterTypeID
				INNER JOIN HairClubCMS.dbo.lkpRegion lr
					ON lr.RegionID = ctr.RegionID
				INNER JOIN HairClubCMS.dbo.lkpState ls
					ON ls.StateID = ctr.StateID
				INNER JOIN HairClubCMS.dbo.lkpCountry lc
					ON lc.CountryID = ctr.CountryID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpTimeZone tz
					ON tz.TimeZoneID = ctr.TimeZoneID
				LEFT OUTER JOIN HCM.dbo.oncd_company co
					ON co.cst_center_number = ctr.CenterNumber
				OUTER APPLY ( SELECT TOP 1
										ec.CenterID
							  ,         e.FirstName + ' ' + e.LastName AS 'ManagingDirector'
							  ,         e.UserLogin + '@hcfm.com' AS 'ManagingDirectorEmail'
							  FROM      HairClubCMS.dbo.datEmployee e
										LEFT JOIN HairClubCMS.dbo.datEmployeeCenter ec
											ON ec.EmployeeGUID = e.EmployeeGUID
										LEFT JOIN HairClubCMS.dbo.cfgEmployeePositionJoin ep
											ON ep.EmployeeGUID = e.EmployeeGUID
										LEFT JOIN HairClubCMS.dbo.lkpEmployeePosition epl
											ON epl.EmployeePositionID = ep.EmployeePositionID
							  WHERE     e.CenterID = ctr.CenterID
										AND e.CenterID = ec.CenterID
										AND e.FirstName NOT IN ( 'EC', 'Test' )
										AND e.IsActiveFlag = 1
										AND epl.ActiveDirectoryGroup = 'Role_Ops Managing Director'
										AND epl.IsActiveFlag = 1
										AND ec.IsActiveFlag = 1
										AND ep.IsActiveFlag = 1
							  ORDER BY  ec.CenterID
							  ,         e.EmployeePayrollID DESC
							) o_MD
		WHERE   dct.CenterTypeDescriptionShort IN ( 'C', 'JV', 'F' )
				AND ctr.IsActiveFlag = 1


/********************************** Get Client Data *************************************/
INSERT	INTO #Client
		SELECT  DISTINCT
				clt.ClientGUID
		FROM    HairClubCMS.dbo.datClientMembership dcm
				INNER JOIN HairClubCMS.dbo.cfgMembership m
					ON m.MembershipID = dcm.MembershipID
				INNER JOIN HairClubCMS.dbo.lkpClientMembershipStatus cms
					ON cms.ClientMembershipStatusID = dcm.ClientMembershipStatusID
				INNER JOIN HairClubCMS.dbo.datClient clt
					ON clt.ClientGUID = dcm.ClientGUID
				INNER JOIN #Center c
					ON c.CenterID = clt.CenterID
		WHERE	( cms.ClientMembershipStatusDescription = 'Active' AND dcm.EndDate >= CAST(GETDATE() AS DATE) )
				AND m.MembershipDescriptionShort NOT IN ( 'HCFK', 'RETAIL', 'NONPGM', 'MODEL', 'EMPLOYEE', 'EMPLOYEXT', 'MODELEXT', 'SHOWNOSALE', 'SNSSURGOFF', 'EMPLOYXTR', 'MODELXTR', 'MDLEXTUG', 'MDLEXTUGSL' )


/********************************** Get Client Membership Data *************************************/
INSERT	INTO #ClientMembership
		SELECT  dcm.ClientMembershipGUID
		,		dcm.ClientGUID
		,		cm.MembershipDescription AS 'Membership'
		,		bs.BusinessSegmentDescription AS 'BusinessSegment'
		,		rg.RevenueGroupDescription AS 'RevenueGroup'
		,		dcm.BeginDate
		,		dcm.EndDate
		,		cms.ClientMembershipStatusDescription AS 'MembershipStatus'
		FROM    HairClubCMS.dbo.datClientMembership dcm WITH ( NOLOCK )
				INNER JOIN #Client c
					ON c.ClientGUID = dcm.ClientGUID
				INNER JOIN HairClubCMS.dbo.cfgMembership cm WITH ( NOLOCK )
					ON cm.MembershipID = dcm.MembershipID
				INNER JOIN HairClubCMS.dbo.lkpClientMembershipStatus cms WITH ( NOLOCK )
					ON cms.ClientMembershipStatusID = dcm.ClientMembershipStatusID
				INNER JOIN HairClubCMS.dbo.lkpRevenueGroup rg WITH ( NOLOCK )
					ON rg.RevenueGroupID = cm.RevenueGroupID
				INNER JOIN HairClubCMS.dbo.lkpBusinessSegment bs WITH ( NOLOCK )
					ON bs.BusinessSegmentID = cm.BusinessSegmentID


/********************************** Get Client Phone Data *************************************/
INSERT	INTO #ClientPhone
		SELECT  dcp.ClientGUID
		,       dcp.PhoneNumber
		,       pt.PhoneTypeDescription AS 'PhoneType'
		,       dcp.CanConfirmAppointmentByCall
		,       dcp.CanConfirmAppointmentByText
		,       dcp.CanContactForPromotionsByCall
		,       dcp.CanContactForPromotionsByText
		,       dcp.ClientPhoneSortOrder
		FROM    HairClubCMS.dbo.datClientPhone dcp WITH ( NOLOCK )
				INNER JOIN #Client c
					ON c.ClientGUID = dcp.ClientGUID
				INNER JOIN HairClubCMS.dbo.lkpPhoneType pt WITH ( NOLOCK )
					ON pt.PhoneTypeID = dcp.PhoneTypeID


/********************************** Return Client Data *************************************/
SELECT  ctr.CenterID AS 'CenterNumber'
,       ctr.CenterName
,		ctr.CenterType
,       clt.ClientIdentifier
,       clt.FirstName
,       clt.LastName
,       ISNULL(clt.EmailAddress, '') AS 'EmailAddress'
,       CASE WHEN ISNULL(clt.CanConfirmAppointmentByEmail, 0) = 1 THEN 'Yes' ELSE 'No' END AS 'CanConfirmAppointmentByEmail'
,       CASE WHEN ISNULL(clt.CanContactForPromotionsByEmail, 0) = 1 THEN 'Yes' ELSE 'No' END AS 'CanContactForPromotionsByEmail'
,		ISNULL(p1.PhoneNumber, '') AS 'Phone1_PhoneNumber'
,		ISNULL(p1.PhoneType, '') AS 'Phone1_PhoneType'
,		CASE WHEN ISNULL(p1.CanConfirmAppointmentByText, 0) = 1 THEN 'Yes' ELSE 'No' END AS 'Phone1_CanConfirmAppointmentByText'
,		CASE WHEN ISNULL(p1.CanContactForPromotionsByText, 0) = 1 THEN 'Yes' ELSE 'No' END AS 'Phone1_CanContactForPromotionsByText'
,		ISNULL(p2.PhoneNumber, '') AS 'Phone2_PhoneNumber'
,		ISNULL(p2.PhoneType, '') AS 'Phone2_PhoneType'
,		CASE WHEN ISNULL(p2.CanConfirmAppointmentByText, 0) = 1 THEN 'Yes' ELSE 'No' END AS 'Phone2_CanConfirmAppointmentByText'
,		CASE WHEN ISNULL(p2.CanContactForPromotionsByText, 0) = 1 THEN 'Yes' ELSE 'No' END AS 'Phone2_CanContactForPromotionsByText'
,		ISNULL(p3.PhoneNumber, '') AS 'Phone3_PhoneNumber'
,		ISNULL(p3.PhoneType, '') AS 'Phone3_PhoneType'
,		CASE WHEN ISNULL(p3.CanConfirmAppointmentByText, 0) = 1 THEN 'Yes' ELSE 'No' END AS 'Phone3_CanConfirmAppointmentByText'
,		CASE WHEN ISNULL(p3.CanContactForPromotionsByText, 0) = 1 THEN 'Yes' ELSE 'No' END AS 'Phone3_CanContactForPromotionsByText'
,       CASE WHEN ISNULL(clt.DoNotCallFlag, 0) = 1 THEN 'Yes' ELSE 'No' END AS 'DoNotCallFlag'
,       CASE WHEN ISNULL(clt.DoNotContactFlag, 0) = 1 THEN 'Yes' ELSE 'No' END AS 'DoNotContactFlag'
,		ISNULL(cm_xtrp.Membership, '') AS 'XtrandsPlus_Membership'
,		ISNULL(cm_xtrp.BusinessSegment, '') AS 'XtrandsPlus_BusinessSegment'
,		ISNULL(cm_xtrp.RevenueGroup, '') AS 'XtrandsPlus_RevenueGroup'
,		ISNULL(CONVERT(VARCHAR(11), CAST(cm_xtrp.BeginDate AS DATE), 101), '') AS 'XtrandsPlus_BeginDate'
,		ISNULL(CONVERT(VARCHAR(11), CAST(cm_xtrp.EndDate AS DATE), 101), '') AS 'XtrandsPlus_EndDate'
,		ISNULL(cm_xtrp.MembershipStatus, '') AS 'XtrandsPlus_MembershipStatus'
,		ISNULL(cm_ext.Membership, '') AS 'EXT_Membership'
,		ISNULL(cm_ext.BusinessSegment, '') AS 'EXT_BusinessSegment'
,		ISNULL(cm_ext.RevenueGroup, '') AS 'EXT_RevenueGroup'
,		ISNULL(CONVERT(VARCHAR(11), CAST(cm_ext.BeginDate AS DATE), 101), '') AS 'EXT_BeginDate'
,		ISNULL(CONVERT(VARCHAR(11), CAST(cm_ext.EndDate AS DATE), 101), '') AS 'EXT_EndDate'
,		ISNULL(cm_ext.MembershipStatus, '') AS 'EXT_MembershipStatus'
,		ISNULL(cm_xtr.Membership, '') AS 'Xtrands_Membership'
,		ISNULL(cm_xtr.BusinessSegment, '') AS 'Xtrands_BusinessSegment'
,		ISNULL(cm_xtr.RevenueGroup, '') AS 'Xtrands_RevenueGroup'
,		ISNULL(CONVERT(VARCHAR(11), CAST(cm_xtr.BeginDate AS DATE), 101), '') AS 'Xtrands_BeginDate'
,		ISNULL(CONVERT(VARCHAR(11), CAST(cm_xtr.EndDate AS DATE), 101), '') AS 'Xtrands_EndDate'
,		ISNULL(cm_xtr.MembershipStatus, '') AS 'Xtrands_MembershipStatus'
,		ISNULL(cm_sur.Membership, '') AS 'Surgery_Membership'
,		ISNULL(cm_sur.BusinessSegment, '') AS 'Surgery_BusinessSegment'
,		ISNULL(cm_sur.RevenueGroup, '') AS 'Surgery_RevenueGroup'
,		ISNULL(CONVERT(VARCHAR(11), CAST(cm_sur.BeginDate AS DATE), 101), '') AS 'Surgery_BeginDate'
,		ISNULL(CONVERT(VARCHAR(11), CAST(cm_sur.EndDate AS DATE), 101), '') AS 'Surgery_EndDate'
,		ISNULL(cm_sur.MembershipStatus, '') AS 'Surgery_MembershipStatus'
FROM    HairClubCMS.dbo.datClient clt
		INNER JOIN #Client c
			ON c.ClientGUID = clt.ClientGUID
        INNER JOIN #Center ctr
            ON ctr.CenterID = clt.CenterID
		LEFT OUTER JOIN #ClientMembership cm_xtrp
			ON cm_xtrp.ClientMembershipGUID = clt.CurrentBioMatrixClientMembershipGUID
		LEFT OUTER JOIN #ClientMembership cm_ext
			ON cm_ext.ClientMembershipGUID = clt.CurrentExtremeTherapyClientMembershipGUID
		LEFT OUTER JOIN #ClientMembership cm_xtr
			ON cm_xtr.ClientMembershipGUID = clt.CurrentXtrandsClientMembershipGUID
		LEFT OUTER JOIN #ClientMembership cm_sur
			ON cm_sur.ClientMembershipGUID = clt.CurrentSurgeryClientMembershipGUID
		LEFT OUTER JOIN #ClientPhone p1
			ON p1.ClientGUID = clt.ClientGUID
				AND p1.ClientPhoneSortOrder = 1
		LEFT OUTER JOIN #ClientPhone p2
			ON p2.ClientGUID = clt.ClientGUID
				AND p2.ClientPhoneSortOrder = 2
		LEFT OUTER JOIN #ClientPhone p3
			ON p3.ClientGUID = clt.ClientGUID
				AND p3.ClientPhoneSortOrder = 3
ORDER BY ctr.CenterID

END
GO
