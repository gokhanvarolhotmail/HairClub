/* CreateDate: 06/10/2013 20:15:02.867 , ModifyDate: 03/05/2015 11:36:46.180 */
GO
/*
==============================================================================
PROCEDURE:				mtnInitializeAccountReceivableForClient

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR:

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		05/23/2013

LAST REVISION DATE: 	05/23/2013

==============================================================================
DESCRIPTION: Initializes AR for the specified client and AR.
		Clears Accum adjustment records, AR Balance, and client membership accum
		for AR.
==============================================================================
NOTES:
		* 05/23/2013 MVT - Created
		* 06/07/2013 MVT - Modified to add AR Client Membership Accum records to current
							BIO and EXT memberships if do not alredy exist.
		* 03/02/2015	MVT		Updated proc for Xtrands Business Segment

==============================================================================
SAMPLE EXECUTION: EXEC [mtnInitializeAccountReceivableForClient] '370C4710-1AAE-4CBF-BA25-7F6800B3D478', 397, 'mike'
==============================================================================
*/

CREATE PROCEDURE [dbo].[mtnInitializeAccountReceivableForClient]
	@ClientGuid uniqueidentifier
	,@InitialARBalance money
	,@User nvarchar(25)

AS
BEGIN
	SET NOCOUNT ON

	-- Delete datAccountReceivable records for the client
	DELETE arj
	FROM datAccountReceivableJoin arj
		INNER JOIN datAccountReceivable ar ON arj.ARChargeID = ar.AccountReceivableID OR arj.ARPaymentID = ar.AccountReceivableID
		INNER JOIN datClient c ON c.ClientGuid = ar.ClientGuid
	WHERE c.ClientGuid = @ClientGuid

	-- Delete AR Detail records for Client.
	DELETE ar
	FROM datAccountReceivable ar
	WHERE ar.ClientGuid = @ClientGuid

	-- Delete AR adjustment records for the Client.
	DELETE adj
	FROM datAccumulatorAdjustment adj
		INNER JOIN cfgAccumulator accum ON adj.AccumulatorID = accum.AccumulatorID
		INNER JOIN datClientMembership cm ON cm.ClientMembershipGuid = adj.ClientMembershipGuid
		INNER JOIN datClient c ON c.ClientGuid = cm.ClientGuid
	WHERE accum.AccumulatorDescriptionShort = 'ARBal'
		AND c.ClientGuid = @ClientGuid

	-- Reset Client Membership Accum for AR to $0.00
	UPDATE cmaccum SET
		cmaccum.[AccumMoney] = 0.0
		,LastUpdate = GETUTCDATE()
		,LastUpdateUser = @User
	FROM datClientMembershipAccum cmaccum
		INNER JOIN cfgAccumulator accum ON cmaccum.AccumulatorID = accum.AccumulatorID
		INNER JOIN datClientMembership cm ON cm.ClientMembershipGuid = cmaccum.ClientMembershipGuid
		INNER JOIN datClient c ON c.ClientGuid = cm.ClientGuid
	WHERE accum.AccumulatorDescriptionShort = 'ARBal'
		AND c.ClientGuid = @ClientGuid

	-- Reset the AR Balance on Client Records to $0.00
	UPDATE c SET
		c.ARBalance = 0.0
		,LastUpdate = GETUTCDATE()
		,LastUpdateUser = @User
	FROM datClient c
	WHERE c.ClientGuid = @ClientGuid

BEGIN TRANSACTION

BEGIN TRY

	DECLARE @CurrentBIOClientMembershipGuid uniqueidentifier, @CurrentEXTClientMembershipGuid uniqueidentifier, @CurrentXTRClientMembershipGuid uniqueidentifier
	SELECT
		@CurrentBIOClientMembershipGuid = c.[CurrentBioMatrixClientMembershipGUID]
		,@CurrentEXTClientMembershipGuid = c.[CurrentExtremeTherapyClientMembershipGUID]
		,@CurrentXTRClientMembershipGuid = c.[CurrentXtrandsClientMembershipGUID]
	FROM datClient c
	WHERE C.ClientGuid = @ClientGuid

	-- Insert AR client membership accum record if does not exist for this client
	IF @CurrentBIOClientMembershipGuid IS NOT NULL
			AND (NOT EXISTS (SELECT * FROM datClientMembershipAccum cmaccum
								INNER JOIN cfgAccumulator accum ON cmaccum.AccumulatorID = accum.AccumulatorID
							WHERE accum.AccumulatorDescriptionShort = 'ARBal'
								AND cmaccum.ClientMembershipGuid = @CurrentBIOClientMembershipGuid))
	BEGIN
		INSERT INTO [datClientMembershipAccum] ([ClientMembershipAccumGUID],[ClientMembershipGUID],[AccumulatorID],[UsedAccumQuantity],[AccumMoney],[AccumDate],[TotalAccumQuantity],[CreateDate],[CreateUser],[LastUpdate], [LastUpdateUser])
		SELECT NEWID(), @CurrentBIOClientMembershipGuid, AccumulatorID, 0, 0.00, NULL, 0,
			GETUTCDATE(),@User,GETUTCDATE(),@User
		FROM cfgAccumulator
		WHERE AccumulatorDescriptionShort = 'ARBal'
	END

	IF @CurrentEXTClientMembershipGuid IS NOT NULL
			AND (NOT EXISTS (SELECT * FROM datClientMembershipAccum cmaccum
								INNER JOIN cfgAccumulator accum ON cmaccum.AccumulatorID = accum.AccumulatorID
							WHERE accum.AccumulatorDescriptionShort = 'ARBal'
								AND cmaccum.ClientMembershipGuid = @CurrentEXTClientMembershipGuid))
	BEGIN
		INSERT INTO [datClientMembershipAccum] ([ClientMembershipAccumGUID],[ClientMembershipGUID],[AccumulatorID],[UsedAccumQuantity],[AccumMoney],[AccumDate],[TotalAccumQuantity],[CreateDate],[CreateUser],[LastUpdate], [LastUpdateUser])
		SELECT NEWID(), @CurrentEXTClientMembershipGuid, AccumulatorID, 0, 0.00, NULL, 0,
			GETUTCDATE(),@User,GETUTCDATE(),@User
		FROM cfgAccumulator
		WHERE AccumulatorDescriptionShort = 'ARBal'
	END

	IF @CurrentXTRClientMembershipGuid IS NOT NULL
			AND (NOT EXISTS (SELECT * FROM datClientMembershipAccum cmaccum
								INNER JOIN cfgAccumulator accum ON cmaccum.AccumulatorID = accum.AccumulatorID
							WHERE accum.AccumulatorDescriptionShort = 'ARBal'
								AND cmaccum.ClientMembershipGuid = @CurrentXTRClientMembershipGuid))
	BEGIN
		INSERT INTO [datClientMembershipAccum] ([ClientMembershipAccumGUID],[ClientMembershipGUID],[AccumulatorID],[UsedAccumQuantity],[AccumMoney],[AccumDate],[TotalAccumQuantity],[CreateDate],[CreateUser],[LastUpdate], [LastUpdateUser])
		SELECT NEWID(), @CurrentXTRClientMembershipGuid, AccumulatorID, 0, 0.00, NULL, 0,
			GETUTCDATE(),@User,GETUTCDATE(),@User
		FROM cfgAccumulator
		WHERE AccumulatorDescriptionShort = 'ARBal'
	END


	-- Create initial transaction only if initial balance > 0
	IF @InitialARBalance > 0
	BEGIN

		--SalesCodeID = 731 ShortDescription = BEGBAL.
		DECLARE @SalesCodeId int = (SELECT SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'BEGBAL')
		DECLARE @InitialCreditId int = (SELECT [AccountReceivableTypeID] FROM [lkpAccountReceivableType] WHERE [AccountReceivableTypeDescriptionShort] = 'InitCredit')
		DECLARE @InitialChargeId int = (SELECT [AccountReceivableTypeID] FROM [lkpAccountReceivableType] WHERE [AccountReceivableTypeDescriptionShort] = 'InitCharge')
		DECLARE @ARTenderTypeId int = (SELECT TenderTypeId FROM lkpTenderType WHERE TenderTypeDescriptionShort = 'AR')
		DECLARE @ARBalance money = @InitialARBalance
		DECLARE @SalesOrderGuid uniqueidentifier, @CenterID int, @ClientMembershipGuid uniqueidentifier

		DECLARE @TempInvoiceTable table
					(
						InvoiceNumber nvarchar(50)
					)
		DECLARE @InvoiceNumber nvarchar(50)

		SET @SalesOrderGuid = NewID()

		SELECT
			@CenterId = C.[CenterID]
			,@ClientMembershipGuid =  CASE WHEN c.[CurrentBioMatrixClientMembershipGUID] IS NOT NULL THEN c.[CurrentBioMatrixClientMembershipGUID]
										WHEN c.[CurrentSurgeryClientMembershipGUID] IS NOT NULL THEN c.[CurrentSurgeryClientMembershipGUID]
										WHEN c.[CurrentExtremeTherapyClientMembershipGUID] IS NOT NULL THEN c.[CurrentExtremeTherapyClientMembershipGUID]
										WHEN c.[CurrentXtrandsClientMembershipGUID] IS NOT NULL THEN c.[CurrentXtrandsClientMembershipGUID]
										ELSE NULL END
		FROM datClient c
		WHERE c.ClientGuid = @ClientGuid


		--create an invoice #
		INSERT INTO @TempInvoiceTable
			EXEC ('mtnGetInvoiceNumber ' + @CenterID)

		SELECT TOP 1 @InvoiceNumber = InvoiceNumber
		FROM @TempInvoiceTable

		DELETE FROM @TempInvoiceTable

		-- Create a sales order
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
			,[EndOfDayGUID])
		VALUES
			(@SalesOrderGuid
			,NULL
			,NULL
			,@CenterID
			,@CenterID
			,1 -- Sales Order
			,@ClientGuid
			,@ClientMembershipGuid
			,NULL
			,NULL
			,GETUTCDATE()
			,@InvoiceNumber
			,0
			,0
			,1
			,NULL
			,NULL
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
			,[GenericSalesCodeDescription])
		VALUES
			(NEWID()
			,NULL
			,@SalesOrderGuid
			,@SalesCodeID
			,CASE WHEN @ARBalance > 0 THEN 1 ELSE -1 END -- Quantity
			,ABS(@ARBalance)
			,0
			,0
			,0
			,0
			,0
			,0
			,NULL
			,NULL
			,0
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
			,NULL
			,NULL
			,NULL
			,1
			,NULL
			,NULL
			,0
			,NULL
			,NULL
			,NULL
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
			,@SalesOrderGuid
			,@ARTenderTypeId
			,@ARBalance
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
			,0
			,NULL
			,1
			,0)

		INSERT INTO [dbo].[datAccountReceivable]
				([ClientGUID]
				,[SalesOrderGUID]
				,[CenterFeeBatchGUID]
				,[Amount]
				,[IsClosed]
				,[AccountReceivableTypeID]
				,[RemainingBalance]
				,[CreateDate]
				,[CreateUser]
				,[LastUpdate]
				,[LastUpdateUser]
				,[CenterDeclineBatchGUID]
				,[RefundedSalesOrderGuid])
			VALUES
				(@ClientGuid
				,@SalesOrderGuid
				,NULL
				,ABS(@ARBalance)
				,0
				,CASE WHEN @ARBalance > 0 THEN @InitialChargeId ELSE @InitialCreditId END
				,ABS(@ARBalance)
				,GETUTCDATE()
				,@User
				,GETUTCDATE()
				,@User
				,NULL
				,NULL)

		EXEC [dbo].[mtnMembershipAccumAdjustment] 'SALES ORDER', @SalesOrderGuid

	END

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
