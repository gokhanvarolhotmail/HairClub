/* CreateDate: 05/09/2013 20:28:43.510 , ModifyDate: 03/09/2020 15:11:19.007 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				extBosleyProcessTreatmentPlanTransaction

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		4/30/13

LAST REVISION DATE: 	3/23/16

--------------------------------------------------------------------------------------------------------
NOTES: 	Processes transactions sent by Bosley.
	* 04/30/13 MLM - Created
	* 05/14/13 MLM - Added ProcessName to the datRequestQueue
	* 05/22/13 MLM - Added IncomingRequestID to the datSalesOrder
	* 05/23/13 MLM - Added call to Create the Beback/Showsale Record
	* 05/30/13 MVT - Modified to use "Membership" tender type for MO.
	* 06/03/13 MVT - Modified to use Invoice Number proc.
	* 07/19/13 MLM - Added Additional Memberships to Process SHOWSALE
	* 07/29/13 MLM - Added First Surgery & Additional Surgery Memberships to the List of Memberships to be Processed.
	* 08/01/13 MLM - Fixed Issue with Converted and Renewed Membership Sales Codes
	* 08/16/13 MLM - Modified the handle BIO & PostExt Memberships
	* 08/30/13 MLM - Fixed Issue with Active First Surgery Memberships creating an additional First Surgery Membership
	* 10/10/13 MVT - Moved the update to Bosley to the end.
	* 04/24/14 MLM - Added check to see if client had a membership in SP Status.
	* 03/23/16 MVT - Added logic to ignore Treatment Plan if Client is already in an Active 1st/Additional
					 Surgery membership.  Also added logic to send an update to Bosley if transaction is ignored.
					 Added Trasaction around the processing. (TFS #6632)
	* 04/19/17 PRM - Added logic to reassign active Add-On's to new membership
	* 05/26/17 MVT - Fixed issue with non-surgery Client Memberships being set to expired.
	* 06/01/17 PRM - Removed try/catch and transactional logic and handling it in the main proc to avoid transactional errors
	* 08/19/17 MVT - Add a check to determine if a Treatment Plan is for a procedure that has already been completed. (TFS #9462).
					- Added 2 checks, one that checks if the Procedure date on the Treatment Plan is over 6 months old from Create Date and
						a check for the Patient Slip Closed with the same Procedure date.
	* 05/24/18 MVT - Added logic to update email if sent by Bosley.
	* 03/27/19 SAL - Added ContractPrice, ContractPaidAmount, and Term, to datClientMembershipAddOn INSERT (TFS #12172)
	* 09/11/19 MVT - Removed logic that writes Be Back Show Sale activity to OnContact.  NCC currently does not call Surgery No Buy clients.
					We'll update data in SF when we re-work the flow from a Lead to a Client (TFS #13032).
	* 01/23/20 MVT - Updated to update Bosley SF Account ID on the client record if not set or different. When checking for previous
					 transactions, added to also check on Bosley SF Account ID. (TFS #13773)
	* 02/05/20 MVT - Added follwoing verifications of incoming transactions prior to processing (TFS #13809):
						* Added error check to verify ConectID is specified
						* Added error check to verify TreatmentPlanGraftCount is > 0
						* Added error check to verify TreatmetnPlanContractAmount is > 0
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:
DECLARE @IsSuccessfullyProcessed bit = 0
exec [extBosleyProcessTreatmentPlanTransaction] @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT

***********************************************************************/

CREATE PROCEDURE [dbo].[extBosleyProcessTreatmentPlanTransaction]
	  @CurrentTransactionIdBeingProcessed INT,
	  @IsSuccessfullyProcessed BIT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

		DECLARE @ClientGUID UNIQUEIDENTIFIER
		DECLARE @ConectID INT
		DECLARE @ProcedureDate DATE
		DECLARE @SiebelID NVARCHAR(50)
		DECLARE @BosleySalesforceAccountID NVARCHAR(50)
		DECLARE @TreatmentPlanGraftCount INT
		DECLARE @TreatmentPlanContractAmount MONEY

		DECLARE @User NVARCHAR(25) = 'Bosley-TP'

		SELECT @ClientGUID = c.ClientGUID
				, @ConectID = irl.ConectID
				, @ProcedureDate = CAST(irl.ProcedureDate AS Date)
				, @SiebelID = irl.SiebelID
				, @BosleySalesforceAccountID = irl.BosleySalesforceAccountID
				, @TreatmentPlanGraftCount = irl.TreatmentPlanGraftCount
				, @TreatmentPlanContractAmount = irl.TreatmentPlanContractAmount
			FROM datIncomingRequestLog irl
				INNER JOIN datClient c on c.ClientIdentifier = irl.ConectID
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
		ELSE IF EXISTS(SELECT *
					FROM datIncomingRequestLog irl
					WHERE
						(irl.SiebelID = @SiebelID
								OR irl.BosleySalesforceAccountID = @BosleySalesforceAccountID
								OR irl.ConectID = @ConectID)
						AND irl.BosleyRequestID < @CurrentTransactionIdBeingProcessed
						AND irl.ProcessName = 'PatientSlipClosed'
						AND CAST(irl.ProcedureDate AS Date) = @ProcedureDate)
		BEGIN
			-- We are receiving a Treatment Plan for a Procedure Date that has already been completed.
			SET @IsSuccessfullyProcessed = 0
			-- Write Error Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET ErrorMessage = 'Unable to process, Client has already had a Procedure for the specified date.'
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
		ELSE IF EXISTS(SELECT *
					FROM datIncomingRequestLog irl
						INNER JOIN datClientMembership cm on irl.ClientMembershipID = cm.ClientMembershipIdentifier
						INNER JOIN cfgMembership m on cm.MembershipID = m.MembershipID
						INNER JOIN lkpBusinessSegment bs on m.BusinessSegmentId = bs.BusinessSegmentID
						INNER JOIN datClient c on cm.ClientGUID = c.ClientGUID
					WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
						AND c.CurrentSurgeryClientMembershipGUID IS NOT NULL
						AND (bs.BusinessSegmentDescriptionShort = 'BIO' OR bs.BusinessSegmentDescriptionShort = 'EXT'))
		BEGIN

			SET @IsSuccessfullyProcessed = 0
			-- Write Error Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET ErrorMessage = 'Unable to process, Client is already in a Surgery Membership.'
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed

			EXEC extSiebelAddUpdateToQueue @ClientGUID

		END
		ELSE IF EXISTS(SELECT *
						FROM datIncomingRequestLog irl
							INNER JOIN datClient c ON c.ClientIdentifier = irl.ConectID
							INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = c.CurrentSurgeryClientMembershipGUID
							INNER JOIN lkpClientMembershipStatus st ON st.ClientMembershipStatusID = cm.ClientMembershipStatusID
							INNER JOIN cfgMembership m ON m.MembershipID = cm.MembershipID
						WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
							AND st.ClientMembershipStatusDescriptionShort = 'A'
							AND m.MembershipDescriptionShort IN ('1STSURG','ADDSURG'))
		BEGIN
			-- Ignore transaction if the client is in either 1ST Surgery or
			-- Additional Surgery Active Membership.
			SET @IsSuccessfullyProcessed = 1
			-- Write Warning Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET WarningMessage = 'Transaction ignored by Treatment Plan Processing due to Client being in an Active Surgery Membership.'
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed

		END
		ELSE IF (@TreatmentPlanGraftCount IS NULL
					OR @TreatmentPlanGraftCount = 0
					OR @TreatmentPlanContractAmount IS NULL
					OR @TreatmentPlanContractAmount = 0)
		BEGIN

			SET @IsSuccessfullyProcessed = 0
			-- Write Error Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET ErrorMessage = 'Unable to process, Treatment Plan Graft Count And/Or Contract Amount not specified.'
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed

		END
		ELSE
		BEGIN

			--First Create a new ClientMembership of type First Surgery
			DECLARE @ClientMembershipGUID UNIQUEIDENTIFIER,
					@CenterID INT,
					@SURGERY_MEMBERSHIP_ID INT,
					@FIRST_SURGERY INT,
					@ADDITIONAL_SURGERY INT,
					@PREVIOUS_CLIENTMEMBERSHIPGUID UNIQUEIDENTIFIER,
					@PreviousClientMembershipStatusDescriptionShort nvarchar(10),
					@PreviousMembershipID int,
					@PreviousMembershipBusinessSegment nvarchar(10),
					@ActiveClientMembershipStatusID INT,
					@ClientMembershipStatusID INT,
					@ExpiredClientMembershipStatusID INT,
					@ContractPrice DECIMAL(21,6),
					@GraftCount INT,
					@PlanDate DATETIME,
					@ClientMembershipNumber NVARCHAR(50),
					@ASSIGN_MEMBERSHIP_SALESCODE INT,
					@BOSLEY_REFUND_SALESCODE INT,
					@CONVERT_MEMBERSHIP_SALESCODE INT,
					@RENEW_MEMBERSHIP_SALESCODE INT,
					@MEMBERSHIP_SALESCODE INT,
					@INSERT_CLIENTMEMBERSHIP_SO BIT,
					@CLIENTMEMBERSHIPADDONSTATUS_ACTIVE INT,
					@CLIENTMEMBERSHIPADDONSTATUS_REASSIGN INT,
					@CLIENTMEMBERSHIPADDONSTATUS_CANCELED INT

			DECLARE @TempAddOnTable table (ClientMembershipAddOnID INT, NewStatusID INT, AddOnDescriptionShort nvarchar(15))

			SET @INSERT_CLIENTMEMBERSHIP_SO = 1

			SELECT @ClientMembershipGUID = NEWID()
			SELECT @FIRST_SURGERY = MembershipID FROM cfgMembership WHERE MembershipDescriptionShort = '1STSURG'
			SELECT @ADDITIONAL_SURGERY = MembershipID FROM cfgMembership WHERE MembershipDescriptionShort = 'ADDSURG'

			SELECT @ActiveClientMembershipStatusID = ClientMembershipStatusID FROM LkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = 'A'
			SELECT @ExpiredClientMembershipStatusID = ClientMembershipStatusID FROM LkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = 'E'

			SELECT @ASSIGN_MEMBERSHIP_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'INITASG'
			SELECT @BOSLEY_REFUND_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMRFD'
			SELECT @CONVERT_MEMBERSHIP_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'CONV'
			SELECT @RENEW_MEMBERSHIP_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'RENEW'

			SELECT @CLIENTMEMBERSHIPADDONSTATUS_ACTIVE = ClientMembershipAddOnStatusID FROM [dbo].[lkpClientMembershipAddOnStatus] WHERE [ClientMembershipAddOnStatusDescriptionShort] = 'Active'
			SELECT @CLIENTMEMBERSHIPADDONSTATUS_REASSIGN = ClientMembershipAddOnStatusID FROM [dbo].[lkpClientMembershipAddOnStatus] WHERE [ClientMembershipAddOnStatusDescriptionShort] = 'Reassign'
			SELECT @CLIENTMEMBERSHIPADDONSTATUS_CANCELED = ClientMembershipAddOnStatusID FROM [dbo].[lkpClientMembershipAddOnStatus] WHERE [ClientMembershipAddOnStatusDescriptionShort] = 'Canceled'


			SELECT @PREVIOUS_CLIENTMEMBERSHIPGUID = cm.ClientMembershipGUID
				,@PreviousMembershipID = cm.MembershipID
				,@PreviousMembershipBusinessSegment = bs.BusinessSegmentDescriptionShort
				,@ClientGUID = cm.ClientGUID
				,@CenterID = c.CenterID
				,@ContractPrice = irl.TreatmentPlanContractAmount
				,@GraftCount = irl.TreatmentPlanGraftCount
				,@PlanDate = irl.TreatmentPlanDate
				,@PreviousClientMembershipStatusDescriptionShort = stat.ClientMembershipStatusDescriptionShort
			FROM datClientMembership cm
				INNER JOIN datIncomingRequestLog irl on cm.ClientMembershipIdentifier = irl.ClientMembershipID
				INNER JOIN datClient c on cm.ClientGUID = c.ClientGUID
				INNER JOIN lkpClientMembershipStatus stat on stat.ClientMembershipStatusID = cm.ClientMembershipStatusID
				INNER JOIN cfgMembership m ON m.MembershipID = cm.MembershipID
				INNER JOIN lkpBusinessSegment bs ON bs.BusinessSegmentID = m.BusinessSegmentID
			WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

			DECLARE @IsAdditionalSurgery bit = 0

			IF EXISTS (SELECT *
						FROM datIncomingRequestLog irl
							INNER JOIN datClientMembership cm on irl.ClientMembershipID = cm.ClientMembershipIdentifier
							INNER JOIN cfgMembership m on cm.MembershipID = m.MembershipID
							INNER JOIN lkpClientMembershipStatus cms on cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
						WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
							AND m.MembershipDescriptionShort IN ('1STSURG', 'ADDSURG')
							AND cms.ClientMembershipStatusDescriptionShort = 'SP')
			BEGIN
				SET @IsAdditionalSurgery = 1
			END

			IF (@IsAdditionalSurgery = 0) AND
					EXISTS (SELECT *	-- Check if a client has a surgery Membership that is in a Surgery Performed Status.
							FROM datIncomingRequestLog irl
								INNER JOIN datClient c ON c.ClientIdentifier = irl.ConectID
								INNER JOIN datClientMembership cm on cm.ClientGUID = c.ClientGUID
								INNER JOIN cfgMembership m on cm.MembershipID = m.MembershipID
								--INNER JOIN lkpBusinessSegment bs ON bs.BusinessSegmentID = m.BusinessSegmentID
								INNER JOIN lkpClientMembershipStatus cms on cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
							WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
								AND m.MembershipDescriptionShort IN ('1STSURG', 'ADDSURG')
								AND cms.ClientMembershipStatusDescriptionShort = 'SP')
			BEGIN
				SET @IsAdditionalSurgery = 1
			END

			-- Membership Assigned depends the current Membership
			IF (@IsAdditionalSurgery =  1)
				BEGIN
					SET @SURGERY_MEMBERSHIP_ID = @ADDITIONAL_SURGERY
					SET @ClientMembershipStatusID = @ActiveClientMembershipStatusID

					--IF PreviousMembership was First Surgery then STatus is Converted, If previous Membership was Additional the Client Membership Status is Renewed.
					IF (@PreviousMembershipID = @FIRST_SURGERY)
						BEGIN
							SET @MEMBERSHIP_SALESCODE = @CONVERT_MEMBERSHIP_SALESCODE
						END
					ELSE
						BEGIN
							SET @MEMBERSHIP_SALESCODE = @RENEW_MEMBERSHIP_SALESCODE
						END

				END
			ELSE
				BEGIN
					SET @SURGERY_MEMBERSHIP_ID = @FIRST_SURGERY
					SET @ClientMembershipStatusID = @ActiveClientMembershipStatusID
					SET @MEMBERSHIP_SALESCODE = @ASSIGN_MEMBERSHIP_SALESCODE
				END

			-- Expire the Previous Membership, Except for Active First Surgery and Additional Surgery
			IF NOT EXISTS(SELECT *
				FROM datIncomingRequestLog irl
					INNER JOIN datClientMembership cm on irl.ClientMembershipID = cm.ClientMembershipIdentifier
					INNER JOIN cfgMembership m on cm.MembershipID = m.MembershipID
					INNER JOIN lkpClientMembershipStatus cms on cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
					INNER JOIN lkpBusinessSegment bs on m.BusinessSegmentId = bs.BusinessSegmentID
				WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
					AND bs.BusinessSegmentDescriptionShort = 'SUR'
					AND (m.MembershipID = @FIRST_SURGERY or m.MembershipID =  @ADDITIONAL_SURGERY)
					AND cms.ClientMembershipStatusDescriptionShort = 'A')
				BEGIN

					--INSERT Client Membership record
					INSERT INTO datClientMembership (
						ClientMembershipGUID,
						Member1_ID_Temp,
						ClientGUID,
						CenterID,
						MembershipID,
						ClientMembershipStatusID,
						ContractPrice,
						ContractPaidAmount,
						MonthlyFee,
						BeginDate,
						EndDate,
						MembershipCancelReasonID,
						CancelDate,
						IsGuaranteeFlag,
						IsRenewalFlag,
						IsMultipleSurgeryFlag,
						RenewalCount,
						IsActiveFlag,
						CreateDate, CreateUser, LastUpdate, LastUpdateUser,
						ClientMembershipIdentifier)
					SELECT
						@ClientMembershipGUID AS  ClientMembershipGUID,
						NULL AS  Member1_ID_Temp,
						@ClientGUID AS  ClientGUID,
						@CenterID AS  CenterID,
						@SURGERY_MEMBERSHIP_ID AS  MembershipID,
						@ClientMembershipStatusID AS  ClientMembershipStatusID,
						@ContractPrice AS ContractPrice,
						0 AS  ContractPaidAmount,
						0 AS  MonthlyFee,
						@PlanDate AS  BeginDate,
						DATEADD(YEAR, 1, @PlanDate)  AS  EndDate,
						NULL AS  MembershipCancelReasonID,
						NULL AS  CancelDate,
						0 AS  IsGuaranteeFlag,
						0 AS  IsRenewalFlag,
						0 AS  IsMultipleSurgeryFlag,
						0 AS  RenewalCount,
						1 AS  IsActiveFlag,
						GETUTCDATE() AS CreateDate, @User AS CreateUser, GETUTCDATE() AS LastUpdate, @User AS LastUpdateUser, @ClientMembershipNumber

					--Get Client Membership Number
					EXEC [mtnGetClientMembershipNumber] @ClientGUID, @CenterID, @PlanDate, @ClientMembershipNumber OUTPUT

					-- Update Client Membershp Identifier
					UPDATE datClientMembership SET
						[ClientMembershipIdentifier] = @ClientMembershipNumber
						,LastUpdate = GETUTCDATE()
						,LastUpdateUser = @User
					WHERE clientmembershipguid = @ClientMembershipGUID

					IF (@PreviousMembershipBusinessSegment = 'SUR' AND @PreviousClientMembershipStatusDescriptionShort = 'A')
					BEGIN
						--Expired the previous Membership
						UPDATE datClientMembership SET
							EndDate = DATEADD(DAY,-1,@PlanDate)
							,ClientMembershipStatusID = @ExpiredClientMembershipStatusID
							,LastUpdate = GETUTCDATE()
							,LastUpdateUser = @User
						WHERE clientmembershipguid = @PREVIOUS_CLIENTMEMBERSHIPGUID
					END

					-- Update Memberhsip on the client record
					UPDATE datClient SET
							CurrentSurgeryClientMembershipGUID = @ClientMembershipGUID
						, LastUpdateUser = @User
						, LastUpdate = GETUTCDATE()
					WHERE ClientGUID = @ClientGUID

					--Create Client Membership Accumulator records
					INSERT INTO [datClientMembershipAccum] ([ClientMembershipAccumGUID],[ClientMembershipGUID],[AccumulatorID],[UsedAccumQuantity],[AccumMoney],[AccumDate],[TotalAccumQuantity],[CreateDate],[CreateUser],[LastUpdate], [LastUpdateUser])
					SELECT NEWID(), @ClientMembershipGUID, AccumulatorID, 0, 0.00, NULL, InitialQuantity,
						GETUTCDATE(),@User,GETUTCDATE(),@User
					FROM cfgMembershipAccum
					WHERE MembershipID = @SURGERY_MEMBERSHIP_ID
						AND IsActiveFlag = 1

					--Get a list of Add-On's to cancel and reassign
					INSERT INTO @TempAddOnTable
					SELECT ClientMembershipAddOnID,
						CASE WHEN ao.CarryOverToNewMembership = 1 THEN @CLIENTMEMBERSHIPADDONSTATUS_REASSIGN ELSE @CLIENTMEMBERSHIPADDONSTATUS_CANCELED END,
						ao.AddOnDescriptionShort
					FROM datClientMembershipAddOn cmao
						INNER JOIN cfgAddOn ao ON cmao.AddOnID = ao.AddOnID
					WHERE cmao.ClientMembershipGUID = @PREVIOUS_CLIENTMEMBERSHIPGUID
						AND cmao.ClientMembershipAddOnStatusID = @CLIENTMEMBERSHIPADDONSTATUS_ACTIVE

					--Cancel or Reassign old, active Add-On's
					UPDATE cmao
					SET ClientMembershipAddOnStatusID = ao.NewStatusID
						,LastUpdate = GETUTCDATE()
						,LastUpdateUser = @User
					FROM datClientMembershipAddOn cmao
						INNER JOIN @TempAddOnTable ao ON cmao.ClientMembershipAddOnID = ao.ClientMembershipAddOnID

					--Move the reassigned add-on's to the new membership
					INSERT INTO datClientMembershipAddOn (ClientMembershipGUID, AddOnID, ClientMembershipAddOnStatusID, Price, Quantity, ContractPrice, ContractPaidAmount, Term, MonthlyFee, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
						SELECT @ClientMembershipGUID, AddOnID, @CLIENTMEMBERSHIPADDONSTATUS_ACTIVE, Price, Quantity, ContractPrice, ContractPaidAmount, Term, MonthlyFee, GETUTCDATE(), @User, GETUTCDATE(), @User
						FROM datClientMembershipAddOn cmao
							INNER JOIN @TempAddOnTable ao ON cmao.ClientMembershipAddOnID = ao.ClientMembershipAddOnID
						WHERE ao.NewStatusID = @CLIENTMEMBERSHIPADDONSTATUS_REASSIGN

					INSERT INTO datClientMembershipAccum (ClientMembershipAccumGUID,ClientMembershipGUID,AccumulatorID,UsedAccumQuantity,AccumMoney,AccumDate,TotalAccumQuantity,CreateDate,CreateUser,LastUpdate,LastUpdateUser)
						SELECT NEWID(), cmao.ClientMembershipGUID, aoa.AccumulatorID, 0, 0, NULL, cmao.Quantity * ISNULL(aoa.InitialQuantity, 1), GETUTCDATE(), @User, GETUTCDATE(), @User
						FROM datClientMembershipAddOn cmao
							INNER JOIN cfgAddOnAccumulator aoa ON cmao.AddOnID = aoa.AddOnID
						WHERE cmao.ClientMembershipGUID = @ClientMembershipGUID
				END
			ELSE
				BEGIN
					--Client Membership already Exists do not Create a Membership Order
					SET @INSERT_CLIENTMEMBERSHIP_SO = 0
				END


			IF @INSERT_CLIENTMEMBERSHIP_SO = 1
				BEGIN

					DECLARE @SalesOrderGUID uniqueidentifier = NEWID()

					DECLARE @INTERCO_BOSLEY_TENDERTYPEID INT, @MEMBERSHIP_TENDERTYPEID INT

					Select @INTERCO_BOSLEY_TENDERTYPEID = TenderTypeID  from LkpTenderType Where TenderTypeDescriptionShort = 'InterCoBOS'
					Select @MEMBERSHIP_TENDERTYPEID = TenderTypeID  from LkpTenderType Where TenderTypeDescriptionShort = 'Membership'


					DECLARE @EmployeeGUID Uniqueidentifier
					SELECT @EmployeeGUID = e.EmployeeGUID FROM datEmployee e inner join datIncomingRequestLog irl on e.UserLogin = LEFT(irl.ConsultantUserName,CHARINDEX('_',irl.ConsultantUserName)-1) Where irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

					-- SalesOrderType
					DECLARE @MembershipOrder_SalesOrderTypeID INT, @SalesOrder_SalesOrderTypeID INT
					SELECT @SalesOrder_SalesOrderTypeID = SalesOrderTypeID FROM [dbo].[LkpSalesOrderType] Where SalesOrderTypeDescriptionShort = 'SO'
					SELECT @MembershipOrder_SalesOrderTypeID = SalesOrderTypeID FROM [dbo].[LkpSalesOrderType] Where SalesOrderTypeDescriptionShort = 'MO'

					DECLARE @TempInvoiceTable table
					(
						InvoiceNumber nvarchar(50)
					)
					DECLARE @InvoiceNumber nvarchar(50)

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
						,@ClientMembershipGUID as ClientMembershipGUID
						,NULL as AppointmentGUID
						,NULL as HairSystemOrderGUID
						,@PlanDate as OrderDate
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
						,@PlanDate as ctrOrderDate
						,NULL as CenterFeeBatchGUID
						,NULL as CenterDeclineBatchGUID
						,NULL as RegisterID
						,NULL as EndOfDayGUID
						,irl.IncomingRequestID as IncomingRequestID
					from [dbo].[datIncomingRequestLog] irl
					INNER JOIN [dbo].[datClient] c on irl.ConectID = c.ClientIdentifier
					INNER JOIN [dbo].[datClientMembership] cm on irl.ClientMembershipID = cm.ClientMembershipIdentifier
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
						,@MEMBERSHIP_SALESCODE as SalesCodeID
						,@GraftCount as Quantity
						,IIF(ISNULL(@GraftCount,0) = 0, 0,@ContractPrice/@GraftCount) as [Price]
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


					--Create Membership Orders for Add-On's (both Canceled & Reassigned)

					DECLARE @SalesCodeId INT,
							@SalesCodeId_MedAddOn INT,
							@SalesCodeId_MedAddOnCS INT,
							@SalesCodeId_MedAddOnTGE INT,
							@SalesCodeId_MedAddOnTGE9 INT,
							@SalesCodeId_CancelAddOn INT,
							@SalesCodeId_Reassign INT

					SELECT @SalesCodeId_MedAddOnCS = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'MEDADDONCS'
					SELECT @SalesCodeId_MedAddOnTGE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'MEDADDONTG'
					SELECT @SalesCodeId_MedAddOnTGE9 = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'MEDADDONTG9'
					SELECT @SalesCodeId_CancelAddOn = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'CANCELADDON'
					SELECT @SalesCodeId_Reassign = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'REASGNADDON'



					DECLARE @ClientMembershipAddOnID INT,
							@NewStatusID INT,
							@AddOnDescriptionShort nvarchar(15)

					DECLARE @AddOnCursor as CURSOR;


					--Add Membership Orders for old membership Cancel/Reassigned Add-On's
					SET @AddOnCursor = CURSOR FAST_FORWARD FOR
						SELECT ClientMembershipAddOnID, NewStatusID, AddOnDescriptionShort
						FROM @TempAddOnTable

					OPEN @AddOnCursor
					FETCH NEXT FROM @AddOnCursor INTO @ClientMembershipAddOnID, @NewStatusID, @AddOnDescriptionShort
						WHILE @@FETCH_STATUS = 0
					BEGIN

						SET @SalesOrderGUID = NEWID()

						IF @NewStatusID = @CLIENTMEMBERSHIPADDONSTATUS_REASSIGN
							SET @SalesCodeId = @SalesCodeId_Reassign
						ELSE
							SET @SalesCodeId = @SalesCodeId_CancelAddOn

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
							,@PREVIOUS_CLIENTMEMBERSHIPGUID as ClientMembershipGUID
							,NULL as AppointmentGUID
							,NULL as HairSystemOrderGUID
							,@PlanDate as OrderDate
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
							,@PlanDate as ctrOrderDate
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
							,@SalesCodeId as SalesCodeID
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
							,0 as BenefitTrackingEnabledFlag
							,NULL as MembershipPromotionID
							,NULL as MembershipOrderReasonID
							,NULL as MembershipNotes
							,NULL as genericSalesCodeDescription
							,NULL as SalesCodeSerialNumber
							,@ClientMembershipAddOnID as ClientMembershipAddOnID

						--Update the Accumulators
						EXEC mtnMembershipAccumAdjustment 'SALES ORDER', @SalesOrderGUID

						FETCH NEXT FROM @AddOnCursor INTO @ClientMembershipAddOnID, @NewStatusID, @AddOnDescriptionShort
					END
					CLOSE @AddOnCursor;
					DEALLOCATE @AddOnCursor;


					--Add Membership Orders for new membership Add-On's that were reassigned
					SET @AddOnCursor = CURSOR FAST_FORWARD FOR
						SELECT ClientMembershipAddOnID, 0, AddOnDescriptionShort
						FROM datClientMembershipAddOn cmao
							INNER JOIN cfgAddOn ao ON cmao.AddOnID = ao.AddOnID
						WHERE ClientMembershipGUID = @ClientMembershipGUID

					OPEN @AddOnCursor
					FETCH NEXT FROM @AddOnCursor INTO @ClientMembershipAddOnID, @NewStatusID, @AddOnDescriptionShort
						WHILE @@FETCH_STATUS = 0
					BEGIN

						IF @AddOnDescriptionShort = 'CS'
							SET @SalesCodeId_MedAddOn = @SalesCodeId_MedAddOnCS
						ELSE IF @AddOnDescriptionShort = 'TGE'
							SET @SalesCodeId_MedAddOn = @SalesCodeId_MedAddOnTGE
						ELSE IF @AddOnDescriptionShort = 'TGE9BPS'
							SET @SalesCodeId_MedAddOn = @SalesCodeId_MedAddOnTGE9


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
							,@ClientMembershipGUID as ClientMembershipGUID
							,NULL as AppointmentGUID
							,NULL as HairSystemOrderGUID
							,@PlanDate as OrderDate
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
							,@PlanDate as ctrOrderDate
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
							,Quantity as Quantity
							,Price as [Price]
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
							,0 as BenefitTrackingEnabledFlag
							,NULL as MembershipPromotionID
							,NULL as MembershipOrderReasonID
							,NULL as MembershipNotes
							,NULL as genericSalesCodeDescription
							,NULL as SalesCodeSerialNumber
							,@ClientMembershipAddOnID as ClientMembershipAddOnID
						FROM datClientMembershipAddOn
						WHERE ClientMembershipAddOnID = @ClientMembershipAddOnID

						--Update the Accumulators
						EXEC mtnMembershipAccumAdjustment 'SALES ORDER', @SalesOrderGUID

						FETCH NEXT FROM @AddOnCursor INTO @ClientMembershipAddOnID, @NewStatusID, @AddOnDescriptionShort
					END
					CLOSE @AddOnCursor;
					DEALLOCATE @AddOnCursor;

				END -- @INSERT_CLIENTMEMBERSHIP_SO = 1


			DECLARE @Consultant nvarchar(20)
					,@ContactID nvarchar(50)
					,@ResultCode varchar(10) = 'SHOWSALE'

			SELECT @Consultant = LEFT(irl.ConsultantUserName,CHARINDEX('_',irl.ConsultantUserName)-1)
					,@ContactID = c.ContactID
			FROM datIncomingRequestLog irl
				INNER JOIN datClient c on irl.ConectID = c.ClientIdentifier
			WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

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


			----Create the Beback/ShowSale Record
			--EXEC extOnContactCreateBeBackActivity @ContactID, @CenterID, @Consultant, @ResultCode

			EXEC extBosleyUpdateProcedureAppointment @CurrentTransactionIdBeingProcessed

			EXEC extSiebelAddUpdateToQueue @ClientGUID

			SET @IsSuccessfullyProcessed = 1
		END
END
GO
