/*
==============================================================================
PROCEDURE:                  mtnClientCenterTransfer

DESTINATION SERVER:         SQL01

DESTINATION DATABASE:		HairClubCMS

RELATED APPLICATION:		CMS

AUTHOR:                     Michael Maass

IMPLEMENTOR:                Michael Maass

DATE IMPLEMENTED:           12/19/2013

LAST REVISION DATE:			12/19/2013

==============================================================================
DESCRIPTION:      Transfers a Client to a new Center
==============================================================================
NOTES:
            * 12/19/2013 MLM - Created Stored Proc
			* 02/04/2015 RMH - Added CurrentXtrandsClientMembershipGUID in two places
			* 03/02/2015 MVT - Updates for Xtrands Business Segment
			* 05/27/2016 MVT - *** OBSOLETE - USE mtnTransferClient PROC

==============================================================================
SAMPLE EXECUTION:
EXEC mtnClientCenterTransfer 420603, 260, 'TFS2448'
==============================================================================
*/

CREATE PROCEDURE [dbo].[mtnClientCenterTransfer]
	  @ClientIdentifier int,
	  @NewCenterID int,
	  @TFS_ITEM nvarchar(25)
AS
BEGIN

		IF (@TFS_ITEM = null or LEN(RTRIM(LTRIM(@TFS_ITEM))) = 0)
			BEGIN
				SET @TFS_ITEM = 'sa'
			END

		--Update the current Client Memberships
		DECLARE @ClientGUID char(36)
				,@ClientMembershipGUID char(36)
				,@IsTaxExemptFlag bit

		--Get the ClientGUID
		SELECT @ClientGUID = ClientGUID, @ClientMembershipGUID = COALESCE(CurrentBioMatrixClientMembershipGUID, CurrentExtremeTherapyClientMembershipGUID,CurrentSurgeryClientMembershipGUID, CurrentXtrandsClientMembershipGUID), @IsTaxExemptFlag = IsTaxExemptFlag FROM datClient Where ClientIdentifier = @ClientIdentifier

		Update cm
			SET CenterID = @NewCenterID
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = ISNULL(@TFS_ITEM,'sa')
		From datClientMembership cm
			inner join datClient c on cm.ClientMembershipGUID = c.CurrentBioMatrixClientMembershipGUID
		Where c.ClientGUID = @ClientGUID

		Update cm
			SET CenterID = @NewCenterID
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = ISNULL(@TFS_ITEM,'sa')
		From datClientMembership cm
			inner join datClient c on cm.ClientMembershipGUID = c.CurrentExtremeTherapyClientMembershipGUID
		Where c.ClientGUID = @ClientGUID

		Update cm
			SET CenterID = @NewCenterID
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = ISNULL(@TFS_ITEM,'sa')
		From datClientMembership cm
			inner join datClient c on cm.ClientMembershipGUID = c.CurrentSurgeryClientMembershipGUID
		Where c.ClientGUID = @ClientGUID

		Update cm
			SET CenterID = @NewCenterID
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = ISNULL(@TFS_ITEM,'sa')
		From datClientMembership cm
			inner join datClient c on cm.ClientMembershipGUID = c.CurrentXtrandsClientMembershipGUID
		Where c.ClientGUID = @ClientGUID

		Update datClient
			SET CenterID = @NewCenterID
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = ISNULL(@TFS_ITEM,'sa')
		From datClient
		Where ClientGUID = @ClientGUID


		DECLARE @MembershipOrderReasonID int
		Select @MembershipOrderReasonID = MembershipOrderReasonID From LkpMembershipOrderReason Where MembershipOrderReasonDescriptionShort = 'AUTO'

		DECLARE @Transfer_SalesCodeID int
		SELECT @Transfer_SalesCodeID = SalesCodeID FrOM cfgSalesCode Where SalesCodeDescriptionShort = 'CTRXFER'


			-- SalesOrder Variables
			DECLARE @SalesOrderGUID Uniqueidentifier = newid()
					,@SalesOrderType_Membership int
					,@EmployeeGUID uniqueidentifier
					,@TenderTypeID int


			Select @SalesOrderType_Membership = SalesOrderTypeID From lkpSalesOrderType Where SalesOrderTypeDescriptionShort = 'MO'
			Select @EmployeeGUID = EmployeeGUID From datEmployee Where UserLogin = 'aptak'
			Select @TenderTypeID = TenderTypeID from LkpTenderType where TenderTypeDescriptionShort = 'Membership'


			DECLARE @TempInvoiceTable table
								(
									InvoiceNumber nvarchar(50)
								)
			DECLARE @InvoiceNumber nvarchar(50)

			--create an invoice #
			INSERT INTO @TempInvoiceTable
			EXEC ('mtnGetInvoiceNumber ' + @NewCenterID)

			SELECT TOP 1 @InvoiceNumber = InvoiceNumber
			FROM @TempInvoiceTable

			DELETE FROM @TempInvoiceTable


		--INSERT Sales Order
		INSERT INTO datSalesOrder(SalesOrderGUID
					,TenderTransactionNumber_Temp
					,TicketNumber_Temp
					,CenterID
					,ClientHomeCenterID
					,SalesOrderTypeID
					,ClientGUID
					,ClientMembershipGUID
					,AppointmentGUID
					,HairSystemOrderGUID
					,OrderDate
					,InvoiceNumber
					,IsTaxExemptFlag
					,IsVoidedFlag
					,IsClosedFlag
					,RegisterCloseGUID
					,EmployeeGUID
					,FulfillmentNumber
					,IsWrittenOffFlag
					,IsRefundedFlag
					,RefundedSalesOrderGUID
					,CreateDate
					,CreateUser
					,LastUpdate
					,LastUpdateUser
					,ParentSalesOrderGUID
					,IsSurgeryReversalFlag
					,IsGuaranteeFlag
					,cashier_temp
					,ctrOrderDate
					,CenterFeeBatchGUID
					,CenterDeclineBatchGUID
					,RegisterID
					,EndOfDayGUID
					,IncomingRequestID)
		VALUES( @SalesOrderGUID
				,NULL --TenderTransationNumber_Temp
				,NULL --TicketNumber_Temp
				,@NewCenterID -- CenterID
				,@NewCenterID --ClientHomeCenterID
				,@SalesOrderType_Membership --SalesOrderTypeID
				,@ClientGUID -- ClientGUID
				,@ClientMembershipGUID --ClientMembershipGUID
				,NULL -- AppointmentGUID
				,NULL -- HairSystemOrderGUID
				,GETUTCDATE() -- OrderDate
				,@InvoiceNumber --InvoiceNumber
				,@IsTaxExemptFlag -- IsTaxExemptFlag
				,0 --IsVoidedFlag
				,1 --IsClosedFlag
				,NULL --RegisterCloseGUID
				,@EmployeeGUID --EmployeeGuID
				,NULL --FulfillmentNumber
				,0 --IsWrittenOffFlag
				,0 --IsRefundedFlag
				,NULL -- RefundedSalesOrderGUID
				,GETUTCDATE() --CreateDate
				,@TFS_ITEM   --CreateUser
				,GETUtCDATE()  --LastUpdate
				,@TFS_ITEM  -- LastUpdateUser
				,NULL --ParentSalesOrderGUID
				,0 --IsSurgeryReversalFlag
				,NULL --IsGuaranteeFlag
				,NULL -- cashier_temp
				,GETUTCDATE() --ctrOrderDate
				,NULL --CenterFeeBatchGUID
				,NULL --CenterDeclineBatchGUID
				,NULL --RegisterID
				,NULL --EndOfDayGUID
				,NULL --IncomingRequestID
				)


		--Insert SalesOrderDetail
		INSERT INTO datSalesOrderDetail(SalesOrderDetailGUID
				,TransactionNumber_Temp
				,SalesOrderGUID
				,SalesCodeID
				,Quantity
				,Price
				,Discount
				,Tax1
				,Tax2
				,TaxRate1
				,TaxRate2
				,IsRefundedFlag
				,RefundedSalesOrderDetailGUID
				,RefundedTotalQuantity
				,RefundedTotalPrice
				,Employee1GUID
				,Employee2GUID
				,Employee3GUID
				,Employee4GUID
				,PreviousClientMembershipGUID
				,NewCenterID
				,CreateDate
				,CreateUser
				,LastUpdate
				,LastUpdateUser
				,Center_Temp
				,performer_temp
				,performer2_temp
				,Member1Price_temp
				,CancelReasonID
				,EntrySortOrder
				,HairSystemOrderGUID
				,DiscountTypeID
				,BenefitTrackingEnabledFlag
				,MembershipPromotionID
				,MembershipOrderReasonID
				,MembershipNotes
				,GenericSalesCodeDescription
				,SalesCodeSerialNumber)
		VALUES(NEWID()
				,NULL
				,@SalesOrderGUID
				,@Transfer_SalesCodeID
				,0 --Quantity
				,0 --Price
				,0 --Discount
				,0 --Tax1
				,0 --Tax2
				,0 --TaxRate1
				,0 --TaxRate2
				,0 --IsRefundedFlag
				,NULL
				,NULL
				,NULL
				,@EmployeeGUID
				,NULL --Employee2GUID
				,NULL --Employee3GUID
				,NULL --Employee4GUID
				,NULL --PreviousClientMembershipGUID
				,@NewCenterID --NewCenterID
				,GETUTCDATE()
				,@TFS_ITEM
				,GETUTCDATE()
				,@TFS_ITEM
				,NULL --Center_Temp
				,NULL --performer_temp
				,NULL --perfomer2_temp
				,NULL --Member1Price_temp
				,NULL --CancelReasonID
				,1 --EntrySortOrder
				,NULL --HairSystemOrderGUID
				,NULL --DiscountTypeID
				,1 --BenefitTrackingEnabledFlag
				,NULL --MembershipPromotionID
				,@MembershipOrderReasonID --MembershipOrderReasonID
				,NULL --MembershipNotes
				,NULL --GenericSalesCodeDescription
				,NULL --SalesCodeSerialNumber
				)


			--INSERT INTO datSalesOrderTender
			INSERT INTO datSalesOrderTender(
					SalesOrderTenderGUID
					,SalesOrderGUID
					,TenderTypeID
					,Amount
					,CheckNumber
					,CreditCardLast4Digits
					,ApprovalCode
					,CreditCardTypeID
					,FinanceCompanyID
					,InterCompanyReasonID
					,CreateDate
					,CreateUser
					,LastUPdate
					,LastUpdateUser
					,RefundAmount
					,MonetraTransactionID
					,EntrySortOrder
					,CashCollected)
			VALUES(
				NEWID()
				,@SalesOrderGUID
				,@TenderTypeID
				,0
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,GETUTCDATE()
				,@TFS_ITEM
				,GETUTCDATE()
				,@TFS_ITEM
				,NULL
				,NULL
				,1
				,NULL)

				-- Call the Accum Stored Proc
				EXEC [dbo].[mtnMembershipAccumAdjustment] 'SALES ORDER', @SalesOrderGUID

END
