/***********************************************************************

PROCEDURE:				extBosleyProcessCreateBosleyPostEXTPayment

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		10/30/13

LAST REVISION DATE: 	10/30/13

--------------------------------------------------------------------------------------------------------
NOTES: 	Create POSTEXT Payment Sales Order
	* 10/30/13 MLM - Created
	* 01/13/13 MLM - Added Bosley Discount Sales Code
	* 05/20/14 MLM - Need to split the discount between the Bosley Payment and Revenue
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [extBosleyProcessCreateBosleyPostEXTPayment] @CurrentTransactionIdBeingProcessed, @InvoiceNumber, @CenterID, @ClientGUID, @ClientMembershipGUID, @EmployeeGUID, @User, @IsSuccessfullyProcessed OUTPUT

***********************************************************************/

CREATE PROCEDURE [dbo].[extBosleyProcessCreateBosleyPostEXTPayment]
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

			DECLARE @POSTEXTPMT nvarchar(10) = 'BOSEXTPMT'
					,@BOSEXTDIS nvarchar(10) = 'BOSEXTDIS'
					,@POSTEXTPMT_ID int
					,@BOSEXTDIS_ID int
					,@PAYAMOUNT_LIMIT decimal(21,6)

			Select @POSTEXTPMT_ID = SalesCodeID, @PAYAMOUNT_LIMIT = PriceDefault FROM cfgSalesCode where SalesCodeDescriptionShort = @POSTEXTPMT
			Select @BOSEXTDIS_ID = SalesCodeID FROM cfgSalesCode Where SalesCodeDescriptionShort = @BOSEXTDIS
			Select @PAYAMOUNT_LIMIT = m.ContractPrice FROM datClientMembership cm inner join cfgMembership m on cm.MembershipID = m.MembershipID WHERE cm.ClientMembershipGUID = @ClientMembershipGUID

			DECLARE @PaymentAmount decimal(21,6)
					,@POSTEXTPMT_Amount decimal(21,6)
					,@BOSEXTDIS_Amount decimal(21,6) = CAST(0 as decimal(21,6))
					,@Gender nvarchar(1)
					,@Payment_Male decimal(21,6) = 2195
					,@Payment_Female decimal(21,6) = 2495
					,@Payment decimal(21,6) = 0
					,@Discount_Amount decimal(21,6) = 0

			-- Need to determine payment Amount, Only allowed to charge $1495 to POSTEXTPMT
			SELECT @PaymentAmount = irl.PaymentAmount, @Gender = Gender FROM [dbo].[datIncomingRequestLog] irl WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

			-- Determine the discounted amount from Full Price.  The total amount discounted will be split between Bosley EXT 9 Payment and Bosley Revenue
			IF (@PaymentAmount > 0)
				BEGIN
					IF (@Gender = 'F')
						BEGIN
							SET @Payment = @Payment_Female
							IF (@Payment_Female > @PaymentAmount)
								SET @Discount_Amount = (@Payment_Female - @PaymentAmount) / 2
						END
					ELSE
						BEGIN
							SET @Payment = @Payment_Male
							IF ( @Payment_Male > @PaymentAmount)
								SET @Discount_Amount = (@Payment_Male - @PaymentAmount) / 2
						END
				END


			IF @PaymentAmount > @PAYAMOUNT_LIMIT
				BEGIN
					SET @POSTEXTPMT_Amount = @PAYAMOUNT_LIMIT
					SET @BOSEXTDIS_Amount = @Payment - @PAYAMOUNT_LIMIT
				END

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
				,GETUTCDATE() as OrderDate
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
				,GETUTCDATE() as CreateDate
				,@User as CreateUser
				,GETUTCDATE() as LastUpdate
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
				,CAST(ISNULL(@POSTEXTPMT_Amount,0) as decimal(21,2)) as [Price]
				,@Discount_Amount as Discount
				,NULL as Tax1
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
				,GETUTCDATE() as CreateDate
				,@User as CreateUser
				,GETUTCDATE() as LastUpdate
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
				INNER JOIN datClient c on irl.SiebelID = c.SiebelID
				LEFT OUTER JOIN cfgSalesCodeCenter scc on c.CenterID = scc.CenterID
							AND scc.SalesCodeID = @POSTEXTPMT_ID
				LEFT OUTER JOIN cfgCenterTaxRate ctr on scc.TaxRate1ID = ctr.CenterTaxRateID
			WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

			-- Add Discount Amount
			IF @BOSEXTDIS_Amount > CAST(0 as decimal(21,6))
				BEGIN
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
						,@BOSEXTDIS_ID as SalesCodeID
						,1 as Quantity
						,CAST(ISNULL(@BOSEXTDIS_Amount,0) as decimal(21,2)) as [Price]
						,@Discount_Amount as Discount
						,NULL as Tax1
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
						,GETUTCDATE() as CreateDate
						,@User as CreateUser
						,GETUTCDATE() as LastUpdate
						,@User as LastUpdateUser
						,NULL as Center_Temp
						,NULL as performer_temp
						,NULL as performer2_temp
						,NULL as Member1Price_temp
						,NULL as CancelReasonID
						,2 as EntrySortOrder
						,NULL as HairSystemOrderGUID
						,NULL as DiscountTypeID
						,1 as BenefitTrackingEnabledFlag
						,NULL as MembershipPromotionID
						,NULL as MembershipOrderReasonID
						,NULL as MembershipNotes
						,NULL as genericSalesCodeDescription
						,NULL as SalesCodeSerialNumber
					from [dbo].[datIncomingRequestLog] irl
						INNER JOIN datClient c on irl.SiebelID = c.SiebelID
						LEFT OUTER JOIN cfgSalesCodeCenter scc on c.CenterID = scc.CenterID
									AND scc.SalesCodeID = @BOSEXTDIS_ID
						LEFT OUTER JOIN cfgCenterTaxRate ctr on scc.TaxRate1ID = ctr.CenterTaxRateID
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
				END


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
				,@PaymentAmount as Amount
				,NULL as CheckNumber
				,NULL as CreditCardLast4Digits
				,NULL as ApprovalCode
				,NULL as CreditCardTypeID
				,NULL as FinanceCompanyID
				,NULL as InterCompanyReasonID
				,GETUTCDATE() as CreateDAte
				,@User as CreateUser
				,GETUTCDATE() as LastUpdate
				,@User as LastUpdateUser
				,IIF(ISNULL(@POSTEXTPMT_Amount,0) < 0, @POSTEXTPMT_Amount,NULL) as RefundedAmount
				,NULL as MonetraTransactionID
				,1 as EntrySortOrder
				,NULL as CashCollected
			from [dbo].[datIncomingRequestLog] irl
			WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

			--Update the Accumulators
			EXEC mtnMembershipAccumAdjustment 'SALES ORDER', @SalesOrderGUID

			SET @IsSuccessfullyProcessed = 1

END
