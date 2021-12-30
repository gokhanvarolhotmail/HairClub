/* CreateDate: 02/18/2013 09:37:14.633 , ModifyDate: 03/05/2015 11:36:42.920 */
GO
/*
==============================================================================
PROCEDURE:				dbaInitializeAccountReceivable

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR:

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		02/09/2013

LAST REVISION DATE: 	02/09/2013

==============================================================================
DESCRIPTION: Initializes AR for all clients that have AR for a specific center.
		Clears Accum adjustment records, AR Balance, and client membership accum
		for AR.
==============================================================================
NOTES:
		* 02/09/2013 MVT - Created
		* 03/02/2015 MVT - Updated proc for Xtrands Business Segment

==============================================================================
SAMPLE EXECUTION: EXEC [dbaInitializeAccountReceivable] 205
==============================================================================
*/

CREATE PROCEDURE [dbo].[dbaInitializeAccountReceivable]
	@CenterId int

AS
BEGIN
	SET NOCOUNT ON

	-- Delete datAccountReceivable records for the center
	DELETE arj
	FROM datAccountReceivableJoin arj
		INNER JOIN datAccountReceivable ar ON arj.ARChargeID = ar.AccountReceivableID OR arj.ARPaymentID = ar.AccountReceivableID
		INNER JOIN datClient c ON c.ClientGuid = ar.ClientGuid
	WHERE c.CenterID = @CenterID

	-- Delete AR Detail records for center.
	DELETE ar
	FROM datAccountReceivable ar
		INNER JOIN datClient c ON c.ClientGuid = ar.ClientGuid
	WHERE c.CenterID = @CenterID

	-- Delete AR adjustment records for the center.
	DELETE adj
	FROM datAccumulatorAdjustment adj
		INNER JOIN cfgAccumulator accum ON adj.AccumulatorID = accum.AccumulatorID
		INNER JOIN datClientMembership cm ON cm.ClientMembershipGuid = adj.ClientMembershipGuid
		INNER JOIN datClient c ON c.ClientGuid = cm.ClientGuid
	WHERE accum.AccumulatorDescriptionShort = 'ARBal'
		AND c.CenterID = @CenterID

	-- Reset Client Membership Accum for AR to $0.00
	UPDATE cmaccum SET
		cmaccum.[AccumMoney] = 0.0
		,LastUpdate = GETUTCDATE()
		,LastUpdateUser = 'sa'
	FROM datClientMembershipAccum cmaccum
		INNER JOIN cfgAccumulator accum ON cmaccum.AccumulatorID = accum.AccumulatorID
		INNER JOIN datClientMembership cm ON cm.ClientMembershipGuid = cmaccum.ClientMembershipGuid
		INNER JOIN datClient c ON c.ClientGuid = cm.ClientGuid
	WHERE accum.AccumulatorDescriptionShort = 'ARBal'
		AND c.CenterID = @CenterID

	-- Reset the AR Balance on Client Records to $0.00
	UPDATE c SET
		c.ARBalance = 0.0
		,LastUpdate = GETUTCDATE()
		,LastUpdateUser = 'sa'
	FROM datClient c
	WHERE c.CenterID = @CenterID AND c.ARBalance <> 0

BEGIN TRANSACTION

BEGIN TRY

	--SalesCodeID = 731 ShortDescription = BEGBAL.
	DECLARE @SalesCodeId int = (SELECT SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'BEGBAL')
	DECLARE @InitialCreditId int = (SELECT [AccountReceivableTypeID] FROM [lkpAccountReceivableType] WHERE [AccountReceivableTypeDescriptionShort] = 'InitCredit')
	DECLARE @InitialChargeId int = (SELECT [AccountReceivableTypeID] FROM [lkpAccountReceivableType] WHERE [AccountReceivableTypeDescriptionShort] = 'InitCharge')
	DECLARE @ARTenderTypeId int = (SELECT TenderTypeId FROM lkpTenderType WHERE TenderTypeDescriptionShort = 'AR')
	DECLARE @SalesOrderGuid uniqueidentifier

	DECLARE @TempInvoiceTable table
				(
					InvoiceNumber nvarchar(50)
				)
	DECLARE @InvoiceNumber nvarchar(50)


	--CURSOR VARIABLES
	DECLARE @ClientGuid uniqueidentifier, @ARBalance decimal(12,2), @ClientMembershipGuid uniqueidentifier

	DECLARE CLIENT_CURSOR CURSOR FAST_FORWARD FOR
		SELECT
			cl.ClientGuid
			, (c.Balance - c.PrePaid) AS ARBalance
			, CASE WHEN cl.[CurrentBioMatrixClientMembershipGUID] IS NOT NULL THEN cl.[CurrentBioMatrixClientMembershipGUID]
				WHEN cl.[CurrentSurgeryClientMembershipGUID] IS NOT NULL THEN cl.[CurrentSurgeryClientMembershipGUID]
				WHEN cl.[CurrentExtremeTherapyClientMembershipGUID] IS NOT NULL THEN cl.[CurrentExtremeTherapyClientMembershipGUID]
				WHEN cl.[CurrentXtrandsClientMembershipGUID] IS NOT NULL THEN cl.[CurrentXtrandsClientMembershipGUID]
				ELSE NULL END
		FROM [HCSQL2\SQL2005].INFOSTORE.DBO.[Clients] c
			INNER JOIN datClient cl ON cl.ClientNumber_Temp = c.Client_no AND cl.CenterID = c.Center
		WHERE c.Center = @CenterID AND (c.Balance - c.PrePaid) <> 0

	OPEN CLIENT_CURSOR
	FETCH NEXT FROM CLIENT_CURSOR INTO @ClientGuid, @ARBalance, @ClientMembershipGuid

	WHILE (@@FETCH_STATUS = 0)
		BEGIN
			SET @SalesOrderGuid = NewID()

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
			   ,'sa'
			   ,GETUTCDATE()
			   ,'sa'
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
			   ,'sa'
			   ,GETUTCDATE()
			   ,'sa'
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
			   ,'sa'
			   ,GETUTCDATE()
			   ,'sa'
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
				   ,'sa'
				   ,GETUTCDATE()
				   ,'sa'
				   ,NULL
				   ,NULL)

			EXEC [dbo].[mtnMembershipAccumAdjustment] 'SALES ORDER', @SalesOrderGuid

			FETCH NEXT FROM CLIENT_CURSOR INTO @ClientGuid, @ARBalance, @ClientMembershipGuid
		END
	CLOSE CLIENT_CURSOR
	DEALLOCATE CLIENT_CURSOR


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
