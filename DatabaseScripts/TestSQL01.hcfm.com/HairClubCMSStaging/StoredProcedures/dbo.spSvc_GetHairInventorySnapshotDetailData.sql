/* CreateDate: 05/29/2020 16:28:31.653 , ModifyDate: 02/11/2021 14:14:01.643 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_GetHairInventorySnapshotDetailData
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		5/28/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetHairInventorySnapshotDetailData
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetHairInventorySnapshotDetailData]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


CREATE TABLE #HairSystemTransactions (
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


DECLARE	@HairSystemInventorySnapshotID INT


SELECT TOP 1 @HairSystemInventorySnapshotID = HairSystemInventorySnapshotID FROM HairClubCMS.dbo.datHairSystemInventorySnapshot ORDER BY SnapshotDate DESC


SELECT	CAST(hsis.SnapshotDate AS DATE) AS 'SnapshotDate'
,		CONVERT(NVARCHAR(11), hsis.SnapshotDate, 108) AS 'SnapshotTime'
,		ctr_b.CenterNumber AS 'SnapshotCenterNumber'
,		ctr_b.CenterDescriptionFullCalc AS 'SnapshotCenterName'
,		ctr_hso.CenterNumber AS 'HSOCenterNumber'
,		ctr_hso.CenterDescriptionFullCalc AS 'HSOCenterName'
,		hso.HairSystemOrderNumber
,		CAST(hso.HairSystemOrderDate AS DATE) AS 'HairSystemOrderDate'
,		hsos.HairSystemOrderStatusDescription AS 'SnapshotHairSystemOrderStatus'
,		hsit.ScannedDate
,		hsit.IsScannedEntry
,		clt.ClientIdentifier
,		clt.FirstName
,		clt.LastName
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
FROM	HairClubCMS.dbo.datHairSystemInventorySnapshot hsis
		INNER JOIN HairClubCMS.dbo.datHairSystemInventoryBatch hsib
			ON hsib.HairSystemInventorySnapshotID = hsis.HairSystemInventorySnapshotID
		INNER JOIN HairClubCMS.dbo.datHairSystemInventoryTransaction hsit
			ON hsit.HairSystemInventoryBatchID = hsib.HairSystemInventoryBatchID
		INNER JOIN HairClubCMS.dbo.datHairSystemOrder hso
			ON hso.HairSystemOrderGUID = hsit.HairSystemOrderGUID
		INNER JOIN HairClubCMS.dbo.cfgCenter ctr_b
			ON ctr_b.CenterID = hsib.CenterID
		INNER JOIN HairClubCMS.dbo.cfgCenter ctr_hso
			ON ctr_hso.CenterID = hso.CenterID
		INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus hsos
			ON hsos.HairSystemOrderStatusID = hsit.HairSystemOrderStatusID
		INNER JOIN HairClubCMS.dbo.datClientMembership cm
			ON cm.ClientMembershipGUID = hsit.ClientMembershipGUID
		INNER JOIN HairClubCMS.dbo.cfgMembership m
			ON m.MembershipID = cm.MembershipID
		INNER JOIN HairClubCMS.dbo.lkpRevenueGroup rg
			ON rg.RevenueGroupID = m.RevenueGroupID
		INNER JOIN HairClubCMS.dbo.lkpBusinessSegment bs
			ON bs.BusinessSegmentID = m.BusinessSegmentID
		INNER JOIN HairClubCMS.dbo.datClient clt
			ON clt.ClientGUID = hsit.ClientGUID
		INNER JOIN HairClubCMS.dbo.lkpClientMembershipStatus cms
			ON cms.ClientMembershipStatusID = cm.ClientMembershipStatusID
WHERE	hsis.HairSystemInventorySnapshotID = @HairSystemInventorySnapshotID


/********************************** Get Hair System Transaction Data *************************************/
INSERT	INTO #HairSystemTransactions
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


CREATE NONCLUSTERED INDEX IDX_HairSystemTransactions_RowID ON #HairSystemTransactions ( RowID );
CREATE NONCLUSTERED INDEX IDX_HairSystemTransactions_HairSystemOrderNumber ON #HairSystemTransactions ( HairSystemOrderNumber );
CREATE NONCLUSTERED INDEX IDX_HairSystemTransactions_StatusToCode ON #HairSystemTransactions ( StatusToCode );


UPDATE STATISTICS #HairSystemTransactions;


/********************************** Return Data *************************************/
SELECT	hs.SnapshotDate
,		hs.SnapshotTime
,		hs.SnapshotCenterNumber
,		hs.SnapshotCenterName
,		hs.HSOCenterNumber
,		hs.HSOCenterName
,		hs.HairSystemOrderNumber
,		CAST(hs.HairSystemOrderDate AS DATE) AS 'HairSystemOrderDate'
,		CAST(ISNULL(hst_prh.TransactionDate, '1/1/1900') AS DATE) AS 'HairSystemPriorityDate'
,		hs.SnapshotHairSystemOrderStatus
,		hs.ScannedDate
,		hs.IsScannedEntry
,		hs.ClientIdentifier
,		hs.FirstName
,		hs.LastName
,		hs.RevenueGroup
,		hs.BusinessSegment
,		hs.Membership
,		hs.BeginDate
,		hs.EndDate
,		hs.MembershipStatus
,		hs.CostContract
,		hs.CostActual
,		hs.CostFactoryShipped
FROM	#HairSystem hs
		LEFT OUTER JOIN #HairSystemTransactions hst_prh
			ON hst_prh.HairSystemOrderNumber = hs.HairSystemOrderNumber
				AND hst_prh.StatusToCode = 'PRIORITY'
				AND hst_prh.RowID = 1
ORDER BY hs.SnapshotCenterNumber
,		hs.HSOCenterNumber

END
GO
