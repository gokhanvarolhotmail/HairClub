/* CreateDate: 05/28/2018 22:19:46.370 , ModifyDate: 12/16/2019 08:35:17.213 */
GO
/***********************************************************************
PROCEDURE: 				[mtnInventoryAdjustment]
PURPOSE:				Writes an Inventory Adjustment and Adjusts Counts.
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Mike Tovbin
DATE IMPLEMENTED:		05/05/2017
--------------------------------------------------------------------------------------------------------
NOTES:

	05/05/2017 - MT - Created
	06/20/2018 - SL - Modified insert into datSalesCodeCenterInvnetorySerialized and removed ClientGUID (TFS #11034)
	07/22/2018 - SL - Modified to remove commented out @SERIALIZED_INVENTORY_STATUS_UNKNOWN variable so that it doesn't
						get used since we're deactivating it (TFS #11138)
	11/14/2018 - SL - Modified to add the IsActive flag on joins to cfgSalesCodeCenter and datSalesCodeCenterInventory
						(TFS #11609)
    11/05/2019 - JLM - Modified to set returned serialized inventory into 'Returned - Available' status if neccessary

--------------------------------------------------------------------------------------------------------
Sample Execution:

EXEC mtnInventoryAdjustment 8, null, 'Distributor Order', 'mtovbin'
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnInventoryAdjustment]
    (
      @AdjustmentSourceID int = NULL,
      @AdjustmentSourceGUID uniqueidentifier = NULL,
      @Action nvarchar(50),  -- Inventory Adjustment (InventoryAdjustmentID), Sales Order (SalesOrderGUID), Distributor (DistributorPurchaseOrderID),
	  @Username nvarchar(25)
    )
AS
BEGIN

	DECLARE @ACTION_INVENTORY_ADJUSTMENT nvarchar(50) = 'Inventory Adjustment'
	DECLARE @ACTION_SALES_ORDER_ADJUSTMENT nvarchar(50) = 'Sales Order'
	DECLARE @ACTION_DISTRIBUTOR_ORDER_ADJUSTMENT nvarchar(50) = 'Distributor Order'

	DECLARE @INVENTORY_ADJUSTMENT_TYPE_PLACE_PURCHASE_ORDER nvarchar(10) = 'PlacePO'
	DECLARE @INVENTORY_ADJUSTMENT_TYPE_RECEIVE_PURCHASE_ORDER nvarchar(10) = 'ReceivePO'
    DECLARE @INVENTORY_ADJUSTMENT_TYPE_SALE  nvarchar(10) = 'Sale'
    DECLARE @INVENTORY_ADJUSTMENT_TYPE_RETURN nvarchar(10) = 'Return'
    DECLARE @INVENTORY_ADJUSTMENT_TYPE_DAMAGED nvarchar(10) = 'Damaged'
    DECLARE @INVENTORY_ADJUSTMENT_TYPE_TRANSFER_OUT nvarchar(10) = 'XferOut'

	--DECLARE @SERIALIZED_INVENTORY_STATUS_AVAILABLE nvarchar(10) = 'Available'
	--DECLARE @SERIALIZED_INVENTORY_STATUS_DAMAGED nvarchar(10) = 'Damaged'
	DECLARE @SERIALIZED_INVENTORY_STATUS_SOLD nvarchar(10) = 'Sold'
	DECLARE @SERIALIZED_INVENTORY_STATUS_RETURNED nvarchar(10) = 'Returned'
    DECLARE @SERIALIZED_INVENTORY_STATUS_RETURNED_AVAILABLE nvarchar(10) = 'RTRNAVAIL'
	--DECLARE @SERIALIZED_INVENTORY_STATUS_TRANSFERRED nvarchar(10) = 'Xfer'

	DECLARE @UNIT_OF_MEASURE_EACH nvarchar(10) = 'Each'
	DECLARE @UNIT_OF_MEASURE_CASE nvarchar(10) = 'CASE'

	DECLARE @DISTRIBUTOR_PURCHAE_ORDER_STATUS_RECEIVED nvarchar(10) = 'Received'

	DECLARE @InventoryAdjustmentTypeID AS int
			, @InventoryAdjustmentTypeDescriptionShort AS nvarchar(10)
			, @IsNegativeAdjustment AS bit
			, @IsDistributorAdjustment AS bit
			, @AdjustmentMultiplier AS int
			, @InventoryAdjustmentID AS int = NULL
	-- TODO: IF Adjustment Type is not found, throw an error.

	-- Write Inventory Adjustment
	IF (@Action = @ACTION_DISTRIBUTOR_ORDER_ADJUSTMENT)
	BEGIN
		-- Use Order PO adjustment type
		SELECT @InventoryAdjustmentTypeID = InventoryAdjustmentTypeID
				, @IsNegativeAdjustment = IsNegativeAdjustment
				, @IsDistributorAdjustment = IsDistributorAdjustment
				, @AdjustmentMultiplier = CASE WHEN IsNegativeAdjustment = 1 THEN -1 ELSE 1 END
		FROM lkpInventoryAdjustmentType
		WHERE InventoryAdjustmentTypeDescriptionShort = @INVENTORY_ADJUSTMENT_TYPE_PLACE_PURCHASE_ORDER

		-- Inventory Adjustment entry
		INSERT INTO [dbo].[datInventoryAdjustment]
			   ([CenterID],[DistributorPurchaseOrderID],[InventoryAdjustmentTypeID],[InventoryAdjustmentDate]

			   ,[EmployeeGUID],[SalesOrderGUID],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser])
		SELECT
				po.DistributorCenterID
			   ,po.DistributorPurchaseOrderID
			   ,@InventoryAdjustmentTypeID
			   ,GETUTCDATE()
			   ,po.EmployeeGUID
			   ,NULL -- SalesOrderGUID
			   ,GETUTCDATE()
			   ,@Username
			   ,GETUTCDATE()
			   ,@Username
		FROM datDistributorPurchaseOrder po
		WHERE po.DistributorPurchaseOrderID = @AdjustmentSourceID

		SELECT @InventoryAdjustmentID = SCOPE_IDENTITY()

		INSERT INTO [dbo].[datInventoryAdjustmentDetail]
           ([InventoryAdjustmentID],[DistributorPurchaseOrderDetailID],[SalesCodeID],[QuantityAdjustment]
           ,[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser])
		SELECT
			   @InventoryAdjustmentID
			   ,pod.DistributorPurchaseOrderDetailID
			   ,sc.SalesCodeID
			   ,CASE
					WHEN uom.UnitOfMeasureDescriptionShort = @UNIT_OF_MEASURE_CASE THEN sc.QuantityPerPack * pod.Quantity
					ELSE pod.Quantity END
			   ,GETUTCDATE()
			   ,@Username
			   ,GETUTCDATE()
			   ,@Username
		FROM datDistributorPurchaseOrderDetail pod
			INNER JOIN lkpUnitOfMeasure uom ON uom.UnitOfMeasureID = pod.UnitOfMeasureID
			INNER JOIN cfgSalesCodeDistributor scd ON scd.SalesCodeDistributorID = pod.SalesCodeDistributorID
			INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = scd.SalesCodeID
		WHERE pod.DistributorPurchaseOrderID = @AdjustmentSourceID

		--IF @IsDistributorAdjustment = 1
		--BEGIN
		--	-- Update Inventory Counts at Distributor
		--	UPDATE scd SET
		--		QuantityAvailable = QuantityAvailable + (invdet.QuantityAdjustment * @AdjustmentMultiplier)
		--		,LastUpdate = GETUTCDATE()
		--		,LastUpdateUser = @Username
		--	FROM datDistributorPurchaseOrderDetail pod
		--		INNER JOIN datInventoryAdjustmentDetail invdet ON invdet.DistributorPurchaseOrderDetailID = pod.DistributorPurchaseOrderDetailID
		--		--INNER JOIN lkpInventoryAdjustmentType t ON t.InventoryAdjustmentTypeID = invdet.InventoryAdjustmentTypeID
		--		INNER JOIN cfgSalesCodeDistributor scd ON scd.SalesCodeDistributorID = pod.SalesCodeDistributorID
		--	WHERE pod.DistributorPurchaseOrderID = @AdjustmentSourceID
		--END

	END
	ELSE IF (@Action = @ACTION_INVENTORY_ADJUSTMENT)
	BEGIN
		SET @InventoryAdjustmentID = @AdjustmentSourceID
	END
	ELSE IF (@Action = @ACTION_SALES_ORDER_ADJUSTMENT)
	BEGIN
		-- Determine if there is Inventory on the Sales
		-- Order that is being tracked.
		DECLARE @InventoryDetails TABLE
		(
		  SalesOrderDetailGUID uniqueidentifier,
		  InventorySalesCodeID int,
		  Quantity int
		)

		INSERT INTO @InventoryDetails (SalesOrderDetailGUID, InventorySalesCodeID, Quantity)
			SELECT
				sod.SalesOrderDetailGUID
				,scc.SalesCodeID
				,sod.Quantity
			FROM datSalesOrder so
				INNER JOIN datSalesOrderDetail sod ON sod.SalesOrderGUID = so.SalesOrderGUID
				INNER JOIN cfgConfigurationCenter cc ON cc.CenterID = so.CenterID
				INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = sod.SalesCodeID
				INNER JOIN cfgSalesCodeCenter scc ON scc.CenterID = so.CenterID	AND scc.IsActiveFlag = 1
				INNER JOIN datSalesCodeCenterInventory scci ON scci.SalesCodeCenterID = scc.SalesCodeCenterID AND scci.IsActive = 1
			WHERE so.SalesOrderGUID = @AdjustmentSourceGUID
				AND (sc.IsSerialized = 1  OR (sc.IsSerialized = 0 AND cc.IsNonSerializedInventoryEnabled = 1))
				AND (scc.SalesCodeID = sc.InventorySalesCodeID
					OR (sc.InventorySalesCodeID IS NULL AND scc.SalesCodeID = sc.SalesCodeID))

		IF EXISTS (SELECT * FROM @InventoryDetails)
		BEGIN
			-- Inventory Adjustment entry
			INSERT INTO [dbo].[datInventoryAdjustment]
				   ([CenterID],[DistributorPurchaseOrderID],[InventoryAdjustmentTypeID],[InventoryAdjustmentDate]
				   ,[EmployeeGUID],[SalesOrderGUID],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser])
			SELECT
				so.CenterID
				,NULL  --DistributorPurchaseOrderID
				,CASE WHEN so.IsRefundedFlag = 1 THEN returnType.InventoryAdjustmentTypeID
						ELSE saleType.InventoryAdjustmentTypeID END
				,GETUTCDATE()
				,so.EmployeeGUID
				,so.SalesOrderGUID -- SalesOrderGUID
				,GETUTCDATE()
				,@Username
				,GETUTCDATE()
				,@Username
			FROM datSalesOrder so
				INNER JOIN lkpInventoryAdjustmentType saleType ON saleType.InventoryAdjustmentTypeDescriptionShort = @INVENTORY_ADJUSTMENT_TYPE_SALE
				INNER JOIN lkpInventoryAdjustmentType returnType ON returnType.InventoryAdjustmentTypeDescriptionShort = @INVENTORY_ADJUSTMENT_TYPE_RETURN
			WHERE so.SalesOrderGUID = @AdjustmentSourceGUID

			SELECT @InventoryAdjustmentID = SCOPE_IDENTITY()

			INSERT INTO [dbo].[datInventoryAdjustmentDetail]
			   ([InventoryAdjustmentID],[DistributorPurchaseOrderDetailID],[SalesOrderDetailGUID],
				[SalesCodeID],[QuantityAdjustment],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser])
			SELECT
				@InventoryAdjustmentID
				,NULL   --DistributorPurchaseOrderDetailID
				,d.SalesOrderDetailGUID
				,d.InventorySalesCodeID
				,ABS(d.Quantity)
				,GETUTCDATE()
				,@Username
				,GETUTCDATE()
				,@Username
			FROM @InventoryDetails d

			INSERT INTO [datInventoryAdjustmentDetailSerialized]
			   ([InventoryAdjustmentDetailID],[SerialNumber],[NewSerializedInventoryStatusID],
				[IsScannedEntry],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser])
			SELECT
				det.InventoryAdjustmentDetailID
				,sccis.SerialNumber
				,CASE WHEN sod.IsRefundedFlag = 1 THEN
                        CASE WHEN sodSer.IsReturnedItemAvailableForResale = 1 THEN retAvailStat.SerializedInventoryStatusID
                        ELSE retStat.SerializedInventoryStatusID END
     			 ELSE soldStat.SerializedInventoryStatusID END -- New Status
				,sodSer.IsScannedEntry
				,GETUTCDATE()
				,@Username
				,GETUTCDATE()
				,@Username
			FROM [datInventoryAdjustmentDetail] det
				INNER JOIN datSalesOrderDetail sod ON sod.SalesOrderDetailGUID = det.SalesOrderDetailGUID
				INNER JOIN datSalesOrderDetailSerialized sodSer ON sodSer.SalesOrderDetailGUID = sod.SalesOrderDetailGUID
				INNER JOIN datSalesCodeCenterInventorySerialized sccis ON sccis.SalesCodeCenterInventorySerializedID = sodSer.SalesCodeCenterInventorySerializedID
				INNER JOIN lkpSerializedInventoryStatus soldStat ON soldStat.SerializedInventoryStatusDescriptionShort = @SERIALIZED_INVENTORY_STATUS_SOLD
				INNER JOIN lkpSerializedInventoryStatus retStat ON retStat.SerializedInventoryStatusDescriptionShort = @SERIALIZED_INVENTORY_STATUS_RETURNED
                INNER JOIN lkpSerializedInventoryStatus retAvailStat ON retAvailStat.SerializedInventoryStatusDescriptionShort = @SERIALIZED_INVENTORY_STATUS_RETURNED_AVAILABLE
			WHERE det.InventoryAdjustmentID = @InventoryAdjustmentID

		END
	END


	/*
	-- Update Inventory based on above Adjustments
	*/
	IF @InventoryAdjustmentID IS NOT NULL
	BEGIN

		SELECT @InventoryAdjustmentTypeID = t.InventoryAdjustmentTypeID
				, @InventoryAdjustmentTypeDescriptionShort = t.InventoryAdjustmentTypeDescriptionShort
				, @IsNegativeAdjustment = t.IsNegativeAdjustment
				, @IsDistributorAdjustment = t.IsDistributorAdjustment
				, @AdjustmentMultiplier = CASE WHEN t.IsNegativeAdjustment = 1 THEN -1 ELSE 1 END
		FROM datInventoryAdjustment ad
			INNER JOIN lkpInventoryAdjustmentType t ON t.InventoryAdjustmentTypeID = ad.InventoryAdjustmentTypeID
		WHERE ad.InventoryAdjustmentID = @InventoryAdjustmentID

		IF 	@IsDistributorAdjustment = 1
		BEGIN
			UPDATE scd SET
				QuantityAvailable = QuantityAvailable + (invdet.QuantityAdjustment * @AdjustmentMultiplier)
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @Username
			FROM datInventoryAdjustment inv
				INNER JOIN datInventoryAdjustmentDetail invdet ON inv.InventoryAdjustmentID = invdet.InventoryAdjustmentID
				INNER JOIN cfgSalesCodeDistributor scd ON scd.SalesCodeID = invdet.SalesCodeID AND scd.CenterID = inv.CenterID
			WHERE inv.InventoryAdjustmentID = @InventoryAdjustmentID
		END
		ELSE
		BEGIN
			-- Update Inventory Counts at Center
			UPDATE scci SET
				QuantityOnHand = scci.QuantityOnHand + (invdet.QuantityAdjustment * @AdjustmentMultiplier)
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @Username
			FROM datInventoryAdjustment inv
				INNER JOIN datInventoryAdjustmentDetail invdet ON invdet.InventoryAdjustmentID = inv.InventoryAdjustmentID
				INNER JOIN cfgSalesCodeCenter scc ON scc.CenterID = inv.CenterID AND scc.SalesCodeID = invdet.SalesCodeID AND scc.IsActiveFlag = 1
				INNER JOIN datSalesCodeCenterInventory scci ON scci.SalesCodeCenterID = scc.SalesCodeCenterID AND scci.IsActive = 1
			WHERE inv.InventoryAdjustmentID = @InventoryAdjustmentID

			-- Adjust Serialized Inventory
			IF @IsNegativeAdjustment = 0
			BEGIN

				-- Update Existing Serialized inventory
				UPDATE scser SET
						SalesCodeCenterInventoryID = scci.SalesCodeCenterInventoryID
					,SerializedInventoryStatusID = invser.NewSerializedInventoryStatusID
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @Username
				FROM datInventoryAdjustment inv
					INNER JOIN datInventoryAdjustmentDetail invdet ON invdet.InventoryAdjustmentID = inv.InventoryAdjustmentID
					INNER JOIN datInventoryAdjustmentDetailSerialized invser ON invser.InventoryAdjustmentDetailID = invdet.InventoryAdjustmentDetailID
					INNER JOIN datSalesCodeCenterInventorySerialized scser ON scser.SerialNumber = invser.SerialNumber
					-- determine possibly a new sales code center record to associate with because it could be moving from a different center
					INNER JOIN cfgSalesCodeCenter scc ON scc.SalesCodeID = invdet.SalesCodeID AND scc.CenterID = inv.CenterID AND scc.IsActiveFlag = 1
					INNER JOIN datSalesCodeCenterInventory scci ON scci.SalesCodeCenterID = scc.SalesCodeCenterID AND scci.IsActive = 1
				WHERE inv.InventoryAdjustmentID = @InventoryAdjustmentID

				-- Insert new Serialized inventory
				INSERT INTO [dbo].[datSalesCodeCenterInventorySerialized]
							([SalesCodeCenterInventoryID],[SerialNumber]
							,[SerializedInventoryStatusID],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser])
					SELECT
						scci.SalesCodeCenterInventoryID
						,invser.SerialNumber
						,invser.NewSerializedInventoryStatusID --st.SerializedInventoryStatusID
						,GETUTCDATE()
						,@Username
						,GETUTCDATE()
						,@Username
					FROM datInventoryAdjustment inv
						INNER JOIN datInventoryAdjustmentDetail invdet ON invdet.InventoryAdjustmentID = inv.InventoryAdjustmentID
						INNER JOIN datInventoryAdjustmentDetailSerialized invser ON invser.InventoryAdjustmentDetailID = invdet.InventoryAdjustmentDetailID
						INNER JOIN cfgSalesCodeCenter scc ON scc.SalesCodeID = invdet.SalesCodeID AND scc.CenterID = inv.CenterID AND scc.IsActiveFlag = 1
						INNER JOIN datSalesCodeCenterInventory scci ON scci.SalesCodeCenterID = scc.SalesCodeCenterID AND scci.IsActive = 1
						LEFT JOIN datSalesCodeCenterInventorySerialized scser ON scser.SerialNumber = invser.SerialNumber
					WHERE inv.InventoryAdjustmentID = @InventoryAdjustmentID
						AND scser.SalesCodeCenterInventorySerializedID IS NULL

			END
			ELSE IF @IsNegativeAdjustment = 1
			BEGIN
				--SELECT scc.SalesCodeID, scc.SalesCodeCenterID, st.SerializedInventoryStatusDescriptionShort, scser.*
				UPDATE scser SET
					SalesCodeCenterInventoryID = scci.SalesCodeCenterInventoryID
					,SerializedInventoryStatusID = invser.NewSerializedInventoryStatusID --st.SerializedInventoryStatusID
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @Username
				FROM datInventoryAdjustment inv
					INNER JOIN datInventoryAdjustmentDetail invdet ON invdet.InventoryAdjustmentID = inv.InventoryAdjustmentID
					INNER JOIN datInventoryAdjustmentDetailSerialized invser ON invser.InventoryAdjustmentDetailID = invdet.InventoryAdjustmentDetailID
					INNER JOIN datSalesCodeCenterInventorySerialized scser ON scser.SerialNumber = invser.SerialNumber
					-- determine possibly a new sales code center record to associate with because it could be moving from a different center
					INNER JOIN cfgSalesCodeCenter scc ON scc.SalesCodeID = invdet.SalesCodeID AND scc.CenterID = inv.CenterID AND scc.IsActiveFlag = 1
					INNER JOIN datSalesCodeCenterInventory scci ON scci.SalesCodeCenterID = scc.SalesCodeCenterID AND scci.IsActive = 1
				WHERE inv.InventoryAdjustmentID = @InventoryAdjustmentID
			END
		END

	END

END
GO
