/* CreateDate: 06/18/2021 12:56:25.197 , ModifyDate: 06/22/2021 16:53:27.670 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		rrojas
-- Create date: 22/06/2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE selGetRptSerializedAuditDiscrepancies
	-- Add the parameters for the stored procedure here
		@centerId NVARCHAR(max),
		@snapshotDate nvarchar(max)
	AS
 BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		DECLARE @InventoryBatchSalesCodeQuantityEntered TABLE
		(
			SerializedInventoryAuditTransactionID INT,
			SalesCodeID INT,
			QuantityEntered INT
		)

		IF OBJECT_ID(N'tempdb..#tmpInventorySerializedAuditDiscrepancies') IS NOT NULL
			BEGIN
				DROP TABLE  #tmpInventorySerializedAuditDiscrepancies
		    END

			IF OBJECT_ID(N'tempdb..#tmpSnapshots') IS NOT NULL
			BEGIN
				DROP TABLE  #tmpSnapshots
		    END

   INSERT INTO @InventoryBatchSalesCodeQuantityEntered
		(
			SerializedInventoryAuditTransactionID,
			SalesCodeID,
			QuantityEntered
		)

	SELECT distinct siat.SerializedInventoryAuditTransactionID,
				siat.SalesCodeID,
				COUNT(siats.SerializedInventoryAuditTransactionSerializedID)
		FROM datSerializedInventoryAuditTransactionSerialized siats
		INNER JOIN datSerializedInventoryAuditTransaction siat ON siats.SerializedInventoryAuditTransactionID = siat.SerializedInventoryAuditTransactionID
		INNER JOIN datSerializedInventoryAuditBatch siab ON siat.SerializedInventoryAuditBatchID = siab.SerializedInventoryAuditBatchID
		where ((siats.ScannedCenterID IS NOT NULL OR siats.IsInTransit = 1) AND (siats.DeviceAddedAfterSnapshotTaken = 0 OR siats.IsInTransit = 1) AND ((siats.ScannedCenterID IS NOT NULL AND siats.ScannedCenterID = siab.CenterID) OR siats.IsInTransit = 1))
		GROUP BY siat.SerializedInventoryAuditTransactionID, siat.SalesCodeID,siab.CenterId

				--New Devices
	SELECT distinct
	        b.SerializedInventoryAuditBatchID,
	        t.SerializedInventoryAuditTransactionID AS 'InventoryAuditTransactionID'
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
			,tsc.CenterNumber AS 'ScannedCenter',
			tsc.CenterDescription as 'CenterDescription'
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
			,ts.UpdateStamp,
			sias.SnapshotDate as 'SnapshotDate',
			ts.ScannedSerializedInventoryAuditBatchID as 'ScannedBatchID'
			into #tmpInventorySerializedAuditDiscrepancies
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
				inner join datSerializedInventoryAuditSnapshot sias on sias.SerializedInventoryAuditSnapshotID = b.SerializedInventoryAuditSnapshotID
		where	sc.IsSerialized = 1
		and ts.IsInTransit = 0
		and ts.ScannedCenterID IS not NULL
		and ts.DeviceAddedAfterSnapshotTaken = 1
	    and convert(date,sias.SnapshotDate) = CONVERT(date, @snapshotDate)
	    and tsc.CenterID IN (select value from string_split(@centerId, ',')  where rtrim(value) <> '')


	union

	--Inventory Not Scanned
	SELECT DISTINCT
	         b.SerializedInventoryAuditBatchID,
	         t.SerializedInventoryAuditTransactionID AS 'InventoryAuditTransactionID'
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
			,tsc.CenterNumber AS 'ScannedCenter',
			tsc.CenterDescription as 'CenterDescription'
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
			,ts.UpdateStamp,
			sias.SnapshotDate as 'SnapshotDate',
			ts.ScannedSerializedInventoryAuditBatchID as 'ScannedBatchID'
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
			    inner join datSerializedInventoryAuditSnapshot sias  on sias.SerializedInventoryAuditSnapshotID = b.SerializedInventoryAuditSnapshotID
		where sc.IsSerialized = 1
		and ts.IsInTransit = 0
		and ts.ScannedCenterID IS not NULL
		and convert(date, sias.SnapshotDate)= CONVERT(date, @snapshotDate)
		and tsc.CenterID IN (select value from string_split(@centerId, ',')  where rtrim(value) <> '')


	union

	--Inventory Scanned in Diff Center
	SELECT distinct
	        b.SerializedInventoryAuditBatchID,
	        t.SerializedInventoryAuditTransactionID AS 'InventoryAuditTransactionID'
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
			,tsc.CenterDescription as 'CenterDescription'
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
			,sias.SnapshotDate as 'SnapshotDate',
			ts.ScannedSerializedInventoryAuditBatchID as 'ScannedBatchID'
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
				INNER JOIN datSerializedInventoryAuditSnapshot sias ON b.SerializedInventoryAuditSnapshotID=sias.SerializedInventoryAuditSnapshotID
	where	sc.IsSerialized = 1
		and ts.IsInTransit = 0
		and (ts.ScannedCenterID IS NOT NULL AND ts.ScannedCenterID <> b.CenterID)
		and convert(date, sias.SnapshotDate)=CONVERT(date, @snapshotDate)
		and tsc.CenterID IN (select value from string_split(@centerId, ',')  where rtrim(value) <> '')
	ORDER BY tsc.CenterNumber,sc.SalesCodeDescriptionShort


	select distinct ts.SerialNumber, ts.ScannedSerializedInventoryAuditBatchID, cen.CenterID, sd.SerializedInventoryAuditBatchID, sias.SerializedInventoryAuditSnapshotID, sias.SnapshotDate
    into #tmpSnapshots
    from #tmpInventorySerializedAuditDiscrepancies sd
	join datSerializedInventoryAuditBatch siab on siab.SerializedInventoryAuditBatchID = sd.SerializedInventoryAuditBatchID
	join datSerializedInventoryAuditTransactionSerialized ts ON ts.ScannedSerializedInventoryAuditBatchID = sd.ScannedBatchID
	join datSerializedInventoryAuditSnapshot sias ON sias.SerializedInventoryAuditSnapshotID=siab.SerializedInventoryAuditSnapshotID
	join cfgCenter cen on cen.CenterID = ts.ScannedCenterID
	where cen.CenterID in (select value from string_split(@centerId, ',')  where rtrim(value) <> '')
	and convert(date, sias.SnapshotDate)= convert(date, @snapshotDate)


SELECT * FROM (
SELECT DISTINCT discrepancies.* , 'Missing' AS 'EntryResult'
from #tmpInventorySerializedAuditDiscrepancies discrepancies
LEFT join #tmpSnapshots missing on discrepancies.SerialNumber=missing.SerialNumber AND missing.ScannedSerializedInventoryAuditBatchID=discrepancies.ScannedBatchId
WHERE discrepancies.SerialNumber IS NULL
UNION
SELECT DISTINCT discrepancies.* , 'Device Added' AS 'EntryResult'
from #tmpInventorySerializedAuditDiscrepancies discrepancies
RIGHT join #tmpSnapshots device on discrepancies.SerialNumber=device.SerialNumber AND device.ScannedSerializedInventoryAuditBatchID=discrepancies.ScannedBatchId
WHERE device.SerialNumber IS NULL
UNION
SELECT DISTINCT discrepancies.* , 'No Issue' AS 'EntryResult'
from #tmpInventorySerializedAuditDiscrepancies discrepancies
INNER join #tmpSnapshots noissue on discrepancies.SerialNumber=noissue.SerialNumber AND noissue.ScannedSerializedInventoryAuditBatchID=discrepancies.ScannedBatchId
)AS t

 END
GO
