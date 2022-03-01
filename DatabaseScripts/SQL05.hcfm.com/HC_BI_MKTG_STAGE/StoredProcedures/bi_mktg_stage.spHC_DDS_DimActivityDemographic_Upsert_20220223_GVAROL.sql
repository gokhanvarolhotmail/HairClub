/* CreateDate: 02/23/2022 11:55:01.230 , ModifyDate: 02/23/2022 11:55:01.230 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DDS_DimActivityDemographic_Upsert_20220223_GVAROL]
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
-- [spHC_DDS_DimActivityDemographic_Upsert] is used to update
-- SCD Type 1 records, update SCD Type 2 records and insert
-- New records
--
--
--   exec [bi_mktg_stage].[spHC_DDS_DimActivityDemographic_Upsert] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    11/16/2009  RLifke       Initial Creation
--			03/29/2013  KMurdoch	 Added DiscStyleSSID
--			03/29/2013  KMurdoch     Added update of DiscStyleSSID
--			01/31/2017  DLeiba		 Updated query to handle a
--									 NULL value for Birthday & Age
--			11/21/2017  KMurdoch     Added SFDC_Lead/Task_ID
--			08/05/2019  KMurdoch	 Migrated ONC to SFDC
--			08/06/2019  KMurdoch     Made SFDC primary
--			09/10/2020  KMurdoch     Added SFDC_PersonAccountID
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

 	SET @TableName = N'[bi_mktg_dds].[DimActivityDemographic]'

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
		SELECT @InitialRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_DimActivityDemographic]

		-- Determine the number of extracted rows
		SELECT @ExtractRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey

		------------------------
		-- Deleted Records
		------------------------
		DELETE
		FROM [bi_mktg_stage].[synHC_DDS_DimActivityDemographic]
		WHERE [ActivityDemographicSSID] IN ( SELECT STG.[ActivityDemographicSSID]
										FROM [bi_mktg_stage].[DimActivityDemographic] STG
										WHERE	STG.[IsDelete] = 1
											AND STG.[DataPkgKey] = @DataPkgKey
									)


		--------------------------
		---- Deleted Records
		--------------------------
		--DELETE
		--FROM [bi_mktg_stage].[synHC_DDS_DimActivityDemographic]
		--WHERE [ActivityDemographicSSID] NOT
		--IN (
		--		SELECT SRC.[activity_demographic_id]
		--		FROM [bi_mktg_stage].[synHC_SRC_TBL_MKTG_cstd_activity_demographic] SRC WITH (NOLOCK)
		--		)
		--AND [ActivityDemographicKey] <> -1

		--SET @OrphanedRowCnt = @@ROWCOUNT


		------------------------
		-- New Records
		------------------------
		INSERT INTO [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] (
					  [ActivityDemographicSSID]
					, [ActivitySSID]
					, [ContactSSID]
					, [GenderSSID]
					, [GenderDescription]
					, [EthnicitySSID]
					, [EthnicityDescription]
					, [OccupationSSID]
					, [OccupationDescription]
					, [MaritalStatusSSID]
					, [MaritalStatusDescription]
					, [Birthday]
					, [Age]
					, [AgeRangeSSID]
					, [AgeRangeDescription]
					, [HairLossTypeSSID]
					, [HairLossTypeDescription]
					, [NorwoodSSID]
					, [LudwigSSID]
					, [Performer]
					, [PriceQuoted]
					, [SolutionOffered]
					, [NoSaleReason]
					, [DiscStyleSSID]
					, [SFDC_LeadID]
					, [SFDC_TaskID]
					, [SFDC_PersonAccountID]
				    , [DateSaved]
					, [RowIsCurrent]
					, [RowStartDate]
					, [RowEndDate]
					, [RowChangeReason]
					, [RowIsInferred]
					, [InsertAuditKey]
					, [UpdateAuditKey]
					)
			SELECT
				  STG.[ActivityDemographicSSID]
				, STG.[ActivitySSID]
				, STG.[ContactSSID]
				, STG.[GenderSSID]
				, STG.[GenderDescription]
				, STG.[EthnicitySSID]
				, STG.[EthnicityDescription]
				, STG.[OccupationSSID]
				, STG.[OccupationDescription]
				, STG.[MaritalStatusSSID]
				, STG.[MaritalStatusDescription]
				, ISNULL(STG.[Birthday], '1900-01-01')
				, ISNULL(STG.[Age], 0)
				, STG.[AgeRangeSSID]
				, STG.[AgeRangeDescription]
				, STG.[HairLossTypeSSID]
				, STG.[HairLossTypeDescription]
				, STG.[NorwoodSSID]
				, STG.[LudwigSSID]
				, STG.[Performer]
				, STG.[PriceQuoted]
				, STG.[SolutionOffered]
				, STG.[NoSaleReason]
				, STG.[DiscStyleSSID]
				, STG.[SFDC_LeadID]
				, STG.[SFDC_TaskID]
				, STG.[SFDC_PersonAccountID]
				, STG.[DateSaved]
				, 1 -- [RowIsCurrent]
				, CAST('1753-01-01 00:00:00' AS DateTime) -- [RowStartDate]
				, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
				, 'New Record' -- [RowChangeReason]
				, 0
				, @DataPkgKey
				, -2 -- 'Not Updated Yet'
			FROM [bi_mktg_stage].[DimActivityDemographic] STG
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
				 DW.[ActivitySSID] = STG.[ActivitySSID]
				, DW.[ContactSSID] = STG.[ContactSSID]
				, DW.[GenderSSID] = STG.[GenderSSID]
				, DW.[GenderDescription] = STG.[GenderDescription]
				, DW.[EthnicitySSID] = STG.[EthnicitySSID]
				, DW.[EthnicityDescription] = STG.[EthnicityDescription]
				, DW.[OccupationSSID] = STG.[OccupationSSID]
				, DW.[OccupationDescription] = STG.[OccupationDescription]
				, DW.[MaritalStatusSSID] = STG.[MaritalStatusSSID]
				, DW.[MaritalStatusDescription] = STG.[MaritalStatusDescription]
				, DW.[Birthday] = ISNULL(STG.[Birthday], '1900-01-01')
				, DW.[Age] = ISNULL(STG.[Age], 0)
				, DW.[AgeRangeSSID] = STG.[AgeRangeSSID]
				, DW.[AgeRangeDescription] = STG.[AgeRangeDescription]
				, DW.[HairLossTypeSSID] = STG.[HairLossTypeSSID]
				, DW.[HairLossTypeDescription] = STG.[HairLossTypeDescription]
				, DW.[NorwoodSSID] = STG.[NorwoodSSID]
				, DW.[LudwigSSID] = STG.[LudwigSSID]
				, DW.[Performer] = STG.[Performer]
				, DW.[PriceQuoted] = STG.[PriceQuoted]
				, DW.[SolutionOffered] = STG.[SolutionOffered]
				, DW.[NoSaleReason] = STG.[NoSaleReason]
				, DW.[DiscStyleSSID] = STG.[DiscStyleSSID]
				, DW.[SFDC_LeadID] = STG.[SFDC_LeadID]
				, DW.[SFDC_TaskID] = STG.[SFDC_TaskID]
				, DW.[SFDC_PersonAccountID] = STG.[SFDC_PersonAccountID]
				, DW.[DateSaved] = STG.[DateSaved]
				, DW.[RowChangeReason] = 'Updated Inferred Member'
				, DW.[RowIsInferred] = 0
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		JOIN [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] DW
			ON DW.SFDC_TaskID = STG.SFDC_TaskID
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
				 DW.[ActivitySSID] = STG.[ActivitySSID]
				, DW.[ContactSSID] = STG.[ContactSSID]
				, DW.[GenderSSID] = STG.[GenderSSID]
				, DW.[GenderDescription] = STG.[GenderDescription]
				, DW.[EthnicitySSID] = STG.[EthnicitySSID]
				, DW.[EthnicityDescription] = STG.[EthnicityDescription]
				, DW.[OccupationSSID] = STG.[OccupationSSID]
				, DW.[OccupationDescription] = STG.[OccupationDescription]
				, DW.[MaritalStatusSSID] = STG.[MaritalStatusSSID]
				, DW.[MaritalStatusDescription] = STG.[MaritalStatusDescription]
				, DW.[Birthday] = ISNULL(STG.[Birthday], '1900-01-01')
				, DW.[Age] = ISNULL(STG.[Age], 0)
				, DW.[AgeRangeSSID] = STG.[AgeRangeSSID]
				, DW.[AgeRangeDescription] = STG.[AgeRangeDescription]
				, DW.[HairLossTypeSSID] = STG.[HairLossTypeSSID]
				, DW.[HairLossTypeDescription] = STG.[HairLossTypeDescription]
				, DW.[NorwoodSSID] = STG.[NorwoodSSID]
				, DW.[LudwigSSID] = STG.[LudwigSSID]
				, DW.[Performer] = STG.[Performer]
				, DW.[PriceQuoted] = STG.[PriceQuoted]
				, DW.[SolutionOffered] = STG.[SolutionOffered]
				, DW.[NoSaleReason] = STG.[NoSaleReason]
				, DW.[DiscStyleSSID] = STG.[DiscStyleSSID]
				, DW.[SFDC_LeadID] = STG.[SFDC_LeadID]
				, DW.[SFDC_TaskID] = STG.[SFDC_TaskID]
				, DW.[SFDC_PersonAccountID] = STG.[SFDC_PersonAccountID]
				, DW.[DateSaved] = STG.[DateSaved]
				, DW.[RowChangeReason] = 'SCD Type 1'
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		JOIN [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] DW
			ON DW.SFDC_TaskID = STG.SFDC_TaskID
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
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		JOIN [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] DW ON
				DW.[ActivityDemographicKey] = STG.[ActivityDemographicKey]
			AND DW.[RowIsCurrent] = 1
		WHERE	STG.[IsType2] = 1
			AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @UpdateSCD2RowCnt = @@ROWCOUNT

		--Next insert the record with the current values
		INSERT INTO [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] (
					  [ActivityDemographicSSID]
					, [ActivitySSID]
					, [ContactSSID]
					, [GenderSSID]
					, [GenderDescription]
					, [EthnicitySSID]
					, [EthnicityDescription]
					, [OccupationSSID]
					, [OccupationDescription]
					, [MaritalStatusSSID]
					, [MaritalStatusDescription]
					, [Birthday]
					, [Age]
					, [AgeRangeSSID]
					, [AgeRangeDescription]
					, [HairLossTypeSSID]
					, [HairLossTypeDescription]
					, [NorwoodSSID]
					, [LudwigSSID]
					, [Performer]
					, [PriceQuoted]
					, [SolutionOffered]
					, [NoSaleReason]
					, [DiscStyleSSID]
					, [SFDC_LeadID]
					, [SFDC_TaskID]
					, [SFDC_PersonAccountID]
					, [DateSaved]
					, [RowIsCurrent]
					, [RowStartDate]
					, [RowEndDate]
					, [RowChangeReason]
					, [RowIsInferred]
					, [InsertAuditKey]
					, [UpdateAuditKey]
					)
			SELECT
				  STG.[ActivityDemographicSSID]
				, STG.[ActivitySSID]
				, STG.[ContactSSID]
				, STG.[GenderSSID]
				, STG.[GenderDescription]
				, STG.[EthnicitySSID]
				, STG.[EthnicityDescription]
				, STG.[OccupationSSID]
				, STG.[OccupationDescription]
				, STG.[MaritalStatusSSID]
				, STG.[MaritalStatusDescription]
				, ISNULL(STG.[Birthday], '1900-01-01')
				, ISNULL(STG.[Age], 0)
				, STG.[AgeRangeSSID]
				, STG.[AgeRangeDescription]
				, STG.[HairLossTypeSSID]
				, STG.[HairLossTypeDescription]
				, STG.[NorwoodSSID]
				, STG.[LudwigSSID]
				, STG.[Performer]
				, STG.[PriceQuoted]
				, STG.[SolutionOffered]
				, STG.[NoSaleReason]
				, STG.[DiscStyleSSID]
				, STG.[SFDC_LeadID]
				, STG.[SFDC_TaskID]
				, STG.[SFDC_PersonAccountID]
				, STG.[DateSaved]
				, 1 -- [RowIsCurrent]
				, STG.[ModifiedDate] -- [RowStartDate]
				, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
				, 'SCD Type 2' -- [RowChangeReason]
				, 0
				, @DataPkgKey
				, -2 -- 'Not Updated Yet'
			FROM [bi_mktg_stage].[DimActivityDemographic] STG
			WHERE	STG.[IsType2] = 1
				AND	STG.[IsException] = 0
				AND STG.[DataPkgKey] = @DataPkgKey


		SET @InsertSCD2RowCnt = @@ROWCOUNT

		--Update DimContact DiscStyleSSID

		UPDATE	DimContact
		SET		DimContact.DiscStyleSSID = ISNULL(DimActivityDemographic.DiscStyleSSID, 'u')
		FROM	HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DimContact
				INNER JOIN bi_mktg_stage.DimActivityDemographic DimActivityDemographic
					ON DimContact.SFDC_LeadID = DimActivityDemographic.SFDC_LeadID
					--ON ISNULL(DimContact.SFDC_LeadID, DimContact.ContactSSID) = ISNULL(DimActivityDemographic.SFDC_LeadID, DimActivityDemographic.ContactSSID)

		-- Determine the number of exception rows
		SELECT @ExceptionRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		WHERE STG.[IsException] = 1
			AND STG.[DataPkgKey] = @DataPkgKey

		-- Determine the number of inserted and updated rows
		SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt

		-- Determine the number of ignored rows
		SELECT @IgnoreRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		WHERE STG.[IsException] = 0
		AND STG.[IsNew] = 0
		AND STG.[IsType1] = 0
		AND STG.[IsType2] = 0
		OR STG.[IsDuplicate] = 1
		AND STG.[DataPkgKey] = @DataPkgKey


		-- Determine Final Row Cnt
		SELECT @FinalRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_DimActivityDemographic]

		-- Determine the number of Fixed rows
		SELECT @FixedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsFixed] = 1

		-- Determine the number of Allowed rows
		SELECT @AllowedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsAllowed] = 1

		-- Determine the number of Rejected rows
		SELECT @RejectedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 1

		-- Determine the number of Healthy rows
		SELECT @HealthyRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 0
		AND STG.[IsAllowed] = 0
		AND STG.[IsFixed] = 0

		-- Determine the number of Duplicate rows
		SELECT @DuplicateRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDuplicate] = 1

		-- Determine the number of Deleted rows
		SELECT @DeletedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDelete] = 1

		-- Included deleted orphaned rows
		SET @DeletedRowCnt = @DeletedRowCnt + @OrphanedRowCnt


		-----------------------
		-- Flag records as validated
		-----------------------
		UPDATE STG SET
			IsLoaded = 1
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
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
