/* CreateDate: 01/24/2019 10:30:43.350 , ModifyDate: 01/24/2019 10:30:43.350 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:            [rptInventoryAuditAdjustment]
 Procedure Description:
 Created By:                Rachelen Hut
 Date Created:              01/24/2019
 Destination Server:        HairclubCMS
 Related Application:       Power BI Reports
================================================================================================
**NOTES**

===============================================================================================
CHANGE HISTORY:

================================================================================================

SAMPLE EXECUTION:

EXEC [rptInventoryAuditAdjustment] '11/28/2018'

================================================================================================
*/

CREATE PROCEDURE [dbo].[rptInventoryAuditAdjustment](
	@SnapshotDate DATE)


AS
BEGIN


;WITH QtyExpected AS (SELECT IAB.CenterID
						,	IAB.InventoryAuditSnapshotID
						,	IAB.InventoryAuditBatchID
						,	IAS.SnapshotDate
						,	IAS.SnapshotLabel
						,	IAB.IsAdjustmentCompleted
						,	IAT.SalesCodeID
						,	SC.SalesCodeDescription
						,	SC.SalesCodeDescriptionShort
						,	IAT.IsSerialized
						,	IAT.QuantityExpected
						,	IAT.QuantityEntered
						,	(IAT.QuantityEntered - IAT.QuantityExpected) AS DifferenceInQty
						FROM dbo.datInventoryAuditSnapshot IAS
						INNER JOIN dbo.datInventoryAuditBatch IAB
							ON IAB.InventoryAuditSnapshotID = IAS.InventoryAuditSnapshotID
						INNER JOIN dbo.datInventoryAuditTransaction IAT
							ON IAT.InventoryAuditBatchID = IAB.InventoryAuditBatchID
						LEFT JOIN dbo.datInventoryAuditTransactionSerialized ATS
							ON	ATS.InventoryAuditTransactionID = IAT.InventoryAuditTransactionID
						INNER JOIN dbo.cfgSalesCode SC
							ON IAT.SalesCodeID = SC.SalesCodeID
						WHERE CAST(IAS.SnapshotDate AS DATE) = @SnapshotDate
						AND (IAT.QuantityExpected <> 0 AND IAT.QuantityEntered <> 0)
						GROUP BY IAB.CenterID
						,	IAB.InventoryAuditSnapshotID
						,	IAB.InventoryAuditBatchID
						,	IAS.SnapshotDate
						,	IAS.SnapshotLabel
						,	IAB.IsAdjustmentCompleted
						,	IAT.SalesCodeID
						,	SC.SalesCodeDescription
						,	SC.SalesCodeDescriptionShort
						,	IAT.IsSerialized
						,	IAT.QuantityExpected
						,	IAT.QuantityEntered
						,	(IAT.QuantityEntered - IAT.QuantityExpected)
						)


,	Adjusted AS (
					SELECT IAS.SnapshotDate
					,	IAS.SnapshotLabel
					,	IA.InventoryAuditBatchID
					,	IAB.CenterID
					,	CASE WHEN IAB.IsAdjustmentCompleted = 1 THEN 'Y' ELSE 'N' END AS CorrectionRun
					,	CAST(IA.InventoryAdjustmentDate AS DATE) AS InventoryAdjustmentDate
					,	IAD.SalesCodeID
					,	SC.SalesCodeDescription
					,	SC.SalesCodeDescriptionShort
					,	IAT.IsNegativeAdjustment
					,	CASE WHEN IAT.IsNegativeAdjustment = 1 THEN ((-1)*IAD.QuantityAdjustment) ELSE IAD.QuantityAdjustment END AS QuantityAdjustment
					FROM dbo.datInventoryAuditSnapshot IAS
						INNER JOIN dbo.datInventoryAuditBatch IAB
							ON IAB.InventoryAuditSnapshotID = IAS.InventoryAuditSnapshotID
						INNER JOIN dbo.datInventoryAdjustment IA
							ON IA.InventoryAuditBatchID = IAB.InventoryAuditBatchID
						INNER JOIN dbo.datInventoryAdjustmentDetail IAD
							ON IAD.InventoryAdjustmentID = IA.InventoryAdjustmentID
						LEFT JOIN dbo.datInventoryAdjustmentDetailSerialized IADS  --This will only be Serialized items
							ON IADS.InventoryAdjustmentDetailID = IAD.InventoryAdjustmentDetailID
						INNER JOIN dbo.cfgSalesCode SC
							ON SC.SalesCodeID = IAD.SalesCodeID
						INNER JOIN dbo.lkpInventoryAdjustmentType IAT
							ON IAT.InventoryAdjustmentTypeID = IA.InventoryAdjustmentTypeID
					WHERE IA.InventoryAuditBatchID IS NOT NULL
						AND CAST(IAS.SnapshotDate AS DATE) = @SnapshotDate
					GROUP BY IAS.SnapshotDate
					,	IAS.SnapshotLabel
					,	IA.InventoryAuditBatchID
					,	IAB.CenterID
					,	CASE WHEN IAB.IsAdjustmentCompleted = 1 THEN 'Y' ELSE 'N' END
					,	CAST(IA.InventoryAdjustmentDate AS DATE)
					,	IAD.SalesCodeID
					,	SC.SalesCodeDescription
					,	SC.SalesCodeDescriptionShort
					,	IAT.IsNegativeAdjustment
					,	CASE WHEN IAT.IsNegativeAdjustment = 1 THEN ((-1)*IAD.QuantityAdjustment) ELSE IAD.QuantityAdjustment END

)

SELECT QE.CenterID
,       QE.InventoryAuditSnapshotID
,       QE.InventoryAuditBatchID
,       QE.SnapshotDate
,       QE.SnapshotLabel
,       QE.IsAdjustmentCompleted
,       QE.SalesCodeID
,       QE.SalesCodeDescription
,       QE.SalesCodeDescriptionShort
,       QE.IsSerialized
,       QE.QuantityExpected
,       QE.QuantityEntered
,       QE.DifferenceInQty

,	  ADJ.CorrectionRun
,	  ADJ.InventoryAdjustmentDate
,	  ADJ.IsNegativeAdjustment
,	  ADJ.QuantityAdjustment
FROM QtyExpected QE
INNER JOIN Adjusted ADJ
	ON ADJ.CenterID = QE.CenterID
WHERE ADJ.InventoryAuditBatchID = QE.InventoryAuditBatchID
	AND ADJ.SalesCodeID = QE.SalesCodeID


END
GO
