/* CreateDate: 05/03/2010 12:26:23.663 , ModifyDate: 12/11/2018 16:00:51.913 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DDS_FactActivity_Upsert]
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
-- [spHC_DDS_FactActivity_Upsert] loads records into the FactActivity table
--
--
--   exec [bi_mktg_stage].[spHC_DDS_FactActivity_Upsert] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    07/01/2009  RLifke       Initial Creation
--			08/05/2011	KMurdoch	 Added ActivityEmployeeKey
--          01/09/2013  EKnapp       Delete orphaned FactActivity rows (with deleted DimActivity s)
--			01/26/2018	KMurdoch     Removed delete
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

	DECLARE		@TableName			varchar(150)	-- Name of table

	DECLARE		  @DeletedRowCnt		bigint
				, @DuplicateRowCnt		bigint
				, @HealthyRowCnt		bigint
				, @RejectedRowCnt		bigint
				, @AllowedRowCnt		bigint
				, @FixedRowCnt			bigint

 	SET @TableName = N'[bi_mktg_dds].[FactActivity]'

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


		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_LoadStart] @DataPkgKey, @TableName

		-- Determine Initial Row Cnt
		SELECT @InitialRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_FactActivity]

		-- Determine the number of extracted rows
		SELECT @ExtractRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey

		------------------------
		-- Deleted Records
		------------------------
		--DELETE
		--FROM [bi_mktg_stage].[synHC_DDS_FactActivity]
		--WHERE [ActivityKey] IN ( SELECT STG.[ActivityKey]
		--								FROM [bi_mktg_stage].[FactActivity] STG
		--								WHERE	STG.[IsDelete] = 1
		--									AND STG.[DataPkgKey] = @DataPkgKey
		--							)

	 --   SET @DeletedRowCnt = @@ROWCOUNT

		DELETE
		FROM [bi_mktg_stage].[synHC_DDS_FactActivity]
		WHERE [ActivityKey] NOT IN ( SELECT  [ActivityKey]
										FROM [bi_mktg_stage].[synHC_DDS_DimActivity] WITH (NOLOCK)
									)

		SET @DeletedRowCnt = @DeletedRowCnt + @@ROWCOUNT

		------------------------
		-- New Records
		------------------------
		INSERT INTO [bi_mktg_stage].[synHC_DDS_FactActivity](
					   [ActivityKey]
					  ,[ActivityDateKey]
					  ,[ActivityTimeKey]

					  ,[ActivityDueDateKey]
					  ,[ActivityStartTimeKey]

					  ,[ActivityCompletedDateKey]
					  ,[ActivityCompletedTimeKey]

					  ,[GenderKey]
					  ,[EthnicityKey]
					  ,[OccupationKey]
					  ,[MaritalStatusKey]
					  ,[AgeRangeKey]
					  ,[HairLossTypeKey]
					  ,[CenterKey]
					  ,[ContactKey]
					  ,[ActionCodeKey]
					  ,[ResultCodeKey]
					  ,[SourceKey]
					  ,[ActivityTypeKey]
					  ,[CompletedByEmployeeKey]
					  ,[StartedByEmployeeKey]
					  ,[ActivityEmployeeKey]
					  ,[InsertAuditKey]
					)
			SELECT DISTINCT
					   STG.[ActivityKey]
					  ,STG.[ActivityDateKey]
					  ,STG.[ActivityTimeKey]

					  ,STG.[ActivityDueDateKey]
					  ,STG.[ActivityStartTimeKey]

					  ,STG.[ActivityCompletedDateKey]
					  ,STG.[ActivityCompletedTimeKey]

					  ,STG.[GenderKey]
					  ,STG.[EthnicityKey]
					  ,STG.[OccupationKey]
					  ,STG.[MaritalStatusKey]
					  ,STG.[AgeRangeKey]
					  ,STG.[HairLossTypeKey]
					  ,STG.[CenterKey]
					  ,STG.[ContactKey]
					  ,STG.[ActionCodeKey]
					  ,STG.[ResultCodeKey]
					  ,STG.[SourceKey]
					  ,STG.[ActivityTypeKey]
					  ,STG.[CompletedByEmployeeKey]
					  ,STG.[StartedByEmployeeKey]
					  ,STG.[ActivityEmployeeKey]
					  ,@DataPkgKey

			FROM [bi_mktg_stage].[FactActivity] STG
			WHERE	STG.[IsNew] = 1
				AND	STG.[IsException] = 0
				AND STG.[IsDuplicate] = 0
				AND STG.[DataPkgKey] = @DataPkgKey

		SET @InsertNewRowCnt = @@ROWCOUNT



		------------------------
		-- Update Records
		------------------------
		-- Just update the record
		UPDATE DW SET
				DW.[ActivityDateKey] = STG.[ActivityDateKey]
				, DW.[ActivityTimeKey] = STG.[ActivityTimeKey]
				, DW.[ActivityDueDateKey] = STG.[ActivityDueDateKey]
				, DW.[ActivityStartTimeKey] = STG.[ActivityStartTimeKey]
				, DW.[ActivityCompletedDateKey] = STG.[ActivityCompletedDateKey]
				, DW.[ActivityCompletedTimeKey] = STG.[ActivityCompletedTimeKey]
				, DW.[GenderKey] = STG.[GenderKey]
				, DW.[EthnicityKey] = STG.[EthnicityKey]
				, DW.[OccupationKey] = STG.[OccupationKey]
				, DW.[MaritalStatusKey] = STG.[MaritalStatusKey]
				, DW.[AgeRangeKey] = STG.[AgeRangeKey]
				, DW.[HairLossTypeKey] = STG.[HairLossTypeKey]
				, DW.[CenterKey] = STG.[CenterKey]
				, DW.[ContactKey] = STG.[ContactKey]
				, DW.[ActionCodeKey] = STG.[ActionCodeKey]
				, DW.[ResultCodeKey] = STG.[ResultCodeKey]
				, DW.[SourceKey] = STG.[SourceKey]
				, DW.[ActivityTypeKey] = STG.[ActivityTypeKey]
				, DW.[CompletedByEmployeeKey] = STG.[CompletedByEmployeeKey]
				, DW.[StartedByEmployeeKey] = STG.[StartedByEmployeeKey]
				, DW.[ActivityEmployeeKey] = STG.[ActivityEmployeeKey]
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_mktg_stage].[FactActivity] STG
		JOIN [bi_mktg_stage].[synHC_DDS_FactActivity] DW ON
				DW.[ActivityKey] = STG.[ActivityKey]
		WHERE	STG.[IsUpdate] = 1
			AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @UpdateSCD1RowCnt = @@ROWCOUNT







		-- Determine the number of exception rows
		SELECT @ExceptionRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[IsException] = 1
			AND STG.[DataPkgKey] = @DataPkgKey

		-- Determine the number of inserted and updated rows
		SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt

		-- Determine the number of ignored rows
		SELECT @IgnoreRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[IsException] = 0
		AND STG.[IsNew] = 0
		AND STG.[IsUpdate] = 0
		AND STG.[IsDelete] = 0
		OR STG.[IsDuplicate] = 1
		AND STG.[DataPkgKey] = @DataPkgKey



		-- Determine Final Row Cnt
		SELECT @FinalRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_FactActivity]

		-- Determine the number of Fixed rows
		SELECT @FixedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsFixed] = 1

		-- Determine the number of Allowed rows
		SELECT @AllowedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsAllowed] = 1

		-- Determine the number of Rejected rows
		SELECT @RejectedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 1

		-- Determine the number of Healthy rows
		SELECT @HealthyRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 0
		AND STG.[IsAllowed] = 0
		AND STG.[IsFixed] = 0

		-- Determine the number of Duplicate rows
		SELECT @DuplicateRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDuplicate] = 1

		-- Determine the number of Deleted rows
		--SELECT @DeletedRowCnt = COUNT(1)
		--FROM [bi_mktg_stage].[FactActivity] STG
		--WHERE STG.[DataPkgKey] = @DataPkgKey
		--AND STG.[IsDelete] = 1


		-----------------------
		-- Flag records as loaded
		-----------------------
		UPDATE STG SET
			IsLoaded = 1
		FROM [bi_mktg_stage].[FactActivity] STG
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
