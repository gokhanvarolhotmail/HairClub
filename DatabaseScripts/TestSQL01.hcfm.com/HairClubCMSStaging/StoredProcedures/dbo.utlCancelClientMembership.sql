/* CreateDate: 04/14/2014 08:01:47.063 , ModifyDate: 05/12/2019 23:28:48.447 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				utlCancelClientMembership
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Mike Tovbin
IMPLEMENTOR: 			Mike Tovbin
DATE IMPLEMENTED: 		03/12/2014
LAST REVISION DATE: 	03/12/2014
--------------------------------------------------------------------------------------------------------
NOTES: 	This utility can be used to cancel specified client Membership. This proc does not do any validation.
		Assumptions:	It is assumed that a client membership in an 'Active' status is passed in.
						It is assumed that a valid consultant is passed in.
						It is assumed that a center Id is passed in
						It is assumed that a valid MembershipOrderReason (for cancel reason) is passed in.

		Optional Parameters:	If User is not passed in, it is defaulted to "util-cancel".

		Following steps are performed:
					1) Client Membership Cancel MO is created
					2) Membership is placed in a Cancelled Status

		03/12/2014 - MVT Created Stored Proc
		09/30/2016 - MVT Modified to Set IsActiveFlag to false on the cancelled membership (TFS 7984)
		03/15/2019 - SAL Modified to cancel Add-Ons for the Client Membership being cancelled. (TFS #12141)
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC utlCancelClientMembership
***********************************************************************/
CREATE PROCEDURE [dbo].[utlCancelClientMembership]
	@ClientMembershipGUID uniqueidentifier,
	@MembershipOrderReasonID int,
	@ConsultantGUID uniqueidentifier,
	@CenterID int,
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
	DECLARE @SalesCodeID int
	DECLARE @CancelAddOnSalesCodeID int
	DECLARE @ClientMembershipAddOnStatusId_Canceled int

	SELECT @Today = DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))

	SELECT @CancelClientMembershipStatusID = ClientMembershipStatusID FROM lkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = 'C'
	SELECT @ClientMembershipAddOnStatusId_Canceled = ClientMembershipAddOnStatusId from lkpClientMembershipAddOnStatus where ClientMembershipAddOnStatusDescriptionShort = 'Canceled'

	SELECT @MembershipTenderTypeID = TenderTypeID FROM lkpTenderType WHERE TenderTypeDescriptionShort = 'Membership'

	SELECT @MOSalesOrderTypeID = SalesOrderTypeID FROM lkpSalesOrderType WHERE SalesOrderTypeDescriptionShort = 'MO'

	SELECT @ClientGUID = ClientGUID FROM datClientMembership WHERE ClientmembershipGUID = @ClientMembershipGUID

	-- Create MO to Cancel Membership, default sales code to 'Cancel' if not specified.
	SET @SalesOrderGUID = NEWID()

	SELECT @SalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'CANCEL'
	SELECT @CancelAddOnSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'CANCELADDON'

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
		,@CancelAddOnSalesCodeID
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
		,(addOn.rn + 1) as EntrySortOrder
		,NULL
		,NULL
		,1
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
	FROM (SELECT cma.ClientMembershipAddOnID, ROW_NUMBER() OVER (PARTITION BY ClientMembershipGUID ORDER BY ClientMembershipAddOnID) AS rn
			FROM datClientMembershipAddOn cma
				inner join lkpClientMembershipAddOnStatus cmaos on cma.ClientMembershipAddOnStatusID = cmaos.ClientMembershipAddOnStatusID
			WHERE cma.ClientMembershipGUID = @ClientMembershipGUID
				and cmaos.ClientMembershipAddOnStatusDescriptionShort = 'Active') AS addOn

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

	-- Update Client Membership to Cancel Status
	UPDATE datClientMembership SET
		ClientMembershipStatusID = @CancelClientMembershipStatusID
		,IsActiveFlag = 0
		,EndDate = CASE WHEN EndDate < @Today THEN EndDate ELSE @Today END
		,LastUpdate = GETUTCDATE()
		,LastUpdateUser = @User
	WHERE ClientMembershipGUID = @ClientMembershipGUID

	-- Update Client Membership's Add-Ons to Canceled Status
	UPDATE cma
	SET ClientMembershipAddOnStatusID = @ClientMembershipAddOnStatusID_Canceled
		,LastUpdate = GETUTCDATE()
		,LastUpdateUser = @User
	FROM datClientMembershipAddOn cma
		inner join lkpClientMembershipAddOnStatus cmaos on cma.ClientMembershipAddOnStatusID = cmaos.ClientMembershipAddOnStatusID
	WHERE cma.ClientMembershipGUID = @ClientMembershipGUID
		and cmaos.ClientMembershipAddOnStatusDescriptionShort = 'Active'
END
GO
