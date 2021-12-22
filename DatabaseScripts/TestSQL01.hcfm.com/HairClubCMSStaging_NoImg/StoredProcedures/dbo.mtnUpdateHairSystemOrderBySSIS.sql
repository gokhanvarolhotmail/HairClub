/* CreateDate: 11/14/2011 19:20:10.323 , ModifyDate: 03/16/2017 16:23:24.923 */
GO
/***********************************************************************
PROCEDURE:				mtnUpdateHairSystemOrderBySSIS
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				HDu
IMPLEMENTOR: 			HDu
DATE IMPLEMENTED: 		10/24/11
LAST REVISION DATE: 	10/24/11
--------------------------------------------------------------------------------------------------------
NOTES: 	Updates a HairSystemOrder status and logs a transaction
	2012-03-28 - HDu - Update for additional fields being sent up from Factory
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
mtnUpdateHairSystemOrderBySSIS
@HairSystemOrderNumber = 1111,
@HairSystemOrderStatus = 'FAC-SHIP',
@CostActual = 99.99,
@FactoryCode = '5A',
@SubFactoryCode = 'X',
@PodCode = 'n'

,@InvoiceDate = ''
,@InvoiceNumber = ''
,@ShipmentMethodCode = ''
,@TrackingNumber = ''
,@InvoiceDescription = ''
,@PurchaseOrderNumber = ''
,@OrderCount = '0'
,@TotalInvoiceValue = '0'
,@InvoiceGUID = 'B07EE049-9CF8-4288-9166-E1ADAC020997'
?,?,?,?,?,?,?,?,?,?,?,?,?,?,?
***********************************************************************/

CREATE PROCEDURE [dbo].[mtnUpdateHairSystemOrderBySSIS]
@HairSystemOrderNumber NVARCHAR(50) = NULL,
@HairSystemOrderStatus NVARCHAR(50) = NULL, -- StatusIDs do not match between CMS and Factory
@CostActual NVARCHAR(50) = NULL,
@FactoryCode NVARCHAR(10) = NULL,
@SubFactoryCode NVARCHAR(10) = NULL,
@PodCode NVARCHAR(10) = NULL

,@InvoiceDate NVARCHAR(50) = NULL
,@InvoiceNumber NVARCHAR(50) = NULL
,@ShipmentMethodCode NVARCHAR(50) = NULL
,@TrackingNumber NVARCHAR(50) = NULL
,@InvoiceDescription NVARCHAR(50) = NULL
,@PurchaseOrderNumber NVARCHAR(50) = NULL
,@OrderCount NVARCHAR(50) = NULL
,@TotalInvoiceValue NVARCHAR(50) = NULL
,@InvoiceGUID NVARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
	INSERT INTO [Utility].[dbo].[mtnUpdateHairSystemOrderBySSISlog]
			   ([RunTime]
			   ,[HairSystemOrderNumber]
			   ,[HairSystemOrderStatus]
			   ,[CostActual]
			   ,[FactoryCode]
			   ,[SubFactoryCode]
			   ,[PodCode]
			   ,[InvoiceDate]
			   ,[InvoiceNumber]
			   ,[ShipmentMethodCode]
			   ,[TrackingNumber]
			   ,[InvoiceDescription]
			   ,[PurchaseOrderNumber]
			   ,[OrderCount]
			   ,[TotalInvoiceValue]
			   ,[InvoiceGUID])
		 VALUES
			   (GETDATE(),
				@HairSystemOrderNumber,
				@HairSystemOrderStatus,
				@CostActual,
				@FactoryCode,
				@SubFactoryCode,
				@PodCode,
				@InvoiceDate,
				@InvoiceNumber,
				@ShipmentMethodCode,
				@TrackingNumber,
				@InvoiceDescription,
				@PurchaseOrderNumber,
				@OrderCount,
				@TotalInvoiceValue,
				@InvoiceGUID);
	------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------

	-- Ignore 8P Updates.
	IF @FactoryCode <> '8P' AND (@SubFactoryCode IS NULL OR @SubFactoryCode <> '8P')
		BEGIN

		BEGIN TRANSACTION
			BEGIN TRY

			DECLARE @ShipmentMethodID INT
			SELECT @ShipmentMethodID = ShipmentMethodID FROM lkpShipmentMethod WHERE ShipmentMethodDescriptionShort = @ShipmentMethodCode

			IF EXISTS (SELECT 1 FROM [dbo].[datInvoice] WHERE InvoiceGUID = @InvoiceGUID)
				UPDATE [dbo].[datInvoice]
				   SET [InvoiceNumber] = @InvoiceNumber
					  ,[InvoiceDate] = @InvoiceDate
					  ,[InvoiceDescription] = @InvoiceDescription
					  ,[OrderCount] = @OrderCount
					  ,[TotalInvoiceValue] = @TotalInvoiceValue
					  ,[ShipmentMethodID] = @ShipmentMethodID
					  ,[TrackingNumber] = @TrackingNumber
					  ,PurchaseOrderNumber = @PurchaseOrderNumber
					  ,[CreateDate] = GETDATE()
					  ,[CreateUser] = 'sa'
					  ,[LastUpdate] = GETDATE()
					  ,[LastUpdateUser] = 'sa'
				WHERE [InvoiceGUID] = @InvoiceGUID
				ELSE
				INSERT INTO [dbo].[datInvoice]([InvoiceGUID],[InvoiceNumber],[InvoiceDate],[InvoiceDescription],[OrderCount],[TotalInvoiceValue],[ShipmentMethodID],[TrackingNumber],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],PurchaseOrderNumber)
				VALUES(@InvoiceGUID
				,@InvoiceNumber
				,@InvoiceDate
				,@InvoiceDescription
				,@OrderCount
				,@TotalInvoiceValue
				,@ShipmentMethodID
				,@TrackingNumber
				,GETDATE()
				,'sa'
				,GETDATE()
				,'sa'
				,@PurchaseOrderNumber)


			DECLARE @HairSystemOrderGUID UNIQUEIDENTIFIER
			SELECT TOP 1 @HairSystemOrderGUID = HairSystemOrderGUID FROM datHairSystemOrder WHERE HairSystemOrderNumber = @HairSystemOrderNumber

			--This will be interesting if different invoices contain the same hairsystemorder
			IF (SELECT COUNT(*) FROM datInvoiceDetail WHERE HairSystemOrderNumber = @HairSystemOrderNumber AND InvoiceGUID = @InvoiceGUID) = 0
			INSERT INTO [dbo].[datInvoiceDetail]([InvoiceDetailGUID],[InvoiceGUID],[HairSystemOrderNumber],[HairSystemOrderGUID],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser])
			VALUES(NEWID(),@InvoiceGUID,@HairSystemOrderNumber,@HairSystemOrderGUID,GETDATE(),'sa',GETDATE(),'sa')

					--STATUS SHOULD BE ORDERED

						DECLARE @HairSystemOrderStatusID INT
						SELECT @HairSystemOrderStatusID = HairSystemOrderStatusID
						FROM dbo.lkpHairSystemOrderStatus
						WHERE HairSystemOrderStatusDescriptionShort = @HairSystemOrderStatus

						--update HSO only if the HSO is in Ordered status
						IF EXISTS (SELECT * FROM dbo.datHairSystemOrder
							WHERE HairSystemOrderNumber = @HairSystemOrderNumber
							AND HairSystemOrderStatusID = 8) --ORDERED
						BEGIN
							--insert transaction
							INSERT INTO [dbo].[datHairSystemOrderTransaction]([HairSystemOrderTransactionGUID],[CenterID],[ClientHomeCenterID],[ClientGUID],[ClientMembershipGUID],[HairSystemOrderTransactionDate],[HairSystemOrderProcessID],[HairSystemOrderGUID],[PreviousCenterID],[PreviousClientMembershipGUID],[PreviousHairSystemOrderStatusID],[NewHairSystemOrderStatusID],[InventoryShipmentDetailGUID],[InventoryTransferRequestGUID],[PurchaseOrderDetailGUID],[CostContract],[PreviousCostContract],[CostActual],[PreviousCostActual],[CenterPrice],[PreviousCenterPrice],[CostFactoryShipped],[PreviousCostFactoryShipped],[EmployeeGUID],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser])
							SELECT NEWID() AS [HairSystemOrderTransactionGUID]
							,hso.[CenterID]
							,hso.[ClientHomeCenterID]
							,hso.[ClientGUID]
							,hso.[ClientMembershipGUID]
							,GETDATE() AS [HairSystemOrderTransactionDate]
							,20 AS [HairSystemOrderProcessID] -- FAC-Ship
							,hso.[HairSystemOrderGUID]
							,hso.[CenterID] AS [PreviousCenterID]
							,hso.[ClientMembershipGUID] AS [PreviousClientMembershipGUID]
							,hso.[HairSystemOrderStatusID] AS [PreviousHairSystemOrderStatusID]
							,@HairSystemOrderStatusID AS [NewHairSystemOrderStatusID]
							,NULL AS [InventoryShipmentDetailGUID]
							,NULL AS [InventoryTransferRequestGUID]
							,pod.PurchaseOrderDetailGUID
							,hso.[CostContract]
							,hso.[CostContract] AS [PreviousCostContract]
							,@CostActual AS [CostActual] -- NEW VALUE
							,hso.[CostActual] as [PreviousCostActual]
							,hso.[CenterPrice]
							,hso.[CenterPrice] AS [PreviousCenterPrice]
							,hso.CostFactoryShipped AS [CostFactoryShipped]
							,hso.CostFactoryShipped AS [PreviousCostFactoryShipped]
							,NULL AS [EmployeeGUID]
							,GETUTCDATE() AS [CreateDate]
							,'Factory' AS [CreateUser]
							,GETUTCDATE() AS [LastUpdate]
							,'Factory' AS [LastUpdateUser]
							FROM [dbo].[datHairSystemOrder] hso
							--INNER JOIN dbo.datInventoryShipmentDetail isd ON hso.[HairSystemOrderGUID] = isd.[HairSystemOrderGUID]
							INNER JOIN dbo.datPurchaseOrderDetail pod ON hso.[HairSystemOrderGUID] = pod.[HairSystemOrderGUID]
							WHERE hso.HairSystemOrderNumber = @HairSystemOrderNumber


							--update HSO
							UPDATE dbo.datHairSystemOrder
							SET HairSystemOrderStatusID = @HairSystemOrderStatusID,
								CostActual = @CostActual,
								SubFactoryCode = @SubFactoryCode,
								PodCode = @PodCode,
								LastUpdate = GETUTCDATE(),
								LastUpdateUser = 'Factory'
							WHERE HairSystemOrderNumber = @HairSystemOrderNumber

						END
						COMMIT TRANSACTION
					END TRY
					BEGIN CATCH
						ROLLBACK TRANSACTION
					END CATCH
		END
END
GO
