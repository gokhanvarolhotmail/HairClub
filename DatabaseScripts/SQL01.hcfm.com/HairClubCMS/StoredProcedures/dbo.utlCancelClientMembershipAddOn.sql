/* CreateDate: 09/07/2017 10:35:29.443 , ModifyDate: 09/07/2017 10:35:29.443 */
GO
/***********************************************************************
PROCEDURE:				utlCancelClientMembershipAddOn
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Mike Tovbin
IMPLEMENTOR: 			Mike Tovbin
DATE IMPLEMENTED: 		09/06/2017
LAST REVISION DATE: 	09/06/2017
--------------------------------------------------------------------------------------------------------
NOTES: 	This utility can be used to cancel specified client Membership Add-On. This proc does not do any validation.
		Assumptions:	It is assumed that a client membership Add-On in an 'Active' status is passed in.
						It is assumed that a valid consultant is passed in.
						It is assumed that a center Id is passed in
						It is assumed that a valid MembershipOrderReason (for cancel reason) is passed in.

		Optional Parameters:	If User is not passed in, it is defaulted to "util-cancelAddOn".

		Following steps are performed:
					1) Client Membership Cancel MO is created
					2) Membership is placed in a Cancelled Status

		09/06/2017 - MVT Created Stored Proc
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC utlCancelClientMembershipAddOn
***********************************************************************/
CREATE PROCEDURE [dbo].[utlCancelClientMembershipAddOn]
	@ClientMembershipAddOnID int,
	@MembershipOrderReasonID int,
	@ConsultantGUID uniqueidentifier,
	@User nvarchar(25) = 'util-cancel'

AS
BEGIN

	DECLARE @Today date
	DECLARE @SalesOrderGUID uniqueidentifier
	DECLARE @TempInvoiceTable table
	(
		InvoiceNumber nvarchar(50)
	)
	DECLARE @InvoiceNumber nvarchar(50)
	DECLARE @MOSalesOrderTypeID int
	DECLARE @MembershipTenderTypeID int
	DECLARE @CancelClientMembershipStatusID int
	DECLARE @ClientGUID uniqueidentifier
	DECLARE @ClientMembershipGUID uniqueidentifier
	DECLARE @SalesCodeID int
	DECLARE @CenterID int

	SELECT @Today = DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))

	SELECT @CancelClientMembershipStatusID = ClientMembershipStatusID FROM lkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = 'C'

	SELECT @MembershipTenderTypeID = TenderTypeID FROM lkpTenderType WHERE TenderTypeDescriptionShort = 'Membership'

	SELECT @MOSalesOrderTypeID = SalesOrderTypeID FROM lkpSalesOrderType WHERE SalesOrderTypeDescriptionShort = 'MO'

	SELECT @ClientGUID = c.ClientGUID
			,@CenterID = c.CenterID
			,@ClientMembershipGUID = cm.ClientMembershipGUID
					FROM datClientMembershipAddOn cma
						INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = cma.ClientMembershipGUID
						INNER JOIN datClient c ON c.ClientGUID = cm.ClientGUID
					WHERE cma.ClientMembershipAddOnID = @ClientMembershipAddOnID

	print @CenterID
	print @ClientmembershipAddOnID

	-- Create MO to Cancel Membership, default sales code to 'Cancel' if not specified.
	SET @SalesOrderGUID = NEWID()

	SELECT @SalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'CANCELADDON'

	--create an invoice #
	INSERT INTO @TempInvoiceTable
		EXEC ('mtnGetInvoiceNumber ' + @CenterID)

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
		,@CenterID
		,@CenterID
		,@MOSalesOrderTypeID
		,@ClientGUID
		,@ClientMembershipGUID
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
		,[InterCompanyPrice]
		,[ClientMembershipAddOnID])
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
		,0
		,NULL
		,NULL
		,NULL
		,@ConsultantGUID
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
		,1
		,NULL
		,@MembershipOrderReasonID
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,0
		,NULL
		,@ClientMembershipAddOnID)

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
		,@MembershipTenderTypeID
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

	-- Update Client Membership Add-on to Cancel Status
	UPDATE datClientMembershipAddOn SET
		ClientMembershipAddOnStatusID = st.ClientMembershipAddOnStatusID
		,LastUpdate = GETUTCDATE()
		,LastUpdateUser = @User
	FROM datClientMembershipAddOn cma
		INNER JOIN lkpClientMembershipAddOnStatus st ON st.ClientMembershipAddOnStatusDescriptionShort = 'Canceled'
	WHERE cma.ClientMembershipAddOnID = @ClientMembershipAddOnID

END
GO
