/* CreateDate: 11/01/2013 07:03:43.227 , ModifyDate: 06/01/2021 09:17:17.343 */
GO
/***********************************************************************
PROCEDURE:				extBosleyProcessBosleySoldEXTTransaction

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		10/30/13

LAST REVISION DATE: 	10/30/13

--------------------------------------------------------------------------------------------------------
NOTES: 	Processes Bosley Sold EXT transactions sent by Bosley.
	* 10/30/13 MLM - Created
	* 02/26/14 MLM - Added Check to see if Client Already Exists
	* 05/21/14 MLM - Added Discounted amount to the Membership Order Sales Order
	* 09/04/14 MVT - Resolved issue with Bosley Request ID being incorrectly written to IncomingRequestID column on the SalesOrder
	* 04/26/17 PRM - Updated to reference new datClientPhone table
	* 05/23/18 MVT - Updated to use Email Address on datIncoming request log to populate email on datClient record
	* 09/30/19 SAL - Removed @IsCMS25Center and the call to mtnClientAddCMS25 if this variable was true (TFS#13095)
	* 01/23/20 MVT - Updated to set Bosley SF Account ID on the client record (TFS #13773)
	* 04/08/21 AOS - Change from EXT9BOS, EXT9BOSSOL to EXTINITIAL
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

DECLARE @IsSuccessfullyProcessed bit = 0
exec [extBosleyProcessBosleySoldEXTTransaction] @45353, @IsSuccessfullyProcessed OUTPUT
***********************************************************************/

CREATE PROCEDURE [dbo].[extBosleyProcessBosleySoldEXTTransaction]
	  @CurrentTransactionIdBeingProcessed INT,
	  @IsSuccessfullyProcessed BIT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY

		--Check to see if Client Already Exists, if client exists fail
		IF EXISTS (SELECT * FROM datIncomingRequestLog irl
						INNER JOIN datClient c on irl.SiebelID = c.SiebelID OR irl.BosleySalesforceAccountID = c.BosleySalesforceAccountID
						WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed)
			BEGIN
				Update datIncomingRequestLog
						SET ErrorMessage = 'Client already Exists in cONEct!'
							,LastUpdate = GETUTCDATE()
							,LastUpdateUser = 'Bosley'
					FROM datIncomingRequestLog
					WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed

					SET @IsSuccessfullyProcessed = 0

			END
		ELSE
			BEGIN

				DECLARE @User nvarchar(10) = 'Bosley'
						,@CenterID int = null
						,@CountryID int
						,@StateID int
						,@State nvarchar(2)
						,@FirstName nvarchar(50)
						,@LastName nvarchar(50)
						,@Address1 nvarchar(50)
						,@City nvarchar(50)
						,@ZipCode nvarchar(10)
						,@GenderID INT
						,@Gender nvarchar(1)
						,@DoNotCall BIT = 0
						,@HomePhone nvarchar(15)
						,@WorkPhone nvarchar(15)
						,@CellPhone nvarchar(15)
						,@HomePhoneTypeID int
						,@WorkPhoneTypeID int
						,@CellPhoneTypeID int
						,@MembershipStartDate dateTime
						,@EmployeeGUID char(36)
						,@SiebelID nvarchar(50)
						,@PaymentAmount decimal(21,6)
						,@IncomingRequestID int
						,@EmailAddress nvarchar(100)
						,@BosleySalesforceAccountID nvarchar(50)

				--SET the EmployeeGUID
				SELECT @EmployeeGUID = e.EmployeeGUID FROM datEmployee e inner join datIncomingRequestLog irl on e.UserLogin = irl.SalesUserName Where irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed

				--Get PhoneTypes
				SELECT @HomePhoneTypeID = PhoneTypeID FROM lkpPhoneType Where PhoneTypeDescriptionShort = 'Home'
				SELECT @WorkPhoneTypeID = PhoneTypeID FROM lkpPhoneType Where PhoneTypeDescriptionShort = 'Work'
				SELECT @CellPhoneTypeID = PhoneTypeID FROM lkpPhoneType Where PhoneTypeDescriptionShort = 'Mobile'

				SELECT @IncomingRequestID = IncomingRequestID FROM datIncomingRequestLog WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed

				SELECT @CenterID = c.CenterID
					,@CountryID = st.CountryID
					,@StateID = st.StateID
					,@State = st.StateDescriptionShort
					,@FirstName = irl.FirstName
					,@LastName = irl.LastName
					,@Address1 = irl.Address1
					,@City = irl.City
					,@ZipCode = irl.ZipCode
					,@GenderID = g.GenderID
					,@Gender = g.GenderDescriptionShort
					,@DoNotCall = CASE WHEN irl.HomePhoneDNC = 1 or irl.WorkPhoneDNC = 1 OR irl.CellPhoneDNC = 1 THEN 1 ELSE 0 END
					,@HomePhone = irl.HomePhone
					,@WorkPhone = irl.WorkPhone
					,@CellPhone = irl.CellPhone
					,@MembershipStartDate = ISNULL(irl.MembershipStartDate, GETUTCDATE())
					,@SiebelID = irl.SiebelID
					,@PaymentAmount = irl.PaymentAmount
					,@EmailAddress = irl.EmailAddress
					,@BosleySalesforceAccountID = irl.BosleySalesforceAccountID
				FROM datIncomingRequestLog irl
					INNER JOIN cfgCenter c on irl.HC_Center = c.CenterID
					INNER JOIN cfgConfigurationCenter cc on c.CenterID = cc.CenterID
					INNER JOIN lkpCenterBusinessType cbt on cc.CenterBusinessTypeID = cbt.CenterBusinessTypeID
					INNER JOIN lkpCenterType ct on c.CenterTypeID = ct.CenterTypeID
							AND ct.CenterTypeDescriptionShort <> 'S'
					LEFT OUTER JOIN lkpState st on irl.[State] = st.StateDescriptionShort
					LEFT OUTER JOIN lkpGender g on irl.[Gender] = g.GenderDescriptionShort
				WHERE irl.BosleyRequestID = @CurrentTransactionIdBeingProcessed


				IF (@CenterID IS NOT NULL)
				BEGIN
					--Generate the new ClientGUID
					DECLARE @CLIENTGUID char(36) = NEWID()

					--Create the New Client
					INSERT INTO datClient (ClientGUID, ClientNumber_Temp, CenterID, CountryID, ContactID, SiebelID, FirstName, LastName, Address1, City, StateID, PostalCode, ARBalance, GenderID, DateOfBirth, DoNotCallFlag,
								IsTaxExemptFlag, EMailAddress, IsHairSystemClientFlag, DoNotContactFlag, IsHairModelFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser, ImportCreateDate, ImportLastUpdate, BosleySalesforceAccountID)
					VALUES(@ClientGUID, NULL, @CenterID, @CountryID, NULL, @SiebelID, @FirstName, @LastName, @Address1, @City, @StateID, @ZipCode, 0, @GenderID, NULL, @DoNotCall,
								0, @EmailAddress, 0, 0, 0, GETUTCDATE(), 'sa-Bosley', GETUTCDATE(), 'sa-Bosley', GETUTCDATE(), GETUTCDATE(), @BosleySalesforceAccountID)

					DECLARE @PhoneCount int = 1
							,@Phone nvarchar(15)
							,@PhoneType nvarchar(15)

					IF @HomePhone IS NOT NULL AND RTRIM(LTRIM(@HomePhone)) <> ''
					  BEGIN
						SET @Phone = @HomePhone
						SET @PhoneType = @HomePhoneTypeID
						INSERT INTO datClientPhone (ClientGUID, PhoneTypeID, PhoneNumber, CanConfirmAppointmentByCall, CanConfirmAppointmentByText, CanContactForPromotionsByCall, CanContactForPromotionsByText, ClientPhoneSortOrder, CreateDate, CreateUser, LastUpdate, LastUpdateUser) VALUES
							(@ClientGUID, @PhoneType, @Phone, NULL, NULL, NULL, NULL, @PhoneCount, GETUTCDATE(), 'sa-Bosley', GETUTCDATE(), 'sa-Bosley')
						SET @PhoneCount = @PhoneCount + 1
					  END
					IF @WorkPhone IS NOT NULL AND RTRIM(LTRIM(@WorkPhone)) <> ''
					  BEGIN
						SET @Phone = @WorkPhone
						SET @PhoneType = @WorkPhoneTypeID
						INSERT INTO datClientPhone (ClientGUID, PhoneTypeID, PhoneNumber, CanConfirmAppointmentByCall, CanConfirmAppointmentByText, CanContactForPromotionsByCall, CanContactForPromotionsByText, ClientPhoneSortOrder, CreateDate, CreateUser, LastUpdate, LastUpdateUser) VALUES
							(@ClientGUID, @PhoneType, @Phone, NULL, NULL, NULL, NULL, @PhoneCount, GETUTCDATE(), 'sa-Bosley', GETUTCDATE(), 'sa-Bosley')
						SET @PhoneCount = @PhoneCount + 1
					  END
					IF @CellPhone IS NOT NULL AND RTRIM(LTRIM(@CellPhone)) <> ''
					  BEGIN
						SET @Phone = @CellPhone
						SET @PhoneType = @CellPhoneTypeID
						INSERT INTO datClientPhone (ClientGUID, PhoneTypeID, PhoneNumber, CanConfirmAppointmentByCall, CanConfirmAppointmentByText, CanContactForPromotionsByCall, CanContactForPromotionsByText, ClientPhoneSortOrder, CreateDate, CreateUser, LastUpdate, LastUpdateUser) VALUES
							(@ClientGUID, @PhoneType, @Phone, NULL, NULL, NULL, NULL, @PhoneCount, GETUTCDATE(), 'sa-Bosley', GETUTCDATE(), 'sa-Bosley')
						SET @PhoneCount = @PhoneCount + 1
					  END

					--Create new Membership
					DECLARE @SalesOrderGUID uniqueidentifier = NEWID()

					DECLARE @MEMBERSHIP_TENDERTYPEID INT
					Select @MEMBERSHIP_TENDERTYPEID = TenderTypeID  from LkpTenderType Where TenderTypeDescriptionShort = 'Membership'

					-- SalesOrderType
					DECLARE @MembershipOrder_SalesOrderTypeID INT
					SELECT @MembershipOrder_SalesOrderTypeID = SalesOrderTypeID FROM [dbo].[LkpSalesOrderType] Where SalesOrderTypeDescriptionShort = 'MO'

					DECLARE @ActiveClientMembershipStatusID int
						,@ClientMembershipNumber nvarchar(50)
						,@NewMembershipID INT
						,@NewMembershipDurationMonths int
						,@GenderID_Female int
						,@ContractPrice MONEY
						,@DiscountAmount decimal(21,6) = 0
						,@Payment_Male decimal(21,6) = 2195
						,@Payment_Female decimal(21,6) = 2495
						,@ClientMembershipGUID char(36)

					SET @ClientMembershipGUID = NEWID()

					SELECT @ActiveClientMembershipStatusID = ClientMembershipStatusID FROM lkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = 'A'
					SELECT @GenderID_Female = GenderID FROM lkpGender WHERE GenderDescriptionShort = 'F'

					IF (@GenderID = @GenderID_Female)
						BEGIN
							SELECT @NewMembershipID = MembershipID, @NewMembershipDurationMonths = ISNULL(DurationMonths,0), @ContractPrice = ContractPrice FROM cfgMembership WHERE MembershipDescriptionShort = 'EXTINITIAL'
							--Calculate the Discount Amount.   The discount will be split betwen Bosley and HairClub
							SET @DiscountAmount = CASE WHEN (@Payment_Female - @PaymentAmount) < 0 THEN 0 ELSE (@Payment_Female - @PaymentAmount) /  2  END
						END
					ELSE
						BEGIN
							SELECT @NewMembershipID = MembershipID, @NewMembershipDurationMonths = ISNULL(DurationMonths,0), @ContractPrice = ContractPrice FROM cfgMembership WHERE MembershipDescriptionShort = 'EXTINITIAL'
							--Calculate the Discount Amount.   The discount will be split betwen Bosley and HairClub
							SET @DiscountAmount = CASE WHEN (@Payment_Male - @PaymentAmount) < 0 THEN 0 ELSE (@Payment_Male - @PaymentAmount) /  2  END
						END


					DECLARE @MembershipOrderSalesCodeID INT
					SELECT @MembershipOrderSalesCodeID = salesCodeID FROM [dbo].[cfgSalesCode] where [SalesCodeDescriptionShort] = 'BOSASG'




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
						@ContractPrice - @DiscountAmount AS ContractPrice,
						0 AS ContractPaidAmount,
						0 AS MonthlyFee,
						@MembershipStartDate AS  BeginDate,
						DATEADD(MONTH, @NewMembershipDurationMonths, @MembershipStartDate)  AS  EndDate,
						NULL AS  MembershipCancelReasonID,
						NULL AS  CancelDate,
						0 AS  IsGuaranteeFlag,
						0 AS  IsRenewalFlag,
						0 AS  IsMultipleSurgeryFlag,
						0 AS  RenewalCount,
						1 AS  IsActiveFlag,
						GETUTCDATE() AS CreateDate, @User AS CreateUser, GETUTCDATE() AS LastUpdate, @User AS LastUpdateUser, @ClientMembershipNumber

					--Get Client Membership Number
					EXEC [mtnGetClientMembershipNumber] @ClientGUID, @CenterID, @MembershipStartDate, @ClientMembershipNumber OUTPUT

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
						GETUTCDATE() AS CreateDate, @User AS CreateUser, GETUTCDATE() AS LastUpdate,
						@User AS LastUpdateUser,@IncomingRequestID
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
						, @ContractPrice AS [Price]
						, @DiscountAmount AS [Discount]
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

					exec [extBosleyProcessCreateBosleyPostEXTPayment] @CurrentTransactionIdBeingProcessed, @InvoiceNumber, @CenterID, @ClientGUID, @ClientMembershipGUID, @EmployeeGUID, @User, @IsSuccessfullyProcessed

					-- Add Notification
					DECLARE @NotificationTypeID int
					SELECT @NotificationTypeID = NotificationTypeID FROM lkpNotificationType Where NotificationTypeDescriptionShort = 'Client'

					INSERT INTO datNotification(NotificationDate, NotificationTypeID, ClientGUID, FeePayCycleID, FeeDate, CenterID, IsAcknowledgedFlag, [Description], CreateDate, CreateUser, LastUpdate, LastUpdateUser)
						VALUES(GETUTCDATE(), @NotificationTypeID, @ClientGUID, NULL, NULL, @CenterID, 0, 'Bosley sold a new EXT 9 client.', GETUTCDATE(), @User, GETUTCDATE(), @User)

					SET @IsSuccessfullyProcessed = 1
				END
				ELSE
					BEGIN
						Update datIncomingRequestLog
							SET ErrorMessage = 'Unable to determine Center'
								,LastUpdate = GETUTCDATE()
								,LastUpdateUser = @User
						FROM datIncomingRequestLog
						WHERE BosleyRequestID = @CurrentTransactionIdBeingProcessed

						SET @IsSuccessfullyProcessed = 0
					END
			END

	END TRY

	BEGIN CATCH
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
GO
