/* CreateDate: 11/04/2019 08:17:45.983 , ModifyDate: 03/23/2020 07:35:37.240 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
	PROCEDURE:				[selClientSummaryDetail]
	DESTINATION SERVER:		SQL01
	DESTINATION DATABASE: 	HairClubCMS
	RELATED APPLICATION:  	CMS
	AUTHOR: 				Jeremy Miller
	IMPLEMENTOR: 			Jeremy Miller
	DATE IMPLEMENTED: 		10/02/2019
	LAST REVISION DATE: 	12/13/2019
	--------------------------------------------------------------------------------------------------------
	NOTES: 	Returns a Client Summary Detail

			10/02/2019 - JLM Created Stored Proc (TFS #13165)
            12/13/2019 - JLM Add field to show whether or not client has an agreement uploaded (TFS #13609)
			12/17/2019 - SAL Add 'QANEEDED' status to hair being selected for NexthairSystemOrderNumberToUse
								(TFS #13604)
			01/09/2020 - SAL Add field to show whether or not client has signed up for HairFit App (TFS #13690)
			01/26/2020 - SAL Updated to call mtnIsClientMissingCompletedPCPAgreement to set value of
								@NoClientAgreementUploaded (TFS #13765)
			01/28/2020 - SAL Updated to rename @NoClientAgreementUploaded parameter to
								@IsClientMissingCompletedPCPAgreement to more closley match the boolean being
								returned (TFS #13779)

	--------------------------------------------------------------------------------------------------------
	SAMPLE EXECUTION:
	EXEC [selClientSummaryDetail] '0E017EDA-5FCE-4FB8-919E-798A54A21370'
***********************************************************************/

CREATE PROCEDURE [dbo].[selClientSummaryDetail]
	@ClientGuid UNIQUEIDENTIFIER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    /******Variables to be selected for result******/
    DECLARE @ExpectedConversionDate DATETIME2
    DECLARE @HasFlaggedNote BIT = 0
    DECLARE @IsCardExpire BIT = 0
    DECLARE @IsInitialApplicationWithin90Days BIT = 0
    DECLARE @HasRecentDecline BIT = 0
    DECLARE @HasClientActivityDue BIT = 0
    DECLARE @IsTechnicalProfileTemplateOverdue BIT = 0
    DECLARE @ShouldConvertMembership BIT = 0
    DECLARE @MembershipRenewReminder BIT = 0
    DECLARE @IsClientTooOldForRenewalReminder BIT = 0
    DECLARE @NextHairSystemOrderNumberToUse NVARCHAR(50) = ''
    DECLARE @IsNationalPricingWarning BIT = 0
    DECLARE @HasHairSystemFromOtherMembership BIT = 0
    DECLARE @IsHairAnniversaryDate BIT = 0
    DECLARE @NoClientUpdateFormUploaded BIT = 0
    DECLARE @IsClientMissingCompletedPCPAgreement BIT = 0
    DECLARE @IsHairFitClient BIT = 0


    /******Client variables used throughout procedure******/
    DECLARE @IsAutoRenewDisabled BIT
    DECLARE @ClientAnniversaryDate DATETIME

    SELECT  @IsAutoRenewDisabled = IsAutoRenewDisabled,
            @ClientAnniversaryDate = AnniversaryDate
    FROM datClient WHERE ClientGUID = @ClientGUID


    /******Constants******/
    DECLARE @PrimaryClientPhoneSortOrder INT = 1
    DECLARE @SecondaryClientPhoneSortOrder INT = 2
    DECLARE @AdditionalClientPhoneSortOrder INT = 3
    DECLARE @NewBusinessRevenueGroup NVARCHAR(10) = 'NB'
    DECLARE @RecurringBusinessRevenueGroup NVARCHAR(10) = 'PCP'
    DECLARE @InitialApplicationAccumulator NVARCHAR(10) = 'InitApp'
    DECLARE @BioMatrixBusinessSegment NVARCHAR(10) = 'BIO'
    DECLARE @RecurringMembershipRevenueGroup NVARCHAR(10) = 'PCP'
    DECLARE @ClientUpdateFormDocumentType NVARCHAR(10) = 'FrmClntUpd'
    DECLARE @ClientAgreementDocumentType NVARCHAR(10) = 'Agreement'
    DECLARE @CentHairSystemOrderStatus NVARCHAR(10) = 'CENT'
    DECLARE @QANeededHairSystemOrderStatus NVARCHAR(10) = 'QANEEDED'
    DECLARE @MinimumDateValue DATETIME2 = '0001-01-01'
    DECLARE @ThirtyDaysInFuture DATETIME = GETUTCDATE() + 30
    DECLARE @NinetyDaysInPast DATETIME = GETUTCDATE() - 90
    DECLARE @SixMonthsInThePast DATETIME = GETUTCDATE() - 180
    DECLARE @FourMonthsInFuture DATETIME = GETUTCDATE() + 120
    DECLARE @AnniversaryStartDate DATETIME = GETUTCDATE() - 365
    DECLARE @AnniversaryEndDate DATETIME = GETUTCDATE() - 334
    DECLARE @NinetyDaysInFuture DATETIME = GETUTCDATE() + 90
    DECLARE @DefaultDateOfBirthStartDate DATETIME = '1900-01-01 00:00:00.000'
    DECLARE @DefaultDateOfBirthEndDate DATETIME = '1900-02-01 00:00:00.000'
	DECLARE @CancelledDocumentStatusType NVARCHAR(10) = N'CANCEL'

	/******TempTables******/
	DECLARE @TempIsClientMissingCompletedPCPAgreementTable TABLE
		(
			IsClientMissingCompletedPCPAgreement BIT
		)



    --Get Expected Conversion Date
	IF EXISTS(SELECT c.* FROM datClient c
					   INNER JOIN datClientMembership cm ON c.ClientGUID = cm.ClientGUID
					   INNER JOIN cfgMembership mem ON cm.MembershipID = mem.MembershipID
					   INNER JOIN lkpRevenueGroup rg ON mem.RevenueGroupID = rg.RevenueGroupID
					   WHERE c.ClientGUID = @ClientGUID
					   AND rg.RevenueGroupDescriptionShort = @NewBusinessRevenueGroup
					   AND cm.IsActiveFlag = 1
					   AND c.ExpectedConversionDate IS NOT NULL)
	BEGIN
		SELECT @ExpectedConversionDate = ExpectedConversionDate FROM datClient WHERE ClientGUID = @ClientGUID
	END
	ELSE
	BEGIN
		SELECT @ExpectedConversionDate = @MinimumDateValue
	END



	--SET Flaged Note
	IF EXISTS (SELECT notes.* FROM datNotesClient notes
						INNER JOIN datClient c ON c.ClientGUID = notes.ClientGUID
						WHERE c.ClientGUID = @ClientGUID
						AND notes.IsFlagged = 1)
	BEGIN
		SET @HasFlaggedNote = 1
	END

	--SET IsCardExpire
	IF EXISTS(SELECT eft.* FROM datClientEFT eft
						   INNER JOIN datClient c ON eft.ClientGUID = c.ClientGUID
						   WHERE c.ClientGUID = @ClientGUID
						   AND eft.AccountExpiration <  @ThirtyDaysInFuture)
	BEGIN
		SET @IsCardExpire = 1
	END

	--SET IsInitialApplicationWithin90Days
	IF EXISTS(SELECT * FROM datClientMembership cm
					   LEFT JOIN datClient c ON cm.ClientMembershipGUID = c.CurrentBioMatrixClientMembershipGUID
					   INNER JOIN cfgMembership mem ON cm.MembershipID = mem.MembershipID
					   INNER JOIN lkpRevenueGroup rg ON mem.RevenueGroupID = rg.RevenueGroupID
					   INNER JOIN datClientMembershipAccum cma ON cm.ClientMembershipGUID = cma.ClientMembershipGUID
					   INNER JOIN cfgAccumulator acc ON cma.AccumulatorID = acc.AccumulatorID
					   WHERE c.ClientGUID = @ClientGUID
					   AND cm.IsActiveFlag = 1
					   AND rg.RevenueGroupDescriptionShort = @NewBusinessRevenueGroup
					   AND acc.AccumulatorDescriptionShort = @InitialApplicationAccumulator
					   AND cma.AccumDate IS NOT NULL
					   AND cma.AccumDate > @NinetyDaysInPast)
	BEGIN
		SET @IsInitialApplicationWithin90Days = 1
	END

	--SET HasRecentDecline
	-- Is there an Unsuccessful Pay Cycle Transaction in last 6 months AND EFT Profile has no updates in last 6 months
	DECLARE @MostRecentTransactionSuccessFlag BIT = 0
	DECLARE @MostRecentTransactionCreateDate DATETIME

	SELECT TOP 1 @MostRecentTransactionSuccessFlag =  pct.IsSuccessfulFlag,
				 @MostRecentTransactionCreateDate = pct.CreateDate FROM datPayCycleTransaction pct
																		   INNER JOIN datClient c ON pct.ClientGUID = c.ClientGUID
																		   WHERE c.ClientGUID = @ClientGUID
																		   AND pct.CreateDate >= @SixMonthsInThePast
																		   ORDER BY pct.CreateDate DESC

	DECLARE @MostRecentClientEFTLastUpdate DATETIME

	SELECT TOP 1 @MostRecentClientEFTLastUpdate = eft.LastUpdate FROM datClientEFT eft
																 INNER JOIN datClient c on eft.ClientGUID = c.ClientGUID
																 WHERE c.ClientGUID = @ClientGUID
																 ORDER BY eft.LastUpdate DESC


	IF (@MostRecentTransactionSuccessFlag = 0 AND (@MostRecentClientEFTLastUpdate IS NULL OR @MostRecentClientEFTLastUpdate < @MostRecentTransactionCreateDate))
	BEGIN
		SET @HasRecentDecline = 1
	END



	--SET HasClientActivityDue
	IF EXISTS (SELECT a.* FROM datActivity a
						INNER JOIN datClient c ON a.ClientGUID = c.ClientGUID
						WHERE c.ClientGUID = @ClientGUID
						AND a.ActivityResultID IS NULL)
	BEGIN
		SET @HasClientActivityDue = 1
	END


	--SET IsTechnicalProfileTemplateOverdue
	DECLARE @MaxLastTechProfileTemplateDate DATETIME

	SELECT @MaxLastTechProfileTemplateDate = MAX(tpb.LastTemplateDate) FROM datClient c
						LEFT JOIN datClientMembership cm ON cm.ClientMembershipGUID = c.CurrentBioMatrixClientMembershipGUID
						INNER JOIN cfgMembership mem ON cm.MembershipID = mem.MembershipID
						INNER JOIN lkpBusinessSegment bs ON mem.BusinessSegmentID = bs.BusinessSegmentID
						INNER JOIN datTechnicalProfile tp ON c.ClientGUID = tp.ClientGUID
						INNER JOIN datTechnicalProfileBio tpb ON tp.TechnicalProfileID = tpb.TechnicalProfileID
						WHERE c.ClientGUID = @ClientGUID
						AND bs.BusinessSegmentDescriptionShort = @BioMatrixBusinessSegment


	IF @MaxLastTechProfileTemplateDate < @NinetyDaysInPast
	BEGIN
		SET @IsTechnicalProfileTemplateOverdue = 1
	END


	--SET ShouldConvertMembership
	IF EXISTS (SELECT * FROM datClient c
						LEFT JOIN datClientMembership bioCm ON c.CurrentBioMatrixClientMembershipGUID = bioCm.ClientMembershipGUID
							LEFT JOIN cfgMembership bioMem ON bioCm.MembershipID = bioMem.MembershipID
							LEFT JOIN lkpRevenueGroup bioRg ON bioMem.RevenueGroupID = bioRg.RevenueGroupID
						LEFT JOIN datClientMembership extCm ON c.CurrentExtremeTherapyClientMembershipGUID = extCm.ClientMembershipGUID
							LEFT JOIN cfgMembership extMem ON extCm.MembershipID = extMem.MembershipID
							LEFT JOIN lkpRevenueGroup extRg ON extMem.RevenueGroupID = extRg.RevenueGroupID
						LEFT JOIN datClientMembership xtrCm ON c.CurrentXtrandsClientMembershipGUID = xtrCm.ClientMembershipGUID
							LEFT JOIN cfgMembership xtrMem ON xtrCm.MembershipID = xtrMem.MembershipID
							LEFT JOIN lkpRevenueGroup xtrRg ON xtrMem.RevenueGroupID = xtrRg.RevenueGroupID
						WHERE c.ClientGUID = @ClientGUID
						AND ((bioCm.ClientMembershipGUID IS NOT NULL AND bioCm.EndDate <= @ThirtyDaysInFuture AND bioRg.RevenueGroupDescriptionShort = @RecurringMembershipRevenueGroup)
							OR (extCm.ClientMembershipGUID IS NOT NULL AND extCm.EndDate <= @ThirtyDaysInFuture AND extRg.RevenueGroupDescriptionShort = @RecurringMembershipRevenueGroup)
							OR (xtrCm.ClientMembershipGUID IS NOT NULL AND xtrCm.EndDate <= @ThirtyDaysInFuture AND xtrRg.RevenueGroupDescriptionShort = @RecurringMembershipRevenueGroup)))
	BEGIN

		IF @IsAutoRenewDisabled = 0
		BEGIN
			SET @ShouldConvertMembership = 1
		END

	END


	--SET MembershipRenewReminder
	IF EXISTS (SELECT * FROM datClient c
						LEFT JOIN datClientMembership bioCm ON c.CurrentBioMatrixClientMembershipGUID = bioCm.ClientMembershipGUID
							LEFT JOIN cfgMembership bioMem ON bioCm.MembershipID = bioMem.MembershipID
							LEFT JOIN lkpRevenueGroup bioRg ON bioMem.RevenueGroupID = bioRg.RevenueGroupID
						LEFT JOIN datClientMembership extCm ON c.CurrentExtremeTherapyClientMembershipGUID = extCm.ClientMembershipGUID
							LEFT JOIN cfgMembership extMem ON extCm.MembershipID = extMem.MembershipID
							LEFT JOIN lkpRevenueGroup extRg ON extMem.RevenueGroupID = extRg.RevenueGroupID
						LEFT JOIN datClientMembership xtrCm ON c.CurrentXtrandsClientMembershipGUID = xtrCm.ClientMembershipGUID
							LEFT JOIN cfgMembership xtrMem ON xtrCm.MembershipID = xtrMem.MembershipID
							LEFT JOIN lkpRevenueGroup xtrRg ON xtrMem.RevenueGroupID = xtrRg.RevenueGroupID
						WHERE c.ClientGUID = @ClientGUID
						AND ((bioCm.ClientMembershipGUID IS NOT NULL AND (bioCm.EndDate > @ThirtyDaysInFuture AND bioCm.EndDate < @FourMonthsInFuture)AND bioRg.RevenueGroupDescriptionShort = @RecurringMembershipRevenueGroup)
							OR (extCm.ClientMembershipGUID IS NOT NULL AND (extCm.EndDate > @ThirtyDaysInFuture AND extCm.EndDate < @FourMonthsInFuture) AND extRg.RevenueGroupDescriptionShort = @RecurringMembershipRevenueGroup)
							OR (xtrCm.ClientMembershipGUID IS NOT NULL AND (xtrCm.EndDate > @ThirtyDaysInFuture AND xtrCm.EndDate < @FourMonthsInFuture) AND xtrRg.RevenueGroupDescriptionShort = @RecurringMembershipRevenueGroup)))
	BEGIN

		IF @IsAutoRenewDisabled = 0
		BEGIN
			SET @MembershipRenewReminder = 1
		END

	END



	--SET IsClientTooOldForRenewalWarning
	DECLARE @DoesClientHaveAMembershipWithMaximumAge BIT = 0

	IF EXISTS (SELECT * FROM datClient c
						INNER JOIN datClientMembership cm ON c.ClientGUID = cm.ClientGUID
						INNER JOIN cfgMembership mem on cm.MembershipID = mem.MembershipID
						WHERE c.ClientGUID = @ClientGUID
						AND mem.MaximumAge IS NOT NULL)
	BEGIN
		SET @DoesClientHaveAMembershipWithMaximumAge = 1
	END


	DECLARE @DoesClientHaveMembershipEndingWithinNinetyDays BIT = 0

	IF EXISTS (SELECT * FROM datClient c
						INNER JOIN datClientMembership cm on c.ClientGUID = cm.ClientGUID
						WHERE c.ClientGUID = @ClientGUID
						AND cm.EndDate IS NOT NULL
						AND cm.EndDate < @NinetyDaysInFuture)
	BEGIN
		SET @DoesClientHaveMembershipEndingWithinNinetyDays = 1
	END


	IF @IsAutoRenewDisabled = 0 AND @DoesClientHaveAMembershipWithMaximumAge = 1 AND @DoesClientHaveMembershipEndingWithinNinetyDays = 1
	BEGIN
		IF EXISTS (SELECT * FROM datClient c
							LEFT JOIN datClientMembership bioCm ON c.CurrentBioMatrixClientMembershipGUID = bioCm.ClientMembershipGUID
								LEFT JOIN cfgMembership bioMem ON bioCm.MembershipID = bioMem.MembershipID
							LEFT JOIN datClientMembership extCm ON c.CurrentExtremeTherapyClientMembershipGUID = extCm.ClientMembershipGUID
								LEFT JOIN cfgMembership extMem ON extCm.MembershipID = extMem.MembershipID
							LEFT JOIN datClientMembership xtrCm ON c.CurrentXtrandsClientMembershipGUID = xtrCm.ClientMembershipGUID
								LEFT JOIN cfgMembership xtrMem ON xtrCm.MembershipID = xtrMem.MembershipID
							WHERE c.ClientGUID = @ClientGUID
							AND c.DateOfBirth IS NOT NULL
							AND NOT (c.DateOfBirth >= @DefaultDateOfBirthStartDate AND c.DateOfBirth < @DefaultDateOfBirthEndDate)
							AND ((bioCm.ClientMembershipGUID IS NOT NULL AND bioMem.MaximumAge IS NOT NULL AND bioCm.EndDate IS NOT NULL AND
									(((MONTH(c.DateOfBirth) < MONTH(bioCm.EndDate) OR (MONTH(c.DateOfBirth) = MONTH(bioCm.EndDate) AND DAY(c.DateOfBirth) <= DAY(bioCm.EndDate)))
										AND bioMem.MaximumAge < (YEAR(bioCm.EndDate) - YEAR(c.DateOfBirth)))
									OR  ((MONTH(c.DateOfBirth) >= MONTH(bioCm.EndDate) AND (MONTH(c.DateOfBirth) <> MONTH(bioCm.EndDate) OR DAY(c.DateOfBirth) > DAY(bioCm.EndDate))
										AND bioMem.MaximumAge < ((YEAR(bioCm.EndDate) - YEAR(c.DateOfBirth)) - 1)))))
							OR (extCm.ClientMembershipGUID IS NOT NULL AND extMem.MaximumAge IS NOT NULL AND extCm.EndDate IS NOT NULL AND
									(((MONTH(c.DateOfBirth) < MONTH(extCm.EndDate) OR (MONTH(c.DateOfBirth) = MONTH(extCm.EndDate) AND DAY(c.DateOfBirth) <= DAY(extCm.EndDate)))
										AND extMem.MaximumAge < (YEAR(extCm.EndDate) - YEAR(c.DateOfBirth)))
									OR ((MONTH(c.DateOfBirth) >= MONTH(extCm.EndDate) AND (MONTH(c.DateOfBirth) <> MONTH(extCm.EndDate) OR DAY(c.DateOfBirth) > DAY(extCm.EndDate))
										AND extMem.MaximumAge < ((YEAR(extCm.EndDate) - YEAR(c.DateOfBirth)) - 1)))))
							OR (xtrCm.ClientMembershipGUID IS NOT NULL AND xtrMem.MaximumAge IS NOT NULL AND xtrCm.EndDate IS NOT NULL AND
									(((MONTH(c.DateOfBirth) < MONTH(xtrCm.EndDate) OR (MONTH(c.DateOfBirth) = MONTH(xtrCm.EndDate) AND DAY(c.DateOfBirth) <= DAY(xtrCm.EndDate)))
										AND xtrMem.MaximumAge < (YEAR(xtrCm.EndDate) - YEAR(c.DateOfBirth)))
									OR  ((MONTH(c.DateOfBirth) >= MONTH(xtrCm.EndDate) AND (MONTH(c.DateOfBirth) <> MONTH(xtrCm.EndDate) OR DAY(c.DateOfBirth) > DAY(xtrCm.EndDate))
										AND xtrMem.MaximumAge < ((YEAR(xtrCm.EndDate) - YEAR(c.DateOfBirth)) - 1)))))))
		BEGIN
			SET @IsClientTooOldForRenewalReminder = 1
		END
	END


	--SET NextHairSystemOrderNumberToUse
	SELECT TOP 1 @NextHairSystemOrderNumberToUse = HairSystemOrderNumber
	FROM datClient c
	INNER JOIN datHairSystemOrder hso ON c.ClientGUID = hso.ClientGUID
	INNER JOIN lkpHairSystemOrderStatus hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
	WHERE c.ClientGUID = @ClientGUID
	AND (hsos.HairSystemOrderStatusDescriptionShort = @CentHairSystemOrderStatus or hsos.HairSystemOrderStatusDescriptionShort = @QANeededHairSystemOrderStatus)
	ORDER BY hso.CreateDate


	--SET IsNationalPricingWarning
	IF EXISTS (SELECT * FROM datClient c
						LEFT JOIN datClientMembership bioCm ON c.CurrentBioMatrixClientMembershipGUID = bioCm.ClientMembershipGUID
							LEFT JOIN cfgMembership bioMem ON bioCM.MembershipID = bioMem.MembershipID
						LEFT JOIN datClientMembership extCm ON c.CurrentExtremeTherapyClientMembershipGUID = extCm.ClientMembershipGUID
							LEFT JOIN cfgMembership extMem ON extCm.MembershipID = extMem.MembershipID
						LEFT JOIN datClientMembership xtrCm ON c.CurrentXtrandsClientMembershipGUID = xtrCm.ClientMembershipGUID
							LEFT JOIN cfgMembership xtrMem ON xtrCm.MembershipID = xtrMem.MembershipID
						WHERE c.ClientGUID = @ClientGUID
						AND ((bioMem.MonthlyFee IS NOT NULL AND bioMem.MonthlyFee > 0 AND
							  bioCm.MonthlyFee IS NOT NULL AND bioCm.MonthlyFee > 0 AND
							  bioMem.MonthlyFee > bioCm.MonthlyFee) OR
							  (extMem.MonthlyFee IS NOT NULL AND extMem.MonthlyFee > 0 AND
							   extCm.MonthlyFee IS NOT NULL AND extCm.MonthlyFee > 0 AND
							   extMem.MonthlyFee > extCm.MonthlyFee) OR
							   (xtrMem.MonthlyFee IS NOT NULL AND xtrMem.MonthlyFee > 0 AND
								xtrCm.MonthlyFee IS NOT NULL AND xtrCm.MonthlyFee > 0 AND
								xtrMem.MonthlyFee > xtrCm.MonthlyFee)))
	BEGIN
		SET @IsNationalPricingWarning = 1
	END



	--SET HasHairSystemFromOtherMembership
	IF EXISTS (SELECT * FROM datClient c
						LEFT JOIN datClientMembership bioCm ON c.CurrentBioMatrixClientMembershipGUID = bioCm.CLientMembershipGUID
							LEFT JOIN datHairSystemOrder bioHso ON bioCm.ClientMembershipGUID = bioHso.ClientMembershipGUID
							LEFT JOIN cfgMembership bioMem ON bioCm.MembershipID = bioMem.MembershipID
							LEFT JOIN cfgHairSystemMembershipJoin bioHsmj ON bioMem.MembershipID = bioHsmj.MembershipID
																		  AND bioHso.HairSystemID = bioHsmj.HairSystemID
						WHERE c.ClientGUID = @ClientGUID
						AND bioCm.BeginDate IS NOT NULL
						AND bioCm.EndDate IS NOT NULL
						AND bioHso.HairSystemOrderGUID IS NOT NULL
						AND (bioHso.HairSystemOrderDate >= bioCm.BeginDate AND bioHso.HairSystemOrderDate <= bioCm.EndDate
							 AND bioHsmj.HairSystemMembershipJoinID IS NULL))
	BEGIN
		SET @HasHairSystemFromOtherMembership = 1
	END


	--SET IsHairAnniversaryDate
	IF (@ClientAnniversaryDate IS NOT NULL AND @AnniversaryStartDate <= @ClientAnniversaryDate AND @AnniversaryEndDate > @ClientAnniversaryDate)
	BEGIN
		SET @IsHairAnniversaryDate = 1
	END


	--SET NoClientUpdateFormUploaded
	IF NOT EXISTS (SELECT * FROM datClientMembershipDocument cmd
							INNER JOIN datClient c ON cmd.ClientGUID = c.ClientGUID
							INNER JOIN lkpDocumentType dt ON cmd.DocumentTypeID = dt.DocumentTypeID
							WHERE c.ClientGUID = @ClientGUID
							AND dt.DocumentTypeDescriptionShort = @ClientUpdateFormDocumentType)
	BEGIN
		SET @NoClientUpdateFormUploaded = 1
	END


	--Set IsClientMissingCompletedPCPAgreement
	INSERT INTO @TempIsClientMissingCompletedPCPAgreementTable
		EXEC ('mtnIsClientMissingCompletedPCPAgreement ''' + @ClientGUID + '''')

	SELECT TOP 1 @IsClientMissingCompletedPCPAgreement = IsClientMissingCompletedPCPAgreement FROM @TempIsClientMissingCompletedPCPAgreementTable



	--SET IsHairFitClient
	IF EXISTS(SELECT chfm.* FROM datClientHairFitMetadata chfm
						   INNER JOIN datClient c ON chfm.ClientGUID = c.ClientGUID
						   WHERE c.ClientGUID = @ClientGUID)
	BEGIN
		SET @IsHairFitClient = 1
	END

	SELECT TOP 1 client.ClientGUID AS ClientGuid,
			client.ClientIdentifier AS ClientId,
			client.FirstName,
			client.LastName,
			client.Address1 AS AddressLine1,
			client.Address2 AS AddressLine2,
			client.City,
			st.StateDescription AS [State],
			client.PostalCode,
			client.EmailAddress,
			COALESCE(gen.DescriptionResourceKey, gen.GenderDescription, NULL) AS Gender,
			gen.GenderDescriptionShort AS GenderDescriptionShort,
			primaryPhone.PhoneNumber AS PrimaryPhoneNumber,
			secondaryPhone.PhoneNumber AS SecondaryPhoneNumber,
			additionalPhone.PhoneNumber AS AdditionalPhoneNumber,
			client.AgeCalc AS Age,
			client.DateOfBirth AS DateOfBirth,
			client.CenterID AS HomeCenter,
			@ExpectedConversionDate AS ExpectedConversion,
			client.CurrentBioMatrixClientMembershipGUID AS BioMatrixGUID,
			client.CurrentExtremeTherapyClientMembershipGUID AS ExtremeGuid,
			client.CurrentSurgeryClientMembershipGUID AS SurgeryGuid,
			client.CurrentXtrandsClientMembershipGUID AS XtrandsGuid,
			client.CurrentMDPClientMembershipGUID AS MDPGuid,
			client.SiebelID AS SiebelId,
			client.DoNotCallFlag AS DoNotCall,
			client.DoNotContactFlag AS DoNotContact,
			@HasFlaggedNote AS HasFlaggedNote,
			@IsCardExpire AS IsCardExpire,
			COALESCE(ethnicity.DescriptionResourceKey, ethnicity.EthnicityDescription, NULL) AS Ethnicity,
			ethnicity.EthnicityDescriptionShort AS EthnicityDescriptionShort,
			COALESCE(occupation.DescriptionResourceKey, occupation.OccupationDescription, NULL) AS Occupation,
			bs.BusinessSegmentDescription AS InitialSolutionOffered,
			clientDemo.PriceQuoted AS InitialSolutionPrice,
			COALESCE(client.ARBalance, 0) AS ARBalance,
			@IsInitialApplicationWithin90Days AS IsInitialApplicationWithin90Days,
			@HasRecentDecline AS HasDeclinedRecently,
			@HasClientActivityDue AS HasClientActivityDue,
			@IsTechnicalProfileTemplateOverdue AS IsTechnicalProfileTemplateOverdue,
			@ShouldConvertMembership AS ShouldConvertMembership,
			@MembershipRenewReminder AS MembershipRenewReminder,
			@IsClientTooOldForRenewalReminder AS IsClientTooOldForRenewalReminder,
			@NextHairSystemOrderNumberToUse AS NextHairSystemOrderNumberToUse,
			@IsNationalPricingWarning AS IsNationalPricingWarning,
			@HasHairSystemFromOtherMembership AS HasHairSystemFromOtherMembership,
			@IsHairAnniversaryDate AS IsHairAnniversaryDate,
			@NoClientUpdateFormUploaded AS NoClientUpdateFormUploaded,
			client.AnniversaryDate AS AnniversaryDate,
			client.EmergencyContactPhone AS EmergencyContactPhone,
			client.DoNotVisitInRoom AS DoNotVisitInRoom,
			client.DoNotMoveAppointments AS DoNotMoveAppointments,
			client.IsAutoRenewDisabled AS IsAutoRenewDisabled,
			client.LastUpdate AS LastUpdate,
			client.LastUpdateUser AS LastUpdateUser,
            @IsClientMissingCompletedPCPAgreement AS IsClientMissingCompletedPCPAgreement,
			@IsHairFitClient AS IsHairFitClient
	FROM datClient client
	LEFT JOIN lkpState st ON client.StateID = st.StateID
	LEFT JOIN lkpGender gen ON client.GenderID = gen.GenderID
	LEFT JOIN datClientPhone primaryPhone ON client.ClientGUID = primaryPhone.ClientGUID
										  AND primaryPhone.ClientPhoneSortOrder = @PrimaryClientPhoneSortOrder
	LEFT JOIN lkpPhoneType primaryPhoneType ON primaryPhone.PhoneTypeID = primaryPhoneType.PhoneTypeID
	LEFT JOIN datClientPhone secondaryPhone ON client.ClientGUID = secondaryPhone.ClientGUID
										  AND secondaryPhone.ClientPhoneSortOrder = @SecondaryClientPhoneSortOrder
	LEFT JOIN lkpPhoneType secondaryPhoneType ON secondaryPhone.PhoneTypeID = secondaryPhoneType.PhoneTypeID
	LEFT JOIN datClientPhone additionalPhone ON client.ClientGUID = additionalPhone.ClientGUID
										  AND additionalPhone.ClientPhoneSortOrder = @AdditionalClientPhoneSortOrder
	LEFT JOIN lkpPhoneType additionalPhoneType ON additionalPhone.PhoneTypeID = additionalPhoneType.PhoneTypeID
	LEFT JOIN datClientDemographic clientDemo ON client.ClientGUID = clientDemo.ClientGUID
	LEFT JOIN lkpEthnicity ethnicity ON clientDemo.EthnicityID = ethnicity.EthnicityID
	LEFT JOIN lkpOccupation occupation ON clientDemo.OccupationID = occupation.OccupationID
	LEFT JOIN lkpBusinessSegment bs ON clientDemo.SolutionOfferedID = bs.BusinessSegmentID

	WHERE client.ClientGUID = @ClientGUID

END
GO
