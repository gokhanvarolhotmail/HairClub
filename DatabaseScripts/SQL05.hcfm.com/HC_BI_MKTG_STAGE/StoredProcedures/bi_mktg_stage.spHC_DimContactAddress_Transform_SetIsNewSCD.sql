/* CreateDate: 05/03/2010 12:26:34.197 , ModifyDate: 09/14/2020 15:22:22.967 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimContactAddress_Transform_SetIsNewSCD]
       (
			  @DataPkgKey				int
       )

AS
-------------------------------------------------------------------------
-- [spHC_DimContactAddress_Transform_SetIsNewSCD] is used to determine which records
--  are NEW, which records are SCD Type 1 or Type 2.
--
--
-- EXEC [spHC_DimContactAddress_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009               Initial Creation
--			11/27/2017	KMurdoch     Added SFDC_Lead/LeadAddress_ID
--			09/14/2020  KMurdoch     Remoed references to OnContact
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

  	SET @TableName = N'[bi_mktg_dds].[DimContactAddress]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

   BEGIN TRY


		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [ContactAddressKey] = DW.[ContactAddressKey]
			,IsNew = CASE WHEN DW.[ContactAddressKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimContactAddress] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimContactAddress] DW ON
				DW.[SFDC_LeadAddressID] = STG.[SFDC_LeadAddressID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[ContactAddressKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimContactAddress] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimContactAddress] DW ON
				 STG.[SFDC_LeadAddressID] = DW.[SFDC_LeadAddressID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey




		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[ContactAddressKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimContactAddress] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimContactAddress] DW ON
				 STG.[SFDC_LeadAddressID] = DW.[SFDC_LeadAddressID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND (COALESCE(STG.[ContactSSID],'') <> COALESCE(DW.[ContactSSID],'')
			 OR  COALESCE(STG.[AddressTypeCode],'') <> COALESCE(DW.[AddressTypeCode],'')
			 OR  COALESCE(STG.[AddressLine1],'') <> COALESCE(DW.[AddressLine1],'')
			 OR  COALESCE(STG.[AddressLine2],'') <> COALESCE(DW.[AddressLine2],'')
			 OR  COALESCE(STG.[AddressLine3],'') <> COALESCE(DW.[AddressLine3],'')
			 OR  COALESCE(STG.[AddressLine4],'') <> COALESCE(DW.[AddressLine4],'')
			 OR  COALESCE(STG.[AddressLine1Soundex],'') <> COALESCE(DW.[AddressLine1Soundex],'')
			 OR  COALESCE(STG.[AddressLine2Soundex],'') <> COALESCE(DW.[AddressLine2Soundex],'')
			 OR  COALESCE(STG.[City],'') <> COALESCE(DW.[City],'')
			 OR  COALESCE(STG.[CitySoundex],'') <> COALESCE(DW.[CitySoundex],'')
			 OR  COALESCE(STG.[StateCode],'') <> COALESCE(DW.[StateCode],'')
			 OR  COALESCE(STG.[StateName],'') <> COALESCE(DW.[StateName],'')
			 OR  COALESCE(STG.[ZipCode],'') <> COALESCE(DW.[ZipCode],'')
			 OR  COALESCE(STG.[CountyCode],'') <> COALESCE(DW.[CountyCode],'')
			 OR  COALESCE(STG.[CountyName],'') <> COALESCE(DW.[CountyName],'')
			 OR  COALESCE(STG.[CountryCode],'') <> COALESCE(DW.[CountryCode],'')
			 OR  COALESCE(STG.[CountryName],'') <> COALESCE(DW.[CountryName],'')
			 OR  COALESCE(STG.[CountryPrefix],'') <> COALESCE(DW.[CountryPrefix],'')
			 OR  COALESCE(STG.[TimeZoneCode],'') <> COALESCE(DW.[TimeZoneCode],'')
			 OR  COALESCE(STG.[PrimaryFlag],'') <> COALESCE(DW.[PrimaryFlag],'')
			 OR  COALESCE(STG.[SFDC_LeadID],'') <> COALESCE(DW.[SFDC_LeadID],'')
			 OR  COALESCE(STG.[SFDC_LeadAddressID],'') <> COALESCE(DW.[SFDC_LeadAddressID],'')
				)
		AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[ContactAddressKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimContactAddress] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimContactAddress] DW ON
				 STG.[SFDC_LeadAddressID] = DW.[SFDC_LeadAddressID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND (COALESCE(STG.[ContactSSID],'') <> COALESCE(DW.[ContactSSID],'')
			-- OR  COALESCE(STG.[AddressTypeCode],'') <> COALESCE(DW.[AddressTypeCode],'')
			-- OR  COALESCE(STG.[AddressLine1],'') <> COALESCE(DW.[AddressLine1],'')
			-- OR  COALESCE(STG.[AddressLine2],'') <> COALESCE(DW.[AddressLine2],'')
			-- OR  COALESCE(STG.[AddressLine3],'') <> COALESCE(DW.[AddressLine3],'')
			-- OR  COALESCE(STG.[AddressLine4],'') <> COALESCE(DW.[AddressLine4],'')
			-- OR  COALESCE(STG.[AddressLine1Soundex],'') <> COALESCE(DW.[AddressLine1Soundex],'')
			-- OR  COALESCE(STG.[AddressLine2Soundex],'') <> COALESCE(DW.[AddressLine2Soundex],'')
			-- OR  COALESCE(STG.[City],'') <> COALESCE(DW.[City],'')
			-- OR  COALESCE(STG.[CitySoundex],'') <> COALESCE(DW.[CitySoundex],'')
			-- OR  COALESCE(STG.[StateCode],'') <> COALESCE(DW.[StateCode],'')
			-- OR  COALESCE(STG.[StateName],'') <> COALESCE(DW.[StateName],'')
			-- OR  COALESCE(STG.[ZipCode],'') <> COALESCE(DW.[ZipCode],'')
			-- OR  COALESCE(STG.[CountyCode],'') <> COALESCE(DW.[CountyCode],'')
			-- OR  COALESCE(STG.[CountyName],'') <> COALESCE(DW.[CountyName],'')
			-- OR  COALESCE(STG.[CountryCode],'') <> COALESCE(DW.[CountryCode],'')
			-- OR  COALESCE(STG.[CountryName],'') <> COALESCE(DW.[CountryName],'')
			-- OR  COALESCE(STG.[CountryPrefix],'') <> COALESCE(DW.[CountryPrefix],'')
			-- OR  COALESCE(STG.[TimeZoneCode],'') <> COALESCE(DW.[TimeZoneCode],'')
			-- OR  COALESCE(STG.[PrimaryFlag],'') <> COALESCE(DW.[PrimaryFlag],'')
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  ContactAddressSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY ContactAddressSSID ORDER BY ContactAddressSSID ) AS RowNum
			   FROM  [bi_mktg_stage].[DimContactAddress] STG
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
		FROM [bi_mktg_stage].[DimContactAddress] STG
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
