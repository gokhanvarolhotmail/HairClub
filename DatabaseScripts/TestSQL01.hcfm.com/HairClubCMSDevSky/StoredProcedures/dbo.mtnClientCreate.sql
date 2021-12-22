/* CreateDate: 04/08/2013 21:57:35.130 , ModifyDate: 03/05/2020 15:21:10.770 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnClientCreate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		3/26/13

LAST REVISION DATE: 	3/26/13

--------------------------------------------------------------------------------------------------------
NOTES: 	Adds a new Client to the database.
	* 03/26/13 MVT - Created
	* 04/12/13 MVT - Added a check for "Is Active" when adding client membership accum records.
	* 04/26/13 MVT - Modified based on Center Business Type changes.
	* 05/30/13 MVT - Modified so that "Membership" tender type is used for Membership Order
	* 05/07/14 SAL - Added EmergencyContactPhone field
	* 09/26/14 MVT - Added Auto Confirm fields
	* 12/02/16 SAL - Added IsConfirmCallPhone1, 2, and 3 fields
	* 04/26/17 PRM - Updated to reference new datClientPhone table
	* 09/11/17 MVT - Modify to Create Client in HW membership if Center Business Unit Brand is HW(TFS #9570)
	* 04/24/18 JGE - Default Han Wiemann membership to Retail.
	* 10/30/18 MVT - Modified to use membership specified in cfgConfigurationCenter Table NewClientMembershipID  (TFS #11548)
	* 03/05/20 MVT - Modified to use membership Duration specified on Membership Record  (TFS #14139)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:
select newid()
EXEC mtnClientCreate 201, NULL, 'F78AAD94-5F63-4257-A6AB-5C17A4B0DDC4', 'test', 'test2','test3','test4', 'Green Bay', 3, 1,2,'12312','1/1/2001', 0,0,null, '1231231234', null, null, null,1, null, null, 0,'user', 0,0,0,0,0,0,0,null

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnClientCreate]
	  @CenterId as int
	, @SalutationId as int
	, @ClientGuid as uniqueidentifier
	, @FirstName nvarchar(50)
	, @LastName nvarchar(50)
	, @Address1 nvarchar(50)
	, @Address2 nvarchar(50)
	, @City nvarchar(50)
	, @StateId as int
	, @CountryId as int
	, @GenderId as int
	, @PostalCode as nvarchar(10)
	, @BirthDate datetime
	, @DoNotCall bit
	, @DoNotContact bit
	, @Email nvarchar(100)
	, @PrimaryPhone nvarchar(15)
	, @SecondaryPhone nvarchar(15)
	, @AdditionalPhone nvarchar(15)
	, @EmergencyContactPhone nvarchar(15)
	, @PrimaryPhoneTypeId int
	, @SecondaryPhoneTypeId int
	, @AdditionalPhoneTypeId int
	, @RequireNoteReview bit
	, @User nvarchar(50)
	, @IsAutoConfirmTextPhone1 bit
	, @IsAutoConfirmTextPhone2 bit
	, @IsAutoConfirmTextPhone3 bit
	, @IsAutoConfirmEmail bit
	, @IsConfirmCallPhone1 bit
	, @IsConfirmCallPhone2 bit
	, @IsConfirmCallPhone3 bit
	, @KorvueID nvarchar(50)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @IsClientFound bit = 0
	DECLARE @ClientCenter int = 0

	DECLARE @EmployeeGuid uniqueidentifier
	DECLARE @MembershipBeginDate datetime
	DECLARE @CenterBusinessType nvarchar(10)
	DECLARE @ClientMembershipGUID uniqueidentifier
	DECLARE @NewMembershipID int
	DECLARE @NewMembershipBusinessSegmentDescriptionShort nvarchar(10)
	DECLARE @NewMembershipDurationMonths int
	DECLARE @ActiveClientMembershipStatusID int
	DECLARE @SalesOrderGUID uniqueidentifier
	DECLARE @SalesCodeID int
	DECLARE @ClientMembershipNumber nvarchar(50)
	DECLARE @TempInvoiceTable table
			(
				InvoiceNumber nvarchar(50)
			)
	DECLARE @InvoiceNumber nvarchar(50)

	--DECLARE @SurgeryCenterBusinessType nvarchar(10) = 'Surgery'
	--DECLARE @DefaultSurgeryMembership nvarchar(10) = 'SHOWSALE'
	DECLARE @DefaultBioMembership nvarchar(10) = 'RETAIL'
	DECLARE @InitialAssignmentSalesCode nvarchar(10) = 'INITASG'
	DECLARE @XtrandsPlusBusinessSegment nvarchar(10) = 'BIO'
	DECLARE @ExtremeBusinessSegment nvarchar(10) = 'EXT'
	DECLARE @XtrandsBusinessSegment nvarchar(10) = 'XTR'
	DECLARE @SurgerBusinessSegment nvarchar(10) = 'SUR'

	DECLARE @MOTenderTypeID int
	DECLARE @BusinessUnitBrand nvarchar(10)


BEGIN TRANSACTION

BEGIN TRY

	SELECT @MOTenderTypeID = TenderTypeID FROM lkpTenderType WHERE TenderTypeDescriptionShort = 'Membership'

	SET @ClientMembershipGUID = NEWID()
	SET @MembershipBeginDate = GETDATE()
	SELECT @ActiveClientMembershipStatusID = ClientMembershipStatusID FROM lkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = 'A'

	SELECT @CenterBusinessType = bt.CenterBusinessTypeDescriptionShort
			, @BusinessUnitBrand = bu.BusinessUnitBrandDescriptionShort
		FROM cfgCenter c
			INNER JOIN cfgConfigurationCenter config ON c.CenterId = config.CenterId
			INNER JOIN lkpCenterBusinessType bt ON bt.CenterBusinessTypeId = config.CenterBusinessTypeId
			INNER JOIN lkpBusinessUnitBrand bu ON bu.BusinessUnitBrandID = c.BusinessUnitBrandID
		WHERE c.CenterId = @CenterId


	SELECT
		@NewMembershipID = cc.NewClientMembershipID
		,@NewMembershipBusinessSegmentDescriptionShort = bs.BusinessSegmentDescriptionShort
		,@NewMembershipDurationMonths = ISNULL(m.DurationMonths,12)
	FROM cfgConfigurationCenter cc
		INNER JOIN cfgMembership m ON m.MembershipID = cc.NewClientMembershipID
		INNER JOIN lkpBusinessSegment bs ON bs.BusinessSegmentID = m.BusinessSegmentID
	WHERE cc.CenterID = @CenterId

	IF @NewMembershipID IS NULL
	BEGIN
		--SELECT @NewMembershipID = MembershipID FROM cfgMembership WHERE MembershipDescriptionShort = @DefaultBioMembership
		SELECT
			@NewMembershipID = m.MembershipID
			,@NewMembershipBusinessSegmentDescriptionShort = bs.BusinessSegmentDescriptionShort
		FROM cfgMembership m
			INNER JOIN lkpBusinessSegment bs ON bs.BusinessSegmentID = m.BusinessSegmentID
		WHERE m.MembershipDescriptionShort = @DefaultBioMembership
	END

	--INSERT Client record
	INSERT INTO datClient (
		ClientGUID,
		ContactID,
		ClientNumber_Temp,
		CenterID,
		SalutationID,
		FirstName,
		LastName,
		Address1,
		Address2,
		Address3,
		City,
		StateID,
		PostalCode,
		CountryID,
		ARBalance,
		DateOfBirth,
		GenderID,
		DoNotCallFlag, DoNotContactFlag, IsHairModelFlag, IsTaxExemptFlag,
		EMailAddress,
		TextMessageAddress,
		EmergencyContactPhone,
		CreateDate, CreateUser, LastUpdate, LastUpdateUser,
		IsAutoConfirmTextPhone1, IsAutoConfirmTextPhone2, IsAutoConfirmTextPhone3, IsAutoConfirmEmail,
		IsConfirmCallPhone1, IsConfirmCallPhone2, IsConfirmCallPhone3, KorvueID)
	SELECT
		@ClientGUID AS ClientGUID,
		NULL,
		NULL AS ClientNumber_Temp,
		@CenterId AS CenterID,
		@SalutationId,
		@FirstName AS FirstName,
		@LastName AS LastName,
		@Address1 AS Address1,
		@Address2 AS Address2,
		NULL AS Address3,
		@City AS City,
		@StateID,
		@PostalCode,
		@CountryID,
		0 AS ARBalance,
		@BirthDate AS DateOfBirth,
		@GenderId,
		@DoNotCall, @DoNotContact,
		0 AS IsHairModelFlag,
		0 AS IsTaxExemptFlag,
		@Email AS EMailAddress, NULL AS TextMessageAddress,
		@EmergencyContactPhone As EmergencyContactPhone,
		GETUTCDATE() AS CreateDate, @User AS CreateUser, GETUTCDATE() AS LastUpdate, @User AS LastUpdateUser,
		@IsAutoConfirmTextPhone1, @IsAutoConfirmTextPhone2,@IsAutoConfirmTextPhone3, @IsAutoConfirmEmail,
		@IsConfirmCallPhone1, @IsConfirmCallPhone2, @IsConfirmCallPhone3, @KorvueID

	DECLARE @PhoneCount int = 1
			,@Phone nvarchar(15)
			,@PhoneType nvarchar(15)

	IF @PrimaryPhone IS NOT NULL AND RTRIM(LTRIM(@PrimaryPhone)) <> ''
		BEGIN
		SET @Phone = @PrimaryPhone
		SET @PhoneType = @PrimaryPhoneTypeId
		INSERT INTO datClientPhone (ClientGUID, PhoneTypeID, PhoneNumber, CanConfirmAppointmentByCall, CanConfirmAppointmentByText, CanContactForPromotionsByCall, CanContactForPromotionsByText, ClientPhoneSortOrder, CreateDate, CreateUser, LastUpdate, LastUpdateUser) VALUES
			(@ClientGUID, @PhoneType, @Phone, NULL, NULL, NULL, NULL, @PhoneCount, GETUTCDATE(), 'sa-Bosley', GETUTCDATE(), 'sa-Bosley')
		SET @PhoneCount = @PhoneCount + 1
		END
	IF @SecondaryPhone IS NOT NULL AND RTRIM(LTRIM(@SecondaryPhone)) <> ''
		BEGIN
		SET @Phone = @SecondaryPhone
		SET @PhoneType = @SecondaryPhoneTypeId
		INSERT INTO datClientPhone (ClientGUID, PhoneTypeID, PhoneNumber, CanConfirmAppointmentByCall, CanConfirmAppointmentByText, CanContactForPromotionsByCall, CanContactForPromotionsByText, ClientPhoneSortOrder, CreateDate, CreateUser, LastUpdate, LastUpdateUser) VALUES
			(@ClientGUID, @PhoneType, @Phone, NULL, NULL, NULL, NULL, @PhoneCount, GETUTCDATE(), 'sa-Bosley', GETUTCDATE(), 'sa-Bosley')
		SET @PhoneCount = @PhoneCount + 1
		END
	IF @AdditionalPhone IS NOT NULL AND RTRIM(LTRIM(@AdditionalPhone)) <> ''
			BEGIN
			SET @Phone = @AdditionalPhone
			SET @PhoneType = @AdditionalPhoneTypeId
			INSERT INTO datClientPhone (ClientGUID, PhoneTypeID, PhoneNumber, CanConfirmAppointmentByCall, CanConfirmAppointmentByText, CanContactForPromotionsByCall, CanContactForPromotionsByText, ClientPhoneSortOrder, CreateDate, CreateUser, LastUpdate, LastUpdateUser) VALUES
				(@ClientGUID, @PhoneType, @Phone, NULL, NULL, NULL, NULL, @PhoneCount, GETUTCDATE(), 'sa-Bosley', GETUTCDATE(), 'sa-Bosley')
			SET @PhoneCount = @PhoneCount + 1
			END

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
		CurrentBioMatrixClientMembershipGUID = CASE WHEN @NewMembershipBusinessSegmentDescriptionShort = @XtrandsPlusBusinessSegment THEN @ClientMembershipGUID ELSE CurrentBioMatrixClientMembershipGUID END
		, [CurrentXtrandsClientMembershipGUID] = CASE WHEN @NewMembershipBusinessSegmentDescriptionShort = @XtrandsBusinessSegment THEN @ClientMembershipGUID ELSE CurrentXtrandsClientMembershipGUID END
		, [CurrentSurgeryClientMembershipGUID] = CASE WHEN @NewMembershipBusinessSegmentDescriptionShort = @SurgerBusinessSegment THEN @ClientMembershipGUID ELSE CurrentSurgeryClientMembershipGUID END
		, [CurrentExtremeTherapyClientMembershipGUID] = CASE WHEN @NewMembershipBusinessSegmentDescriptionShort = @ExtremeBusinessSegment THEN @ClientMembershipGUID ELSE CurrentExtremeTherapyClientMembershipGUID END
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
	SELECT @SalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = @InitialAssignmentSalesCode --New Membership
	SELECT @EmployeeGuid = EmployeeGuid FROM datEmployee WHERE [UserLogin] = @User

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
		CreateDate, CreateUser, LastUpdate, LastUpdateUser)
	SELECT
		@SalesOrderGUID AS SalesOrderGUID,
		NULL AS TenderTransactionNumber_Temp, NULL AS TicketNumber_Temp,
		cm.CenterID AS CenterID, cm.CenterID AS ClientHomeCenterID,
		2 AS SalesOrderTypeID, --Membership
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
		GETUTCDATE() AS CreateDate, @User AS CreateUser, GETUTCDATE() AS LastUpdate, @User AS LastUpdateUser
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
		, @SalesCodeID AS SalesCodeID
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
			,   @MOTenderTypeID  -- Membership Tender type
			,	0  -- Amount
			,	GETUTCDATE()
			,	@User
			,	GETUTCDATE()
			,	@User )


	-- Call the Accum Stored Proc
	EXEC [dbo].[mtnMembershipAccumAdjustment] 'SALES ORDER', @SalesOrderGUID



	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION

	 DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE();

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);

END CATCH

END
GO
