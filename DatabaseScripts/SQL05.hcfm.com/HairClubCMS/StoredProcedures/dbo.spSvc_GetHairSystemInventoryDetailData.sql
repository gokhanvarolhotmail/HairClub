/* CreateDate: 03/26/2021 09:55:45.717 , ModifyDate: 06/02/2021 14:11:50.270 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetHairSystemInventoryDetailData
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

EXEC spSvc_GetHairSystemInventoryDetailData
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetHairSystemInventoryDetailData]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE	@CurrentDate DATETIME


SET @CurrentDate = GETDATE()


CREATE TABLE #HairSystemInventoryBatch (
	HairSystemInventoryBatchID INT IDENTITY(1,1)
,	CenterID INT
,	CenterNumber INT
,	CenterName NVARCHAR(103)
)

CREATE TABLE #HairSystemInventoryTransaction (
	HairSystemTransactionID INT IDENTITY(1,1)
,	HairSystemInventoryBatchID INT
,	HairSystemOrderGUID UNIQUEIDENTIFIER
,	HairSystemOrderNumber NVARCHAR(50)
,	HairSystemOrderStatusID INT
,	IsInTransit BIT
,	ClientGUID UNIQUEIDENTIFIER
,	ClientMembershipGUID UNIQUEIDENTIFIER
,	ClientIdentifier INT
,	ClientHomeCenterID INT
)

CREATE TABLE #Priority (
	RowID INT
,	HairSystemOrderNumber NVARCHAR(50)
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	ClientIdentifier INT
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Membership NVARCHAR(50)
,	TransactionDate DATE
,	StatusToCode NVARCHAR(10)
,	StatusTo NVARCHAR(100)
,	PriorityReason NVARCHAR(100)
)


INSERT	INTO #HairSystemInventoryBatch
		SELECT	c.CenterID
		,		c.CenterNumber
		,		c.CenterDescriptionFullCalc AS 'CenterName'
		FROM	cfgCenter c
				INNER JOIN cfgConfigurationCenter cc
					ON cc.CenterID = c.CenterID
				INNER JOIN lkpCenterBusinessType bt
					ON bt.CenterBusinessTypeID = cc.CenterBusinessTypeID
		WHERE	c.IsActiveFlag = 1
				AND bt.CenterBusinessTypeDescriptionShort IN ( 'cONEctCorp', 'cONEctHQ', 'HW', 'AEU' )
				AND c.CenterNumber NOT IN ( 901, 902, 903, 904, 103 ) -- Exclude Virtual Centers
		ORDER BY c.CenterID


INSERT	INTO #HairSystemInventoryTransaction
		SELECT	batch.HairSystemInventoryBatchID
		,		hso.HairSystemOrderGUID
		,		hso.HairSystemOrderNumber
		,		hso.HairSystemOrderStatusID
		,		hstat.IsInTransitFlag AS 'IsInTransit'
		,		hso.ClientGUID
		,		hso.ClientMembershipGUID
		,		c.ClientIdentifier
		,		c.CenterID
		FROM	datHairSystemOrder hso
				INNER JOIN #HairSystemInventoryBatch batch
					ON batch.CenterID = hso.CenterID
				INNER JOIN datClient c
					ON c.ClientGUID = hso.ClientGUID
				INNER JOIN lkpHairSystemOrderStatus hstat
					ON hstat.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
		WHERE	hstat.IncludeInInventorySnapshotFlag = 1
				AND hso.DueDate <= CONVERT(DATE, @CurrentDate)


SELECT	CAST(@CurrentDate AS DATE) AS 'Date'
,		CONVERT(NVARCHAR(11), @CurrentDate, 108) AS 'Time'
,		ISNULL(CONVERT(VARCHAR, o_Po.PurchaseOrderNumber), '') AS 'PurchaseOrderNumber'
,		o_Po.FactoryCode
,		o_Po.Factory
,		o_Po.VendorAddress2
,		hso.HairSystemOrderNumber
,		ctr_hso.CenterID AS 'HairSystemCenterID'
,		ctr_hso.CenterNumber AS 'HairSystemCenterNumber'
,		ctr_hso.CenterDescriptionFullCalc AS 'HairSystemCenterName'
,		ct_hso.CenterTypeDescriptionShort AS 'HairSystemCenterType'
,		hso.HairSystemOrderDate
,		hso.DueDate
,		hsos.HairSystemOrderStatusDescriptionShort AS 'HairSystemOrderStatus'
,		hsos.HairSystemOrderStatusDescription
,		ctr_clt.CenterID AS 'ClientCenterID'
,		ctr_clt.CenterNumber AS 'ClientCenterNumber'
,		ctr_clt.CenterDescriptionFullCalc AS 'ClientCenterName'
,		ct_clt.CenterTypeDescriptionShort AS 'ClientCenterType'
,		c.ClientIdentifier
,		c.FirstName
,		c.LastName
,		rg.RevenueGroupDescription AS 'RevenueGroup'
,		bs.BusinessSegmentDescription AS 'BusinessSegment'
,		m.MembershipDescription AS 'Membership'
,		cm.BeginDate
,		cm.EndDate
,		cms.ClientMembershipStatusDescription AS 'MembershipStatus'
,		hso.CostContract
,		hso.CostActual
,		hso.CostFactoryShipped
INTO	#HairSystem
FROM	datHairSystemOrder hso
		INNER JOIN #HairSystemInventoryTransaction hsit
			ON hsit.HairSystemOrderNumber = hso.HairSystemOrderNumber
		LEFT JOIN cfgCenter ctr_hso
			ON ctr_hso.CenterID = hso.CenterID
				AND ctr_hso.IsActiveFlag = 1
		LEFT JOIN lkpCenterType ct_hso
			ON ct_hso.CenterTypeID = ctr_hso.CenterTypeID
		LEFT JOIN cfgCenter ctr_clt
			ON ctr_clt.CenterID = hso.ClientHomeCenterID
				AND ctr_clt.IsActiveFlag = 1
		LEFT JOIN lkpCenterType ct_clt
			ON ct_clt.CenterTypeID = ctr_clt.CenterTypeID
		LEFT JOIN datClient c
			ON hso.ClientGUID = c.ClientGUID
		LEFT JOIN datClientMembership cm
			ON hso.ClientMembershipGUID = cm.ClientMembershipGUID
		LEFT JOIN cfgMembership m
			ON cm.MembershipID = m.MembershipID
		LEFT JOIN HairClubCMS.dbo.lkpRevenueGroup rg
			ON rg.RevenueGroupID = m.RevenueGroupID
		LEFT JOIN HairClubCMS.dbo.lkpBusinessSegment bs
			ON bs.BusinessSegmentID = m.BusinessSegmentID
		LEFT JOIN lkpClientMembershipStatus cms
			ON cms.ClientMembershipStatusID = cm.ClientMembershipStatusID
		LEFT JOIN lkpHairSystemOrderStatus hsos
			ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
		OUTER APPLY (
			SELECT	po.PurchaseOrderNumber
			,		CONVERT(DATE, po.PurchaseOrderDate) AS 'PurchaseOrderDate'
			,		ISNULL(v.VendorDescriptionShort, '') AS 'FactoryCode'
			,		ISNULL(v.VendorDescription, '') AS 'Factory'
			,		ISNULL(VendorAddress2, '') AS 'VendorAddress2'
			FROM	datPurchaseOrder po
					INNER JOIN datPurchaseOrderDetail pod
						ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID
					LEFT JOIN cfgVendor v
						ON po.VendorID = v.VendorID
			WHERE	pod.HairSystemOrderGUID = hso.HairSystemOrderGUID
			GROUP BY po.PurchaseOrderNumber
			,		CONVERT(DATE, po.PurchaseOrderDate)
			,		ISNULL(v.VendorDescriptionShort, '')
			,		ISNULL(v.VendorDescription, '')
			,		ISNULL(VendorAddress2, '')
		) o_Po


/********************************** Get Hair System Transaction Data *************************************/
INSERT	INTO #Priority
		SELECT	ROW_NUMBER() OVER ( PARTITION BY hso.HairSystemOrderNumber, st.HairSystemOrderStatusDescriptionShort ORDER BY hsot.HairSystemOrderTransactionDate DESC ) AS 'RowID'
		,		hso.HairSystemOrderNumber
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		clt.ClientIdentifier
		,		clt.FirstName
		,		clt.LastName
		,		m.MembershipDescription AS 'Membership'
		,		CAST(hsot.HairSystemOrderTransactionDate AS DATE) AS 'TransactionDate'
		,		st.HairSystemOrderStatusDescriptionShort AS 'StatusToCode'
		,		st.HairSystemOrderStatusDescription AS 'StatusTo'
		,		ISNULL(prhr.HairSystemOrderPriorityReasonDescription, '') AS 'PriorityReason'
		FROM	HairClubCMS.dbo.datHairSystemOrderTransaction hsot
				INNER JOIN HairClubCMS.dbo.datHairSystemOrder hso
					ON hso.HairSystemOrderGUID = hsot.HairSystemOrderGUID
				INNER JOIN #HairSystem hs
					ON hs.HairSystemOrderNumber = hso.HairSystemOrderNumber
				INNER JOIN HairClubCMS.dbo.cfgCenter ctr
					ON ctr.CenterID = hsot.CenterID
				INNER JOIN HairClubCMS.dbo.datClient clt
					ON clt.ClientGUID = hsot.ClientGUID
				INNER JOIN HairClubCMS.dbo.datClientMembership cm
					ON cm.ClientMembershipGUID = hsot.ClientMembershipGUID
				INNER JOIN HairClubCMS.dbo.cfgMembership m
					ON m.MembershipID = cm.MembershipID
				INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus cs --Current Status
					ON cs.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
				INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus sf --Status From
					ON sf.HairSystemOrderStatusID = hsot.PreviousHairSystemOrderStatusID
				INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus st --Status To
					ON st.HairSystemOrderStatusID = hsot.NewHairSystemOrderStatusID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpHairSystemOrderPriorityReason prhr
					ON prhr.HairSystemOrderPriorityReasonID = hsot.HairSystemOrderPriorityReasonID
		WHERE	st.HairSystemOrderStatusDescriptionShort = 'PRIORITY'


CREATE NONCLUSTERED INDEX IDX_HairSystemTransactions_RowID ON #Priority ( RowID );
CREATE NONCLUSTERED INDEX IDX_HairSystemTransactions_HairSystemOrderNumber ON #Priority ( HairSystemOrderNumber );
CREATE NONCLUSTERED INDEX IDX_HairSystemTransactions_StatusToCode ON #Priority ( StatusToCode );


UPDATE STATISTICS #Priority;


/********************************** Return Data *************************************/
SELECT	hs.Date
,		hs.Time
,		hs.PurchaseOrderNumber
,		hs.FactoryCode
,		REPLACE(hs.Factory, ',', '') AS 'Factory'
,		hs.HairSystemOrderNumber
,		hs.HairSystemCenterID
,		hs.HairSystemCenterNumber
,		hs.HairSystemCenterName
,		CONVERT(DATE, hs.HairSystemOrderDate) AS 'HairSystemOrderDate'
,		CAST(ISNULL(hst_prh.TransactionDate, '1/1/1900') AS DATE) AS 'HairSystemPriorityDate'
,		CONVERT(DATE, hs.DueDate) AS 'HairSystemDueDate'
,		hs.HairSystemOrderStatus
,		hs.HairSystemOrderStatusDescription
,		hs.ClientCenterID
,		hs.ClientCenterNumber
,		hs.ClientCenterName
,		hs.ClientIdentifier
,		REPLACE(hs.FirstName, ',', '') AS 'FirstName'
,		REPLACE(hs.LastName, ',', '') AS 'LastName'
,		hs.RevenueGroup
,		hs.BusinessSegment
,		hs.Membership
,		CONVERT(DATE, hs.BeginDate) AS 'BeginDate'
,		CONVERT(DATE, hs.EndDate) AS 'EndDate'
,		hs.MembershipStatus
,		hs.CostContract
,		hs.CostActual
,		hs.CostFactoryShipped
FROM	#HairSystem hs
		LEFT OUTER JOIN #Priority hst_prh
			ON hst_prh.HairSystemOrderNumber = hs.HairSystemOrderNumber
				AND hst_prh.StatusToCode = 'PRIORITY'
				AND hst_prh.RowID = 1

END
GO
