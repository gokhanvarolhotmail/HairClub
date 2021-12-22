/*
==============================================================================
PROCEDURE:				ReduceClientARBalanceWithPMTRCVDSalesOrder

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR:

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		11/12/2014

LAST REVISION DATE: 	11/12/2014

==============================================================================
DESCRIPTION:  Reduce a client's A/R Balance by writing and applying a PMTRCVD sales order
==============================================================================
NOTES:
		11/12/2014 SAL - Created
		03/02/2015 MVT - Updated proc for Xtrands Business Segment

==============================================================================
SAMPLE EXECUTION: EXEC [dbaReduceClientARBalanceWithPMTRCVDSalesOrder] '607BAAB3-334B-4A1B-AB25-8E28232D082B', 1248.00, 'TFS3798'
==============================================================================
*/
CREATE PROCEDURE [dbo].[dbaReduceClientARBalanceWithPMTRCVDSalesOrder]
	@ClientGuid uniqueidentifier,
	@ARPaymentAmount money,
	@User nvarchar(25)

AS
BEGIN
	SET NOCOUNT ON

	DECLARE @SalesCodeId int = (SELECT SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PMTRCVD') --SalesCodeID = 368 ShortDescription = PMTRCVD.
	DECLARE @ARPaymentTypeId int = (SELECT [AccountReceivableTypeID] FROM [lkpAccountReceivableType] WHERE [AccountReceivableTypeDescriptionShort] = 'Payment')
	DECLARE @InterCoTenderTypeId int = (SELECT TenderTypeId FROM lkpTenderType WHERE TenderTypeDescriptionShort = 'InterCo')
	DECLARE @SalesOrderGuid uniqueidentifier, @CenterID int, @ClientMembershipGuid uniqueidentifier

	DECLARE @TempInvoiceTable table
				(
					InvoiceNumber nvarchar(50)
				)
	DECLARE @InvoiceNumber nvarchar(50)

	SET @SalesOrderGuid = NewID()

	SELECT @CenterId = C.[CenterID]
			,@ClientMembershipGUID =  CASE WHEN c.[CurrentBioMatrixClientMembershipGUID] IS NOT NULL THEN c.[CurrentBioMatrixClientMembershipGUID]
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


	BEGIN TRANSACTION

	BEGIN TRY
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
			,1
			,@ARPaymentAmount
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
			,@InterCoTenderTypeId
			,@ARPaymentAmount
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
				,@ARPaymentAmount
				,0
				,@ARPaymentTypeId
				,@ARPaymentAmount
				,GETUTCDATE()
				,@User
				,GETUTCDATE()
				,@User
				,NULL
				,NULL)

		EXEC [dbo].[mtnMembershipAccumAdjustment] 'SALES ORDER', @SalesOrderGuid

		EXEC [dbo].[dbaApplyOpenARDetailsForClient] @ClientGUID, @User

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
