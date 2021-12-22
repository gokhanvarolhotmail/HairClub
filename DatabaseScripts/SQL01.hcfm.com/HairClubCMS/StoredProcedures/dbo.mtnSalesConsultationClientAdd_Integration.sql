/***********************************************************************

PROCEDURE:				mtnSalesConsultationClientAdd_Integration

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		4/22/13

LAST REVISION DATE: 	08/05/16

--------------------------------------------------------------------------------------------------------
NOTES: 	Adds a new employee to the database.
	* 04/22/13 MVT - Created.  Started out with a mtnClientAddNonSurgery Proc.
	* 05/30/13 MVT - Modified so that "Membership" tender type is used for Membership Order
	* 06/04/13 MVT - Removed the Appointment employee update.  Moved it to the demographic proc.
	* 11/26/13 MVT - Modified to use duration from the Membership table when creating a Client Membership.
	* 12/08/13 MVT - Modified to cancel current BIO or SUR membership if it's a ShowNoSale or ShowNoSaleSurOffered.
	* 01/23/14 MVT - Modified to account for cONEct Franchise centers.
	* 09/03/14 KPL - Modified to update all datNotesClient records for an appointment with the ClientGUID
	* 10/02/14 MVT - Added logic to set appointment status to Sales Consultation Complete.
	* 10/07/14 MVT - Added logic to move the Email Opt in/out settings from OnContact
	* 10/07/14 KPL - Modified to update any datClientSurvey records for an appointment with the ClientGUID
	* 10/11/14 MVT - Fixed logic with email opt in/out
	* 11/25/14 MVT - Updated so that demographic data is written to the Client Demographic table.  Included
					 Solution Offered, Price Quoted, Last Consultation, and Last Consultant.
	* 01/14/15 MVT - Updated for Xtrands Business Segment
	* 02/25/15 MVT - Modified the transfer process to clear out Client Number Temp when Client Transfers (TFS #4341)
	* 06/01/15 MVT - Modified to update existing appointments for Client (Bio, Ext, and Xtr only) to new membership (for BeBack Clients)
	* 10/26/15 MVT - Modifed to update datClient record with a Siebel ID from OnContact if specified
	* 02/26/16 MVT - Modified to close current Bio if set to SHOWNOSALE and to close current surgery if set to SNSSURGOFF
	* 04/26/16 SAL - Modified to include returning the Client Membership GUID
	* 05/03/16 SAL - Modified to take in language and set the datClient.LanugaugeID when creating the client
	* 06/09/16 MVT - Added "IsPotentialModel" parameter and updated Client Demographic Update/Insert to use it.
	* 08/05/16 MVT - TFS #7601: Added logic to set the expected conversion date on the client record.
	* 02/24/17 MVT - TFS #8605: Modified to use Business Segment of Solution Offered to set Business Segment on the
					 Demographic record (instead of using the NoSale membership that the client is put into)
	* 04/27/17 PRM - Updated to reference new datClientPhone table
	* 07/18/17 PRM - Modifying use of PromotionId to be CenterPromotionId and adding new NCCPromotionId
	* 10/28/17 MVT - Modified to include SalesforceLeadID
	* 04/12/18 JGE - Add support for Hans Weihman Surgery Consultations
	* 04/27/18 MVT - Updated following for HW:
						* Modified to search for clients within Business Unit Brand
						* Modified to check HW Solution Offered
	* 09/10/19 MVT - Modified to accept Consultation Note and Lead Create Date as parameters.  Create Consultation Note associated
					with Appointment if has value. Modified to write Lead Create Date to datClient record.
	* 10/02/19 SAL - Updated to removed commented out code that is referencing OnContact and synonyms
						being deleted (TFS #13144)
	* 10/14/19 MVT - Updated to accept Bosley Salesforce Account ID as a parameter and populate it on the client record.
	* 15/05/20 AAM - Task #14465: If solution selected is ‘Surgery-HW’, client should be created in ‘Show No Sale Surgery Offered HW’ Membership
	* 02/26/2021 AP  #14809 Add clientOriginalCenterId form SalesForce in datclient table
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

[mtnSalesConsultationClientAdd_Integration] '001', 201, 'Mr.', 'John', 'William', 'Smith', '100 Easy St', NULL, 'Madison', 'WI', '54321', '1/1/1970', 'M', 'email@somewhere.com', '123-456-7890', 10, 'Surgery', 1000, 5.00, 50000.00, '9A4E124E-D01B-4382-A0D9-C72F1ECE9C87', 1, 'Spanish'

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnSalesConsultationClientAdd_Integration]
	  @ContactID nvarchar(50)
	, @SalesforceLeadID nvarchar(18)
	, @CenterID as int
	, @Salutation nvarchar(10)
	, @FirstName nvarchar(50)
	, @MiddleName nvarchar(20)
	, @LastName nvarchar(50)
	, @Address1 nvarchar(50)
	, @Address2 nvarchar(50)
	, @City nvarchar(50)
	, @State nvarchar(2)
	, @Zip nvarchar(10)
	, @BirthDate datetime
	, @Gender nchar(1)
	, @Email nvarchar(100)
	, @PrimaryPhone nvarchar(15)
	, @MembershipId int
	, @SolutionOffered nvarchar(50)
	, @NumberOfGrafts int
	, @PricePerGraft money
	, @ContractPrice money
	, @Discount money = 0
	, @AppointmentGuid uniqueidentifier
	, @IsSale bit
	, @User nvarchar(50)
	, @ConsultantGuid uniqueidentifier
	, @NCCPromotionId int
	, @CenterPromotionId int
	, @EthnicityCode int
	, @OccupationCode int
	, @MaritalStatusCode int
	, @LudwigCode int
	, @NorwoodCode int
	, @DISCStyle varchar(1)
	, @Language nvarchar(20)
	, @IsPotentialModel bit
	, @IsEmailOptIn bit
	, @SiebelID nvarchar(50)
	, @BosleySalesforceAccountID nvarchar(50)
	, @Note nvarchar(4000)
	, @LeadCreateDate datetime
	, @ClientOriginalCenterID int  = 100
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @IsClientFound bit = 0
	DECLARE @ClientCenter int
	DECLARE @CenterHasFullAccess bit = 0
	DECLARE @CurrentSurgeryMembership uniqueidentifier
	DECLARE @CurrentBioMembership uniqueidentifier
	DECLARE @CurrentExtMembership uniqueidentifier
	DECLARE @CurrentXtrMembership uniqueidentifier
	DECLARE @CurrentMdpMembership uniqueidentifier

	DECLARE @BusinessUnitBrandID int
	DECLARE @ExpectedConversionDays int
	DECLARE @BusinessSegment nvarchar(10) = 'BIO'
	DECLARE @BusinessSegmentID int
	DECLARE @SolutionOfferedBusinessSegmentID int
	DECLARE @ClientGUID uniqueidentifier
	DECLARE @ClientMembershipGUID uniqueidentifier
	DECLARE @NewMembershipID int
	DECLARE @MembershipDurationMonths int = 12
	DECLARE @ActiveClientMembershipStatusID int
	DECLARE @CancelClientMembershipStatusID int
	DECLARE @SalesOrderGUID uniqueidentifier
	DECLARE @SalesCodeID int
	DECLARE @ClientMembershipNumber nvarchar(50)
	DECLARE @MembershipBeginDate datetime
	DECLARE @TempInvoiceTable table
			(
				InvoiceNumber nvarchar(50)
			)
	DECLARE @InvoiceNumber nvarchar(50)
	DECLARE @StrippedPrimaryPhone nvarchar(15)
	DECLARE @CenterBusinessType nvarchar(10)
	DECLARE @MembershipOrderReasonID int
	DECLARE @Today Date

	DECLARE @SurgeryCenterBusinessType nvarchar(10) = 'Surgery'
	DECLARE @ConectCorpCenterBusinessType nvarchar(10) = 'cONEctCorp'
	DECLARE @ConectFranCenterBusinessType nvarchar(10) = 'cONEctFran'
	DECLARE @ConectJVCenterBusinessType nvarchar(10) = 'cONEctJV'
	DECLARE @CMS25CorpCenterBusinessType nvarchar(10) = 'CMS25Corp'
	DECLARE @HansWeihmanCenterBusinessType nvarchar(10) = 'HW'
	DECLARE @ShowNoSaleSurgeryOfferedMembership nvarchar(10) = 'SNSSURGOFF'
	DECLARE @ShowNoSaleMembership nvarchar(10) = 'SHOWNOSALE'
	DECLARE @ShowNoSaleSurgeryHWOfferedMembership nvarchar(10) = 'SNSSURGHW'

	DECLARE @SolutionOfferedSurgery nvarchar(20) = 'Surgery'
	DECLARE @SolutionOfferedHWSurgery nvarchar(20) = 'Surgery-HW'
	DECLARE @SolutionOfferedXtrandsPlus nvarchar(20) = 'Xtrands+'
	DECLARE @SolutionOfferedExtremeTherapy nvarchar(20) = 'Extreme Therapy'
	DECLARE @SolutionOfferedXtrands nvarchar(20) = 'Xtrands'
	DECLARE @SolutionOfferedMDP nvarchar(20) = 'MDP'

	DECLARE @SolutionOfferedXtrandsPlus_HW nvarchar(20) = 'Hair'
	DECLARE @SolutionOfferedExtremeTherapy_HW nvarchar(20) = 'Restorative'

	DECLARE @SurgeryBusinessSegment nvarchar(10) = 'SUR'
	DECLARE @SCCompleteAppointmentStatus nvarchar(10) = 'SCComplete'

	DECLARE @ConsultationNoteType nvarchar(10) = 'Consult'
	DECLARE @ConsultationNoteTypeID int

	SELECT @ConsultationNoteTypeID = NoteTypeID FROM lkpNoteType WHERE NoteTypeDescriptionShort = @ConsultationNoteType

	DECLARE @EthnicityID int
	DECLARE @OccupationID int
	DECLARE @MaritalStatusID int
	DECLARE @LudwigScaleID int
	DECLARE @NorwoodScaleID int
	DECLARE @DISCStyleID int

	SELECT @EthnicityID = EthnicityID FROM lkpEthnicity WHERE BOSEthnicityCode = @EthnicityCode
	SELECT @OccupationID = OccupationID FROM lkpOccupation WHERE BOSOccupationCode = @OccupationCode
	SELECT @MaritalStatusID = MaritalStatusID FROM lkpMaritalStatus WHERE BOSMaritalStatusCode = @MaritalStatusCode
	SELECT @LudwigScaleID = LudwigScaleID FROM lkpLudwigScale WHERE BOSLudwigScaleCode = @LudwigCode
	SELECT @NorwoodScaleID = NorwoodScaleID FROM lkpNorwoodScale WHERE BOSNorwoodScaleCode = @NorwoodCode
	SELECT @DISCStyleID = DISCStyleID FROM lkpDISCStyle WHERE DISCStyleDescriptionShort = @DISCStyle

	DECLARE @MembershipTenderTypeID int
	DECLARE @IsConectCenter bit = 0
	DECLARE @IsGraftCountUsed bit = 1
	SELECT @Today = CONVERT (DATE, GETDATE())

	SELECT @MembershipTenderTypeID = TenderTypeID
		FROM lkpTenderType
		WHERE TenderTypeDescriptionShort = 'Membership'


	-- Strip '-', ')', '(', ' ' characters from the phone number.
	SELECT @StrippedPrimaryPhone = REPLACE(REPLACE(REPLACE(REPLACE(@PrimaryPhone, '-', ''), ')', ''), '(', ''), ' ', '')

	SELECT	@CenterBusinessType = bt.CenterBusinessTypeDescriptionShort,
			@BusinessUnitBrandID = c.BusinessUnitBrandID,
			@IsConectCenter =  CASE WHEN bt.CenterBusinessTypeDescriptionShort = @ConectCorpCenterBusinessType
											OR bt.CenterBusinessTypeDescriptionShort = @ConectFranCenterBusinessType
											OR bt.CenterBusinessTypeDescriptionShort = @ConectJVCenterBusinessType
											OR bt.CenterBusinessTypeDescriptionShort = @HansWeihmanCenterBusinessType
								THEN 1 ELSE 0 END
					FROM cfgCenter c
						INNER JOIN cfgConfigurationCenter config ON c.CenterId = config.CenterId
						INNER JOIN lkpCenterBusinessType bt ON bt.CenterBusinessTypeId = config.CenterBusinessTypeId
					WHERE c.CenterId = @CenterId

	 Set @IsGraftCountUsed = 0
	--Set @IsGraftCountUsed = Case When @CenterBusinessType <> @HansWeihmanCenterBusinessType Then 1 Else 0 End

	-- ONLY use client if client is in Current Center,
	-- or client's center is live on conect and current center is live on conect
	-- Otherwise a new client should be created.
	-- (4/27/18) Search within same Business Unit Brand
	SELECT  CASE WHEN cntr.CenterId = @CenterId OR
					 ((bt.CenterBusinessTypeDescriptionShort = @ConectCorpCenterBusinessType
								OR bt.CenterBusinessTypeDescriptionShort = @ConectFranCenterBusinessType
								OR bt.CenterBusinessTypeDescriptionShort = @ConectJVCenterBusinessType
								OR bt.CenterBusinessTypeDescriptionShort = @HansWeihmanCenterBusinessType)
							AND @IsConectCenter = 1)
					 THEN 1 ELSE 0 END AS IsClientFound,
			cntr.CenterId AS CenterID,
			c.ClientGUID AS ClientGUID,
			c.[CurrentBioMatrixClientMembershipGUID] as CurrentBioMatrixClientMembershipGUID,
			c.[CurrentSurgeryClientMembershipGUID] as CurrentSurgeryClientMembershipGUID,
			c.[CurrentExtremeTherapyClientMembershipGUID] as CurrentExtremeTherapyClientMembershipGUID,
			c.[CurrentXtrandsClientMembershipGUID] as CurrentXtrandsClientMembershipGUID,
			c.[CurrentMDPClientMembershipGUID] as CurrentMDPClientMembershipGUID,
			c.CreateDate AS CreateDate
		INTO #foundClients
		FROM [datClient] c
			INNER JOIN cfgCenter cntr ON c.CenterId = cntr.CenterId
			INNER JOIN cfgConfigurationCenter cntrConfig ON cntr.CenterId = cntrConfig.CenterId
			INNER JOIN lkpCenterBusinessType bt ON cntrConfig.CenterBusinessTypeId = bt.CenterBusinessTypeId
		WHERE cntr.BusinessUnitBrandID = @BusinessUnitBrandID
			AND ((c.ContactID IS NOT NULL AND c.[ContactID] = @ContactID)
				OR (c.SalesforceContactID IS NOT NULL AND c.[SalesforceContactID] = @SalesforceLeadID))


	-- Check if the Client exists in the current center first
	IF EXISTS (SELECT * FROM #foundClients WHERE IsClientFound = 1 AND CenterID = @CenterID)
		SELECT TOP(1)
			@IsClientFound = IsClientFound
			,@ClientCenter = CenterID
			,@ClientGUID = ClientGUID
			,@CurrentSurgeryMembership = CurrentSurgeryClientMembershipGUID
			,@CurrentBioMembership = CurrentBioMatrixClientMembershipGUID
			,@CurrentExtMembership = CurrentExtremeTherapyClientMembershipGUID
			,@CurrentXtrMembership = CurrentXtrandsClientMembershipGUID
			,@CurrentMdpMembership = CurrentMDPClientMembershipGUID
		FROM #foundClients
		WHERE IsClientFound = 1 AND CenterID = @CenterID
		ORDER BY CreateDate desc
	ELSE IF EXISTS (SELECT * FROM #foundClients WHERE IsClientFound = 1)
		SELECT TOP(1)
			@IsClientFound = IsClientFound
			,@ClientCenter = CenterID
			,@ClientGUID = ClientGUID
			,@CurrentSurgeryMembership = CurrentSurgeryClientMembershipGUID
			,@CurrentBioMembership = CurrentBioMatrixClientMembershipGUID
			,@CurrentExtMembership = CurrentExtremeTherapyClientMembershipGUID
			,@CurrentXtrMembership = CurrentXtrandsClientMembershipGUID
			,@CurrentMdpMembership = CurrentMDPClientMembershipGUID
		FROM #foundClients
		WHERE IsClientFound = 1
		ORDER BY CreateDate desc


	-- Reset variable for Client if not found.
	IF @IsClientFound = 0
	BEGIN
		SET @ClientCenter = NULL
		SET @ClientGUID = NULL
		SET @CurrentSurgeryMembership = NULL
		SET @CurrentBioMembership = NULL
		SET @CurrentExtMembership = NULL
		SET @CurrentXtrMembership = NULL
		SET @CurrentMdpMembership = NULL
	END


	-- If client is found, but is assigned to a wrong center, perform
	-- a client transfer.
	IF @IsClientFound = 1 AND @ClientCenter <> @CenterID
	BEGIN

		-------------------------------------------
		--  Create MO to Transfer client to correct center.
		--------------------------------------------

	  	SET @SalesOrderGUID = NEWID()
		SELECT @SalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'CTRXFER' --Center Transfer

		--create an invoice #
		INSERT INTO @TempInvoiceTable
			EXEC ('mtnGetInvoiceNumber ' + @CenterID)

		SELECT TOP 1 @InvoiceNumber = InvoiceNumber
		FROM @TempInvoiceTable

		DELETE FROM @TempInvoiceTable

		-- Determine membership Transfer reason ID for 'AUTO'
		SELECT @MembershipOrderReasonID = r.MembershipOrderReasonID
			FROM lkpMembershipOrderReason r
				INNER JOIN lkpMembershipOrderReasonType rt ON r.MembershipOrderReasonTypeID = rt.MembershipOrderReasonTypeID
			WHERE r.MembershipOrderReasonDescriptionShort = 'AUTO'
				AND rt.MembershipOrderReasonTypeDescriptionShort = 'CTRTRXFR'

		--INSERT Sales Order record
		INSERT INTO datSalesOrder (SalesOrderGUID, TenderTransactionNumber_Temp, TicketNumber_Temp, CenterID, ClientHomeCenterID,
			SalesOrderTypeID, ClientGUID, ClientMembershipGUID, AppointmentGUID, HairSystemOrderGUID, OrderDate, InvoiceNumber,
			IsTaxExemptFlag, IsVoidedFlag, IsClosedFlag, EmployeeGUID, FulfillmentNumber, IsWrittenOffFlag,
			IsRefundedFlag, RefundedSalesOrderGUID, IsSurgeryReversalFlag, IsGuaranteeFlag,
			CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT
			@SalesOrderGUID AS SalesOrderGUID,
			NULL AS TenderTransactionNumber_Temp, NULL AS TicketNumber_Temp,
			@CenterID AS CenterID,
			@ClientCenter AS ClientHomeCenterID,
			2 AS SalesOrderTypeID, --Membership
			@ClientGUID AS ClientGUID,
			CASE WHEN c.CurrentBioMatrixClientMembershipGUID IS NOT NULL THEN c.CurrentBioMatrixClientMembershipGUID
				WHEN c.CurrentExtremeTherapyClientMembershipGUID IS NOT NULL THEN c.CurrentExtremeTherapyClientMembershipGUID
				WHEN c.CurrentSurgeryClientMembershipGUID IS NOT NULL THEN c.CurrentSurgeryClientMembershipGUID
				WHEN c.CurrentXtrandsClientMembershipGUID IS NOT NULL THEN c.CurrentXtrandsClientMembershipGUID
				WHEN c.CUrrentMDPClientMembershipGUID IS NOT NULL THEN c.CurrentMDPClientMembershipGUID
				ELSE NULL END AS ClientMembershipGUID,
			@AppointmentGuid AS AppointmentGUID,
			NULL AS FactoryOrderGUID,
			GETUTCDATE() AS OrderDate,
			@InvoiceNumber AS InvoiceNumber,
			0 AS IsTaxExemptFlag, 0 AS IsVoidedFlag, 1 AS IsClosedFlag,
			@ConsultantGuid AS EmployeeGUID, NULL AS FulfillmentNumber,
			0 AS IsWrittenOffFlag, 0 AS IsRefundedFlag, NULL AS RefundedSalesOrderGUID,
			0, -- IsSurgeryReversalFlag
			0, -- IsGuaranteeFlag
			GETUTCDATE() AS CreateDate, @User AS CreateUser, GETUTCDATE() AS LastUpdate, @User AS LastUpdateUser
		FROM datClient c
		WHERE c.ClientGUID = @ClientGUID


		--INSERT Sales Order Detail record
		INSERT INTO datSalesOrderDetail ([SalesOrderDetailGUID],[TransactionNumber_Temp],[SalesOrderGUID],[SalesCodeID],
			[Quantity],[Price],[Discount],[Tax1],[Tax2],[TaxRate1],[TaxRate2],
			[IsRefundedFlag],[RefundedSalesOrderDetailGUID],[RefundedTotalQuantity],[RefundedTotalPrice],
			[Employee1GUID],[Employee2GUID],[Employee3GUID],[Employee4GUID], NewCenterID,
			[BenefitTrackingEnabledFlag],
			[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser], [NCCMembershipPromotionID], [MembershipPromotionID], [MembershipOrderReasonID])
		SELECT
			NEWID() AS SalesOrderDetailGUID
			, NULL AS TransactionNumber_Temp
			, @SalesOrderGUID AS SalesOrderGUID
			, @SalesCodeID AS SalesCodeID
			, 1 AS [Quantity] -- Set Quantity to 1
			, 0.00 AS [Price]
			, 0.00 AS [Discount]
			, 0 AS [Tax1], 0 AS [Tax2], 0 AS [TaxRate1], 0 AS [TaxRate2]
			, 0 AS [IsRefundedFlag], NULL AS [RefundedSalesOrderDetailGUID], 0 AS [RefundedTotalQuantity], 0 AS [RefundedTotalPrice]
			, @ConsultantGuid AS [Employee1GUID], NULL AS [Employee2GUID], NULL AS [Employee3GUID], NULL AS [Employee4GUID]
			, @CenterID AS NewCenterID, 1
			, GETUTCDATE() AS CreateDate, @User AS CreateUser, GETUTCDATE() AS LastUpdate, @User AS LastUpdateUser
			, CASE WHEN @NCCPromotionId = 0 THEN NULL ELSE @NCCPromotionId END
			, CASE WHEN @CenterPromotionId = 0 THEN NULL ELSE @CenterPromotionId END
			, @MembershipOrderReasonID


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
			,   @MembershipTenderTypeID  -- Membership Tender type
			,	0  -- Amount
			,	GETUTCDATE()
			,	@User
			,	GETUTCDATE()
			,	@User )


		-- Update Client Center and clear out Client Number Temp
		UPDATE datClient SET
			CenterID = @CenterID
			, ClientNumber_Temp = NULL
			, LastUpdateUser = @User
			, LastUpdate = GETUTCDATE()
		WHERE ClientGUID = @ClientGUID

		-- Call the Accum Stored Proc
		EXEC [dbo].[mtnMembershipAccumAdjustment] 'SALES ORDER', @SalesOrderGUID

	END

	-- Set Clinet Guid if client does not exist
	IF @IsClientFound = 0
		SET @ClientGUID = NEWID()

	SET @ClientMembershipGUID = NEWID()
	SELECT @ActiveClientMembershipStatusID = ClientMembershipStatusID FROM lkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = 'A'
	SELECT @CancelClientMembershipStatusID = ClientMembershipStatusID FROM lkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = 'C'
	SELECT @MembershipBeginDate = GETDATE()


	-- If Sale put the client into membership that was sold.  Otherwise put them
	-- in a Show No Sale Surgery Offered membership if Surgery was offered or Show No Sale if BIO or EXT was offered.
	IF @IsSale = 1
	BEGIN
		SELECT @NewMembershipID = mem.MembershipID,
			@MembershipDurationMonths = ISNULL(mem.DurationMonths, 12),
			@ExpectedConversionDays = mem.ExpectedConversionDays,
			@BusinessSegment = bs.BusinessSegmentDescriptionShort,
			@BusinessSegmentID = bs.BusinessSegmentID,
			@SolutionOfferedBusinessSegmentID = bs.BusinessSegmentID
		FROM cfgMembership  mem
				INNER JOIN lkpBusinessSegment bs ON bs.BusinessSegmentID = mem.BusinessSegmentID
		WHERE mem.MembershipId = @MembershipId

		--SELECT @BusinessSegment = bs.BusinessSegmentDescriptionShort,
		--		@BusinessSegmentID = bs.BusinessSegmentID
		--FROM cfgMembership mem
		--		INNER JOIN lkpBusinessSegment bs ON bs.BusinessSegmentID = mem.BusinessSegmentID
		--WHERE mem.MembershipId = @MembershipId
	END
	ELSE
	BEGIN
		IF @SolutionOffered = @SolutionOfferedSurgery
			SELECT @NewMembershipID = MembershipID,
				  @MembershipDurationMonths = ISNULL(DurationMonths, 12)
			FROM cfgMembership WHERE MembershipDescriptionShort = @ShowNoSaleSurgeryOfferedMembership
		ELSE
			IF @SolutionOffered = @SolutionOfferedHWSurgery
				SELECT @NewMembershipID = MembershipID,
					  @MembershipDurationMonths = ISNULL(DurationMonths, 12)
				FROM cfgMembership WHERE MembershipDescriptionShort = @ShowNoSaleSurgeryHWOfferedMembership
			ELSE
				SELECT @NewMembershipID = MembershipID,
					   @MembershipDurationMonths = ISNULL(DurationMonths, 12)
				FROM cfgMembership WHERE MembershipDescriptionShort = @ShowNoSaleMembership

		SELECT @BusinessSegment = bs.BusinessSegmentDescriptionShort,
				@BusinessSegmentID = bs.BusinessSegmentID
		FROM cfgMembership mem
				INNER JOIN lkpBusinessSegment bs ON bs.BusinessSegmentID = mem.BusinessSegmentID
		WHERE mem.MembershipId = @NewMembershipID

			-- Set Solution Offered Business Segment
		SELECT @SolutionOfferedBusinessSegmentID = bs.BusinessSegmentID
			FROM lkpBusinessSegment bs
			WHERE bs.BusinessSegmentDescriptionShort =
							CASE WHEN @SolutionOffered = @SolutionOfferedSurgery THEN 'SUR'
							     WHEN @SolutionOffered = @SolutionOfferedHWSurgery THEN 'SUR'
								 WHEN @SolutionOffered = @SolutionOfferedXtrandsPlus OR @SolutionOffered = @SolutionOfferedXtrandsPlus_HW THEN 'BIO'
								 WHEN @SolutionOffered = @SolutionOfferedXtrands THEN 'XTR'
								 WHEN @SolutionOffered = @SolutionOfferedExtremeTherapy OR @SolutionOffered = @SolutionOfferedXtrandsPlus_HW THEN 'EXT'
								 WHEN @SolutionOffered = @SolutionOfferedMDP THEN 'MDP'
							ELSE NULL END
	END





	-- Close Current Membership if show no sale or show no sale surgery offered
	IF @IsClientFound = 1
	BEGIN
		-- Update demographic data and email info
		UPDATE datClient SET
			EMailAddress = @Email,
			IsAutoConfirmEmail = (CASE WHEN @Email IS NULL OR @Email = '' THEN NULL ELSE @IsEmailOptIn END),
			SiebelID = (CASE WHEN @SiebelID IS NULL OR @SiebelID = '' THEN NULL ELSE @SiebelID END),
			BosleySalesforceAccountID = (CASE WHEN @BosleySalesforceAccountID IS NULL OR @BosleySalesforceAccountID = '' THEN NULL ELSE @BosleySalesforceAccountID END),
			SalesforceContactID = @SalesforceLeadID,
			LeadCreateDate = @LeadCreateDate,
			LastUpdate = GETUTCDATE(),
			LastUpdateUser = @User
		WHERE ClientGUID = @ClientGUID

		IF EXISTS (SELECT * FROM datClientDemographic WHERE ClientGUID = @ClientGUID)
		BEGIN
			UPDATE dem SET
				EthnicityID = @EthnicityID,
				OccupationID = @OccupationID,
				MaritalStatusID = @MaritalStatusID,
				LudwigScaleID = @LudwigScaleID,
				NorwoodScaleID = @NorwoodScaleID,
				DISCStyleID = @DISCStyleID,
				[SolutionOfferedID] = @SolutionOfferedBusinessSegmentID,
				[PriceQuoted] = (CASE WHEN @BusinessSegment = 'SUR' AND @IsGraftCountUsed = 1 THEN ISNULL(@PricePerGraft,0) * ISNULL(@NumberOfGrafts,0)
									ELSE ISNULL(@ContractPrice,0) END) - ISNULL(@Discount,0),
				[LastConsultationDate] = appt.AppointmentDate,
				[LastConsultantGUID] = @ConsultantGuid,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = @User,
				IsPotentialModel = @IsPotentialModel
			FROM datClientDemographic dem
				INNER JOIN datAppointment appt ON appt.AppointmentGUID = @AppointmentGuid
			WHERE dem.ClientGUID = @ClientGUID
		END
		ELSE
		BEGIN
			INSERT INTO [dbo].[datClientDemographic]
						([ClientGUID]
						,[ClientIdentifier]
						,[EthnicityID]
						,[OccupationID]
						,[MaritalStatusID]
						,[LudwigScaleID]
						,[NorwoodScaleID]
						,[DISCStyleID]
						,[SolutionOfferedID]
						,[PriceQuoted]
						,[LastConsultationDate]
						,[LastConsultantGUID]
						,[CreateDate]
						,[CreateUser]
						,[LastUpdate]
						,[LastUpdateUser]
						,[IsPotentialModel])
				SELECT
						c.[ClientGUID]
						,c.[ClientIdentifier]
						,@EthnicityID
						,@OccupationID
						,@MaritalStatusID
						,@LudwigScaleID
						,@NorwoodScaleID
						,@DISCStyleID
						,@SolutionOfferedBusinessSegmentID
						,(CASE WHEN @BusinessSegment = 'SUR' AND @IsGraftCountUsed = 1 THEN ISNULL(@PricePerGraft,0) * ISNULL(@NumberOfGrafts,0)
									ELSE ISNULL(@ContractPrice,0) END) - ISNULL(@Discount,0)
						,appt.AppointmentDate
						,@ConsultantGuid
						,GETUTCDATE()
						,@User
						,GETUTCDATE()
						,@User
						,@IsPotentialModel
					FROM [dbo].[datClient] c
						INNER JOIN datAppointment appt ON appt.AppointmentGUID = @AppointmentGuid
					WHERE c.ClientGUID = @ClientGUID
		END

		IF --(@BusinessSegment = 'BIO' OR @BusinessSegment = 'EXT' OR  @BusinessSegment = 'XTR') AND
				@CurrentSurgeryMembership IS NOT NULL AND
				EXISTS (SELECT * FROM datClientMembership cm
							INNER JOIN cfgMembership m ON m.MembershipID = cm.MembershipID
						WHERE cm.ClientMembershipGUID = @CurrentSurgeryMembership
							AND m.MembershipDescriptionShort = @ShowNoSaleSurgeryOfferedMembership or m.MembershipDescriptionShort = @ShowNoSaleSurgeryHWOfferedMembership)
		BEGIN

			SET @SalesOrderGUID = NEWID()
			SELECT @SalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'CLOSE' --New Membership

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
				@CenterId AS CenterID, @CenterId AS ClientHomeCenterID,
				2 AS SalesOrderTypeID, --Membership
				cm.ClientGUID AS ClientGUID,
				cm.ClientMembershipGUID,
				@AppointmentGuid AS AppointmentGUID,
				NULL AS FactoryOrderGUID,
				GETUTCDATE() AS OrderDate,
				@InvoiceNumber AS InvoiceNumber,
				0 AS IsTaxExemptFlag, 0 AS IsVoidedFlag, 1 AS IsClosedFlag,
				@ConsultantGuid AS EmployeeGUID, NULL AS FulfillmentNumber,
				0 AS IsWrittenOffFlag, 0 AS IsRefundedFlag, NULL AS RefundedSalesOrderGUID,
				0, -- IsSurgeryReversalFlag
				0, -- IsGuaranteeFlag
				GETUTCDATE() AS CreateDate, @User AS CreateUser, GETUTCDATE() AS LastUpdate, @User AS LastUpdateUser
			FROM datClientMembership cm
				INNER JOIN cfgCenter c ON cm.CenterID = c.CenterID
			WHERE cm.ClientMembershipGUID = @CurrentSurgeryMembership

			--INSERT Sales Order Detail record
			INSERT INTO datSalesOrderDetail ([SalesOrderDetailGUID],[TransactionNumber_Temp],[SalesOrderGUID],[SalesCodeID],
				[Quantity],[Price],[Discount],[Tax1],[Tax2],[TaxRate1],[TaxRate2],
				[IsRefundedFlag],[RefundedSalesOrderDetailGUID],[RefundedTotalQuantity],[RefundedTotalPrice],
				[Employee1GUID],[Employee2GUID],[Employee3GUID],[Employee4GUID], [PreviousClientMembershipGUID],
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
				, @ConsultantGuid AS [Employee1GUID], NULL AS [Employee2GUID], NULL AS [Employee3GUID], NULL AS [Employee4GUID]
				, NULL AS PreviousClientMembershipGUID
				, GETUTCDATE() AS CreateDate, @User AS CreateUser, GETUTCDATE() AS LastUpdate, @User AS LastUpdateUser
				, NULL
			FROM datClientMembership cm
				INNER JOIN cfgCenter c ON cm.CenterID = c.CenterID
			WHERE cm.ClientMembershipGUID = @CurrentSurgeryMembership

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
					,   @MembershipTenderTypeID  -- Membership Tender type
					,	0  -- Amount
					,	GETUTCDATE()
					,	@User
					,	GETUTCDATE()
					,	@User )

			-- Call the Accum Stored Proc
			EXEC [dbo].[mtnMembershipAccumAdjustment] 'SALES ORDER', @SalesOrderGUID

			-- Update membership to 'Cancel' status
			UPDATE datClientMembership SET
				ClientMembershipStatusId = @CancelClientMembershipStatusID,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = @User
			WHERE ClientMembershipGUID = @CurrentSurgeryMembership

			UPDATE datClient SET
				[CurrentSurgeryClientMembershipGUID] = NULL,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = @User
			WHERE ClientGUID = @ClientGUID

		END

		IF --(@BusinessSegment = 'EXT' OR @BusinessSegment = 'SUR' OR @BusinessSegment = 'XTR') AND
				@CurrentBioMembership IS NOT NULL AND
				EXISTS (SELECT * FROM datClientMembership cm
						INNER JOIN cfgMembership m ON m.MembershipID = cm.MembershipID
					WHERE cm.ClientMembershipGUID = @CurrentBioMembership
						AND (m.MembershipDescriptionShort = @ShowNoSaleMembership))
		BEGIN

			SET @SalesOrderGUID = NEWID()
			SELECT @SalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'CLOSE' --New Membership

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
				@CenterId AS CenterID, @CenterId AS ClientHomeCenterID,
				2 AS SalesOrderTypeID, --Membership
				cm.ClientGUID AS ClientGUID,
				cm.ClientMembershipGUID,
				@AppointmentGuid AS AppointmentGUID,
				NULL AS FactoryOrderGUID,
				GETUTCDATE() AS OrderDate,
				@InvoiceNumber AS InvoiceNumber,
				0 AS IsTaxExemptFlag, 0 AS IsVoidedFlag, 1 AS IsClosedFlag,
				@ConsultantGuid AS EmployeeGUID, NULL AS FulfillmentNumber,
				0 AS IsWrittenOffFlag, 0 AS IsRefundedFlag, NULL AS RefundedSalesOrderGUID,
				0, -- IsSurgeryReversalFlag
				0, -- IsGuaranteeFlag
				GETUTCDATE() AS CreateDate, @User AS CreateUser, GETUTCDATE() AS LastUpdate, @User AS LastUpdateUser
			FROM datClientMembership cm
				INNER JOIN cfgCenter c ON cm.CenterID = c.CenterID
			WHERE cm.ClientMembershipGUID = @CurrentBioMembership

			--INSERT Sales Order Detail record
			INSERT INTO datSalesOrderDetail ([SalesOrderDetailGUID],[TransactionNumber_Temp],[SalesOrderGUID],[SalesCodeID],
				[Quantity],[Price],[Discount],[Tax1],[Tax2],[TaxRate1],[TaxRate2],
				[IsRefundedFlag],[RefundedSalesOrderDetailGUID],[RefundedTotalQuantity],[RefundedTotalPrice],
				[Employee1GUID],[Employee2GUID],[Employee3GUID],[Employee4GUID], [PreviousClientMembershipGUID],
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
				, @ConsultantGuid AS [Employee1GUID], NULL AS [Employee2GUID], NULL AS [Employee3GUID], NULL AS [Employee4GUID]
				, NULL AS PreviousClientMembershipGUID
				, GETUTCDATE() AS CreateDate, @User AS CreateUser, GETUTCDATE() AS LastUpdate, @User AS LastUpdateUser
				, NULL
			FROM datClientMembership cm
				INNER JOIN cfgCenter c ON cm.CenterID = c.CenterID
			WHERE cm.ClientMembershipGUID = @CurrentBioMembership

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
					,   @MembershipTenderTypeID  -- Membership Tender type
					,	0  -- Amount
					,	GETUTCDATE()
					,	@User
					,	GETUTCDATE()
					,	@User )

			-- Call the Accum Stored Proc
			EXEC [dbo].[mtnMembershipAccumAdjustment] 'SALES ORDER', @SalesOrderGUID

			-- Update membership to 'Cancel' status
			UPDATE datClientMembership SET
				ClientMembershipStatusId = @CancelClientMembershipStatusID,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = @User
			WHERE ClientMembershipGUID = @CurrentBioMembership

			UPDATE datClient SET
				[CurrentBioMatrixClientMembershipGUID] = NULL,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = @User
			WHERE ClientGUID = @ClientGUID

		END
	END



	-- INSERT Client record if center is a corp cONEct! center or membership is in surgery business segment
	-- or it's not a sale.
	-- If 2.5 corp center and client is created in conect (in a scenario of no sale or Surgery sale), a merge
	-- will need to occure when client is imported back into cONEct! from 2.5.
    IF @CenterBusinessType = @ConectCorpCenterBusinessType
			OR @CenterBusinessType = @ConectFranCenterBusinessType
			OR @CenterBusinessType = @ConectJVCenterBusinessType
			OR @CenterBusinessType = @HansWeihmanCenterBusinessType
			OR @BusinessSegment = @SurgeryBusinessSegment  -- Always Create Client if Surgery business segment
	BEGIN

			IF @IsClientFound = 0
			BEGIN
				INSERT INTO datClient (
				    ClientOriginalCenterID,
					ClientGUID,
					ContactID,
					ClientNumber_Temp,
					CenterID,
					SalutationID,
					FirstName,
					MiddleName,
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
					LanguageID,
					DoNotCallFlag, DoNotContactFlag, IsHairModelFlag, IsTaxExemptFlag,
					EMailAddress,
					TextMessageAddress,
					CreateDate, CreateUser, LastUpdate, LastUpdateUser,
					IsAutoConfirmEmail,
					SiebelID,
					BosleySalesforceAccountID,
					SalesforceContactID,
					LeadCreateDate)
				SELECT
				    @ClientOriginalCenterID,
					@ClientGUID AS ClientGUID,
					@ContactID AS ContactID,
					NULL AS ClientNumber_Temp,
					@CenterID AS CenterID,
					(SELECT s.SalutationID FROM lkpSalutation s WHERE s.SalutationDescription = @Salutation) AS SalutationID,
					@FirstName AS FirstName,
					@MiddleName AS MiddleName,
					@LastName AS LastName,
					@Address1 AS Address1,
					@Address2 AS Address2,
					NULL AS Address3,
					@City AS City,
					(SELECT s.StateID FROM lkpState s WHERE s.StateDescriptionShort = @State) AS StateID,
					@Zip AS PostalCode,
					(SELECT TOP 1 CountryID FROM cfgCenter WHERE CenterID = @CenterID) AS CountryID,
					0 AS ARBalance,
					CAST(@BirthDate AS date) AS DateOfBirth,
					CASE WHEN @Gender = 'F' THEN 2
							ELSE 1	-- Default to male
					END AS GenderID,
					CASE WHEN @Language = 'SPANISH' THEN 3
							ELSE null
					END AS LanguageID,
					0 AS DoNotCallFlag, 0 AS DoNotContactFlag, 0 AS IsHairModelFlag, 0 AS IsTaxExemptFlag,
					@Email AS EMailAddress, NULL AS TextMessageAddress,
					GETUTCDATE() AS CreateDate, @User AS CreateUser, GETUTCDATE() AS LastUpdate, @User AS LastUpdateUser,
					(CASE WHEN @Email IS NULL OR @Email = '' THEN NULL ELSE @IsEmailOptIn END) AS IsEmailOptIn,
					(CASE WHEN @SiebelID IS NULL OR @SiebelID = '' THEN NULL ELSE @SiebelID END) AS SiebelID,
					(CASE WHEN @BosleySalesforceAccountID IS NULL OR @BosleySalesforceAccountID = '' THEN NULL ELSE @BosleySalesforceAccountID END) AS BosleySalesforceAccountID,
					@SalesforceLeadID,
					@LeadCreateDate


					IF @StrippedPrimaryPhone IS NOT NULL AND RTRIM(LTRIM(@StrippedPrimaryPhone)) <> ''
					  BEGIN
						INSERT INTO datClientPhone (ClientGUID, PhoneTypeID, PhoneNumber, CanConfirmAppointmentByCall, CanConfirmAppointmentByText, CanContactForPromotionsByCall, CanContactForPromotionsByText, ClientPhoneSortOrder, CreateDate, CreateUser, LastUpdate, LastUpdateUser) VALUES
							(@ClientGUID, 1, @StrippedPrimaryPhone, NULL, NULL, NULL, NULL, 1, GETUTCDATE(), @User, GETUTCDATE(), @User)
					  END

				INSERT INTO [dbo].[datClientDemographic]
						   ([ClientGUID]
						   ,[ClientIdentifier]
						   ,[EthnicityID]
						   ,[OccupationID]
						   ,[MaritalStatusID]
						   ,[LudwigScaleID]
						   ,[NorwoodScaleID]
						   ,[DISCStyleID]
						   ,[SolutionOfferedID]
						   ,[PriceQuoted]
						   ,[LastConsultationDate]
						   ,[LastConsultantGUID]
						   ,[CreateDate]
						   ,[CreateUser]
						   ,[LastUpdate]
						   ,[LastUpdateUser])
					SELECT
						  c.[ClientGUID]
						  ,c.[ClientIdentifier]
						  ,@EthnicityID
						  ,@OccupationID
						  ,@MaritalStatusID
						  ,@LudwigScaleID
						  ,@NorwoodScaleID
						  ,@DISCStyleID
						  ,@SolutionOfferedBusinessSegmentID
						  ,(CASE WHEN @BusinessSegment = 'SUR' AND @IsGraftCountUsed = 1 THEN ISNULL(@PricePerGraft,0) * ISNULL(@NumberOfGrafts,0)
										ELSE ISNULL(@ContractPrice,0) END) - ISNULL(@Discount,0)
						  ,appt.AppointmentDate
						  ,@ConsultantGuid
						  ,GETUTCDATE()
						  ,@User
						  ,GETUTCDATE()
						  ,@User
					  FROM [dbo].[datClient] c
							INNER JOIN datAppointment appt ON appt.AppointmentGUID = @AppointmentGuid
					  WHERE c.ClientGUID = @ClientGUID
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
				CASE WHEN @IsSale = 1 THEN @ContractPrice ELSE 0 END AS  ContractPrice,
				0 AS  ContractPaidAmount,
				0 AS  MonthlyFee,
				@MembershipBeginDate AS  BeginDate,
				DATEADD(MONTH, @MembershipDurationMonths, @MembershipBeginDate)  AS  EndDate,
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



			-- If appointment guid is not null, then update Appointment with
			-- Client Guid and Client Membership Guid.
			-- Set appointment status to Sales Consultation complete.
			UPDATE datAppointment SET
				ClientGUID = @ClientGuid
				, ClientMembershipGUID = @ClientMembershipGUID
				, AppointmentStatusID = (SELECT AppointmentStatusID FROM lkpAppointmentStatus WHERE AppointmentStatusDescriptionShort = @SCCompleteAppointmentStatus)
				, LastUpdateUser = @User
				, LastUpdate = GETUTCDATE()
			WHERE AppointmentGUID = @AppointmentGuid

			-- If @CurrentBioMembership is not NULL, update all future appointments
			-- to the new membership.
			IF @CurrentBioMembership IS NOT NULL
				 OR @CurrentExtMembership IS NOT NULL
				 OR @CurrentXtrMembership IS NOT NULL
				 OR @CurrentMdpMembership IS NOT NULL
			BEGIN
				UPDATE datAppointment SET
					ClientMembershipGUID = @ClientMembershipGUID
					, LastUpdateUser = @User
					, LastUpdate = GETUTCDATE()
				WHERE (ClientMembershipGUID = @CurrentBioMembership
						OR ClientMembershipGUID = @CurrentExtMembership
						OR ClientMembershipGUID = @CurrentXtrMembership
						OR ClientMembershipGUID = @CurrentMdpMembership)
					AND AppointmentDate >= @Today
			END

			IF LEN(@Note) > 0
			BEGIN
				INSERT INTO [dbo].[datNotesClient]
						   ([NotesClientGUID]
						   ,[ClientGUID]
						   ,[EmployeeGUID]
						   ,[AppointmentGUID]
						   ,[SalesOrderGUID]
						   ,[ClientMembershipGUID]
						   ,[NoteTypeID]
						   ,[NotesClientDate]
						   ,[NotesClient]
						   ,[CreateDate]
						   ,[CreateUser]
						   ,[LastUpdate]
						   ,[LastUpdateUser]
						   ,[HairSystemOrderGUID]
						   ,[NoteSubTypeID]
						   ,[IsFlagged])
					 VALUES
						   (NEWID()
						   ,@ClientGUID
						   ,@ConsultantGuid
						   ,@AppointmentGuid
						   ,NULL  -- SalesOrderGUID
						   ,@ClientMembershipGUID
						   ,@ConsultationNoteTypeID
						   ,GETUTCDATE()
						   ,@Note
						   ,GETUTCDATE()
						   ,@User
						   ,GETUTCDATE()
						   ,@User
						   ,NULL  --HairSystemOrderGUID
						   ,NULL  --NoteSubTypeID
						   ,0	  --IsFlagged
						   )
			END
			ELSE
			BEGIN
				-- Update ClientNotes for the Appointment with
				-- Client Guid.
				UPDATE datNotesClient SET
					ClientGUID = @ClientGuid
					, LastUpdateUser = @User
					, LastUpdate = GETUTCDATE()
				WHERE AppointmentGUID = @AppointmentGuid
			END

			-- Update datClientSurvey for the Appointment with
			-- Client Guid.
			UPDATE datClientSurvey SET
				ClientGUID = @ClientGuid
				, LastUpdateUser = @User
				, LastUpdate = GETUTCDATE()
			WHERE AppointmentGUID = @AppointmentGuid

			---- Delete any employee that is not the selected consultant
			--DELETE FROM [datAppointmentEmployee] WHERE AppointmentGuid = @AppointmentGuid AND EmployeeGuid <> @ConsultantGuid

			---- Add Consultant selected on the Demographic screen as a employee if do not exist
			--IF NOT EXISTS(SELECT * FROM datAppointmentEmployee WHERE AppointmentGuid = @AppointmentGuid AND EmployeeGuid = @ConsultantGuid)
			--		AND @ConsultantGuid IS NOT NULL
			--BEGIN
			--	INSERT INTO [dbo].[datAppointmentEmployee]
			--			([AppointmentEmployeeGUID]
			--			,[AppointmentGUID]
			--			,[EmployeeGUID]
			--			,[CreateDate]
			--			,[CreateUser]
			--			,[LastUpdate]
			--			,[LastUpdateUser])
			--		VALUES (NEWID()
			--			, @AppointmentGuid
			--			, @ConsultantGuid
			--			, GETUTCDATE()
			--			, @User
			--			, GETUTCDATE()
			--			, @User)
			--END


			-- DETERMINE Expected Conversion Date
			--		Expected conversion date is set on the datClient record only
			--		if it's null or if the current date is less than or equal to today.
			DECLARE @ExpectedConversionDate Date = NULL
			IF (@ExpectedConversionDays IS NOT NULL AND @ExpectedConversionDays > 0)
			BEGIN
				SELECT @ExpectedConversionDate = DATEADD(dd,@ExpectedConversionDays,@Today)
			END

			-- Update Memberhsip on the client record
			UPDATE datClient SET
				CurrentBioMatrixClientMembershipGUID = CASE WHEN @BusinessSegment = 'BIO' THEN @ClientMembershipGUID ELSE CurrentBioMatrixClientMembershipGUID END
				, CurrentExtremeTherapyClientMembershipGUID = CASE WHEN @BusinessSegment = 'EXT' THEN @ClientMembershipGUID ELSE CurrentExtremeTherapyClientMembershipGUID END
				, CurrentSurgeryClientMembershipGUID = CASE WHEN @BusinessSegment = 'SUR' THEN @ClientMembershipGUID ELSE CurrentSurgeryClientMembershipGUID END
				, CurrentXtrandsClientMembershipGUID = CASE WHEN @BusinessSegment = 'XTR' THEN @ClientMembershipGUID ELSE CurrentXtrandsClientMembershipGUID END
				, CurrentMDPClientMembershipGUID = CASE WHEN @BusinessSegment = 'MDP' THEN @ClientMembershipGUID ELSE CurrentMDPClientMembershipGUID END
				, ExpectedConversionDate = CASE WHEN @ExpectedConversionDate IS NOT NULL AND
													 (ExpectedConversionDate IS NULL OR ExpectedConversionDate <= @Today)
													 THEN @ExpectedConversionDate ELSE ExpectedConversionDate END
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


			-- Upate the end date of the previous membership to yesterday's date.
			UPDATE datClientMembership SET
				EndDate = DATEADD(day, -1, @MembershipBeginDate)
				, LastUpdateUser = @User
				, LastUpdate = GETUTCDATE()
			WHERE (@BusinessSegment = 'BIO' AND ClientMembershipGuid = @CurrentBioMembership) OR
					(@BusinessSegment = 'EXT' AND ClientMembershipGuid = @CurrentExtMembership) OR
					(@BusinessSegment = 'XTR' AND ClientMembershipGuid = @CurrentXtrMembership) OR
					(@BusinessSegment = 'SUR' AND ClientMembershipGuid = @CurrentSurgeryMembership) OR
					(@BusinessSegment = 'MDP' AND ClientMembershipGuid = @CurrentMdpMembership)


			-------------------------------------------
			--  Create MO for the new Client Membership
			--------------------------------------------

			SET @SalesOrderGUID = NEWID()
			SELECT @SalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'INITASG' --New Membership

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
				@AppointmentGuid AS AppointmentGUID,
				NULL AS FactoryOrderGUID,
				GETUTCDATE() AS OrderDate,
				@InvoiceNumber AS InvoiceNumber,
				0 AS IsTaxExemptFlag, 0 AS IsVoidedFlag, 1 AS IsClosedFlag,
				@ConsultantGuid AS EmployeeGUID, NULL AS FulfillmentNumber,
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
				[Employee1GUID],[Employee2GUID],[Employee3GUID],[Employee4GUID], [PreviousClientMembershipGUID],
				[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser], [NCCMembershipPromotionID], [MembershipPromotionID])
			SELECT
					NEWID() AS SalesOrderDetailGUID, NULL AS TransactionNumber_Temp
				, @SalesOrderGUID AS SalesOrderGUID
				, @SalesCodeID AS SalesCodeID
				, CASE WHEN @BusinessSegment = 'SUR' AND @IsGraftCountUsed = 1 AND @IsSale = 1 THEN @NumberOfGrafts ELSE 1 END AS [Quantity] -- Set Quantity to 1
				, CASE WHEN @BusinessSegment = 'SUR' AND @IsGraftCountUsed = 1 AND @IsSale = 1 THEN @PricePerGraft
						WHEN (@BusinessSegment <> 'SUR' OR @IsGraftCountUsed = 0) AND @IsSale = 1 THEN @ContractPrice ELSE 0 END AS [Price]   --- Set it to the Contract Price if sale
				, CASE WHEN @BusinessSegment <> 'SUR' AND @IsSale = 1 THEN @Discount ELSE 0 END AS [Discount]
				, 0 AS [Tax1], 0 AS [Tax2], 0 AS [TaxRate1], 0 AS [TaxRate2]
				, 0 AS [IsRefundedFlag], NULL AS [RefundedSalesOrderDetailGUID], 0 AS [RefundedTotalQuantity], 0 AS [RefundedTotalPrice]
				, @ConsultantGuid AS [Employee1GUID], NULL AS [Employee2GUID], NULL AS [Employee3GUID], NULL AS [Employee4GUID]
				, CASE WHEN @BusinessSegment = 'SUR' THEN @CurrentSurgeryMembership
					WHEN @BusinessSegment = 'BIO' THEN @CurrentBioMembership
					WHEN @BusinessSegment = 'EXT' THEN @CurrentExtMembership ELSE NULL END AS PreviousClientMembershipGUID
				, GETUTCDATE() AS CreateDate, @User AS CreateUser, GETUTCDATE() AS LastUpdate, @User AS LastUpdateUser
				, CASE WHEN @NCCPromotionId = 0 THEN NULL ELSE @NCCPromotionId END
				, CASE WHEN @CenterPromotionId = 0 THEN NULL ELSE @CenterPromotionId END
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
					,   @MembershipTenderTypeID  -- Membership Tender type
					,	0  -- Amount
					,	GETUTCDATE()
					,	@User
					,	GETUTCDATE()
					,	@User )

			-- Call the Accum Stored Proc
			EXEC [dbo].[mtnMembershipAccumAdjustment] 'SALES ORDER', @SalesOrderGUID
	END

	--Return ClientGuid and ClientMembershipGuid
	SELECT @ClientGuid As ClientGuid, @ClientMembershipGUID As ClientMembershipGuid


	-- Always call SSIS to create a client in 2.5 if center business type
	-- is CMS 2.5 Corp.  This may result in client being created in cONEct! and CMS 2.5 if
	-- the client was sold surgery.
	IF @CenterBusinessType = @CMS25CorpCenterBusinessType
		AND @IsSale = 1
	BEGIN

		------ if business segment is not surgery, client was not created in
		------ cONEct! Reset clientGuid to an Empty Guid.
		----IF @BusinessSegment <> @SurgeryBusinessSegment
		----	SELECT @ClientGuid = CAST(CAST(0 as binary) as uniqueidentifier)

		DECLARE @AreaCode nvarchar(3)
		DECLARE @PhoneNumNoAreaCode nvarchar(7)

		IF LEN(@StrippedPrimaryPhone) = 10
		BEGIN
			SET @AreaCode = SUBSTRING(@StrippedPrimaryPhone, 1, 3)
			SET @PhoneNumNoAreaCode = SUBSTRING(@StrippedPrimaryPhone, 4, 7)
		END
		ELSE IF LEN(@StrippedPrimaryPhone) = 7
			SET @PhoneNumNoAreaCode = @StrippedPrimaryPhone

		-- Executes SSIS package to create a client in 2.5
		EXECUTE [dbo].[spApp_CMSCreateNewClient]
		   @Address1
		  ,@AreaCode
		  ,@CenterID
		  ,@City
		  ,@ContactID
		  ,@Email
		  ,@Gender
		  ,@LastName
		  ,@FirstName
		  ,@PhoneNumNoAreaCode
		  ,@State
		  ,@Zip

	END
END
