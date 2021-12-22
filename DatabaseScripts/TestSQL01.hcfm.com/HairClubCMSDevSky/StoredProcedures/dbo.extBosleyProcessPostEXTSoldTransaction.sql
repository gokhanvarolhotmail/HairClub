/* CreateDate: 06/10/2013 20:12:27.287 , ModifyDate: 03/09/2020 15:11:19.343 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				extBosleyProcessPostEXTSoldTransaction

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tpvbin

IMPLEMENTOR: 			Mike Tpvbin

DATE IMPLEMENTED: 		5/31/13

LAST REVISION DATE: 	5/31/13

--------------------------------------------------------------------------------------------------------
NOTES: 	Processes Post EXT Sold transactions sent by Bosley.
	* 05/31/13 MLM - Created
	* 08/16/13 MLM - Modified to Handle BIO & PostEXT Client Memberships
	* 09/19/13 MVT - Modified so that payments are always assigned to Surgery memberships.
					 The processing will stop if no surgery membership exists.
	* 01/20/14 MLM - Fixed issue with SalesCodeID being sent to NULL
	* 08/28/14 MVT - Fixed issue with Bosley Request ID being written to datSalesOrder IncomingRequestID column.
	* 11/17/2014 DL - Changed procedure to use current surgery client membership from the client table.
	* 05/24/18 MVT - Added logic to update email if sent by Bosley.
	* 01/27/20 MVT - Updated to set Bosley SF Account ID on the client record if not set or different. (TFS #13773)
	* 02/05/20 MVT - Added follwoing verifications of incoming transactions prior to processing (TFS #13809):
						* Added error check to verify ConectID is specified

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [extBosleyProcessPostEXTSoldTransaction] @CurrentTransactionIdBeingProcessed, @IsSuccessfullyProcessed OUTPUT

***********************************************************************/

CREATE PROCEDURE [dbo].[extBosleyProcessPostEXTSoldTransaction]
	  @CurrentTransactionIdBeingProcessed INT,
	  @IsSuccessfullyProcessed BIT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;


	BEGIN TRY

		DECLARE @User nvarchar(10) = 'Bosley'

		DECLARE @ClientGUID uniqueidentifier
				,@CenterID int
				,@SurClientMembershipGUID uniqueidentifier
				,@BosleySalesforceAccountID nvarchar(50)

		SELECT @ClientGUID = c.ClientGuid
				,@CenterID = c.CenterID
				,@SurClientMembershipGUID = c.[CurrentSurgeryClientMembershipGUID]
				,@BosleySalesforceAccountID = irl.BosleySalesforceAccountID
		FROM [dbo].[datIncomingRequestLog] irl
			INNER JOIN [dbo].[datClient] c on irl.ConectID = c.ClientIdentifier
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
			SET @IsSuccessfullyProcessed = 0
			-- Write Error Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET ErrorMessage = 'Unable to process, client not found.'
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
		END
		--Must have a Current Surgery Client Membership
		ELSE IF @SurClientMembershipGUID IS NULL
			BEGIN
				SET @IsSuccessfullyProcessed = 0
				-- Write Error Message to the IncomingRequestLog Table
				Update datIncomingRequestLog
					SET ErrorMessage = 'Unable to process, no Treatment Plan received'
						,LastUpdate = GETDATE()
						,LastUpdateUser = @User
				FROM datIncomingRequestLog
				WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed

			END
		ELSE
			BEGIN
				-- Variable declarations
				DECLARE @EmployeeGUID Uniqueidentifier
				SELECT @EmployeeGUID = e.EmployeeGUID FROM datEmployee e inner join datIncomingRequestLog irl on e.UserLogin = LEFT(irl.ConsultantUserName,CHARINDEX('_',irl.ConsultantUserName)-1) Where irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
				DECLARE @ClientMembershipGUID uniqueidentifier


				-- Always select Surgery membership.  Verified above that surgery membership exists.
				--SELECT @SurClientMembershipGUID = CASE WHEN bs.BusinessSegmentDescriptionShort = 'SUR' THEN cm.clientMembershipGUID
				--									ELSE c.[CurrentSurgeryClientMembershipGUID] END
				SELECT @SurClientMembershipGUID = c.[CurrentSurgeryClientMembershipGUID]
				FROM [dbo].[datIncomingRequestLog] irl
								INNER JOIN datClient c ON irl.ConectID = c.ClientIdentifier
								--INNER JOIN [dbo].[datClientMembership] cm on irl.ClientMembershipID = cm.ClientMembershipIdentifier
								--INNER JOIN datClient c ON c.ClientGuid = cm.ClientGuid
								--INNER JOIN cfgMembership mem ON mem.MembershipID = cm.MembershipID
								--INNER JOIN lkpBusinessSegment bs ON bs.BusinessSegmentID = mem.BusinessSegmentID
							WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed


				DECLARE @TempInvoiceTable table
						(
							InvoiceNumber nvarchar(50)
						)
				DECLARE @InvoiceNumber nvarchar(50)

				DECLARE @POSTEXTPMT nvarchar(10) = 'POSTEXTPMT'

				IF EXISTS (SELECT c.* FROM datClient c
										INNER JOIN datClientMembership cm ON c.[CurrentExtremeTherapyClientMembershipGUID] = cm.ClientMembershipGuid
										INNER JOIN lkpClientMembershipStatus stat ON stat.ClientMembershipStatusID = cm.ClientMembershipStatusID
								WHERE c.ClientGUID = @ClientGUID
										AND stat.[IsActiveMembershipFlag] = 1)
					BEGIN
						IF EXISTS (SELECT * FROM datClientMembership cm
										INNER JOIN lkpClientMembershipStatus stat ON stat.ClientMembershipStatusID = cm.ClientMembershipStatusID
										INNER JOIN datSalesOrder so on so.ClientMembershipGUID = cm.ClientMembershipGUID
										INNER JOIN datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
										INNER JOIN cfgSalesCode sc on sod.SalesCodeID = sc.SalesCodeID
								WHERE cm.ClientMembershipGuid = @SurClientMembershipGUID
										AND stat.[IsActiveMembershipFlag] = 1
										AND sc.SalesCodeDescriptionShort = @POSTEXTPMT)
							BEGIN
								-- Skip this record since Active EXT membership exists.
								-- add warning
								UPDATE irl SET
									WarningMessage = 'Payment for PostEXT Membership has already been accepted: ' + cm.ClientMembershipIdentifier
									,LastUpdate = GETUTCDATE()
									,LastUpdateUser = @User
								FROM datIncomingRequestLog irl
									INNER JOIN datClient c ON c.ClientIdentifier = irl.ConectID
									INNER JOIN datClientMembership cm ON c.[CurrentExtremeTherapyClientMembershipGUID] = cm.ClientMembershipGuid
								WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
							END
							ELSE
							BEGIN
									---- Get the EXT ClientMembershipGUID
									--SELECT @ClientMembershipGUID = c.[CurrentExtremeTherapyClientMembershipGUID] FROM datClient c WHERE c.ClientGUID = @ClientGUID

									--create an invoice #
									INSERT INTO @TempInvoiceTable
										EXEC ('mtnGetInvoiceNumber ' + @CenterID)

									SELECT TOP 1 @InvoiceNumber = InvoiceNumber
									FROM @TempInvoiceTable

									DELETE FROM @TempInvoiceTable
									--Enter POSTEXT Payment
									exec [extBosleyProcessCreatePostEXTPayment] @CurrentTransactionIdBeingProcessed, @InvoiceNumber, @CenterID, @ClientGUID, @SurClientMembershipGUID, @EmployeeGUID, @User, @IsSuccessfullyProcessed
							END

					END
				ELSE IF EXISTS (SELECT c.* FROM datClient c
										INNER JOIN cfgCenter ctr on c.CenterID = ctr.CenterID
										INNER JOIN lkpCountry co on ctr.CountryID = co.CountryID
								WHERE c.ClientGUID = @ClientGUID
										AND co.CountryDescriptionShort = 'CA')
					BEGIN
						-- Skip Processing Canadian Centers
						-- add warning
						UPDATE irl SET
							WarningMessage = 'Canada Center - not processed: ' + cm.ClientMembershipIdentifier
							,LastUpdate = GETUTCDATE()
							,LastUpdateUser = @User
						FROM datIncomingRequestLog irl
							INNER JOIN datClient c ON c.ClientIdentifier = irl.ConectID
							INNER JOIN datClientMembership cm ON c.[CurrentExtremeTherapyClientMembershipGUID] = cm.ClientMembershipGuid
						WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed
					END
				ELSE IF EXISTS (SELECT c.* FROM datClient c
										INNER JOIN cfgConfigurationCenter cent ON c.CenterID = cent.CenterID
										INNER JOIN lkpCenterBusinessType bt ON bt.CenterBusinessTypeID = cent.CenterBusinessTypeID
								WHERE c.ClientGUID = @ClientGUID
										AND bt.CenterBusinessTypeDescriptionShort <> 'cONEctCorp')
					BEGIN

						--create an invoice #
						INSERT INTO @TempInvoiceTable
							EXEC ('mtnGetInvoiceNumber ' + @CenterID)

						SELECT TOP 1 @InvoiceNumber = InvoiceNumber
						FROM @TempInvoiceTable

						DELETE FROM @TempInvoiceTable

						--Enter POSTEXT Payment
						exec [extBosleyProcessCreatePostEXTPayment] @CurrentTransactionIdBeingProcessed, @InvoiceNumber, @CenterID, @ClientGUID, @SurClientMembershipGUID, @EmployeeGUID, @User, @IsSuccessfullyProcessed
					END
				ELSE
					BEGIN

						DECLARE @SalesOrderGUID uniqueidentifier = NEWID()

						DECLARE @MEMBERSHIP_TENDERTYPEID INT
						Select @MEMBERSHIP_TENDERTYPEID = TenderTypeID  from LkpTenderType Where TenderTypeDescriptionShort = 'Membership'

						-- SalesOrderType
						DECLARE @MembershipOrder_SalesOrderTypeID INT
						SELECT @MembershipOrder_SalesOrderTypeID = SalesOrderTypeID FROM [dbo].[LkpSalesOrderType] Where SalesOrderTypeDescriptionShort = 'MO'

						DECLARE @MembershipBeginDate datetime
							,@ActiveClientMembershipStatusID int
							,@ClientMembershipNumber nvarchar(50)
							,@NewMembershipID int
							,@NewMembershipDurationMonths int
							,@FirstSurgeryMembershipID int
							,@IncomingRequestID int


						SELECT @IncomingRequestID = r.IncomingRequestID
						FROM datIncomingRequestLog r
						WHERE r.BosleyRequestID = @CurrentTransactionIdBeingProcessed

						SET @ClientMembershipGUID = NEWID()
						SET @MembershipBeginDate = GETDATE()

						SELECT @ActiveClientMembershipStatusID = ClientMembershipStatusID FROM lkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = 'A'
						SELECT @NewMembershipID = MembershipID, @NewMembershipDurationMonths = ISNULL(DurationMonths,0) FROM cfgMembership WHERE MembershipDescriptionShort = 'POSTEXT'
						SELECT @FirstSurgeryMembershipID = MembershipID FROM cfgMembership WHERE MembershipDescriptionShort = '1STSURG'  -- Used to find a Membership Rule

						DECLARE @BOSLEY_PAYMENT_SALESCODE INT
								, @MembershipOrderSalesCodeID INT

						SELECT @BOSLEY_PAYMENT_SALESCODE = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSMEMPMT'
						SELECT @MembershipOrderSalesCodeID = mr.SalesCodeID
							FROM cfgMembershipRule mr
								--INNER JOIN lkpClientMembershipStatus cms ON mr.CurrentMembershipStatusID = cms.ClientMembershipStatusID
								INNER JOIN lkpCenterBusinessType bt ON bt.CenterBusinessTypeID = mr.CenterBusinessTypeID
							WHERE mr.NewMembershipID = @NewMembershipID
								AND mr.CurrentMembershipID = @FirstSurgeryMembershipID
								--AND cms.IsActiveMembershipFlag = 1
								AND bt.CenterBusinessTypeDescriptionShort = 'cONEctCorp'

						-------------------------------------------
						--  Create new Client Membership
						--------------------------------------------
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
							@NewMembershipID AS  MembershipID,
							@ActiveClientMembershipStatusID AS  ClientMembershipStatusID,
							0 AS ContractPrice,
							0 AS ContractPaidAmount,
							0 AS MonthlyFee,
							@MembershipBeginDate AS  BeginDate,
							DATEADD(MONTH, @NewMembershipDurationMonths, @MembershipBeginDate)  AS  EndDate,
							NULL AS  MembershipCancelReasonID,
							NULL AS  CancelDate,
							0 AS  IsGuaranteeFlag,
							0 AS  IsRenewalFlag,
							0 AS  IsMultipleSurgeryFlag,
							0 AS  RenewalCount,
							1 AS  IsActiveFlag,
							GETUTCDATE() AS CreateDate, @User AS CreateUser, GETUTCDATE() AS LastUpdate, @User AS LastUpdateUser, @ClientMembershipNumber

						--Get Client Membership Number
						EXEC [mtnGetClientMembershipNumber] @ClientGUID, @CenterID, @MembershipBeginDate, @ClientMembershipNumber OUTPUT

						-- Update Client Membershp Identifier
						UPDATE datClientMembership SET
							[ClientMembershipIdentifier] = @ClientMembershipNumber
						WHERE clientmembershipguid = @ClientMembershipGUID


						-- Update Memberhsip on the client record
						UPDATE datClient SET
							CurrentExtremeTherapyClientMembershipGUID = @ClientMembershipGUID
							, LastUpdateUser = @User
							, LastUpdate = GETUTCDATE()
						WHERE ClientGUID = @ClientGUID

						--Create Client Membership Accumulator records
						INSERT INTO [datClientMembershipAccum] ([ClientMembershipAccumGUID],[ClientMembershipGUID],[AccumulatorID],[UsedAccumQuantity],[AccumMoney],[AccumDate],[TotalAccumQuantity],[CreateDate],[CreateUser],[LastUpdate], [LastUpdateUser])
						SELECT NEWID(), @ClientMembershipGUID, AccumulatorID, 0, 0.00, NULL, InitialQuantity,
							GETUTCDATE(),@User,GETUTCDATE(),@User
						FROM cfgMembershipAccum
						WHERE MembershipID = @NewMembershipID
							AND IsActiveFlag = 1

						-------------------------------------------
						--  Create MO for the new Client Membership
						--------------------------------------------
						SET @SalesOrderGUID = NEWID()

						--create an invoice #
						INSERT INTO @TempInvoiceTable
							EXEC ('mtnGetInvoiceNumber ' + @CenterID)

						SELECT TOP 1 @InvoiceNumber = InvoiceNumber
						FROM @TempInvoiceTable

						DELETE FROM @TempInvoiceTable

						--INSERT Sales Order record
						INSERT INTO datSalesOrder (SalesOrderGUID, TenderTransactionNumber_Temp, TicketNumber_Temp, CenterID, ClientHomeCenterID,
							SalesOrderTypeID, ClientGUID, ClientMembershipGUID, AppointmentGUID, HairSystemOrderGUID, OrderDate, InvoiceNumber,
							IsTaxExemptFlag, IsVoidedFlag, IsClosedFlag, EmployeeGUID, FulfillmentNumber, IsWrittenOffFlag,
							IsRefundedFlag, RefundedSalesOrderGUID, IsSurgeryReversalFlag, IsGuaranteeFlag,
							CreateDate, CreateUser, LastUpdate, LastUpdateUser,[IncomingRequestID])
						SELECT
							@SalesOrderGUID AS SalesOrderGUID,
							NULL AS TenderTransactionNumber_Temp, NULL AS TicketNumber_Temp,
							cm.CenterID AS CenterID, cm.CenterID AS ClientHomeCenterID,
							@MembershipOrder_SalesOrderTypeID AS SalesOrderTypeID, --Membership
							cm.ClientGUID AS ClientGUID,
							cm.ClientMembershipGUID,
							NULL AS AppointmentGUID,
							NULL AS FactoryOrderGUID,
							GETUTCDATE() AS OrderDate,
							@InvoiceNumber AS InvoiceNumber,
							0 AS IsTaxExemptFlag, 0 AS IsVoidedFlag, 1 AS IsClosedFlag,
							@EmployeeGuid AS EmployeeGUID, NULL AS FulfillmentNumber,
							0 AS IsWrittenOffFlag, 0 AS IsRefundedFlag, NULL AS RefundedSalesOrderGUID,
							0, -- IsSurgeryReversalFlag
							0, -- IsGuaranteeFlag
							GETUTCDATE() AS CreateDate, @User AS CreateUser, GETUTCDATE() AS LastUpdate, @User AS LastUpdateUser,@IncomingRequestID
						FROM datClientMembership cm
							INNER JOIN cfgCenter c ON cm.CenterID = c.CenterID
						WHERE cm.ClientMembershipGUID = @ClientMembershipGUID

						--INSERT Sales Order Detail record
						INSERT INTO datSalesOrderDetail ([SalesOrderDetailGUID],[TransactionNumber_Temp],[SalesOrderGUID],[SalesCodeID],
							[Quantity],[Price],[Discount],[Tax1],[Tax2],[TaxRate1],[TaxRate2],
							[IsRefundedFlag],[RefundedSalesOrderDetailGUID],[RefundedTotalQuantity],[RefundedTotalPrice],
							[Employee1GUID],[Employee2GUID],[Employee3GUID],[Employee4GUID],
							[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser], [MembershipPromotionID])
						SELECT
								NEWID() AS SalesOrderDetailGUID, NULL AS TransactionNumber_Temp
							, @SalesOrderGUID AS SalesOrderGUID
							, @MembershipOrderSalesCodeID AS SalesCodeID
							, 1 AS [Quantity] -- Set Quantity to 1
							, 0 AS [Price]
							, 0 AS [Discount]
							, 0 AS [Tax1], 0 AS [Tax2], 0 AS [TaxRate1], 0 AS [TaxRate2]
							, 0 AS [IsRefundedFlag], NULL AS [RefundedSalesOrderDetailGUID], 0 AS [RefundedTotalQuantity], 0 AS [RefundedTotalPrice]
							, @EmployeeGuid AS [Employee1GUID], NULL AS [Employee2GUID], NULL AS [Employee3GUID], NULL AS [Employee4GUID]
							, GETUTCDATE() AS CreateDate, @User AS CreateUser, GETUTCDATE() AS LastUpdate, @User AS LastUpdateUser
							, NULL
						FROM datClientMembership cm
							INNER JOIN cfgCenter c ON cm.CenterID = c.CenterID
						WHERE cm.ClientMembershipGUID = @ClientMembershipGUID

						--- Create a $0 Membership Tender
						INSERT INTO [datSalesOrderTender]
									([SalesOrderTenderGUID]
									,[SalesOrderGUID]
									,[TenderTypeID]
									,[Amount]
									,[CreateDate]
									,[CreateUser]
									,[LastUpdate]
									,[LastUpdateUser])
							VALUES (
									NEWID()
								,	@SalesOrderGUID
								,   @MEMBERSHIP_TENDERTYPEID  -- Membership Tender type
								,	0  -- Amount
								,	GETUTCDATE()
								,	@User
								,	GETUTCDATE()
								,	@User )

						-- Call the Accum Stored Proc
						EXEC [dbo].[mtnMembershipAccumAdjustment] 'SALES ORDER', @SalesOrderGUID

						--create an invoice #
						INSERT INTO @TempInvoiceTable
							EXEC ('mtnGetInvoiceNumber ' + @CenterID)

						SELECT TOP 1 @InvoiceNumber = InvoiceNumber
						FROM @TempInvoiceTable

						DELETE FROM @TempInvoiceTable

						exec [extBosleyProcessCreatePostEXTPayment] @CurrentTransactionIdBeingProcessed, @InvoiceNumber, @CenterID, @ClientGUID, @SurClientMembershipGUID, @EmployeeGUID, @User, @IsSuccessfullyProcessed


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

				SET @IsSuccessfullyProcessed = 1
			END


	END TRY

	BEGIN CATCH
			SET @IsSuccessfullyProcessed = 0
			-- Write Error Message to the IncomingRequestLog Table
			Update datIncomingRequestLog
				SET ErrorMessage = Error_Procedure() + ':' + Error_Message()
					,LastUpdate = GETDATE()
					,LastUpdateUser = @User
			FROM datIncomingRequestLog
			WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed
	END CATCH

END
GO
