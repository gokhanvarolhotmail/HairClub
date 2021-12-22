/* CreateDate: 03/26/2021 09:59:36.517 , ModifyDate: 03/26/2021 09:59:36.517 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_GetARSummaryData
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		3/26/2021
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetARSummaryData
***********************************************************************/
CREATE PROCEDURE spSvc_GetARSummaryData
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

CREATE TABLE #Client (
	Area NVARCHAR(100)
,	CenterID INT
,	CenterNumber INT
,	CenterName NVARCHAR(50)
,	CenterType NVARCHAR(100)
,	ClientGUID UNIQUEIDENTIFIER
,	ClientIdentifier INT
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Address1 NVARCHAR(50)
,	Address2 NVARCHAR(50)
,	Address3 NVARCHAR(50)
,	StateCode NVARCHAR(10)
,	ZipCode NVARCHAR(10)
,	CountryCode NVARCHAR(10)
,	CurrentARBalance MONEY
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

CREATE TABLE #AccountsReceivable (
	Area NVARCHAR(100)
,	CenterID INT
,	CenterNumber INT
,	CenterName NVARCHAR(50)
,	ClientGUID UNIQUEIDENTIFIER
,	ClientIdentifier INT
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Address1 NVARCHAR(50)
,	Address2 NVARCHAR(50)
,	Address3 NVARCHAR(50)
,	StateCode NVARCHAR(10)
,	ZipCode NVARCHAR(10)
,	CountryCode NVARCHAR(10)
,	PhoneNumber NVARCHAR(15)
,	PhoneType NVARCHAR(100)
,	Membership NVARCHAR(50)
,	BeginDate DATETIME
,	EndDate DATETIME
,	RevenueGroup NVARCHAR(100)
,	BusinessSegment NVARCHAR(100)
,	MembershipStatus NVARCHAR(100)
,	EFTPayCycle NVARCHAR(100)
,	EFTType NVARCHAR(100)
,	SalesOrderGUID UNIQUEIDENTIFIER
,	InvoiceNumber NVARCHAR(50)
,	SalesCodeDescription NVARCHAR(MAX)
,	OrderDate DATETIME
,	Amount MONEY
,	RemainingBalance MONEY
,	CurrentARBalance MONEY
,	AccountReceivableType NVARCHAR(100)
,	CreateDate DATETIME
,	IsClosed BIT
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
		SELECT	c.Area
		,		c.CenterID
		,		c.CenterNumber
		,		c.CenterName
		,		c.CenterType
		,		clt.ClientGUID
		,		clt.ClientIdentifier
		,		clt.FirstName
		,		clt.LastName
		,		ISNULL(clt.Address1, '') AS 'Address1'
		,		ISNULL(clt.Address2, '') AS 'Address2'
		,		ISNULL(clt.Address3, '') AS 'Address3'
		,		ISNULL(s.StateDescriptionShort, '') AS 'StateCode'
		,		ISNULL(clt.PostalCode, '') AS 'ZipCode'
		,		ISNULL(cty.CountryDescriptionShort, '') AS 'CountryCode'
		,		clt.ARBalance AS 'CurrentARBalance'
		FROM	HairClubCMS.dbo.datClient clt
				INNER JOIN #Center c
					ON c.CenterID = clt.CenterID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpState s
					ON s.StateID = clt.StateID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpCountry cty
					ON cty.CountryID = clt.CountryID
		WHERE	clt.ARBalance <> 0


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
INSERT	INTO #AccountsReceivable
		SELECT	c.Area
		,		c.CenterID
		,		c.CenterNumber
		,		c.CenterName
		,		c.ClientGUID
		,		c.ClientIdentifier
		,		c.FirstName
		,		c.LastName
		,		c.Address1
		,		c.Address2
		,		c.Address3
		,		c.StateCode
		,		c.ZipCode
		,		c.CountryCode
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
		,		so.SalesOrderGUID
		,		so.InvoiceNumber
		,		x_Sc.SalesCodeDescription
		,		CAST(so.OrderDate AS DATE) AS 'OrderDate'
		,		CASE WHEN art.AccountReceivableTypeDescription IN ( 'Beginning AR Charge', 'AR Charge', 'Payment Refund' ) THEN ar.Amount
							ELSE (ar.Amount * -1)
				END AS 'Amount'
		,		ar.RemainingBalance
		,		c.CurrentARBalance
		,		art.AccountReceivableTypeDescription AS 'AccountReceivableType'
		,		CAST(ar.CreateDate AS DATE) AS 'CreateDate'
		,		ar.IsClosed
		FROM	HairClubCMS.dbo.datAccountReceivable ar
				INNER JOIN HairClubCMS.dbo.datSalesOrder so
					ON so.SalesOrderGUID = ar.SalesOrderGUID
				INNER JOIN HairClubCMS.dbo.lkpAccountReceivableType art
					ON art.AccountReceivableTypeID = ar.AccountReceivableTypeID
				INNER JOIN #Client c
					ON c.ClientGUID = ar.ClientGUID
				INNER JOIN #ClientMembership cm
					ON cm.ClientGUID = so.ClientGUID
					AND cm.ClientMembershipGUID = so.ClientMembershipGUID
				CROSS APPLY (
					SELECT	STRING_AGG(sc.SalesCodeDescription, ', ') AS 'SalesCodeDescription'
					FROM	HairClubCMS.dbo.datSalesOrder so
							INNER JOIN HairClubCMS.dbo.datSalesOrderDetail sod
								ON sod.SalesOrderGUID = so.SalesOrderGUID
							INNER JOIN HairClubCMS.dbo.cfgSalesCode sc
								ON sc.SalesCodeID = sod.SalesCodeID
							INNER JOIN HairClubCMS.dbo.lkpSalesCodeType sct
								ON sct.SalesCodeTypeID = sc.SalesCodeTypeID
					WHERE	so.SalesOrderGUID = ar.SalesOrderGUID
							AND ISNULL(so.IsVoidedFlag, 0) = 0
				) x_Sc
				LEFT OUTER JOIN HairClubCMS.dbo.datClientEFT ce
					ON ce.ClientGUID = cm.ClientGUID
					AND ce.ClientMembershipGUID = cm.ClientMembershipGUID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpFeePayCycle pc
					ON pc.FeePayCycleID = ce.FeePayCycleID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpEFTAccountType eat
					ON eat.EFTAccountTypeID = ce.EFTAccountTypeID
				LEFT OUTER JOIN #ClientPhone cp
					ON cp.ClientGUID = c.ClientGUID
					AND cp.ClientPhoneSortOrder = 1


/********************************** Return Client AR Data Summary *************************************/
SELECT	c.Area
,		c.CenterNumber
,		c.CenterName
,		c.CenterType
,		c.ClientIdentifier
,		c.FirstName
,		c.LastName
,		c.Address1
,		c.Address2
,		c.Address3
,		c.StateCode
,		c.ZipCode
,		c.CountryCode
,		c.CurrentARBalance
FROM	#Client c
		LEFT OUTER JOIN #ClientPhone cp
			ON cp.ClientGUID = c.ClientGUID
			AND cp.ClientPhoneSortOrder = 1
ORDER BY c.Area
,		c.CenterName
,		c.ClientIdentifier

END
GO
