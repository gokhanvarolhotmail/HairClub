/***********************************************************************
PROCEDURE:				spSvc_GetSerializedInventorySnapshotData
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

EXEC spSvc_GetSerializedInventorySnapshotData
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetSerializedInventorySnapshotData]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @SerializedInventoryAuditSnapshotID INT


SELECT TOP 1 @SerializedInventoryAuditSnapshotID = SerializedInventoryAuditSnapshotID FROM HairClubCMS.dbo.datSerializedInventoryAuditSnapshot ORDER BY SnapshotDate DESC


SELECT	CONVERT(VARCHAR(11), s.SnapshotDate, 101) AS 'Snapshot Date'
,		c.CenterNumber AS 'CenterID'
,		c.CenterDescriptionFullCalc AS 'Center Name'
,		ISNULL(cma.CenterManagementAreaDescription, 'Corporate') AS 'Area'
,		bs.InventoryAuditBatchStatusDescription AS 'Center Audit Status'
,		ISNULL(CONVERT(VARCHAR(11), b.CompleteDate, 101), '') AS 'Completed Date'
,		ISNULL(e.FirstName, '') + ' ' + ISNULL(e.LastName, '') AS 'Completed By'
,		CASE WHEN b.IsReviewCompleted = 1 THEN 'Yes' ELSE 'No' END AS 'Review Completed'
,		CASE WHEN b.IsReviewCompleted = 0 THEN '' ELSE CONVERT(VARCHAR(11), b.ReviewCompleteDate, 101) END AS 'Review Completed Date'
,		ISNULL(e_rv.FirstName, '') + ' ' + ISNULL(e_rv.LastName, '') AS 'Reviewed By'
,		CASE WHEN b.IsAdjustmentCompleted = 1 THEN 'Yes' ELSE 'No' END AS 'Adjustment Completed'
,		CASE WHEN b.IsAdjustmentCompleted = 0 THEN '' ELSE CONVERT(VARCHAR(11), b.LastUpdate, 101) END AS 'Adjustment Date'
,		CASE WHEN t.IsExcludedFromCorrections = 1 THEN 'Yes' ELSE 'No' END AS 'Excluded From Adjustment'
,		ISNULL(t.ExclusionReason, '') AS 'Exclusion Reason'
,		sc.SalesCodeDescriptionShort AS 'Item SKU'
,		sc.SalesCodeDescription AS 'Item Description'
,		scci.QuantityOnHand AS 'Current Quantity'
,		t.QuantityExpected AS 'Expected Quantity'
,		ISNULL(tacount.TotalQuantityScanned, 0) AS 'Entered Quantity'
,		(ISNULL(tacount.TotalQuantityScanned, 0) - t.QuantityExpected) AS 'Variance'
,		scc.CenterCost AS 'Per Item Cost'
,		(ISNULL(tacount.TotalQuantityScanned, 0) - t.QuantityExpected) * scc.CenterCost AS 'Variance Cost'
,		CASE WHEN ts.IsScannedEntry IS NULL THEN 'N/A'
			WHEN ts.IsScannedEntry = 0 THEN 'Yes'
			ELSE 'No'
		END AS 'Typed Serialized Entry'
,		ts.SerialNumber AS 'Serial Number'
,		currsis.SerializedInventoryStatusDescription AS 'Current Status'
,		sis.SerializedInventoryStatusDescription AS 'Snapshot Status'
,		CASE WHEN sis.IsInTransit IS NULL THEN 'N/A'
			WHEN sis.IsInTransit = 1 THEN 'Yes'
			ELSE 'No'
		END AS 'In Transit'
,		CONVERT(VARCHAR, adj.InventoryAdjustmentDate, 1) AS 'Status Date'
,		CASE WHEN sis.SerializedInventoryStatusDescriptionShort = 'Xfer' THEN adj.FromCenter
			ELSE NULL
		END AS 'Transfer From'
,		CASE WHEN sis.SerializedInventoryStatusDescriptionShort = 'Xfer' THEN adj.ToCenter
			ELSE NULL
		END AS 'Transfer To'
FROM	HairClubCMS.dbo.datSerializedInventoryAuditSnapshot s
		LEFT JOIN HairClubCMS.dbo.datSerializedInventoryAuditBatch b
			ON s.SerializedInventoryAuditSnapshotID = b.SerializedInventoryAuditSnapshotID
		LEFT JOIN HairClubCMS.dbo.cfgCenter c
			ON b.CenterID = c.CenterID
		LEFT JOIN HairClubCMS.dbo.cfgCenterManagementArea cma
			ON c.CenterManagementAreaID = cma.CenterManagementAreaID
		LEFT JOIN HairClubCMS.dbo.lkpInventoryAuditBatchStatus bs
			ON b.InventoryAuditBatchStatusID = bs.InventoryAuditBatchStatusID
		LEFT JOIN HairClubCMS.dbo.datEmployee e
			ON b.CompletedByEmployeeGUID = e.EmployeeGUID
		LEFT JOIN HairClubCMS.dbo.datEmployee e_rv
			ON b.ReviewCompletedByEmployeeGUID = e_rv.EmployeeGUID
		LEFT JOIN HairClubCMS.dbo.datSerializedInventoryAuditTransaction t
			ON b.SerializedInventoryAuditBatchID = t.SerializedInventoryAuditBatchID
		LEFT JOIN HairClubCMS.dbo.cfgSalesCode sc
			ON t.SalesCodeID = sc.SalesCodeID
		LEFT JOIN HairClubCMS.dbo.cfgSalesCodeCenter scc
			ON (sc.SalesCodeID = scc.SalesCodeID AND scc.CenterID = b.CenterID)
		LEFT JOIN HairClubCMS.dbo.datSalesCodeCenterInventory scci
			ON scc.SalesCodeCenterID = scci.SalesCodeCenterID
		LEFT JOIN HairClubCMS.dbo.datSerializedInventoryAuditTransactionSerialized ts
			ON t.SerializedInventoryAuditTransactionID = ts.SerializedInventoryAuditTransactionID
		LEFT JOIN HairClubCMS.dbo.lkpSerializedInventoryStatus sis
			ON ts.SerializedInventoryStatusID = sis.SerializedInventoryStatusID
		LEFT JOIN HairClubCMS.dbo.lkpInventoryNotScannedReason insr
			ON ts.InventoryNotScannedReasonID = insr.InventoryNotScannedReasonID
		LEFT JOIN HairClubCMS.dbo.datEmployee tse
			ON ts.ScannedEmployeeGUID = tse.EmployeeGUID
		LEFT JOIN HairClubCMS.dbo.cfgCenter tsc
			ON ts.ScannedCenterID = tsc.CenterID
		LEFT JOIN HairClubCMS.dbo.datSalesCodeCenterInventorySerialized sccis
			ON ts.SerialNumber = sccis.SerialNumber
		LEFT JOIN HairClubCMS.dbo.lkpSerializedInventoryStatus currsis
			ON sccis.SerializedInventoryStatusID = currsis.SerializedInventoryStatusID
		OUTER APPLY (
				SELECT	TOP 1
						ia.InventoryAdjustmentDate
				,		ctrfrom.CenterNumber AS FromCenter
				,		ctrto.CenterNumber AS ToCenter
				FROM	HairClubCMS.dbo.datInventoryAdjustmentDetailSerialized iads
						INNER JOIN HairClubCMS.dbo.datInventoryAdjustmentDetail iad
							ON iads.InventoryAdjustmentDetailID = iad.InventoryAdjustmentDetailID
						INNER JOIN HairClubCMS.dbo.datInventoryAdjustment ia
							ON iad.InventoryAdjustmentID = ia.InventoryAdjustmentID
						LEFT JOIN HairClubCMS.dbo.cfgCenter ctrfrom
							ON ia.CenterID = ctrfrom.CenterID
						LEFT JOIN HairClubCMS.dbo.cfgCenter ctrto
							ON ia.TransferToCenterID = ctrto.CenterID
				WHERE	iads.SerialNumber = sccis.SerialNumber
						AND ia.InventoryAdjustmentDate <= s.SnapshotDate
				ORDER BY ia.InventoryAdjustmentDate DESC
					) adj
		LEFT JOIN (
				SELECT	t.SerializedInventoryAuditTransactionID
				,		COUNT(ts.ScannedCenterID) AS TotalQuantityScanned
				FROM	HairClubCMS.dbo.datSerializedInventoryAuditSnapshot s
						LEFT JOIN HairClubCMS.dbo.datSerializedInventoryAuditBatch b
							ON s.SerializedInventoryAuditSnapshotID = b.SerializedInventoryAuditSnapshotID
						LEFT JOIN HairClubCMS.dbo.datSerializedInventoryAuditTransaction t
							ON b.SerializedInventoryAuditBatchID = t.SerializedInventoryAuditBatchID
						LEFT JOIN HairClubCMS.dbo.datSerializedInventoryAuditTransactionSerialized ts
							ON t.SerializedInventoryAuditTransactionID = ts.SerializedInventoryAuditTransactionID
				WHERE	s.SerializedInventoryAuditSnapshotID = @SerializedInventoryAuditSnapshotID
						AND ts.ScannedCenterID IS NOT NULL
						AND ts.ScannedCenterID = b.CenterID
				GROUP BY t.SerializedInventoryAuditTransactionID
				) tacount
			ON t.SerializedInventoryAuditTransactionID = tacount.SerializedInventoryAuditTransactionID
WHERE	s.SerializedInventoryAuditSnapshotID = @SerializedInventoryAuditSnapshotID
		AND c.CenterNumber NOT IN ( 901, 902, 903, 904 ) --Exclude Virtual Centers
ORDER BY c.CenterNumber
,		sc.SalesCodeDescriptionShort

END
