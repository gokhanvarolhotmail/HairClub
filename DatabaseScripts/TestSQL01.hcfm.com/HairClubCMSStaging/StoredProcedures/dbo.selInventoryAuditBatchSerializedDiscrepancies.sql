/* CreateDate: 12/19/2018 08:03:27.913 , ModifyDate: 09/23/2019 12:32:36.843 */
GO
/***********************************************************************

PROCEDURE:				selInventoryAuditBatchSerializedDiscrepancies

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		12/06/2018

LAST REVISION DATE: 	12/06/2018

--------------------------------------------------------------------------------------------------------
NOTES:  Return the Inventory Audit Batch's Serialized Discrepancies

		* 11/17/2018	SAL	Created (TFS #11702)
		* 06/27/2019	JLM Update proc to look at serialized inventory tables (TFS #12660)
		* 09/09/2019	SAL	Updated to consider the scc.IsActiveFlag on joins (TFS #12999)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC selInventoryAuditBatchSerializedDiscrepancies 239

***********************************************************************/

CREATE PROCEDURE [dbo].[selInventoryAuditBatchSerializedDiscrepancies]
	@InventoryAuditBatchID int
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRY

		--Calculate Quantity Entered
		DECLARE @InventoryBatchSalesCodeQuantityEntered TABLE
		(
			SerializedInventoryAuditTransactionID INT,
			SalesCodeID INT,
			QuantityEntered INT
		)

		INSERT INTO @InventoryBatchSalesCodeQuantityEntered
		(
			SerializedInventoryAuditTransactionID,
			SalesCodeID,
			QuantityEntered
		)
		SELECT siat.SerializedInventoryAuditTransactionID,
				siat.SalesCodeID,
				COUNT(siats.SerializedInventoryAuditTransactionSerializedID)
		FROM datSerializedInventoryAuditTransactionSerialized siats
		INNER JOIN datSerializedInventoryAuditTransaction siat ON siats.SerializedInventoryAuditTransactionID = siat.SerializedInventoryAuditTransactionID
		INNER JOIN datSerializedInventoryAuditBatch siab ON siat.SerializedInventoryAuditBatchID = siab.SerializedInventoryAuditBatchID
		WHERE siat.SerializedInventoryAuditBatchID = @InventoryAuditBatchID
		AND ((siats.ScannedCenterID IS NOT NULL OR siats.IsInTransit = 1) AND (siats.DeviceAddedAfterSnapshotTaken = 0 OR siats.IsInTransit = 1) AND ((siats.ScannedCenterID IS NOT NULL AND siats.ScannedCenterID = siab.CenterID) OR siats.IsInTransit = 1))
		GROUP BY siat.SerializedInventoryAuditTransactionID, siat.SalesCodeID

--New Devices
	SELECT	t.SerializedInventoryAuditTransactionID AS 'InventoryAuditTransactionID'
			,sc.SalesCodeDescriptionShort
			,sc.SalesCodeDescription
			,scci.QuantityOnHand
			,t.QuantityExpected
			,COALESCE(qe.QuantityEntered, 0) AS 'QuantityEntered'
			,(COALESCE(qe.QuantityEntered, 0) - t.QuantityExpected) AS 'Variance'
			,scc.CenterCost
			,(COALESCE(qe.QuantityEntered, 0) - t.QuantityExpected) * scc.CenterCost AS 'VarianceCost'
			,t.IsExcludedFromCorrections AS 'TransactionIsExcluded'
			,t.ExclusionReason AS 'TransactionExclusionReason'
			,ts.SerializedInventoryAuditTransactionSerializedID AS 'InventoryAuditTransactionSerializedID'
			,tsc.CenterNumber AS 'ScannedCenter'
			,ts.IsScannedEntry
			,ts.SerialNumber
			,currsis.SerializedInventoryStatusDescription AS 'CurrentStatus'
			,sis.SerializedInventoryStatusDescription AS 'SnapshotStatus'
			,sis.IsInTransit
			,CONVERT(VARCHAR, ia.InventoryAdjustmentDate, 1) AS 'StatusDate'
			,CASE	WHEN sis.SerializedInventoryStatusDescriptionShort = 'Xfer' THEN ctrfrom.CenterNumber
					ELSE NULL
					END AS 'CenterTransferFrom'
			,CASE	WHEN sis.SerializedInventoryStatusDescriptionShort = 'Xfer' THEN ctrto.CenterNumber
					ELSE NULL
					END AS 'CenterTransferTo'
			,insr.InventoryNotScannedReasonDescription
			,ts.InventoryNotScannedNote
			,ts.IsExcludedFromCorrections AS 'TransactionSerializedIsExcluded'
			,ts.ExclusionReason AS 'TransactionSerializedExclusionReason'
			,ts.UpdateStamp
	FROM	datSerializedInventoryAuditBatch b
				left join datSerializedInventoryAuditTransaction t on b.SerializedInventoryAuditBatchID = t.SerializedInventoryAuditBatchID
					left join cfgSalesCode sc on (t.SalesCodeID = sc.SalesCodeID and sc.IsActiveFlag = 1)
					left join cfgSalesCodeCenter scc on (sc.SalesCodeID = scc.SalesCodeID and scc.CenterID = b.CenterID and scc.IsActiveFlag = 1)
					left join datSalesCodeCenterInventory scci on scc.SalesCodeCenterID = scci.SalesCodeCenterID
				left join datSerializedInventoryAuditTransactionSerialized ts on t.SerializedInventoryAuditTransactionID = ts.SerializedInventoryAuditTransactionID
					left join lkpSerializedInventoryStatus sis on ts.SerializedInventoryStatusID = sis.SerializedInventoryStatusID
					left join lkpInventoryNotScannedReason insr on ts.InventoryNotScannedReasonID = insr.InventoryNotScannedReasonID
					left join datEmployee tse on ts.ScannedEmployeeGUID = tse.EmployeeGUID
					left join cfgCenter tsc on ts.ScannedCenterID = tsc.CenterID
				left join datSalesCodeCenterInventorySerialized sccis on ts.SerialNumber = sccis.SerialNumber
					left join lkpSerializedInventoryStatus currsis on sccis.SerializedInventoryStatusID = currsis.SerializedInventoryStatusID
				left join datInventoryAdjustment ia on ts.InventoryAdjustmentIdAtTimeOfSnapshot = ia.InventoryAdjustmentID
					left join cfgCenter ctrfrom on ia.CenterID = ctrfrom.CenterID
					left join cfgCenter ctrto on ia.TransferToCenterID = ctrto.CenterID
				left join @InventoryBatchSalesCodeQuantityEntered qe on t.SerializedInventoryAuditTransactionID = qe.SerializedInventoryAuditTransactionID
																	and t.SalesCodeID = qe.SalesCodeID
	WHERE	b.SerializedInventoryAuditBatchID = @InventoryAuditBatchID
		and	sc.IsSerialized = 1
		and ts.IsInTransit = 0
		and ts.DeviceAddedAfterSnapshotTaken = 1

	UNION

	--Inventory Not Scanned
	SELECT	t.SerializedInventoryAuditTransactionID AS 'InventoryAuditTransactionID'
			,sc.SalesCodeDescriptionShort
			,sc.SalesCodeDescription
			,scci.QuantityOnHand
			,t.QuantityExpected
			,COALESCE(qe.QuantityEntered, 0) AS 'QuantityEntered'
			,(COALESCE(qe.QuantityEntered, 0) - t.QuantityExpected) AS 'Variance'
			,scc.CenterCost
			,(COALESCE(qe.QuantityEntered, 0) - t.QuantityExpected) * scc.CenterCost AS 'VarianceCost'
			,t.IsExcludedFromCorrections AS 'TransactionIsExcluded'
			,t.ExclusionReason AS 'TransactionExclusionReason'
			,ts.SerializedInventoryAuditTransactionSerializedID AS 'InventoryAuditTransactionSerializedID'
			,tsc.CenterNumber AS 'ScannedCenter'
			,ts.IsScannedEntry
			,ts.SerialNumber
			,currsis.SerializedInventoryStatusDescription AS 'CurrentStatus'
			,sis.SerializedInventoryStatusDescription AS 'SnapshotStatus'
			,sis.IsInTransit
			,CONVERT(VARCHAR, ia.InventoryAdjustmentDate, 1) AS 'StatusDate'
			,CASE	WHEN sis.SerializedInventoryStatusDescriptionShort = 'Xfer' THEN ctrfrom.CenterNumber
					ELSE NULL
					END AS 'CenterTransferFrom'
			,CASE	WHEN sis.SerializedInventoryStatusDescriptionShort = 'Xfer' THEN ctrto.CenterNumber
					ELSE NULL
					END AS 'CenterTransferTo'
			,insr.InventoryNotScannedReasonDescription
			,ts.InventoryNotScannedNote
			,ts.IsExcludedFromCorrections AS 'TransactionSerializedIsExcluded'
			,ts.ExclusionReason AS 'TransactionSerializedExclusionReason'
			,ts.UpdateStamp
	FROM	datSerializedInventoryAuditBatch b
				left join datSerializedInventoryAuditTransaction t on b.SerializedInventoryAuditBatchID = t.SerializedInventoryAuditBatchID
					left join cfgSalesCode sc on (t.SalesCodeID = sc.SalesCodeID and sc.IsActiveFlag = 1)
					left join cfgSalesCodeCenter scc on (sc.SalesCodeID = scc.SalesCodeID and scc.CenterID = b.CenterID and scc.IsActiveFlag = 1)
					left join datSalesCodeCenterInventory scci on scc.SalesCodeCenterID = scci.SalesCodeCenterID
				left join datSerializedInventoryAuditTransactionSerialized ts on t.SerializedInventoryAuditTransactionID = ts.SerializedInventoryAuditTransactionID
					left join lkpSerializedInventoryStatus sis on ts.SerializedInventoryStatusID = sis.SerializedInventoryStatusID
					left join lkpInventoryNotScannedReason insr on ts.InventoryNotScannedReasonID = insr.InventoryNotScannedReasonID
					left join datEmployee tse on ts.ScannedEmployeeGUID = tse.EmployeeGUID
					left join cfgCenter tsc on ts.ScannedCenterID = tsc.CenterID
				left join datSalesCodeCenterInventorySerialized sccis on ts.SerialNumber = sccis.SerialNumber
					left join lkpSerializedInventoryStatus currsis on sccis.SerializedInventoryStatusID = currsis.SerializedInventoryStatusID
				left join datInventoryAdjustment ia on ts.InventoryAdjustmentIdAtTimeOfSnapshot = ia.InventoryAdjustmentID
					left join cfgCenter ctrfrom on ia.CenterID = ctrfrom.CenterID
					left join cfgCenter ctrto on ia.TransferToCenterID = ctrto.CenterID
				left join @InventoryBatchSalesCodeQuantityEntered qe on t.SerializedInventoryAuditTransactionID = qe.SerializedInventoryAuditTransactionID
																 	 and t.SalesCodeID = qe.SalesCodeID
	WHERE	b.SerializedInventoryAuditBatchID = @InventoryAuditBatchID
		and	sc.IsSerialized = 1
		and ts.IsInTransit = 0
		and ts.ScannedCenterID IS NULL

	UNION

	--Inventory Scanned in Diff Center
	SELECT	t.SerializedInventoryAuditTransactionID AS 'InventoryAuditTransactionID'
			,sc.SalesCodeDescriptionShort
			,sc.SalesCodeDescription
			,scci.QuantityOnHand
			,t.QuantityExpected
			,COALESCE(qe.QuantityEntered, 0) AS 'QuantityEntered'
			,(COALESCE(qe.QuantityEntered, 0) - t.QuantityExpected) AS 'Variance'
			,scc.CenterCost
			,(COALESCE(qe.QuantityEntered, 0) - t.QuantityExpected) * scc.CenterCost AS 'VarianceCost'
			,t.IsExcludedFromCorrections AS 'TransactionIsExcluded'
			,t.ExclusionReason AS 'TransactionExclusionReason'
			,ts.SerializedInventoryAuditTransactionSerializedID AS 'InventoryAuditTransactionSerializedID'
			,tsc.CenterNumber AS 'ScannedCenter'
			,ts.IsScannedEntry
			,ts.SerialNumber
			,currsis.SerializedInventoryStatusDescription AS 'CurrentStatus'
			,sis.SerializedInventoryStatusDescription AS 'SnapshotStatus'
			,sis.IsInTransit
			,CONVERT(VARCHAR, ia.InventoryAdjustmentDate, 1) AS 'StatusDate'
			,CASE	WHEN sis.SerializedInventoryStatusDescriptionShort = 'Xfer' THEN ctrfrom.CenterNumber
					ELSE NULL
					END AS 'CenterTransferFrom'
			,CASE	WHEN sis.SerializedInventoryStatusDescriptionShort = 'Xfer' THEN ctrto.CenterNumber
					ELSE NULL
					END AS 'CenterTransferTo'
			,insr.InventoryNotScannedReasonDescription
			,ts.InventoryNotScannedNote
			,ts.IsExcludedFromCorrections AS 'TransactionSerializedIsExcluded'
			,ts.ExclusionReason AS 'TransactionSerializedExclusionReason'
			,ts.UpdateStamp
	FROM	datSerializedInventoryAuditBatch b
				left join datSerializedInventoryAuditTransaction t on b.SerializedInventoryAuditBatchID = t.SerializedInventoryAuditBatchID
					left join cfgSalesCode sc on (t.SalesCodeID = sc.SalesCodeID and sc.IsActiveFlag = 1)
					left join cfgSalesCodeCenter scc on (sc.SalesCodeID = scc.SalesCodeID and scc.CenterID = b.CenterID and scc.IsActiveFlag = 1)
					left join datSalesCodeCenterInventory scci on scc.SalesCodeCenterID = scci.SalesCodeCenterID
				left join datSerializedInventoryAuditTransactionSerialized ts on t.SerializedInventoryAuditTransactionID = ts.SerializedInventoryAuditTransactionID
					left join lkpSerializedInventoryStatus sis on ts.SerializedInventoryStatusID = sis.SerializedInventoryStatusID
					left join lkpInventoryNotScannedReason insr on ts.InventoryNotScannedReasonID = insr.InventoryNotScannedReasonID
					left join datEmployee tse on ts.ScannedEmployeeGUID = tse.EmployeeGUID
					left join cfgCenter tsc on ts.ScannedCenterID = tsc.CenterID
				left join datSalesCodeCenterInventorySerialized sccis on ts.SerialNumber = sccis.SerialNumber
					left join lkpSerializedInventoryStatus currsis on sccis.SerializedInventoryStatusID = currsis.SerializedInventoryStatusID
				left join datInventoryAdjustment ia on ts.InventoryAdjustmentIdAtTimeOfSnapshot = ia.InventoryAdjustmentID
					left join cfgCenter ctrfrom on ia.CenterID = ctrfrom.CenterID
					left join cfgCenter ctrto on ia.TransferToCenterID = ctrto.CenterID
				left join @InventoryBatchSalesCodeQuantityEntered qe on t.SerializedInventoryAuditTransactionID = qe.SerializedInventoryAuditTransactionID
																	 and t.SalesCodeID = qe.SalesCodeID
	WHERE	b.SerializedInventoryAuditBatchID = @InventoryAuditBatchID
		and	sc.IsSerialized = 1
		and ts.IsInTransit = 0
		and (ts.ScannedCenterID IS NOT NULL AND ts.ScannedCenterID <> b.CenterID)

	ORDER BY sc.SalesCodeDescriptionShort

  END TRY

  BEGIN CATCH

	DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE();

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
  END CATCH

END
GO
