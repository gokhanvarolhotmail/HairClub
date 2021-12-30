/* CreateDate: 11/18/2019 14:28:11.693 , ModifyDate: 12/06/2019 15:10:40.383 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetPCPClientCancellationData
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/18/2019
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetPCPClientCancellationData -45
EXEC spSvc_GetPCPClientCancellationData -90
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetPCPClientCancellationData]
(
	@RefreshInterval INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE	@CurrentDate DATETIME
,		@StartDate DATETIME


SET @CurrentDate = CAST(GETDATE() AS DATE)
SET @StartDate = CAST(DATEADD(DAY, @RefreshInterval, CAST(CONVERT(VARCHAR, @CurrentDate, 10) AS DATETIME)) AS DATE)


/********************************** Create temp table objects *************************************/
CREATE TABLE #Center (
	CenterID INT
,	CenterNumber INT
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
)

CREATE TABLE #Cancel (
	ClientMembershipGUID UNIQUEIDENTIFIER
,	ClientGUID UNIQUEIDENTIFIER
,	CancelDate DATETIME
,	CancelReason NVARCHAR(100)
)

CREATE TABLE #Client (
	CenterID INT
,	ClientGUID UNIQUEIDENTIFIER
,	ClientIdentifier INT
,	SalesforceContactID NVARCHAR(18)
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

CREATE TABLE #Appointment (
	ClientGUID UNIQUEIDENTIFIER
,	AppointmentDate DATE
)

CREATE TABLE #Service (
	ClientGUID UNIQUEIDENTIFIER
,	ServiceDate DATETIME
,	StylistFirstName NVARCHAR(50)
,	StylistLastName NVARCHAR(50)
)


/********************************** Create temp table indexes *************************************/
CREATE NONCLUSTERED INDEX IDX_Center_CenterID ON #Center ( CenterID )
CREATE NONCLUSTERED INDEX IDX_Cancel_ClientGUID ON #Cancel ( ClientGUID )
CREATE NONCLUSTERED INDEX IDX_Client_ClientGUID ON #Client ( ClientGUID )
CREATE NONCLUSTERED INDEX IDX_ClientMembership_ClientGUID_INCL ON #ClientMembership ( ClientGUID, ClientMembershipGUID )
CREATE NONCLUSTERED INDEX IDX_ClientPhone_ClientGUID ON #ClientPhone ( ClientGUID )


/********************************** Get Center Data *************************************/
INSERT  INTO #Center
		SELECT  ctr.CenterID
		,		ctr.CenterNumber
		,		ctr.CenterDescription AS 'CenterName'
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
		WHERE   CONVERT(VARCHAR, ctr.CenterNumber) LIKE '[2]%'
				AND ctr.IsActiveFlag = 1


/********************************** Convert @StartDate to UTC ***********************************************/
SELECT  tz.TimeZoneID
,       tz.UTCOffset
,       tz.UsesDayLightSavingsFlag
,       tz.IsActiveFlag
,       CAST(HairClubCMS.dbo.GetUTCFromLocal(@StartDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS DATE) AS 'UTCStartDate'
,       CAST(HairClubCMS.dbo.GetUTCFromLocal(@StartDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS DATE) AS 'UTCEndDate'
INTO    #UTCDates
FROM    HairClubCMS.dbo.lkpTimeZone tz
WHERE   tz.IsActiveFlag = 1


/********************************** Get Client Cancellation Data *************************************/
INSERT	INTO #Cancel
		SELECT  dcm.ClientMembershipGUID
		,       clt.ClientGUID
		,       dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'CancelDate'
		,       mor.MembershipOrderReasonDescription AS 'CancelReason'
		FROM    HairClubCMS.dbo.datSalesOrderDetail sod
				INNER JOIN HairClubCMS.dbo.datSalesOrder so
					ON so.SalesOrderGUID = sod.SalesOrderGUID
				INNER JOIN HairClubCMS.dbo.datClientMembership dcm
					ON dcm.ClientMembershipGUID = so.ClientMembershipGUID
				INNER JOIN HairClubCMS.dbo.cfgSalesCode sc
					ON sc.SalesCodeID = sod.SalesCodeID
				INNER JOIN HairClubCMS.dbo.cfgCenter ctr
					ON ctr.CenterID = so.CenterID
				INNER JOIN #Center c
					ON c.CenterID = ctr.CenterID
				INNER JOIN HairClubCMS.dbo.lkpTimeZone tz
					ON tz.TimeZoneID = ctr.TimeZoneID
				JOIN #UTCDates u
					ON u.TimeZoneID = tz.TimeZoneID
				INNER JOIN HairClubCMS.dbo.datClient clt
					ON clt.ClientGUID = so.ClientGUID
				INNER JOIN HairClubCMS.dbo.lkpMembershipOrderReason mor
					ON mor.MembershipOrderReasonID = sod.MembershipOrderReasonID
		WHERE   CAST(so.OrderDate AS DATE) BETWEEN u.UTCStartDate AND u.UTCEndDate
				AND sc.SalesCodeDepartmentID = 1099 -- Cancellations
				AND mor.MembershipOrderReasonDescriptionShort NOT IN ( 'DATA', 'UNKNOWN' )
				AND so.IsVoidedFlag = 0


/********************************** Get Client Data *************************************/
INSERT	INTO #Client
		SELECT  clt.CenterID
		,		clt.ClientGUID
		,		clt.ClientIdentifier
		,		ISNULL(clt.SalesforceContactID, '') AS 'SalesforceContactID'
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
		WHERE	clt.ClientGUID IN ( SELECT c.ClientGUID FROM #Cancel c ) -- Client Cancelled within time period


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
				INNER JOIN #Cancel c
					ON c.ClientGUID = dcm.ClientGUID
						AND c.ClientMembershipGUID = dcm.ClientMembershipGUID
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


/********************************** Get Appointment Data ***********************************************/
INSERT	INTO #Appointment
		SELECT	da.ClientGUID
		,		MAX(da.AppointmentDate) AS 'AppointmentDate'
		FROM	HairClubCMS.dbo.datAppointment da WITH ( NOLOCK )
				INNER JOIN #Client c
					ON c.ClientGUID = da.ClientGUID
				INNER JOIN HairClubCMS.dbo.datAppointmentDetail dad WITH ( NOLOCK )
					ON dad.AppointmentGUID = da.AppointmentGUID
				INNER JOIN HairClubCMS.dbo.cfgSalesCode sc WITH ( NOLOCK )
					ON sc.SalesCodeID = dad.SalesCodeID
				INNER JOIN HairClubCMS.dbo.datAppointmentEmployee ae WITH ( NOLOCK )
					ON ae.AppointmentGUID = da.AppointmentGUID
				INNER JOIN HairClubCMS.dbo.datEmployee de WITH ( NOLOCK )
					ON de.EmployeeGUID = ae.EmployeeGUID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpAppointmentType lat WITH ( NOLOCK )
					ON lat.AppointmentTypeID = da.AppointmentTypeID
		WHERE	ISNULL(lat.AppointmentTypeDescriptionShort, '') <> 'BosleyAppt'
				AND da.IsDeletedFlag = 0
		GROUP BY da.ClientGUID


CREATE NONCLUSTERED INDEX IDX_Appointment_ClientGUID ON #Appointment ( ClientGUID );


UPDATE STATISTICS #Appointment;


/********************************** Get Last Service Data ***********************************************/
;
WITH    LastService ( RowID, ClientGUID, ServiceDate, StylistFirstName, StylistLastName )
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY clt.ClientGUID ORDER BY so.OrderDate DESC ) AS 'RowID'
               ,        clt.ClientGUID
               ,        CAST(so.OrderDate AS DATE) AS 'ServiceDate'
               ,        sty.FirstName AS 'StylistFirstName'
               ,        sty.LastName AS 'StylistLastName'
               FROM     HairClubCMS.dbo.datClient clt
						INNER JOIN #Client c
							ON c.ClientGUID = clt.ClientGUID
                        INNER JOIN HairClubCMS.dbo.datSalesOrder so
                            ON clt.ClientGUID = so.ClientGUID
                        INNER JOIN HairClubCMS.dbo.datSalesOrderDetail sod
                            ON sod.SalesOrderGUID = so.SalesOrderGUID
                        INNER JOIN HairClubCMS.dbo.cfgSalesCode sc
                            ON sc.SalesCodeID = sod.SalesCodeID
                        LEFT OUTER JOIN HairClubCMS.dbo.datEmployee sty
                            ON sty.EmployeeGUID = sod.Employee2GUID
               WHERE    ( sc.SalesCodeDescriptionShort = 'NB1A' -- Initial New Style
                          OR sc.SalesCodeDepartmentID IN ( 5035, 5037 ) ) -- Services
                        AND sc.SalesCodeDescriptionShort NOT IN ( 'XTRPRECHK', 'XTRREDO', 'EXTSVCXTD', 'XTRTRAINSVC', 'XTRPROMOSVC' )
                        AND so.IsVoidedFlag = 0
             )
	INSERT	INTO #Service
			SELECT  ls.ClientGUID
			,       ls.ServiceDate
			,       ls.StylistFirstName
			,       ls.StylistLastName
			FROM    LastService ls
			WHERE   ls.RowID = 1


/********************************** Return Client Data *************************************/
SELECT  ctr.CenterNumber
,       ctr.CenterName
,		ctr.PhoneNumber AS 'CenterPhoneNumber'
,       clt.ClientIdentifier
,       clt.SalesforceContactID
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
,		ISNULL(CONVERT(VARCHAR(11), CAST(s.ServiceDate AS DATE), 101), '') AS 'LastServiceDate'
,		ISNULL(s.StylistFirstName, '') AS 'StylistFirstName'
,		ISNULL(s.StylistLastName, '') AS 'StylistLastName'
,		ISNULL(CONVERT(VARCHAR(11), CAST(o_C.CancelDate AS DATE), 101), '') AS 'CancelDate'
,		ISNULL(o_C.CancelReason, '') AS 'CancelReason'
,		ISNULL(CONVERT(VARCHAR(11), CAST(a.AppointmentDate AS DATE), 101), '') AS 'LastAppointmentDate'
,       ISNULL(clt.Language, 'English') AS 'Language'
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
FROM    #Client clt
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
		LEFT OUTER JOIN #Appointment a
			ON a.ClientGUID = clt.ClientGUID
		LEFT OUTER JOIN #Service s
			ON s.ClientGUID = clt.ClientGUID
        OUTER APPLY ( SELECT TOP 1
                                c.ClientMembershipGUID
                      ,         c.ClientGUID
                      ,         c.CancelDate
                      ,         c.CancelReason
                      FROM      #Cancel c
                      WHERE     c.ClientGUID = clt.ClientGUID
                      ORDER BY  c.CancelDate DESC
                    ) o_C
WHERE   ( ( clt.EmailAddress <> '' AND @RefreshInterval = -45 )
			OR ( clt.Address1 <> '' AND @RefreshInterval = -90 ) )
        AND ISNULL(clt.DoNotContactFlag, 0) = 0 -- Client can be contacted
		AND o_C.CancelDate >= a.AppointmentDate -- Client did not have any appointments after their cancellation date
		AND ( ( cm_xtrp.RevenueGroup = 'Recurring Business' AND cm_xtrp.MembershipStatus = 'Canceled' ) -- Canceled Xtrands Plus Membership
				OR ( cm_ext.RevenueGroup = 'Recurring Business' AND cm_ext.MembershipStatus = 'Canceled' ) -- Canceled EXT Membership
				OR ( cm_xtr.RevenueGroup = 'Recurring Business' AND cm_xtr.MembershipStatus = 'Canceled' ) -- Canceled Xtrands Membership
				OR ( cm_sur.RevenueGroup = 'Recurring Business' AND cm_sur.MembershipStatus = 'Canceled' ) ) -- Canceled Surgery Membership

END
GO
