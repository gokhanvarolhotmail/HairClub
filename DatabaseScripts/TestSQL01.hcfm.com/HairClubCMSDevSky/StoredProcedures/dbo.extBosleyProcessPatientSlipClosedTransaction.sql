/* CreateDate: 05/09/2013 20:28:43.550 , ModifyDate: 03/12/2021 14:38:07.230 */
GO
/***********************************************************************

PROCEDURE:				extBosleyProcessPatientSlipClosedTransaction

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		4/15/16

LAST REVISION DATE: 	4/15/16

--------------------------------------------------------------------------------------------------------
NOTES: 	Processes transactions sent by Bosley.
	* 4/30/13 MLM - Created
	* 5/20/13 MLM - Fixed Issue With Adjustment Entry.
	* 5/22/13 MLM - Added IncomingRequestID to the datSalesOrder Table
	* 5/30/12 MVT - Modified to use "Membership" tender type for MO.  Modified Adjustment to be an "SO"
					with a tender that matches the Detail record.
	* 6/03/13 MVT - Modified to use Invoice Number proc.
	* 6/05/13 MLM - Corrected Issue where Adjustment Calculation was NOT excluding Voided Transactions
	* 6/10/13 MLM - Need to take Room Reservation Payment into account when calculating the adjustment
	* 6/13/13 KRM - Changed calculation of payments to use ExtendedPriceCalc rather than Qty*Price
	* 7/19/13 MLM - Fixed Issue with Qty, Price, and Adjustment Calcs
	* 7/19/13 MLM - Fixed Issue with Clients in New Client Memberships Not Processing Correctly.
	* 8/16/13 MLM - Added Logic to Handle BIO & PostExt Clients
	* 9/10/13 MLM - Moved the Adjustment Record ahead of the Surgery Post.
	* 3/31/14 MLM - Added 60 Day Check and Procedure Done Check.
	* 4/13/16 MVT - Added a check for determine if FUE and make a call to Process FUE Patient Slip Closed.
	* 2/13/17 MVT - Modified 'BOSMEMADJ' Sales Order so that the Price is written as a positive number
					with a negative quantity (if negative amount) (TFS #8569)
	* 5/22/17 PRM - Setting ContractPrice = 0 when cancelling a client membership to be consistant with Add-On's
	* 9/07/17 MVT - Added Tenders to Membership Orders.
	* 12/07/17 MVT - Modified logic that determines payment total to also account for Surgery Adjustment
	* 05/24/18 MVT - Added logic to update email if sent by Bosley.
	* 05/01/19 SAL - Modified to handle the fact that Client Membership Add-Ons are no longer being lumped into
						the Client Membership (TFS #12385)
						- Adjust the Surgery membership's Contract Price to 0 when cancelling the surgery membership.
						- Surgery payments (ie; RRF) only if the Surgery Client Membership Contract Price = 0
						- Change when and how we adjust the Add-On's Contract Paid by suming up sales order details
							for the client membership add-on and comparing to the Total Due Bosley is sending us.
						- Change when and how we replace the Surgery Membership's Contract Price, for Surgery Performed,
							by comparing the Surgery Membership's Contract Price to the Grafts X Price Bosley is sending us.
							Update if they are not equal.
	* 05/09/19 SAL - Moved updating the Membership's status after writing all the sales orders and running them through accums (TFS #12442)
	* 01/27/20 MVT - Updated to set Bosley SF Account ID on the client record if not set or different. Moved reading of the Email Address from
					incoming request log to the top and modified query that updates email on client record to only update if not set on the client record. (TFS #13773)
	* 02/05/20 MVT - Added follwoing verifications of incoming transactions prior to processing (TFS #13809):
						* Added error check to verify ConectID is specified
						* Added error check to verify Procedure Graft Count is greater than 1

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [extBosleyProcessPatientSlipClosedTransaction] @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT

***********************************************************************/

CREATE PROCEDURE [dbo].[extBosleyProcessPatientSlipClosedTransaction]
	  @CurrentTransactionIdBeingProcessed INT,
	  @IsSuccessfullyProcessed BIT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @User nvarchar(25) = 'Bosley-PSC'
	DECLARE @ProcedureDoneProcess as nvarchar(20) = 'ProcedureDone'
	DECLARE @MEMBERSHIP_TENDER nvarchar(15) = 'Membership'

	DECLARE @MembershipTenderTypeID int
	DECLARE @ProcedureGraftCount int

	SELECT @MembershipTenderTypeID = TenderTypeID FROM lkpTenderType WHERE TenderTypeDescriptionShort = @MEMBERSHIP_TENDER


	-- Update Client email if Sent by Bosley
	DECLARE @EmailAddress AS nvarchar(100), @ClientGUID AS uniqueidentifier, @BosleySalesforceAccountID nvarchar(50)

	SELECT @EmailAddress = rl.EmailAddress
		, @ClientGUID = c.ClientGUID
		, @BosleySalesforceAccountID = c.BosleySalesforceAccountID
		, @ProcedureGraftCount = rl.ProcedureGraftCount
	FROM datIncomingRequestLog rl
		INNER JOIN datClient c ON c.ClientIdentifier = ConectID
	WHERE rl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

	-- Update Bosley Salesforce Account ID
	IF (@ClientGUID IS NOT NULL AND @BosleySalesforceAccountID IS NOT NULL AND LTRIM(RTRIM(@BosleySalesforceAccountID)) <> '')
	BEGIN
		UPDATE c SET
			BosleySalesforceAccountID = @BosleySalesforceAccountID
			,LastUpdate = GETUTCDATE()
			,LastUpdateUser = @User
		FROM datClient c
		WHERE c.ClientGUID = @ClientGUID
			AND (c.BosleySalesforceAccountID IS NULL OR
					(c.BosleySalesforceAccountID <> @BosleySalesforceAccountID))
	END

	IF (@ClientGUID IS NULL)
	BEGIN
		SET @IsSuccessfullyProcessed = 0
		-- Write Error Message to the IncomingRequestLog Table
		Update datIncomingRequestLog
			SET ErrorMessage = 'Unable to process, client not found.'
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @User
		FROM datIncomingRequestLog
		WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
	END
	ELSE IF (@ProcedureGraftCount IS NULL OR @ProcedureGraftCount <= 1)
	BEGIN
		-- We are receiving a Treatment Plan without a ConectID
		SET @IsSuccessfullyProcessed = 0
		-- Write Error Message to the IncomingRequestLog Table
		Update datIncomingRequestLog
			SET ErrorMessage = 'Unable to process, Procedure Graft Count is invalid.'
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @User
		FROM datIncomingRequestLog
		WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
	END
	ELSE IF EXISTS (SELECT irl.*
					FROM datIncomingRequestLog irl
						INNER JOIN datClient c on irl.ConectID = c.ClientIdentifier
						INNER JOIN datClientMembership cm on cm.ClientMembershipIdentifier = irl.ClientMembershipID
						INNER JOIN lkpClientMembershipStatus cms on cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
						CROSS APPLY (
							SELECT ca_irl.*
							FROM datIncomingRequestLog ca_irl
							WHERE ca_irl.ConectID = c.ClientIdentifier
								AND ca_irl.BosleyRequestID < @CurrentTransactionIdBeingProcessed
								AND ca_irl.ProcessName = 'PatientSlipClosed'
								AND DateDiff(dd, ca_irl.CreateDate, irl.CreateDate) <= 5
						) ca_psc
						OUTER APPLY (
							SELECT o_irl.*
							FROM datIncomingRequestLog o_irl
							WHERE o_irl.ConectID = c.ClientIdentifier
								AND o_irl.BosleyRequestID < @CurrentTransactionIdBeingProcessed
								AND o_irl.ProcessName = 'TreatmentPlan'
								AND o_irl.BosleyRequestID > ca_psc.BosleyRequestID
								AND o_irl.BosleyRequestID < irl.BosleyRequestID
						) o_tp
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
									AND c.CurrentSurgeryClientMembershipGUID IS NOT NULL
									AND cms.ClientMembershipStatusDescriptionShort = 'SP'
									AND o_tp.BosleyRequestID IS NULL )
	BEGIN
		EXEC [extBosleyProcessFUEPatientSlipClosedTransaction] @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT
	END
	ELSE
	BEGIN

		--Must have a Current Surgery Client Membership
		IF EXISTS(Select *
					FROM datIncomingRequestLog irl
						INNER JOIN datClient c on irl.ConectID = c.ClientIdentifier
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
						AND c.CurrentSurgeryClientMembershipGUID IS NULL)
		BEGIN
			SET @IsSuccessfullyProcessed = 0
			-- Write Error Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET ErrorMessage = 'Unable to process, no Treatment Plan received'
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed

		END
		-- Fail if a procedure done has been received for the client
		ELSE IF EXISTS(SELECT *
					FROM datIncomingRequestLog irl
						INNER JOIN datIncomingRequestLog irlDone on irl.ConectID = irlDone.ConectID
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
						AND irlDone.ProcessName = @ProcedureDoneProcess
						AnD irlDone.IncomingRequestID > irl.IncomingRequestID
						--AND irlDone.IsProcessedFlag = 0
						)
		BEGIN
			SET @IsSuccessfullyProcessed = 0
			-- Write Error Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET ErrorMessage = 'Unable to process, Procedure Done has already been received.'
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
		END
		-- Procedure Date cannot be more than 60 days into the future.
		ELSE IF EXISTS(SELECT *
					FROM datIncomingRequestLog irl
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
						AND irl.ProcedureDate > DateAdd(day,60,GETUTCDATE()))
		BEGIN
			SET @IsSuccessfullyProcessed = 0
			-- Write Error Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET ErrorMessage = 'Unable to process, Procedure Date more than 60 days into the future.'
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
		END
		--Current Surgery Client Membership must be Active
		ELSE IF NOT EXISTS (SELECT *
					FROM datIncomingRequestLog irl
						INNER JOIN datClient c on irl.ConectID = c.ClientIdentifier
						INNER JOIN datClientMembership cm on c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
						INNER JOIN cfgMembership m on cm.MembershipID = m.MembershipID
						INNER JOIN lkpClientMembershipStatus cms on cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
						AND cms.ClientMembershipStatusDescriptionShort = 'A')
		BEGIN
			SET @IsSuccessfullyProcessed = 0
			-- Write Error Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET ErrorMessage = 'Unable to process, Surgery Membership is not in an Active status.'
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
		END
		ELSE
		BEGIN

			DECLARE @SalesCodeId_ContractAdjust INT,
				@CurrentContractBal DECIMAL(21,6) = 0,
				@ContractAdj DECIMAL(21,6) = 0,
				@ContractAdjTotal DECIMAL(21,6)

			SELECT @CurrentContractBal = ISNULL(cm.ContractPrice, 0),
					@ContractAdj = ISNULL(cmaGraft.TotalAccumQuantity,0) * ISNULL(cmaPrice.AccumMoney,0)
			FROM datIncomingRequestLog irl
				INNER JOIN datClient c ON irl.ConectID = c.ClientIdentifier
				INNER JOIN datClientMembership cm ON c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
				INNER JOIN datClientMembershipAccum cmaPrice ON cm.ClientMembershipGUID = cmaPrice.ClientMembershipGUID
				INNER JOIN cfgAccumulator aPrice ON cmaPrice.AccumulatorID = aPrice.AccumulatorID
				INNER JOIN datClientMembershipAccum cmaGraft ON cm.ClientMembershipGUID = cmaGraft.ClientMembershipGUID
				INNER JOIN cfgAccumulator aGraft ON cmaGraft.AccumulatorID = aGraft.AccumulatorID
			WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
				AND aGraft.AccumulatorDescriptionShort = 'Grafts'
				AND aPrice.AccumulatorDescriptionShort = 'PPSG'

			DECLARE @BOSLEY_PAYMENT_SALESCODE INT
					,@BOSLEY_REFUND_SALESCODE INT
					,@BOSLEY_ADJUST_SALESCODE INT
					,@BOSLEY_PERFORM_SALESCODE INT
					,@MEMBERSHIP_PAYMENT_SALESCODE INT
					,@BOSLEY_ROOMRESERVATION_SALESCODE INT

			SELECT @BOSLEY_PAYMENT_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMPMT'
			SELECT @BOSLEY_REFUND_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMRFD'
			SELECT @BOSLEY_ROOMRESERVATION_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSRMRES'
			SELECT @BOSLEY_ADJUST_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMADJ'
			SELECT @BOSLEY_PERFORM_SALESCODE = salesCodeID FrOM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSSURGERY'
			SELECT @MEMBERSHIP_PAYMENT_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] WHERE [SalesCodeDescriptionShort] = 'MEMPMT'

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
			SELECT @CenterID = centerID FROM [dbo].[datClient] c INNER JOIN datIncomingRequestLog irl on c.ClientIdentifier = irl.ConectID WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

			-- Check for Cancelled
			IF EXISTS(SELECT * FROM datIncomingRequestLog WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed AND ProcedureStatus = 'Cancelled')
				BEGIN

					DECLARE @CANCEL_SALESCODE INT
					SELECT @CANCEL_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'CANCEL'

					SET @SalesOrderGUID = NEWID()

					--create an invoice #
					INSERT INTO @TempInvoiceTable EXEC ('mtnGetInvoiceNumber ' + @CenterID)
					SELECT TOP 1 @InvoiceNumber = InvoiceNumber FROM @TempInvoiceTable
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
					INNER JOIN [dbo].[datClientMembership] cm on c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
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
						,@CANCEL_SALESCODE as SalesCodeID
						,0 as Quantity
						,0 as [Price]
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


					--Manually adjust the Contract Balance to 0 since we're cancelling the surgery membership
					SET @SalesOrderGUID = NEWID()
					SELECT @SalesCodeId_ContractAdjust = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'UPDTCONTBAL'

					--create an invoice #
					INSERT INTO @TempInvoiceTable EXEC ('mtnGetInvoiceNumber ' + @CenterID)
					SELECT TOP 1 @InvoiceNumber = InvoiceNumber FROM @TempInvoiceTable
					DELETE FROM @TempInvoiceTable

					INSERT INTO [dbo].[datSalesOrder] (SalesOrderGUID, TenderTransactionNumber_Temp, TicketNumber_Temp, CenterID, ClientHomeCenterID, SalesOrderTypeID, ClientGUID, ClientMembershipGUID,
														AppointmentGUID, HairSystemOrderGUID, OrderDate, InvoiceNumber, IsTaxExemptFlag, IsVoidedFlag, IsClosedFlag, RegisterCloseGUID, EmployeeGUID,
														FulfillmentNumber, IsWrittenOffFlag, IsRefundedFlag, RefundedSalesOrderGUID, CreateDate, CreateUser, LastUpdate, LastUpdateUser,
														ParentSalesOrderGUID , IsSurgeryReversalFlag, IsGuaranteeFlag, cashier_temp, ctrOrderDate, CenterFeeBatchGUID, CenterDeclineBatchGUID,
														RegisterID, EndOfDayGUID, IncomingRequestID)
					SELECT @SalesOrderGUID AS SalesOrderGUID
						,NULL AS TenderTransactionNumber_Temp
						,NULL AS TicketNumber_Temp
						,c.CenterID AS CenterID
						,c.CenterID AS ClientHomeCenterID
						,@MembershipOrder_SalesOrderTypeID AS SalesOrderTypeID
						,c.ClientGUID AS ClientGUID
						,cm.ClientMembershipGUID AS ClientMembershipGUID
						,NULL AS AppointmentGUID
						,NULL AS HairSystemOrderGUID
						,GETUTCDATE() AS OrderDate
						,@InvoiceNumber AS InvoiceNumber
						,0 AS IsTaxExemptFlag
						,0 AS IsVoidedFlag
						,1 AS IsClosedFlag
						,NULL AS RegisterCloseGUID
						,@EmployeeGUID AS EmployeeGUID
						,NULL AS FulfillmentNumber
						,0 AS IsWrittenOffFlag
						,0 AS IsRefundedFlag
						,NULL AS RefundedSalesOrderGUID
						,GETUTCDATE() AS CreateDate
						,@User AS CreateUser
						,GETUTCDATE() AS LastUpdate
						,@User AS LastUpdateUser
						,NULL AS ParentSalesOrderGUID
						,0 AS IsSurgeryReversalFlag
						,0 AS IsGuaranteeFlag
						,NULL AS cashier_temp
						,GETUTCDATE() AS ctrOrderDate
						,NULL AS CenterFeeBatchGUID
						,NULL AS CenterDeclineBatchGUID
						,NULL AS RegisterID
						,NULL AS EndOfDayGUID
						,NULL --,irl.IncomingRequestID AS IncomingRequestID
					from [dbo].[datIncomingRequestLog] irl
						INNER JOIN [dbo].[datClient] c on irl.ConectID = c.ClientIdentifier
						INNER JOIN [dbo].[datClientMembership] cm on c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

					INSERT INTO datSalesOrderDetail (SalesOrderDetailGUID, TransactionNumber_Temp, SalesOrderGUID, SalesCodeID , Quantity, Price, Discount, Tax1, Tax2, TaxRate1, TaxRate2,
													IsRefundedFlag, RefundedSalesOrderDetailGUID, RefundedTotalQuantity, RefundedTotalPrice, Employee1GUID, Employee2GUID, Employee3GUID, Employee4GUID,
													PreviousClientMembershipGUID, NewCenterID, CreateDate, CreateUser, LastUpdate, LastUpdateUser, Center_Temp, performer_temp, performer2_temp,
													Member1Price_temp, CancelReasonID, EntrySortOrder, HairSystemOrderGUID, DiscountTypeID, BenefitTrackingEnabledFlag, MembershipPromotionID,
													MembershipOrderReasonID, MembershipNotes, GenericSalesCodeDescription, SalesCodeSerialNumber, ClientMembershipAddOnID)
					SELECT NEWID() AS SalesOrderDetailGUID
						,NULL AS TransactionNumber_Temp
						,@SalesOrderGUID AS SalesOrderGUID
						,@SalesCodeId_ContractAdjust AS SalesCodeID
						,1 AS Quantity
						,0 AS [Price]
						,0 AS Discount
						,NULL AS Tax1
						,NULL AS Tax2
						,0 AS TaxRate1
						,0 AS TaxRate2
						,0 AS IsRefundedFlag
						,NULL AS RefundedSalesORderDetailGUID
						,NULL AS RefundedTotalQuantity
						,NULL AS RefundedTotalPrice
						,@EmployeeGUID AS Employee1GUID
						,NULL AS Employee2GUID
						,NULL AS Employee3GUID
						,NULL AS Employee4GUID
						,NULL AS previousClientMembershipGUID
						,NULL AS NewCenterID
						,GETUTCDATE() AS CreateDate
						,@User AS CreateUser
						,GETUTCDATE() AS LastUpdate
						,@User AS LastUpdateUser
						,NULL AS Center_Temp
						,NULL AS performer_temp
						,NULL AS performer2_temp
						,NULL AS Member1Price_temp
						,NULL AS CancelReasonID
						,1 AS EntrySortOrder
						,NULL AS HairSystemOrderGUID
						,NULL AS DiscountTypeID
						,1 AS BenefitTrackingEnabledFlag
						,NULL AS MembershipPromotionID
						,NULL AS MembershipOrderReasonID
						,NULL AS MembershipNotes
						,NULL AS genericSalesCodeDescription
						,NULL AS SalesCodeSerialNumber
						,NULL AS ClientMembershipAddOnID

					INSERT INTO [dbo].[datSalesOrderTender]  ([SalesOrderTenderGUID],[SalesOrderGUID],[TenderTypeID],[Amount],[CheckNumber],[CreditCardLast4Digits],[ApprovalCode]
																,[CreditCardTypeID],[FinanceCompanyID],[InterCompanyReasonID],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser]
																,[RefundAmount],[MonetraTransactionId],[EntrySortOrder],[CashCollected])
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

					--Update the Accumulators
					EXEC mtnMembershipAccumAdjustment 'SALES ORDER', @SalesOrderGUID


					-- Update the ClientMembershipStatus
					DECLARE @CLIENTMEMBERSHIPSTATUS_CANCELLED INT
					SELECT @CLIENTMEMBERSHIPSTATUS_CANCELLED = ClientMembershipStatusID FROM LkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = 'C'

					UPDATE cm
					SET ClientMembershipStatusID = @CLIENTMEMBERSHIPSTATUS_CANCELLED
						,LastUpdate = GETUTCDATE()
						,LastUpdateUser = @User
					FROM datClientMembership cm
						inner join datClient c on c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
						inner join datIncomingRequestLog irl on c.ClientIdentifier = irl.conectID
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
				END
			ELSE
				BEGIN

					-- Get all Payment Records for Procedure
					DECLARE @TOTAL_GRAFTS INT
							,@TOTAL_DUE DECIMAL(21,2)
							,@PRICE DECIMAL(21,6)
							,@PAYMENT_TOTAL DECIMAL(21,2)
							,@ADJUSTMENT_GRAFTS INT
							,@ADJUSTMENT_TOTAL DECIMAL(21,2)

					SELECT @PAYMENT_TOTAL = SUM(ISNULL(ExtendedPriceCalc,0))
							,@TOTAL_GRAFTS = ISNULL(MAX(irl.ProcedureGraftCount),0)
							,@TOTAL_DUE = ISNULL(MAX(irl.ProcedureAmount),0)
					FROM datIncomingRequestLog irl
						INNER JOIN datClient c on irl.ConectID = c.ClientIdentifier
						INNER JOIN datClientMembership cm on c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
						LEFT OUTER JOIN datSalesOrder so on cm.ClientGUID = so.ClientGUID AND so.ClientMembershipGUID = cm.ClientMembershipGUID
							AND so.IsVoidedFlag = 0
						LEFT OUTER JOIN datSalesOrderDetail sod on so.SalesOrderGUId = sod.SalesOrderGUId
							AND (sod.SalesCodeID = @BOSLEY_PAYMENT_SALESCODE OR sod.SalesCodeID = @BOSLEY_REFUND_SALESCODE
									OR sod.SalesCodeID = @MEMBERSHIP_PAYMENT_SALESCODE OR sod.SalesCodeID = @BOSLEY_ROOMRESERVATION_SALESCODE
									OR sod.SalesCodeID = @BOSLEY_ADJUST_SALESCODE)
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

					SET @PRICE = IIF(@TOTAL_GRAFTS = 0, 0, @TOTAL_DUE / @TOTAL_GRAFTS)

					SET @ADJUSTMENT_TOTAL = IIF(@Total_DUE IS NULL or @Payment_Total IS NULL, 0, (@TOTAL_DUE - @PAYMENT_TOTAL))
					SET @ADJUSTMENT_GRAFTS = IIF(@ADJUSTMENT_TOTAL > 0, 1, -1)

					--Adjust the Surgery Membership's Contract Paid if necessary
					IF (@ADJUSTMENT_TOTAL <> 0)
					BEGIN
						SET @SalesOrderGUID = NEWID()

						--create an invoice #
						INSERT INTO @TempInvoiceTable EXEC ('mtnGetInvoiceNumber ' + @CenterID)
						SELECT TOP 1 @InvoiceNumber = InvoiceNumber FROM @TempInvoiceTable
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
							INNER JOIN [dbo].[datClientMembership] cm on c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
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
								,@ADJUSTMENT_GRAFTS as Quantity
								,ABS(@ADJUSTMENT_TOTAL) as [Price]
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
							,@ADJUSTMENT_TOTAL as Amount
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
					END


					--Write the 'Surgery Performed' sales order
					SET @SalesOrderGUID = NEWID()

					--create an invoice #
					INSERT INTO @TempInvoiceTable EXEC ('mtnGetInvoiceNumber ' + @CenterID)
					SELECT TOP 1 @InvoiceNumber = InvoiceNumber FROM @TempInvoiceTable
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
						INNER JOIN [dbo].[datClientMembership] cm on c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
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
						,@BOSLEY_PERFORM_SALESCODE as SalesCodeID
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


					--Manually replace the Surgery Membership's Contract Price if necessary
					IF ((@PRICE * @TOTAL_GRAFTS) <> @ContractAdj)
					BEGIN

						SET @SalesOrderGUID = NEWID()
						SELECT @SalesCodeId_ContractAdjust = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'UPDTCONTBAL'

						SET @ContractAdjTotal = (@PRICE * @TOTAL_GRAFTS)

						--create an invoice #
						INSERT INTO @TempInvoiceTable EXEC ('mtnGetInvoiceNumber ' + @CenterID)
						SELECT TOP 1 @InvoiceNumber = InvoiceNumber FROM @TempInvoiceTable
						DELETE FROM @TempInvoiceTable

						INSERT INTO [dbo].[datSalesOrder] (SalesOrderGUID, TenderTransactionNumber_Temp, TicketNumber_Temp, CenterID, ClientHomeCenterID, SalesOrderTypeID, ClientGUID, ClientMembershipGUID,
															AppointmentGUID, HairSystemOrderGUID, OrderDate, InvoiceNumber, IsTaxExemptFlag, IsVoidedFlag, IsClosedFlag, RegisterCloseGUID, EmployeeGUID,
															FulfillmentNumber, IsWrittenOffFlag, IsRefundedFlag, RefundedSalesOrderGUID, CreateDate, CreateUser, LastUpdate, LastUpdateUser,
															ParentSalesOrderGUID , IsSurgeryReversalFlag, IsGuaranteeFlag, cashier_temp, ctrOrderDate, CenterFeeBatchGUID, CenterDeclineBatchGUID,
															RegisterID, EndOfDayGUID, IncomingRequestID)
						SELECT @SalesOrderGUID AS SalesOrderGUID
							,NULL AS TenderTransactionNumber_Temp
							,NULL AS TicketNumber_Temp
							,c.CenterID AS CenterID
							,c.CenterID AS ClientHomeCenterID
							,@MembershipOrder_SalesOrderTypeID AS SalesOrderTypeID
							,c.ClientGUID AS ClientGUID
							,cm.ClientMembershipGUID AS ClientMembershipGUID
							,NULL AS AppointmentGUID
							,NULL AS HairSystemOrderGUID
							,GETUTCDATE() AS OrderDate
							,@InvoiceNumber AS InvoiceNumber
							,0 AS IsTaxExemptFlag
							,0 AS IsVoidedFlag
							,1 AS IsClosedFlag
							,NULL AS RegisterCloseGUID
							,@EmployeeGUID AS EmployeeGUID
							,NULL AS FulfillmentNumber
							,0 AS IsWrittenOffFlag
							,0 AS IsRefundedFlag
							,NULL AS RefundedSalesOrderGUID
							,GETUTCDATE() AS CreateDate
							,@User AS CreateUser
							,GETUTCDATE() AS LastUpdate
							,@User AS LastUpdateUser
							,NULL AS ParentSalesOrderGUID
							,0 AS IsSurgeryReversalFlag
							,0 AS IsGuaranteeFlag
							,NULL AS cashier_temp
							,GETUTCDATE() AS ctrOrderDate
							,NULL AS CenterFeeBatchGUID
							,NULL AS CenterDeclineBatchGUID
							,NULL AS RegisterID
							,NULL AS EndOfDayGUID
							,NULL --,irl.IncomingRequestID AS IncomingRequestID
						FROM datIncomingRequestLog irl
							INNER JOIN [dbo].[datClient] c on irl.ConectID = c.ClientIdentifier
							INNER JOIN [dbo].[datClientMembership] cm on irl.ClientMembershipID = cm.ClientMembershipIdentifier
						WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

						INSERT INTO datSalesOrderDetail (SalesOrderDetailGUID, TransactionNumber_Temp, SalesOrderGUID, SalesCodeID , Quantity, Price, Discount, Tax1, Tax2, TaxRate1, TaxRate2,
														IsRefundedFlag, RefundedSalesOrderDetailGUID, RefundedTotalQuantity, RefundedTotalPrice, Employee1GUID, Employee2GUID, Employee3GUID, Employee4GUID,
														PreviousClientMembershipGUID, NewCenterID, CreateDate, CreateUser, LastUpdate, LastUpdateUser, Center_Temp, performer_temp, performer2_temp,
														Member1Price_temp, CancelReasonID, EntrySortOrder, HairSystemOrderGUID, DiscountTypeID, BenefitTrackingEnabledFlag, MembershipPromotionID,
														MembershipOrderReasonID, MembershipNotes, GenericSalesCodeDescription, SalesCodeSerialNumber, ClientMembershipAddOnID)
						SELECT NEWID() AS SalesOrderDetailGUID
							,NULL AS TransactionNumber_Temp
							,@SalesOrderGUID AS SalesOrderGUID
							,@SalesCodeId_ContractAdjust AS SalesCodeID
							,1 AS Quantity
							,@ContractAdjTotal AS [Price]
							,0 AS Discount
							,NULL AS Tax1
							,NULL AS Tax2
							,0 AS TaxRate1
							,0 AS TaxRate2
							,0 AS IsRefundedFlag
							,NULL AS RefundedSalesORderDetailGUID
							,NULL AS RefundedTotalQuantity
							,NULL AS RefundedTotalPrice
							,@EmployeeGUID AS Employee1GUID
							,NULL AS Employee2GUID
							,NULL AS Employee3GUID
							,NULL AS Employee4GUID
							,NULL AS previousClientMembershipGUID
							,NULL AS NewCenterID
							,GETUTCDATE() AS CreateDate
							,@User AS CreateUser
							,GETUTCDATE() AS LastUpdate
							,@User AS LastUpdateUser
							,NULL AS Center_Temp
							,NULL AS performer_temp
							,NULL AS performer2_temp
							,NULL AS Member1Price_temp
							,NULL AS CancelReasonID
							,1 AS EntrySortOrder
							,NULL AS HairSystemOrderGUID
							,NULL AS DiscountTypeID
							,1 AS BenefitTrackingEnabledFlag
							,NULL AS MembershipPromotionID
							,NULL AS MembershipOrderReasonID
							,NULL AS MembershipNotes
							,NULL AS genericSalesCodeDescription
							,NULL AS SalesCodeSerialNumber
							,NULL AS ClientMembershipAddOnID

						INSERT INTO [dbo].[datSalesOrderTender]  ([SalesOrderTenderGUID],[SalesOrderGUID],[TenderTypeID],[Amount],[CheckNumber],[CreditCardLast4Digits],[ApprovalCode]
																,[CreditCardTypeID],[FinanceCompanyID],[InterCompanyReasonID],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser]
																,[RefundAmount],[MonetraTransactionId],[EntrySortOrder],[CashCollected])
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

						--Update the Accumulators
						EXEC mtnMembershipAccumAdjustment 'SALES ORDER', @SalesOrderGUID
					END

					-- Update the ClientMembershipStatus to Surgery Performed
					DECLARE @ClientMembershipStatus_SurgeryPerformed INT
					SELECT @ClientMembershipStatus_SurgeryPerformed = ClientMembershipStatusID FROM lkpClientMembershipStatus Where ClientMembershipStatusDescriptionShort = 'SP'

					UPDATE cm
					SET ClientMembershipStatusID = @ClientMembershipStatus_SurgeryPerformed
						,LastUpdate = GETUTCDATE()
						,LastUpdateUser = @User
					FROM datClientMembership cm
						inner join datClient c on c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
						inner join datIncomingRequestLog irl on c.ClientIdentifier = irl.ConectID
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
				END


			UPDATE c SET
				EmailAddress = @EmailAddress
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @User
			FROM datClient c
			WHERE c.ClientGUID = @ClientGUID
				AND (c.EmailAddress IS NULL OR c.EmailAddress = '')
				AND (@EmailAddress IS NOT NULL AND @EmailAddress <> '')


			EXEC extBosleyUpdateProcedureAppointment @CurrentTransactionIdBeingProcessed

			SET @IsSuccessfullyProcessed = 1
		END
	END
END
GO
