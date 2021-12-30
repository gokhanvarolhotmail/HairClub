/* CreateDate: 09/23/2019 12:31:49.617 , ModifyDate: 08/28/2020 17:02:23.460 */
GO
/***********************************************************************

PROCEDURE:				mtnInventoryCreateSerializedSnapshot

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Jeremy Miller

IMPLEMENTOR: 			Jeremy Miller

DATE IMPLEMENTED: 		06/19/2019

LAST REVISION DATE: 	06/19/2019

--------------------------------------------------------------------------------------------------------
NOTES:  Creates a Serialized Inventory Snapshot for all centers for current date.

		* 06/19/2019	JLM	Created (TFS #12641)
		* 09/10/2019	SAL Include cONEctHQ Center Business Type (TFS #13002)
		* 04/21/2020	SAL	Added center exclusions for April, 2020 inventory snapshot (TFS #14384)
		* 04/24/2020	SAL	Remove center exclusions put in place for April, 2020 inventory snapshot (TFS #14386)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnInventoryCreateSerializedSnapshot

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnInventoryCreateSerializedSnapshot]
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRY
	BEGIN TRANSACTION

	DECLARE @NotStartedBatchStatusID int,
			@InventoryAuditSnapshotID int,
			@User nvarchar(25)

	SET @User = 'Inv_Snapshot'

	INSERT INTO [dbo].[datSerializedInventoryAuditSnapshot]
           ([SnapshotDate]
           ,[SnapshotLabel]
           ,[IsAdjustmentCompleted]
           ,[CreateDate]
           ,[CreateUser]
           ,[LastUpdate]
           ,[LastUpdateUser])
     VALUES
           (GETUTCDATE()
           ,CAST(DATEPART(YEAR, GETUTCDATE()) AS varchar) + ' ' + DATENAME(MONTH, GETUTCDATE()) + ' ' + CAST(DATEPART(DAY, GETUTCDATE()) AS varchar)
           ,0
           ,GETUTCDATE()
           ,@User
           ,GETUTCDATE()
           ,@User)

	SELECT @InventoryAuditSnapshotID = SCOPE_IDENTITY()

	SELECT @NotStartedBatchStatusID = InventoryAuditBatchStatusID FROM lkpInventoryAuditBatchStatus WHERE InventoryAuditBatchStatusDescriptionShort = 'NotStarted'

	-- Create a batch records
	INSERT INTO [dbo].[datSerializedInventoryAuditBatch]
           ([SerializedInventoryAuditSnapshotID]
           ,[CenterID]
           ,[InventoryAuditBatchStatusID]
           ,[CompleteDate]
           ,[CompletedByEmployeeGUID]
           ,[IsAdjustmentCompleted]
		   ,[IsReviewCompleted]
           ,[CreateDate]
           ,[CreateUser]
           ,[LastUpdate]
           ,[LastUpdateUser])
		SELECT
			@InventoryAuditSnapshotID
			, c.CenterID
			, @NotStartedBatchStatusID
			, NULL -- Complete Date
			, NULL -- Completed By Employee
			, 0 -- Set to true when correction script fixes the order
			, 0
			, GETUTCDATE()
			, @User
			, GETUTCDATE()
			, @User
		FROM cfgCenter c
			INNER JOIN cfgConfigurationCenter cc ON cc.CenterID = c.CenterID
			INNER JOIN lkpCenterBusinessType bt ON bt.CenterBusinessTypeID = cc.CenterBusinessTypeID
		WHERE c.IsActiveFlag = 1
			AND bt.CenterBusinessTypeDescriptionShort IN ('cONEctCorp','cONEctHQ')
			AND c.CenterNumber NOT IN ( 901, 902, 903, 904, 103 ) -- Exclude Virtual Centers
		ORDER BY c.CenterID

	-- Create Transaction records for the batch - Serialized
	INSERT INTO [dbo].[datSerializedInventoryAuditTransaction]
           ([SerializedInventoryAuditBatchID]
           ,[SalesCodeID]
           ,[QuantityExpected]
           ,[CreateDate]
           ,[CreateUser]
           ,[LastUpdate]
           ,[LastUpdateUser])
		SELECT
			batch.SerializedInventoryAuditBatchID
			, sc.SalesCodeID
			, scci.QuantityOnHand	-- QuantityExpected
			, GETUTCDATE()
			, @User
			, GETUTCDATE()
			, @User
		FROM cfgSalesCode sc
			INNER JOIN cfgSalesCodeCenter scc ON scc.SalesCodeID = sc.SalesCodeID
			INNER JOIN datSalesCodeCenterInventory scci ON scci.SalesCodeCenterID = scc.SalesCodeCenterID
			INNER JOIN datSerializedInventoryAuditBatch batch ON batch.CenterID = scc.CenterID
		WHERE batch.SerializedInventoryAuditSnapshotID = @InventoryAuditSnapshotID
			and sc.IsSerialized = 1

	INSERT INTO [datSerializedInventoryAuditTransactionSerialized]
           ([SerializedInventoryAuditTransactionID]
           ,[SerialNumber]
           ,[IsInTransit]
           ,[IsScannedEntry]
           ,[SerializedInventoryStatusID]
           ,[IsExcludedFromCorrections]
           ,[ExclusionReason]
           ,[InventoryNotScannedNote]
           ,[ScannedDate]
           ,[ScannedEmployeeGUID]
           ,[ScannedCenterID]
           ,[ScannedSerializedInventoryAuditBatchID]
           ,[CreateDate]
           ,[CreateUser]
           ,[LastUpdate]
           ,[LastUpdateUser]
		   ,[DeviceAddedAfterSnapshotTaken]
		   ,[InventoryAdjustmentIdAtTimeOfSnapshot])
	SELECT t.SerializedInventoryAuditTransactionID
			, sccsi.SerialNumber
			, st.IsInTransit
			, NULL
			, st.SerializedInventoryStatusID
			, 0
			, NULL
			, NULL
			, NULL
			, NULL
			, NULL
			, NULL
			, GETUTCDATE()
			, @User
			, GETUTCDATE()
			, @User
			,0
			,adj.InventoryAdjustmentID
	FROM [datSerializedInventoryAuditTransaction] t
		INNER JOIN datSerializedInventoryAuditBatch batch ON batch.SerializedInventoryAuditBatchID = t.SerializedInventoryAuditBatchID
		INNER JOIN cfgSalesCodeCenter scc ON scc.SalesCodeID = t.SalesCodeID AND scc.CenterID = batch.CenterID
		INNER JOIN datSalesCodeCenterInventory scci ON scci.SalesCodeCenterID = scc.SalesCodeCenterID
		INNER JOIN datSalesCodeCenterInventorySerialized sccsi ON sccsi.SalesCodeCenterInventoryID = scci.SalesCodeCenterInventoryID
		INNER JOIN lkpSerializedInventoryStatus st ON st.SerializedInventoryStatusID = sccsi.SerializedInventoryStatusID
		OUTER APPLY (SELECT TOP 1 ia.InventoryAdjustmentID
						FROM datInventoryAdjustmentDetailSerialized iads
							INNER JOIN datInventoryAdjustmentDetail iad on iads.InventoryAdjustmentDetailID = iad.InventoryAdjustmentDetailID
							INNER JOIN datInventoryAdjustment ia on iad.InventoryAdjustmentID = ia.InventoryAdjustmentID
						WHERE iads.SerialNumber = sccsi.SerialNumber
						ORDER BY ia.InventoryAdjustmentDate desc) AS adj
	WHERE batch.SerializedInventoryAuditSnapshotID = @InventoryAuditSnapshotID
		AND st.IncludeInInventorySnapshot = 1

  COMMIT TRANSACTION

  END TRY

  BEGIN CATCH
	ROLLBACK TRANSACTION

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
