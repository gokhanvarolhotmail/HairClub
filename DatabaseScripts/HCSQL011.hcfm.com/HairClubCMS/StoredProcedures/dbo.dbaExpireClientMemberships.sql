/* CreateDate: 02/18/2013 06:55:56.223 , ModifyDate: 01/19/2020 21:51:11.567 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				dbaExpireClientMemberships

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Joe Enders

IMPLEMENTOR: 			Joe Enders

DATE IMPLEMENTED: 		1/15/2013

LAST REVISION DATE: 	1/15/2013


--------------------------------------------------------------------------------------------------------
NOTES: 	Expires client memberships whose membership period is no longer valid.
	* 05/30/2013 MVT - Modified so that "Membership" tender type is used for Membership Order
	* 09/16/2016 SAL - Modified to move HSOs from CENT to PRIORITY Status and generate HSO Transaction
	* 03/14/2019 SAL - Modified to expire Add-Ons for the Client Memberships being expired. (TFS #12034)
					   Modified to set Quantity to 1 (was being set to 0) for Membership Expiration
						sales order detail (TFS #12138)
	* 12/13/2019 SAL - Modified to move HSOs from QANEEDED to PRIORITY Status and generate HSO Transaction
						(TFS #13588)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

dbaExpireClientMemberships 0

***********************************************************************/

CREATE PROCEDURE [dbo].[dbaExpireClientMemberships]
	  @DateInclusive bit -- 0 means do not include the current date. If script runs after midnight, we do not want to include todays date since membership would expire at the end of the business day.
AS
BEGIN
	SET NOCOUNT ON

	-- wrap the entire stored procedure in a transaction
	BEGIN TRANSACTION

	--------------------------------------------------------------------
	-- SECTION 1: Declare constant values used within this stored proc,
	--               also declare any other variables that will be used
	--               within the stored proc
	--------------------------------------------------------------------
	DECLARE @Run_Start_Date date  -- Get compare date that we are using to determine expiration. Get date right away just in case job is run close to midnight.
	Set @Run_Start_Date = DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) -- not using utc since we are using the date the job runs on the host server.

	--DECLARE @Active_ClientMembershipStatusId int
	--SELECT @Active_ClientMembershipStatusId = ClientMembershipSTatusid from lkpClientMembershipStatus where ClientMembershipStatusDescriptionShort = 'A'

	DECLARE @Expired_ClientMembershipStatusId int
	SELECT @Expired_ClientMembershipStatusId = ClientMembershipStatusid from lkpClientMembershipStatus where ClientMembershipStatusDescriptionShort = 'E'

	DECLARE @Expired_ClientMembershipAddOnStatusId int
	SELECT @Expired_ClientMembershipAddOnStatusId = ClientMembershipAddOnStatusId from lkpClientMembershipAddOnStatus where ClientMembershipAddOnStatusDescriptionShort = 'E'

	DECLARE @MO_SalesOrderTypeID int
	SELECT @MO_SalesOrderTypeID = SalesOrderTypeID from lkpSalesOrderType where SalesOrderTypeDescriptionShort = 'MO'

	DECLARE @SalesCodeID int
	SELECT @SalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'EXPIRE' --Expire Membership

	DECLARE @ExpireAddOnSalesCodeID int
	SELECT @ExpireAddOnSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'EXPIREAO' --Expire Add-On

	DECLARE @TenderTypeID int
	SELECT @TenderTypeID = TenderTypeID FROM lkpTenderType WHERE TenderTypeDescriptionShort = 'Membership'

	DECLARE @TempInvoiceTable table
				(
					InvoiceNumber nvarchar(50)
				)
	DECLARE @InvoiceNumber nvarchar(50)

	DECLARE @Memberships_Cursor CURSOR
	DECLARE @ClientMembershipGUID uniqueidentifier
	DECLARE @ClientGUID uniqueidentifier
	DECLARE @CenterID int

	DECLARE @SalesOrderGUID uniqueidentifier

	DECLARE @CENT_HairSystemOrderStatusID int
	SELECT @CENT_HairSystemOrderStatusID = HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'CENT'

	DECLARE @QANEEDED_HairSystemOrderStatusID int
	SELECT @QANEEDED_HairSystemOrderStatusID = HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'QANEEDED'

	DECLARE @PRIORITY_HairSystemOrderStatusID int
	SELECT @PRIORITY_HairSystemOrderStatusID = HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'PRIORITY'

	DECLARE @AutoAdj_HairSystemOrderProcessID int
	SELECT @AutoAdj_HairSystemOrderProcessID = HairSystemOrderProcessID FROM lkpHairSystemOrderProcess WHERE HairSystemOrderProcessDescriptionShort = 'AutoAdj'

	DECLARE @Expired_HairSystemOrderPriorityReasonID int
	SELECT @Expired_HairSystemOrderPriorityReasonID = HairSystemOrderPriorityReasonID FROM lkpHairSystemOrderPriorityReason WHERE HairSystemOrderPriorityReasonDescriptionShort = 'EXPIRED'

	DECLARE @HairSystemOrder_Cursor CURSOR
	DECLARE @HairSystemOrderGUID uniqueidentifier

	DECLARE @CMSUser nvarchar(25)
	SET @CMSUser = 'cmsMemExp'
	--------------------------------------------------------------------
	-- SECTION 2: Fill curser with clientmemberships that are past expiration but still in the active status.
	--------------------------------------------------------------------

	SET @Memberships_Cursor = CURSOR FAST_FORWARD FOR
		SELECT ClientMembershipGUID,
			   CenterID,
			   ClientGUID
		FROM datClientMembership cm with (nolock)
			Inner Join lkpClientMembershipStatus cms with (nolock) ON cms.ClientMembershipStatusID = cm.ClientMembershipStatusID
			Inner Join cfgConfigurationMembership cfm with (nolock) ON cfm.MembershipID = cm.MembershipID
		WHERE cfm.IsAutoExpire = 1 and cms.IsActiveMembershipFlag = 1 AND
				(
					cm.EndDate IS NULL OR -- should not happen but just in case.
					(@DateInclusive = 1 and datediff(day, EndDate, getdate()) >= cfm.NumDaysExpirationBuffer) or -- include today's date.
					(@DateInclusive = 0 and datediff(day, EndDate, getdate()) > cfm.NumDaysExpirationBuffer) -- exclude today's date.
				)

		OPEN @Memberships_Cursor
		FETCH NEXT FROM @Memberships_Cursor
		INTO @ClientMembershipGUID, @CenterID, @ClientGUID

		--------------------------------------------------------------------
		-- SECTION 3: Set client membership records to expired.
		--			  Generate manufacturing order transactions to track change.
		--			  Move HSOs in CENT Status to PRIORITY Status.
		--			  Generate HSO Transaction to track change.
		--------------------------------------------------------------------
		WHILE @@FETCH_STATUS = 0
		  BEGIN

			--Create an invoice #
			INSERT INTO @TempInvoiceTable
				EXEC ('mtnGetInvoiceNumber ' + @CenterID)

			SELECT TOP 1 @InvoiceNumber = InvoiceNumber
			FROM @TempInvoiceTable

			DELETE FROM @TempInvoiceTable

			set @SalesOrderGUID = newid()

			-- Generate MO
			INSERT INTO datSalesOrder
				   (SalesOrderGUID,
					CenterID,
					ClientHomeCenterID,
					SalesOrderTypeID,
					ClientGUID,
					ClientMembershipGUID,
					OrderDate,
					InvoiceNumber,
					IsVoidedFlag,
					IsClosedFlag,
					IsWrittenOffFlag,
					IsRefundedFlag,
					CreateDate,
					CreateUser,
					LastUpdate,
					LastUpdateUser,
					IsSurgeryReversalFlag,
					IsGuaranteeFlag)
			VALUES
				   (@SalesOrderGUID,
					@CenterID,
					@CenterID,
					@MO_SalesOrderTypeID,
					@ClientGUID,
					@ClientMembershipGUID,
					GETUTCDATE(),
					@InvoiceNumber,
					0,
					1,
					0,
					0,
					GETUTCDATE(),
					@CMSUser,
					GETUTCDATE(),
					@CMSUser,
					0,
					0)

			-- Generate line item for membership.
			INSERT INTO [dbo].[datSalesOrderDetail]
				   (SalesOrderDetailGUID,
					SalesOrderGUID,
					SalesCodeID,
					Quantity,
					Price,
					Discount,
					Tax1,
					Tax2,
					TaxRate1,
					TaxRate2,
					IsRefundedFlag,
					RefundedTotalQuantity,
					RefundedTotalPrice,
					CreateDate,
					CreateUser,
					LastUpdate,
					LastUpdateUser,
					EntrySortOrder,
					BenefitTrackingEnabledFlag)
			 VALUES
				   (newid(),
					@SalesOrderGUID,
					@SalesCodeID,
					1,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					GETUTCDATE(),
					@CMSUser,
					GETUTCDATE(),
					@CMSUser,
					1,
					1)

			-- Generate line items for Add-Ons
			INSERT INTO [dbo].[datSalesOrderDetail]
				   (SalesOrderDetailGUID,
					SalesOrderGUID,
					SalesCodeID,
					Quantity,
					Price,
					Discount,
					Tax1,
					Tax2,
					TaxRate1,
					TaxRate2,
					IsRefundedFlag,
					RefundedTotalQuantity,
					RefundedTotalPrice,
					CreateDate,
					CreateUser,
					LastUpdate,
					LastUpdateUser,
					EntrySortOrder,
					BenefitTrackingEnabledFlag,
					ClientMembershipAddOnID)
			SELECT	newid(),
					@SalesOrderGUID,
					@ExpireAddOnSalesCodeID,
					1,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					0,
					GETUTCDATE(),
					@CMSUser,
					GETUTCDATE(),
					@CMSUser,
					(addOn.rn + 1) as EntrySortOrder,
					1,
					addOn.ClientMembershipAddOnID
			FROM (SELECT cma.ClientMembershipAddOnID, ROW_NUMBER() OVER (PARTITION BY ClientMembershipGUID ORDER BY ClientMembershipAddOnID) AS rn
					FROM datClientMembershipAddOn cma
						inner join lkpClientMembershipAddOnStatus cmaos on cma.ClientMembershipAddOnStatusID = cmaos.ClientMembershipAddOnStatusID
					WHERE cma.ClientMembershipGUID = @ClientMembershipGUID
						and cmaos.ClientMembershipAddOnStatusDescriptionShort = 'Active') AS addOn

			-- Add empty tender record.
			INSERT INTO [dbo].[datSalesOrderTender]
				   (SalesOrderTenderGUID,
					SalesOrderGUID,
					TenderTypeID,
					Amount,
					CreateDate,
					CreateUser,
					LastUpdate,
					LastUpdateUser,
					RefundAmount,
					CashCollected,
					EntrySortOrder)
			 VALUES
				   (newid(),
					@SalesOrderGUID,
					@TenderTypeID,
					0,
					GETUTCDATE(),
					@CMSUser,
					GETUTCDATE(),
					@CMSUser,
					0,
					0,
					1)


			-- Expire Membership
			UPDATE datClientMembership
			SET ClientMembershipStatusId = @Expired_ClientMembershipStatusId
				,IsActiveFlag = 0
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @CMSUser
			WHERE ClientMembershipGUID = @ClientMembershipGUID

			-- Expire Add-Ons
			UPDATE cma
			SET ClientMembershipAddOnStatusID = @Expired_ClientMembershipAddOnStatusID
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @CMSUser
			FROM datClientMembershipAddOn cma
				inner join lkpClientMembershipAddOnStatus cmaos on cma.ClientMembershipAddOnStatusID = cmaos.ClientMembershipAddOnStatusID
			WHERE cma.ClientMembershipGUID = @ClientMembershipGUID
				and cmaos.ClientMembershipAddOnStatusDescriptionShort = 'Active'


			-- Move HSOs in CENT or QANEEDED Status to PRIORITY Status.
			SET @HairSystemOrder_Cursor = CURSOR FAST_FORWARD FOR
				SELECT HairSystemOrderGUID
				FROM datHairSystemOrder
				WHERE ClientMembershipGUID = @ClientMembershipGUID
					and HairSystemOrderStatusID in (@CENT_HairSystemOrderStatusID, @QANEEDED_HairSystemOrderStatusID)

				OPEN @HairSystemOrder_Cursor
				FETCH NEXT FROM @HairSystemOrder_Cursor INTO @HairSystemOrderGUID

				WHILE @@FETCH_STATUS = 0
				BEGIN

					-- Generate Hair System Order Transaction to track change.
					INSERT INTO [dbo].[datHairSystemOrderTransaction]
							(HairSystemOrderTransactionGUID
							,CenterID
							,ClientHomeCenterID
							,ClientGUID
							,ClientMembershipGUID
							,HairSystemOrderTransactionDate
							,HairSystemOrderProcessID
							,HairSystemOrderGUID
							,PreviousCenterID
							,PreviousClientMembershipGUID
							,PreviousHairSystemOrderStatusID
							,NewHairSystemOrderStatusID
							,InventoryShipmentDetailGUID
							,InventoryTransferRequestGUID
							,PurchaseOrderDetailGUID
							,CostContract
							,PreviousCostContract
							,CostActual
							,PreviousCostActual
							,CenterPrice
							,PreviousCenterPrice
							,EmployeeGUID
							,CreateDate
							,CreateUser
							,LastUpdate
							,LastUpdateUser
							,CostFactoryShipped
							,PreviousCostFactoryShipped
							,SalesOrderDetailGuid
							,HairSystemOrderPriorityReasonID)
					SELECT	NEWID()
							,CenterID
							,ClientHomeCenterID
							,ClientGUID
							,ClientMembershipGUID
							,GETUTCDATE()
							,@AutoAdj_HairSystemOrderProcessID
							,HairSystemOrderGUID
							,CenterID
							,OriginalClientMembershipGUID
							,HairSystemOrderStatusID
							,@PRIORITY_HairSystemOrderStatusID
							,NULL
							,NULL
							,NULL
							,CostContract
							,CostContract
							,CostActual
							,CostActual
							,CenterPrice
							,CenterPrice
							,MeasurementEmployeeGUID
							,GETUTCDATE()
							,@CMSUser
							,GETUTCDATE()
							,@CMSUser
							,CostFactoryShipped
							,CostFactoryShipped
							,NULL
							,@Expired_HairSystemOrderPriorityReasonID
					FROM datHairSystemOrder
					WHERE HairSystemOrderGUID = @HairSystemOrderGUID

					-- Move Hair Order to PRIORITY Status
					UPDATE datHairSystemOrder
					SET HairSystemOrderStatusID = @PRIORITY_HairSystemOrderStatusID
						,IsStockInventoryFlag = 1
						,LastUpdate = GETUTCDATE()
						,LastUpdateUser = @CMSUser
					WHERE HairSystemOrderGUID = @HairSystemOrderGUID

					-- Grab next record.
					FETCH NEXT FROM @HairSystemOrder_Cursor INTO @HairSystemOrderGUID
				END

				-- close & remove the reference to the cursor object
 				CLOSE @HairSystemOrder_Cursor
				DEALLOCATE @HairSystemOrder_Cursor

			-- Grab next record.
			FETCH NEXT FROM @Memberships_Cursor
			INTO @ClientMembershipGUID, @CenterID, @ClientGUID
		  END

	-- close & remove the reference to the cursor object
 	CLOSE @Memberships_Cursor
	DEALLOCATE @Memberships_Cursor

 	-- complete the transaction and save
	COMMIT TRANSACTION

END
GO
