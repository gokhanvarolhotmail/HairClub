/* CreateDate: 05/22/2018 13:25:23.057 , ModifyDate: 10/22/2018 10:34:22.573 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetHaloServiceData
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/24/2017
DESCRIPTION:			10/24/2017
------------------------------------------------------------------------
NOTES:

WHEN CenterType is equal to C
AND ServiceDate is exactly 1 day ago
AND MembershipStatus = Active
AND DoNotContact = 0
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetHaloServiceData NULL, NULL
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetHaloServiceData]
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


/********************************** Date Parameters *************************************/
IF ( @StartDate IS NULL OR @EndDate IS NULL )
   BEGIN
		SET @StartDate = DATEADD(dd, -7, CAST(CONVERT(VARCHAR, @CurrentDate, 10) AS DATETIME))
		SET @EndDate = DATEADD(dd, -7, CAST(CONVERT(VARCHAR, @CurrentDate, 10) AS DATETIME))
		SET @EndDate = @EndDate + ' 23:59:59'
   END


/********************************** Create temp table objects *************************************/
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

CREATE TABLE #Service (
	ClientGUID UNIQUEIDENTIFIER
,	ClientMembershipGUID UNIQUEIDENTIFIER
,	ServiceDate DATETIME
,	StylistFirstName NVARCHAR(50)
,	StylistLastName NVARCHAR(50)
)

CREATE TABLE #Client (
	CenterID INT
,	ClientGUID UNIQUEIDENTIFIER
,	ClientIdentifier INT
,	LeadID NCHAR(10)
,	LeadSourceCode NCHAR(20)
,	LeadPromoCode NCHAR(10)
,	SiebelID NVARCHAR(50)
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Address1 NVARCHAR(50)
,	Address2 NVARCHAR(50)
,	City NVARCHAR(50)
,	StateCode NVARCHAR(10)
,	ZipCode NVARCHAR(10)
,	Country NVARCHAR(100)
,	DateOfBirth VARCHAR(11)
,	Age NVARCHAR(15)
,	EmailAddress NVARCHAR(100)
,	CanConfirmAppointmentByEmail BIT
,	CanContactForPromotionsByEmail BIT
,	Gender NVARCHAR(10)
,	Ethinicity NVARCHAR(100)
,   SolutionOffered NVARCHAR(100)
,	PerformerName NVARCHAR(102)
,	Language NVARCHAR(100)
,	CurrentBioMatrixClientMembershipGUID UNIQUEIDENTIFIER
,	CurrentExtremeTherapyClientMembershipGUID UNIQUEIDENTIFIER
,	CurrentXtrandsClientMembershipGUID UNIQUEIDENTIFIER
,	CurrentSurgeryClientMembershipGUID UNIQUEIDENTIFIER
,	DoNotCallFlag BIT
,	DoNotContactFlag BIT
,	ClientCreationDate VARCHAR(11)
,	ClientLastUpdateDate VARCHAR(11)
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
CREATE NONCLUSTERED INDEX IDX_Service_ClientGUID ON #Service ( ClientGUID )
CREATE NONCLUSTERED INDEX IDX_Client_ClientGUID ON #Client ( ClientGUID )
CREATE NONCLUSTERED INDEX IDX_ClientMembership_ClientGUID ON #ClientMembership ( ClientGUID, ClientMembershipGUID )
CREATE NONCLUSTERED INDEX IDX_ClientPhone_ClientGUID ON #ClientPhone ( ClientGUID )


/********************************** Get Center Data *************************************/
INSERT  INTO #Center
		SELECT  ctr.CenterID
		,		ISNULL(co.company_id, '') AS 'CompanyID'
		,       ctr.CenterDescription AS 'CenterName'
		,       dct.CenterTypeDescriptionShort AS 'CenterType'
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
					ON co.cst_center_number = ctr.CenterID
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
		WHERE   dct.CenterTypeDescriptionShort = 'C'
				AND ctr.IsActiveFlag = 1


/********************************** Get Halo Service Data ***********************************************/
INSERT	INTO #Service
		SELECT  clt.ClientGUID
		,       so.ClientMembershipGUID
		,       CAST(so.OrderDate AS DATE) AS 'ServiceDate'
		,       sty.FirstName AS 'StylistFirstName'
		,       sty.LastName AS 'StylistLastName'
		FROM    HairClubCMS.dbo.datClient clt
				INNER JOIN HairClubCMS.dbo.datSalesOrder so
					ON clt.ClientGUID = so.ClientGUID
				INNER JOIN HairClubCMS.dbo.datSalesOrderDetail sod
					ON sod.SalesOrderGUID = so.SalesOrderGUID
				INNER JOIN HairClubCMS.dbo.cfgSalesCode sc
					ON sc.SalesCodeID = sod.SalesCodeID
				LEFT OUTER JOIN HairClubCMS.dbo.datEmployee sty
					ON sty.EmployeeGUID = sod.Employee2GUID
		WHERE   so.OrderDate BETWEEN @StartDate AND @EndDate
				AND sc.SalesCodeDescriptionShort IN ( 'HALOSVC' )
				AND so.IsVoidedFlag = 0


/********************************** Get Client Data *************************************/
INSERT	INTO #Client
		SELECT  clt.CenterID
		,		clt.ClientGUID
		,		clt.ClientIdentifier
		,		ISNULL(clt.ContactID, '') AS 'LeadID'
		,		ISNULL(ocs.source_code, '') AS 'LeadSourceCode'
		,		ISNULL(oc.cst_promotion_code, '') AS 'LeadPromoCode'
		,		ISNULL(clt.SiebelID, '') AS 'SiebelID'
		,		clt.FirstName
		,		clt.LastName
		,       ISNULL(LTRIM(RTRIM(REPLACE(clt.Address1, ',', ''))), '') AS 'Address1'
		,       ISNULL(LTRIM(RTRIM(REPLACE(clt.Address2, ',', ''))), '') AS 'Address2'
		,       ISNULL(LTRIM(RTRIM(REPLACE(clt.City, ',', ''))), '') AS 'City'
		,		ISNULL(st.StateDescriptionShort, '') AS 'State'
		,		ISNULL(REPLACE(clt.PostalCode, '-', ''), '') AS 'ZipCode'
		,		lc.CountryDescriptionShort AS 'Country'
		,		CASE WHEN clt.DateOfBirth IS NULL THEN '' ELSE CONVERT(VARCHAR(11), clt.DateOfBirth, 101) END AS 'DateOfBirth'
		,		ISNULL(clt.AgeCalc, '') AS 'ClientAge'
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
		,		ISNULL(clt.CanConfirmAppointmentByEmail, 0) AS 'CanConfirmAppointmentByEmail'
		,		ISNULL(clt.CanContactForPromotionsByEmail, 0) AS 'CanContactForPromotionsByEmail'
		,       CASE ISNULL(clt.GenderID, 1)
				  WHEN 1 THEN 'Male'
				  WHEN 2 THEN 'Female'
				END AS 'Gender'
		,		ISNULL(le.EthnicityDescription, '') AS 'Ethinicity'
		,       ISNULL(bs.BusinessSegmentDescription, '') AS 'SolutionOffered'
		,		ISNULL(de.FirstName, '') + ' ' + ISNULL(de.LastName, '') AS 'PerformerName'
		,		ISNULL(ll.LanguageDescription, 'English') AS 'Language'
		,		clt.CurrentBioMatrixClientMembershipGUID
		,		clt.CurrentExtremeTherapyClientMembershipGUID
		,		clt.CurrentXtrandsClientMembershipGUID
		,		clt.CurrentSurgeryClientMembershipGUID
		,       clt.DoNotCallFlag
		,       clt.DoNotContactFlag
		,       CONVERT(VARCHAR(11), CAST(clt.CreateDate AS DATE), 101) AS 'ClientCreationDate'
		,       CONVERT(VARCHAR(11), CAST(clt.LastUpdate AS DATE), 101) AS 'ClientLastUpdateDate'
		FROM    HairClubCMS.dbo.datClient clt WITH ( NOLOCK )
				INNER JOIN #Service s
					ON s.ClientGUID = clt.ClientGUID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpState st WITH ( NOLOCK )
					ON st.StateID = clt.StateID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpCountry lc WITH ( NOLOCK )
					ON lc.CountryID = clt.CountryID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpLanguage ll WITH ( NOLOCK )
					ON ll.LanguageID = clt.LanguageID
				LEFT OUTER JOIN HairClubCMS.dbo.datClientDemographic dcd WITH ( NOLOCK )
					ON dcd.ClientGUID = clt.ClientGUID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpEthnicity le WITH ( NOLOCK )
					ON le.EthnicityID = dcd.EthnicityID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpBusinessSegment bs WITH ( NOLOCK )
					ON bs.BusinessSegmentID = dcd.SolutionOfferedID
				LEFT OUTER JOIN HairClubCMS.dbo.datEmployee de WITH ( NOLOCK )
					ON de.EmployeeGUID = dcd.LastConsultantGUID
				LEFT OUTER JOIN HCM.dbo.oncd_contact oc WITH (NOLOCK)
					ON oc.contact_id = clt.ContactID
				LEFT OUTER JOIN HCM.dbo.oncd_contact_source ocs WITH (NOLOCK)
					ON ocs.contact_id = oc.contact_id
						AND ocs.primary_flag = 'Y'


/********************************** Get Client Memberships *************************************/
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
				INNER JOIN #Service s
					ON s.ClientGUID = dcm.ClientGUID
						AND s.ClientMembershipGUID = dcm.ClientMembershipGUID
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
SELECT  ctr.CenterID
,       ctr.CompanyID
,       ctr.CenterName
,       ctr.ManagingDirector
,       ctr.RegionalVicePresident
,		ctr.PhoneNumber AS 'CenterPhoneNumber'
,       clt.ClientGUID
,       clt.ClientIdentifier
,       clt.LeadID
,       clt.LeadSourceCode
,       clt.LeadPromoCode
,       clt.SiebelID
,       clt.FirstName
,       clt.LastName
,       clt.Address1
,       clt.Address2
,       clt.City
,       clt.StateCode
,       clt.ZipCode
,       clt.Country
,       ctr.Timezone
,       clt.DateOfBirth
,       clt.Age
,       clt.EmailAddress
,       clt.CanConfirmAppointmentByEmail
,       clt.CanContactForPromotionsByEmail
,       clt.Gender
,		clt.Ethinicity
,		clt.SolutionOffered
,		clt.PerformerName
,		s.ServiceDate
,		s.StylistFirstName
,		s.StylistLastName
,       clt.Language
,		ISNULL(p1.PhoneNumber, '') AS 'Phone1_PhoneNumber'
,		ISNULL(p1.PhoneType, '') AS 'Phone1_PhoneType'
,		ISNULL(p1.CanConfirmAppointmentByText, 0) AS 'Phone1_CanConfirmAppointmentByText'
,		ISNULL(p1.CanContactForPromotionsByText, 0) AS 'Phone1_CanContactForPromotionsByText'
,		ISNULL(p2.PhoneNumber, '') AS 'Phone2_PhoneNumber'
,		ISNULL(p2.PhoneType, '') AS 'Phone2_PhoneType'
,		ISNULL(p2.CanConfirmAppointmentByText, 0) AS 'Phone2_CanConfirmAppointmentByText'
,		ISNULL(p2.CanContactForPromotionsByText, 0) AS 'Phone2_CanContactForPromotionsByText'
,		ISNULL(p3.PhoneNumber, '') AS 'Phone3_PhoneNumber'
,		ISNULL(p3.PhoneType, '') AS 'Phone3_PhoneType'
,		ISNULL(p3.CanConfirmAppointmentByText, 0) AS 'Phone3_CanConfirmAppointmentByText'
,		ISNULL(p3.CanContactForPromotionsByText, 0) AS 'Phone3_CanContactForPromotionsByText'
,		CASE WHEN ISNULL(p1.CanConfirmAppointmentByText, 0) = 1 THEN p1.PhoneNumber ELSE CASE WHEN ISNULL(p2.CanConfirmAppointmentByText, 0) = 1 THEN p2.PhoneNumber ELSE CASE WHEN ISNULL(p3.CanConfirmAppointmentByText, 0) = 1 THEN p3.PhoneNumber ELSE '' END END END AS 'SMSPhoneNumber'
,       clt.DoNotCallFlag
,       clt.DoNotContactFlag
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
,       clt.ClientCreationDate
,       clt.ClientLastUpdateDate
FROM    #Client clt
        INNER JOIN #Center ctr
            ON ctr.CenterID = clt.CenterID
		INNER JOIN #Service s
			ON s.ClientGUID = clt.ClientGUID
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
WHERE	clt.EmailAddress <> '' -- Email Address cannot be empty
		AND ISNULL(clt.DoNotContactFlag, 0) = 0 -- Client can be contacted
		AND ISNULL(clt.CanContactForPromotionsByEmail, 0) = 1 -- Client can be emailed for surveys/promotions
		AND ( ( cm_xtrp.MembershipStatus = 'Active' AND cm_xtrp.Membership <> 'New Client (ShowNoSale)' ) -- Active Xtrands Plus Membership
				OR ( cm_ext.MembershipStatus = 'Active' ) -- Active EXT Membership
				OR ( cm_xtr.MembershipStatus = 'Active' ) -- Active Xtrands Membership
				OR ( cm_sur.MembershipStatus = 'Active' AND cm_sur.Membership <> 'New Client (Surgery Offered)' ) ) -- Active Surgery Membership

END
GO
