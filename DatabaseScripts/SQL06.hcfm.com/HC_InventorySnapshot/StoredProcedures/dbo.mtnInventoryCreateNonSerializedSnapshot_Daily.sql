/* CreateDate: 12/07/2020 16:29:30.083 , ModifyDate: 12/07/2020 16:29:30.083 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[mtnInventoryCreateNonSerializedSnapshot_Daily]
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRY
	BEGIN TRANSACTION

	DECLARE @NotStartedBatchStatusID int,
			@InventoryAuditSnapshotID int,
			@User nvarchar(25)

	SET @User = 'Inv_Snapshot'

	INSERT INTO [HC_InventorySnapshot].[dbo].[datNonSerializedInventoryAuditSnapshot] -- done
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

	SELECT @NotStartedBatchStatusID = iabs.InventoryAuditBatchStatusID FROM [LS_HCSQL011].[HairClubCMS].[dbo].[lkpInventoryAuditBatchStatus] iabs
	WHERE iabs.InventoryAuditBatchStatusDescriptionShort = 'NotStarted'

	---------------------------------------------------------------------------------------------------------------------------------------------------

	-- Create a batch records
	INSERT INTO [HC_InventorySnapshot].[dbo].[datNonSerializedInventoryAuditBatch]
			([NonSerializedInventoryAuditSnapshotID]
			,[CenterID]
			,[InventoryAuditBatchStatusID]
			,[CompleteDate]
			,[CompletedByEmployeeGUID]
			,[IsAdjustmentCompleted]
			,[CreateDate]
			,[CreateUser]
			,[LastUpdate]
			,[LastUpdateUser]
			,[IsReviewCompleted])
	SELECT
		@InventoryAuditSnapshotID
		, c.CenterID
		, @NotStartedBatchStatusID
		, NULL -- Complete Date
		, NULL -- Completed By Employee
		, 0 -- Set to true when correction script fixes the order
		, GETUTCDATE()
		, @User
		, GETUTCDATE()
		, @User
		,0
	FROM [LS_HCSQL011].[HairClubCMS].[dbo].[cfgCenter] c
		INNER JOIN [LS_HCSQL011].[HairClubCMS].[dbo].[cfgConfigurationCenter] cc ON cc.CenterID = c.CenterID
		INNER JOIN [LS_HCSQL011].[HairClubCMS].[dbo].[lkpCenterBusinessType] bt ON bt.CenterBusinessTypeID = cc.CenterBusinessTypeID
	WHERE c.IsActiveFlag = 1
		AND bt.CenterBusinessTypeDescriptionShort IN ('cONEctCorp')
		AND c.CenterNumber NOT IN ( 901, 902, 903, 904 ) -- Exclude Virtual Centers
	ORDER BY c.CenterID

	---------------------------------------------------------------------------------------------------------------------------------------------------

	-- Create Transaction records for the batch - Non Serialized
	INSERT INTO [HC_InventorySnapshot].[dbo].[datNonSerializedInventoryAuditTransaction] -- done
			([NonSerializedInventoryAuditBatchID]
			,[SalesCodeID]
			,[QuantityExpected]
			,[CreateDate]
			,[CreateUser]
			,[LastUpdate]
			,[LastUpdateUser]
			,[IsExcludedFromCorrections])
	SELECT
		batch.NonSerializedInventoryAuditBatchID
		, sc.SalesCodeID
		, scci.QuantityOnHand	-- QuantityExpected
		, GETUTCDATE()
		, @User
		, GETUTCDATE()
		, @User
		, 0						-- Default to correct all non-serialized variances
	FROM [LS_HCSQL011].[HairClubCMS].[dbo].[cfgSalesCode] sc
		INNER JOIN [LS_HCSQL011].[HairClubCMS].[dbo].[cfgSalesCodeCenter] scc ON scc.SalesCodeID = sc.SalesCodeID
		INNER JOIN [LS_HCSQL011].[HairClubCMS].[dbo].[datSalesCodeCenterInventory] scci ON scci.SalesCodeCenterID = scc.SalesCodeCenterID
		INNER JOIN [HC_InventorySnapshot].[dbo].[datNonSerializedInventoryAuditBatch] batch ON batch.CenterID = scc.CenterID
	WHERE batch.NonSerializedInventoryAuditSnapshotID = @InventoryAuditSnapshotID
		and scc.CenterID in (SELECT c.CenterID
								FROM [LS_HCSQL011].[HairClubCMS].[dbo].[cfgCenter] c
								INNER JOIN [LS_HCSQL011].[HairClubCMS].[dbo].[cfgConfigurationCenter] cc on c.CenterID = cc.CenterID
								WHERE cc.IsNonSerializedInventoryEnabled = 1)
		and sc.IsSerialized = 0

	---------------------------------------------------------------------------------------------------------------------------------------------------

	--Create Transaction Area records for each Transaction
	INSERT INTO [HC_InventorySnapshot].[dbo].[datNonSerializedInventoryAuditTransactionArea]
	(
			[NonSerializedInventoryAuditTransactionID]
		,[InventoryAreaID]
		,[QuantityEntered]
		,[CreateDate]
		,[CreateUser]
		,[LastUpdate]
		,[LastUpdateUser]
	)
	SELECT  t.NonSerializedInventoryAuditTransactionID,
			ia.InventoryAreaID,
			0,
			GETUTCDATE(),
			@User,
			GETUTCDATE(),
			@User
	FROM [HC_InventorySnapshot].[dbo].[datNonSerializedInventoryAuditTransaction] t
	CROSS JOIN [LS_HCSQL011].[HairClubCMS].[dbo].[lkpInventoryArea] ia
	INNER JOIN [HC_InventorySnapshot].[dbo].[datNonSerializedInventoryAuditBatch] batch ON batch.NonSerializedInventoryAuditBatchID = t.NonSerializedInventoryAuditBatchID
	WHERE batch.NonSerializedInventoryAuditSnapshotID = @InventoryAuditSnapshotID

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
