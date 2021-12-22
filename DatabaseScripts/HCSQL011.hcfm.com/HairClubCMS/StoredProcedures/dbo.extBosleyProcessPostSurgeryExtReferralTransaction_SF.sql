/* CreateDate: 12/11/2017 07:03:39.963 , ModifyDate: 11/25/2019 14:38:26.650 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				extBosleyProcessPostSurgeryExtReferralTransaction_SF

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		11/15/17

LAST REVISION DATE: 	11/15/17

--------------------------------------------------------------------------------------------------------
NOTES: Bosley patient that has just had surgery, Bosley will tell patient that HairClub will be able to
		provide 2 free EXT services.
	* 11/15/17 MVT - Created
	* 03/18/19 SAL - Updated to pass value into utilCloseClientMembership for ClientMembershipAddOnStatusID,
						even though the call is currently commented out. (TFS #12148)
	* 11/25/19 MVT - Modified join logic to cfgCenter from datIncomingRequestLog to use CenterNumber instead of CenterID (TFS #13502)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

DECLARE @IsSuccessfullyProcessed bit = 0
DECLARE @ClientIdentifier int
exec [extBosleyProcessPostSurgeryExtReferralTransaction_SF] 45353, @ClientIdentifier OUTPUT, @IsSuccessfullyProcessed OUTPUT

***********************************************************************/

CREATE PROCEDURE [dbo].[extBosleyProcessPostSurgeryExtReferralTransaction_SF]
	  @IncomingRequestID int,
	  @ClientIdentifier int OUTPUT,
	  @IsSuccessfullyProcessed bit OUTPUT
AS

SET XACT_ABORT ON
SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION

		DECLARE @User nvarchar(25) = 'Bosley-PostExtRef'
		DECLARE @MembershipDescriptionShort nvarchar(10) = 'POSTEXTBOS'

		DECLARE @ClientGUID uniqueidentifier = NULL
		DECLARE @CurrentExtClientMembershipGUID uniqueidentifier = NULL
		DECLARE @EXTClientMembershipStatusDescriptionShort nvarchar(10) = NULL

		--Check to see if Client Already Exists
		SELECT TOP(1) @ClientGUID = c.ClientGUID
				, @CurrentExtClientMembershipGUID = cm.ClientMembershipGUID
				, @EXTClientMembershipStatusDescriptionShort = st.ClientMembershipStatusDescriptionShort
		FROM datIncomingRequestLog irl
			INNER JOIN datClient c on irl.SiebelID = c.SiebelID OR irl.ConectID = c.ClientIdentifier
			LEFT JOIN datClientMembership cm ON cm.ClientMembershipGUID = c.CurrentExtremeTherapyClientMembershipGUID
			LEFT JOIN lkpClientMembershipStatus st ON st.ClientMembershipStatusID = cm.ClientMembershipStatusID
		WHERE irl.IncomingRequestID = @IncomingRequestID


		DECLARE @CenterID int = null
				,@CountryID int
				,@StateID int
				,@State nvarchar(2)
				,@FirstName nvarchar(50)
				,@LastName nvarchar(50)
				,@Address1 nvarchar(100)
				,@Address2 nvarchar(100)
				,@City nvarchar(50)
				,@ZipCode nvarchar(10)
				,@GenderID INT
				,@GenderDescriptionShort nvarchar(1)
				,@GenderDescription nvarchar(10)
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
				,@SalesUserName nvarchar(100)
				,@CenterSentByBosley nvarchar(50)
				,@Country nvarchar(15)
				,@BosleyProcedureID nvarchar(20)

		SELECT @CenterID = c.CenterID
			,@CountryID = st.CountryID
			,@StateID = st.StateID
			,@State = st.StateDescriptionShort
			,@FirstName = irl.FirstName
			,@LastName = irl.LastName
			,@Address1 = irl.Address1
			,@Address2 = irl.Address2
			,@City = irl.City
			,@ZipCode = irl.ZipCode
			,@GenderID = g.GenderID
			,@GenderDescriptionShort = g.GenderDescriptionShort
			,@GenderDescription = UPPER(g.GenderDescription)
			,@DoNotCall = CASE WHEN irl.HomePhoneDNC = 1 or irl.WorkPhoneDNC = 1 OR irl.CellPhoneDNC = 1 THEN 1 ELSE 0 END
			,@HomePhone = irl.HomePhone
			,@WorkPhone = irl.WorkPhone
			,@CellPhone = irl.CellPhone
			,@MembershipStartDate = ISNULL(irl.MembershipStartDate, GETUTCDATE())
			,@SiebelID = irl.SiebelID
			,@SalesUserName = irl.SalesUserName
			,@CenterSentByBosley = irl.HC_Center
			,@EmployeeGUID = e.EmployeeGUID
			,@Country = co.CountryDescriptionShort
			,@BosleyProcedureID = irl.BosleyProcedureID
		FROM datIncomingRequestLog irl
			LEFT JOIN cfgCenter c on irl.HC_Center = c.CenterNumber
			LEFT JOIN cfgConfigurationCenter cc on c.CenterID = cc.CenterID
		--	INNER JOIN lkpCenterBusinessType cbt on cc.CenterBusinessTypeID = cbt.CenterBusinessTypeID
			LEFT JOIN lkpCenterType ct on c.CenterTypeID = ct.CenterTypeID
					AND ct.CenterTypeDescriptionShort <> 'S'
			LEFT OUTER JOIN lkpState st on st.StateDescriptionShort = irl.[State]
			LEFT OUTER JOIN lkpCountry co on co.CountryID = st.CountryID
			LEFT OUTER JOIN lkpGender g on irl.[Gender] = g.GenderDescriptionShort
			LEFT OUTER JOIN datEmployee e ON irl.SalesUserName = e.UserLogin
		WHERE irl.IncomingRequestID = @IncomingRequestID


		--------------------------------------------------------------------
		-- Error Checking
		--------------------------------------------------------------------
		IF 	@CurrentExtClientMembershipGUID IS NOT NULL AND @EXTClientMembershipStatusDescriptionShort = 'A'
		BEGIN
			 RAISERROR (N'Client is already in an Active EXT Membership.', -- Message text.
               16, -- Severity.
               1 -- State.
			   );
		END

		IF @BosleyProcedureID IS NULL OR @BosleyProcedureID = ''
		BEGIN
			 RAISERROR (N'Bosley ProcedureID is required', -- Message text.
               16, -- Severity.
               1 -- State.
			   );
		END


		IF @CenterID IS NULL
		BEGIN
			 RAISERROR (N'Unable to find Center: %s', -- Message text.
               16, -- Severity.
               1, -- State.
               @CenterSentByBosley -- param1
			   );
		END

		IF NOT EXISTS (SELECT * FROM cfgCenterMembership cm
									INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
								WHERE cm.CenterID = @CenterID
									AND m.MembershipDescriptionShort = @MembershipDescriptionShort
									AND cm.IsActiveFlag = 1)
		BEGIN
			RAISERROR (N'Membership is not valid for Center: %s', -- Message text.
               16, -- Severity.
               1, -- State.
               @CenterSentByBosley -- param1
			   );
		END

		-- reject if phone number is not provided
		IF (@HomePhone IS NULL OR LEN(@HomePhone) <> 10)
			AND (@WorkPhone IS NULL OR LEN(@WorkPhone) <> 10)
			AND (@CellPhone IS NULL OR LEN(@CellPhone) <> 10)
		BEGIN
			 RAISERROR (N'Phone number is required.', -- Message text.
               16, -- Severity.
               1 -- State.
			   );
		END


		--Get PhoneTypes
		SELECT @HomePhoneTypeID = PhoneTypeID FROM lkpPhoneType Where PhoneTypeDescriptionShort = 'Home'
		SELECT @WorkPhoneTypeID = PhoneTypeID FROM lkpPhoneType Where PhoneTypeDescriptionShort = 'Work'
		SELECT @CellPhoneTypeID = PhoneTypeID FROM lkpPhoneType Where PhoneTypeDescriptionShort = 'Mobile'


		--------------------------------------
		---- Create OnContact Records
		--------------------------------------

		--DECLARE @ActivityID varchar(25)
		--DECLARE @HomeAreaCode nvarchar(3), @HomePhoneNumber nvarchar(7),
		--		@WorkAreaCode nvarchar(3), @WorkPhoneNumber nvarchar(7),
		--		@MobileAreaCode nvarchar(3), @MobilePhoneNumber nvarchar(7)

		--IF @HomePhone is not NULL AND LEN(@HomePhone) = 10
		--BEGIN
		--	SET @HomeAreaCode = SUBSTRING(@HomePhone,1,3)
		--	SET @HomePhoneNumber = SUBSTRING(@HomePhone,4,7)
		--END

		--IF @WorkPhone is not NULL AND LEN(@WorkPhone) = 10
		--BEGIN
		--	SET @WorkAreaCode = SUBSTRING(@WorkPhone,1,3)
		--	SET @WorkPhoneNumber = SUBSTRING(@WorkPhone,4,7)
		--END

		--IF @CellPhone is not NULL AND LEN(@CellPhone) = 10
		--BEGIN
		--	SET @MobileAreaCode = SUBSTRING(@CellPhone,1,3)
		--	SET @MobilePhoneNumber = SUBSTRING(@CellPhone,4,7)
		--END

		---- Create OnContact Lead
		--EXEC extOnContactCreateContact @ContactID OUTPUT, @CenterID, @FirstName, @LastName, @GenderDescription, NULL, @HomeAreaCode, @HomePhoneNumber,
		--						@WorkAreaCode, @WorkPhoneNumber, @MobileAreaCode, @MobilePhoneNumber, @Address1, @Address2, @City, @State, @ZipCode, @Country,
		--						'BOSPExtRef', @DoNotCall, NULL, NULL, 'CLIENT', @SiebelID

  --		-- Create Activity
		--EXEC extOnContactCreateActivity @ActivityID OUTPUT, 'BOSCLIENT', 'WEBSVCCLNT', 'INBOUND', 'Bosley Lead', @ContactID, @CenterID, 'BOSPExtRef'

		---- This update needs to happen after activity is created since
		---- there is a trigger on the activity table that does not allow a result code
		---- to be set when activity is inserted.
		--EXEC extOnContactUpdateActivityResult @ActivityID, 'WEBSVCCLNT', @CenterID


		---- Close Client Membership if Active
		-- MODIFIED TO RETURN ERROR IF ACTIVE
		--IF 	@CurrentExtClientMembershipGUID IS NOT NULL AND @EXTClientMembershipStatusDescriptionShort = 'A'
		--BEGIN
		--	EXEC [utlCloseClientMembership] @CurrentExtClientMembershipGUID, @EmployeeGUID, @CenterID, NULL, NULL, @User
		--END

		--Create the New Client if doesn't exist
		IF @ClientGUID IS NULL
		BEGIN
			SET @ClientGUID = NEWID()

			INSERT INTO datClient (ClientGUID, ClientNumber_Temp, CenterID, CountryID, ContactID, SiebelID, FirstName, LastName, Address1, City, StateID, PostalCode, ARBalance, GenderID, DateOfBirth, DoNotCallFlag,
									IsTaxExemptFlag, EMailAddress, IsHairSystemClientFlag, DoNotContactFlag, IsHairModelFlag,
									CreateDate, CreateUser, LastUpdate, LastUpdateUser, ImportCreateDate, ImportLastUpdate)
			VALUES(@ClientGUID, NULL, @CenterID, @CountryID, NULL, @SiebelID, @FirstName, @LastName, @Address1, @City, @StateID, @ZipCode, 0, @GenderID, NULL, @DoNotCall,
						0, NULL, 0, 0, 0,
						GETUTCDATE(), @User, GETUTCDATE(), @User, GETUTCDATE(), GETUTCDATE())

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
			--,@GenderID_Female int
			,@ContractPrice MONEY
			,@DiscountAmount decimal(21,6) = 0
			,@Payment_Male decimal(21,6) = 2195
			,@Payment_Female decimal(21,6) = 2495
			,@ClientMembershipGUID char(36)

		SET @ClientMembershipGUID = NEWID()

		SELECT @ActiveClientMembershipStatusID = ClientMembershipStatusID FROM lkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = 'A'
		--SELECT @GenderID_Female = GenderID FROM lkpGender WHERE GenderDescriptionShort = 'F'

		SELECT @NewMembershipID = MembershipID, @NewMembershipDurationMonths = ISNULL(DurationMonths,0), @ContractPrice = ContractPrice FROM cfgMembership WHERE MembershipDescriptionShort = @MembershipDescriptionShort
		--No Discount since the contract is for $0
		SET @DiscountAmount = 0

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


		-- Add Notification
		DECLARE @NotificationTypeID int
		SELECT @NotificationTypeID = NotificationTypeID FROM lkpNotificationType Where NotificationTypeDescriptionShort = 'Client'

		INSERT INTO datNotification(NotificationDate, NotificationTypeID, ClientGUID, FeePayCycleID, FeeDate, CenterID, IsAcknowledgedFlag, [Description], CreateDate, CreateUser, LastUpdate, LastUpdateUser)
			VALUES(GETUTCDATE(), @NotificationTypeID, @ClientGUID, NULL, NULL, @CenterID, 0, 'Bosley referred a Post EXT Client.', GETUTCDATE(), @User, GETUTCDATE(), @User)

		--UPDATE datIncomingRequestLog SET
		--		IsProcessedFlag = 1
		--		,LastUpdate = GETUTCDATE()
		--		,LastUpdateUser = @User
		--FROM datIncomingRequestLog
		--WHERE IncomingRequestID = @IncomingRequestID

		SELECT @ClientIdentifier = c.ClientIdentifier
		FROM datClient c
		WHERE c.ClientGUID = @ClientGUID

	COMMIT TRANSACTION

		SET @IsSuccessfullyProcessed = 1

END TRY
BEGIN CATCH
		ROLLBACK TRANSACTION

		SET @IsSuccessfullyProcessed = 0
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;
		DECLARE @ErrorProcedure NVARCHAR(200);

		SELECT @ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE(),
				@ErrorProcedure = ERROR_PROCEDURE();

		-- Write Error Message to the IncomingRequestLog Table
		Update datIncomingRequestLog
			SET ErrorMessage = @ErrorProcedure + ':' + @ErrorMessage
				,LastUpdate = GETUTCDATE()
				,LastUpdateUser = @User
		FROM datIncomingRequestLog
		WHERE IncomingRequestID = @IncomingRequestID

		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);

END CATCH
GO
