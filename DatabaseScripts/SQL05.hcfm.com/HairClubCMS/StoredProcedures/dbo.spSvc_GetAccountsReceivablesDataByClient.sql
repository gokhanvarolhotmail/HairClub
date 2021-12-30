/* CreateDate: 10/29/2020 10:48:03.137 , ModifyDate: 10/29/2020 11:11:02.557 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetAccountsReceivablesDataByClient
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/29/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetAccountsReceivablesDataByClient
***********************************************************************/
CREATE PROCEDURE spSvc_GetAccountsReceivablesDataByClient
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE	@CurrentDate DATETIME = CAST(GETDATE() AS DATE)


/********************************** Create temp table objects *************************************/
CREATE TABLE #Center (
	CenterID INT
,	CenterNumber INT
,	CenterName NVARCHAR(50)
,	CenterType NVARCHAR(100)
,	Area NVARCHAR(100)
,	RegionID INT
,	RegionName NVARCHAR(100)
,	Address1 NVARCHAR(50)
,	Address2 NVARCHAR(50)
,	City NVARCHAR(50)
,	StateCode NVARCHAR(10)
,	ZipCode NVARCHAR(15)
,	Country NVARCHAR(100)
,	Timezone NVARCHAR(100)
,	PhoneNumber NVARCHAR(15)
)

CREATE TABLE #Client ( ClientGUID UNIQUEIDENTIFIER )

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


/********************************** Get Center Data *************************************/
INSERT INTO #Center
		SELECT	ctr.CenterID
		,		ctr.CenterNumber
		,		ctr.CenterDescription AS 'CenterName'
		,		dct.CenterTypeDescription AS 'CenterType'
		,		ISNULL(cma.CenterManagementAreaDescription, 'Corporate') AS 'Area'
		,		ISNULL(lr.RegionID, 1) AS 'RegionID'
		,		ISNULL(lr.RegionDescription, 'Corporate') AS 'RegionName'
		,		ctr.Address1
		,		ctr.Address2
		,		ctr.City
		,		ls.StateDescriptionShort AS 'StateCode'
		,		ctr.PostalCode AS 'ZipCode'
		,		lc.CountryDescription AS 'Country'
		,		tz.TimeZoneDescriptionShort AS 'Timezone'
		,		ctr.Phone1 AS 'PhoneNumber'
		FROM	HairClubCMS.dbo.cfgCenter ctr
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
				LEFT OUTER JOIN HairClubCMS.dbo.cfgCenterManagementArea cma
					ON cma.CenterManagementAreaID = ctr.CenterManagementAreaID
		WHERE	dct.CenterTypeDescriptionShort IN ( 'C', 'HW' )
				AND ( ctr.CenterNumber IN ( 360, 199 ) OR ctr.IsActiveFlag = 1 )


CREATE NONCLUSTERED INDEX IDX_Center_CenterID ON #Center (CenterID);
CREATE NONCLUSTERED INDEX IDX_Center_CenterNumber ON #Center (CenterNumber);


UPDATE STATISTICS #Center;


/********************************** Get Client Data *************************************/
INSERT INTO #Client
		SELECT	DISTINCT
				clt.ClientGUID
		FROM	HairClubCMS.dbo.datClient clt
				INNER JOIN #Center c
					ON c.CenterID = clt.CenterID
		WHERE	clt.ARBalance > 0


CREATE NONCLUSTERED INDEX IDX_Client_ClientGUID ON #Client (ClientGUID);


UPDATE STATISTICS #Client;


/********************************** Get Client Membership Data *************************************/
INSERT	INTO #ClientMembership
		SELECT  cm.ClientMembershipGUID
		,		c.ClientGUID
		,		m.MembershipDescription AS 'Membership'
		,		bs.BusinessSegmentDescription AS 'BusinessSegment'
		,		rg.RevenueGroupDescription AS 'RevenueGroup'
		,		cm.BeginDate
		,		cm.EndDate
		,		cms.ClientMembershipStatusDescription AS 'MembershipStatus'
		FROM    HairClubCMS.dbo.datClientMembership cm WITH ( NOLOCK )
				INNER JOIN #Client c
					ON c.ClientGUID = cm.ClientGUID
				INNER JOIN HairClubCMS.dbo.cfgMembership m WITH ( NOLOCK )
					ON m.MembershipID = cm.MembershipID
				INNER JOIN HairClubCMS.dbo.lkpClientMembershipStatus cms WITH ( NOLOCK )
					ON cms.ClientMembershipStatusID = cm.ClientMembershipStatusID
				INNER JOIN HairClubCMS.dbo.lkpRevenueGroup rg WITH ( NOLOCK )
					ON rg.RevenueGroupID = m.RevenueGroupID
				INNER JOIN HairClubCMS.dbo.lkpBusinessSegment bs WITH ( NOLOCK )
					ON bs.BusinessSegmentID = m.BusinessSegmentID
		WHERE	cms.ClientMembershipStatusDescription = 'Active'


CREATE NONCLUSTERED INDEX IDX_ClientMembership_ClientGUID ON #ClientMembership (ClientGUID);
CREATE NONCLUSTERED INDEX IDX_ClientMembership_ClientMembershipGUID ON #ClientMembership (ClientMembershipGUID);


UPDATE STATISTICS #ClientMembership;


/********************************** Get Client Phone Data *************************************/
INSERT INTO #ClientPhone
		SELECT	dcp.ClientGUID
		,		dcp.PhoneNumber
		,		pt.PhoneTypeDescription AS 'PhoneType'
		,		dcp.CanConfirmAppointmentByCall
		,		dcp.CanConfirmAppointmentByText
		,		dcp.CanContactForPromotionsByCall
		,		dcp.CanContactForPromotionsByText
		,		dcp.ClientPhoneSortOrder
		FROM	HairClubCMS.dbo.datClientPhone dcp WITH (NOLOCK)
				INNER JOIN #Client c
					ON c.ClientGUID = dcp.ClientGUID
				INNER JOIN HairClubCMS.dbo.lkpPhoneType pt WITH (NOLOCK)
					ON pt.PhoneTypeID = dcp.PhoneTypeID
		GROUP BY dcp.ClientGUID
		,		dcp.PhoneNumber
		,		pt.PhoneTypeDescription
		,		dcp.CanConfirmAppointmentByCall
		,		dcp.CanConfirmAppointmentByText
		,		dcp.CanContactForPromotionsByCall
		,		dcp.CanContactForPromotionsByText
		,		dcp.ClientPhoneSortOrder


CREATE NONCLUSTERED INDEX IDX_ClientPhone_ClientGUID ON #ClientPhone (ClientGUID);


UPDATE STATISTICS #ClientPhone;


/********************************** Get Client AR Data *************************************/
SELECT	ctr.CenterNumber
,		ctr.CenterName
,		clt.ClientIdentifier
,		clt.FirstName
,		clt.LastName
,		clt.Address1
,		ISNULL(clt.Address2, '') AS 'Address2'
,		ISNULL(clt.Address3, '') AS 'Address3'
,		s.StateDescriptionShort AS 'StateCode'
,		clt.PostalCode AS 'ZipCode'
,		cty.CountryDescriptionShort AS 'CountryCode'
,		cp.PhoneNumber
,		cp.PhoneType
,		cm.Membership
,		cm.BeginDate
,		cm.EndDate
,		cm.RevenueGroup
,		cm.BusinessSegment
,		cm.MembershipStatus
,		pc.FeePayCycleDescription AS 'EFTPayCycle'
,		eat.EFTAccountTypeDescription AS 'EFTType'
,		so.InvoiceNumber
,		CAST(so.OrderDate AS DATE) AS 'OrderDate'
,		sc.SalesCodeDescriptionShort
,		sc.SalesCodeDescription
,		sc.SalesCodeDepartmentID
,		CASE WHEN art.AccountReceivableTypeDescription = 'AR Payment' THEN ( ar.Amount * -1 ) ELSE ar.Amount END AS 'Amount'
,		clt.ARBalance AS 'CurrentARBalance'
,		art.AccountReceivableTypeDescription AS 'AccountReceivableType'
INTO	#AccountsReceivable
FROM	HairClubCMS.dbo.datAccountReceivable ar
		INNER JOIN HairClubCMS.dbo.datSalesOrder so
			ON so.SalesOrderGUID = ar.SalesOrderGUID
		INNER JOIN HairClubCMS.dbo.datSalesOrderDetail sod
			ON sod.SalesOrderGUID = so.SalesOrderGUID
		INNER JOIN HairClubCMS.dbo.cfgSalesCode sc
			ON sc.SalesCodeID = sod.SalesCodeID
		INNER JOIN HairClubCMS.dbo.lkpAccountReceivableType art
			ON art.AccountReceivableTypeID = ar.AccountReceivableTypeID
		INNER JOIN HairClubCMS.dbo.datClient clt
			ON clt.ClientGUID = ar.ClientGUID
		INNER JOIN #Center ctr
			ON ctr.CenterID = clt.CenterID
		INNER JOIN #ClientMembership cm
			ON cm.ClientGUID = so.ClientGUID
				AND cm.ClientMembershipGUID = so.ClientMembershipGUID
		LEFT OUTER JOIN HairClubCMS.dbo.datClientEFT ce
			ON ce.ClientGUID = cm.ClientGUID
				AND ce.ClientMembershipGUID = cm.ClientMembershipGUID
		LEFT OUTER JOIN HairClubCMS.dbo.lkpFeePayCycle pc
			ON pc.FeePayCycleID = ce.FeePayCycleID
		LEFT OUTER JOIN lkpEFTAccountType eat
			ON eat.EFTAccountTypeID = ce.EFTAccountTypeID
		LEFT OUTER JOIN #ClientPhone cp
			ON cp.ClientGUID = clt.ClientGUID
				AND cp.ClientPhoneSortOrder = 1
		LEFT OUTER JOIN HairClubCMS.dbo.lkpState s
			ON s.StateID = clt.StateID
		LEFT OUTER JOIN HairClubCMS.dbo.lkpCountry cty
			ON cty.CountryID = clt.CountryID
WHERE	( ( art.AccountReceivableTypeDescription = 'AR Charge' )
		OR ( art.AccountReceivableTypeDescription = 'AR Payment' AND sc.SalesCodeDescriptionShort = 'PMTRCVD' ) )


/********************************** Return Client AR Data *************************************/
SELECT	ar.CenterNumber
,		ar.CenterName
,		ar.ClientIdentifier
,		ar.FirstName
,		ar.LastName
,		ar.Address1
,		ar.Address2
,		ar.Address3
,		ar.StateCode
,		ar.ZipCode
,		ar.CountryCode
,		ar.PhoneNumber
,		ar.PhoneType
,		ar.Membership
,		ar.BeginDate
,		ar.EndDate
,		ar.RevenueGroup
,		ar.BusinessSegment
,		ar.MembershipStatus
,		ar.EFTPayCycle
,		ar.EFTType
,		ar.InvoiceNumber
,		ar.OrderDate
,		ar.SalesCodeDescriptionShort
,		ar.SalesCodeDescription
,		ar.SalesCodeDepartmentID
,		ar.Amount
,		ar.CurrentARBalance
,		ar.AccountReceivableType
FROM	#AccountsReceivable ar

END
GO
