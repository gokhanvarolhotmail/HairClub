/* CreateDate: 05/03/2010 12:26:42.710 , ModifyDate: 03/22/2021 10:54:12.060 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimContact_Transform_SetIsNewSCD]
       (
			  @DataPkgKey				int
       )

AS
-------------------------------------------------------------------------
-- [spHC_DimContact_Transform_SetIsNewSCD] is used to determine which records
--  are NEW, which records are SCD Type 1 or Type 2.
--
--
-- EXEC [spHC_DimContact_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009               Initial Creation
--			11/201/2017				 Added SFDC_LeadID
--			04/13/2018  KMurdoch	 Added SiebelID
--			08/06/2019  KMurdoch     Modified SFDC Lead to be primary
--			07/14/2020  KMurdoch     Added DMA Region & Description
--			07/23/2020  KMurdoch     Added Address information
--			08/20/2020  KMurdoch     Added GCLID to DimContact
--			09/10/2020  KMurdoch     added SFDC_PersonAccountID
--			10/26/2020  KMurdoch     Added SFDC_IsDeleted Flag
--			11/24/2020  KMurdoch     Added LeadSource
--			12/30/2020  KMurdoch     Added Accomodation
--			02/09/2021	KMurdoch     Added Phone, MobilePhone, & Email
--			03/22/2021  KMurdoch     Added Lead_Activity_Status__c
-------------------------------------------------------------------------
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
	SET NOCOUNT ON;



  	DECLARE		      @intError			int				-- error code
  					, @intDBErrorLogID	int				-- ID of error record logged
  					, @intRowCount		int				-- count of rows modified
  					, @vchTagValueList	nvarchar(1000)	-- Named Valued Pairs of Parameters
  	 				, @return_value		int

    DECLARE		      @TableName		varchar(150)	-- Name of table
				    , @CleanupRowCnt	int

  	SET @TableName = N'[bi_mktg_dds].[DimContact]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

   BEGIN TRY


		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [ContactKey] = DW.[ContactKey]
			,IsNew = CASE WHEN DW.[ContactKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimContact] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimContact] DW ON
			DW.[SFDC_LeadID] = STG.[SFDC_LeadID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[ContactKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimContact] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimContact] DW ON
			DW.[SFDC_LeadID] = STG.[SFDC_LeadID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey




		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[ContactKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimContact] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimContact] DW ON
			DW.[SFDC_LeadID] = STG.[SFDC_LeadID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.[ContactFirstName],'') <> COALESCE(DW.[ContactFirstName],'')
				OR COALESCE(STG.[ContactMiddleName],'') <> COALESCE(DW.[ContactMiddleName],'')
				OR COALESCE(STG.[ContactLastName],'') <> COALESCE(DW.[ContactLastName],'')
				OR COALESCE(STG.[ContactSuffix],'') <> COALESCE(DW.[ContactSuffix],'')
				OR COALESCE(STG.[Salutation],'') <> COALESCE(DW.[Salutation],'')
				OR COALESCE(STG.[ContactStatusSSID],'') <> COALESCE(DW.[ContactStatusSSID],'')
				OR COALESCE(STG.[ContactStatusDescription],'') <> COALESCE(DW.[ContactStatusDescription],'')
				OR COALESCE(STG.[ContactMethodSSID],'') <> COALESCE(DW.[ContactMethodSSID],'')
				OR COALESCE(STG.[ContactMethodDescription],'') <> COALESCE(DW.[ContactMethodDescription],'')
				OR COALESCE(STG.[DoNotSolicitFlag],'') <> COALESCE(DW.[DoNotSolicitFlag],'')
				OR COALESCE(STG.[DoNotCallFlag],'') <> COALESCE(DW.[DoNotCallFlag],'')
				OR COALESCE(STG.[DoNotEmailFlag],'') <> COALESCE(DW.[DoNotEmailFlag],'')
				OR COALESCE(STG.[DoNotTextFlag],'') <> COALESCE(DW.[DoNotTextFlag],'')
				OR COALESCE(STG.[ContactGender],'') <> COALESCE(DW.[ContactGender],'')
				OR COALESCE(STG.[ContactCallTime],'') <> COALESCE(DW.[ContactCallTime],'')
				OR COALESCE(STG.[CompleteSale],'') <> COALESCE(DW.[CompleteSale],'')
				OR COALESCE(STG.[ContactResearch],'') <> COALESCE(DW.[ContactResearch],'')
				OR COALESCE(STG.[ReferringStore],'') <> COALESCE(DW.[ReferringStore],'')
				OR COALESCE(STG.[ContactLanguageSSID],'') <> COALESCE(DW.[ContactLanguageSSID],'')
				OR COALESCE(STG.[ContactLanguageDescription],'') <> COALESCE(DW.[ContactLanguageDescription],'')
				OR COALESCE(STG.[ContactPromotonSSID],'') <> COALESCE(DW.[ContactPromotonSSID],'')
				OR COALESCE(STG.[ContactPromotionDescription],'') <> COALESCE(DW.[ContactPromotionDescription],'')
				OR COALESCE(STG.[ContactRequestSSID],'') <> COALESCE(DW.[ContactRequestSSID],'')
				OR COALESCE(STG.[ContactRequestDescription],'') <> COALESCE(DW.[ContactRequestDescription],'')
				OR COALESCE(STG.[ContactAgeRangeSSID],'') <> COALESCE(DW.[ContactAgeRangeSSID],'')
				OR COALESCE(STG.[ContactAgeRangeDescription],'') <> COALESCE(DW.[ContactAgeRangeDescription],'')
				OR COALESCE(STG.[ContactHairLossSSID],'') <> COALESCE(DW.[ContactHairLossSSID],'')
				OR COALESCE(STG.[ContactHairLossDescription],'') <> COALESCE(DW.[ContactHairLossDescription],'')
				OR COALESCE(STG.[SFDC_LeadID],'') <> COALESCE(DW.[SFDC_LeadID],'')
				OR COALESCE(STG.[SFDC_PersonAccountID],'') <> COALESCE(DW.[SFDC_PersonAccountID],'')
				OR COALESCE(STG.[BosleySiebelID],'') <> COALESCE(DW.[BosleySiebelID],'')
				OR COALESCE(STG.[DNCFlag],'') <> COALESCE(DW.[DNCFlag],'')
				OR COALESCE(STG.[DNCDate],'') <> COALESCE(DW.[DNCDate],'')
				OR COALESCE(STG.[ContactAffiliateID],'') <> COALESCE(DW.[ContactAffiliateID],'')
				OR COALESCE(STG.[ContactCenterSSID],'') <> COALESCE(DW.[ContactCenterSSID],'')
				OR COALESCE(STG.[ContactCenter],'') <> COALESCE(DW.[ContactCenter],'')
				OR COALESCE(STG.[ContactAlternateCenter],'') <> COALESCE(DW.[ContactAlternateCenter],'')
				OR COALESCE(STG.[DMARegion],'') <> COALESCE(DW.[DMARegion],'')
				OR COALESCE(STG.[DMADescription],'') <> COALESCE(DW.[DMADescription],'')
				OR COALESCE(STG.[Street],'') <> COALESCE(DW.[Street],'')
				OR COALESCE(STG.[City],'') <> COALESCE(DW.[City],'')
				OR COALESCE(STG.[State],'') <> COALESCE(DW.[State],'')
				OR COALESCE(STG.[StateCode],'') <> COALESCE(DW.[StateCode],'')
				OR COALESCE(STG.[Country],'') <> COALESCE(DW.[Country],'')
				OR COALESCE(STG.[CountryCode],'') <> COALESCE(DW.[CountryCode],'')
				OR COALESCE(STG.[PostalCode],'') <> COALESCE(DW.[PostalCode],'')
				OR COALESCE(STG.[GCLID],'') <> COALESCE(DW.[GCLID],'')
				OR COALESCE(STG.[LeadSource],'') <> COALESCE(DW.[LeadSource],'')
				OR COALESCE(STG.[SFDC_IsDeleted],'') <> COALESCE(DW.[SFDC_IsDeleted],'')
				OR COALESCE(STG.[Accomodation],'') <> COALESCE(DW.[Accomodation],'')
				OR COALESCE(STG.[Phone],'') <> COALESCE(DW.[Phone],'')
				OR COALESCE(STG.[MobilePhone],'') <> COALESCE(DW.[MobilePhone],'')
				OR COALESCE(STG.[Email],'') <> COALESCE(DW.[Email],'')
				OR COALESCE(STG.[Lead_Activity_Status__c],'') <> COALESCE(DW.[Lead_Activity_Status__c],'')
				)
		AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[ContactKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimContact] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimContact] DW ON
			DW.[SFDC_LeadID] = STG.[SFDC_LeadID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.[ContactFirstName],'') <> COALESCE(DW.[ContactFirstName],'')
			--	OR COALESCE(STG.[ContactLastName],'') <> COALESCE(DW.[ContactLastName],'')
				--OR COALESCE(STG.[ContactMiddleName],'') <> COALESCE(DW.[ContactMiddleName],'')
				--OR COALESCE(STG.[ContactLastName],'') <> COALESCE(DW.[ContactLastName],'')
				--OR COALESCE(STG.[ContactSuffix],'') <> COALESCE(DW.[ContactSuffix],'')
				--OR COALESCE(STG.[Salutation],'') <> COALESCE(DW.[Salutation],'')
				--OR COALESCE(STG.[ContactStatusSSID],'') <> COALESCE(DW.[ContactStatusSSID],'')
				--OR COALESCE(STG.[ContactStatusDescription],'') <> COALESCE(DW.[ContactStatusDescription],'')
				--OR COALESCE(STG.[ContactMethodSSID],'') <> COALESCE(DW.[ContactMethodSSID],'')
				--OR COALESCE(STG.[ContactMethodDescription],'') <> COALESCE(DW.[ContactMethodDescription],'')
				--OR COALESCE(STG.[DoNotSolicitFlag],'') <> COALESCE(DW.[DoNotSolicitFlag],'')
				--OR COALESCE(STG.[DoNotCallFlag],'') <> COALESCE(DW.[DoNotCallFlag],'')
				--OR COALESCE(STG.[DoNotEmailFlag],'') <> COALESCE(DW.[DoNotEmailFlag],'')
				--OR COALESCE(STG.[DoNotTextFlag],'') <> COALESCE(DW.[DoNotTextFlag],'')
				--OR COALESCE(STG.[ContactGender],'') <> COALESCE(DW.[ContactGender],'')
				--OR COALESCE(STG.[ContactCallTime],'') <> COALESCE(DW.[ContactCallTime],'')
				--OR COALESCE(STG.[CompleteSale],'') <> COALESCE(DW.[CompleteSale],'')
				--OR COALESCE(STG.[ContactResearch],'') <> COALESCE(DW.[ContactResearch],'')
				--OR COALESCE(STG.[ReferringStore],'') <> COALESCE(DW.[ReferringStore],'')
				--OR COALESCE(STG.[ContactLanguageSSID],'') <> COALESCE(DW.[ContactLanguageSSID],'')
				--OR COALESCE(STG.[ContactLanguageDescription],'') <> COALESCE(DW.[ContactLanguageDescription],'')
				--OR COALESCE(STG.[ContactPromotonSSID],'') <> COALESCE(DW.[ContactPromotonSSID],'')
				--OR COALESCE(STG.[ContactPromotionDescription],'') <> COALESCE(DW.[ContactPromotionDescription],'')
				--OR COALESCE(STG.[ContactRequestSSID],'') <> COALESCE(DW.[ContactRequestSSID],'')
				--OR COALESCE(STG.[ContactRequestDescription],'') <> COALESCE(DW.[ContactRequestDescription],'')
				--OR COALESCE(STG.[ContactAgeRangeSSID],'') <> COALESCE(DW.[ContactAgeRangeSSID],'')
				--OR COALESCE(STG.[ContactAgeRangeDescription],'') <> COALESCE(DW.[ContactAgeRangeDescription],'')
				--OR COALESCE(STG.[ContactHairLossSSID],'') <> COALESCE(DW.[ContactHairLossSSID],'')
				--OR COALESCE(STG.[ContactHairLossDescription],'') <> COALESCE(DW.[ContactHairLossDescription],'')
				--OR COALESCE(STG.[DNCFlag],'') <> COALESCE(DW.[DNCFlag],'')
				--OR COALESCE(STG.[DNCDate],'') <> COALESCE(DW.[DNCDate],'')
				--OR COALESCE(STG.[ContactAffiliateID],'') <> COALESCE(DW.[ContactAffiliateID],'')
				--OR COALESCE(STG.[ContactCenterSSID],'') <> COALESCE(DW.[ContactCenterSSID],'')
				--OR COALESCE(STG.[ContactCenter],'') <> COALESCE(DW.[ContactCenter],'')
				--OR COALESCE(STG.[ContactAlternateCenter],'') <> COALESCE(DW.[ContactAlternateCenter],'')
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  STG.SFDC_LeadID AS 'ContactSSID'
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY STG.SFDC_LeadID ORDER BY STG.SFDC_LeadID ) AS RowNum
			   FROM  [bi_mktg_stage].[DimContact] STG
			   WHERE IsNew = 1
			   AND STG.[DataPkgKey] = @DataPkgKey

			)

			UPDATE STG SET
				IsDuplicate = 1
			FROM Duplicates STG
			WHERE   RowNum > 1


		-----------------------
		-- Check for deleted rows
		-----------------------
		UPDATE STG SET
				IsDelete = CASE WHEN COALESCE(STG.[CDC_Operation],'') = 'D'
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimContact] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-- Cleanup
		-- Reset SET NOCOUNT to OFF.
		SET NOCOUNT OFF

		-- Cleanup temp tables

		-- Return success
		RETURN 0

	END TRY

    BEGIN CATCH
		-- Save original error number
		SET @intError = ERROR_NUMBER();


		-- Log the error
		EXECUTE [bief_stage].[_DBErrorLog_LogError]
					  @DBErrorLogID = @intDBErrorLogID OUTPUT
					, @tagValueList = @vchTagValueList;

		-- Re Raise the error
		EXECUTE [bief_stage].[_DBErrorLog_RethrowError] @vchTagValueList;

		-- Cleanup
		-- Reset SET NOCOUNT to OFF.
		SET NOCOUNT OFF
		-- Cleanup temp tables

		-- Return the error number
		RETURN @intError;
    END CATCH


END
GO
