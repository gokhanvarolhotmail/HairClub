/* CreateDate: 05/02/2018 15:44:13.807 , ModifyDate: 05/02/2018 15:44:13.807 */
GO
/***********************************************************************

PROCEDURE:				tmpHansWiemannCreatecONEctHairOrders

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		05/01/2018

LAST REVISION DATE: 	05/01/2018

--------------------------------------------------------------------------------------------------------
NOTES:  Creates cONEct Hair Orders for Hans Wiemann's Hair Order Inventory.  Used to get their inventory
			on hand into cONEct

		* 05/01/2018	SAL	Created
		* 05/01/2018	DSL	Changed c.CurrentBioMatrixClientMembershipGUID to COALESCE(c.CurrentBioMatrixClientMembershipGUID, c.CurrentExtremeTherapyClientMembershipGUID, c.CurrentSurgeryClientMembershipGUID)
		* 05/02/2018	SAL	Close and Deallocate CUR in Catch
		* 05/02/2018	DSL Changed MAX(HairSystemOrderNumber) + 1 to MAX(CAST(HairSystemOrderNumber AS INT)) + 1
		* 05/02/2018	SAL	Changed to pull cfgConfigurationApplication.HairSystemOrderCounter + 1 for HairSystemOrderNumber
		* 05/02/2018	SAL	Changed to pull cfgConfigurationApplication.HairSystemOrderCounter + 1 for HairSystemOrderNumber
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC tmpHansWiemannCreatecONEctHairOrders

***********************************************************************/
CREATE PROCEDURE [dbo].[tmpHansWiemannCreatecONEctHairOrders]
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRY

	DECLARE @User nvarchar(25) = 'TFS9422'
	DECLARE @HWCenterID int = 1001
	DECLARE @HairSystemID_HW1 int
	DECLARE @HairSystemID_HW2 int
	DECLARE @HairSystemOrderStatusID_CENT int
	DECLARE @HairSystemOrderProcessID_ManualAdjustment int
	DECLARE @MeasurementsByEmployeeGUID uniqueidentifier
	DECLARE @HairSystemHairMaterialID_Human int
	DECLARE @HairSystemStyleID_FreeStyle int
	DECLARE @NextHairSystemOrderNumber nvarchar(50)
	DECLARE @HairSystemOrderGUID uniqueidentifier
	DECLARE @ClientGUID uniqueidentifier
	DECLARE @ClientMembershipGUID uniqueidentifier
	DECLARE @HairSystemID int
	DECLARE @HairSystemHairLengthID int
	DECLARE @HairSystemCurlID int
	DECLARE @HairSystemHairColorID int
	DECLARE @ClientKorvueID nvarchar(50)
	DECLARE @VendorHairOrderID nvarchar(50)

	SELECT @HairSystemID_HW1 = HairSystemID FROM cfgHairSystem WHERE HairSystemDescriptionShort = 'HW1' --used for On-Rite vendor
	SELECT @HairSystemID_HW2 = HairSystemID FROM cfgHairSystem WHERE HairSystemDescriptionShort = 'HW2' --used for New Image vendor
	SELECT @HairSystemOrderStatusID_CENT = HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'CENT'
	SELECT @HairSystemOrderProcessID_ManualAdjustment = HairSystemOrderProcessID FROM lkpHairSystemOrderProcess WHERE HairSystemOrderProcessDescriptionShort = 'MANUAL'
	SELECT @MeasurementsByEmployeeGUID = EmployeeGUID FROM datEmployee WHERE LastName = 'Gray' and FirstName = 'Susan'
	SELECT @HairSystemHairMaterialID_Human = HairSystemHairMaterialID FROM lkpHairSystemHairMaterial WHERE HairSystemHairMaterialDescriptionShort = 'H'
	SELECT @HairSystemStyleID_FreeStyle = HairSystemStyleID FROM lkpHairSystemStyle WHERE HairSystemStyleDescriptionShort = 'FS'

	DECLARE @CounterTable TABLE (HairSystemOrderCounter int)

	DECLARE CUR CURSOR FAST_FORWARD FOR
		SELECT o.ClientKorvueID
			,o.VendorHairOrderID
			,c.ClientGUID
			,COALESCE(c.CurrentBioMatrixClientMembershipGUID, c.CurrentExtremeTherapyClientMembershipGUID, c.CurrentSurgeryClientMembershipGUID)
			,CASE
				WHEN o.Vendor = 'On-Rite' THEN @HairSystemID_HW1
				ELSE @HairSystemID_HW2
			 END AS HairSystemID
			,hshl.HairSystemHairLengthID
			,hsc.HairSystemCurlID
			,hshc.HairSystemHairColorID
		FROM temp_HansWiemannHairOrders o
			inner join datClient c on o.ClientKorvueID = c.KorvueID
			inner join lkpHairSystemHairLength hshl on o.HairOrderHairLength = hshl.HairSystemHairLengthValue
			inner join lkpHairSystemCurl hsc on o.HairOrderCurlDescription = hsc.HairSystemCurlDescription
			inner join lkpHairSystemHairColor hshc on o.BaseHairOrderHairColor = hshc.HairSystemHairColorDescriptionShort
		WHERE DateProcessed IS NULL

	OPEN CUR

	FETCH NEXT FROM CUR INTO @ClientKorvueID, @VendorHairOrderID, @ClientGUID, @ClientMembershipGUID, @HairSystemID, @HairSystemHairLengthID, @HairSystemCurlID, @HairSystemHairColorID

	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF @ClientMembershipGUID IS NOT NULL
		BEGIN

		BEGIN TRANSACTION
			SET @HairSystemOrderGUID = NEWID()

			--Get the next HairOrderNumber
			DELETE FROM @CounterTable

			UPDATE cfgConfigurationApplication WITH (HOLDLOCK)
			SET HairSystemOrderCounter = (HairSystemOrderCounter + 1)
			OUTPUT inserted.HairSystemOrderCounter INTO @CounterTable

			SELECT TOP 1 @NextHairSystemOrderNumber = CAST(HairSystemOrderCounter AS nvarchar) FROM @CounterTable order by HairSystemOrderCounter desc

			--Insert datHairSystemOrder
			INSERT INTO [dbo].[datHairSystemOrder]
				   ([HairSystemOrderGUID]
				   ,[CenterID]
				   ,[ClientHomeCenterID]
				   ,[HairSystemOrderStatusID]
				   ,[ClientGUID]
				   ,[ClientMembershipGUID]
				   ,[OriginalClientGUID]
				   ,[OriginalClientMembershipGUID]
				   ,[HairSystemOrderDate]
				   ,[HairSystemOrderNumber]
				   ,[MeasurementEmployeeGUID]
				   ,[DueDate]
				   ,[TemplateReceivedDate]
				   ,[AppliedDate]
				   ,[IsRepairOrderFlag]
				   ,[IsRedoOrderFlag]
				   ,[IsRushOrderFlag]
				   ,[IsStockInventoryFlag]
				   ,[IsOnCenterHoldFlag]
				   ,[OriginalHairSystemOrderGUID]
				   ,[TemplateWidth]
				   ,[TemplateWidthAdjustment]
				   ,[TemplateHeight]
				   ,[TemplateHeightAdjustment]
				   ,[HairSystemOrderSpecialInstructionID]
				   ,[HairSystemID]
				   ,[HairSystemMatrixColorID]
				   ,[HairSystemDesignTemplateID]
				   ,[HairSystemRecessionID]
				   ,[HairSystemDensityID]
				   ,[HairSystemFrontalDensityID]
				   ,[HairSystemHairLengthID]
				   ,[HairSystemFrontalDesignID]
				   ,[HairSystemCurlID]
				   ,[HairSystemStyleID]
				   ,[ColorHairSystemHairMaterialID]
				   ,[ColorFrontHairSystemHairColorID]
				   ,[ColorTempleHairSystemHairColorID]
				   ,[ColorTopHairSystemHairColorID]
				   ,[ColorSidesHairSystemHairColorID]
				   ,[ColorCrownHairSystemHairColorID]
				   ,[ColorBackHairSystemHairColorID]
				   ,[Highlight1HairSystemHairMaterialID]
				   ,[Highlight1HairSystemHighlightID]
				   ,[Highlight1FrontHairSystemHairColorID]
				   ,[Highlight1TempleHairSystemHairColorID]
				   ,[Highlight1TopHairSystemHairColorID]
				   ,[Highlight1SidesHairSystemHairColorID]
				   ,[Highlight1CrownHairSystemHairColorID]
				   ,[Highlight1BackHairSystemHairColorID]
				   ,[Highlight1FrontHairSystemColorPercentageID]
				   ,[Highlight1TempleHairSystemColorPercentageID]
				   ,[Highlight1TopHairSystemColorPercentageID]
				   ,[Highlight1SidesHairSystemColorPercentageID]
				   ,[Highlight1CrownHairSystemColorPercentageID]
				   ,[Highlight1BackHairSystemColorPercentageID]
				   ,[Highlight2HairSystemHairMaterialID]
				   ,[Highlight2HairSystemHighlightID]
				   ,[Highlight2FrontHairSystemHairColorID]
				   ,[Highlight2TempleHairSystemHairColorID]
				   ,[Highlight2TopHairSystemHairColorID]
				   ,[Highlight2SidesHairSystemHairColorID]
				   ,[Highlight2CrownHairSystemHairColorID]
				   ,[Highlight2BackHairSystemHairColorID]
				   ,[Highlight2FrontHairSystemColorPercentageID]
				   ,[Highlight2TempleHairSystemColorPercentageID]
				   ,[Highlight2TopHairSystemColorPercentageID]
				   ,[Highlight2SidesHairSystemColorPercentageID]
				   ,[Highlight2CrownHairSystemColorPercentageID]
				   ,[Highlight2BackHairSystemColorPercentageID]
				   ,[GreyHairSystemHairMaterialID]
				   ,[GreyFrontHairSystemColorPercentageID]
				   ,[GreyTempleHairSystemColorPercentageID]
				   ,[GreyTopHairSystemColorPercentageID]
				   ,[GreySidesHairSystemColorPercentageID]
				   ,[GreyCrownHairSystemColorPercentageID]
				   ,[GreyBackHairSystemColorPercentageID]
				   ,[CostContract]
				   ,[CostActual]
				   ,[CenterPrice]
				   ,[HairSystemVendorContractPricingID]
				   ,[CenterUseFromBridgeDistance]
				   ,[CenterUseIsPermFlag]
				   ,[HairSystemRepairReasonID]
				   ,[HairSystemRedoReasonID]
				   ,[FactoryNote]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemCenterContractPricingID]
				   ,[ManualVendorID]
				   ,[OrderedByEmployeeGUID]
				   ,[HairSystemHoldReasonID]
				   ,[HairSystemFactoryNoteID]
				   ,[HairSystemFrontalLaceLengthID]
				   ,[HairSystemLocationID]
				   ,[IsOnHoldForReviewFlag]
				   ,[IsSampleOrderFlag]
				   ,[RequestForCreditAcceptedDate]
				   ,[RequestForCreditDeclinedDate]
				   ,[AllocationDate]
				   ,[ChargeDecisionID]
				   ,[ReceivedCorpDate]
				   ,[ShippedFromCorpDate]
				   ,[SubFactoryCode]
				   ,[PodCode]
				   ,[IsBleachOrderFlag]
				   ,[CostFactoryShipped]
				   ,[FactoryShippedHairSystemVendorContractPricingID]
				   ,[IsFashionHairlineHighlightsFlag]
				   ,[VendorHairSystemOrderNumber])
			 VALUES
				   (@HairSystemOrderGUID
				   ,@HWCenterID
				   ,@HWCenterID
				   ,@HairSystemOrderStatusID_CENT
				   ,@ClientGUID
				   ,@ClientMembershipGUID
				   ,@ClientGUID --<OriginalClientGUID, uniqueidentifier,>
				   ,@ClientMembershipGUID --<OriginalClientMembershipGUID, uniqueidentifier,>
				   ,GETUTCDATE() --<HairSystemOrderDate, datetime,>
				   ,@NextHairSystemOrderNumber --<HairSystemOrderNumber, nvarchar(50),>
				   ,@MeasurementsByEmployeeGUID --<MeasurementEmployeeGUID, uniqueidentifier,>
				   ,GETUTCDATE() --<DueDate, datetime,>
				   ,GETUTCDATE() --<TemplateReceivedDate, datetime,>
				   ,NULL --<AppliedDate, datetime,>
				   ,0 --<IsRepairOrderFlag, bit,>
				   ,0 --<IsRedoOrderFlag, bit,>
				   ,0 --<IsRushOrderFlag, bit,>
				   ,0 --<IsStockInventoryFlag, bit,>
				   ,0 --<IsOnCenterHoldFlag, bit,>
				   ,NULL --<OriginalHairSystemOrderGUID, uniqueidentifier,>
				   ,NULL --<TemplateWidth, decimal(10,4),>
				   ,NULL --<TemplateWidthAdjustment, decimal(10,4),>
				   ,NULL --<TemplateHeight, decimal(10,4),>
				   ,NULL --<TemplateHeightAdjustment, decimal(10,4),>
				   ,NULL --<HairSystemOrderSpecialInstructionID, int,>
				   ,@HairSystemID --<HairSystemID, int,>
				   ,NULL --<HairSystemMatrixColorID, int,>
				   ,NULL --<HairSystemDesignTemplateID, int,>
				   ,NULL --<HairSystemRecessionID, int,>
				   ,NULL --<HairSystemDensityID, int,>
				   ,NULL --<HairSystemFrontalDensityID, int,>
				   ,@HairSystemHairLengthID --<HairSystemHairLengthID, int,>
				   ,NULL --<HairSystemFrontalDesignID, int,>
				   ,@HairSystemCurlID --<HairSystemCurlID, int,>
				   ,@HairSystemStyleID_FreeStyle --<HairSystemStyleID, int,>
				   ,@HairSystemHairMaterialID_Human --<ColorHairSystemHairMaterialID, int,>
				   ,@HairSystemHairColorID --<ColorFrontHairSystemHairColorID, int,>
				   ,@HairSystemHairColorID --<ColorTempleHairSystemHairColorID, int,>
				   ,@HairSystemHairColorID --<ColorTopHairSystemHairColorID, int,>
				   ,@HairSystemHairColorID --<ColorSidesHairSystemHairColorID, int,>
				   ,@HairSystemHairColorID --<ColorCrownHairSystemHairColorID, int,>
				   ,@HairSystemHairColorID --<ColorBackHairSystemHairColorID, int,>
				   ,NULL --<Highlight1HairSystemHairMaterialID, int,>
				   ,NULL --<Highlight1HairSystemHighlightID, int,>
				   ,NULL --<Highlight1FrontHairSystemHairColorID, int,>
				   ,NULL --<Highlight1TempleHairSystemHairColorID, int,>
				   ,NULL --<Highlight1TopHairSystemHairColorID, int,>
				   ,NULL --<Highlight1SidesHairSystemHairColorID, int,>
				   ,NULL --<Highlight1CrownHairSystemHairColorID, int,>
				   ,NULL --<Highlight1BackHairSystemHairColorID, int,>
				   ,NULL --<Highlight1FrontHairSystemColorPercentageID, int,>
				   ,NULL --<Highlight1TempleHairSystemColorPercentageID, int,>
				   ,NULL --<Highlight1TopHairSystemColorPercentageID, int,>
				   ,NULL --<Highlight1SidesHairSystemColorPercentageID, int,>
				   ,NULL --<Highlight1CrownHairSystemColorPercentageID, int,>
				   ,NULL --<Highlight1BackHairSystemColorPercentageID, int,>
				   ,NULL --<Highlight2HairSystemHairMaterialID, int,>
				   ,NULL --<Highlight2HairSystemHighlightID, int,>
				   ,NULL --<Highlight2FrontHairSystemHairColorID, int,>
				   ,NULL --<Highlight2TempleHairSystemHairColorID, int,>
				   ,NULL --<Highlight2TopHairSystemHairColorID, int,>
				   ,NULL --<Highlight2SidesHairSystemHairColorID, int,>
				   ,NULL --<Highlight2CrownHairSystemHairColorID, int,>
				   ,NULL --<Highlight2BackHairSystemHairColorID, int,>
				   ,NULL --<Highlight2FrontHairSystemColorPercentageID, int,>
				   ,NULL --<Highlight2TempleHairSystemColorPercentageID, int,>
				   ,NULL --<Highlight2TopHairSystemColorPercentageID, int,>
				   ,NULL --<Highlight2SidesHairSystemColorPercentageID, int,>
				   ,NULL --<Highlight2CrownHairSystemColorPercentageID, int,>
				   ,NULL --<Highlight2BackHairSystemColorPercentageID, int,>
				   ,NULL --<GreyHairSystemHairMaterialID, int,>
				   ,NULL --<GreyFrontHairSystemColorPercentageID, int,>
				   ,NULL --<GreyTempleHairSystemColorPercentageID, int,>
				   ,NULL --<GreyTopHairSystemColorPercentageID, int,>
				   ,NULL --<GreySidesHairSystemColorPercentageID, int,>
				   ,NULL --<GreyCrownHairSystemColorPercentageID, int,>
				   ,NULL --<GreyBackHairSystemColorPercentageID, int,>
				   ,0 --<CostContract, money,>
				   ,0 --<CostActual, money,>
				   ,0 --<CenterPrice, money,>
				   ,NULL --<HairSystemVendorContractPricingID, int,>
				   ,NULL --<CenterUseFromBridgeDistance, decimal(10,4),>
				   ,0 --<CenterUseIsPermFlag, bit,>
				   ,NULL --<HairSystemRepairReasonID, int,>
				   ,NULL --<HairSystemRedoReasonID, int,>
				   ,NULL --<FactoryNote, ntext,>
				   ,GETUTCDATE() --<CreateDate, datetime,>
				   ,@User --<CreateUser, nvarchar(25),>
				   ,GETUTCDATE() --<LastUpdate, datetime,>
				   ,@User --<LastUpdateUser, nvarchar(25),>
				   ,NULL --<HairSystemCenterContractPricingID, int,>
				   ,NULL --<ManualVendorID, int,>
				   ,@MeasurementsByEmployeeGUID --<OrderedByEmployeeGUID, uniqueidentifier,>
				   ,NULL --<HairSystemHoldReasonID, int,>
				   ,NULL --<HairSystemFactoryNoteID, int,>
				   ,NULL --<HairSystemFrontalLaceLengthID, int,>
				   ,NULL --<HairSystemLocationID, int,>
				   ,0 --<IsOnHoldForReviewFlag, bit,>
				   ,0 --<IsSampleOrderFlag, bit,>
				   ,NULL --<RequestForCreditAcceptedDate, datetime,>
				   ,NULL --<RequestForCreditDeclinedDate, datetime,>
				   ,GETUTCDATE() --<AllocationDate, datetime,>
				   ,NULL --<ChargeDecisionID, int,>
				   ,GETUTCDATE() --<ReceivedCorpDate, datetime,>
				   ,GETUTCDATE() --<ShippedFromCorpDate, datetime,>
				   ,NULL --<SubFactoryCode, nvarchar(25),>
				   ,NULL --<PodCode, nvarchar(25),>
				   ,0 --<IsBleachOrderFlag, bit,>
				   ,0 --<CostFactoryShipped, money,>
				   ,NULL --<FactoryShippedHairSystemVendorContractPricingID, int,>
				   ,0 --<IsFashionHairlineHighlightsFlag, bit,>
				   ,@VendorHairOrderID) --<VendorHairSystemOrderNumber, nvarchar(50),>

			--Insert datHairSystemOrderTransaction
			INSERT INTO [dbo].[datHairSystemOrderTransaction]
				   ([HairSystemOrderTransactionGUID]
				   ,[CenterID]
				   ,[ClientHomeCenterID]
				   ,[ClientGUID]
				   ,[ClientMembershipGUID]
				   ,[HairSystemOrderTransactionDate]
				   ,[HairSystemOrderProcessID]
				   ,[HairSystemOrderGUID]
				   ,[PreviousCenterID]
				   ,[PreviousClientMembershipGUID]
				   ,[PreviousHairSystemOrderStatusID]
				   ,[NewHairSystemOrderStatusID]
				   ,[InventoryShipmentDetailGUID]
				   ,[InventoryTransferRequestGUID]
				   ,[PurchaseOrderDetailGUID]
				   ,[CostContract]
				   ,[PreviousCostContract]
				   ,[CostActual]
				   ,[PreviousCostActual]
				   ,[CenterPrice]
				   ,[PreviousCenterPrice]
				   ,[EmployeeGUID]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[CostFactoryShipped]
				   ,[PreviousCostFactoryShipped]
				   ,[SalesOrderDetailGuid]
				   ,[HairSystemOrderPriorityReasonID])
			 VALUES
				   (NEWID()
				   ,@HWCenterID --<CenterID, int,>
				   ,@HWCenterID --<ClientHomeCenterID, int,>
				   ,@ClientGUID --<ClientGUID, uniqueidentifier,>
				   ,@ClientMembershipGUID --<ClientMembershipGUID, uniqueidentifier,>
				   ,GETUTCDATE() --<HairSystemOrderTransactionDate, datetime,>
				   ,@HairSystemOrderProcessID_ManualAdjustment --<HairSystemOrderProcessID, int,>
				   ,@HairSystemOrderGUID --<HairSystemOrderGUID, uniqueidentifier,>
				   ,@HWCenterID --<PreviousCenterID, int,>
				   ,@ClientMembershipGUID --<PreviousClientMembershipGUID, uniqueidentifier,>
				   ,@HairSystemOrderStatusID_CENT --<PreviousHairSystemOrderStatusID, int,>
				   ,@HairSystemOrderStatusID_CENT --<NewHairSystemOrderStatusID, int,>
				   ,NULL --<InventoryShipmentDetailGUID, uniqueidentifier,>
				   ,NULL --<InventoryTransferRequestGUID, uniqueidentifier,>
				   ,NULL --<PurchaseOrderDetailGUID, uniqueidentifier,>
				   ,0 --<CostContract, money,>
				   ,0 --<PreviousCostContract, money,>
				   ,0 --<CostActual, money,>
				   ,0 --<PreviousCostActual, money,>
				   ,0 --<CenterPrice, money,>
				   ,0 --<PreviousCenterPrice, money,>
				   ,@MeasurementsByEmployeeGUID --<EmployeeGUID, uniqueidentifier,>
				   ,GETUTCDATE() --<CreateDate, datetime,>
				   ,@User --<CreateUser, nvarchar(25),>
				   ,GETUTCDATE() --<LastUpdate, datetime,>
				   ,@User --<LastUpdateUser, nvarchar(25),>
				   ,0 --<CostFactoryShipped, money,>
				   ,0 --<PreviousCostFactoryShipped, money,>
				   ,NULL --<SalesOrderDetailGuid, uniqueidentifier,>
				   ,NULL) --<HairSystemOrderPriorityReasonID, int,>

			--Update temp_HansWiemannHairOrders
			UPDATE [dbo].[temp_HansWiemannHairOrders]
			SET ClientGUID = @ClientGUID
				,ClientMembershipGUID = @ClientMembershipGUID
				,HairSystemOrderGUID = @HairSystemOrderGUID
				,DateProcessed = GETUTCDATE()
			WHERE ClientKorvueID = @ClientKorvueID
				and VendorHairOrderID = @VendorHairOrderID

		COMMIT TRANSACTION

		END

		FETCH NEXT FROM CUR INTO @ClientKorvueID, @VendorHairOrderID, @ClientGUID, @ClientMembershipGUID, @HairSystemID, @HairSystemHairLengthID, @HairSystemCurlID, @HairSystemHairColorID
	END

	CLOSE CUR
	DEALLOCATE CUR

  END TRY
  BEGIN CATCH
	ROLLBACK TRANSACTION

	CLOSE CUR
	DEALLOCATE CUR

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
