/* CreateDate: 04/24/2017 09:23:44.873 , ModifyDate: 05/27/2021 09:14:40.587 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				extBosleyProcessPatientSlipClosedPRPTransaction

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		04/12/17

LAST REVISION DATE: 	04/12/17

--------------------------------------------------------------------------------------------------------
NOTES: 	Processes PatientSlipClosedPRP transaction sent by Bosley.
	* 04/12/17 PRM - Created - taking credit even though Tovbin wrote 90% of this :)
	* 06/27/17 MVT - Modified logic to update Total Count to 1 And Total Due to 0 if we receive a quantity greater than 1 (TFS #9213)
	* 08/31/17 MVT - Processing of PatientSlipClosedPRP will only occur if the client is currently in an active Add-on (TFS #9517)
	* 12/07/17 MVT - Added a check to determine if there is outstanding surgery payments and write an
						adjustment to balance out Surgery payments to $0.  Since TriGen Procedure Sales Code is under
						another department, surgery payments should not be used for paying for TriGen.
	* 05/24/18 MVT - Added logic to update email if sent by Bosley.
	* 05/01/19 SAL - Modified to handle the fact that Client Membership Add-Ons are no longer being lumped into the Client Membership (TFS #12385)
						- Adjust Surgery payments (ie; RRF) only if the Surgery Client Membership Contract Price = 0
						- Change when and how we adjust the Add-On's Contract Paid by suming up sales order details for the client membership add-on
							and comparing to the Total Due Bosley is sending us.
						- Change when and how we replace the Add-On's Contract Price by comparing the Add-On's Contract Price to the Total Due Bosley
							is sending us.  Use new UPDTCONTBALAO sales code for this ajustment and set the ClientMembershipAddOnID on the sales order
							detail.
	* 05/09/19 SAL - Added writing a tender when creating an Update Contract Balance sales order (TFS #12440)
					 Moved updating the Add-On's status after writing all the sales orders and running them through accums (TFS #12442)
	* 01/27/20 MVT - Updated to set Bosley SF Account ID on the client record if not set or different. Moved reading of the Email Address from
					incoming request log to the top and modified query that updates email on client record to only update if not set on the client record. (TFS #13773)
	* 02/05/20 MVT - Added follwoing verifications of incoming transactions prior to processing (TFS #13809):
						* Default Procedure Graft Count to 1 since sometimes Bosley sends either 0 or Surgery Graft count.
						* Added error check to verify ConectID is specified
						* Added error check to verify Procedure Amount is specified
						* Added error check if it's a Patient Slip Closed for 4 PRP (must be processed manually)

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [extBosleyProcessPatientSlipClosedPRPTransaction] @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT

***********************************************************************/

CREATE PROCEDURE [dbo].[extBosleyProcessPatientSlipClosedPRPTransaction]
	  @CurrentTransactionIdBeingProcessed INT,
	  @IsSuccessfullyProcessed BIT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

		DECLARE @User nvarchar(25) = 'Bosley-PSC-PRP'
		--DECLARE @ProcedureDoneProcess as nvarchar(20) = 'ProcedureDone'

		DECLARE @ADDON_TGE nvarchar(15) = 'TGE'
		DECLARE @ADDON_TGE9BPS nvarchar(15) = 'TGE9BPS'
		DECLARE @CMSADDONSTATUS_ACTIVE nvarchar(15) = 'Active'


		DECLARE @CurrentSurgeryMembershipGUID Uniqueidentifier
				,@CenterID INT
				,@TOTAL_CYCLES INT
				,@TOTAL_DUE DECIMAL(21,2)
				,@PRICE DECIMAL(21,6)
				,@PAYMENT_TOTAL DECIMAL(21,2)
				,@ADJUSTMENT_TOTAL DECIMAL(21,2)
				,@ADJUSTMENT_CYCLES INT

		DECLARE @SalesCodeId_ContractAdjust INT,
				@CurrentContractBal DECIMAL(21,2) = 0,
				@AddOnCurrentContractPrice DECIMAL(21,2) = 0

		DECLARE @EmailAddress AS nvarchar(100), @ClientGUID AS uniqueidentifier, @BosleySalesforceAccountID nvarchar(50)

		SELECT @CurrentSurgeryMembershipGUID = CurrentSurgeryClientMembershipGUID
				, @CenterID = c.CenterID
				, @PAYMENT_TOTAL = 0
				, @TOTAL_CYCLES = 1 -- ISNULL(irl.ProcedureGraftCount,0)
				, @TOTAL_DUE = ISNULL(irl.ProcedureAmount,0)
				, @EmailAddress = irl.EmailAddress
				, @ClientGUID = c.ClientGUID
				, @BosleySalesforceAccountID = irl.BosleySalesforceAccountID
		FROM datIncomingRequestLog irl
			INNER JOIN datClient c on irl.ConectID = c.ClientIdentifier
		WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed


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

		SET @PRICE = IIF(@TOTAL_CYCLES = 0, 0, @TOTAL_DUE / @TOTAL_CYCLES)


		DECLARE @ClientMembershipAddOnID INT
				, @PRPAddOnCount INT
				, @PRPAddOn nvarchar(15)

		SELECT @PRPAddOnCount = COUNT(*)
		FROM datClientMembershipAddOn cmao
			INNER JOIN lkpClientMembershipAddOnStatus cmaos ON cmao.ClientMembershipAddOnStatusID = cmaos.ClientMembershipAddOnStatusID
			INNER JOIN cfgAddOn ao ON cmao.AddOnID = ao.AddOnID
			INNER JOIN datClientMembership cm ON cmao.ClientMembershipGUID = cm.ClientMembershipGUID
			INNER JOIN datClient c ON cm.ClientMembershipGUID = c.CurrentSurgeryClientMembershipGUID
			INNER JOIN datIncomingRequestLog irl ON irl.ConectID = c.ClientIdentifier
		WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
			AND ao.AddOnDescriptionShort IN (@ADDON_TGE, @ADDON_TGE9BPS)
			AND cmaos.ClientMembershipAddOnStatusDescriptionShort = @CMSADDONSTATUS_ACTIVE

		--Doing TOP 1 in case the count in the previous query is > 1 which will cause an error to be logged later in code
		SELECT TOP 1 @ClientMembershipAddOnID = ClientMembershipAddOnID,
			@PRPAddOn = ao.AddOnDescriptionShort,
			@AddOnCurrentContractPrice = ISNULL(cmao.ContractPrice, 0)
		FROM datClientMembershipAddOn cmao
			INNER JOIN lkpClientMembershipAddOnStatus cmaos ON cmao.ClientMembershipAddOnStatusID = cmaos.ClientMembershipAddOnStatusID
			INNER JOIN cfgAddOn ao ON cmao.AddOnID = ao.AddOnID
			INNER JOIN datClientMembership cm ON cmao.ClientMembershipGUID = cm.ClientMembershipGUID
			INNER JOIN datClient c ON cm.ClientMembershipGUID = c.CurrentSurgeryClientMembershipGUID
			INNER JOIN datIncomingRequestLog irl ON irl.ConectID = c.ClientIdentifier
		WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
			AND ao.AddOnDescriptionShort IN (@ADDON_TGE, @ADDON_TGE9BPS)
			AND cmaos.ClientMembershipAddOnStatusDescriptionShort = @CMSADDONSTATUS_ACTIVE



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
		ELSE IF (@TOTAL_DUE IS NULL OR @TOTAL_DUE = 0)
		BEGIN
			SET @IsSuccessfullyProcessed = 0
			-- Write Error Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET ErrorMessage = 'Unable to process, Procedure Amount not specified.'
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
		END
		-- Check if this Patient Slip Closed for 4 PRP. If we have another Patient Slip Closed PRP
		-- transaction without a Treatment Plan Tri Gen, then it's a potential 4 PRP Patient Slip Closed.
		-- Stop Processing and deal with it manually by either combining all Patient Slip Closed Transactions into 1 OR
		-- manually process each of the Treatment Plans (sent previously) and Patient Slip Closed Transactions.
		ELSE IF EXISTS (SELECT *
					FROM datIncomingRequestLog irl
						OUTER APPLY (
								SELECT TOP(1) tr_irl.*
								FROM datIncomingRequestLog tr_irl
								WHERE tr_irl.BosleyRequestID > @CurrentTransactionIdBeingProcessed
									--AND tr_irl.ConectID = irl.ConectID
									AND tr_irl.ProcessName = 'TreatmentPlanTriGenEnh'
								ORDER BY tr_irl.BosleyRequestID) o_tr
						OUTER APPLY (
								SELECT TOP(1) psc_irl.*
								FROM datIncomingRequestLog psc_irl
								WHERE psc_irl.BosleyRequestID > @CurrentTransactionIdBeingProcessed
									--AND psc_irl.ConectID = irl.ConectID
									AND psc_irl.ProcessName = 'PatientSlipClosedPRP'
								ORDER BY psc_irl.BosleyRequestID) o_psc
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
							AND o_psc.IncomingRequestID IS NOT NULL
							AND (o_tr.IncomingRequestID IS NULL OR (o_psc.BosleyRequestID < o_tr.BosleyRequestID)))
		BEGIN
			SET @IsSuccessfullyProcessed = 0
			-- Write Error Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET ErrorMessage = 'Potential 4 PRP Patient Slip Closed, manual intervention is needed.'
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
		END
		--Must have a Current Surgery Client Membership
		ELSE IF @CurrentSurgeryMembershipGUID IS NULL
			BEGIN
				SET @IsSuccessfullyProcessed = 1
				-- Write Error Message to the IncomingRequestLog Table
				Update datIncomingRequestLog
					SET ErrorMessage = 'Unable to process, client is not in a Surgery Membership'
						,WarningMessage = 'Process skipped since HC did not sell this Add-on.'
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
				SET @IsSuccessfullyProcessed = 1
				-- Write Error Message to the IncomingRequestLog Table
				Update datIncomingRequestLog
					SET ErrorMessage = 'Unable to process, client does not have active Add-On'
						,WarningMessage = 'Process skipped since HC did not sell this Add-on.'
						,LastUpdate = GETUTCDATE()
						,LastUpdateUser = @User
				FROM datIncomingRequestLog
				WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
			END
		--There can only be 1 active PRP Add-On
		ELSE IF @PRPAddOnCount > 1
			BEGIN
				SET @IsSuccessfullyProcessed = 0
				-- Write Error Message to the IncomingRequestLog Table
				Update datIncomingRequestLog
					SET ErrorMessage = 'Unable to process, more than 1 PRP Add-On exists'
						,LastUpdate = GETUTCDATE()
						,LastUpdateUser = @User
				FROM datIncomingRequestLog
				WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
			END
		ELSE
			BEGIN
				DECLARE @MEMBERSHIP_PAYMENT_SALESCODE INT
						,@BOSLEY_PAYMENT_SALESCODE INT
						,@BOSLEY_REFUND_SALESCODE INT
						,@BOSLEY_ROOMRESERVATION_SALESCODE INT
						,@BOSLEY_ADJUST_SALESCODE INT
						,@BOSLEY_ADJUST_SALESCODE_TG INT
						,@BOSLEY_ADJUST_SALESCODE_TGBPS INT
						,@BOSLEY_ADJUST_SALESCODE_PRP INT
						,@BOSLEY_ADJUST_SALESCODE_CS INT
						,@BOSLEY_PERFORM_SALESCODE INT
						,@BOSLEY_PERFORM_SURGERY_SALESCODE INT
						,@ADDON_TGE_PAYMENT_SALESCODE INT
						,@ADDON_TGE9BPS_PAYMENT_SALESCODE INT


				SELECT @MEMBERSHIP_PAYMENT_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] WHERE [SalesCodeDescriptionShort] = 'MEMPMT'
				SELECT @BOSLEY_PAYMENT_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMPMT'
				SELECT @BOSLEY_REFUND_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMRFD'
				SELECT @BOSLEY_ROOMRESERVATION_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSRMRES'
				SELECT @BOSLEY_ADJUST_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMADJ'

				SELECT @BOSLEY_PERFORM_SURGERY_SALESCODE = salesCodeID FrOM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSSURGERY'

				SELECT @BOSLEY_ADJUST_SALESCODE_TG = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMADJTG'
				SELECT @BOSLEY_ADJUST_SALESCODE_TGBPS = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMADJTGBPS'
				SELECT @BOSLEY_ADJUST_SALESCODE_CS = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMADJCS'

				SELECT @ADDON_TGE_PAYMENT_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] WHERE [SalesCodeDescriptionShort] = 'MEDADDONPMTTRI'
				SELECT @ADDON_TGE9BPS_PAYMENT_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] WHERE [SalesCodeDescriptionShort] = 'MEDADDONPMTTRI9'


				IF @PRPAddOn = @ADDON_TGE
					BEGIN
						SELECT @BOSLEY_PERFORM_SALESCODE = salesCodeID FrOM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSPERFTG'
						SET @BOSLEY_ADJUST_SALESCODE_PRP = @BOSLEY_ADJUST_SALESCODE_TG
					END
				ELSE IF @PRPAddOn = @ADDON_TGE9BPS
					BEGIN
						SELECT @BOSLEY_PERFORM_SALESCODE = salesCodeID FrOM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSPERFTGBPS'
						SET @BOSLEY_ADJUST_SALESCODE_PRP = @BOSLEY_ADJUST_SALESCODE_TGBPS
					END
				ELSE
				  BEGIN
					SET @IsSuccessfullyProcessed = 0
					-- Write Error Message to the IncomingRequestLog Table
					Update datIncomingRequestLog
						SET ErrorMessage = 'Unable to process, Add-On doesn''t exist to lookup sales code ''' + @PRPAddOn + ''''
							,LastUpdate = GETUTCDATE()
							,LastUpdateUser = @User
					FROM datIncomingRequestLog
					WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
				  END


				DECLARE @INTERCO_BOSLEY_TENDERTYPEID INT
						,@MEMBERSHIP_TENDERTYPEID INT
						,@CLIENTMEMBERSHIPADDONSTATUS_CLOSED INT
						,@ADDON_COOLSCULPTING INT

				SELECT @INTERCO_BOSLEY_TENDERTYPEID = TenderTypeID  from LkpTenderType Where TenderTypeDescriptionShort = 'InterCoBOS'
				SELECT @MEMBERSHIP_TENDERTYPEID = TenderTypeID  from LkpTenderType Where TenderTypeDescriptionShort = 'Membership'
				SELECT @CLIENTMEMBERSHIPADDONSTATUS_CLOSED = ClientMembershipAddOnStatusID FROM [dbo].[lkpClientMembershipAddOnStatus] WHERE [ClientMembershipAddOnStatusDescriptionShort] = 'Completed'
				SELECT @ADDON_COOLSCULPTING = AddOnID FROM [dbo].[cfgAddOn] WHERE [AddOnDescriptionShort] = 'PRP'

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
								LEFT OUTER JOIN datSalesOrderDetail sod on so.SalesOrderGUId = sod.SalesOrderGUID
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
								LEFT OUTER JOIN datSalesOrderDetail sod on so.SalesOrderGUId = sod.SalesOrderGUID
									AND (sod.SalesCodeID = @BOSLEY_PERFORM_SURGERY_SALESCODE)
							WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

							-- Determine if adjustment is needed to balance out surgery prior to writing
							-- TriGen transaction
							SET @ADJUSTMENT_TOTAL = ISNULL(@SURGERY_TOTAL,0)- ISNULL(@PAYMENT_TOTAL,0)
							SET @ADJUSTMENT_QUANTITY = IIF(@ADJUSTMENT_TOTAL > 0, 1, -1)

							-- Write Adjustment record if necessary
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
							AND sod.SalesCodeID in (@ADDON_TGE_PAYMENT_SALESCODE, @ADDON_TGE9BPS_PAYMENT_SALESCODE)
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
									,@BOSLEY_ADJUST_SALESCODE_PRP as SalesCodeID
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
							,@BOSLEY_PERFORM_SALESCODE as SalesCodeID
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
								,@MEMBERSHIP_TENDERTYPEID
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
			END

		UPDATE c SET
			EmailAddress = @EmailAddress
			,LastUpdate = GETUTCDATE()
			,LastUpdateUser = @User
		FROM datClient c
		WHERE c.ClientGUID = @ClientGUID
			AND (c.EmailAddress IS NULL OR c.EmailAddress = '')
			AND (@EmailAddress IS NOT NULL AND @EmailAddress <> '')

END
GO
