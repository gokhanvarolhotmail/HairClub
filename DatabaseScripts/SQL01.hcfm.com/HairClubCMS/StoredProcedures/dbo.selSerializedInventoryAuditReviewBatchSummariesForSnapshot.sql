/***********************************************************************

PROCEDURE:				selSerializedInventoryAuditReviewBatchSummariesForSnapshot

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		09/03/2019

LAST REVISION DATE: 	09/03/2019

--------------------------------------------------------------------------------------------------------
NOTES:  Gets a summary of all the serialized inventory batches for the current snapshot

		* 09/03/2019	SAL	Created
		* 11/05/2019	SAL	Updated to left join to tscount so that if there are no actual devices in the
							center's batch it is still returned. (TFS #13365)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC selSerializedInventoryAuditReviewBatchSummariesForSnapshot 15

***********************************************************************/

CREATE PROCEDURE [dbo].[selSerializedInventoryAuditReviewBatchSummariesForSnapshot]
	@SerializedInventoryAuditSnapshotID int
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRY

	;WITH
	--Get the total variance for each batch in the snapshot
	BatchVariances as
		(SELECT b.SerializedInventoryAuditBatchID, ROUND(SUM((tscount.TotalQuantityScanned - t.QuantityExpected) * scc.CenterCost), 2) AS TotalVariance
		FROM datSerializedInventoryAuditSnapshot s
			inner join datSerializedInventoryAuditBatch b on s.SerializedInventoryAuditSnapshotID = b.SerializedInventoryAuditSnapshotID
			inner join datSerializedInventoryAuditTransaction t on b.SerializedInventoryAuditBatchID = t.SerializedInventoryAuditBatchID
				inner join cfgSalesCode sc on t.SalesCodeID = sc.SalesCodeID
				inner join cfgSalesCodeCenter scc on (sc.SalesCodeID = scc.SalesCodeID and scc.CenterID = b.CenterID)
			left join (SELECT t.SerializedInventoryAuditTransactionID, COUNT(ts.ScannedCenterID) as TotalQuantityScanned
						FROM datSerializedInventoryAuditSnapshot s
								inner join datSerializedInventoryAuditBatch b on s.SerializedInventoryAuditSnapshotID = b.SerializedInventoryAuditSnapshotID
								inner join datSerializedInventoryAuditTransaction t on b.SerializedInventoryAuditBatchID = t.SerializedInventoryAuditBatchID
								inner join datSerializedInventoryAuditTransactionSerialized ts on t.SerializedInventoryAuditTransactionID = ts.SerializedInventoryAuditTransactionID
						WHERE s.SerializedInventoryAuditSnapshotID = @SerializedInventoryAuditSnapshotID
							and (ts.ScannedCenterID is null or ts.ScannedCenterID = b.CenterID)
						GROUP BY t.SerializedInventoryAuditTransactionID) tscount on t.SerializedInventoryAuditTransactionID = tscount.SerializedInventoryAuditTransactionID
		WHERE s.SerializedInventoryAuditSnapshotID = @SerializedInventoryAuditSnapshotID
		GROUP BY b.SerializedInventoryAuditBatchID)

	--Return a batch summary with total variance for each batch in the snapshot
	SELECT	b.SerializedInventoryAuditBatchID AS SerializedInventoryAuditBatchID
			,c.CenterDescriptionFullCalc AS CenterDescription
			,bs.InventoryAuditBatchStatusDescription AS InventoryAuditBatchStatusDescription
			,bs.InventoryAuditBatchStatusDescriptionShort AS InventoryAuditBatchStatusDescriptionShort
			,e_complaudit.EmployeeFullNameCalc AS InventoryAuditCompletedByEmployeeFullNameCalc
			,b.IsReviewCompleted AS IsReviewComplete
			,b.ReviewCompleteDate AS ReviewCompleteDate
			,e_complreview.EmployeeGUID AS ReviewCompletedByEmployeeGUID
			,e_complreview.EmployeeFullNameCalc AS ReviewCompletedByEmployeeFullNameCalc
			,b.IsAdjustmentCompleted AS IsAdjustmentCompleted
			,bv.TotalVariance AS TotalVariance
	FROM datSerializedInventoryAuditSnapshot s
			inner join datSerializedInventoryAuditBatch b on s.SerializedInventoryAuditSnapshotID = b.SerializedInventoryAuditSnapshotID
				inner join cfgCenter c on b.CenterID = c.CenterID
				inner join lkpInventoryAuditBatchStatus bs on b.InventoryAuditBatchStatusID = bs.InventoryAuditBatchStatusID
				left join datEmployee e_complaudit on b.CompletedByEmployeeGUID = e_complaudit.EmployeeGUID
				left join datEmployee e_complreview on b.ReviewCompletedByEmployeeGUID = e_complreview.EmployeeGUID
				inner join BatchVariances bv on b.SerializedInventoryAuditBatchID = bv.SerializedInventoryAuditBatchID
	WHERE s.SerializedInventoryAuditSnapshotID = @SerializedInventoryAuditSnapshotID
	ORDER BY c.CenterDescriptionFullCalc

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
