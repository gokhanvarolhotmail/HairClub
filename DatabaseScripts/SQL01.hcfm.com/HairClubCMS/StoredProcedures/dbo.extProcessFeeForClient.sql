/* CreateDate: 05/14/2012 17:34:58.177 , ModifyDate: 09/17/2017 18:32:58.513 */
GO
/***********************************************************************
		PROCEDURE:				[extProcessFeeForClient]
		DESTINATION SERVER:		SQL01
		DESTINATION DATABASE: 	HairClubCMS
		RELATED APPLICATION:  	CMS
		AUTHOR: 				MMaass
		IMPLEMENTOR: 			MMaass
		DATE IMPLEMENTED: 		03/30/2012
		LAST REVISION DATE: 	03/30/2012
		--------------------------------------------------------------------------------------------------------
		NOTES: 	Processes Fee for a Client
				03/20/2012 - MMaass Created Stored Proc
				09/17/2017 - SAL	Replaced code that generated the Invoice Number with a call to the mtnGetInvoiceNumber stored proc
		--------------------------------------------------------------------------------------------------------
		SAMPLE EXECUTION:
		EXEC [extProcessFeeForClient]
		***********************************************************************/
		CREATE PROCEDURE [dbo].[extProcessFeeForClient]
				@CenterID int,
				@ClientGUID uniqueIdentifier,
				@ClientMembershipGUID uniqueIdentifier,
				@EmployeeGUID uniqueIdentifier,
				@CenterFeeBatchGUID uniqueIdentifier,
				@CenterDeclineBatchGUID uniqueIdentifier,
				@HCUSER nvarchar(25),
				@SalesCodeDescriptionShort nvarchar(15),
				@Price decimal(21,6),
				@TaxRate1 decimal(6,5),
				@TenderTypeDescriptionShort nvarchar(15),
				@Amount money,
				@CreditCardLast4Digits nvarchar(4),
				@ApprovalCode nvarchar(100),
				@CreditCardTypeDescriptionShort nvarchar(15),
				@MonetraTransactionID int,
				@Verbiage nvarchar(100),
				@SoftCode nvarchar(30),
				@HardCoce nvarchar(30),
				@ExpirationDate nvarchar(10),
				@PayCycleTransactionTypeDescriptionShort nvarchar(15),
				@IsSuccessfulFlag bit,
				@AVSResult nvarchar(20),
				@HCStatusCode nvarchar(1),
				@AccountReceivableTypeDescriptionShort nvarchar(15)

		AS
		BEGIN
			-- SET NOCOUNT ON added to prevent extra result sets from
			-- interfering with SELECT statements.
			SET NOCOUNT ON;

			-- Internal Variables
			DECLARE @SalesOrderGUID char(36),
					@SalesOrderDetailGUID char(36),
					@SalesOrderTenderGUID char(36),
					@PayCycleTransactionGUID char(36),
					@SalesCodeID int,
					@SalesOrderTypeID_MonthlyFee int,
					@TenderTypeID int,
					@CreditCardTypeID int,
					@ChargeAmount money,
					@TaxAmount money,
					@PayCycleTransactionTypeID int,
					@AccountReceivableTypeID int,
					@InvoiceNumber nvarchar(20)

			-- Create a SalesOrderGUID
			SET @SalesOrderGUID = NEWID()
			SET @SalesOrderDetailGUID = NEWID()
			SET @SalesOrderTenderGUID = NEWID()
			SET @PayCycleTransactionGUID = NEWID()

			--Retrieve the SalesOrderTypeID for the MonthlyFee (FO)
			SELECT @SalesOrderTypeID_MonthlyFee = SalesOrderTypeID FROM lkpSalesOrderType WHERE SalesOrderTypeDescriptionShort = 'FO'

			--Grab the next Invoice Number
			DECLARE @TempInvoiceNumberTable TABLE (InvoiceNumber nvarchar(50))
			INSERT INTO @TempInvoiceNumberTable EXEC mtnGetInvoiceNumber @CenterID
			SELECT @InvoiceNumber = InvoiceNumber FROM @TempInvoiceNumberTable

			--Insert datSalesOrder Record
			INSERT INTO datSalesOrder(
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
				,CenterFeeBatchGUID)
			VALUES
				(@SalesOrderGUID -- SalesOrderGUID
				,NULL    -- TenderTransactionNumber_Temp
				,NULL    -- TicketNumber_Temp
				,@CenterID --CenterID
				,@CenterID --CenterID
				,@SalesOrderTypeID_MonthlyFee --SalesOrderTypeID
				,@ClientGUID --ClientGUID
				,@ClientMembershipGUID --ClientMembershipGUID
				,NULL --AppointmentGUID
				,NULL --HairSystemOrderGUID
				,GETUTCDATE() --OrderDate
				,@InvoiceNumber --InvoiceNumber
				,0 --IsTaxExemptFlag  Does this need to be passed in?
				,0 --IsVoidedflag
				,0 --IsClosedFlag  Need to be passed in?
				,NULL --RegisterCloseGUID
				,@EmployeeGUID  --EmployeeGUID
				,NULL --FulfillmentNumber
				,0 --IsWrittenOffFlag
				,0 --IsRefundedFlag
				,NULL --RefundedSalesOrderGUID
				,GETUTCDATE() --CreateDate
				,@HCUSER --CreateUser
				,GETUTCDATE() --LastUpdate
				,@HCUSER -- LastUpdateUser
				,NULL --ParentSalesOrderGUID
				,0 --IsSurgeryReversalFlag
				,NULL --IsGuarnteeFlag
				,@CenterFeeBatchGUID)

			--GET the SalesCodeID
			SELECT @SalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = @SalesCodeDescriptionShort


				INSERT INTO datSalesOrderDetail(
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
							,Center_Temp)
				VALUES(@SalesOrderDetailGUID --SalesOrderDetailGUID
							,NULL --TransactionNumber_Temp
							,@SalesOrderGUID --SalesOrderGUID
							,@SalesCodeID --SalesCodeID
							,1 --Quantity
							,@Price --Price
							,0 --Discount
							,0 --Tax1
							,0 --Tax2
							,@TaxRate1 --TaxRate1
							,0 --TaxRate2
							,0 --IsRefundedFlag
							,NULL --RefundedSalesOrderDetailGUID
							,NULL --RefunedTotalQuantity
							,NULL --RefundedTotalPrice
							,NULL --Employee1GUID
							,NULL --Employee2GUID
							,NULL --Employee3GUID
							,NULL --Employee4GUID
							,NULL --PreviousClientMembershpGUID
							,NULL --NewCenterID
							,GETUTCDATE() --CreateDate
							,@HCUSER --CreateUser
							,GETUTCDATE() --LastUpdate
							,@HCUSER --LastUpdateUser
							,NULL) --Center_Temp



			SELECT @TenderTypeID = TenderTypeID  FROM lkpTenderType WHERE TenderTypeDescriptionShort = @TenderTypeDescriptionShort
			SELECT @CreditCardTypeID = CreditCardTypeID from lkpCreditCardType WHERE CreditCardTypeDescriptionShort = @CreditCardTypeDescriptionShort

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
								,MonetraTransactionId)
				VALUES(@SalesOrderTenderGUID --SalesOrderTenderGUID
								,@SalesOrderGUID --SalesOrderGUID
								,@TenderTypeID --TenderTypeID
								,@Amount --Amount
								,NULL --CheckNumber
								,@CreditCardLast4Digits --CreditCardlast4Digits
								,@ApprovalCode --ApprovalCode
								,@CreditCardTypeID --CreditCardTypeID
								,NULL --FinanceCompanyID
								,NULL --InterCompanyReasonID
								,GETUTCDATE() --CreateDate
								,@HCUSER --CreateUser
								,GETUTCDATE() --LastUpdate
								,@HCUSER --LastUpdateUser
								,NULL --RefundAmount
								,@MonetraTransactionID) --MonetraTransactionId



			SELECT @PayCycleTransactionTypeID = PayCycleTransactionTypeID  FROM lkpPayCycleTransactionType WHERE PayCycleTransactionTypeDescriptionShort = @PayCycleTransactionTypeDescriptionShort

				INSERT INTO datPayCycleTransaction(
								PayCycleTransactionGUID
								,PayCycleTransactionTypeID
								,CenterFeeBatchGUID
								,CenterDeclineBatchGUID
								,SalesOrderGUID
								,ClientGUID
								,ProcessorTransactionID
								,ApprovalCode
								,FeeAmount
								,TaxAmount
								,ChargeAmount
								,Verbiage
								,SoftCode
								,HardCode
								,Last4Digits
								,ExpirationDate
								,IsTokenUsedFlag
								,IsCardPresentFlag
								,IsSuccessfulFlag
								,IsReprocessFlag
								,TransactionErrorMessage
								,AVSResult
								,HCStatusCode
								,CreateDate
								,CreateUser
								,LastUpdate
								,LastUpdateUser)
				VALUES(@PayCycleTransactionGUID  --PayCycleTransactionGUID
								,@PayCycleTransactionTypeID --PayCycleTransactionTypeID
								,@CenterFeeBatchGUID --CenterFeeBatchGUID
								,@CenterDeclineBatchGUID --CenterDeclineBatchGUID
								,@SalesOrderGUID --SalesOrderGUID
								,@ClientGUID --ClientGUID
								,@MonetraTransactionID --ProcessorTransactionID
								,@ApprovalCode --ApprovalCode
								,ISNULL(@Amount,0) --FeeAmount
								,ISNULL(@Amount,0) * ISNULL(@TaxRate1,0) --TaxAmount
								,(ISNULL(@Amount,0) + (ISNULL(@Amount,0) * ISNULL(@TaxRate1,0)))  --ChargeAmount
								,@Verbiage --Verbiage
								,@SoftCode --SoftCode
								,@HardCoce --HardCode
								,@CreditCardLast4Digits --Last4Digits
								,@ExpirationDate --ExpirationDAte
								,CASE WHEN @PayCycleTransactionTypeDescriptionShort = 'CC' THEN 1
									ELSE 0
								 END --IsTokenUsedFlag
								,0 --IsCardPresentFlag
								,@IsSuccessfulFlag --IsSucessfulFlag
								,CASE WHEN @IsSuccessfulFlag = 1 THEN 0
									ELSE 1
								 END  --IsReprocessFlag
								,NULL --TransactionErrorMessage
								,@AVSResult --AVSResult
								,@HCStatusCode --HCStatusCode
								,GETUTCDATE() --CreateDate
								,@HCUSER --CreateUser
								,GETUTCDATE() --LastUpdate
								,@HCUSER) --LastUpdateUser


			SELECT @AccountReceivableTypeID = AccountReceivableTypeID  FROM lkpAccountReceivableType WHERE AccountReceivableTypeDescriptionShort = @AccountReceivableTypeDescriptionShort

				INSERT INTO datAccountReceivable(
								ClientGUID
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
								,CenterDeclineBatchGUID)
				VALUES(@ClientGUID --ClientGUID
								,@SalesOrderGUID --SalesOrderGUID
								,@CenterFeeBatchGUID  --CenterFeeBatchGUID
								,@Amount --Amount
								,0 --IsClosed
								,@AccountReceivableTypeID --AccountReceivableTypeID
								,@Amount --RemainingBalance
								,GETUTCDATE() --CreateDate
								,@HCUSER --CreateUser
								,GETUTCDATE() --LastUpdate
								,@HCUSER --LastUpdateUser
								,@CenterDeclineBatchGUID) --CenterDeclineBatchGUID

		END
GO
