/***********************************************************************

PROCEDURE:				extBosleyProcessPatientSlipClosedCSTransaction

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		04/12/17

LAST REVISION DATE: 	04/12/17

--------------------------------------------------------------------------------------------------------
NOTES: 	Processes PatientSlipClosedCS transaction sent by Bosley.
	* 04/12/17 PRM - Created - taking credit even though Tovbin wrote 90% of this :)
	* 06/27/17 MVT - Modified logic to update Total Count to 1 And Total Due to 0 if we receive a quantity greater than 1 (TFS #9213)
	* 09/07/17 MVT - Added Tenders to Membership Orders (TFS #9556)
	* 12/07/17 MVT - Added a check to determine if there is outstanding surgery payments and write an
					adjustment to balance out Surgery payments to $0.  Since CS Procedure Sales Code is under
					another department, surgery payments should not be used for paying for CS.
	* 05/24/18 MVT - Added logic to update email if sent by Bosley.
	* 05/01/19 SAL - Modified to handle the fact that Client Membership Add-Ons are no longer being lumped into the Client Membership (TFS #12385)
						- Adjust Surgery payments (ie; RRF) only if the Surgery Client Membership Contract Price = 0
						- Change when and how we adjust the Add-On's Contract Paid by suming up sales order details for the client membership add-on
							and comparing to the Total Due Bosley is sending us.
						- Change when and how we replace the Add-On's Contract Price by comparing the Add-On's Contract Price to the Total Due Bosley
							is sending us.  Use new UPDTCONTBALAO sales code for this ajustment and set the ClientMembershipAddOnID on the sales order
							detail.
	* 05/09/19 SAL - Moved updating the Add-On's status after writing all the sales orders and running them through accums (TFS #12442)

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [extBosleyProcessPatientSlipClosedCSTransaction] @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT

***********************************************************************/

CREATE PROCEDURE [dbo].[extBosleyProcessPatientSlipClosedCSTransaction]
	  @CurrentTransactionIdBeingProcessed INT,
	  @IsSuccessfullyProcessed BIT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

		DECLARE @User nvarchar(25) = 'Bosley-PSC-CS'
		DECLARE @ADDON_CS nvarchar(15) = 'CS'
		DECLARE @CMSADDONSTATUS_ACTIVE nvarchar(15) = 'Active'
		DECLARE @MEMBERSHIP_TENDER nvarchar(15) = 'Membership'

		DECLARE @CurrentSurgeryMembershipGUID Uniqueidentifier
				,@CenterID INT
				,@MembershipTenderTypeID INT
				,@TOTAL_CYCLES INT
				,@TOTAL_DUE DECIMAL(21,2)
				,@PRICE DECIMAL(21,6)
				,@PAYMENT_TOTAL DECIMAL(21,2)
				,@ADJUSTMENT_TOTAL DECIMAL(21,2)
				,@ADJUSTMENT_CYCLES INT

		DECLARE @SalesCodeId_ContractAdjust INT,
				@CurrentContractBal DECIMAL(21,6) = 0,
				@AddOnCurrentContractPrice DECIMAL(21,2) = 0

		SELECT @CurrentSurgeryMembershipGUID = CurrentSurgeryClientMembershipGUID
				, @CenterID = c.CenterID
				, @PAYMENT_TOTAL = 0
				, @TOTAL_CYCLES = ISNULL(irl.ProcedureGraftCount,0)
				, @TOTAL_DUE = ISNULL(irl.ProcedureAmount,0)
		FROM datIncomingRequestLog irl
			INNER JOIN datClient c on irl.ConectID = c.ClientIdentifier
		WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

		SELECT @MembershipTenderTypeID = TenderTypeID FROM lkpTenderType WHERE TenderTypeDescriptionShort = @MEMBERSHIP_TENDER

		SET @PRICE = IIF(@TOTAL_CYCLES = 0, 0, @TOTAL_DUE / @TOTAL_CYCLES)

		DECLARE @ClientMembershipAddOnID INT

		SELECT @ClientMembershipAddOnID = ClientMembershipAddOnID,
			@AddOnCurrentContractPrice = ISNULL(cmao.ContractPrice, 0)
		FROM datClientMembershipAddOn cmao
			INNER JOIN lkpClientMembershipAddOnStatus cmaos ON cmao.ClientMembershipAddOnStatusID = cmaos.ClientMembershipAddOnStatusID
			INNER JOIN cfgAddOn ao ON cmao.AddOnID = ao.AddOnID
			INNER JOIN datClientMembership cm ON cmao.ClientMembershipGUID = cm.ClientMembershipGUID
			INNER JOIN datClient c ON cm.ClientMembershipGUID = c.CurrentSurgeryClientMembershipGUID
			INNER JOIN datIncomingRequestLog irl ON irl.ConectID = c.ClientIdentifier
		WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
			AND ao.AddOnDescriptionShort = @ADDON_CS
			AND cmaos.ClientMembershipAddOnStatusDescriptionShort = @CMSADDONSTATUS_ACTIVE


		--Must have a Current Surgery Client Membership
		IF @CurrentSurgeryMembershipGUID IS NULL
			BEGIN
				SET @IsSuccessfullyProcessed = 0
				-- Write Error Message to the IncomingRequestLog Table
				Update datIncomingRequestLog
					SET ErrorMessage = 'Unable to process, client is not in a Surgery Membership'
						,LastUpdate = GETUTCDATE()
						,LastUpdateUser = @User
				FROM datIncomingRequestLog
				WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed

			END
		ELSE IF @TOTAL_CYCLES > 1
			BEGIN
				SET @IsSuccessfullyProcessed = 0
				-- Write Error Message to the IncomingRequestLog Table
				Update datIncomingRequestLog
					SET ErrorMessage = 'Unable to process, Quantity is greater than 1.'
						,LastUpdate = GETUTCDATE()
						,LastUpdateUser = @User
				FROM datIncomingRequestLog
				WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed

			END
		--Must have an Active Add-On associated with the Current Surgery Client Membership
		ELSE IF @ClientMembershipAddOnID IS NULL
			BEGIN
				SET @IsSuccessfullyProcessed = 0
				-- Write Error Message to the IncomingRequestLog Table
				Update datIncomingRequestLog
					SET ErrorMessage = 'Unable to process, client does not have active Add-On'
						,LastUpdate = GETUTCDATE()
						,LastUpdateUser = @User
				FROM datIncomingRequestLog
				WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed

			END
		ELSE
			BEGIN
				DECLARE @BOSLEY_PAYMENT_SALESCODE INT
						,@BOSLEY_ROOMRESERVATION_SALESCODE INT
						,@BOSLEY_REFUND_SALESCODE INT
						,@BOSLEY_ADJUST_SALESCODE INT
						,@BOSLEY_ADJUST_SALESCODE_TG INT
						,@BOSLEY_ADJUST_SALESCODE_TGBPS INT
						,@BOSLEY_ADJUST_SALESCODE_CS INT
						,@BOSLEY_PERFORM_SALESCODE_CS INT
						,@MEMBERSHIP_PAYMENT_SALESCODE INT
						,@BOSLEY_PERFORM_SURGERY_SALESCODE INT
						,@ADDON_CS_PAYMENT_SALESCODE INT

				SELECT @BOSLEY_PAYMENT_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMPMT'
				SELECT @BOSLEY_REFUND_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMRFD'
				SELECT @BOSLEY_ROOMRESERVATION_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSRMRES'
				SELECT @BOSLEY_ADJUST_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMADJ'
				SELECT @BOSLEY_ADJUST_SALESCODE_TG = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMADJTG'
				SELECT @BOSLEY_ADJUST_SALESCODE_TGBPS = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMADJTGBPS'
				SELECT @BOSLEY_ADJUST_SALESCODE_CS = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMADJCS'
				SELECT @BOSLEY_PERFORM_SALESCODE_CS = salesCodeID FrOM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSPERFCS'
				SELECT @MEMBERSHIP_PAYMENT_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] WHERE [SalesCodeDescriptionShort] = 'MEMPMT'
				SELECT @ADDON_CS_PAYMENT_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] WHERE [SalesCodeDescriptionShort] = 'MEDADDONPMTCS'

				SELECT @BOSLEY_PERFORM_SURGERY_SALESCODE = salesCodeID FrOM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSSURGERY'


				DECLARE @INTERCO_BOSLEY_TENDERTYPEID INT
						,@MEMBERSHIP_TENDERTYPEID INT
						,@CLIENTMEMBERSHIPADDONSTATUS_CLOSED INT
						,@ADDON_COOLSCULPTING INT

				SELECT @INTERCO_BOSLEY_TENDERTYPEID = TenderTypeID  from LkpTenderType Where TenderTypeDescriptionShort = 'InterCoBOS'
				SELECT @MEMBERSHIP_TENDERTYPEID = TenderTypeID  from LkpTenderType Where TenderTypeDescriptionShort = 'Membership'
				SELECT @CLIENTMEMBERSHIPADDONSTATUS_CLOSED = ClientMembershipAddOnStatusID FROM [dbo].[lkpClientMembershipAddOnStatus] WHERE [ClientMembershipAddOnStatusDescriptionShort] = 'Completed'
				SELECT @ADDON_COOLSCULPTING = AddOnID FROM [dbo].[cfgAddOn] WHERE [AddOnDescriptionShort] = 'CS'

				DECLARE @EmployeeGUID Uniqueidentifier
				SELECT @EmployeeGUID = e.EmployeeGUID FROM datEmployee e inner join datIncomingRequestLog irl on e.UserLogin = LEFT(irl.ConsultantUserName,CHARINDEX('_',irl.ConsultantUserName)-1) Where irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

				-- SalesOrderType
				DECLARE @MembershipOrder_SalesOrderTypeID INT
						,@SalesOrder_SalesOrderTypeID INT

				SELECT @SalesOrder_SalesOrderTypeID = SalesOrderTypeID FROM [dbo].[LkpSalesOrderType] Where SalesOrderTypeDescriptionShort = 'SO'
				SELECT @MembershipOrder_SalesOrderTypeID = SalesOrderTypeID FROM [dbo].[LkpSalesOrderType] Where SalesOrderTypeDescriptionShort = 'MO'

				DECLARE @DateToday datetime
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

				-- Check for Cancelled -- skip processing if cancelled
				IF NOT EXISTS(SELECT * FROM datIncomingRequestLog WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed AND ProcedureStatus = 'Cancelled')
					BEGIN
						DECLARE @SURGERY_TOTAL DECIMAL(21,6)
						DECLARE @ADJUSTMENT_QUANTITY int
						DECLARE @CurrentSurgeryMembershipContractPrice DECIMAL(21,6)

						SELECT @CurrentSurgeryMembershipContractPrice = cm.ContractPrice FROM datClientMembership cm WHERE cm.ClientMembershipGUID = @CurrentSurgeryMembershipGUID

						--If there is a 'fake' surgery membership (ie; a surgery membership that was created with no contract price explicitly for the purpose of adding add-ons)
						-- then reverse the difference between payments and surgery performed, from the surgery membership, even thought there shouldn't be anyting other than RRF.
						IF (@CurrentSurgeryMembershipContractPrice = 0)
						BEGIN
							-- Determine all surgery payments for client membership
							SELECT @PAYMENT_TOTAL = SUM(ISNULL(ExtendedPriceCalc,0))
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

							-- Determine Surgery Performed total
							SELECT @SURGERY_TOTAL = SUM(ISNULL(ExtendedPriceCalc,0))
							FROM datIncomingRequestLog irl
								INNER JOIN datClient c on irl.ConectID = c.ClientIdentifier
								INNER JOIN datClientMembership cm on c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
								LEFT OUTER JOIN datSalesOrder so on cm.ClientGUID = so.ClientGUID AND so.ClientMembershipGUID = cm.ClientMembershipGUID
									AND so.IsVoidedFlag = 0
								LEFT OUTER JOIN datSalesOrderDetail sod on so.SalesOrderGUId = sod.SalesOrderGUId
									AND (sod.SalesCodeID = @BOSLEY_PERFORM_SURGERY_SALESCODE)
							WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

							-- Determine if adjustment is needed to balance out surgery prior to writing
							-- CS transaction
							SET @ADJUSTMENT_TOTAL = ISNULL(@SURGERY_TOTAL,0)- ISNULL(@PAYMENT_TOTAL,0)
							SET @ADJUSTMENT_QUANTITY = IIF(@ADJUSTMENT_TOTAL > 0, 1, -1)

							-- Write Adjustment record if Adjustment Total <> 0
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
										,@ADJUSTMENT_QUANTITY as Quantity
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
						END

						--Adjust the Add-On's Contract Paid if necessary
						SET @PAYMENT_TOTAL = 0
						SET @ADJUSTMENT_TOTAL = 0

						-- Determine all Add-On payments
						SELECT @PAYMENT_TOTAL = SUM(ISNULL(ExtendedPriceCalc,0))
						FROM datSalesOrder so
							INNER JOIN datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
						WHERE sod.ClientMembershipAddOnID = @ClientMembershipAddOnID
							AND sod.SalesCodeID in (@ADDON_CS_PAYMENT_SALESCODE)
							AND so.IsVoidedFlag = 0

						SET @ADJUSTMENT_TOTAL = ISNULL(@Total_DUE, 0) - ISNULL(@PAYMENT_TOTAL, 0)
						SET @ADJUSTMENT_QUANTITY = IIF(@ADJUSTMENT_TOTAL > 0, 1, -1)

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
									,SalesCodeSerialNumber
									,ClientMembershipAddOnID)
								SELECT NEWID() as SalesOrderDetailGUID
									,NULL as TransactionNumber_Temp
									,@SalesOrderGUID as SalesOrderGUID
									,@BOSLEY_ADJUST_SALESCODE_CS as SalesCodeID
									,@ADJUSTMENT_QUANTITY as Quantity
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
									,@ClientMembershipAddOnID as ClientMembershipAddOnID
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

						--Write the 'Perform Add-On' sales order
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
							,SalesCodeSerialNumber
							,ClientMembershipAddOnID)
						SELECT NEWID() as SalesOrderDetailGUID
							,NULL as TransactionNumber_Temp
							,@SalesOrderGUID as SalesOrderGUID
							,@BOSLEY_PERFORM_SALESCODE_CS as SalesCodeID
							,@TOTAL_CYCLES as Quantity
							,@PRICE as [Price]
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
							,@ClientMembershipAddOnID as ClientMembershipAddOnID

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

						--Manually replace the Add-On's Contract Price if necessary
						IF @TOTAL_DUE <> @AddOnCurrentContractPrice
						BEGIN

							SET @SalesOrderGUID = NEWID()
							SELECT @SalesCodeId_ContractAdjust = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'UPDTCONTBALAO'

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
								,@CurrentSurgeryMembershipGUID AS ClientMembershipGUID
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
								,@TOTAL_DUE AS [Price]
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
								,@ClientMembershipAddOnID as ClientMembershipAddOnID

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

						--Update Add-On Status to Closed
						UPDATE datClientMembershipAddOn
						SET ClientMembershipAddOnStatusID = @CLIENTMEMBERSHIPADDONSTATUS_CLOSED
							,Price = @PRICE
							,Quantity = @TOTAL_CYCLES
							,LastUpdate = GETUTCDATE()
							,LastUpdateUser = @User
						WHERE @ClientMembershipAddOnID = ClientMembershipAddOnID

						SET @IsSuccessfullyProcessed = 1
					END

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
			END
END
