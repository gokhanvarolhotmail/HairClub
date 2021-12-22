/*
==============================================================================
PROCEDURE:				dbaInitializeAccountReceivableForClientLeavingARTransIntact

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR:

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		10/30/2014

LAST REVISION DATE: 	10/30/2014

==============================================================================
DESCRIPTION: Initializes AR for the specified client and AR.
		Clears Accum adjustment records, Client AR Balance, and client membership
		accum for AR.  Leaves all AR detail records in place, but closes any open
		ones and zeroes out their remaining balance.
==============================================================================
NOTES:
		10/30/2014 SAL - Created
		11/07/2014 SAL - Added TFSUser and LogCreateDate to log table
		03/02/2015 MVT - Updated proc for Xtrands Business Segment

==============================================================================
SAMPLE EXECUTION: EXEC [dbaInitializeAccountReceivableForClientLeavingARTransIntact] '607BAAB3-334B-4A1B-AB25-8E28232D082B', 311.00, 'TFS3755'
==============================================================================
*/

CREATE PROCEDURE [dbo].[dbaInitializeAccountReceivableForClientLeavingARTransIntact]
	@ClientGuid uniqueidentifier
	,@InitialARBalance money
	,@User nvarchar(25)

AS
BEGIN
	SET NOCOUNT ON

	DECLARE @ActionTaken nvarchar(255)

	--Create the log table if it doesn't exist
	IF OBJECT_ID('Log4Net.dbo.ARTransOriginalFixedARBal', 'U') IS NULL
	BEGIN
		CREATE TABLE Log4Net.dbo.ARTransOriginalFixedARBal
		(
			AccountReceivableID int
			,ClientGUID nvarchar(255)
			,SalesOrderGUID nvarchar(255)
			,CenterFeeBatchGUID nvarchar(255)
			,Amount money
			,IsClosed bit
			,AccountReceivableTypeID int
			,RemainingBalance money
			,CreateDate datetime
			,CreateUser nvarchar(25)
			,LastUpdate datetime
			,LastUpdateUser nvarchar(25)
			,CenterDeclineBatchGUID nvarchar(255)
			,RefundSalesOrderGUID nvarchar(255)
			,WriteOffSalesOrderGUID nvarchar(255)
			,NSFSalesOrderGUID nvarchar(255)
			,ChareBackSalesOrderGUID nvarchar(255)
			,ActionTaken nvarchar(255)
			,TFSUser nvarchar(25)
			,LogCreateDate datetime
		)
	END

	--
	--Close all open datAccountReceivable records for the client
	--
	SET @ActionTaken = 'Closed'

	--Log the transactions we're updating
	INSERT INTO Log4Net.dbo.ARTransOriginalFixedARBal
	SELECT 	AccountReceivableID
			,ClientGUID
			,SalesOrderGUID
			,CenterFeeBatchGUID
			,Amount
			,IsClosed
			,AccountReceivableTypeID
			,RemainingBalance
			,CreateDate
			,CreateUser
			,LastUpdate
			,LastUpdateUser
			,CenterDeclineBatchGUID
			,RefundedSalesOrderGUID
			,WriteOffSalesOrderGUID
			,NSFSalesOrderGUID
			,ChargeBackSalesOrderGUID
			,@ActionTaken
			,@User
			,GETUTCDATE()
	FROM datAccountReceivable
	WHERE ClientGUID = @ClientGUID
	and IsClosed = 0

	--Update the transactions
	UPDATE datAccountReceivable
	SET	IsClosed = 1
		,LastUpdate = GETUTCDATE()
		,LastUpdateUser = @User
	WHERE ClientGUID = @ClientGUID
	and IsClosed = 0

	--
	--Set all negative Amounts to positive
	--
	SET @ActionTaken = 'Amount set to positive'

	--Log the transactions we're updating
	INSERT INTO Log4Net.dbo.ARTransOriginalFixedARBal
	SELECT 	AccountReceivableID
			,ClientGUID
			,SalesOrderGUID
			,CenterFeeBatchGUID
			,Amount
			,IsClosed
			,AccountReceivableTypeID
			,RemainingBalance
			,CreateDate
			,CreateUser
			,LastUpdate
			,LastUpdateUser
			,CenterDeclineBatchGUID
			,RefundedSalesOrderGUID
			,WriteOffSalesOrderGUID
			,NSFSalesOrderGUID
			,ChargeBackSalesOrderGUID
			,@ActionTaken
			,@User
			,GETUTCDATE()
	FROM datAccountReceivable
	WHERE ClientGUID = @ClientGUID
	and Amount < 0

	--Update the transactions
	UPDATE datAccountReceivable
	SET	Amount = Amount * -1
		,LastUpdate = GETUTCDATE()
		,LastUpdateUser = @User
	WHERE ClientGUID = @ClientGUID
		and Amount < 0

	--
	--Zero out Remaining Balances
	--
	SET @ActionTaken = 'Remaining Balance set to zero'

	--Log the transactions we're updating
	INSERT INTO Log4Net.dbo.ARTransOriginalFixedARBal
	SELECT 	AccountReceivableID
			,ClientGUID
			,SalesOrderGUID
			,CenterFeeBatchGUID
			,Amount
			,IsClosed
			,AccountReceivableTypeID
			,RemainingBalance
			,CreateDate
			,CreateUser
			,LastUpdate
			,LastUpdateUser
			,CenterDeclineBatchGUID
			,RefundedSalesOrderGUID
			,WriteOffSalesOrderGUID
			,NSFSalesOrderGUID
			,ChargeBackSalesOrderGUID
			,@ActionTaken
			,@User
			,GETUTCDATE()
	FROM datAccountReceivable
	WHERE ClientGUID = @ClientGUID
	and RemainingBalance <> 0

	--Update the transactions
	UPDATE datAccountReceivable
	SET	RemainingBalance = 0
		,LastUpdate = GETUTCDATE()
		,LastUpdateUser = @User
	WHERE ClientGUID = @ClientGUID
		and RemainingBalance <> 0

	--
	-- Reset Client Membership Accum for AR to $0.00
	--	(We logged the CMA AR in the hotfix script b4 calling this SP)
	--
	UPDATE cmaccum SET
		cmaccum.AccumMoney = 0.0
		,LastUpdate = GETUTCDATE()
		,LastUpdateUser = @User
	FROM datClientMembershipAccum cmaccum
		INNER JOIN cfgAccumulator accum ON cmaccum.AccumulatorID = accum.AccumulatorID
		INNER JOIN datClientMembership cm ON cm.ClientMembershipGuid = cmaccum.ClientMembershipGuid
		INNER JOIN datClient c ON c.ClientGuid = cm.ClientGuid
	WHERE accum.AccumulatorDescriptionShort = 'ARBal'
		AND c.ClientGuid = @ClientGuid

	--
	-- Reset the AR Balance on Client Records to $0.00
	--	(We logged the Client AR in the hotfix script b4 calling this SP)
	--
	UPDATE c SET
		c.ARBalance = 0.0
		,LastUpdate = GETUTCDATE()
		,LastUpdateUser = @User
	FROM datClient c
	WHERE c.ClientGuid = @ClientGuid

BEGIN TRANSACTION

BEGIN TRY

IF @InitialARBalance <> 0
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
