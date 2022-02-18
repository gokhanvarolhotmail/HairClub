/* CreateDate: 09/23/2009 14:09:31.760 , ModifyDate: 01/10/2022 12:01:12.580 */
GO
/*
==============================================================================
PROCEDURE:                    mtnCenterAdd

DESTINATION SERVER:           SQL01

DESTINATION DATABASE:		  HairClubCMS

RELATED APPLICATION:		  CMS

AUTHOR:                       Paul Madary

IMPLEMENTOR:                  Paul Madary

DATE IMPLEMENTED:              ?

LAST REVISION DATE:			  03/16/2020

==============================================================================
DESCRIPTION:      Add Center
==============================================================================
NOTES:
            * 08/15/2011 MVT - Modified to include Center pricing and Finance Company.
            * 06/27/2012 JGE - Modified to make transactional.
			* 08/01/2012 MLM - Modified the CenterContract to Copy Priority Hair Contracts.
			* 08/27/2014 SAL - Modified to include parms for required Center Configuration fields
			* 10/23/2014 MVT - Modified to include params for Center Membership copy center and
								TrichoView copy center.
			* 11/28/2016 SAL - Modified to insert default values for recently added required
								cfgConfigurationCenter fields (HairOrderDelayDays, EntityID, and
								IsAutomatedAgreementEnabled
			* 12/11/2016 SAL - Modified to inclue param for UseCreditCardProcessorForCreditCardOnFile
			* 01/09/2017 MVT - Updated proc to include recently added columns
			* 01/18/2017 SAL - Updated proc to default cfgConfigurationCenter.IsTrichoViewEnabledForMobile to FALSE
							   Updated proc to copy cfgCenterTrichoView.IsSebumAvailable, .IsScalpHealthAvailable,
								and default .IsHighResUploadAvailable to FALSE
			* 02/07/2017 MVT - Modified to include new CenterNumber column in cfgCenter table (TFS #8527)
			* 09/18/2017 MVT - Modified to remove @CenterID parameter and added @CenterNumber parameter.  Modified Center
								Insert to insert @CenterNUmber and removed @CenterID since it's now an Identity.
			* 10/05/2018 MVT - Modified to remove QuantityOnHand,QuantityOnOrdered, and QuantityTotalSold from cfgSalesCodeCenter.
								Added logic to copy datSalesCodeCenterInventory records (TFS #11426,11427).
		    * 02/14/2019 JLM - Copy Add-On Pricing when copying a center (TFS #11975)
			* 07/11/2019 SAL - Modified to default cfgConfigurationCenter.IsTransferToHWEnabled to false. (TFS #12732)
			* 07/25/2019 SAL - Modified to consider the cfgCenter.IsActiveFlag when checking to see if cfgCenter.CenterNumber
								exists before inserting the new center. (TFS #12765)
			* 12/11/2019 SAL - Modified to add cfgConfigurationCenter.IsStylistCareerPathEnabled and default to false. (TFS #13540)
            * 03/17/2020 JLM - Update center pricing copy to include cuticle intact hair and root shadowing add-ons (TFS 14191 & 14192)

==============================================================================
SAMPLE EXECUTION:
EXEC
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnCenterAdd]
    @CenterNumber                              INT
  , @CenterDescription                         NVARCHAR(50)
  , @IsActive                                  BIT
  , @SurgeryHubCenterID                        INT
  , @ReportingCenterID                         INT
  , @RegionID                                  INT
  , @CenterPayGroupID                          INT
  , @CenterTypeID                              INT
  , @OwnershipTypeID                           INT
  , @EmployeeDoctorGUID                        UNIQUEIDENTIFIER
  , @DoctorRegionID                            INT
  , @Address1                                  NVARCHAR(50)
  , @Address2                                  NVARCHAR(50)
  , @Address3                                  NVARCHAR(50)
  , @City                                      NVARCHAR(50)
  , @StateID                                   INT
  , @PostalCode                                NVARCHAR(10)
  , @CountryID                                 INT
  , @TimeZoneID                                INT
  , @Phone1                                    NVARCHAR(15)
  , @Phone2                                    NVARCHAR(15)
  , @Phone3                                    NVARCHAR(15)
  , @Phone1TypeID                              INT
  , @Phone2TypeID                              INT
  , @Phone3TypeID                              INT
  , @SurgerySuiteCount                         INT
  , @TaxRate1                                  DECIMAL(6, 5)
  , @TaxRate2                                  DECIMAL(6, 5)
  , @TaxRate3                                  DECIMAL(6, 5)
  , @TaxRate4                                  DECIMAL(6, 5)
  , @TaxRate5                                  DECIMAL(6, 5)
  , @TaxRate6                                  DECIMAL(6, 5)
  , @SalesCodeCenterCopy                       INT
  , @IsSurgeryCenter                           BIT
  , @CopyCenterContractFrom_CenterID           INT
  , @CopyFinanaceCompaniesFrom_CenterID        INT
  , @CopyTrichoViewConfigurationFrom_CenterID  INT
  , @CopyCenterMembershipsFrom_CenterID        INT
  , @UseCreditCardProcessorFlag                BIT
  , @UseCreditCardProcessorForCreditCardOnFile BIT
  , @GeneralLedgerID                           INT
  , @AccountingExportFreightBaseRate           MONEY
  , @AccountingExportFreightPerItemRate        MONEY
  , @FeeNotificationDays                       INT
  , @IsFeeProcessedCentrallyFlag               BIT
  , @CenterBusinessTypeID                      INT
  , @HasFullAccess                             BIT
  , @IsSalesConsultationEnabled                BIT
  , @IsSalesOrderRoundingEnabled               BIT
  , @IsScheduleFeatureEnabled                  BIT
  , @IsFulfillmentEnabled                      BIT
  , @IsEnhSalesConsultEnabled                  BIT
  , @CenterManagementAreaID                    INT
  , @BusinessUnitBrandID                       INT
  , @User                                      NVARCHAR(25)
AS
    BEGIN
        SET NOCOUNT ON ;

        DECLARE @SurgerySuiteDescription NVARCHAR(25) ;
        DECLARE @SurgerySuiteDescriptionShort NVARCHAR(5) ;
        DECLARE @ResourceTypeID INT ;
        DECLARE @TaxTypeID INT ;
        DECLARE @NextTaxTypeID INT ;
        DECLARE @HairOrderDelayDays INT = 7 ;
        DECLARE @EntityID INT ;
        DECLARE @IsAutomatedAgreementEnabled BIT = 1 ;
        DECLARE @IsTrichoViewEnabledForMobile BIT = 0 ;
        DECLARE @IsHighResUploadAvailable BIT = 0 ;
        DECLARE @IsTransferToHWEnabled BIT = 0 ;
        DECLARE @IsStylistCareerPathEnabled BIT = 0 ;

        SELECT @EntityID = [EntityID]
        FROM [dbo].[cfgEntity]
        WHERE [EntityDescriptionShort] = 'CORPUS' ;

        BEGIN TRANSACTION ;

        BEGIN TRY

            --insert the center record
            -- RegionRSMNBConsultantGuid, RegionRSMMembershipAdvisorGuid, RegionRTMTechnicalManagerGuid,
            -- RegionOperationsManagerGuid are no longer used
            IF NOT EXISTS ( SELECT 1 FROM [dbo].[cfgCenter] WHERE [CenterNumber] = @CenterNumber AND [IsActiveFlag] = 1 )
                BEGIN
                    INSERT INTO [dbo].[cfgCenter]( [CountryID]
                                                 , [RegionID]
                                                 , [CenterPayGroupID]
                                                 , [CenterDescription]
                                                 , [CenterTypeID]
                                                 , [CenterOwnershipID]
                                                 , [SurgeryHubCenterID]
                                                 , [ReportingCenterID]
                                                 , [AliasSurgeryCenterID]
                                                 , [EmployeeDoctorGUID]
                                                 , [DoctorRegionID]
                                                 , [TimeZoneID]
                                                 , [InvoiceCounter]
                                                 , [Address1]
                                                 , [Address2]
                                                 , [Address3]
                                                 , [City]
                                                 , [StateID]
                                                 , [PostalCode]
                                                 , [Phone1]
                                                 , [Phone2]
                                                 , [Phone3]
                                                 , [Phone1TypeID]
                                                 , [Phone2TypeID]
                                                 , [Phone3TypeID]
                                                 , [IsPhone1PrimaryFlag]
                                                 , [IsPhone2PrimaryFlag]
                                                 , [IsPhone3PrimaryFlag]
                                                 , [IsCorporateHeadquartersFlag]
                                                 , [IsActiveFlag]
                                                 , [CreateDate]
                                                 , [CreateUser]
                                                 , [LastUpdate]
                                                 , [LastUpdateUser]
                                                 , [CenterManagementAreaID]
                                                 , [CenterNumber]
                                                 , [BusinessUnitBrandID] )
                    SELECT
                        @CountryID
                      , @RegionID
                      , @CenterPayGroupID
                      , @CenterDescription
                      , @CenterTypeID
                      , @OwnershipTypeID
                      , @SurgeryHubCenterID
                      , @ReportingCenterID
                      , NULL AS [AliasSurgeryCenterID]
                      , @EmployeeDoctorGUID
                      , @DoctorRegionID
                      , @TimeZoneID
                      , 0 AS [InvoiceCounter]
                      , @Address1
                      , @Address2
                      , @Address3
                      , @City
                      , @StateID
                      , @PostalCode
                      , @Phone1
                      , @Phone2
                      , @Phone3
                      , @Phone1TypeID
                      , @Phone2TypeID
                      , @Phone3TypeID
                      , 1 AS [IsPhone1PrimaryFlag]
                      , 0 AS [IsPhone2PrimaryFlag]
                      , 0 AS [IsPhone3PrimaryFlag]
                      , 0 AS [IsCorporateHeadquartersFlag]
                      , @IsActive
                      , GETUTCDATE()
                      , @User
                      , GETUTCDATE()
                      , @User
                      , @CenterManagementAreaID
                      , @CenterNumber
                      , @BusinessUnitBrandID ;
                END ;

            DECLARE @CenterID AS INTEGER ;

            SELECT @CenterID = SCOPE_IDENTITY() ;

            --insert TrichoView configuration
            IF NOT EXISTS ( SELECT 1 FROM [dbo].[cfgCenterTrichoView] WHERE [CenterID] = @CenterID )
                BEGIN
                    INSERT INTO [dbo].[cfgCenterTrichoView]( [CenterID]
                                                           , [IsProfileAvailable]
                                                           , [IsScalpAvailable]
                                                           , [IsScopeAvailable]
                                                           , [IsDensityAvailable]
                                                           , [IsWidthAvailable]
                                                           , [IsScaleAvailable]
                                                           , [IsHealthAvailable]
                                                           , [IsHMIAvailable]
                                                           , [IsSurveyAvailable]
                                                           , [IsTrichoViewReportAvailable]
                                                           , [CreateDate]
                                                           , [CreateUser]
                                                           , [LastUpdate]
                                                           , [LastUpdateUser]
                                                           , [IsImageEditorAvailable]
                                                           , [IsSebumAvailable]
                                                           , [IsScalpHealthAvailable]
                                                           , [IsHighResUploadAvailable] )
                    SELECT
                        @CenterID
                      , [IsProfileAvailable]
                      , [IsScalpAvailable]
                      , [IsScopeAvailable]
                      , [IsDensityAvailable]
                      , [IsWidthAvailable]
                      , [IsScaleAvailable]
                      , [IsHealthAvailable]
                      , [IsHMIAvailable]
                      , [IsSurveyAvailable]
                      , [IsTrichoViewReportAvailable]
                      , GETUTCDATE()
                      , @User
                      , GETUTCDATE()
                      , @User
                      , [IsImageEditorAvailable]
                      , [IsSebumAvailable]
                      , [IsScalpHealthAvailable]
                      , @IsHighResUploadAvailable
                    FROM [dbo].[cfgCenterTrichoView]
                    WHERE [CenterID] = @CopyTrichoViewConfigurationFrom_CenterID ;
                END ;

            --insert Center Memberships
            -- Disable In House Payment Plan by default
            INSERT INTO [dbo].[cfgCenterMembership]( [CenterID]
                                                   , [MembershipID]
                                                   , [IsActiveFlag]
                                                   , [CreateDate]
                                                   , [CreateUser]
                                                   , [LastUpdate]
                                                   , [LastUpdateUser]
                                                   , [ContractPriceMale]
                                                   , [ContractPriceFemale]
                                                   , [NumRenewalDays]
                                                   , [AgreementID]
                                                   , [CanUseInHousePaymentPlan]
                                                   , [DoesNewBusinessHairOrderRestrictionsApply] )
            SELECT
                @CenterID
              , [MembershipID]
              , [IsActiveFlag]
              , GETUTCDATE()
              , @User
              , GETUTCDATE()
              , @User
              , [ContractPriceMale]
              , [ContractPriceFemale]
              , [NumRenewalDays]
              , [AgreementID]
              , 0 -- default payment plan to false
              , 0 --DoesNewBusinessHairOrderRestrictionsApply
            FROM [dbo].[cfgCenterMembership]
            WHERE [CenterID] = @CopyCenterMembershipsFrom_CenterID ;

            --insert the center tax rates
            -- Don't copy over Tax Id Number
            SET @TaxTypeID = 1 ;

            IF( NOT @TaxRate1 IS NULL ) AND NOT EXISTS ( SELECT 1 FROM [dbo].[cfgCenterTaxRate] WHERE [TaxTypeID] = @TaxTypeID AND [CenterID] = @CenterID )
                BEGIN
                    SELECT @NextTaxTypeID = MAX([CenterTaxRateID]) + 1
                    FROM [dbo].[cfgCenterTaxRate] ;

                    INSERT INTO [dbo].[cfgCenterTaxRate]( [CenterTaxRateID], [CenterID], [TaxTypeID], [TaxRate], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser] )
                    VALUES( @NextTaxTypeID, @CenterID, @TaxTypeID, @TaxRate1, 1, GETUTCDATE(), @User, GETUTCDATE(), @User ) ;
                END ;

            SET @TaxTypeID = 2 ;

            IF( NOT @TaxRate2 IS NULL ) AND NOT EXISTS ( SELECT 1 FROM [dbo].[cfgCenterTaxRate] WHERE [TaxTypeID] = @TaxTypeID AND [CenterID] = @CenterID )
                BEGIN
                    SELECT @NextTaxTypeID = MAX([CenterTaxRateID]) + 1
                    FROM [dbo].[cfgCenterTaxRate] ;

                    INSERT INTO [dbo].[cfgCenterTaxRate]( [CenterTaxRateID], [CenterID], [TaxTypeID], [TaxRate], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser] )
                    VALUES( @NextTaxTypeID, @CenterID, @TaxTypeID, @TaxRate2, 1, GETUTCDATE(), @User, GETUTCDATE(), @User ) ;
                END ;

            SET @TaxTypeID = 3 ;

            IF( NOT @TaxRate3 IS NULL ) AND NOT EXISTS ( SELECT 1 FROM [dbo].[cfgCenterTaxRate] WHERE [TaxTypeID] = @TaxTypeID AND [CenterID] = @CenterID )
                BEGIN
                    SELECT @NextTaxTypeID = MAX([CenterTaxRateID]) + 1
                    FROM [dbo].[cfgCenterTaxRate] ;

                    INSERT INTO [dbo].[cfgCenterTaxRate]( [CenterTaxRateID], [CenterID], [TaxTypeID], [TaxRate], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser] )
                    VALUES( @NextTaxTypeID, @CenterID, @TaxTypeID, @TaxRate3, 1, GETUTCDATE(), @User, GETUTCDATE(), @User ) ;
                END ;

            SET @TaxTypeID = 4 ;

            IF( NOT @TaxRate4 IS NULL ) AND NOT EXISTS ( SELECT 1 FROM [dbo].[cfgCenterTaxRate] WHERE [TaxTypeID] = @TaxTypeID AND [CenterID] = @CenterID )
                BEGIN
                    SELECT @NextTaxTypeID = MAX([CenterTaxRateID]) + 1
                    FROM [dbo].[cfgCenterTaxRate] ;

                    INSERT INTO [dbo].[cfgCenterTaxRate]( [CenterTaxRateID], [CenterID], [TaxTypeID], [TaxRate], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser] )
                    VALUES( @NextTaxTypeID, @CenterID, @TaxTypeID, @TaxRate4, 1, GETUTCDATE(), @User, GETUTCDATE(), @User ) ;
                END ;

            SET @TaxTypeID = 5 ;

            IF( NOT @TaxRate5 IS NULL ) AND NOT EXISTS ( SELECT 1 FROM [dbo].[cfgCenterTaxRate] WHERE [TaxTypeID] = @TaxTypeID AND [CenterID] = @CenterID )
                BEGIN
                    SELECT @NextTaxTypeID = MAX([CenterTaxRateID]) + 1
                    FROM [dbo].[cfgCenterTaxRate] ;

                    INSERT INTO [dbo].[cfgCenterTaxRate]( [CenterTaxRateID], [CenterID], [TaxTypeID], [TaxRate], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser] )
                    VALUES( @NextTaxTypeID, @CenterID, @TaxTypeID, @TaxRate5, 1, GETUTCDATE(), @User, GETUTCDATE(), @User ) ;
                END ;

            SET @TaxTypeID = 6 ;

            IF( NOT @TaxRate6 IS NULL ) AND NOT EXISTS ( SELECT 1 FROM [dbo].[cfgCenterTaxRate] WHERE [TaxTypeID] = @TaxTypeID AND [CenterID] = @CenterID )
                BEGIN
                    SELECT @NextTaxTypeID = MAX([CenterTaxRateID]) + 1
                    FROM [dbo].[cfgCenterTaxRate] ;

                    INSERT INTO [dbo].[cfgCenterTaxRate]( [CenterTaxRateID], [CenterID], [TaxTypeID], [TaxRate], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser] )
                    VALUES( @NextTaxTypeID, @CenterID, @TaxTypeID, @TaxRate6, 1, GETUTCDATE(), @User, GETUTCDATE(), @User ) ;
                END ;

            --we currently don't have sales codes defined for non-surgery centers
            --IF @IsSurgeryCenter = 1
            -- BEGIN
            --insert the center sales codes & membership sales codes
            IF NOT EXISTS ( SELECT 1 FROM [dbo].[cfgSalesCodeCenter] WHERE [CenterID] = @CenterID )
                BEGIN
                    INSERT INTO [dbo].[cfgSalesCodeCenter]( [CenterID], [SalesCodeID], [PriceRetail], [TaxRate1ID], [TaxRate2ID], [QuantityMaxLevel], [QuantityMinLevel], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [AgreementID], [CenterCost] )
                    SELECT
                        @CenterID
                      , [scc].[SalesCodeID]
                      , [scc].[PriceRetail]
                      , [ctr1new].[CenterTaxRateID]
                      , [ctr2new].[CenterTaxRateID]
                      , [scc].[QuantityMaxLevel]
                      , [scc].[QuantityMinLevel]
                      , 1
                      , GETUTCDATE()
                      , @User
                      , GETUTCDATE()
                      , @User
                      , [scc].[AgreementID]
                      , [scc].[CenterCost]
                    FROM [dbo].[cfgSalesCodeCenter] AS [scc]
                    LEFT JOIN [dbo].[cfgCenterTaxRate] AS [ctr1] ON [scc].[TaxRate1ID] = [ctr1].[CenterTaxRateID]
                    LEFT JOIN [dbo].[cfgCenterTaxRate] AS [ctr1new] ON [ctr1].[TaxTypeID] = [ctr1new].[TaxTypeID] AND [ctr1new].[CenterID] = @CenterID
                    LEFT JOIN [dbo].[cfgCenterTaxRate] AS [ctr2] ON [scc].[TaxRate2ID] = [ctr2].[CenterTaxRateID]
                    LEFT JOIN [dbo].[cfgCenterTaxRate] AS [ctr2new] ON [ctr2].[TaxTypeID] = [ctr2new].[TaxTypeID] AND [ctr2new].[CenterID] = @CenterID
                    WHERE [scc].[CenterID] = @SalesCodeCenterCopy ;
                END ;

            IF NOT EXISTS ( SELECT 1
                            FROM [dbo].[cfgSalesCodeCenter] AS [scc]
                            INNER JOIN [dbo].[cfgSalesCodeMembership] AS [scm] ON [scc].[SalesCodeCenterID] = [scm].[SalesCodeCenterID]
                            WHERE [scc].[CenterID] = @CenterID )
                BEGIN
                    INSERT INTO [dbo].[cfgSalesCodeMembership]( [SalesCodeCenterID], [MembershipID], [Price], [TaxRate1ID], [TaxRate2ID], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser] )
                    SELECT
                        [sccnew].[SalesCodeCenterID]
                      , [scm].[MembershipID]
                      , [scm].[Price]
                      , [ctr1new].[CenterTaxRateID]
                      , [ctr2new].[CenterTaxRateID]
                      , 1
                      , GETUTCDATE()
                      , @User
                      , GETUTCDATE()
                      , @User
                    FROM [dbo].[cfgSalesCodeCenter] AS [scc]
                    INNER JOIN [dbo].[cfgSalesCodeCenter] AS [sccnew] ON [scc].[SalesCodeID] = [sccnew].[SalesCodeID] AND [sccnew].[CenterID] = @CenterID
                    INNER JOIN [dbo].[cfgSalesCodeMembership] AS [scm] ON [scc].[SalesCodeCenterID] = [scm].[SalesCodeCenterID]
                    LEFT JOIN [dbo].[cfgCenterTaxRate] AS [ctr1] ON [scm].[TaxRate1ID] = [ctr1].[CenterTaxRateID]
                    LEFT JOIN [dbo].[cfgCenterTaxRate] AS [ctr1new] ON [ctr1].[TaxTypeID] = [ctr1new].[TaxTypeID] AND [ctr1new].[CenterID] = @CenterID
                    LEFT JOIN [dbo].[cfgCenterTaxRate] AS [ctr2] ON [scm].[TaxRate2ID] = [ctr2].[CenterTaxRateID]
                    LEFT JOIN [dbo].[cfgCenterTaxRate] AS [ctr2new] ON [ctr2].[TaxTypeID] = [ctr2new].[TaxTypeID] AND [ctr2new].[CenterID] = @CenterID
                    WHERE [scc].[CenterID] = @SalesCodeCenterCopy ;
                END ;

            -- END

            -- Copy Sales Code Center Inventory Records, but set the quantities to 0
            INSERT INTO [dbo].[datSalesCodeCenterInventory]( [SalesCodeCenterID], [QuantityPar], [IsActive], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser] )
            SELECT
                [sccNew].[SalesCodeCenterID]
              , 0 -- Quantity Par
              , 1 -- Is Active
              , GETUTCDATE()
              , @User
              , GETUTCDATE()
              , @User
            FROM [dbo].[datSalesCodeCenterInventory] AS [scci]
            INNER JOIN [dbo].[cfgSalesCodeCenter] AS [scc] ON [scc].[SalesCodeCenterID] = [scci].[SalesCodeCenterID]
            INNER JOIN [dbo].[cfgSalesCodeCenter] AS [sccNew] ON [sccNew].[SalesCodeID] = [scc].[SalesCodeID] AND [sccNew].[CenterID] = @CenterID
            LEFT JOIN [dbo].[datSalesCodeCenterInventory] AS [scciNew] ON [scciNew].[SalesCodeCenterID] = [sccNew].[SalesCodeCenterID]
            WHERE [scc].[CenterID] = @SalesCodeCenterCopy AND [scci].[IsActive] = 1 AND [scciNew].[SalesCodeCenterInventoryID] IS NULL ;

            IF NOT EXISTS ( SELECT 1 FROM [dbo].[cfgConfigurationCenter] WHERE [CenterID] = @CenterID )
                BEGIN
                    INSERT INTO [dbo].[cfgConfigurationCenter]( [ConfigurationCenterSortOrder]
                                                              , [CenterID]
                                                              , [UseCreditCardProcessorFlag]
                                                              , [UseCreditCardProcessorForCreditCardOnFile]
                                                              , [CreateDate]
                                                              , [CreateUser]
                                                              , [LastUpdate]
                                                              , [LastUpdateUser]
                                                              , [AccountingExportReceiveAPDebitGLNumber]
                                                              , [AccountingExportFreightBaseRate]
                                                              , [AccountingExportFreightPerItemRate]
                                                              , [FeeNotificationDays]
                                                              , [IsFeeProcessedCentrallyFlag]
                                                              , [CenterBusinessTypeID]
                                                              , [HasFullAccess]
                                                              , [IsSalesConsultationEnabled]
                                                              , [IsSalesOrderRoundingEnabled]
                                                              , [IsScheduleFeatureEnabled]
                                                              , [IsFulfillmentEnabled]
                                                              , [IsEnhSalesConsultEnabled]
                                                              , [HairOrderDelayDays]
                                                              , [EntityID]
                                                              , [IsAutomatedAgreementEnabled]
                                                              , [IsTrichoViewEnabledForMobile]
                                                              , [IsTransferToHWEnabled]
                                                              , [IsStylistCareerPathEnabled]
                                                              , [IsConfirmAppointmentClientContactInformationEnabled] )
                    VALUES(
                              @CenterID
                            , @CenterID
                            , @UseCreditCardProcessorFlag
                            , @UseCreditCardProcessorForCreditCardOnFile
                            , GETUTCDATE()
                            , @User
                            , GETUTCDATE()
                            , @User
                            , @GeneralLedgerID
                            , @AccountingExportFreightBaseRate
                            , @AccountingExportFreightPerItemRate
                            , @FeeNotificationDays
                            , @IsFeeProcessedCentrallyFlag
                            , @CenterBusinessTypeID
                            , @HasFullAccess
                            , @IsSalesConsultationEnabled
                            , @IsSalesOrderRoundingEnabled
                            , @IsScheduleFeatureEnabled
                            , @IsFulfillmentEnabled
                            , @IsEnhSalesConsultEnabled
                            , @HairOrderDelayDays
                            , @EntityID
                            , @IsAutomatedAgreementEnabled
                            , @IsTrichoViewEnabledForMobile
                            , @IsTransferToHWEnabled
                            , @IsStylistCareerPathEnabled
                            , 0
                          ) ;
                END ;

            -- SURGERY SPECIFIC DATA
            IF @IsSurgeryCenter = 1
                BEGIN
                    --insert a new resource record up to the requested number
                    DECLARE @tempResourceCount INT ;

                    SELECT @tempResourceCount = COUNT(*)
                    FROM [dbo].[cfgResource]
                    WHERE [CenterID] = @CenterID ;

                    IF @CenterID = @SurgeryHubCenterID
                        BEGIN
                            SET @ResourceTypeID = 1 ;
                            SET @SurgerySuiteDescription = N'Surgical Suite ' ;
                            SET @SurgerySuiteDescriptionShort = N'SS' ;
                        END ;
                    ELSE
                        BEGIN
                            SET @ResourceTypeID = 2 ;
                            SET @SurgerySuiteDescription = N'Room 10' ;
                            SET @SurgerySuiteDescriptionShort = N'R10' ;
                        END ;

                    WHILE @tempResourceCount < @SurgerySuiteCount
                        BEGIN
                            SET @tempResourceCount = @tempResourceCount + 1 ;

                            INSERT INTO [dbo].[cfgResource]( [ResourceSortOrder], [ResourceDescription], [ResourceDescriptionShort], [CenterID], [ResourceTypeID], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser] )
                            VALUES(
                                      @tempResourceCount, @SurgerySuiteDescription + CAST(@tempResourceCount AS NVARCHAR), @SurgerySuiteDescriptionShort + CAST(@tempResourceCount AS NVARCHAR), @CenterID, @ResourceTypeID, 1, GETUTCDATE(), @User, GETUTCDATE(), @User
                                  ) ;
                        END ;

                    IF NOT EXISTS ( SELECT 1 FROM [dbo].[cfgSurgeryGraftPricing] WHERE [CenterID] = @CenterID )
                        BEGIN
                            INSERT INTO [dbo].[cfgSurgeryGraftPricing]( [SurgeryGraftPricingSortOrder], [CenterID], [GraftsMinimum], [GraftsMaximum], [CostPerGraft], [IsActive], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser] )
                            SELECT
                                [SurgeryGraftPricingSortOrder]
                              , @CenterID
                              , [GraftsMinimum]
                              , [GraftsMaximum]
                              , [CostPerGraft]
                              , 1
                              , GETUTCDATE()
                              , @User
                              , GETUTCDATE()
                              , @User
                            FROM [dbo].[cfgSurgeryGraftPricing]
                            WHERE [CenterID] = @SalesCodeCenterCopy ;
                        END ;
                END ;

            -- Center Contracts don't Exist, then copy from Specified Center
            IF @CopyCenterContractFrom_CenterID IS NOT NULL AND NOT EXISTS ( SELECT * FROM [dbo].[cfgHairSystemCenterContract] WHERE [CenterID] = @CenterID )
                BEGIN
                    INSERT INTO [dbo].[cfgHairSystemCenterContract]( [CenterID], [ContractEntryDate], [ContractBeginDate], [ContractEndDate], [IsActiveContract], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [IsRepair], [IsPriorityContract] )
                    SELECT
                        @CenterID
                      , GETUTCDATE()
                      , [c].[ContractBeginDate]
                      , [c].[ContractEndDate]
                      , [c].[IsActiveContract]
                      , GETUTCDATE()
                      , @User
                      , GETUTCDATE()
                      , @User
                      , [c].[IsRepair]
                      , [c].[IsPriorityContract]
                    FROM [dbo].[cfgHairSystemCenterContract] AS [c]
                    WHERE [c].[CenterID] = @CopyCenterContractFrom_CenterID AND [c].[IsActiveContract] = 1 ;

                    DECLARE
                        @CopyFromCenterContractID          INT
                      , @CopyFromCenterContractID_Repair   INT
                      , @CopyFromCenterContractID_Priority INT
                      , @CopyToCenterContractID            INT
                      , @CopyToCenterContractID_Repair     INT
                      , @CopyToCenterContractID_Priority   INT ;

                    SELECT @CopyFromCenterContractID = [c].[HairSystemCenterContractID]
                    FROM [dbo].[cfgHairSystemCenterContract] AS [c]
                    WHERE [c].[CenterID] = @CopyCenterContractFrom_CenterID AND [c].[IsActiveContract] = 1 AND [c].[IsRepair] = 0 AND [c].[IsPriorityContract] = 0 ;

                    SELECT @CopyFromCenterContractID_Repair = [c].[HairSystemCenterContractID]
                    FROM [dbo].[cfgHairSystemCenterContract] AS [c]
                    WHERE [c].[CenterID] = @CopyCenterContractFrom_CenterID AND [c].[IsActiveContract] = 1 AND [c].[IsRepair] = 1 AND [c].[IsPriorityContract] = 0 ;

                    SELECT @CopyFromCenterContractID_Priority = [c].[HairSystemCenterContractID]
                    FROM [dbo].[cfgHairSystemCenterContract] AS [c]
                    WHERE [c].[CenterID] = @CopyCenterContractFrom_CenterID AND [c].[IsActiveContract] = 1 AND [c].[IsRepair] = 0 AND [c].[IsPriorityContract] = 1 ;

                    SELECT @CopyToCenterContractID = [c].[HairSystemCenterContractID]
                    FROM [dbo].[cfgHairSystemCenterContract] AS [c]
                    WHERE [c].[CenterID] = @CenterID AND [c].[IsActiveContract] = 1 AND [c].[IsRepair] = 0 AND [c].[IsPriorityContract] = 0 ;

                    SELECT @CopyToCenterContractID_Repair = [c].[HairSystemCenterContractID]
                    FROM [dbo].[cfgHairSystemCenterContract] AS [c]
                    WHERE [c].[CenterID] = @CenterID AND [c].[IsActiveContract] = 1 AND [c].[IsRepair] = 1 AND [c].[IsPriorityContract] = 0 ;

                    SELECT @CopyToCenterContractID_Priority = [c].[HairSystemCenterContractID]
                    FROM [dbo].[cfgHairSystemCenterContract] AS [c]
                    WHERE [c].[CenterID] = @CenterID AND [c].[IsActiveContract] = 1 AND [c].[IsRepair] = 0 AND [c].[IsPriorityContract] = 1 ;

                    -- Copy non-repair pricing contracts
                    INSERT INTO [dbo].[cfgHairSystemCenterContractPricing]( [HairSystemCenterContractID]
                                                                          , [HairSystemID]
                                                                          , [HairSystemHairLengthID]
                                                                          , [HairSystemPrice]
                                                                          , [IsContractPriceInActive]
                                                                          , [HairSystemAreaRangeBegin]
                                                                          , [HairSystemAreaRangeEnd]
                                                                          , [CreateDate]
                                                                          , [CreateUser]
                                                                          , [LastUpdate]
                                                                          , [LastUpdateUser]
                                                                          , [AddOnSignatureHairlinePrice]
                                                                          , [AddOnExtendedLacePrice]
                                                                          , [AddOnOmbrePrice]
                                                                          , [AddOnCuticleIntactHairPrice]
                                                                          , [AddOnRootShadowingPrice] )
                    SELECT
                        @CopyToCenterContractID
                      , [cp].[HairSystemID]
                      , [cp].[HairSystemHairLengthID]
                      , [cp].[HairSystemPrice]
                      , [cp].[IsContractPriceInActive]
                      , [cp].[HairSystemAreaRangeBegin]
                      , [cp].[HairSystemAreaRangeEnd]
                      , GETUTCDATE()
                      , @User
                      , GETUTCDATE()
                      , @User
                      , [cp].[AddOnSignatureHairlinePrice]
                      , [cp].[AddOnExtendedLacePrice]
                      , [cp].[AddOnOmbrePrice]
                      , [cp].[AddOnCuticleIntactHairPrice]
                      , [cp].[AddOnRootShadowingPrice]
                    FROM [dbo].[cfgHairSystemCenterContractPricing] AS [cp]
                    WHERE [cp].[HairSystemCenterContractID] = @CopyFromCenterContractID ;

                    -- Copy repair pricing contracts
                    INSERT INTO [dbo].[cfgHairSystemCenterContractPricing]( [HairSystemCenterContractID]
                                                                          , [HairSystemID]
                                                                          , [HairSystemHairLengthID]
                                                                          , [HairSystemPrice]
                                                                          , [IsContractPriceInActive]
                                                                          , [HairSystemAreaRangeBegin]
                                                                          , [HairSystemAreaRangeEnd]
                                                                          , [CreateDate]
                                                                          , [CreateUser]
                                                                          , [LastUpdate]
                                                                          , [LastUpdateUser]
                                                                          , [AddOnSignatureHairlinePrice]
                                                                          , [AddOnExtendedLacePrice]
                                                                          , [AddOnOmbrePrice]
                                                                          , [AddOnCuticleIntactHairPrice]
                                                                          , [AddOnRootShadowingPrice] )
                    SELECT
                        @CopyToCenterContractID_Repair
                      , [cp].[HairSystemID]
                      , [cp].[HairSystemHairLengthID]
                      , [cp].[HairSystemPrice]
                      , [cp].[IsContractPriceInActive]
                      , [cp].[HairSystemAreaRangeBegin]
                      , [cp].[HairSystemAreaRangeEnd]
                      , GETUTCDATE()
                      , @User
                      , GETUTCDATE()
                      , @User
                      , [cp].[AddOnSignatureHairlinePrice]
                      , [cp].[AddOnExtendedLacePrice]
                      , [cp].[AddOnOmbrePrice]
                      , [cp].[AddOnCuticleIntactHairPrice]
                      , [cp].[AddOnRootShadowingPrice]
                    FROM [dbo].[cfgHairSystemCenterContractPricing] AS [cp]
                    WHERE [cp].[HairSystemCenterContractID] = @CopyFromCenterContractID_Repair ;

                    -- Copy priority pricing contracts
                    INSERT INTO [dbo].[cfgHairSystemCenterContractPricing]( [HairSystemCenterContractID]
                                                                          , [HairSystemID]
                                                                          , [HairSystemHairLengthID]
                                                                          , [HairSystemPrice]
                                                                          , [IsContractPriceInActive]
                                                                          , [HairSystemAreaRangeBegin]
                                                                          , [HairSystemAreaRangeEnd]
                                                                          , [CreateDate]
                                                                          , [CreateUser]
                                                                          , [LastUpdate]
                                                                          , [LastUpdateUser]
                                                                          , [AddOnSignatureHairlinePrice]
                                                                          , [AddOnExtendedLacePrice]
                                                                          , [AddOnOmbrePrice]
                                                                          , [AddOnCuticleIntactHairPrice]
                                                                          , [AddOnRootShadowingPrice] )
                    SELECT
                        @CopyToCenterContractID_Priority
                      , [cp].[HairSystemID]
                      , [cp].[HairSystemHairLengthID]
                      , [cp].[HairSystemPrice]
                      , [cp].[IsContractPriceInActive]
                      , [cp].[HairSystemAreaRangeBegin]
                      , [cp].[HairSystemAreaRangeEnd]
                      , GETUTCDATE()
                      , @User
                      , GETUTCDATE()
                      , @User
                      , [cp].[AddOnSignatureHairlinePrice]
                      , [cp].[AddOnExtendedLacePrice]
                      , [cp].[AddOnOmbrePrice]
                      , [cp].[AddOnCuticleIntactHairPrice]
                      , [cp].[AddOnRootShadowingPrice]
                    FROM [dbo].[cfgHairSystemCenterContractPricing] AS [cp]
                    WHERE [cp].[HairSystemCenterContractID] = @CopyFromCenterContractID_Priority ;
                END ;

            -- Add Finance Company Joins for Surgery Center
            IF NOT EXISTS ( SELECT * FROM [dbo].[cfgCenterFinanceCompanyJoin] WHERE [CenterID] = @CenterID )
                BEGIN
                    INSERT INTO [dbo].[cfgCenterFinanceCompanyJoin]( [CenterID], [FinanceCompanyID], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser] )
                    SELECT
                        @CenterID
                      , [fj].[FinanceCompanyID]
                      , GETUTCDATE()
                      , @User
                      , GETUTCDATE()
                      , @User
                    FROM [dbo].[cfgCenterFinanceCompanyJoin] AS [fj]
                    WHERE [fj].[CenterID] = @CopyFinanaceCompaniesFrom_CenterID ;
                END ;

            COMMIT TRANSACTION ;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION ;

            DECLARE @ErrorMessage NVARCHAR(4000) ;
            DECLARE @ErrorSeverity INT ;
            DECLARE @ErrorState INT ;

            SELECT
                @ErrorMessage = ERROR_MESSAGE()
              , @ErrorSeverity = ERROR_SEVERITY()
              , @ErrorState = ERROR_STATE() ;

            RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState) ;
        END CATCH ;
    END ;
GO
