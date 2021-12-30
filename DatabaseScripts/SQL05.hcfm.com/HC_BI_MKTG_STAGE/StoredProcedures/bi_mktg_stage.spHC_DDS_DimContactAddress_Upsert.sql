/* CreateDate: 05/03/2010 12:26:23.413 , ModifyDate: 02/09/2021 14:30:35.020 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DDS_DimContactAddress_Upsert]
			   @DataPkgKey					int
			 , @IgnoreRowCnt				bigint output
			 , @InsertRowCnt				bigint output
			 , @UpdateRowCnt				bigint output
			 , @ExceptionRowCnt				bigint output
			 , @ExtractRowCnt				bigint output
			 , @InsertNewRowCnt				bigint output
			 , @InsertInferredRowCnt		bigint output
			 , @InsertSCD2RowCnt			bigint output
			 , @UpdateInferredRowCnt		bigint output
			 , @UpdateSCD1RowCnt			bigint output
			 , @UpdateSCD2RowCnt			bigint output
			 , @InitialRowCnt				bigint output
			 , @FinalRowCnt					bigint output

AS
-------------------------------------------------------------------------
-- [spHC_DDS_DimContactAddress_Upsert] is used to update
-- SCD Type 1 records, update SCD Type 2 records and insert
-- New records
--
--
--   exec [bi_mktg_stage].[spHC_DDS_DimContactAddress_Upsert] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/23/2009  RLifke       Initial Creation
--			11/21/2017	KMurdoch	 Added SFDC_Lead/LeadAddress_ID
--			09/10/2020  KMurdoch     Added SFDC_PersonAccountID
--			09/14/2020  KMurdoch     Removed references to OnContact
--			09/15/2020  KMurdoch     Fixed delete for duplicate records.
--			09/17/2020  KMurdoch     Reverted code back for delete where 'not in'
--			02/09/2021  KMurdoch     Added check for Null on SFDC_LeadAddressID to  "Not In" logic
-------------------------------------------------------------------------
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DECLARE		  @intError			int				-- error code
				, @intDBErrorLogID	int				-- ID of error record logged
				, @intRowCount		int				-- count of rows modified
				, @vchTagValueList	nvarchar(1000)	-- Named Valued Pairs of Parameters
				, @return_value		int

	DECLARE		  @TableName			varchar(150)	-- Name of table

	DECLARE		  @DeletedRowCnt		bigint
				, @DuplicateRowCnt		bigint
				, @HealthyRowCnt		bigint
				, @RejectedRowCnt		bigint
				, @AllowedRowCnt		bigint
				, @FixedRowCnt			bigint
				, @OrphanedRowCnt		bigint

 	SET @TableName = N'[bi_mktg_dds].[DimContactAddress]'

	BEGIN TRY

		SET @IgnoreRowCnt = 0
		SET @InsertRowCnt = 0
		SET @UpdateRowCnt = 0
		SET @ExceptionRowCnt = 0
		SET @ExtractRowCnt = 0
		SET @InsertNewRowCnt = 0
		SET @InsertInferredRowCnt = 0
		SET @InsertSCD2RowCnt = 0
		SET @UpdateInferredRowCnt = 0
		SET @UpdateSCD1RowCnt = 0
		SET @UpdateSCD2RowCnt = 0
		SET @InitialRowCnt = 0
		SET @FinalRowCnt = 0
		SET @DeletedRowCnt = 0
		SET @DuplicateRowCnt = 0
		SET @HealthyRowCnt = 0
		SET @RejectedRowCnt = 0
		SET @AllowedRowCnt = 0
		SET @FixedRowCnt = 0
		SET @OrphanedRowCnt = 0


		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_LoadStart] @DataPkgKey, @TableName

		-- Determine Initial Row Cnt
		SELECT @InitialRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_DimContactAddress]

		-- Determine the number of extracted rows
		SELECT @ExtractRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[DimContactAddress] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey

		------------------------
		-- Deleted Records
		------------------------
		DELETE
		FROM [bi_mktg_stage].[synHC_DDS_DimContactAddress]
		WHERE [SFDC_LeadAddressID] IN ( SELECT STG.[SFDC_LeadAddressID]
										FROM [bi_mktg_stage].[DimContactAddress] STG
										WHERE	STG.[IsDelete] = 1
											AND STG.[DataPkgKey] = @DataPkgKey
									)


		------------------------
		-- Deleted Records
		------------------------
		--DELETE dca
		--FROM [bi_mktg_stage].[synHC_DDS_DimContactAddress] dca
		--	INNER JOIN HC_BI_SFDC.dbo.Address__c address__c
		--		ON dca.SFDC_LeadAddressID = address__c.id
		--WHERE dca.[ContactAddressKey] <> -1

		DELETE

		FROM [bi_mktg_stage].[synHC_DDS_DimContactAddress]
		WHERE [SFDC_LeadAddressID] IS NOT NULL AND ([SFDC_LeadAddressID] NOT
		IN (
				SELECT SRC.Id
				FROM HC_BI_SFDC.dbo.Address__c SRC WITH (NOLOCK)
				)
		AND ContactAddressKey <> -1)

		SET @OrphanedRowCnt = @@ROWCOUNT

		------------------------
		-- New Records
		------------------------
		INSERT INTO [bi_mktg_stage].[synHC_DDS_DimContactAddress] (
				      [ContactAddressSSID]
				    , [ContactSSID]
				    , [AddressTypeCode]
				    , [AddressLine1]
				    , [AddressLine2]
				    , [AddressLine3]
				    , [AddressLine4]
				    , [AddressLine1Soundex]
				    , [AddressLine2Soundex]
				    , [City]
				    , [CitySoundex]
				    , [StateCode]
				    , [StateName]
				    , [ZipCode]
				    , [CountyCode]
				    , [CountyName]
				    , [CountryCode]
				    , [CountryName]
				    , [CountryPrefix]
				    , [TimeZoneCode]
				    , [PrimaryFlag]
					, [SFDC_LeadID]
					, [SFDC_PersonAccountID]
					, [SFDC_LeadAddressID]
					, [RowIsCurrent]
					, [RowStartDate]
					, [RowEndDate]
					, [RowChangeReason]
					, [RowIsInferred]
					, [InsertAuditKey]
					, [UpdateAuditKey]
					)
			SELECT
  					  STG.[ContactAddressSSID]
				    , STG.[ContactSSID]
				    , STG.[AddressTypeCode]
				    , STG.[AddressLine1]
				    , STG.[AddressLine2]
				    , STG.[AddressLine3]
				    , STG.[AddressLine4]
				    , STG.[AddressLine1Soundex]
				    , STG.[AddressLine2Soundex]
				    , STG.[City]
				    , STG.[CitySoundex]
				    , STG.[StateCode]
				    , STG.[StateName]
				    , STG.[ZipCode]
				    , STG.[CountyCode]
				    , STG.[CountyName]
				    , STG.[CountryCode]
				    , STG.[CountryName]
				    , STG.[CountryPrefix]
				    , STG.[TimeZoneCode]
				    , STG.[PrimaryFlag]
					, STG.[SFDC_LeadID]
					, STG.[SFDC_PersonAccountID]
					, STG.[SFDC_LeadAddressID]
					, 1 -- [RowIsCurrent]
					, CAST('1753-01-01 00:00:00' AS DateTime) -- [RowStartDate]
					, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
					, 'New Record' -- [RowChangeReason]
					, 0
					, @DataPkgKey
					, -2 -- 'Not Updated Yet'
			FROM [bi_mktg_stage].[DimContactAddress] STG
			WHERE	STG.[IsNew] = 1
				AND	STG.[IsException] = 0
				AND STG.[IsDuplicate] = 0
				AND STG.[DataPkgKey] = @DataPkgKey

		SET @InsertNewRowCnt = @@ROWCOUNT


		------------------------
		-- Inferred Members
		------------------------
		-- Just update the record
		UPDATE DW SET
				  DW.[ContactSSID] = STG.[ContactSSID]
				, DW.[AddressTypeCode] = STG.[AddressTypeCode]
				, DW.[AddressLine1] = STG.[AddressLine1]
				, DW.[AddressLine2] = STG.[AddressLine2]
				, DW.[AddressLine3] = STG.[AddressLine3]
				, DW.[AddressLine4] = STG.[AddressLine4]
				, DW.[AddressLine1Soundex] = STG.[AddressLine1Soundex]
				, DW.[AddressLine2Soundex] = STG.[AddressLine2Soundex]
				, DW.[City] = STG.[City]
				, DW.[CitySoundex] = STG.[CitySoundex]
				, DW.[StateCode] = STG.[StateCode]
				, DW.[StateName] = STG.[StateName]
				, DW.[ZipCode] = STG.[ZipCode]
				, DW.[CountyCode] = STG.[CountyCode]
				, DW.[CountyName] = STG.[CountyName]
				, DW.[CountryCode] = STG.[CountryCode]
				, DW.[CountryName] = STG.[CountryName]
				, DW.[CountryPrefix] = STG.[CountryPrefix]
				, DW.[TimeZoneCode] = STG.[TimeZoneCode]
				, DW.[PrimaryFlag] = STG.[PrimaryFlag]
				, DW.[SFDC_LeadID] = STG.[SFDC_LeadID]
				, DW.[SFDC_PersonAccountID] = STG.[SFDC_PersonAccountID]
				, DW.[SFDC_LeadAddressID] = STG.[SFDC_LeadAddressID]
				, DW.[RowChangeReason] = 'Updated Inferred Member'
				, DW.[RowIsInferred] = 0
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_mktg_stage].[DimContactAddress] STG
		JOIN [bi_mktg_stage].[synHC_DDS_DimContactAddress] DW ON
				DW.[SFDC_LeadAddressID] = STG.[SFDC_LeadAddressID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE	STG.[IsInferredMember] = 1
			AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @UpdateInferredRowCnt = @@ROWCOUNT


		------------------------
		-- SCD Type 1
		------------------------
		-- Just update the record
		UPDATE DW SET
				  DW.[ContactSSID] = STG.[ContactSSID]
				, DW.[AddressTypeCode] = STG.[AddressTypeCode]
				, DW.[AddressLine1] = STG.[AddressLine1]
				, DW.[AddressLine2] = STG.[AddressLine2]
				, DW.[AddressLine3] = STG.[AddressLine3]
				, DW.[AddressLine4] = STG.[AddressLine4]
				, DW.[AddressLine1Soundex] = STG.[AddressLine1Soundex]
				, DW.[AddressLine2Soundex] = STG.[AddressLine2Soundex]
				, DW.[City] = STG.[City]
				, DW.[CitySoundex] = STG.[CitySoundex]
				, DW.[StateCode] = STG.[StateCode]
				, DW.[StateName] = STG.[StateName]
				, DW.[ZipCode] = STG.[ZipCode]
				, DW.[CountyCode] = STG.[CountyCode]
				, DW.[CountyName] = STG.[CountyName]
				, DW.[CountryCode] = STG.[CountryCode]
				, DW.[CountryName] = STG.[CountryName]
				, DW.[CountryPrefix] = STG.[CountryPrefix]
				, DW.[TimeZoneCode] = STG.[TimeZoneCode]
				, DW.[PrimaryFlag] = STG.[PrimaryFlag]
				, DW.[SFDC_LeadID] = STG.[SFDC_LeadID]
				, DW.[SFDC_PersonAccountID] = STG.[SFDC_PersonAccountID]
				, DW.[SFDC_LeadAddressID] = STG.[SFDC_LeadAddressID]
				, DW.[RowChangeReason] = 'SCD Type 1'
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_mktg_stage].[DimContactAddress] STG
		JOIN [bi_mktg_stage].[synHC_DDS_DimContactAddress] DW ON
				DW.[SFDC_LeadAddressID] = STG.[SFDC_LeadAddressID]
			AND DW.[RowIsCurrent] = 1
		WHERE	STG.[IsType1] = 1
			AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @UpdateSCD1RowCnt = @@ROWCOUNT



		------------------------
		-- SCD Type 2
		------------------------
		-- First Expire the current row
		UPDATE DW SET
				  DW.[RowIsCurrent] = 0
				, DW.[RowEndDate] = DATEADD(minute, -1, STG.[ModifiedDate])
		FROM [bi_mktg_stage].[DimContactAddress] STG
		JOIN [bi_mktg_stage].[synHC_DDS_DimContactAddress] DW ON
				DW.[ContactAddressKey] = STG.[ContactAddressKey]
			AND DW.[RowIsCurrent] = 1
		WHERE	STG.[IsType2] = 1
			AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @UpdateSCD2RowCnt = @@ROWCOUNT

		--Next insert the record with the current values
		INSERT INTO [bi_mktg_stage].[synHC_DDS_DimContactAddress] (
				      [ContactAddressSSID]
				    , [ContactSSID]
				    , [AddressTypeCode]
				    , [AddressLine1]
				    , [AddressLine2]
				    , [AddressLine3]
				    , [AddressLine4]
				    , [AddressLine1Soundex]
				    , [AddressLine2Soundex]
				    , [City]
				    , [CitySoundex]
				    , [StateCode]
				    , [StateName]
				    , [ZipCode]
				    , [CountyCode]
				    , [CountyName]
				    , [CountryCode]
				    , [CountryName]
				    , [TimeZoneCode]
				    , [PrimaryFlag]
					, [SFDC_LeadID]
					, [SFDC_PersonAccountID]
					, [SFDC_LeadAddressID]
					, [RowIsCurrent]
					, [RowStartDate]
					, [RowEndDate]
					, [RowChangeReason]
					, [RowIsInferred]
					, [InsertAuditKey]
					, [UpdateAuditKey]
					)
			SELECT
  					  STG.[ContactAddressSSID]
				    , STG.[ContactSSID]
				    , STG.[AddressTypeCode]
				    , STG.[AddressLine1]
				    , STG.[AddressLine2]
				    , STG.[AddressLine3]
				    , STG.[AddressLine4]
				    , STG.[AddressLine1Soundex]
				    , STG.[AddressLine2Soundex]
				    , STG.[City]
				    , STG.[CitySoundex]
				    , STG.[StateCode]
				    , STG.[StateName]
				    , STG.[ZipCode]
				    , STG.[CountyCode]
				    , STG.[CountyName]
				    , STG.[CountryCode]
				    , STG.[CountryName]
				    , STG.[TimeZoneCode]
				    , STG.[PrimaryFlag]
					, STG.[SFDC_LeadID]
					, STG.[SFDC_PersonAccountID]
					, STG.[SFDC_LeadAddressID]
					, 1 -- [RowIsCurrent]
					, STG.[ModifiedDate] -- [RowStartDate]
					, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
					, 'SCD Type 2' -- [RowChangeReason]
					, 0
					, @DataPkgKey
					, -2 -- 'Not Updated Yet'
			FROM [bi_mktg_stage].[DimContactAddress] STG
			WHERE	STG.[IsType2] = 1
				AND	STG.[IsException] = 0
				AND STG.[DataPkgKey] = @DataPkgKey


		SET @InsertSCD2RowCnt = @@ROWCOUNT


		-- Determine the number of exception rows
		SELECT @ExceptionRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[DimContactAddress] STG
		WHERE STG.[IsException] = 1
			AND STG.[DataPkgKey] = @DataPkgKey

		-- Determine the number of inserted and updated rows
		SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt

		-- Determine the number of ignored rows
		SELECT @IgnoreRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[DimContactAddress] STG
		WHERE STG.[IsException] = 0
		AND STG.[IsNew] = 0
		AND STG.[IsType1] = 0
		AND STG.[IsType2] = 0
		OR STG.[IsDuplicate] = 1
		AND STG.[DataPkgKey] = @DataPkgKey


		-- Determine Final Row Cnt
		SELECT @FinalRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_DimContactAddress]

		-- Determine the number of Fixed rows
		SELECT @FixedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[DimContactAddress] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsFixed] = 1

		-- Determine the number of Allowed rows
		SELECT @AllowedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[DimContactAddress] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsAllowed] = 1

		-- Determine the number of Rejected rows
		SELECT @RejectedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[DimContactAddress] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 1

		-- Determine the number of Healthy rows
		SELECT @HealthyRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[DimContactAddress] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 0
		AND STG.[IsAllowed] = 0
		AND STG.[IsFixed] = 0

		-- Determine the number of Duplicate rows
		SELECT @DuplicateRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[DimContactAddress] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDuplicate] = 1

		-- Determine the number of Deleted rows
		SELECT @DeletedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[DimContactAddress] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDelete] = 1

		-- Included deleted orphaned rows
		SET @DeletedRowCnt = @DeletedRowCnt + @OrphanedRowCnt

		-----------------------
		-- Flag records as validated
		-----------------------
		UPDATE STG SET
			IsLoaded = 1
		FROM [bi_mktg_stage].[DimContactAddress] STG
		WHERE DataPkgKey = @DataPkgKey

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_LoadStop] @DataPkgKey, @TableName
					, @IgnoreRowCnt, @InsertRowCnt, @UpdateRowCnt, @ExceptionRowCnt, @ExtractRowCnt
					, @InsertNewRowCnt, @InsertInferredRowCnt, @InsertSCD2RowCnt
					, @UpdateInferredRowCnt, @UpdateSCD1RowCnt, @UpdateSCD2RowCnt
					, @InitialRowCnt, @FinalRowCnt
					, @DeletedRowCnt, @DuplicateRowCnt, @HealthyRowCnt
					, @RejectedRowCnt, @AllowedRowCnt, @FixedRowCnt

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
