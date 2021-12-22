/***********************************************************************

PROCEDURE:				extBosleyProcessCreatePostEXTPayment

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		7/17/13

LAST REVISION DATE: 	7/17/13

--------------------------------------------------------------------------------------------------------
NOTES: 	Create POSTEXT Payment Sales Order
	* 7/17/13 MLM - Created
	* 7/21/13 MLM  - Set the Order Date to the CreateDate of the datIncomingRequestLog Record.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [extBosleyProcessCreatePostEXTPayment] @CurrentTransactionIdBeingProcessed, @InvoiceNumber, @CenterID, @ClientGUID, @ClientMembershipGUID, @EmployeeGUID, @User, @IsSuccessfullyProcessed OUTPUT

***********************************************************************/

CREATE PROCEDURE [dbo].[extBosleyProcessCreatePostEXTPayment]
	  @CurrentTransactionIdBeingProcessed int,
	  @InvoiceNumber nvarchar(50),
	  @CenterID int,
	  @ClientGUID char(36),
	  @ClientMembershipGUID char(36),
	  @EmployeeGUID char(36),
	  @User nvarchar(10),
	  @IsSuccessfullyProcessed BIT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;


			DECLARE @SalesOrderGUID char(36)

			-------------------------------------------
			--  Create SO for the Membership Payment
			--------------------------------------------
			SET @SalesOrderGUID = NEWID()

			-- SalesOrderType
			DECLARE @SalesOrder_SalesOrderTypeID INT
			SELECT @SalesOrder_SalesOrderTypeID = SalesOrderTypeID FROM [dbo].[LkpSalesOrderType] Where SalesOrderTypeDescriptionShort = 'SO'

			DECLARE @INTERCO_BOSLEY_TENDERTYPEID INT
			Select @INTERCO_BOSLEY_TENDERTYPEID = TenderTypeID  from LkpTenderType Where TenderTypeDescriptionShort = 'InterCoBOS'

			DECLARE @POSTEXTPMT nvarchar(10) = 'POSTEXTPMT'
					,@POSTEXTPMT_ID int

			Select @POSTEXTPMT_ID = SalesCodeID FROM cfgSalesCode where SalesCodeDescriptionShort = @POSTEXTPMT

			DECLARE @PaymentAmount decimal(21,6)
					,@TaxAmount money


			INSERT INTO [dbo].[datSalesOrder] (
						SalesOrderGUID
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
			Select @SalesOrderGUID as SalesOrderGUID
				,NULL as TenderTransactionNumber_Temp
				,NULL as TicketNumber_Temp
				,@CenterID as CenterID
				,@CenterID as ClientHomeCenterID
				,@SalesOrder_SalesOrderTypeID as SalesOrderTypeID
				,@ClientGUID as ClientGUID
				,@ClientMembershipGUID as ClientMembershipGUID
				,NULL as AppointmentGUID
				,NULL as HairSystemOrderGUID
				,irl.[CreateDate] as OrderDate
				,@InvoiceNumber as InvoiceNumber
				,0 as IsTaxExemptFlag
				,0 as IsVoidedFlag
				,1 as IsClosedFlag
				,NULL as RegisterCloseGUID
				,@EmployeeGUID as EmployeeGUID
				,NULL as FulfillmentNumber
				,0 as IsWrittenOffFlag
				,0 as IsRefundedFlag
				,NULL as RefundedSalesOrderGUID
				,GETDATE() as CreateDate
				,@User as CreateUser
				,GETDATE() as LastUpdate
				,@User as LastUpdateUser
				,NULL as ParentSalesOrderGUID
				,0 as IsSurgeryReversalFlag
				,0 as IsGuaranteeFlag
				,NULL as cashier_temp
				,irl.CreateDate as ctrOrderDate
				,NULL as CenterFeeBatchGUID
				,NULL as CenterDeclineBatchGUID
				,NULL as RegisterID
				,NULL as EndOfDayGUID
				,irl.IncomingRequestID as IncomingRequestID
			from [dbo].[datIncomingRequestLog] irl
			WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

			INSERT INTO datSalesOrderDetail (
				SalesOrderDetailGUID
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
			SELECT NEWID() as SalesOrderDetailGUID
				,NULL as TransactionNumber_Temp
				,@SalesOrderGUID as SalesOrderGUID
				,@POSTEXTPMT_ID as SalesCodeID
				,1 as Quantity
				,CAST((ISNULL(irl.PaymentAmount,0) / (1 + ISNULL(ctr.TaxRate,0))) as decimal(21,2)) as [Price]
				,0 as Discount
				,CAST(ISNULL(irl.PaymentAmount,0) - (ISNULL(irl.PaymentAmount,0) / (1 + ISNULL(ctr.TaxRate,0))) as decimal(21,2)) as Tax1
				,NULL as Tax2
				,0 as TaxRate1
				,0 as TaxRate2
				,0 as IsRefundedFlag
				,NULL as RefundedSalesORderDetailGUID
				,NULL as RefundedTotalQuantity
				,NULL as RefundedTotalPrice
				,@EmployeeGUID as Employee1GUID
				,NULL as Employee2GUID
				,NULL as Employee3GUID
				,NULL as Employee4GUID
				,NULL as previousClientMembershipGUID
				,NULL as NewCenterID
				,GETDATE() as CreateDate
				,@User as CreateUser
				,GETDATE() as LastUpdate
				,@User as LastUpdateUser
				,NULL as Center_Temp
				,NULL as performer_temp
				,NULL as performer2_temp
				,NULL as Member1Price_temp
				,NULL as CancelReasonID
				,1 as EntrySortOrder
				,NULL as HairSystemOrderGUID
				,NULL as DiscountTypeID
				,1 as BenefitTrackingEnabledFlag
				,NULL as MembershipPromotionID
				,NULL as MembershipOrderReasonID
				,NULL as MembershipNotes
				,NULL as genericSalesCodeDescription
				,NULL as SalesCodeSerialNumber
			from [dbo].[datIncomingRequestLog] irl
				INNER JOIN datClient c on irl.ConectID = c.ClientIdentifier
				LEFT OUTER JOIN cfgSalesCodeCenter scc on c.CenterID = scc.CenterID
							AND scc.SalesCodeID = @POSTEXTPMT_ID
				LEFT OUTER JOIN cfgCenterTaxRate ctr on scc.TaxRate1ID = ctr.CenterTaxRateID
			WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

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
				,LastUpdate
				,LastUpdateUser
				,RefundAmount
				,MonetraTransactionId
				,EntrySortOrder
				,CashCollected)
			SELECT NEWID() as SalesOrderTenderGUID
				,@SalesOrderGUID as SalesOrderGUID
				,@INTERCO_BOSLEY_TENDERTYPEID as TenderTypeID
				,irl.PaymentAmount as Amount
				,NULL as CheckNumber
				,NULL as CreditCardLast4Digits
				,NULL as ApprovalCode
				,NULL as CreditCardTypeID
				,NULL as FinanceCompanyID
				,NULL as InterCompanyReasonID
				,GETDATE() as CreateDAte
				,@User as CreateUser
				,GETDATE() as LastUpdate
				,@User as LastUpdateUser
				,IIF(ISNULL(irl.PaymentAmount,0) < 0, irl.PaymentAmount,NULL) as RefundedAmount
				,NULL as MonetraTransactionID
				,1 as EntrySortOrder
				,NULL as CashCollected
			from [dbo].[datIncomingRequestLog] irl
			WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

			--Update the Accumulators
			EXEC mtnMembershipAccumAdjustment 'SALES ORDER', @SalesOrderGUID

			SET @IsSuccessfullyProcessed = 1


END
