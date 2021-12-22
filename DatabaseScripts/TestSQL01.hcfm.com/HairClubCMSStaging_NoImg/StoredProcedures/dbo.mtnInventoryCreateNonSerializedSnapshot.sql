/* CreateDate: 09/23/2019 12:32:00.317 , ModifyDate: 08/28/2020 17:02:10.910 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnInventoryCreateNonSerializedSnapshot

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Jeremy Miller

IMPLEMENTOR: 			Jeremy Miller

DATE IMPLEMENTED: 		06/19/2019

LAST REVISION DATE: 	06/19/2019

--------------------------------------------------------------------------------------------------------
NOTES:  Creates an Inventory Snapshot for all centers for current date

		* 06/19/2019	JLM	Created (TFS #12642)
		* 04/21/2020	SAL	Added center exclusions for April, 2020 inventory snapshot (TFS #14384)
		* 04/24/2020	SAL	Remove center exclusions put in place for April, 2020 inventory snapshot (TFS #14386)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnInventoryCreateNonSerializedSnapshot

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnInventoryCreateNonSerializedSnapshot]
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRY
	BEGIN TRANSACTION

	DECLARE @NotStartedBatchStatusID int,
			@InventoryAuditSnapshotID int,
			@User nvarchar(25)

	SET @User = 'Inv_Snapshot'

	INSERT INTO [dbo].[datNonSerializedInventoryAuditSnapshot]
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
	INSERT INTO [dbo].[datNonSerializedInventoryAuditBatch]
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
		FROM cfgCenter c
			INNER JOIN cfgConfigurationCenter cc ON cc.CenterID = c.CenterID
			INNER JOIN lkpCenterBusinessType bt ON bt.CenterBusinessTypeID = cc.CenterBusinessTypeID
		WHERE c.IsActiveFlag = 1
			AND bt.CenterBusinessTypeDescriptionShort IN ('cONEctCorp')
			AND c.CenterNumber NOT IN ( 901, 902, 903, 904, 103 ) -- Exclude Virtual Centers
		ORDER BY c.CenterID


	-- Create Transaction records for the batch - Non Serialized
	INSERT INTO [dbo].[datNonSerializedInventoryAuditTransaction]
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
		FROM cfgSalesCode sc
			INNER JOIN cfgSalesCodeCenter scc ON scc.SalesCodeID = sc.SalesCodeID
			INNER JOIN datSalesCodeCenterInventory scci ON scci.SalesCodeCenterID = scc.SalesCodeCenterID
			INNER JOIN datNonSerializedInventoryAuditBatch batch ON batch.CenterID = scc.CenterID
		WHERE batch.NonSerializedInventoryAuditSnapshotID = @InventoryAuditSnapshotID
			and scc.CenterID in (SELECT c.CenterID
								 FROM cfgCenter c
									INNER JOIN cfgConfigurationCenter cc on c.CenterID = cc.CenterID
								 WHERE cc.IsNonSerializedInventoryEnabled = 1)
			and sc.IsSerialized = 0

	--Create Transaction Area records for each Transaction
	INSERT INTO [datNonSerializedInventoryAuditTransactionArea]
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
	FROM [datNonSerializedInventoryAuditTransaction] t
	CROSS JOIN lkpInventoryArea ia
	INNER JOIN datNonSerializedInventoryAuditBatch batch ON batch.NonSerializedInventoryAuditBatchID = t.NonSerializedInventoryAuditBatchID
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
