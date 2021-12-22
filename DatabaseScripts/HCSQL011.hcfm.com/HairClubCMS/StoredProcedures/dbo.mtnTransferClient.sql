/* CreateDate: 04/14/2014 08:01:47.273 , ModifyDate: 04/12/2020 22:03:51.267 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************************************************
PROCEDURE:				mtnTransferClient
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Mike Tovbin
IMPLEMENTOR: 			Mike Tovbin
DATE IMPLEMENTED: 		02/24/2014
LAST REVISION DATE: 	11/19/2019
----------------------------------------------------------------------------------------------------------------------------------------------
NOTES: 	Transfer client which involves moving Hair Orders and Revenue Overage.  New Client Memberships
			are created at the new Center.
		* 06/06/14 SAL - Prevent Deferred Revenue Transactions from being written for New Business clients
		* 08/04/14 SAL - Add step #17 - If there are future appointments for the client at the new center
							we need to update them so they are not considered visiting client appointments
		* 01/21/15 SAL - Moved the following Client level appointment and visiting notifications udpates to
							before the client membership cursor:
							- 'soft delete' of future appointments for the client (previously step #14)
							- delete of visiting notifications (previously step #17)
							- update HomeCenterID of open future appointments to the new center
						 Added the following membership specific appointment updates to inside the client
							membership cursor (TFS #3930):
							- update of open future appointments to new client membership (under step #6)

		* 02/16/15 MVT - (TFS #4230) Added logic to not add Hair Orders in 'CENT' status to shipments. The
						Orders will still need to be updated with new Client Home Center and new Client
						Membership.
		* 02/25/15 MVT - Modified the transfer process to clear out Client Number Temp when Client Transfers (TFS #4340)
		* 03/02/15 MVT		Updated proc for Xtrands Business Segment
		* 06/11/15 SAL - Updated join under "-- Current XTR Membership" to join the c.CurrentXtrandsClientMembershipGUID field
							and not the c.CurrentExtremeTherapyClientMembershipGUID field like it was. I'm sure this was the
							result of a copy and paste from the Ext select above it.  This was resulting in a new client membership
							record NOT being created for the new center and the old membership not getting updated to a status of
							Transferred.
		* 01/26/15 SAL - Modified the transfer process to include deleting the client's credit card on file.
		* 03/15/19 SAL - Modified to include handling Client Membership Add-Ons when a client is transfered. (TFS #12050)
		* 03/20/19 SAL - Modified to update all client memberships' future appointments to the new memberships. (TFS #12152)
		* 03/26/19 SAL - Add .Price and .Term when inserting into datClientMembershipAddOn (TFS #12162)
		* 11/19/19 JLM - Transfer client hair orders in 'QA Needed' status the same as 'Cent' status. (TFS #13459)
		* 03/20/20 SAL - Modified to update all client membership's future waiting lists to the new memberships. (TFS #14205)
----------------------------------------------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [mtnTransferClient] '5A7F8381-A218-4571-A3BF-C66680E1F129', 30, '54905628-47F8-40A1-B7D5-CA828DF01392', null, 201, 1, 'MT Test'
**********************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[mtnTransferClient]
	@ClientMembershipGUID uniqueidentifier,
	@MembershipOrderReasonID int,
	@ConsultantGUID uniqueidentifier,
	@StylistGUID uniqueidentifier,
	@NewCenterID int,
	@CancelFutureAppointments bit,
	@User nvarchar(25)

AS
BEGIN

SET NOCOUNT ON

	DECLARE @ClientMemberships TABLE
	(
		ID int IDENTITY(1,1) PRIMARY KEY,
		ClientMembershipGUID uniqueidentifier NOT NULL,
		ClientMembershipStatusID int NOT NULL,
		ClientMembershipStatusDescriptionShort varchar(10) NOT NULL,
		BusinessSegmentDescriptionShort varchar(10) NOT NULL,
		BeginDate datetime NULL,
		EndDate datetime NULL,
		IsDefault bit NOT NULL,
		IsDeferredRevenueMembership bit NOT NULL
	)

	DECLARE @HairOrders TABLE
	(
		ID int IDENTITY(1,1) PRIMARY KEY,
		HairSystemOrderGUID uniqueidentifier NOT NULL,
		PreviousHairSystemOrderStatusID int NULL,
		PreviousCenterID int NULL,
		CurrentClientMembershipGUID uniqueidentifier NOT NULL,
		NewClientMembershipGUID uniqueidentifier NOT NULL,
		ClientHomeCenterID int NOT NULL,
		CenterID int NOT NULL
	)

	DECLARE @Today date
	DECLARE @SalesOrderGUID uniqueidentifier
	DECLARE @TempInvoiceTable table
			(
				InvoiceNumber nvarchar(50)
			)
	DECLARE @InvoiceNumber nvarchar(50)
	DECLARE @MOSalesOrderTypeID int
	DECLARE @SOSalesOrderTypeID int
	DECLARE @TenderTypeID int
	DECLARE @SalesCodeID int
	DECLARE @SalesCodeID_TransferOutAddOn int
	DECLARE @SalesCodeID_TransferInAddOn int
	DECLARE @ActiveClientMembershipStatusID int
	DECLARE @RevenueOverage money
	DECLARE @MembershipID int
	DECLARE @CurrentCenterID int
	DECLARE @ClientGUID uniqueidentifier
	DECLARE @ClientIdentifier int
	DECLARE @ClientFullName nvarchar(100)
	DECLARE @ClientMembershipStatusID int
	DECLARE @ClientMembershipAddOnStatusID_Transferred int
	DECLARE @ClientMembershipAddOnStatusID_Active int
	DECLARE @ClientMembershipNumber nvarchar(50)
	--DECLARE @BusinessSegment nvarchar(10)
	DECLARE @NewClientMembershipGUID uniqueidentifier
	DECLARE @AutoAdjHairSystemOrderProcessID int

	DECLARE @CurrentCenterDescription nvarchar(100)
	DECLARE @NewCenterDescription nvarchar(100)
	DECLARE @DBName nvarchar(30)
	DECLARE @DeferredRevSalesCodeID int
	DECLARE @IsDeferredRevenueAllowed bit
	DECLARE @TempDeferredRevTable table
			(
				DeferredRevenue money
			)

	DECLARE @InventoryShipmentGUID uniqueidentifier = null
	DECLARE @CentnerToCenterInventoryShipmentTypeID int
	DECLARE @OpenInventoryShipmentStatusID int
	DECLARE @ShipInventoryShipmentDetailStatusID int
	DECLARE @XferInventoryShipmentReasonID int

	DECLARE @IsTransferToCorporateHQ bit
	DECLARE @XsferAcceptedHairSystemOrderStatusID int
	DECLARE @CentHairSystemOrderStatusID int
	DECLARE @QANeededHairSystemOrderStatusID INT

	SELECT @IsTransferToCorporateHQ = IsCorporateHeadquartersFlag FROM cfgCenter WHERE CenterID = @NewCenterID
	SELECT @XsferAcceptedHairSystemOrderStatusID = HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'XferAccept'
	SELECT @CentHairSystemOrderStatusID = HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'Cent'
	SELECT @QANeededHairSystemOrderStatusID = HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'QANEEDED'
	SELECT @CentnerToCenterInventoryShipmentTypeID = InventoryShipmentTypeID FROM lkpInventoryShipmentType WHERE InventoryShipmentTypeDescriptionShort = 'HSCtr2Ctr'
	SELECT @OpenInventoryShipmentStatusID = InventoryShipmentStatusID FROM lkpInventoryShipmentStatus WHERE InventoryShipmentStatusDescriptionShort = 'OPEN'
	SELECT @ShipInventoryShipmentDetailStatusID = InventoryShipmentDetailStatusID FROM lkpInventoryShipmentDetailStatus WHERE InventoryShipmentDetailStatusDescriptionShort = 'SHIP'
	SELECT @XferInventoryShipmentReasonID = InventoryShipmentReasonID FROM lkpInventoryShipmentReason WHERE InventoryShipmentReasonDescriptionShort = 'CLIENTXFER'
	SELECT @ClientMembershipAddOnStatusID_Active = ClientMembershipAddOnStatusID FROM lkpClientMembershipAddOnStatus WHERE ClientMembershipAddOnStatusDescriptionShort = 'Active'
	SELECT @ClientMembershipAddOnStatusID_Transferred = ClientMembershipAddOnStatusID FROM lkpClientMembershipAddOnStatus WHERE ClientMembershipAddOnStatusDescriptionShort = 'Txfr'
	SELECT @SalesCodeID_TransferOutAddOn = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'TXFRAOOUT'
	SELECT @SalesCodeID_TransferInAddOn = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'TXFRAOIN'

	SELECT @DeferredRevSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'CLTXFRREV'

	SELECT @DBName = DB_NAME()

	SELECT @AutoAdjHairSystemOrderProcessID = HairSystemOrderProcessID
	FROM lkpHairSystemOrderProcess WHERE HairSystemOrderProcessDescriptionShort = 'AutoAdj'

	SELECT @Today = DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))

	SELECT @MOSalesOrderTypeID = SalesOrderTypeID
		FROM lkpSalesOrderType WHERE SalesOrderTypeDescriptionShort = 'MO'

	SELECT @SOSalesOrderTypeID = SalesOrderTypeID
		FROM lkpSalesOrderType WHERE SalesOrderTypeDescriptionShort = 'SO'

	SELECT @MembershipID = cm.MembershipID,
			@CurrentCenterID = cm.CenterID,
			@ClientGUID = cm.ClientGUID,
			@ClientIdentifier = c.ClientIdentifier,
			@ClientFullName = c.ClientFullNameCalc,
			@CurrentCenterDescription = cent.CenterDescriptionFullCalc
			--@BusinessSegment = bs.BusinessSegmentDescriptionShort
		FROM datClientMembership cm
			INNER JOIN datClient c ON c.ClientGUID = cm.ClientGUID
			INNER JOIN cfgMembership m on m.MembershipID = cm.MembershipID
			INNER JOIN lkpBusinessSegment bs ON bs.BusinessSegmentID = m.BusinessSegmentID
			INNER JOIN cfgCenter cent ON cent.CenterID = cm.CenterID
	WHERE ClientMembershipGUID = @ClientMembershipGUID

	SELECT @NewCenterDescription = CenterDescriptionFullCalc FROM cfgCenter WHERE CenterID = @NewCenterID

	-- Current BIO Membership
	INSERT INTO @ClientMemberships (
		ClientMembershipGUID, ClientMembershipStatusID, ClientMembershipStatusDescriptionShort,
		BusinessSegmentDescriptionShort, BeginDate, EndDate, IsDefault, IsDeferredRevenueMembership)
	SELECT cm.ClientMembershipGUID,
			cm.ClientMembershipStatusID,
			stat.ClientMembershipStatusDescriptionShort,
			bs.BusinessSegmentDescriptionShort,
			cm.BeginDate,
			cm.EndDate,
			CASE WHEN cm.ClientMembershipGUID = @ClientMembershipGUID THEN 1 ELSE 0 END,
			1 -- always apply Deferred Revenue to BIO
		FROM datClient c
			INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = c.CurrentBioMatrixClientMembershipGUID
			INNER JOIN lkpClientMembershipStatus stat ON stat.ClientMembershipStatusID = cm.ClientMembershipStatusID
			INNER JOIN cfgMembership mem ON cm.MembershipID = mem.MembershipID
			INNER JOIN lkpBusinessSegment bs ON bs.BusinessSegmentID = mem.BusinessSegmentID
	WHERE c.ClientGUID = @ClientGUID

	-- Current EXT Membership
	INSERT INTO @ClientMemberships (
		ClientMembershipGUID, ClientMembershipStatusID, ClientMembershipStatusDescriptionShort,
		BusinessSegmentDescriptionShort, BeginDate, EndDate, IsDefault, IsDeferredRevenueMembership)
	SELECT cm.ClientMembershipGUID,
			cm.ClientMembershipStatusID,
			stat.ClientMembershipStatusDescriptionShort,
			bs.BusinessSegmentDescriptionShort,
			cm.BeginDate,
			cm.EndDate,
			CASE WHEN cm.ClientMembershipGUID = @ClientMembershipGUID THEN 1 ELSE 0 END,
			CASE WHEN c.CurrentBioMatrixClientMembershipGUID IS NULL THEN 1 ELSE 0 END
		FROM datClient c
			INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = c.CurrentExtremeTherapyClientMembershipGUID
			INNER JOIN lkpClientMembershipStatus stat ON stat.ClientMembershipStatusID = cm.ClientMembershipStatusID
			INNER JOIN cfgMembership mem ON cm.MembershipID = mem.MembershipID
			INNER JOIN lkpBusinessSegment bs ON bs.BusinessSegmentID = mem.BusinessSegmentID
	WHERE c.ClientGUID = @ClientGUID

	-- Current XTR Membership
	INSERT INTO @ClientMemberships (
		ClientMembershipGUID, ClientMembershipStatusID, ClientMembershipStatusDescriptionShort,
		BusinessSegmentDescriptionShort, BeginDate, EndDate, IsDefault, IsDeferredRevenueMembership)
	SELECT cm.ClientMembershipGUID,
			cm.ClientMembershipStatusID,
			stat.ClientMembershipStatusDescriptionShort,
			bs.BusinessSegmentDescriptionShort,
			cm.BeginDate,
			cm.EndDate,
			CASE WHEN cm.ClientMembershipGUID = @ClientMembershipGUID THEN 1 ELSE 0 END,
			CASE WHEN c.CurrentBioMatrixClientMembershipGUID IS NULL AND c.CurrentExtremeTherapyClientMembershipGUID IS NULL THEN 1 ELSE 0 END
		FROM datClient c
			INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = c.CurrentXtrandsClientMembershipGUID
			INNER JOIN lkpClientMembershipStatus stat ON stat.ClientMembershipStatusID = cm.ClientMembershipStatusID
			INNER JOIN cfgMembership mem ON cm.MembershipID = mem.MembershipID
			INNER JOIN lkpBusinessSegment bs ON bs.BusinessSegmentID = mem.BusinessSegmentID
	WHERE c.ClientGUID = @ClientGUID

	-- Deferred Revenue transactions are only written for Corp - Corp transfers.
	SET @IsDeferredRevenueAllowed = 1
	SELECT @IsDeferredRevenueAllowed = CASE WHEN bt.CenterBusinessTypeDescriptionShort = 'cONEctCorp' THEN 1 ELSE 0 END
		FROM cfgConfigurationCenter cc
			INNER JOIN lkpCenterBusinessType bt ON bt.CenterBusinessTypeID = cc.CenterBusinessTypeID
		 WHERE cc.CenterID = @CurrentCenterID

	IF @IsDeferredRevenueAllowed = 1
	BEGIN
		SELECT @IsDeferredRevenueAllowed = CASE WHEN bt.CenterBusinessTypeDescriptionShort = 'cONEctCorp' THEN 1 ELSE 0 END
			FROM cfgConfigurationCenter cc
				INNER JOIN lkpCenterBusinessType bt ON bt.CenterBusinessTypeID = cc.CenterBusinessTypeID
			 WHERE cc.CenterID = @NewCenterID
	END

	-- Deferred Revenue transactions are not written for New Business clients
	IF @IsDeferredRevenueAllowed = 1
	BEGIN
		SELECT @IsDeferredRevenueAllowed = CASE WHEN rg.RevenueGroupDescriptionShort = 'NB' THEN 0 ELSE 1 END
			FROM datClientMembership cm
				INNER JOIN cfgMembership m on cm.MembershipID = m.MembershipID
				INNER JOIN lkpRevenueGroup rg on m.RevenueGroupID = rg.RevenueGroupID
			 WHERE cm.ClientMembershipGUID = @ClientMembershipGUID
	END

-- Transaction
BEGIN TRANSACTION
BEGIN TRY

	--
	-- Update Center ID for the Current Surgery Membership if exists. We do not create
	-- transfer records for Surgery Memberships.
	--
	UPDATE cm SET
		CenterID = @NewCenterID,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = @User
	FROM datClient c
		INNER JOIN datClientMembership cm ON c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
	WHERE c.ClientGUID = @ClientGUID

	--
	-- If @CancelFutureAppointments bit is set, Flag all future appointments for the client (in their current center only) as "Deleted"
	--
	IF (@CancelFutureAppointments = 1)
	BEGIN
		UPDATE a SET
				a.IsDeletedFlag = 1,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = @User
		FROM datAppointment a
		WHERE a.IsDeletedFlag = 0
			AND a.CheckedInFlag = 0
			AND a.ClientGUID = @ClientGUID
			AND a.AppointmentDate >= @Today
			AND a.CenterID = @CurrentCenterID
	END

	--
	--Delete Notifications tied to future appointments at the new center, so they will no longer be considered 'visiting clients'
	--
	DELETE datNotification
	WHERE NotificationID in (SELECT n.NotificationID
								FROM datAppointment a
									inner join datNotification n on a.AppointmentGUID = n.AppointmentGUID
								WHERE a.IsDeletedFlag = 0
									AND a.CheckedInFlag = 0
									AND a.ClientGUID = @ClientGUID
									AND a.AppointmentDate >= @Today
									AND a.CenterID = @NewCenterID
									AND a.ClientHomeCenterID = @CurrentCenterID)

	--
	--Delete Credit Card on File for client
	--
	DELETE datClientCreditCard WHERE ClientGUID = @ClientGUID

	--
	--Update HomeCenterID to the new center, and reset IsAuthorizedFlag, on all open future appointments for the client
	--
	UPDATE a
	SET	a.ClientHomeCenterID = @NewCenterID,
		a.IsAuthorizedFlag = 0,
		a.LastUpdate = GETUTCDATE(),
		a.LastUpdateUser = @User
	FROM datAppointment a
	WHERE a.IsDeletedFlag = 0
		AND a.CheckedInFlag = 0
		AND a.ClientGUID = @ClientGUID
		AND a.AppointmentDate >= @Today

	--CURSOR VARIABLES
	DECLARE @CurClientMembershipGuid uniqueidentifier, @CurClientMembershipStatusID int, @CurClientMembershipStatusDescriptionShort varchar(10)
	DECLARE @CurBusinessSegmentDescriptionShort varchar(10), @CurBeginDate datetime, @CurEndDate datetime, @CurIsDefault bit, @CurIsDeferredRevenueMembership bit

	DECLARE CLIENT_CURSOR CURSOR FAST_FORWARD FOR
		SELECT
			ClientMembershipGUID, ClientMembershipStatusID, ClientMembershipStatusDescriptionShort,
			BusinessSegmentDescriptionShort, BeginDate, EndDate, IsDefault, IsDeferredRevenueMembership
		FROM @ClientMemberships cm


	OPEN CLIENT_CURSOR
	FETCH NEXT FROM CLIENT_CURSOR INTO @CurClientMembershipGuid, @CurClientMembershipStatusID, @CurClientMembershipStatusDescriptionShort,
								@CurBusinessSegmentDescriptionShort, @CurBeginDate, @CurEndDate, @CurIsDefault, @CurIsDeferredRevenueMembership

	WHILE (@@FETCH_STATUS = 0)
	BEGIN

		-- Determine revenue overage if it's a deferred revenue membership
		IF (@IsDeferredRevenueAllowed = 1 AND @CurIsDeferredRevenueMembership = 1)
		BEGIN

			--
			-- 1) Determine Revenue Overage
			--
			INSERT INTO @TempDeferredRevTable
				EXEC ('selCurrentDeferredBalanceByClient ' + @ClientIdentifier)

			SELECT TOP 1 @RevenueOverage = DeferredRevenue
				FROM @TempDeferredRevTable

			--
			-- 2) Create SO Refund for the Overage amount for Current Client Membership (Current Center)  (Use Default Payment Sales Code from the cfgMembership table?)
			--
			IF (@RevenueOverage > 0)
			BEGIN
				SET @SalesOrderGUID = NEWID()

				SELECT @TenderTypeID = TenderTypeID FROM lkpTenderType WHERE TenderTypeDescriptionShort = 'InterCo'

				--create an invoice #
				INSERT INTO @TempInvoiceTable
					EXEC ('mtnGetInvoiceNumber ' + @CurrentCenterID)

				SELECT TOP 1 @InvoiceNumber = InvoiceNumber
				FROM @TempInvoiceTable

				DELETE FROM @TempInvoiceTable

				INSERT INTO [dbo].[datSalesOrder]
				   ([SalesOrderGUID]
				   ,[TenderTransactionNumber_Temp]
				   ,[TicketNumber_Temp]
				   ,[CenterID]
				   ,[ClientHomeCenterID]
				   ,[SalesOrderTypeID]
				   ,[ClientGUID]
				   ,[ClientMembershipGUID]
				   ,[AppointmentGUID]
				   ,[HairSystemOrderGUID]
				   ,[OrderDate]
				   ,[InvoiceNumber]
				   ,[IsTaxExemptFlag]
				   ,[IsVoidedFlag]
				   ,[IsClosedFlag]
				   ,[RegisterCloseGUID]
				   ,[EmployeeGUID]
				   ,[FulfillmentNumber]
				   ,[IsWrittenOffFlag]
				   ,[IsRefundedFlag]
				   ,[RefundedSalesOrderGUID]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[ParentSalesOrderGUID]
				   ,[IsSurgeryReversalFlag]
				   ,[IsGuaranteeFlag]
				   ,[cashier_temp]
				   ,[ctrOrderDate]
				   ,[CenterFeeBatchGUID]
				   ,[CenterDeclineBatchGUID]
				   ,[RegisterID]
				   ,[EndOfDayGUID]
				   ,[IncomingRequestID]
				   ,[WriteOffSalesOrderGUID]
				   ,[NSFSalesOrderGUID]
				   ,[ChargeBackSalesOrderGUID]
				   ,[ChargebackReasonID]
				   ,[InterCompanyTransactionID])
			 VALUES
				   (@SalesOrderGUID
				   ,NULL
				   ,NULL
				   ,@CurrentCenterID
				   ,@CurrentCenterID
				   ,@SOSalesOrderTypeID
				   ,@ClientGUID
				   ,@CurClientMembershipGUID
				   ,NULL
				   ,NULL
				   ,GETUTCDATE()
				   ,@InvoiceNumber
				   ,0
				   ,0 -- IsVoided
				   ,1 -- IsClosed
				   ,NULL
				   ,@ConsultantGUID
				   ,NULL
				   ,0
				   ,1
				   ,NULL
				   ,GETUTCDATE()
				   ,@User
				   ,GETUTCDATE()
				   ,@User
				   ,NULL
				   ,0
				   ,0
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL)

				INSERT INTO [dbo].[datSalesOrderDetail]
				   ([SalesOrderDetailGUID]
				   ,[TransactionNumber_Temp]
				   ,[SalesOrderGUID]
				   ,[SalesCodeID]
				   ,[Quantity]
				   ,[Price]
				   ,[Discount]
				   ,[Tax1]
				   ,[Tax2]
				   ,[TaxRate1]
				   ,[TaxRate2]
				   ,[IsRefundedFlag]
				   ,[RefundedSalesOrderDetailGUID]
				   ,[RefundedTotalQuantity]
				   ,[RefundedTotalPrice]
				   ,[Employee1GUID]
				   ,[Employee2GUID]
				   ,[Employee3GUID]
				   ,[Employee4GUID]
				   ,[PreviousClientMembershipGUID]
				   ,[NewCenterID]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[Center_Temp]
				   ,[performer_temp]
				   ,[performer2_temp]
				   ,[Member1Price_temp]
				   ,[CancelReasonID]
				   ,[EntrySortOrder]
				   ,[HairSystemOrderGUID]
				   ,[DiscountTypeID]
				   ,[BenefitTrackingEnabledFlag]
				   ,[MembershipPromotionID]
				   ,[MembershipOrderReasonID]
				   ,[MembershipNotes]
				   ,[GenericSalesCodeDescription]
				   ,[SalesCodeSerialNumber]
				   ,[WriteOffSalesOrderDetailGUID]
				   ,[NSFBouncedDate]
				   ,[IsWrittenOffFlag]
				   ,[InterCompanyPrice])
			 VALUES
				   (NEWID()
				   ,NULL
				   ,@SalesOrderGUID
				   ,@DeferredRevSalesCodeID
				   ,-1
				   ,@RevenueOverage
				   ,0
				   ,0
				   ,0
				   ,0
				   ,0
				   ,1
				   ,NULL
				   ,NULL
				   ,NULL
				   ,@ConsultantGUID
				   ,@StylistGUID
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,GETUTCDATE()
				   ,@User
				   ,GETUTCDATE()
				   ,@User
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,1
				   ,NULL
				   ,NULL
				   ,1
				   ,NULL
				   ,NULL --MembershipOrderReasonID
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,0
				   ,NULL)

				INSERT INTO [dbo].[datSalesOrderTender]
				   ([SalesOrderTenderGUID]
				   ,[SalesOrderGUID]
				   ,[TenderTypeID]
				   ,[Amount]
				   ,[CheckNumber]
				   ,[CreditCardLast4Digits]
				   ,[ApprovalCode]
				   ,[CreditCardTypeID]
				   ,[FinanceCompanyID]
				   ,[InterCompanyReasonID]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[RefundAmount]
				   ,[MonetraTransactionId]
				   ,[EntrySortOrder]
				   ,[CashCollected])
			 VALUES
				   (NEWID()
				   ,@SalesOrderGUID
				   ,@TenderTypeID
				   ,(-1 * @RevenueOverage)
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,NULL
				   ,GETUTCDATE()
				   ,@User
				   ,GETUTCDATE()
				   ,@User
				   ,NULL
				   ,NULL
				   ,1
				   ,NULL)

				-- Call the Accum Stored Proc
				EXEC [dbo].[mtnMembershipAccumAdjustment] 'SALES ORDER', @SalesOrderGUID
			END -- end of @RevenueOverage > 0 statement

		END  -- end of @CurIsDeferredRevenueMembership = 1 statement

		-- If Client Membership status is active, cancel membership.
		IF (@CurClientMembershipStatusDescriptionShort = 'A')
		BEGIN

			-- Deterimne 'Transferred' status id.
			SELECT @ClientMembershipStatusID = ClientMembershipStatusID FROM lkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = 'TXFR'

			--
			-- 3) Create MO to Close Membership
			--
			EXEC [utlCloseClientMembership] @CurClientMembershipGUID, @ConsultantGUID, @CurrentCenterID, @ClientMembershipStatusID, @ClientMembershipAddOnStatusID_Transferred, @User
		END  -- end of @CurClientMembershipStatusDescriptionShort <> 'A' statement


		--
		-- 5) Create MO to Transfer Client to new Center (User TXFROUT sales code)
		--
		SET @SalesOrderGUID = NEWID()
		SELECT @SalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'TXFROUT'
		SELECT @TenderTypeID = TenderTypeID FROM lkpTenderType WHERE TenderTypeDescriptionShort = 'Membership'

		--create an invoice #
		INSERT INTO @TempInvoiceTable
			EXEC ('mtnGetInvoiceNumber ' + @CurrentCenterID)

		SELECT TOP 1 @InvoiceNumber = InvoiceNumber
		FROM @TempInvoiceTable

		DELETE FROM @TempInvoiceTable

		INSERT INTO [dbo].[datSalesOrder]
	        ([SalesOrderGUID]
	        ,[TenderTransactionNumber_Temp]
	        ,[TicketNumber_Temp]
	        ,[CenterID]
	        ,[ClientHomeCenterID]
	        ,[SalesOrderTypeID]
	        ,[ClientGUID]
	        ,[ClientMembershipGUID]
	        ,[AppointmentGUID]
	        ,[HairSystemOrderGUID]
	        ,[OrderDate]
	        ,[InvoiceNumber]
	        ,[IsTaxExemptFlag]
	        ,[IsVoidedFlag]
	        ,[IsClosedFlag]
	        ,[RegisterCloseGUID]
	        ,[EmployeeGUID]
	        ,[FulfillmentNumber]
	        ,[IsWrittenOffFlag]
	        ,[IsRefundedFlag]
	        ,[RefundedSalesOrderGUID]
	        ,[CreateDate]
	        ,[CreateUser]
	        ,[LastUpdate]
	        ,[LastUpdateUser]
	        ,[ParentSalesOrderGUID]
	        ,[IsSurgeryReversalFlag]
	        ,[IsGuaranteeFlag]
	        ,[cashier_temp]
	        ,[ctrOrderDate]
	        ,[CenterFeeBatchGUID]
	        ,[CenterDeclineBatchGUID]
	        ,[RegisterID]
	        ,[EndOfDayGUID]
	        ,[IncomingRequestID]
	        ,[WriteOffSalesOrderGUID]
	        ,[NSFSalesOrderGUID]
	        ,[ChargeBackSalesOrderGUID]
	        ,[ChargebackReasonID]
	        ,[InterCompanyTransactionID])
	    VALUES
	        (@SalesOrderGUID
	        ,NULL
	        ,NULL
	        ,@CurrentCenterID
	        ,@CurrentCenterID
	        ,@MOSalesOrderTypeID
	        ,@ClientGUID
	        ,@CurClientMembershipGUID
	        ,NULL
	        ,NULL
	        ,GETUTCDATE()
	        ,@InvoiceNumber
	        ,0 -- IsTaxExempt
	        ,0 -- IsVoided
	        ,1 -- IsClosed
	        ,NULL
	        ,@ConsultantGUID
	        ,NULL
	        ,0 -- IsWrittenOffFlag
	        ,1 -- IsRefundedFlag
	        ,NULL -- RefundedSalesOrderGUID
	        ,GETUTCDATE()
	        ,@User
	        ,GETUTCDATE()
	        ,@User
	        ,NULL
	        ,0
	        ,0
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL)

		-- Generate line item for membership.
		INSERT INTO [dbo].[datSalesOrderDetail]
	        ([SalesOrderDetailGUID]
	        ,[TransactionNumber_Temp]
	        ,[SalesOrderGUID]
	        ,[SalesCodeID]
	        ,[Quantity]
	        ,[Price]
	        ,[Discount]
	        ,[Tax1]
	        ,[Tax2]
	        ,[TaxRate1]
	        ,[TaxRate2]
	        ,[IsRefundedFlag]
	        ,[RefundedSalesOrderDetailGUID]
	        ,[RefundedTotalQuantity]
	        ,[RefundedTotalPrice]
	        ,[Employee1GUID]
	        ,[Employee2GUID]
	        ,[Employee3GUID]
	        ,[Employee4GUID]
	        ,[PreviousClientMembershipGUID]
	        ,[NewCenterID]
	        ,[CreateDate]
	        ,[CreateUser]
	        ,[LastUpdate]
	        ,[LastUpdateUser]
	        ,[Center_Temp]
	        ,[performer_temp]
	        ,[performer2_temp]
	        ,[Member1Price_temp]
	        ,[CancelReasonID]
	        ,[EntrySortOrder]
	        ,[HairSystemOrderGUID]
	        ,[DiscountTypeID]
	        ,[BenefitTrackingEnabledFlag]
	        ,[MembershipPromotionID]
	        ,[MembershipOrderReasonID]
	        ,[MembershipNotes]
	        ,[GenericSalesCodeDescription]
	        ,[SalesCodeSerialNumber]
	        ,[WriteOffSalesOrderDetailGUID]
	        ,[NSFBouncedDate]
	        ,[IsWrittenOffFlag]
	        ,[InterCompanyPrice])
	    VALUES
	        (NEWID()
	        ,NULL
	        ,@SalesOrderGUID
	        ,@SalesCodeID
	        ,1 -- Quantity
	        ,0 -- Price
	        ,0 -- Discount
	        ,0 -- Tax1
	        ,0 -- Tax2
	        ,0 -- TaxRate1
	        ,0 -- TaxRate2
	        ,1 -- IsRefundedFlag
	        ,NULL
	        ,NULL
	        ,NULL
	        ,@ConsultantGUID
	        ,@StylistGUID
	        ,NULL
	        ,NULL
	        ,NULL
	        ,@NewCenterID -- New CenterID
	        ,GETUTCDATE()
	        ,@User
	        ,GETUTCDATE()
	        ,@User
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,1
	        ,NULL
	        ,NULL
	        ,1
	        ,NULL
	        ,@MembershipOrderReasonID -- MembershipOrderReasonID for Transfer reason
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,0
	        ,NULL)

		-- Generate line items for Add-Ons
		INSERT INTO [dbo].[datSalesOrderDetail]
	        ([SalesOrderDetailGUID]
	        ,[TransactionNumber_Temp]
	        ,[SalesOrderGUID]
	        ,[SalesCodeID]
	        ,[Quantity]
	        ,[Price]
	        ,[Discount]
	        ,[Tax1]
	        ,[Tax2]
	        ,[TaxRate1]
	        ,[TaxRate2]
	        ,[IsRefundedFlag]
	        ,[RefundedSalesOrderDetailGUID]
	        ,[RefundedTotalQuantity]
	        ,[RefundedTotalPrice]
	        ,[Employee1GUID]
	        ,[Employee2GUID]
	        ,[Employee3GUID]
	        ,[Employee4GUID]
	        ,[PreviousClientMembershipGUID]
	        ,[NewCenterID]
	        ,[CreateDate]
	        ,[CreateUser]
	        ,[LastUpdate]
	        ,[LastUpdateUser]
	        ,[Center_Temp]
	        ,[performer_temp]
	        ,[performer2_temp]
	        ,[Member1Price_temp]
	        ,[CancelReasonID]
	        ,[EntrySortOrder]
	        ,[HairSystemOrderGUID]
	        ,[DiscountTypeID]
	        ,[BenefitTrackingEnabledFlag]
	        ,[MembershipPromotionID]
	        ,[MembershipOrderReasonID]
	        ,[MembershipNotes]
	        ,[GenericSalesCodeDescription]
	        ,[SalesCodeSerialNumber]
	        ,[WriteOffSalesOrderDetailGUID]
	        ,[NSFBouncedDate]
	        ,[IsWrittenOffFlag]
	        ,[InterCompanyPrice]
			,[ClientMembershipAddOnID])
	    SELECT
	        NEWID()
	        ,NULL
	        ,@SalesOrderGUID
	        ,@SalesCodeID_TransferOutAddOn
	        ,1 -- Quantity
	        ,0 -- Price
	        ,0 -- Discount
	        ,0 -- Tax1
	        ,0 -- Tax2
	        ,0 -- TaxRate1
	        ,0 -- TaxRate2
	        ,1 -- IsRefundedFlag
	        ,NULL
	        ,NULL
	        ,NULL
	        ,@ConsultantGUID
	        ,@StylistGUID
	        ,NULL
	        ,NULL
	        ,NULL
	        ,@NewCenterID
	        ,GETUTCDATE()
	        ,@User
	        ,GETUTCDATE()
	        ,@User
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
			,(addOn.rn + 1) as EntrySortOrder
	        ,NULL
	        ,NULL
	        ,1 -- BenefitTrackingEnabledFlag
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,0
	        ,NULL
			,addOn.ClientMembershipAddOnID
		FROM (SELECT ClientMembershipAddOnID, ROW_NUMBER() OVER (PARTITION BY ClientMembershipGUID ORDER BY ClientMembershipAddOnID) AS rn
				FROM datClientMembershipAddOn
				WHERE ClientMembershipGUID = @CurClientMembershipGUID
					and ClientMembershipAddOnStatusID = @ClientMembershipAddOnStatusID_Transferred) AS addOn

		INSERT INTO [dbo].[datSalesOrderTender]
	        ([SalesOrderTenderGUID]
	        ,[SalesOrderGUID]
	        ,[TenderTypeID]
	        ,[Amount]
	        ,[CheckNumber]
	        ,[CreditCardLast4Digits]
	        ,[ApprovalCode]
	        ,[CreditCardTypeID]
	        ,[FinanceCompanyID]
	        ,[InterCompanyReasonID]
	        ,[CreateDate]
	        ,[CreateUser]
	        ,[LastUpdate]
	        ,[LastUpdateUser]
	        ,[RefundAmount]
	        ,[MonetraTransactionId]
	        ,[EntrySortOrder]
	        ,[CashCollected])
	    VALUES
	        (NEWID()
	        ,@SalesOrderGUID
	        ,@TenderTypeID
	        ,0 -- Amount
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,NULL
	        ,GETUTCDATE()
	        ,@User
	        ,GETUTCDATE()
	        ,@User
	        ,NULL
	        ,NULL
	        ,1
	        ,NULL)

		-- Call the Accum Stored Proc
		EXEC [dbo].[mtnMembershipAccumAdjustment] 'SALES ORDER', @SalesOrderGUID

		--
		-- 6) Create new Client Membership and new Client Memebership Add-Ons at the new center
		--
		SET @NewClientMembershipGUID = NEWID()

		INSERT INTO datClientMembership (
			ClientMembershipGUID,
			Member1_ID_Temp,
			ClientGUID,
			CenterID,
			MembershipID,
			ClientMembershipStatusID,
			ContractPrice,
			ContractPaidAmount,
			MonthlyFee,
			BeginDate,
			EndDate,
			MembershipCancelReasonID,
			CancelDate,
			IsGuaranteeFlag,
			IsRenewalFlag,
			IsMultipleSurgeryFlag,
			RenewalCount,
			IsActiveFlag,
			CreateDate,
			CreateUser,
			LastUpdate,
			LastUpdateUser,
			ClientMembershipIdentifier)
		SELECT
			@NewClientMembershipGUID
			,NULL
			,cm.ClientGUID
			,@NewCenterID
			,cm.MembershipID
			,@CurClientMembershipStatusID
			,ContractPrice
			,ContractPaidAmount
			,MonthlyFee
			,CASE WHEN @CurEndDate < @Today THEN @CurBeginDate ELSE @Today END  -- only change start date if the end date is in the future.
			,@CurEndDate
			,NULL
			,NULL
			,IsGuaranteeFlag
			,IsRenewalFlag
			,IsMultipleSurgeryFlag
			,RenewalCount
			,1
			,GETUTCDATE()
			,@User
			,GETUTCDATE()
			,@User
			,NULL
		FROM datClientMembership cm
		WHERE cm.ClientMembershipGUID = @CurClientMembershipGUID

		INSERT INTO datClientMembershipAddOn
			(ClientMembershipGUID
			,AddOnID
			,ClientMembershipAddOnStatusID
			,ContractPrice
			,Quantity
			,MonthlyFee
			,CreateDate
			,CreateUser
			,LastUpdate
			,LastUpdateUser
			,ContractPaidAmount
			,Price
			,Term)
		SELECT
			@NewClientMembershipGUID
			,AddOnID
			,@ClientMembershipAddOnStatusID_Active
			,ContractPrice
			,Quantity
			,MonthlyFee
			,GETUTCDATE()
			,@User
			,GETUTCDATE()
			,@User
			,ContractPaidAmount
			,Price
			,Term
		FROM datClientMembershipAddOn
		WHERE ClientMembershipGUID = @CurClientMembershipGUID
			and ClientMembershipAddOnStatusID = @ClientMembershipAddOnStatusID_Transferred

		--Get Client Membership Number
		EXEC [mtnGetClientMembershipNumber] @ClientGUID, @NewCenterID, @Today, @ClientMembershipNumber OUTPUT

		-- Update Client Membershp Identifier
		UPDATE datClientMembership SET
			[ClientMembershipIdentifier] = @ClientMembershipNumber
		WHERE ClientMembershipGUID = @NewClientMembershipGUID

		-- Update Memberhsip on the client record
		UPDATE datClient SET
			CurrentBioMatrixClientMembershipGUID = CASE WHEN @CurBusinessSegmentDescriptionShort = 'BIO' THEN @NewClientMembershipGUID ELSE CurrentBioMatrixClientMembershipGUID END
			, CurrentExtremeTherapyClientMembershipGUID = CASE WHEN @CurBusinessSegmentDescriptionShort = 'EXT' THEN @NewClientMembershipGUID ELSE CurrentExtremeTherapyClientMembershipGUID END
			, CurrentXtrandsClientMembershipGUID = CASE WHEN @CurBusinessSegmentDescriptionShort = 'XTR' THEN @NewClientMembershipGUID ELSE CurrentXtrandsClientMembershipGUID END
			, CurrentSurgeryClientMembershipGUID = CASE WHEN @CurBusinessSegmentDescriptionShort = 'SUR' THEN @NewClientMembershipGUID ELSE CurrentSurgeryClientMembershipGUID END
			, LastUpdateUser = @User
			, LastUpdate = GETUTCDATE()
		WHERE ClientGUID = @ClientGUID

		--Update Membership on all open future appointments tied to the old Membership
		UPDATE a
		SET	a.ClientMembershipGUID = @NewClientMembershipGUID,
			a.LastUpdate = GETUTCDATE(),
			a.LastUpdateUser = @User
		FROM datAppointment a
		WHERE a.IsDeletedFlag = 0
			AND a.CheckedInFlag = 0
			AND a.ClientMembershipGUID = @CurClientMembershipGUID --@ClientMembershipGUID
			AND a.AppointmentDate >= @Today

		--Update Membership on all open future waiting lists tied to the old Membership
		UPDATE wl
		SET	wl.ClientMembershipGUID = @NewClientMembershipGUID,
			wl.LastUpdate = GETUTCDATE(),
			wl.LastUpdateUser = @User
		FROM datWaitingList wl
		WHERE wl.IsDeletedFlag = 0
			AND wl.AppointmentGUID IS NULL
			AND wl.ClientMembershipGUID = @CurClientMembershipGUID
			AND wl.EndDate >= @Today

		--
		-- 7) Copy Client Membership Accum records from current Membership to new client membership (retain same values)
		--
		INSERT INTO [dbo].[datClientMembershipAccum]
			   ([ClientMembershipAccumGUID]
			   ,[ClientMembershipGUID]
			   ,[AccumulatorID]
			   ,[UsedAccumQuantity]
			   ,[AccumMoney]
			   ,[AccumDate]
			   ,[TotalAccumQuantity]
			   ,[CreateDate]
			   ,[CreateUser]
			   ,[LastUpdate]
			   ,[LastUpdateUser]
			   ,[ClientMembershipAddOnID])
		SELECT
			   NEWID()
			   ,@NewClientMembershipGUID
			   ,AccumulatorID
			   ,UsedAccumQuantity
			   ,AccumMoney
			   ,AccumDate
			   ,TotalAccumQuantity
			   ,GETUTCDATE()
			   ,@User
			   ,GETUTCDATE()
			   ,@User
			   ,cmao_newmem.ClientMembershipAddOnID
		FROM datClientMembershipAccum cma
			left join datClientMembershipAddOn cmao_oldmem on cma.ClientMembershipAddOnID = cmao_oldmem.ClientMembershipAddOnID
			left join datClientMembershipAddOn cmao_newmem on cmao_newmem.ClientMembershipGUID = @NewClientMembershipGUID and cmao_newmem.AddOnID = cmao_oldmem.AddOnID
		WHERE cma.ClientMembershipGUID = @CurClientMembershipGUID
			and (cmao_oldmem.ClientMembershipAddOnID IS NULL or cmao_oldmem.ClientMembershipAddOnStatusID = @ClientMembershipAddOnStatusID_Transferred)

		--
		-- 7b) Reassign EFT Profile if Exists to new Client Membership
		--
		UPDATE datClientEFT SET
			ClientMembershipGUID = @NewClientMembershipGUID,
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = @User
		WHERE ClientMembershipGUID = @CurClientMembershipGUID


		--
		-- 8) Create new MO for the New Center (Use TXFRIN Sales Code)
		--

		PRINT @NewCenterID
		SET @SalesOrderGUID = NEWID()
		SELECT @SalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'TXFRIN'

		SELECT @TenderTypeID = TenderTypeID FROM lkpTenderType WHERE TenderTypeDescriptionShort = 'Membership'

		--create an invoice #
		INSERT INTO @TempInvoiceTable
			EXEC ('mtnGetInvoiceNumber ' + @NewCenterID)

		SELECT TOP 1 @InvoiceNumber = InvoiceNumber
		FROM @TempInvoiceTable

		DELETE FROM @TempInvoiceTable

		INSERT INTO [dbo].[datSalesOrder]
			([SalesOrderGUID]
			,[TenderTransactionNumber_Temp]
			,[TicketNumber_Temp]
			,[CenterID]
			,[ClientHomeCenterID]
			,[SalesOrderTypeID]
			,[ClientGUID]
			,[ClientMembershipGUID]
			,[AppointmentGUID]
			,[HairSystemOrderGUID]
			,[OrderDate]
			,[InvoiceNumber]
			,[IsTaxExemptFlag]
			,[IsVoidedFlag]
			,[IsClosedFlag]
			,[RegisterCloseGUID]
			,[EmployeeGUID]
			,[FulfillmentNumber]
			,[IsWrittenOffFlag]
			,[IsRefundedFlag]
			,[RefundedSalesOrderGUID]
			,[CreateDate]
			,[CreateUser]
			,[LastUpdate]
			,[LastUpdateUser]
			,[ParentSalesOrderGUID]
			,[IsSurgeryReversalFlag]
			,[IsGuaranteeFlag]
			,[cashier_temp]
			,[ctrOrderDate]
			,[CenterFeeBatchGUID]
			,[CenterDeclineBatchGUID]
			,[RegisterID]
			,[EndOfDayGUID]
			,[IncomingRequestID]
			,[WriteOffSalesOrderGUID]
			,[NSFSalesOrderGUID]
			,[ChargeBackSalesOrderGUID]
			,[ChargebackReasonID]
			,[InterCompanyTransactionID])
		VALUES
			(@SalesOrderGUID
			,NULL
			,NULL
			,@NewCenterID
			,@NewCenterID
			,@MOSalesOrderTypeID
			,@ClientGUID
			,@NewClientMembershipGUID
			,NULL
			,NULL
			,GETUTCDATE()
			,@InvoiceNumber
			,0
			,0 -- IsVoided
			,1 -- IsClosed
			,NULL
			,@ConsultantGUID
			,NULL
			,0
			,1
			,NULL
			,GETUTCDATE()
			,@User
			,GETUTCDATE()
			,@User
			,NULL
			,0
			,0
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL)

		-- Generate line item for membership.
		INSERT INTO [dbo].[datSalesOrderDetail]
			([SalesOrderDetailGUID]
			,[TransactionNumber_Temp]
			,[SalesOrderGUID]
			,[SalesCodeID]
			,[Quantity]
			,[Price]
			,[Discount]
			,[Tax1]
			,[Tax2]
			,[TaxRate1]
			,[TaxRate2]
			,[IsRefundedFlag]
			,[RefundedSalesOrderDetailGUID]
			,[RefundedTotalQuantity]
			,[RefundedTotalPrice]
			,[Employee1GUID]
			,[Employee2GUID]
			,[Employee3GUID]
			,[Employee4GUID]
			,[PreviousClientMembershipGUID]
			,[NewCenterID]
			,[CreateDate]
			,[CreateUser]
			,[LastUpdate]
			,[LastUpdateUser]
			,[Center_Temp]
			,[performer_temp]
			,[performer2_temp]
			,[Member1Price_temp]
			,[CancelReasonID]
			,[EntrySortOrder]
			,[HairSystemOrderGUID]
			,[DiscountTypeID]
			,[BenefitTrackingEnabledFlag]
			,[MembershipPromotionID]
			,[MembershipOrderReasonID]
			,[MembershipNotes]
			,[GenericSalesCodeDescription]
			,[SalesCodeSerialNumber]
			,[WriteOffSalesOrderDetailGUID]
			,[NSFBouncedDate]
			,[IsWrittenOffFlag]
			,[InterCompanyPrice])
		VALUES
			(NEWID()
			,NULL
			,@SalesOrderGUID
			,@SalesCodeID
			,1
			,0 -- Price
			,0
			,0
			,0
			,0
			,0
			,1
			,NULL
			,NULL
			,NULL
			,@ConsultantGUID
			,@StylistGUID
			,NULL
			,NULL
			,@CurClientMembershipGUID
			,NULL -- New CenterID
			,GETUTCDATE()
			,@User
			,GETUTCDATE()
			,@User
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,1
			,NULL
			,NULL
			,1
			,NULL
			,@MembershipOrderReasonID --MembershipOrderReasonID for Transfer reason
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,0
			,NULL)

		-- Generate line items for Add-Ons
		INSERT INTO [dbo].[datSalesOrderDetail]
			([SalesOrderDetailGUID]
			,[TransactionNumber_Temp]
			,[SalesOrderGUID]
			,[SalesCodeID]
			,[Quantity]
			,[Price]
			,[Discount]
			,[Tax1]
			,[Tax2]
			,[TaxRate1]
			,[TaxRate2]
			,[IsRefundedFlag]
			,[RefundedSalesOrderDetailGUID]
			,[RefundedTotalQuantity]
			,[RefundedTotalPrice]
			,[Employee1GUID]
			,[Employee2GUID]
			,[Employee3GUID]
			,[Employee4GUID]
			,[PreviousClientMembershipGUID]
			,[NewCenterID]
			,[CreateDate]
			,[CreateUser]
			,[LastUpdate]
			,[LastUpdateUser]
			,[Center_Temp]
			,[performer_temp]
			,[performer2_temp]
			,[Member1Price_temp]
			,[CancelReasonID]
			,[EntrySortOrder]
			,[HairSystemOrderGUID]
			,[DiscountTypeID]
			,[BenefitTrackingEnabledFlag]
			,[MembershipPromotionID]
			,[MembershipOrderReasonID]
			,[MembershipNotes]
			,[GenericSalesCodeDescription]
			,[SalesCodeSerialNumber]
			,[WriteOffSalesOrderDetailGUID]
			,[NSFBouncedDate]
			,[IsWrittenOffFlag]
			,[InterCompanyPrice]
			,[ClientMembershipAddOnID])
		SELECT
			NEWID()
			,NULL
			,@SalesOrderGUID
			,@SalesCodeID_TransferInAddOn
			,1 -- Quantity
			,0 -- Price
			,0 -- Discount
			,0 -- Tax1
			,0 -- Tax2
			,0 -- TaxRate1
			,0 -- TaxRate2
			,1 -- IsRefundedFlag
			,NULL
			,NULL
			,NULL
			,@ConsultantGUID
			,@StylistGUID
			,NULL
			,NULL
			,NULL
			,NULL -- New CenterID
			,GETUTCDATE()
			,@User
			,GETUTCDATE()
			,@User
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,(addOn.rn + 1) as EntrySortOrder
			,NULL
			,NULL
			,1 -- BenefitTrackingEnabledFlag
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,0
			,NULL
			,addOn.ClientMembershipAddOnID
		FROM (SELECT ClientMembershipAddOnID, ROW_NUMBER() OVER (PARTITION BY ClientMembershipGUID ORDER BY ClientMembershipAddOnID) AS rn
				FROM datClientMembershipAddOn
				WHERE ClientMembershipGUID = @CurClientMembershipGUID
					and ClientMembershipAddOnStatusID = @ClientMembershipAddOnStatusID_Transferred) AS addOn

		INSERT INTO [dbo].[datSalesOrderTender]
			([SalesOrderTenderGUID]
			,[SalesOrderGUID]
			,[TenderTypeID]
			,[Amount]
			,[CheckNumber]
			,[CreditCardLast4Digits]
			,[ApprovalCode]
			,[CreditCardTypeID]
			,[FinanceCompanyID]
			,[InterCompanyReasonID]
			,[CreateDate]
			,[CreateUser]
			,[LastUpdate]
			,[LastUpdateUser]
			,[RefundAmount]
			,[MonetraTransactionId]
			,[EntrySortOrder]
			,[CashCollected])
		VALUES
			(NEWID()
			,@SalesOrderGUID
			,@TenderTypeID
			,0 -- Amount
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,GETUTCDATE()
			,@User
			,GETUTCDATE()
			,@User
			,NULL
			,NULL
			,1
			,NULL)

		-- Call the Accum Stored Proc
		EXEC [dbo].[mtnMembershipAccumAdjustment] 'SALES ORDER', @SalesOrderGUID

		--
		-- 9) Enter Membership Payment SO for the Overage Amount under the new client membership (Use Default Payment Sales Code from the cfgMembership table?)
		--
		IF (@IsDeferredRevenueAllowed = 1 AND @CurIsDeferredRevenueMembership = 1 AND  @RevenueOverage > 0)
		BEGIN
			SET @SalesOrderGUID = NEWID()

			SELECT @TenderTypeID = TenderTypeID FROM lkpTenderType WHERE TenderTypeDescriptionShort = 'InterCo'

			--create an invoice #
			INSERT INTO @TempInvoiceTable
				EXEC ('mtnGetInvoiceNumber ' + @NewCenterID)

			SELECT TOP 1 @InvoiceNumber = InvoiceNumber
			FROM @TempInvoiceTable

			DELETE FROM @TempInvoiceTable

			INSERT INTO [dbo].[datSalesOrder]
			   ([SalesOrderGUID]
			   ,[TenderTransactionNumber_Temp]
			   ,[TicketNumber_Temp]
			   ,[CenterID]
			   ,[ClientHomeCenterID]
			   ,[SalesOrderTypeID]
			   ,[ClientGUID]
			   ,[ClientMembershipGUID]
			   ,[AppointmentGUID]
			   ,[HairSystemOrderGUID]
			   ,[OrderDate]
			   ,[InvoiceNumber]
			   ,[IsTaxExemptFlag]
			   ,[IsVoidedFlag]
			   ,[IsClosedFlag]
			   ,[RegisterCloseGUID]
			   ,[EmployeeGUID]
			   ,[FulfillmentNumber]
			   ,[IsWrittenOffFlag]
			   ,[IsRefundedFlag]
			   ,[RefundedSalesOrderGUID]
			   ,[CreateDate]
			   ,[CreateUser]
			   ,[LastUpdate]
			   ,[LastUpdateUser]
			   ,[ParentSalesOrderGUID]
			   ,[IsSurgeryReversalFlag]
			   ,[IsGuaranteeFlag]
			   ,[cashier_temp]
			   ,[ctrOrderDate]
			   ,[CenterFeeBatchGUID]
			   ,[CenterDeclineBatchGUID]
			   ,[RegisterID]
			   ,[EndOfDayGUID]
			   ,[IncomingRequestID]
			   ,[WriteOffSalesOrderGUID]
			   ,[NSFSalesOrderGUID]
			   ,[ChargeBackSalesOrderGUID]
			   ,[ChargebackReasonID]
			   ,[InterCompanyTransactionID])
		 VALUES
			   (@SalesOrderGUID
			   ,NULL
			   ,NULL
			   ,@NewCenterID
			   ,@NewCenterID
			   ,@SOSalesOrderTypeID
			   ,@ClientGUID
			   ,@NewClientMembershipGUID
			   ,NULL
			   ,NULL
			   ,GETUTCDATE()
			   ,@InvoiceNumber
			   ,0
			   ,0 -- IsVoided
			   ,1 -- IsClosed
			   ,NULL
			   ,@ConsultantGUID
			   ,NULL
			   ,0
			   ,0
			   ,NULL
			   ,GETUTCDATE()
			   ,@User
			   ,GETUTCDATE()
			   ,@User
			   ,NULL
			   ,0
			   ,0
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL)

			INSERT INTO [dbo].[datSalesOrderDetail]
			   ([SalesOrderDetailGUID]
			   ,[TransactionNumber_Temp]
			   ,[SalesOrderGUID]
			   ,[SalesCodeID]
			   ,[Quantity]
			   ,[Price]
			   ,[Discount]
			   ,[Tax1]
			   ,[Tax2]
			   ,[TaxRate1]
			   ,[TaxRate2]
			   ,[IsRefundedFlag]
			   ,[RefundedSalesOrderDetailGUID]
			   ,[RefundedTotalQuantity]
			   ,[RefundedTotalPrice]
			   ,[Employee1GUID]
			   ,[Employee2GUID]
			   ,[Employee3GUID]
			   ,[Employee4GUID]
			   ,[PreviousClientMembershipGUID]
			   ,[NewCenterID]
			   ,[CreateDate]
			   ,[CreateUser]
			   ,[LastUpdate]
			   ,[LastUpdateUser]
			   ,[Center_Temp]
			   ,[performer_temp]
			   ,[performer2_temp]
			   ,[Member1Price_temp]
			   ,[CancelReasonID]
			   ,[EntrySortOrder]
			   ,[HairSystemOrderGUID]
			   ,[DiscountTypeID]
			   ,[BenefitTrackingEnabledFlag]
			   ,[MembershipPromotionID]
			   ,[MembershipOrderReasonID]
			   ,[MembershipNotes]
			   ,[GenericSalesCodeDescription]
			   ,[SalesCodeSerialNumber]
			   ,[WriteOffSalesOrderDetailGUID]
			   ,[NSFBouncedDate]
			   ,[IsWrittenOffFlag]
			   ,[InterCompanyPrice])
		 VALUES
			   (NEWID()
			   ,NULL
			   ,@SalesOrderGUID
			   ,@DeferredRevSalesCodeID
			   ,1
			   ,@RevenueOverage
			   ,0
			   ,0
			   ,0
			   ,0
			   ,0
			   ,1
			   ,NULL
			   ,NULL
			   ,NULL
			   ,@ConsultantGUID
			   ,@StylistGUID
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL
			   ,GETUTCDATE()
			   ,@User
			   ,GETUTCDATE()
			   ,@User
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL
			   ,1
			   ,NULL
			   ,NULL
			   ,1
			   ,NULL
			   ,NULL --MembershipOrderReasonID
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL
			   ,0
			   ,NULL)

			INSERT INTO [dbo].[datSalesOrderTender]
			   ([SalesOrderTenderGUID]
			   ,[SalesOrderGUID]
			   ,[TenderTypeID]
			   ,[Amount]
			   ,[CheckNumber]
			   ,[CreditCardLast4Digits]
			   ,[ApprovalCode]
			   ,[CreditCardTypeID]
			   ,[FinanceCompanyID]
			   ,[InterCompanyReasonID]
			   ,[CreateDate]
			   ,[CreateUser]
			   ,[LastUpdate]
			   ,[LastUpdateUser]
			   ,[RefundAmount]
			   ,[MonetraTransactionId]
			   ,[EntrySortOrder]
			   ,[CashCollected])
		 VALUES
			   (NEWID()
			   ,@SalesOrderGUID
			   ,@TenderTypeID
			   ,@RevenueOverage
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL
			   ,NULL
			   ,GETUTCDATE()
			   ,@User
			   ,GETUTCDATE()
			   ,@User
			   ,NULL
			   ,NULL
			   ,1
			   ,NULL)

			-- Call the Accum Stored Proc
			EXEC [dbo].[mtnMembershipAccumAdjustment] 'SALES ORDER', @SalesOrderGUID
		END

		FETCH NEXT FROM CLIENT_CURSOR INTO @CurClientMembershipGuid, @CurClientMembershipStatusID, @CurClientMembershipStatusDescriptionShort,
								@CurBusinessSegmentDescriptionShort, @CurBeginDate, @CurEndDate, @CurIsDefault, @CurIsDeferredRevenueMembership

	END
	CLOSE CLIENT_CURSOR
	DEALLOCATE CLIENT_CURSOR


	--
	-- 10) Determine all Hair Orders in 'CENT' status and hso Center ID <> New Center ID.  If client is not transferring
	--		to Corp HQ, move these orders to 'To be Shipped' status and set Client Home Center to the New Center ID.
	--
	DELETE FROM @HairOrders

	-- Check Orders for the Client
	INSERT INTO @HairOrders
		(HairSystemOrderGUID, PreviousHairSystemOrderStatusID, CurrentClientMembershipGUID, NewClientMembershipGUID, ClientHomeCenterID, CenterID)
	SELECT hso.HairSystemOrderGUID, hso.HairSystemOrderStatusID, hso.ClientMembershipGUID,
		CASE WHEN c.[CurrentBioMatrixClientMembershipGUID] IS NOT NULL THEN
					c.[CurrentBioMatrixClientMembershipGUID] ELSE hso.ClientMembershipGUID END,
				hso.ClientHomeCenterID, hso.CenterID
	FROM datHairSystemOrder hso
		INNER JOIN lkpHairSystemOrderStatus stat ON stat.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
		INNER JOIN datClient c ON c.ClientGUID = hso.ClientGUID
	WHERE hso.ClientGUID = @ClientGUID
		AND stat.HairSystemOrderStatusID IN (@CentHairSystemOrderStatusID, @QANeededHairSystemOrderStatusID)
		AND hso.CenterID <> @NewCenterID

	-- Add orders to shipments only if not transferring to Corp HQ.
	IF @IsTransferToCorporateHQ <> 1
	BEGIN
		-- Set up to process all shipments
		DECLARE @Counter int = 1
		DECLARE @CentersCount int
		DECLARE @FromCenterID int

		-- Determine all distinct From Centers to create shipments
		DECLARE @DistinctFromCenters TABLE
		(
			ID int IDENTITY(1,1) PRIMARY KEY,
			CenterID int NOT NULL
		)

		INSERT INTO @DistinctFromCenters (CenterID)
			SELECT DISTINCT h.CenterID
			FROM @HairOrders h
			WHERE h.CenterID <> @NewCenterID

		SELECT @CentersCount = COUNT(*) FROM @DistinctFromCenters

		-- Process Shipments
		WHILE (@Counter <= @CentersCount)
		BEGIN
			SELECT @FromCenterID = CenterID FROM @DistinctFromCenters WHERE ID = @Counter

			SELECT @InventoryShipmentGUID = InventoryShipmentGUID
			FROM datInventoryShipment s
			WHERE s.ShipFromCenterID = @FromCenterID
				AND s.ShipToCenterID = @NewCenterID
				AND InventoryShipmentStatusID = @OpenInventoryShipmentStatusID

			IF @InventoryShipmentGUID IS NULL
			BEGIN
				SET @InventoryShipmentGUID = NEWID()

				-- Create Shipment
				INSERT INTO [dbo].[datInventoryShipment]
					([InventoryShipmentGUID]
					,[InventoryShipmentTypeID]
					,[InventoryShipmentStatusID]
					,[ShipFromVendorID]
					,[ShipFromCenterID]
					,[ShipToVendorID]
					,[ShipToCenterID]
					,[ShipDate]
					,[ReceiveDate]
					,[CloseDate]
					,[InvoiceNumber]
					,[InvoiceTotal]
					,[InvoiceCount]
					,[TrackingNumber]
					,[ShipmentMethodID]
					,[CreateDate]
					,[CreateUser]
					,[LastUpdate]
					,[LastUpdateUser]
					,[InvoiceActualTotal]
					,[InvoiceActualCount])
				VALUES
					(@InventoryShipmentGUID
					,@CentnerToCenterInventoryShipmentTypeID
					,@OpenInventoryShipmentStatusID
					,NULL	--ShipFromVendorID
					,@FromCenterID --ShipFromCenterID
					,NULL	--ShipToVendorID
					,@NewCenterID --ShipToCenterID
					,GETUTCDATE() --ShipDate
					,NULL	--ReceiveDate
					,NULL	--CloseDate
					,NULL	--InvoiceNumber
					,0.00	--InvoiceTotal
					,0 --InvoiceCount (will get set further down)
					,NULL	--TrackingNumber
					,NULL	--ShipmentMethodID
					,GETUTCDATE()
					,@User
					,GETUTCDATE()
					,@User
					,0.00 --InvoiceActualTotal
					,0.00)
			END

			INSERT INTO [dbo].[datInventoryShipmentDetail]
				([InventoryShipmentDetailGUID]
				,[InventoryShipmentGUID]
				,[HairSystemOrderGUID]
				,[InventoryShipmentDetailStatusID]
				,[InventoryTransferRequestGUID]
				,[CreateDate]
				,[CreateUser]
				,[LastUpdate]
				,[LastUpdateUser]
				,[InventoryShipmentReasonID]
				,[PriorityTransferFee]
				,[PriorityHairSystemCenterContractPricingID])
			SELECT NEWID()
				,@InventoryShipmentGUID
				,h.HairSystemOrderGUID
				,@ShipInventoryShipmentDetailStatusID
				,NULL	--InventoryTransferRequestGUID
				,GETUTCDATE()
				,@User
				,GETUTCDATE()
				,@user
				,@XferInventoryShipmentReasonID
				,NULL	--PriorityTransferFee
				,NULL	--PriorityHairSystemCenterContractPricingID
			FROM @HairOrders h
				LEFT JOIN datInventoryShipmentDetail sd ON sd.InventoryShipmentGUID = @InventoryShipmentGUID
														AND sd.HairSystemOrderGUID = h.HairSystemOrderGUID
			WHERE CenterID = @FromCenterID
				AND sd.InventoryShipmentDetailGUID IS NULL


			-- Update Shipment Invoice Count
			UPDATE datInventoryShipment SET
					InvoiceCount = (SELECT COUNT(*) FROM datInventoryShipmentDetail WHERE InventoryShipmentGUID = @InventoryShipmentGUID),
					LastUpdate = GETUTCDATE(),
					LastUpdateUser = @User
			WHERE InventoryShipmentGUID = @InventoryShipmentGUID

			SET @Counter = @Counter + 1
		END

	END  -- end of adding orders to shipments

	-- Update Client Membership and Client Home Center on HSO
	UPDATE hso SET
		ClientMembershipGUID = h_ord.NewClientMembershipGUID,
		ClientHomeCenterID = @NewCenterID,
		HairSystemOrderStatusID = CASE WHEN @IsTransferToCorporateHQ <> 1   -- ONLY update status to XferAccept if not transferring to  Corp HQ
										THEN  @XsferAcceptedHairSystemOrderStatusID ELSE HairSystemOrderStatusID END,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = @User
	FROM @HairOrders h_ord
		INNER JOIN datHairSystemOrder hso ON h_ord.HairSystemOrderGUID = hso.HairSystemOrderGUID


	--
	-- 11) Create Hair System Order Transaction records for changes in Step 12.
	--
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
			,[SalesOrderDetailGuid])
		SELECT
			NEWID()
			,hso.CenterID
			,hso.ClientHomeCenterID
			,@ClientGUID
			,o.NewClientMembershipGUID
			,GETUTCDATE()
			,@AutoAdjHairSystemOrderProcessID
			,hso.HairSystemOrderGUID
			,NULL as PreviousCenterID
			,o.CurrentClientMembershipGUID as PreviousClientMembershipGUID
			,o.PreviousHairSystemOrderStatusID as PreviousHairSystemOrderStatusID
			,hso.HairSystemOrderStatusID as NewHairSystemOrderStatusID
			,isd.InventoryShipmentDetailGUID as InventoryShipmentDetailGUID
			,NULL as InventoryTransferRequestGUID
			,NULL as PurchaseOrderDetailGUID
			,hso.CostContract as CostContract
			,hso.CostContract as PreviousCostContract
			,hso.CostActual as CostActual
			,hso.CostActual as CostActual
			,hso.CenterPrice as CenterPrice
			,hso.CenterPrice as PreviousCenterPrice
			,@ConsultantGUID as EmployeeGUID
			,GETUTCDATE()
			,@User
			,GETUTCDATE()
			,@User
			,hso.CostFactoryShipped
			,hso.CostFactoryShipped
			,NULL
	FROM @HairOrders o
		INNER JOIN datHairSystemOrder hso ON hso.HairSystemOrderGUID = o.HairSystemOrderGUID
		OUTER APPLY
		(
			SELECT TOP(1) oa_isd.*
			FROM datInventoryShipmentDetail oa_isd
				INNER JOIN datInventoryShipment oa_s ON oa_s.InventoryShipmentGUID = oa_isd.InventoryShipmentGUID
			WHERE oa_isd.HairSystemOrderGUID = o.HairSystemORderGUID
					AND oa_isd.InventoryShipmentReasonID = @XferInventoryShipmentReasonID
					AND oa_s.InventoryShipmentTypeID = @CentnerToCenterInventoryShipmentTypeID
					AND oa_s.InventoryShipmentStatusID = @OpenInventoryShipmentStatusID
			ORDER BY oa_s.ShipmentNumber desc

		) isd


	--
	-- 12) Determine all Hair Orders in 'ORDER', 'NEW', 'HQ-Recv', 'HQ-FShip', 'ShipCorp', 'FAC-Ship', and 'HQ-HOLD' and modify Client Home Center to the New Center
	--
	DELETE FROM @HairOrders

	INSERT INTO @HairOrders
		(HairSystemOrderGUID, PreviousHairSystemOrderStatusID, CurrentClientMembershipGUID, NewClientMembershipGUID, ClientHomeCenterID, CenterID)
	SELECT hso.HairSystemOrderGUID, hso.HairSystemOrderStatusID, hso.ClientMembershipGUID,
			CASE WHEN c.[CurrentBioMatrixClientMembershipGUID] IS NOT NULL THEN
					c.[CurrentBioMatrixClientMembershipGUID] ELSE hso.ClientMembershipGUID END,
				hso.ClientHomeCenterID, hso.CenterID
	FROM datHairSystemOrder hso
		INNER JOIN lkpHairSystemOrderStatus stat ON stat.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
		INNER JOIN datClient c ON c.ClientGUID = hso.ClientGUID
	WHERE hso.ClientMembershipGUID = @CurClientMembershipGUID
		AND stat.HairSystemOrderStatusDescriptionShort IN ('ORDER','NEW','HQ-Recv','HQ-FShip','ShipCorp','FAC-Ship','HQ-HOLD')

	-- Update Client Membership and Client Home Center on HSO
	UPDATE hso SET
		ClientMembershipGUID = h_ord.NewClientMembershipGUID,
		ClientHomeCenterID = @NewCenterID,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = @User
	FROM @HairOrders h_ord
		INNER JOIN datHairSystemOrder hso ON h_ord.HairSystemOrderGUID = hso.HairSystemOrderGUID

	--
	-- 13) Create Hair System Order Transaction records for changes in Step 12.
	--
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
			,[SalesOrderDetailGuid])
		SELECT
			NEWID()
			,hso.CenterID
			,hso.ClientHomeCenterID
			,@ClientGUID
			,o.NewClientMembershipGUID
			,GETUTCDATE()
			,@AutoAdjHairSystemOrderProcessID
			,hso.HairSystemOrderGUID
			,NULL as PreviousCenterID
			,o.CurrentClientMembershipGUID as PreviousClientMembershipGUID
			,o.PreviousHairSystemOrderStatusID as PreviousHairSystemOrderStatusID
			,hso.HairSystemOrderStatusID as NewHairSystemOrderStatusID
			,NULL as InventoryShipmentDetailGUID
			,NULL as InventoryTransferRequestGUID
			,NULL as PurchaseOrderDetailGUID
			,hso.CostContract as CostContract
			,hso.CostContract as PreviousCostContract
			,hso.CostActual as CostActual
			,hso.CostActual as CostActual
			,hso.CenterPrice as CenterPrice
			,hso.CenterPrice as PreviousCenterPrice
			,@ConsultantGUID as EmployeeGUID
			,GETUTCDATE()
			,@User
			,GETUTCDATE()
			,@User
			,hso.CostFactoryShipped
			,hso.CostFactoryShipped
			,NULL
	FROM @HairOrders o
		INNER JOIN datHairSystemOrder hso ON hso.HairSystemOrderGUID = o.HairSystemOrderGUID

	--
	-- 14) Update Client Center ID And clear out Client Number Temp
	--
	UPDATE datClient SET
		CenterID = @NewCenterID,
		ClientNumber_Temp = NULL,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = @User
	WHERE ClientGUID = @ClientGUID

	--
	-- 15) Create Notifications
	--
	DECLARE @NotificationTypeID int
	DECLARE @Notification nvarchar(100)

	SET @Notification = @ClientFullName + ' has been transfered from ' + @CurrentCenterDescription + ' to ' + @NewCenterDescription

	SELECT @NotificationTypeID = NotificationTypeID FROM lkpNotificationType WHERE NotificationTypeDescriptionShort = 'Client'

	-- Current Center Notification
	INSERT INTO [dbo].[datNotification]
			   ([NotificationDate], [NotificationTypeID], [ClientGUID], [FeePayCycleID], [FeeDate], [CenterID]
			   ,[IsAcknowledgedFlag], [Description], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser]
			   ,[AppointmentGUID], [IsHairOrderRequestedFlag])
		 VALUES (GETUTCDATE(),@NotificationTypeID,@ClientGUID,NULL,NULL,@CurrentCenterID,0,@Notification
			   ,GETUTCDATE(),@User,GETUTCDATE(),@User,NULL,0)


	-- New Center Notification
	INSERT INTO [dbo].[datNotification]
			   ([NotificationDate], [NotificationTypeID], [ClientGUID], [FeePayCycleID], [FeeDate], [CenterID]
			   ,[IsAcknowledgedFlag], [Description], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser]
			   ,[AppointmentGUID], [IsHairOrderRequestedFlag])
		 VALUES (GETUTCDATE(),@NotificationTypeID,@ClientGUID,NULL,NULL,@NewCenterID,0,@Notification
			   ,GETUTCDATE(),@User,GETUTCDATE(),@User,NULL,0)

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
