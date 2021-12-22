/* CreateDate: 12/20/2019 08:50:23.677 , ModifyDate: 05/24/2021 09:11:13.400 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				dbaCompileInventoryDifferences
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Edmund Poillion
IMPLEMENTOR: 			Edmund Poillion
DATE IMPLEMENTED: 		09/06/2017
LAST REVISION DATE: 	09/06/2017
--------------------------------------------------------------------------------------------------------
NOTES: 	Called from EIGlobalRefresh SSIS Package.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC [dbo].[dbaCompileInventoryDifferencesIFS] @SSISRunInstance = '2019-12-19 01:04:11.000', @UserName = 'SSISIFSBatchUpdates', @CenterId = 1091, @TestCommunicationWithNewProduct = 0, @IsDebug = 1;


***********************************************************************/

CREATE  PROCEDURE [dbo].[dbaCompileInventoryDifferencesIFS]
	@SSISRunInstance datetime,
	@UserName nvarchar(25),
	@CenterId bigint,
	@TestCommunicationWithNewProduct bigint,
	@IsDebug bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Set allocated code
	DECLARE @Allocated nvarchar(25) = N'Allocated';
	DECLARE @AddInventoryAdjustmentID int = -1;
	DECLARE @RemInventoryAdjustmentID int = -1;

	-- (1) Determine the @InventoryAdjustmentTypeID for tracking auto-updates from distributor
	DECLARE @AddAdjustTypeID int;
	SELECT @AddAdjustTypeID = [InventoryAdjustmentTypeID] FROM [lkpInventoryAdjustmentType] WHERE [InventoryAdjustmentTypeDescriptionShort] = 'DistSysAdd' AND [IsActive] = 1;

	DECLARE @RemAdjustTypeID int;
	SELECT @RemAdjustTypeID = [InventoryAdjustmentTypeID] FROM [lkpInventoryAdjustmentType] WHERE [InventoryAdjustmentTypeDescriptionShort] = 'DistSysRem' AND [IsActive] = 1;

	IF (@IsDebug = 1) SELECT @AddAdjustTypeID AS '@AddAdjustTypeID', @RemAdjustTypeID AS '@RemAdjustTypeID';

	-- (1.5) Add a new product to test new production communications on the server, when appropriate
	IF (@TestCommunicationWithNewProduct > 0)
	BEGIN
		IF ((SELECT COUNT(1) FROM [datSalesCodeDistributorSnapshot] WHERE [ItemSKU] LIKE 'NewProduct%' AND [SSISRunInstance] = @SSISRunInstance) = 0)
		BEGIN
			INSERT INTO [datSalesCodeDistributorSnapshot] ([ItemSKU], [QuantityAvailable], [Warehouse], [AreaName], [SSISRunInstance]) VALUES ('NewProduct_A', 7, '80 Ormont', 'Inventory', @SSISRunInstance);
			INSERT INTO [datSalesCodeDistributorSnapshot] ([ItemSKU], [QuantityAvailable], [Warehouse], [AreaName], [SSISRunInstance]) VALUES ('NewProduct_A', 8, 'The Other Warehouse', 'Inventory', @SSISRunInstance);
			INSERT INTO [datSalesCodeDistributorSnapshot] ([ItemSKU], [QuantityAvailable], [Warehouse], [AreaName], [SSISRunInstance]) VALUES ('NewProduct_A', 404, 'The Other Warehouse', 'Allocated', @SSISRunInstance);
			INSERT INTO [datSalesCodeDistributorSnapshot] ([ItemSKU], [QuantityAvailable], [Warehouse], [AreaName], [SSISRunInstance]) VALUES ('NewProduct_B', 4, '80 Ormont', 'Inventory', @SSISRunInstance);
			INSERT INTO [datSalesCodeDistributorSnapshot] ([ItemSKU], [QuantityAvailable], [Warehouse], [AreaName], [SSISRunInstance]) VALUES ('NewProduct_B', 123, '80 Ormont', 'Allocated', @SSISRunInstance);
		END
	END

    DECLARE @warehouse VARCHAR(20) = (SELECT WarehouseId FROM cfgCenter WHERE CenterId = @CenterId)
	--(1.70) Update datSalesCodeDistributorSnapshot with correct ItemSalesCodeID
	UPDATE
		scds
	SET
		scds.ItemSalesCodeID = bef.SalesCodeID
	FROM
		datSalesCodeDistributorSnapshot scds
	JOIN
		tmpInventorySalesCodeDistributorIFSBefore bef ON bef.ItemSKU = scds.ItemSKU
	WHERE
		bef.SSISRunInstance = @SSISRunInstance AND scds.Warehouse = bef.WarehouseId; ----- CHANGE


	--(1.71) Update datSalesCodeDistributorSnapshot with correct PackSalesCodeID
	UPDATE
		scds
	SET
		scds.PackSalesCodeID = bef.SalesCodeID
	FROM
		datSalesCodeDistributorSnapshot scds
	JOIN
		tmpInventorySalesCodeDistributorIFSBefore bef ON bef.PackSKU = scds.ItemSKU
	WHERE
		bef.SSISRunInstance = @SSISRunInstance AND scds.Warehouse = bef.WarehouseId;
;



	--(2) Populate changes temp table (exclude already allocated items)
	SELECT
		[ItemSKU],
		SUM([QuantityAvailable]) AS [QuantityAvailable],
		CAST(0 AS int) AS [QuantityChange],
		COALESCE(ItemSalesCodeID, PackSalesCodeID) AS [SalesCodeId],
		ItemSalesCodeID,
		PackSalesCodeID,
	    Warehouse
	INTO
		#tmpChanges
	FROM
		[datSalesCodeDistributorSnapshot]
	WHERE
		[SSISRunInstance] = @SSISRunInstance
		AND Warehouse = @warehouse
		--AND [AreaName] <> @Allocated
		AND ItemSalesCodeID IS NOT NULL
			--(
			--	(ItemSalesCodeID IS NOT NULL AND PackSalesCodeID IS NULL)
			--	OR (ItemSalesCodeID IS NOT NULL AND PackSalesCodeID IS NOT NULL)
			--)
	GROUP BY
		[ItemSKU],
		ItemSalesCodeID,
		PackSalesCodeID,
		Warehouse; ---- CHANGE

	IF (@IsDebug = 1) SELECT 'datSalesCodeDistributorSnapshot' AS TableName, * FROM [datSalesCodeDistributorSnapshot] WHERE [SSISRunInstance] = @SSISRunInstance;
	IF (@IsDebug = 1) SELECT '#tmpChanges' AS TableName, * FROM #tmpChanges;


	 --(3) Pull all rows that didn't exist before into new products temp table
	SELECT
		[ItemSKU]
	INTO
		#tmpNewProducts
	FROM
		[datSalesCodeDistributorSnapshot]
	WHERE
		[SSISRunInstance] = @SSISRunInstance
		AND Warehouse = @warehouse
		AND ItemSalesCodeID IS NULL
		AND PackSalesCodeID IS NULL

 	IF (@IsDebug = 1) SELECT '#tmpNewProducts' AS TableName, * FROM #tmpNewProducts;
 	IF (@IsDebug = 1) SELECT 'tmpInventorySalesCodeDistributorIFSBefore' AS TableName, * FROM tmpInventorySalesCodeDistributorIFSBefore WHERE SSISRunInstance = @SSISRunInstance;


	 --(5) Update quantity changes by Item SKU
	UPDATE
		#tmpChanges
	SET
		[QuantityChange] = #tmpChanges.[QuantityAvailable] - bef.[QuantityAvailable]
	FROM
		[tmpInventorySalesCodeDistributorIFSBefore] bef
	LEFT JOIN
		#tmpChanges ON #tmpChanges.SalesCodeID = bef.SalesCodeID
	WHERE
		bef.[SSISRunInstance] = @SSISRunInstance AND bef.WarehouseId = #tmpChanges.Warehouse;

	IF (@IsDebug = 1) SELECT '#tmpChanges(5)' AS TableName, * FROM #tmpChanges;


	 --(6) Remove all rows without actual quantity changes (not interesting)
	DELETE FROM
		#tmpChanges
	WHERE
		[QuantityChange] = 0;

	IF (@IsDebug = 1) SELECT '#tmpChanges(6)' AS TableName, * FROM #tmpChanges;


	 --(8) Transaction, only if something else hasn't come in since
	IF ((SELECT COUNT(1) FROM [tmpInventorySalesCodeDistributorIFSBefore] WHERE [SSISRunInstance] > @SSISRunInstance) <= 0)
	BEGIN
		BEGIN TRANSACTION Inventory_Updates;


		--(8B1) Log all inventory additions as one inventory change
		--  Note: Left at null: [DistributorPurchaseOrderID],[EmployeeGUID],[SalesOrderGUID]
		IF ((SELECT COUNT(1) FROM #tmpChanges WHERE QuantityChange > 0) > 0)
		BEGIN
			INSERT INTO
				[dbo].[datInventoryAdjustment] ([CenterID],[InventoryAdjustmentTypeID],[InventoryAdjustmentDate],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser])
			VALUES
				(@CenterId, @AddAdjustTypeID, @SSISRunInstance,@SSISRunInstance, @UserName, @SSISRunInstance, @UserName);


			--(8C1) Determine the InventoryAdjustmentId to use for the next insert
			SET @AddInventoryAdjustmentID = SCOPE_IDENTITY();


			--(8D1) Insert the specific quantity details
			--  Note: Left at null: [DistributorPurchaseOrderID]
			INSERT INTO
				[dbo].[datInventoryAdjustmentDetail] ([InventoryAdjustmentID],[SalesCodeID],[QuantityAdjustment],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser])
			SELECT
				@AddInventoryAdjustmentID,
				#tmpChanges.[SalesCodeId],
				ABS(#tmpChanges.[QuantityChange]),
				@SSISRunInstance,
				@UserName,
				@SSISRunInstance,
				@UserName
			FROM
				#tmpChanges
			WHERE
				QuantityChange > 0;
		END


		--(8B2) Log all inventory additions as one inventory change
		--  Note: Left at null: [DistributorPurchaseOrderID],[EmployeeGUID],[SalesOrderGUID]
		IF ((SELECT COUNT(1) FROM #tmpChanges WHERE QuantityChange < 0) > 0)
		BEGIN
			INSERT INTO
				[dbo].[datInventoryAdjustment] ([CenterID],[InventoryAdjustmentTypeID],[InventoryAdjustmentDate],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser])
			VALUES
				(@CenterId, @RemAdjustTypeID, @SSISRunInstance,@SSISRunInstance, @UserName, @SSISRunInstance, @UserName);


			--(8C2) Determine the InventoryAdjustmentId to use for the next insert
			--DECLARE @InventoryAdjustmentID int;
			SET @RemInventoryAdjustmentID = SCOPE_IDENTITY();


			--(8D2) Insert the specific quantity details
			--  Note: Left at null: [DistributorPurchaseOrderID]
			INSERT INTO
				[dbo].[datInventoryAdjustmentDetail] ([InventoryAdjustmentID],[SalesCodeID],[QuantityAdjustment],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser])
			SELECT
				@RemInventoryAdjustmentID,
				#tmpChanges.[SalesCodeId],
				ABS(#tmpChanges.[QuantityChange]),
				@SSISRunInstance,
				@UserName,
				@SSISRunInstance,
				@UserName
			FROM
				#tmpChanges
			WHERE
				QuantityChange < 0;
		END


		--(8E-F) If something else hasn't come in since, commit; else, rollback
		IF ((SELECT COUNT(1) FROM [tmpInventorySalesCodeDistributorIFSBefore] WHERE [SSISRunInstance] > @SSISRunInstance) <= 0)
		BEGIN
			COMMIT TRANSACTION Inventory_Updates;
		END
		ELSE
		BEGIN
			ROLLBACK TRANSACTION Inventory_Updates;
		END
	END

	IF (@IsDebug = 1) SELECT @AddInventoryAdjustmentID AS '@AddInventoryAdjustmentID', @RemInventoryAdjustmentID AS '@RemInventoryAdjustmentID';
	IF (@IsDebug = 1) SELECT * FROM [datInventoryAdjustment] WHERE InventoryAdjustmentId = @AddInventoryAdjustmentID;
	IF (@IsDebug = 1) SELECT * FROM [datInventoryAdjustment] WHERE InventoryAdjustmentId = @RemInventoryAdjustmentID;
	IF (@IsDebug = 1) SELECT * FROM [datInventoryAdjustmentDetail] WHERE InventoryAdjustmentId = @AddInventoryAdjustmentID;
	IF (@IsDebug = 1) SELECT * FROM [datInventoryAdjustmentDetail] WHERE InventoryAdjustmentId = @RemInventoryAdjustmentID;


	--(9) Return all details on new products
	SELECT
		[datSalesCodeDistributorSnapshot].[ItemSKU],
		[datSalesCodeDistributorSnapshot].[QuantityAvailable],
		[datSalesCodeDistributorSnapshot].[Warehouse]
	FROM
		#tmpNewProducts
	JOIN
		[datSalesCodeDistributorSnapshot] ON [datSalesCodeDistributorSnapshot].[ItemSKU] = #tmpNewProducts.[ItemSKU]
	WHERE
		[datSalesCodeDistributorSnapshot].SSISRunInstance = @SSISRunInstance
		--AND [datSalesCodeDistributorSnapshot].[AreaName] <> @Allocated;


	-- (9.5) Remove new products to test new production communications on the server, when appropriate
	IF (@TestCommunicationWithNewProduct > 0)
	BEGIN
		IF ((SELECT COUNT(1) FROM [datSalesCodeDistributorSnapshot] WHERE [ItemSKU] LIKE 'NewProduct%' AND SSISRunInstance = @SSISRunInstance) > 0)
		BEGIN
			DELETE
				[datSalesCodeDistributorSnapshot]
			WHERE
				[ItemSKU] LIKE 'NewProduct%' AND [SSISRunInstance] = @SSISRunInstance;
		END
	END


	 --(10) Finally, drop the temporary tables
	DROP TABLE #tmpChanges;
	DROP TABLE #tmpNewProducts;

	IF (@AddInventoryAdjustmentID > 0) EXEC mtnInventoryAdjustment @AddInventoryAdjustmentID, null, 'Inventory Adjustment', @UserName;
	IF (@RemInventoryAdjustmentID > 0) EXEC mtnInventoryAdjustment @RemInventoryAdjustmentID, null, 'Inventory Adjustment', @UserName;
	IF (@IsDebug = 1) SELECT 'cfgSalesCodeDistributor' AS TableName, * FROM cfgSalesCodeDistributor;

END
GO
