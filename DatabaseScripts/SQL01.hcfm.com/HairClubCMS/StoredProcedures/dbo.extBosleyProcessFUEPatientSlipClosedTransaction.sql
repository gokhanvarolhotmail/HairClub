/***********************************************************************

PROCEDURE:				extBosleyProcessFUEPatientSlipClosedTransaction

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		4/12/16

LAST REVISION DATE: 	4/12/16

--------------------------------------------------------------------------------------------------------
NOTES: 	Processes transactions sent by Bosley.
	* 04/12/2016 MVT - Created
	* 02/14/2017 MVT - Modified to write Adjustment Price as always positive. Modified to write quantity
						as negative if the Total_Due is Negative.
	* 05/23/2018 MVT - Added logic to update email address on datClient if Bosley sent it.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [extBosleyProcessFUEPatientSlipClosedTransaction] @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT

***********************************************************************/

CREATE PROCEDURE [dbo].[extBosleyProcessFUEPatientSlipClosedTransaction]
	  @CurrentTransactionIdBeingProcessed INT,
	  @IsSuccessfullyProcessed BIT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @User nvarchar(25) = 'Bosley-PSCFUE'

	BEGIN TRANSACTION

	BEGIN TRY


		--Current Surgery Client Membership must be in Surgery Performed Status.
		IF NOT EXISTS (SELECT *
					FROM datIncomingRequestLog irl
						INNER JOIN datClient c on irl.ConectID = c.ClientIdentifier
						INNER JOIN datClientMembership cm on cm.ClientMembershipIdentifier = irl.ClientMembershipID
						INNER JOIN cfgMembership m on cm.MembershipID = m.MembershipID
						INNER JOIN lkpClientMembershipStatus cms on cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
						AND cms.ClientMembershipStatusDescriptionShort = 'SP')
			BEGIN
				SET @IsSuccessfullyProcessed = 0
				-- Write Error Message to the IncomingRequestLog Table
				Update datIncomingRequestLog
					SET ErrorMessage = 'Unable to process, Surgery Membership is not in Surgery Performed status.'
						,LastUpdate = GETUTCDATE()
						,LastUpdateUser = @User
				FROM datIncomingRequestLog
				WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
			END
		ELSE
			BEGIN

				DECLARE @BOSLEY_PAYMENT_SALESCODE INT
						,@BOSLEY_REFUND_SALESCODE INT
						,@BOSLEY_ADJUST_SALESCODE INT
						,@BOSLEY_PERFORM_SALESCODE INT
						,@MEMBERSHIP_PAYMENT_SALESCODE INT
						,@BOSLEY_ROOMRESERVATION_SALESCODE INT
						,@BOSLEY_SURGERY_UPDATE INT

				SELECT @BOSLEY_PAYMENT_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMPMT'
				SELECT @BOSLEY_REFUND_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMRFD'
				SELECT @BOSLEY_ROOMRESERVATION_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSRMRES'
				SELECT @BOSLEY_ADJUST_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMADJ'
				SELECT @BOSLEY_PERFORM_SALESCODE = salesCodeID FrOM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSSURGERY'
				SELECT @MEMBERSHIP_PAYMENT_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] WHERE [SalesCodeDescriptionShort] = 'MEMPMT'
				SELECT @BOSLEY_SURGERY_UPDATE = salesCodeID FROM [dbo].[cfgSalesCode] WHERE [SalesCodeDescriptionShort] = 'BOSSURUPT'

				DECLARE @INTERCO_BOSLEY_TENDERTYPEID INT, @MEMBERSHIP_TENDERTYPEID INT

				Select @INTERCO_BOSLEY_TENDERTYPEID = TenderTypeID  from LkpTenderType Where TenderTypeDescriptionShort = 'InterCoBOS'
				Select @MEMBERSHIP_TENDERTYPEID = TenderTypeID  from LkpTenderType Where TenderTypeDescriptionShort = 'Membership'

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

				DECLARE @SalesOrderGUID uniqueidentifier

				-- SET Today's Date
				SET @DateToday = CONVERT(DATE,CONVERT(NVARCHAR,GETDATE(),101))

				-- SET the CenterID
				SELECT @CenterID = centerID
				FROM [dbo].[datClient] c
					INNER JOIN datIncomingRequestLog irl on c.ClientIdentifier = irl.ConectID WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

				-- Get all Payment Records for Procedure
				DECLARE @TOTAL_GRAFTS INT
						,@TOTAL_DUE DECIMAL(21,6)

				SELECT @TOTAL_GRAFTS = ISNULL(MAX(irl.ProcedureGraftCount),0)
						,@TOTAL_DUE = ISNULL(MAX(irl.ProcedureAmount),0)
				FROM datIncomingRequestLog irl
				WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

				SET @SalesOrderGUID = NEWID()

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
						,@MembershipOrder_SalesOrderTypeID as SalesOrderTypeID
						,c.ClientGUID as ClientGUID
						,cm.ClientMembershipGUID  as ClientMembershipGUID
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
						,GETUTCDATE() as ctrOrderDate
						,NULL as CenterFeeBatchGUID
						,NULL as CenterDeclineBatchGUID
						,NULL as RegisterID
						,NULL as EndOfDayGUID
						,irl.IncomingRequestID as IncomingRequestID
					from [dbo].[datIncomingRequestLog] irl
					INNER JOIN [dbo].[datClient] c on irl.ConectID = c.ClientIdentifier
					INNER JOIN [dbo].[datClientMembership] cm on cm.ClientMembershipIdentifier = irl.ClientMembershipID
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

				-- Enter an Bosley Surgery Update
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
					,@BOSLEY_SURGERY_UPDATE as SalesCodeID
					,@TOTAL_GRAFTS as Quantity
					,IIF(@TOTAL_GRAFTS = 0, 0, @TOTAL_DUE / @TOTAL_GRAFTS) as [Price]
					,0 as Discount
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
					,@MEMBERSHIP_TENDERTYPEID as TenderTypeID
					,0 as Amount
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
					,0 as RefundedAmount
					,NULL as MonetraTransactionID
					,1 as EntrySortOrder
					,NULL as CashCollected

				--Update the Accumulators
				EXEC mtnMembershipAccumAdjustment 'SALES ORDER', @SalesOrderGUID


				---------------------------------------
				-- Enter a Sales Order for the Payment
				---------------------------------------
				SET @SalesOrderGUID = NEWID()

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
						,cm.ClientMembershipGUID  as ClientMembershipGUID
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
						,GETUTCDATE() as ctrOrderDate
						,NULL as CenterFeeBatchGUID
						,NULL as CenterDeclineBatchGUID
						,NULL as RegisterID
						,NULL as EndOfDayGUID
						,irl.IncomingRequestID as IncomingRequestID
					from [dbo].[datIncomingRequestLog] irl
					INNER JOIN [dbo].[datClient] c on irl.ConectID = c.ClientIdentifier
					INNER JOIN [dbo].[datClientMembership] cm on cm.ClientMembershipIdentifier = irl.ClientMembershipID
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
						,@BOSLEY_ADJUST_SALESCODE as SalesCodeID
						,IIF(@TOTAL_DUE >= 0, 1, -1) as Quantity
						,ABS(@TOTAL_DUE) as [Price]
						,0 as Discount
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
					,@TOTAL_DUE as Amount
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
					,0 as RefundedAmount
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
						,LastUpdateUser = @User
					FROM datIncomingRequestLog rl
						INNER JOIN datClient c ON c.ClientIdentifier = ConectID
					WHERE rl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
				END


				SET @IsSuccessfullyProcessed = 1
			END

        COMMIT TRANSACTION
	END TRY

	BEGIN CATCH

        ROLLBACK TRANSACTION

		SET @IsSuccessfullyProcessed = 0
		-- Write Error Message to the IncomingRequestLog Table
		Update datIncomingRequestLog
			SET ErrorMessage = Error_Procedure() + ':' + Error_Message()
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @User
		FROM datIncomingRequestLog
		WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
	END CATCH

END
