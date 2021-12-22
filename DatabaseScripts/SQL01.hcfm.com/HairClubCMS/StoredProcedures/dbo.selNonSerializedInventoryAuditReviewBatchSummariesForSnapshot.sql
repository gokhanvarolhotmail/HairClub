/***********************************************************************

PROCEDURE:				selNonSerializedInventoryAuditReviewBatchSummariesForSnapshot

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		09/03/2019

LAST REVISION DATE: 	09/03/2019

--------------------------------------------------------------------------------------------------------
NOTES:  Gets a summary of all the non-serialized inventory batches for the current snapshot

		* 09/03/2019	SAL	Created
		* 01/02/2020	SAL	Updated to left join to transaction, transactionarea, salescode,
							salescodecenter, and tacount so that if there is no retail inventory in the
							center's batch it is still returned. (TFS #13658)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC selNonSerializedInventoryAuditReviewBatchSummariesForSnapshot 15

***********************************************************************/

CREATE PROCEDURE [dbo].[selNonSerializedInventoryAuditReviewBatchSummariesForSnapshot]
	@SerializedInventoryAuditSnapshotID int
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRY

	;WITH
	--Get the total variance for each batch in the snapshot
	BatchVariances as
		(SELECT b.NonSerializedInventoryAuditBatchID, ROUND(SUM((tacount.TotalQuantityEntered - t.QuantityExpected) * scc.CenterCost), 2) AS TotalVariance
		FROM datNonSerializedInventoryAuditSnapshot s
			inner join datNonSerializedInventoryAuditBatch b on s.NonSerializedInventoryAuditSnapshotID = b.NonSerializedInventoryAuditSnapshotID
			left join datNonSerializedInventoryAuditTransaction t on b.NonSerializedInventoryAuditBatchID = t.NonSerializedInventoryAuditBatchID
				left join cfgSalesCode sc on t.SalesCodeID = sc.SalesCodeID
				left join cfgSalesCodeCenter scc on (sc.SalesCodeID = scc.SalesCodeID and scc.CenterID = b.CenterID)
			left join (SELECT t.NonSerializedInventoryAuditTransactionID, SUM(ta.QuantityEntered) as TotalQuantityEntered
						FROM datNonSerializedInventoryAuditSnapshot s
								inner join datNonSerializedInventoryAuditBatch b on s.NonSerializedInventoryAuditSnapshotID = b.NonSerializedInventoryAuditSnapshotID
								left join datNonSerializedInventoryAuditTransaction t on b.NonSerializedInventoryAuditBatchID = t.NonSerializedInventoryAuditBatchID
								left join datNonSerializedInventoryAuditTransactionArea ta on t.NonSerializedInventoryAuditTransactionID = ta.NonSerializedInventoryAuditTransactionID
						WHERE s.NonSerializedInventoryAuditSnapshotID = @SerializedInventoryAuditSnapshotID
						GROUP BY t.NonSerializedInventoryAuditTransactionID) tacount on t.NonSerializedInventoryAuditTransactionID = tacount.NonSerializedInventoryAuditTransactionID
		WHERE s.NonSerializedInventoryAuditSnapshotID = @SerializedInventoryAuditSnapshotID
		GROUP BY b.NonSerializedInventoryAuditBatchID)

	--Return a batch summary with total variance for each batch in the snapshot
	SELECT	b.NonSerializedInventoryAuditBatchID AS NonSerializedInventoryAuditBatchID
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
	FROM datNonSerializedInventoryAuditSnapshot s
			inner join datNonSerializedInventoryAuditBatch b on s.NonSerializedInventoryAuditSnapshotID = b.NonSerializedInventoryAuditSnapshotID
				inner join cfgCenter c on b.CenterID = c.CenterID
				inner join lkpInventoryAuditBatchStatus bs on b.InventoryAuditBatchStatusID = bs.InventoryAuditBatchStatusID
				left join datEmployee e_complaudit on b.CompletedByEmployeeGUID = e_complaudit.EmployeeGUID
				left join datEmployee e_complreview on b.ReviewCompletedByEmployeeGUID = e_complreview.EmployeeGUID
				inner join BatchVariances bv on b.NonSerializedInventoryAuditBatchID = bv.NonSerializedInventoryAuditBatchID
	WHERE s.NonSerializedInventoryAuditSnapshotID = @SerializedInventoryAuditSnapshotID
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
