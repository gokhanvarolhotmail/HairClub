/* CreateDate: 04/24/2017 09:24:10.083 , ModifyDate: 03/09/2020 15:11:19.097 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				extBosleyProcessTreatmentPlanTransactionTriGen

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		4/18/17

LAST REVISION DATE: 	4/18/17

--------------------------------------------------------------------------------------------------------
NOTES: 	Processes Cool Sculpting transactions sent by Bosley.
	* 04/18/17 PRM - Created
	* 06/21/17 MVT - Modified to use Utility for creating new membership. Modified logic to create
					a new Surgery Membership if there is no active Surgery. (TFS #9179)
	* 06/27/17 MVT - Modified logic to update Total Count to 1 And Total Due to 0 if we receive a quantity greater than 1 (TFS #9213)
	* 08/19/17 MVT - Add a check to determine if a Treatment Plan is for a procedure that has already been completed. (TFS #9462).
					- Added 2 checks, one that checks if the Procedure date on the Treatment Plan is over 6 months old from Create Date and
						a check for the Patient Slip Closed with the same Procedure date.
	* 09/06/17 MVT - Modified to only process first TriGen Add-on for Client.  Additional TriGen Treatment Plans will be ignored. (TFS #9516).
					- Modified to only process Treatment Plan only if the Center is Active for the specified Treatment Plan Date. (TFS #9539).
	* 03/27/19 SAL - Added ContractPrice, ContractPaidAmount, and Term, to datClientMembershipAddOn INSERT (TFS #12172)
	* 04/30/19 SAL - Removed code that creates the sales order for a contract ajustment when cancelling
						the Alternate Add-On.  No longer need to adjust the contract because Add-Ons are now being
						accounted for on their own and are not lumped into the Client Membership. (TFS #12385)
	* 09/11/19 MVT - Removed logic that writes Be Back Show Sale activity to OnContact.  NCC currently does not call Surgery No Buy clients.
					We'll update data in SF when we re-work the flow from a Lead to a Client (TFS #13032).
	* 01/23/20 MVT - Updated to update Bosley SF Account ID on the client record if not set or different. When checking for previous
					 transactions, added to also check on Bosley SF Account ID. (TFS #13773)
	* 02/05/20 MVT - Added follwoing verifications of incoming transactions prior to processing (TFS #13809):
						* Added error check to verify ConectID is specified
						* Added error check to verify TreatmentPlanGraftCount is 0, then default to 1
						* Added error check to verify TreatmetnPlanContractAmount is > 0 and TreatmentPlanGraftCount is not > 1 (commented out for now)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:
DECLARE @IsSuccessfullyProcessed bit = 0
exec [extBosleyProcessTreatmentPlanTransactionTriGen] @CurrentTransactionIdBeingProcessed, 'TGE', 'TGE9BPS', @IsSuccessfullyProcessed OUTPUT
***********************************************************************/

CREATE PROCEDURE [dbo].[extBosleyProcessTreatmentPlanTransactionTriGen]
	  @CurrentTransactionIdBeingProcessed INT,
	  @AddOn_Main NVARCHAR(15),
	  @AddOn_Alt NVARCHAR(15),
	  @IsSuccessfullyProcessed BIT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

		DECLARE @User nvarchar(25) = 'Bosley-TP-TGE'

		DECLARE @CMSADDONSTATUS_ACTIVE nvarchar(15) = 'Active'
		DECLARE @CMSADDONSTATUS_CANCELLED nvarchar(15) = 'Canceled'
		DECLARE @MEMBERSHIP_SURGERYOFFERED nvarchar(15) = 'SNSSURGOFF'
		DECLARE @SALESCODE_MEDADDONTG nvarchar(15) = 'MEDADDONTG'
		DECLARE @SALESCODE_MEDADDONTG9 nvarchar(15) = 'MEDADDONTG9'
		DECLARE @SALESCODE_CANCELADDON nvarchar(15) = 'CANCELADDON'
		DECLARE @MEMBERSHIP_TENDER nvarchar(15) = 'Membership'
		DECLARE @SalesOrderGUID uniqueidentifier = NEWID()
		DECLARE @InvoiceNumber nvarchar(50)
		DECLARE @TempInvoiceTable table (InvoiceNumber nvarchar(50))
		DECLARE @EmployeeGUID uniqueidentifier
		DECLARE @MembershipTenderTypeID int

		DECLARE @ClientGUID UNIQUEIDENTIFIER,
				@ProcedureStatus NVARCHAR(30),
				@CenterID INT,
				@CurrentSurgeryMembershipGUID UNIQUEIDENTIFIER,
				@MembershipDescriptionShort NVARCHAR(15),
				@TOTAL_CYCLES INT,
				@TOTAL_DUE DECIMAL(21,6),
				@PRICE DECIMAL(21,6),
				@IsSurgeryActive BIT,
				@ProcedureDate DATE,
				@TreatmentPlanDate DATE,
				@SiebelID NVARCHAR(50),
				@BosleySalesforceAccountID NVARCHAR(50)

		DECLARE	@CurrentContractBal DECIMAL(21,6) = 0

		SELECT @ClientGUID = c.ClientGUID,
				@ProcedureStatus = irl.ProcedureStatus,
				@CenterID = c.CenterID,
				@CurrentSurgeryMembershipGUID = CurrentSurgeryClientMembershipGUID,
				@MembershipDescriptionShort = m.MembershipDescriptionShort,
				@IsSurgeryActive = cms.IsActiveMembershipFlag,
				@TOTAL_CYCLES = CASE WHEN ISNULL(irl.TreatmentPlanGraftCount,1) > 1 THEN irl.TreatmentPlanGraftCount ELSE 1 END, -- Default to 1 if NULL or 0
				@TOTAL_DUE = ISNULL(irl.TreatmentPlanContractAmount,0),
				@ProcedureDate = CAST(irl.ProcedureDate AS Date),
				@TreatmentPlanDate = CAST(irl.TreatmentPlanDate AS Date),
				@SiebelID = irl.SiebelID,
				@BosleySalesforceAccountID = irl.BosleySalesforceAccountID
		FROM datIncomingRequestLog irl
			INNER JOIN datClient c on c.ClientIdentifier = irl.ConectID
			LEFT JOIN datClientMembership cm ON c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
			LEFT JOIN cfgMembership m ON cm.MembershipId = m.MembershipId
			LEFT JOIN lkpClientMembershipStatus cms ON cm.ClientMembershipStatusId = cms.ClientMembershipStatusId
		WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed


		SELECT @MembershipTenderTypeID = TenderTypeID FROM lkpTenderType WHERE TenderTypeDescriptionShort = @MEMBERSHIP_TENDER
		SELECT @EmployeeGUID = e.EmployeeGUID FROM datEmployee e inner join datIncomingRequestLog irl on e.UserLogin = LEFT(irl.ConsultantUserName,CHARINDEX('_',irl.ConsultantUserName)-1) Where irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

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
			-- We are receiving a Treatment Plan without a ConectID
			SET @IsSuccessfullyProcessed = 0
			-- Write Error Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET ErrorMessage = 'Unable to process, client not found.'
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
		END
		ELSE IF EXISTS (SELECT *
					FROM datClientMembership cm
						INNER JOIN datClientMembershipAddOn	cma ON cma.ClientMembershipGUID = cm.ClientMembershipGUID
						INNER JOIN cfgAddOn a ON a.AddOnID = cma.AddOnID
					WHERE cm.ClientGUID = @ClientGUID
						AND a.AddOnDescriptionShort IN ('TGE', 'TGE9BPS'))
		BEGIN
			SET @IsSuccessfullyProcessed = 1
			-- Write Warning Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET WarningMessage = 'Treatment Plan not processed since client already had TriGen Add-On'
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
		END
		ELSE IF @TreatmentPlanDate < '4/24/2017'
		BEGIN
			SET @IsSuccessfullyProcessed = 1
			-- Write Warning Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET WarningMessage = 'Treatment Plan not processed since TreatmentPlanDate is prior to HC Go Live date of 4/24/2017'
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
		END
		ELSE IF @CenterID NOT IN ('250','249','201','202','204','299','219','257','256','276','214','275','211','277','203')
			AND @TreatmentPlanDate < '8/26/2017'
		BEGIN
			SET @IsSuccessfullyProcessed = 1
			-- Write Warning Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET WarningMessage = 'Treatment Plan not processed because TriGen is not available to be sold in Center ' + CAST(@CenterID AS nvarchar(4)) + ' on the specified Treatment Plan Date.'
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
		END
		ELSE IF NOT EXISTS (SELECT *
					FROM cfgCenterMembership cm
						INNER JOIN cfgCenterMembershipAddOn cma ON cma.CenterMembershipID = cm.CenterMembershipID
						INNER JOIN cfgAddOn a ON a.AddOnID = cma.AddOnID
					WHERE cm.CenterID = @CenterID
						AND a.AddOnDescriptionShort IN ('TGE', 'TGE9BPS'))
		BEGIN
			-- We are only processing TriGen Treatment Plan if it's a first TriGen AddOn (doesn't matter on Status)
			SET @IsSuccessfullyProcessed = 1
			-- Write Warning Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET WarningMessage = 'Treatment Plan not processed because TriGen is not available in Center ' + CAST(@CenterID AS nvarchar(4)) + '.'
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
		END
		ELSE IF EXISTS(SELECT *
					FROM datIncomingRequestLog irl
					WHERE (irl.SiebelID = @SiebelID OR irl.BosleySalesforceAccountID = @BosleySalesforceAccountID)
						AND irl.BosleyRequestID < @CurrentTransactionIdBeingProcessed
						AND irl.ProcessName = 'PatientSlipClosedPRP'
						AND CAST(irl.ProcedureDate AS Date) = @ProcedureDate)
		BEGIN
			-- We are receiving a Treatment Plan for a Procedure Date that has already been completed.
			SET @IsSuccessfullyProcessed = 0
			-- Write Error Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET ErrorMessage = 'Unable to process, Client has already had a PRP Procedure for the specified date.'
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed

			EXEC extSiebelAddUpdateToQueue @ClientGUID

		END
		ELSE IF EXISTS(SELECT *
					FROM datIncomingRequestLog irl
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
						AND DATEDIFF(mm, irl.ProcedureDate, irl.CreateDate) > 6 )
		BEGIN
			-- Potentially old treatment plan, procedure date over 6 months old.
			SET @IsSuccessfullyProcessed = 0
			-- Write Error Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET ErrorMessage = 'Possibly an old Treatment Plan, verify Procedure Date.'
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed

			EXEC extSiebelAddUpdateToQueue @ClientGUID

		END
		---- If we want to stop processing when invalid Cycles and Amount are sent, uncomment code below.
		--ELSE IF (@TOTAL_CYCLES > 1)
		--BEGIN

		--	SET @IsSuccessfullyProcessed = 0
		--	-- Write Error Message to the IncomingRequestLog Table
		--	Update datIncomingRequestLog
		--		SET ErrorMessage = 'Unable to process, Treatment Plan Graft Count cannot be greater than 1.'
		--			,LastUpdate = GETUTCDATE()
		--			,LastUpdateUser = @User
		--	FROM datIncomingRequestLog
		--	WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed

		--END
		--ELSE IF (@TOTAL_DUE = 0)
		--BEGIN

		--	SET @IsSuccessfullyProcessed = 0
		--	-- Write Error Message to the IncomingRequestLog Table
		--	Update datIncomingRequestLog
		--		SET ErrorMessage = 'Unable to process, Treatment Plan Contract Amount not specified.'
		--			,LastUpdate = GETUTCDATE()
		--			,LastUpdateUser = @User
		--	FROM datIncomingRequestLog
		--	WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed

		--END
		ELSE
		BEGIN
			-- This is being done because we were getting bad data from Bosley.  They were sometimes sending us the surgery grafts and surger total so we decided
			-- to put this in and force a quantity of 1 and total of 0 because for the Add-On we should not be getting a quantity of more than 1.
			IF @TOTAL_CYCLES > 1
			BEGIN
				SET @TOTAL_CYCLES = 1
				SET @TOTAL_DUE = 0
			END

			SET @PRICE = IIF(@TOTAL_CYCLES = 0, 0, @TOTAL_DUE / @TOTAL_CYCLES)

			-- SalesOrderType
			DECLARE @MembershipOrder_SalesOrderTypeID INT, @SalesOrder_SalesOrderTypeID INT
			SELECT @SalesOrder_SalesOrderTypeID = SalesOrderTypeID FROM [dbo].[LkpSalesOrderType] Where SalesOrderTypeDescriptionShort = 'SO'
			SELECT @MembershipOrder_SalesOrderTypeID = SalesOrderTypeID FROM [dbo].[LkpSalesOrderType] Where SalesOrderTypeDescriptionShort = 'MO'


			IF @IsSurgeryActive IS NULL OR @IsSurgeryActive = 0 OR @MembershipDescriptionShort = @MEMBERSHIP_SURGERYOFFERED
			BEGIN
				DECLARE @NewMembershipDescriptionShort NVARCHAR(10)
						,@NewClientMembershipGUID UNIQUEIDENTIFIER
						,@AssignMembershipSalesCodeID INT
						,@BeginDate DATETIME
						,@IncomingRequestID INT

				IF @MembershipDescriptionShort = @MEMBERSHIP_SURGERYOFFERED OR @MembershipDescriptionShort IS NULL
				BEGIN
					SET @NewMembershipDescriptionShort = '1STSURG'
				END
				ELSE
				BEGIN
					SET @NewMembershipDescriptionShort = @MembershipDescriptionShort
				END

				SET @NewClientMembershipGUID = NEWID()
				SELECT @AssignMembershipSalesCodeID = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'INITASG'

				SELECT
					@BeginDate = irl.TreatmentPlanDate
					,@IncomingRequestID = irl.IncomingRequestID
				FROM datIncomingRequestLog irl
				WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed


				EXEC [utilCreateSurgeryClientMembership]
							@ClientGUID,
							@EmployeeGUID,
							@NewClientMembershipGUID,
							@NewMembershipDescriptionShort,
							'E',
							0, -- Contract Price
							0, -- Grafts
							@AssignMembershipSalesCodeID,
							@BeginDate,
							@User,
							@IncomingRequestID

				SET @CurrentSurgeryMembershipGUID = @NewClientMembershipGUID

				DECLARE @Consultant nvarchar(20)
						,@ContactID nvarchar(50)
						,@ResultCode varchar(10) = 'SHOWSALE'

				SELECT @Consultant = LEFT(irl.ConsultantUserName,CHARINDEX('_',irl.ConsultantUserName)-1)
						,@ContactID = c.ContactID
				FROM datIncomingRequestLog irl
					INNER JOIN datClient c on irl.ConectID = c.ClientIdentifier
				WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

				--Create the Beback/ShowSale Record
				--EXEC extOnContactCreateBeBackActivity @ContactID, @CenterID, @Consultant, @ResultCode

				EXEC extBosleyUpdateProcedureAppointment @CurrentTransactionIdBeingProcessed

				EXEC extSiebelAddUpdateToQueue @ClientGUID
			END


			DECLARE @ClientMembershipAddOnID INT,
					@ClientMembershipAddOnID_Alt INT,
					@AddOnId INT,
					@AddOnId_Alt INT,
					@ClientMembershipAddOnStatusID_Active INT,
					@ClientMembershipAddOnStatusID_Canceled INT,
					@SalesCodeId_MedAddOn INT,
					@SalesCodeId_CancelAddOn INT

			SELECT @AddOnId = AddOnID FROM cfgAddOn WHERE AddOnDescriptionShort = @AddOn_Main
			SELECT @AddOnId_Alt = AddOnID FROM cfgAddOn WHERE AddOnDescriptionShort = @AddOn_Alt
			SELECT @ClientMembershipAddOnStatusID_Active = ClientMembershipAddOnStatusID FROM lkpClientMembershipAddOnStatus WHERE ClientMembershipAddOnStatusDescriptionShort = @CMSADDONSTATUS_ACTIVE
			SELECT @ClientMembershipAddOnStatusID_Canceled = ClientMembershipAddOnStatusID FROM lkpClientMembershipAddOnStatus WHERE ClientMembershipAddOnStatusDescriptionShort = @CMSADDONSTATUS_CANCELLED

			IF @AddOn_Main = 'TGE'
				SELECT @SalesCodeId_MedAddOn = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = @SALESCODE_MEDADDONTG
			ELSE IF @AddOn_Main = 'TGE9BPS'
				SELECT @SalesCodeId_MedAddOn = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = @SALESCODE_MEDADDONTG9

			SELECT @SalesCodeId_CancelAddOn = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = @SALESCODE_CANCELADDON

			SELECT TOP 1 @ClientMembershipAddOnID = ClientMembershipAddOnID
			FROM datClientMembershipAddOn cmao
			WHERE cmao.ClientMembershipGUID = @CurrentSurgeryMembershipGUID
				AND cmao.AddOnId = @AddOnId
				AND cmao.ClientMembershipAddOnStatusID = @ClientMembershipAddOnStatusID_Active

			SELECT TOP 1 @ClientMembershipAddOnID_Alt = ClientMembershipAddOnID
			FROM datClientMembershipAddOn cmao
			WHERE cmao.ClientMembershipGUID = @CurrentSurgeryMembershipGUID
				AND cmao.AddOnId = @AddOnId_Alt
				AND cmao.ClientMembershipAddOnStatusID = @ClientMembershipAddOnStatusID_Active

			SET @IsSuccessfullyProcessed = 1

			--Cancel the Alternate Add-On
			--NOTE:  New logic was put in above to only process first TriGen Add-on for Client. (TFS #9516). So, this logic will never get executed but we're leaving it here.
			IF @ClientMembershipAddOnID_Alt IS NOT NULL
				BEGIN
					UPDATE datClientMembershipAddOn
					SET ClientMembershipAddOnStatusID = @ClientMembershipAddOnStatusID_Canceled,
						LastUpdate = GETUTCDATE(),
						LastUpdateUser = @User
					WHERE ClientMembershipAddOnID = @ClientMembershipAddOnID_Alt


					SET @SalesOrderGUID = NEWID()

					--create an invoice #
					INSERT INTO @TempInvoiceTable EXEC ('mtnGetInvoiceNumber ' + @CenterID)
					SELECT TOP 1 @InvoiceNumber = InvoiceNumber FROM @TempInvoiceTable
					DELETE FROM @TempInvoiceTable

					INSERT INTO [dbo].[datSalesOrder] (SalesOrderGUID, TenderTransactionNumber_Temp, TicketNumber_Temp, CenterID, ClientHomeCenterID, SalesOrderTypeID, ClientGUID, ClientMembershipGUID,
														AppointmentGUID, HairSystemOrderGUID, OrderDate, InvoiceNumber, IsTaxExemptFlag, IsVoidedFlag, IsClosedFlag, RegisterCloseGUID, EmployeeGUID,
														FulfillmentNumber, IsWrittenOffFlag, IsRefundedFlag, RefundedSalesOrderGUID, CreateDate, CreateUser, LastUpdate, LastUpdateUser,
														ParentSalesOrderGUID , IsSurgeryReversalFlag, IsGuaranteeFlag, cashier_temp, ctrOrderDate, CenterFeeBatchGUID, CenterDeclineBatchGUID,
														RegisterID, EndOfDayGUID, IncomingRequestID)
					Select @SalesOrderGUID as SalesOrderGUID
						,NULL as TenderTransactionNumber_Temp
						,NULL as TicketNumber_Temp
						,c.CenterID as CenterID
						,c.CenterID as ClientHomeCenterID
						,@MembershipOrder_SalesOrderTypeID as SalesOrderTypeID
						,c.ClientGUID as ClientGUID
						,@CurrentSurgeryMembershipGUID as ClientMembershipGUID
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
					FROM datIncomingRequestLog irl
						INNER JOIN [dbo].[datClient] c on irl.ConectID = c.ClientIdentifier
						INNER JOIN [dbo].[datClientMembership] cm on irl.ClientMembershipID = cm.ClientMembershipIdentifier
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

					INSERT INTO datSalesOrderDetail (SalesOrderDetailGUID, TransactionNumber_Temp, SalesOrderGUID, SalesCodeID , Quantity, Price, Discount, Tax1, Tax2, TaxRate1, TaxRate2,
													IsRefundedFlag, RefundedSalesOrderDetailGUID, RefundedTotalQuantity, RefundedTotalPrice, Employee1GUID, Employee2GUID, Employee3GUID, Employee4GUID,
													PreviousClientMembershipGUID, NewCenterID, CreateDate, CreateUser, LastUpdate, LastUpdateUser, Center_Temp, performer_temp, performer2_temp,
													Member1Price_temp, CancelReasonID, EntrySortOrder, HairSystemOrderGUID, DiscountTypeID, BenefitTrackingEnabledFlag, MembershipPromotionID,
													MembershipOrderReasonID, MembershipNotes, GenericSalesCodeDescription, SalesCodeSerialNumber, ClientMembershipAddOnID)
					SELECT NEWID() as SalesOrderDetailGUID
						,NULL as TransactionNumber_Temp
						,@SalesOrderGUID as SalesOrderGUID
						,@SalesCodeId_CancelAddOn as SalesCodeID
						,1 as Quantity
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
						,@ClientMembershipAddOnID_Alt as ClientMembershipAddOnID

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

			SET @IsSuccessfullyProcessed = 1

			IF @ClientMembershipAddOnID IS NOT NULL
				BEGIN

					-- Ignore transaction if Add-On already exists
					Update datIncomingRequestLog
						SET WarningMessage = 'Transaction ignored by Treatment Plan Processing due to active Add-On already exists.'
							,LastUpdate = GETUTCDATE()
							,LastUpdateUser = @User
					FROM datIncomingRequestLog
					WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
				END
			ELSE
				BEGIN
					-- Add the Add-On to the client membership
					INSERT INTO datClientMembershipAddOn (ClientMembershipGUID, AddOnID, ClientMembershipAddOnStatusID, Price, Quantity, ContractPrice, ContractPaidAmount, Term, MonthlyFee, CreateDate, CreateUser, LastUpdate, LastUpdateUser) VALUES
						(@CurrentSurgeryMembershipGUID, @AddOnId, @ClientMembershipAddOnStatusID_Active, @PRICE, @TOTAL_CYCLES, (@PRICE * @TOTAL_CYCLES), 0, NULL, NULL, GETUTCDATE(), @User, GETUTCDATE(), @User)

					--Grab the Id of the new record just created
					SET @ClientMembershipAddOnID = SCOPE_IDENTITY()

					INSERT INTO datClientMembershipAccum (ClientMembershipAccumGUID,ClientMembershipGUID,AccumulatorID,UsedAccumQuantity,AccumMoney,AccumDate,TotalAccumQuantity,CreateDate,CreateUser,LastUpdate,LastUpdateUser)
						SELECT NEWID(), @CurrentSurgeryMembershipGUID, aoa.AccumulatorID, 0, 0, NULL, @TOTAL_CYCLES * ISNULL(aoa.InitialQuantity, 1), GETUTCDATE(), @User, GETUTCDATE(), @User
						FROM cfgAddOnAccumulator aoa
						WHERE aoa.AddOnID = @AddOnId


						SET @SalesOrderGUID = NEWID()

						--create an invoice #
						INSERT INTO @TempInvoiceTable EXEC ('mtnGetInvoiceNumber ' + @CenterID)
						SELECT TOP 1 @InvoiceNumber = InvoiceNumber FROM @TempInvoiceTable
						DELETE FROM @TempInvoiceTable

						INSERT INTO [dbo].[datSalesOrder] (SalesOrderGUID, TenderTransactionNumber_Temp, TicketNumber_Temp, CenterID, ClientHomeCenterID, SalesOrderTypeID, ClientGUID, ClientMembershipGUID,
															AppointmentGUID, HairSystemOrderGUID, OrderDate, InvoiceNumber, IsTaxExemptFlag, IsVoidedFlag, IsClosedFlag, RegisterCloseGUID, EmployeeGUID,
															FulfillmentNumber, IsWrittenOffFlag, IsRefundedFlag, RefundedSalesOrderGUID, CreateDate, CreateUser, LastUpdate, LastUpdateUser,
															ParentSalesOrderGUID , IsSurgeryReversalFlag, IsGuaranteeFlag, cashier_temp, ctrOrderDate, CenterFeeBatchGUID, CenterDeclineBatchGUID,
															RegisterID, EndOfDayGUID, IncomingRequestID)
						Select @SalesOrderGUID as SalesOrderGUID
							,NULL as TenderTransactionNumber_Temp
							,NULL as TicketNumber_Temp
							,c.CenterID as CenterID
							,c.CenterID as ClientHomeCenterID
							,@MembershipOrder_SalesOrderTypeID as SalesOrderTypeID
							,c.ClientGUID as ClientGUID
							,@CurrentSurgeryMembershipGUID as ClientMembershipGUID
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
						FROM datIncomingRequestLog irl
							INNER JOIN [dbo].[datClient] c on irl.ConectID = c.ClientIdentifier
							INNER JOIN [dbo].[datClientMembership] cm on irl.ClientMembershipID = cm.ClientMembershipIdentifier
						WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

						INSERT INTO datSalesOrderDetail (SalesOrderDetailGUID, TransactionNumber_Temp, SalesOrderGUID, SalesCodeID , Quantity, Price, Discount, Tax1, Tax2, TaxRate1, TaxRate2,
														IsRefundedFlag, RefundedSalesOrderDetailGUID, RefundedTotalQuantity, RefundedTotalPrice, Employee1GUID, Employee2GUID, Employee3GUID, Employee4GUID,
														PreviousClientMembershipGUID, NewCenterID, CreateDate, CreateUser, LastUpdate, LastUpdateUser, Center_Temp, performer_temp, performer2_temp,
														Member1Price_temp, CancelReasonID, EntrySortOrder, HairSystemOrderGUID, DiscountTypeID, BenefitTrackingEnabledFlag, MembershipPromotionID,
														MembershipOrderReasonID, MembershipNotes, GenericSalesCodeDescription, SalesCodeSerialNumber, ClientMembershipAddOnID)
						SELECT NEWID() as SalesOrderDetailGUID
							,NULL as TransactionNumber_Temp
							,@SalesOrderGUID as SalesOrderGUID
							,@SalesCodeId_MedAddOn as SalesCodeID
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
		END
END
GO
