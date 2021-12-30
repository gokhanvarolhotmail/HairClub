/* CreateDate: 05/03/2010 12:26:23.510 , ModifyDate: 03/22/2021 10:52:03.967 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DDS_DimContact_Upsert]
    @DataPkgKey INT,
    @IgnoreRowCnt BIGINT OUTPUT,
    @InsertRowCnt BIGINT OUTPUT,
    @UpdateRowCnt BIGINT OUTPUT,
    @ExceptionRowCnt BIGINT OUTPUT,
    @ExtractRowCnt BIGINT OUTPUT,
    @InsertNewRowCnt BIGINT OUTPUT,
    @InsertInferredRowCnt BIGINT OUTPUT,
    @InsertSCD2RowCnt BIGINT OUTPUT,
    @UpdateInferredRowCnt BIGINT OUTPUT,
    @UpdateSCD1RowCnt BIGINT OUTPUT,
    @UpdateSCD2RowCnt BIGINT OUTPUT,
    @InitialRowCnt BIGINT OUTPUT,
    @FinalRowCnt BIGINT OUTPUT
AS
-------------------------------------------------------------------------
-- [spHC_DDS_DimContact_Upsert] is used to update
-- SCD Type 1 records, update SCD Type 2 records and insert
-- New records
--
--
--   exec [bi_mktg_stage].[spHC_DDS_DimContact_Upsert] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/23/2009  RLifke       Initial Creation
--			10/26/2011  kMurdoch	 Fixed Ignore count logic
--			08/22/2017  KMurdoch	 Added HairLoss Question/Answers
--			10/24/2017  KMurdoch     Added Create and Update Date
--			11/20/2017  KMurdoch     Added SFDC_LeadID
--			04/13/2018	KMurdoch	 Added SiebelID
--			07/14/2020  KMurdoch     Added DMARegion & DMADescription
--			07/23/2020	KMurdoch	 Added Address Information from Lead
--			08/21/2020  KMurdoch     Added GCLID
--			09/10/2020  KMurdoch     added SFDC_PersonAccountID
--			10/26/2020  KMurdoch     Added SFDC_IsDeleted
--			11/24/2020  KMurdoch     Added LeadSource
--			12/30/2020  KMurdoch     Added Accomodation
--			02/09/2021  KMurdoch     Added Phone, MobilePhone & Email
--			03/22/2021  KMurdoch     Added Lead_Activity_Status__c
-------------------------------------------------------------------------
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;


    DECLARE @intError INT,                   -- error code
            @intDBErrorLogID INT,            -- ID of error record logged
            @intRowCount INT,                -- count of rows modified
            @vchTagValueList NVARCHAR(1000), -- Named Valued Pairs of Parameters
            @return_value INT;

    DECLARE @TableName VARCHAR(150); -- Name of table

    DECLARE @DeletedRowCnt BIGINT,
            @DuplicateRowCnt BIGINT,
            @HealthyRowCnt BIGINT,
            @RejectedRowCnt BIGINT,
            @AllowedRowCnt BIGINT,
            @FixedRowCnt BIGINT,
            @OrphanedRowCnt BIGINT;

    SET @TableName = N'[bi_mktg_dds].[DimContact]';

    BEGIN TRY

        SET @IgnoreRowCnt = 0;
        SET @InsertRowCnt = 0;
        SET @UpdateRowCnt = 0;
        SET @ExceptionRowCnt = 0;
        SET @ExtractRowCnt = 0;
        SET @InsertNewRowCnt = 0;
        SET @InsertInferredRowCnt = 0;
        SET @InsertSCD2RowCnt = 0;
        SET @UpdateInferredRowCnt = 0;
        SET @UpdateSCD1RowCnt = 0;
        SET @UpdateSCD2RowCnt = 0;
        SET @InitialRowCnt = 0;
        SET @FinalRowCnt = 0;
        SET @DeletedRowCnt = 0;
        SET @DuplicateRowCnt = 0;
        SET @HealthyRowCnt = 0;
        SET @RejectedRowCnt = 0;
        SET @AllowedRowCnt = 0;
        SET @FixedRowCnt = 0;
        SET @OrphanedRowCnt = 0;


        -- Data pkg auditing
        EXEC @return_value = [bief_stage].[sp_META_AuditDataPkgDetail_LoadStart] @DataPkgKey,
                                                                                 @TableName;

        -- Determine Initial Row Cnt
        SELECT @InitialRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[synHC_DDS_DimContact];

        -- Determine the number of extracted rows
        SELECT @ExtractRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[DimContact] STG
        WHERE STG.[DataPkgKey] = @DataPkgKey;

        ------------------------
        -- Deleted Records
        ------------------------
        DELETE FROM [bi_mktg_stage].[synHC_DDS_DimContact]
        WHERE SFDC_LeadID IN (
                                   SELECT STG.SFDC_LeadID
                                   FROM [bi_mktg_stage].[DimContact] STG
                                   WHERE STG.[IsDelete] = 1
                                         AND STG.[DataPkgKey] = @DataPkgKey
                               );


        --------------------------
        ---- Deleted Records
        --------------------------
        --DELETE FROM [bi_mktg_stage].[synHC_DDS_DimContact]
        --WHERE [ContactSSID] NOT IN (
        --                               SELECT SRC.[contact_id]
        --                               FROM [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_contact] SRC WITH (NOLOCK)
        --                           )
        --      AND [ContactKey] <> -1;

        --SET @OrphanedRowCnt = @@ROWCOUNT;


        ------------------------
        -- New Records
        ------------------------
        INSERT INTO [bi_mktg_stage].[synHC_DDS_DimContact]
        (
            [ContactSSID],
            [ContactFirstName],
            [ContactMiddleName],
            [ContactLastName],
            [ContactSuffix],
            [Salutation],
            [ContactStatusSSID],
            [ContactStatusDescription],
            [ContactMethodSSID],
            [ContactMethodDescription],
            [DoNotSolicitFlag],
            [DoNotCallFlag],
            [DoNotEmailFlag],
            [DoNotMailFlag],
            [DoNotTextFlag],
            [ContactGender],
            [ContactCallTime],
            [CompleteSale],
            [ContactResearch],
            [ReferringStore],
            [ReferringStylist],
            [ContactLanguageSSID],
            [ContactLanguageDescription],
            [ContactPromotonSSID],
            [ContactPromotionDescription],
            [ContactRequestSSID],
            [ContactRequestDescription],
            [ContactAgeRangeSSID],
            [ContactAgeRangeDescription],
            [ContactHairLossSSID],
            [ContactHairLossDescription],
            [DNCFlag],
            [DNCDate],
            [ContactAffiliateID],
			[ContactSessionID],
			[SFDC_LeadID],
			[SFDC_PersonAccountID],
			[BosleySiebelID],
            [ContactCenterSSID],
            [ContactCenter],
            [ContactAlternateCenter],
            [HairLossTreatment],
            [HairLossSpot],
            [HairLossExperience],
            [HairLossinFamily],
            [HairLossFamily],
            [CreationDate],
            [UpdateDate],
			[DMARegion],
			[DMADescription],
			[Street],
			[City],
			[State],
			[StateCode],
			[Country],
			[CountryCode],
			[PostalCode],
			[GCLID],
			[LeadSource],
			[Phone],
			[MobilePhone],
			[Email],
			[SFDC_IsDeleted],
			[Accomodation],
			[Lead_Activity_Status__c],
            [RowIsCurrent],
            [RowStartDate],
            [RowEndDate],
            [RowChangeReason],
            [RowIsInferred],
            [InsertAuditKey],
            [UpdateAuditKey]
        )
        SELECT STG.[ContactSSID],
               STG.[ContactFirstName],
               STG.[ContactMiddleName],
               STG.[ContactLastName],
               STG.[ContactSuffix],
               STG.[Salutation],
               STG.[ContactStatusSSID],
               STG.[ContactStatusDescription],
               STG.[ContactMethodSSID],
               STG.[ContactMethodDescription],
               STG.[DoNotSolicitFlag],
               STG.[DoNotCallFlag],
               STG.[DoNotEmailFlag],
               STG.[DoNotMailFlag],
               STG.[DoNotTextFlag],
               STG.[ContactGender],
               STG.[ContactCallTime],
               STG.[CompleteSale],
               STG.[ContactResearch],
               STG.[ReferringStore],
               STG.[ReferringStylist],
               STG.[ContactLanguageSSID],
               STG.[ContactLanguageDescription],
               STG.[ContactPromotonSSID],
               STG.[ContactPromotionDescription],
               STG.[ContactRequestSSID],
               STG.[ContactRequestDescription],
               ISNULL(STG.[ContactAgeRangeSSID], '-2'),
               ISNULL(STG.[ContactAgeRangeDescription], 'Unknown'),
               STG.[ContactHairLossSSID],
               STG.[ContactHairLossDescription],
               STG.[DNCFlag],
               STG.[DNCDate],
               STG.[ContactAffiliateID],
               STG.[ContactSessionid],
			   STG.[SFDC_LeadID],
			   STG.[SFDC_PersonAccountID],
			   STG.[BosleySiebelID],
			   STG.[ContactCenterSSID],
               STG.[ContactCenter],
               STG.[ContactAlternateCenter],
               STG.[HairLossTreatment],
               STG.[HairLossSpot],
               STG.[HairLossExperience],
               STG.[HairLossInFamily],
               STG.[HairLossFamily],
               STG.[CreationDate],
               STG.[UpdateDate],
			   STG.[DMARegion],
			   STG.[DMADescription],
			   STG.[Street],
			   STG.[City],
			   STG.[State],
			   STG.[StateCode],
			   STG.[Country],
			   STG.[CountryCode],
			   STG.[PostalCode],
			   STG.[GCLID],
			   STG.[LeadSource],
			   STG.[Phone],
			   STG.[MobilePhone],
			   STG.[Email],
			   STG.[SFDC_IsDeleted],
			   STG.[Accomodation],
			   [Lead_Activity_Status__c],
               1,                                       -- [RowIsCurrent]
               CAST('1753-01-01 00:00:00' AS DATETIME), -- [RowStartDate]
               CAST('9999-12-31 00:00:00' AS DATETIME), -- [RowEndDate]
               'New Record',                            -- [RowChangeReason]
               0,
               @DataPkgKey,
               -2                                       -- 'Not Updated Yet'
        FROM [bi_mktg_stage].[DimContact] STG
        WHERE STG.[IsNew] = 1
              AND STG.[IsException] = 0
              AND STG.[IsDuplicate] = 0
              AND STG.[DataPkgKey] = @DataPkgKey;

        SET @InsertNewRowCnt = @@ROWCOUNT;


        ------------------------
        -- Inferred Members
        ------------------------
        -- Just update the record
        UPDATE DW
        SET DW.[ContactSSID] = STG.[ContactSSID],
			DW.[ContactFirstName] = STG.[ContactFirstName],
            DW.[ContactMiddleName] = STG.[ContactMiddleName],
            DW.[ContactLastName] = STG.[ContactLastName],
            DW.[ContactSuffix] = STG.[ContactSuffix],
            DW.[Salutation] = STG.[Salutation],
            DW.[ContactStatusSSID] = STG.[ContactStatusSSID],
            DW.[ContactStatusDescription] = STG.[ContactStatusDescription],
            DW.[ContactMethodSSID] = STG.[ContactMethodSSID],
            DW.[ContactMethodDescription] = STG.[ContactMethodDescription],
            DW.[DoNotSolicitFlag] = STG.[DoNotSolicitFlag],
            DW.[DoNotCallFlag] = STG.[DoNotCallFlag],
            DW.[DoNotEmailFlag] = STG.[DoNotEmailFlag],
            DW.[DoNotMailFlag] = STG.[DoNotMailFlag],
            DW.[DoNotTextFlag] = STG.[DoNotTextFlag],
            DW.[ContactGender] = STG.[ContactGender],
            DW.[ContactCallTime] = STG.[ContactCallTime],
            DW.[CompleteSale] = STG.[CompleteSale],
            DW.[ContactResearch] = STG.[ContactResearch],
            DW.[ReferringStore] = STG.[ReferringStore],
            DW.[ReferringStylist] = STG.[ReferringStylist],
            DW.[ContactLanguageSSID] = STG.[ContactLanguageSSID],
            DW.[ContactLanguageDescription] = STG.[ContactLanguageDescription],
            DW.[ContactPromotonSSID] = STG.[ContactPromotonSSID],
            DW.[ContactPromotionDescription] = STG.[ContactPromotionDescription],
            DW.[ContactRequestSSID] = STG.[ContactRequestSSID],
            DW.[ContactRequestDescription] = STG.[ContactRequestDescription],
            DW.[ContactAgeRangeSSID] = ISNULL(STG.[ContactAgeRangeSSID], '-2'),
            DW.[ContactAgeRangeDescription] = ISNULL(STG.[ContactAgeRangeDescription], 'Unknown'),
            DW.[ContactHairLossSSID] = STG.[ContactHairLossSSID],
            DW.[ContactHairLossDescription] = STG.[ContactHairLossDescription],
            DW.[DNCFlag] = STG.[DNCFlag],
            DW.[DNCDate] = STG.[DNCDate],
            DW.[ContactAffiliateID] = STG.[ContactAffiliateID],
            DW.[ContactCenterSSID] = STG.[ContactCenterSSID],
            DW.[ContactCenter] = STG.[ContactCenter],
            DW.[ContactAlternateCenter] = STG.[ContactAlternateCenter],
            DW.[HairLossTreatment] = STG.[HairLossTreatment],
            DW.[HairLossSpot] = STG.[HairLossSpot],
            DW.[HairLossExperience] = STG.[HairLossExperience],
            DW.[HairLossinFamily] = STG.[HairLossInFamily],
            DW.[HairLossFamily] = STG.[HairLossFamily],
			DW.[CreationDate] = STG.[CreationDate],
			DW.[UpdateDate] = STG.[UpdateDate],
			DW.[ContactSessionID] = STG.[ContactSessionid],
			DW.[SFDC_LeadID] = STG.[SFDC_LeadID],
			DW.[SFDC_PersonAccountID] = STG.[SFDC_PersonAccountID],
			DW.[BosleySiebelID] = STG.[BosleySiebelID],
			DW.[DMARegion] = STG.[DMARegion],
			DW.[DMADescription] = STG.[DMADescription],
			DW.[Street] = STG.[Street],
			DW.[City] = STG.[City],
			DW.[State] = STG.[State],
			DW.[StateCode] = STG.[StateCode],
			DW.[Country] = STG.[Country],
			DW.[CountryCode] = STG.[CountryCode],
			DW.[PostalCode] = STG.[PostalCode],
			DW.[GCLID] = STG.[GCLID],
			DW.[LeadSource] = STG.[LeadSource],
			DW.[Phone] = STG.[Phone],
			DW.[MobilePhone] = STG.[MobilePhone],
			DW.[Email] = STG.[Email],
			DW.[SFDC_IsDeleted] = STG.[SFDC_IsDeleted],
			DW.[Accomodation] = STG.[Accomodation],
			DW.[Lead_Activity_Status__c] = STG.[Lead_Activity_Status__c],
            DW.[RowChangeReason] = 'Updated Inferred Member',
            DW.[RowIsInferred] = 0,
            DW.[UpdateAuditKey] = @DataPkgKey
        FROM [bi_mktg_stage].[DimContact] STG
            JOIN [bi_mktg_stage].[synHC_DDS_DimContact] DW
                ON DW.[SFDC_LeadID] = STG.[SFDC_LeadID]
                   AND DW.[RowIsCurrent] = 1
                   AND DW.[RowIsInferred] = 1
        WHERE STG.[IsInferredMember] = 1
              AND STG.[IsException] = 0
              AND STG.[DataPkgKey] = @DataPkgKey;

        SET @UpdateInferredRowCnt = @@ROWCOUNT;


        ------------------------
        -- SCD Type 1
        ------------------------
        -- Just update the record
        UPDATE DW
        SET DW.[ContactSSID] = STG.[ContactSSID],
			DW.[ContactFirstName] = STG.[ContactFirstName],
            DW.[ContactMiddleName] = STG.[ContactMiddleName],
            DW.[ContactLastName] = STG.[ContactLastName],
            DW.[ContactSuffix] = STG.[ContactSuffix],
            DW.[Salutation] = STG.[Salutation],
            DW.[ContactStatusSSID] = STG.[ContactStatusSSID],
            DW.[ContactStatusDescription] = STG.[ContactStatusDescription],
            DW.[ContactMethodSSID] = STG.[ContactMethodSSID],
            DW.[ContactMethodDescription] = STG.[ContactMethodDescription],
            DW.[DoNotSolicitFlag] = STG.[DoNotSolicitFlag],
            DW.[DoNotCallFlag] = STG.[DoNotCallFlag],
            DW.[DoNotEmailFlag] = STG.[DoNotEmailFlag],
            DW.[DoNotMailFlag] = STG.[DoNotMailFlag],
            DW.[DoNotTextFlag] = STG.[DoNotTextFlag],
            DW.[ContactGender] = STG.[ContactGender],
            DW.[ContactCallTime] = STG.[ContactCallTime],
            DW.[CompleteSale] = STG.[CompleteSale],
            DW.[ContactResearch] = STG.[ContactResearch],
            DW.[ReferringStore] = STG.[ReferringStore],
            DW.[ReferringStylist] = STG.[ReferringStylist],
            DW.[ContactLanguageSSID] = STG.[ContactLanguageSSID],
            DW.[ContactLanguageDescription] = STG.[ContactLanguageDescription],
            DW.[ContactPromotonSSID] = STG.[ContactPromotonSSID],
            DW.[ContactPromotionDescription] = STG.[ContactPromotionDescription],
            DW.[ContactRequestSSID] = STG.[ContactRequestSSID],
            DW.[ContactRequestDescription] = STG.[ContactRequestDescription],
            DW.[ContactAgeRangeSSID] = ISNULL(STG.[ContactAgeRangeSSID], '-2'),
            DW.[ContactAgeRangeDescription] = ISNULL(STG.[ContactAgeRangeDescription], 'Unknown'),
            DW.[ContactHairLossSSID] = STG.[ContactHairLossSSID],
            DW.[ContactHairLossDescription] = STG.[ContactHairLossDescription],
            DW.[DNCFlag] = STG.[DNCFlag],
            DW.[DNCDate] = STG.[DNCDate],
            DW.[ContactAffiliateID] = STG.[ContactAffiliateID],
            DW.[ContactCenterSSID] = STG.[ContactCenterSSID],
            DW.[ContactCenter] = STG.[ContactCenter],
            DW.[ContactAlternateCenter] = STG.[ContactAlternateCenter],
            DW.[HairLossTreatment] = STG.[HairLossTreatment],
            DW.[HairLossSpot] = STG.[HairLossSpot],
            DW.[HairLossExperience] = STG.[HairLossExperience],
            DW.[HairLossinFamily] = STG.[HairLossInFamily],
            DW.[HairLossFamily] = STG.[HairLossFamily],
			DW.[CreationDate] = STG.[CreationDate],
			DW.[UpdateDate] = STG.[UpdateDate],
			DW.[ContactSessionID] = STG.[ContactSessionid],
			DW.[SFDC_LeadID] = STG.[SFDC_LeadID],
			DW.[SFDC_PersonAccountID] = STG.[SFDC_PersonAccountID],
			DW.[BosleySiebelID] = STG.[BosleySiebelID],
			DW.[DMARegion] = STG.[DMARegion],
			DW.[DMADescription] = STG.[DMADescription],
			DW.[Street] = STG.[Street],
			DW.[City] = STG.[City],
			DW.[State] = STG.[State],
			DW.[StateCode] = STG.[StateCode],
			DW.[Country] = STG.[Country],
			DW.[CountryCode] = STG.[CountryCode],
			DW.[PostalCode] = STG.[PostalCode],
			DW.[GCLID] = STG.[GCLID],
			DW.[LeadSource] = STG.[LeadSource],
			DW.[Phone] = STG.[Phone],
			DW.[MobilePhone] = STG.[MobilePhone],
			DW.[Email] = STG.[Email],
			DW.[SFDC_IsDeleted] = STG.[SFDC_IsDeleted],
			DW.[Accomodation] = STG.[Accomodation],
			DW.[Lead_Activity_Status__c] = STG.[Lead_Activity_Status__c],
            DW.[RowChangeReason] = 'SCD Type 1',
            DW.[UpdateAuditKey] = @DataPkgKey
        FROM [bi_mktg_stage].[DimContact] STG
            JOIN [bi_mktg_stage].[synHC_DDS_DimContact] DW
                ON DW.[SFDC_LeadID] = STG.[SFDC_LeadID]
                   AND DW.[RowIsCurrent] = 1
        WHERE STG.[IsType1] = 1
              AND STG.[IsException] = 0
              AND STG.[DataPkgKey] = @DataPkgKey;

        SET @UpdateSCD1RowCnt = @@ROWCOUNT;



        ------------------------
        -- SCD Type 2
        ------------------------
        -- First Expire the current row
        UPDATE DW
        SET DW.[RowIsCurrent] = 0,
            DW.[RowEndDate] = DATEADD(MINUTE, -1, STG.[ModifiedDate])
        FROM [bi_mktg_stage].[DimContact] STG
            JOIN [bi_mktg_stage].[synHC_DDS_DimContact] DW
                ON DW.[ContactKey] = STG.[ContactKey]
                   AND DW.[RowIsCurrent] = 1
        WHERE STG.[IsType2] = 1
              AND STG.[IsException] = 0
              AND STG.[DataPkgKey] = @DataPkgKey;

        SET @UpdateSCD2RowCnt = @@ROWCOUNT;

        --Next insert the record with the current values
        INSERT INTO [bi_mktg_stage].[synHC_DDS_DimContact]
        (
            [ContactSSID],
            [ContactFirstName],
            [ContactMiddleName],
            [ContactLastName],
            [ContactSuffix],
            [Salutation],
            [ContactStatusSSID],
            [ContactStatusDescription],
            [ContactMethodSSID],
            [ContactMethodDescription],
            [DoNotSolicitFlag],
            [DoNotCallFlag],
            [DoNotEmailFlag],
            [DoNotMailFlag],
            [DoNotTextFlag],
            [ContactGender],
            [ContactCallTime],
            [CompleteSale],
            [ContactResearch],
            [ReferringStore],
            [ReferringStylist],
            [ContactLanguageSSID],
            [ContactLanguageDescription],
            [ContactPromotonSSID],
            [ContactPromotionDescription],
            [ContactRequestSSID],
            [ContactRequestDescription],
            [ContactAgeRangeSSID],
            [ContactAgeRangeDescription],
            [ContactHairLossSSID],
            [ContactHairLossDescription],
            [DNCFlag],
            [DNCDate],
            [ContactAffiliateID],
            [ContactCenterSSID],
            [ContactCenter],
            [ContactAlternateCenter],
            [HairLossTreatment],
            [HairLossSpot],
            [HairLossExperience],
            [HairLossinFamily],
            [HairLossFamily],
			[CreationDate],
			[UpdateDate],
			[ContactSessionID],
			[SFDC_LeadID],
			[SFDC_PersonAccountID],
			[BosleySiebelID],
			[DMARegion],
			[DMADescription],
			[Street],
			[City],
			[State],
			[StateCode],
			[Country],
			[CountryCode],
			[PostalCode],
			[GCLID],
			[LeadSource],
			[Phone],
			[MobilePhone],
			[Email],
			[SFDC_IsDeleted],
			[Accomodation],
			[Lead_Activity_Status__c],
            [RowIsCurrent],
            [RowStartDate],
            [RowEndDate],
            [RowChangeReason],
            [RowIsInferred],
            [InsertAuditKey],
            [UpdateAuditKey]
        )
        SELECT STG.[ContactSSID],
               STG.[ContactFirstName],
               STG.[ContactMiddleName],
               STG.[ContactLastName],
               STG.[ContactSuffix],
               STG.[Salutation],
               STG.[ContactStatusSSID],
               STG.[ContactStatusDescription],
               STG.[ContactMethodSSID],
               STG.[ContactMethodDescription],
               STG.[DoNotSolicitFlag],
               STG.[DoNotCallFlag],
               STG.[DoNotEmailFlag],
               STG.[DoNotMailFlag],
               STG.[DoNotTextFlag],
               STG.[ContactGender],
               STG.[ContactCallTime],
               STG.[CompleteSale],
               STG.[ContactResearch],
               STG.[ReferringStore],
               STG.[ReferringStylist],
               STG.[ContactLanguageSSID],
               STG.[ContactLanguageDescription],
               STG.[ContactPromotonSSID],
               STG.[ContactPromotionDescription],
               STG.[ContactRequestSSID],
               STG.[ContactRequestDescription],
               ISNULL(STG.[ContactAgeRangeSSID], '-2'),
               ISNULL(STG.[ContactAgeRangeDescription], 'Unknown'),
               STG.[ContactHairLossSSID],
               STG.[ContactHairLossDescription],
               STG.[DNCFlag],
               STG.[DNCDate],
               STG.[ContactAffiliateID],
               STG.[ContactCenterSSID],
               STG.[ContactCenter],
               STG.[ContactAlternateCenter],
               STG.[HairLossTreatment],
               STG.[HairLossSpot],
               STG.[HairLossExperience],
               STG.[HairLossInFamily],
               STG.[HairLossFamily],
				STG.[CreationDate],
				STG.[UpdateDate],
				STG.[ContactSessionID],
				STG.[SFDC_LeadID],
				STG.[SFDC_PersonAccountID],
				STG.[BosleySiebelID],
				STG.[DMARegion],
				STG.[DMADescription],
				STG.[Street],
				STG.[City],
				STG.[State],
				STG.[StateCode],
				STG.[Country],
				STG.[CountryCode],
				STG.[PostalCode],
				STG.[GCLID],
				STG.[LeadSource],
				STG.[Phone],
				STG.[MobilePhone],
				STG.[Email],
				STG.[SFDC_IsDeleted],
				STG.[Accomodation],
				STG.[Lead_Activity_Status__c],
               1,                                       -- [RowIsCurrent]
               STG.[ModifiedDate],                      -- [RowStartDate]
               CAST('9999-12-31 00:00:00' AS DATETIME), -- [RowEndDate]
               'SCD Type 2',                            -- [RowChangeReason]
               0,
               @DataPkgKey,
               -2                                       -- 'Not Updated Yet'
        FROM [bi_mktg_stage].[DimContact] STG
        WHERE STG.[IsType2] = 1
              AND STG.[IsException] = 0
              AND STG.[DataPkgKey] = @DataPkgKey;


        SET @InsertSCD2RowCnt = @@ROWCOUNT;


        -- Determine the number of exception rows
        SELECT @ExceptionRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[DimContact] STG
        WHERE STG.[IsException] = 1
              AND STG.[DataPkgKey] = @DataPkgKey;

        -- Determine the number of inserted and updated rows
        SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt;
        SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt;

        -- Determine the number of ignored rows
        SELECT @IgnoreRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[DimContact] STG
        WHERE STG.[DataPkgKey] = @DataPkgKey
              AND
              (
                  (
                      STG.[IsException] = 0
                      AND STG.[IsNew] = 0
                      AND STG.[IsType1] = 0
                      AND STG.[IsType2] = 0
                  )
                  OR STG.[IsDuplicate] = 1
              );



        -- Determine Final Row Cnt
        SELECT @FinalRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[synHC_DDS_DimContact];

        -- Determine the number of Fixed rows
        SELECT @FixedRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[DimContact] STG
        WHERE STG.[DataPkgKey] = @DataPkgKey
              AND STG.[IsFixed] = 1;

        -- Determine the number of Allowed rows
        SELECT @AllowedRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[DimContact] STG
        WHERE STG.[DataPkgKey] = @DataPkgKey
              AND STG.[IsAllowed] = 1;

        -- Determine the number of Rejected rows
        SELECT @RejectedRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[DimContact] STG
        WHERE STG.[DataPkgKey] = @DataPkgKey
              AND STG.[IsRejected] = 1;

        -- Determine the number of Healthy rows
        SELECT @HealthyRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[DimContact] STG
        WHERE STG.[DataPkgKey] = @DataPkgKey
              AND STG.[IsRejected] = 0
              AND STG.[IsAllowed] = 0
              AND STG.[IsFixed] = 0;

        -- Determine the number of Duplicate rows
        SELECT @DuplicateRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[DimContact] STG
        WHERE STG.[DataPkgKey] = @DataPkgKey
              AND STG.[IsDuplicate] = 1;

        -- Determine the number of Deleted rows
        SELECT @DeletedRowCnt = COUNT(1)
        FROM [bi_mktg_stage].[DimContact] STG
        WHERE STG.[DataPkgKey] = @DataPkgKey
              AND STG.[IsDelete] = 1;


        -- Included deleted orphaned rows
        SET @DeletedRowCnt = @DeletedRowCnt + @OrphanedRowCnt;

        -----------------------
        -- Flag records as validated
        -----------------------
        UPDATE STG
        SET IsLoaded = 1
        FROM [bi_mktg_stage].[DimContact] STG
        WHERE DataPkgKey = @DataPkgKey;

        -- Data pkg auditing
        EXEC @return_value = [bief_stage].[sp_META_AuditDataPkgDetail_LoadStop] @DataPkgKey,
                                                                                @TableName,
                                                                                @IgnoreRowCnt,
                                                                                @InsertRowCnt,
                                                                                @UpdateRowCnt,
                                                                                @ExceptionRowCnt,
                                                                                @ExtractRowCnt,
                                                                                @InsertNewRowCnt,
                                                                                @InsertInferredRowCnt,
                                                                                @InsertSCD2RowCnt,
                                                                                @UpdateInferredRowCnt,
                                                                                @UpdateSCD1RowCnt,
                                                                                @UpdateSCD2RowCnt,
                                                                                @InitialRowCnt,
                                                                                @FinalRowCnt,
                                                                                @DeletedRowCnt,
                                                                                @DuplicateRowCnt,
                                                                                @HealthyRowCnt,
                                                                                @RejectedRowCnt,
                                                                                @AllowedRowCnt,
                                                                                @FixedRowCnt;

        -- Cleanup
        -- Reset SET NOCOUNT to OFF.
        SET NOCOUNT OFF;

        -- Cleanup temp tables

        -- Return success
        RETURN 0;
    END TRY
    BEGIN CATCH
        -- Save original error number
        SET @intError = ERROR_NUMBER();

        -- Log the error
        EXECUTE [bief_stage].[_DBErrorLog_LogError] @DBErrorLogID = @intDBErrorLogID OUTPUT,
                                                    @tagValueList = @vchTagValueList;

        -- Re Raise the error
        EXECUTE [bief_stage].[_DBErrorLog_RethrowError] @vchTagValueList;

        -- Cleanup
        -- Reset SET NOCOUNT to OFF.
        SET NOCOUNT OFF;
        -- Cleanup temp tables

        -- Return the error number
        RETURN @intError;
    END CATCH;


END;
GO
