/***********************************************************************

PROCEDURE:				extBosleyProcessPaymentTransaction

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		4/30/13

LAST REVISION DATE: 	4/30/13

--------------------------------------------------------------------------------------------------------
NOTES: 	Processes transactions sent by Bosley.
	* 4/30/13 MLM - Created
	* 5/07/13 MLM - Added ConsultantUserName to the IncomingRequestLog
	* 5/22/13 MLM - Added IncomingRequestID to the datSalesOrder Table
	* 5/23/13 MLM - Skip processing Payment if PaymentType = 'HCPAYMENT'
	* 6/03/13 MVT - Modified to use Invoice Number proc.
	* 6/20/13 MVT - Modified to use Current Surgery Membership instead of the
					membership sent back by Bosley.
	* 6/1/17 PRM  - Removed try/catch and transactional logic and handling it in the main proc to avoid transactional errors
	* 5/24/18 MVT - Added logic to update email if sent by Bosley.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [extBosleyProcessPaymentTransaction] @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT

***********************************************************************/

CREATE PROCEDURE [dbo].[extBosleyProcessPaymentTransaction]
	  @CurrentTransactionIdBeingProcessed INT,
	  @IsSuccessfullyProcessed BIT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

			DECLARE @HCPAYMENT VARCHAR(10) = 'HCPAYMENT'

			-- HCPayments are not processed.
			IF NOT EXISTS (SELECT * FROM datIncomingRequestLog irl Where irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed AND irl.PaymentType = @HCPAYMENT)
				BEGIN

					DECLARE @SalesOrderGUID uniqueidentifier = NEWID()

					DECLARE @BOSLEY_PAYMENT_SALESCODE INT
							,@BOSLEY_REFUND_SALESCODE INT

					SELECT @BOSLEY_PAYMENT_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMPMT'
					SELECT @BOSLEY_REFUND_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMRFD'

					DECLARE @INTERCO_BOSLEY_TENDERTYPEID INT

					Select @INTERCO_BOSLEY_TENDERTYPEID = TenderTypeID  from LkpTenderType Where TenderTypeDescriptionShort = 'InterCoBOS'

					DECLARE @EmployeeGUID Uniqueidentifier
					SELECT @EmployeeGUID = e.EmployeeGUID FROM datEmployee e inner join datIncomingRequestLog irl on e.UserLogin = LEFT(irl.ConsultantUserName,CHARINDEX('_',irl.ConsultantUserName)-1) Where irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

					-- SalesOrderType
					DECLARE @MembershipOrder_SalesOrderTypeID INT, @SalesOrder_SalesOrderTypeID INT
					SELECT @SalesOrder_SalesOrderTypeID = SalesOrderTypeID FROM [dbo].[LkpSalesOrderType] Where SalesOrderTypeDescriptionShort = 'SO'
					SELECT @MembershipOrder_SalesOrderTypeID = SalesOrderTypeID FROM [dbo].[LkpSalesOrderType] Where SalesOrderTypeDescriptionShort = 'MO'

					DECLARE @CenterID int, @DateToday datetime
					DECLARE @TempInvoiceTable table
					(
						InvoiceNumber nvarchar(50)
					)
					DECLARE @InvoiceNumber nvarchar(50)

					-- SET Today's Date
					SET @DateToday = CONVERT(DATE,CONVERT(NVARCHAR,GETDATE(),101))

					-- SET the CenterID
					SELECT @CenterID = centerID FROM [dbo].[datClient] c INNER JOIN datIncomingRequestLog irl on c.ClientIdentifier = irl.ConectID WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed


					--create an invoice #
					INSERT INTO @TempInvoiceTable
						EXEC ('mtnGetInvoiceNumber ' + @CenterID)

					SELECT TOP 1 @InvoiceNumber = InvoiceNumber
					FROM @TempInvoiceTable

					DELETE FROM @TempInvoiceTable


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
						,c.CenterID as CenterID
						,c.CenterID as ClientHomeCenterID
						,@SalesOrder_SalesOrderTypeID as SalesOrderTypeID
						,c.ClientGUID as ClientGUID
						,cm.ClientMembershipGUID as ClientMembershipGUID
						,NULL as AppointmentGUID
						,NULL as HairSystemOrderGUID
						,irl.[PaymentDate] as OrderDate
						,@InvoiceNumber as InvoiceNumber
						,0 as IsTaxExemptFlag
						,0 as IsVoidedFlag
						,1 as IsClosedFlag
						,NULL as RegisterCloseGUID
						,@EmployeeGUID as EmployeeGUID
						,NULL as FulfillmentNumber
						,0 as IsWrittenOffFlag
						,IIF(ISNULL(irl.PaymentAmount,0) < 0, 1, 0) as IsRefundedFlag
						,NULL as RefundedSalesOrderGUID
						,GETDATE() as CreateDate
						,'BosleyPayment' as CreateUser
						,GETDATE() as LastUpdate
						,'BosleyPayment' as LastUpdateUser
						,NULL as ParentSalesOrderGUID
						,0 as IsSurgeryReversalFlag
						,0 as IsGuaranteeFlag
						,NULL as cashier_temp
						,irl.PaymentDate as ctrOrderDate
						,NULL as CenterFeeBatchGUID
						,NULL as CenterDeclineBatchGUID
						,NULL as RegisterID
						,NULL as EndOfDayGUID
						,irl.IncomingRequestID as IncomingRequestID
					from [dbo].[datIncomingRequestLog] irl
					INNER JOIN [dbo].[datClient] c on irl.ConectID = c.ClientIdentifier
					INNER JOIN [dbo].[datClientMembership] cm on c.[CurrentSurgeryClientMembershipGUID] = cm.ClientMembershipGuid
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
						,IIF(ISNULL(irl.PaymentAmount,0) < 0, @BOSLEY_REFUND_SALESCODE, @BOSLEY_PAYMENT_SALESCODE) as SalesCodeID
						,1 as Quantity
						,irl.PaymentAmount as [Price]
						,0 as Discount
						,NULL as Tax1
						,NULL as Tax2
						,0 as TaxRate1
						,0 as TaxRate2
						,IIF(ISNULL(irl.PaymentAmount,0) < 0, 1, 0) as IsRefundedFlag
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
						,'Bosley' as CreateUser
						,GETDATE() as LastUpdate
						,'Bosley' as LastUpdateUser
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
						,'Bosley' as CreateUser
						,GETDATE() as LastUpdate
						,'Bosley' as LastUpdateUser
						,IIF(ISNULL(irl.PaymentAmount,0) < 0, irl.PaymentAmount,NULL) as RefundedAmount
						,NULL as MonetraTransactionID
						,1 as EntrySortOrder
						,NULL as CashCollected
					from [dbo].[datIncomingRequestLog] irl
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

					--Update the Accumulators
					EXEC mtnMembershipAccumAdjustment 'SALES ORDER', @SalesOrderGUID


					-- Update Client email if Sent by Bosley
					DECLARE @EmailAddress AS nvarchar(100)

					SELECT @EmailAddress = rl.EmailAddress
					FROM datIncomingRequestLog rl
						INNER JOIN datClient c ON c.ClientIdentifier = ConectID
					WHERE rl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
						AND (c.EmailAddress IS NULL OR c.EmailAddress = '')

					IF (@EmailAddress IS NOT NULL AND @EmailAddress <> '')
					BEGIN
						UPDATE c SET
							EmailAddress = @EmailAddress
							,LastUpdate = GETUTCDATE()
							,LastUpdateUser = 'BosleyPayment'
						FROM datIncomingRequestLog rl
							INNER JOIN datClient c ON c.ClientIdentifier = ConectID
						WHERE rl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
					END
				END

			SET @IsSuccessfullyProcessed = 1

END
