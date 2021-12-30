/* CreateDate: 05/03/2010 12:26:59.850 , ModifyDate: 10/26/2011 10:47:09.923 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivity_Transform_Lkup_OccupationKey]
			   @DataPkgKey					int
			 --, @IgnoreRowCnt				bigint output
			 --, @InsertRowCnt				bigint output
			 --, @UpdateRowCnt				bigint output
			 --, @ExceptionRowCnt				bigint output
			 --, @ExtractRowCnt				bigint output
			 --, @InsertNewRowCnt				bigint output
			 --, @InsertInferredRowCnt		bigint output
			 --, @InsertSCD2RowCnt			bigint output
			 --, @UpdateInferredRowCnt		bigint output
			 --, @UpdateSCD1RowCnt			bigint output
			 --, @UpdateSCD2RowCnt			bigint output
			 --, @InitialRowCnt				bigint output
			 --, @FinalRowCnt					bigint output

AS
-------------------------------------------------------------------------
-- [sspHC_FactActivity_Transform_Lkup_OccupationKey] is used to determine
-- the OccupationKey foreign key values in the FactActivity table using DimOccupation.
--
--
--   exec [bi_mktg_stage].[spHC_FactActivity_Transform_Lkup_OccupationKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011  KMurdoch	 Added Exception Message
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
	DECLARE		@DataPkgDetailKey	int

 	SET @TableName = N'[bi_mktg_dds].[DimOccupation]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		--SET @IgnoreRowCnt = 0
		--SET @InsertRowCnt = 0
		--SET @UpdateRowCnt = 0
		--SET @ExceptionRowCnt = 0
		--SET @ExtractRowCnt = 0
		--SET @InsertNewRowCnt = 0
		--SET @InsertInferredRowCnt = 0
		--SET @InsertSCD2RowCnt = 0
		--SET @UpdateInferredRowCnt = 0
		--SET @UpdateSCD1RowCnt = 0
		--SET @UpdateSCD2RowCnt = 0
		--SET @InitialRowCnt = 0
		--SET @FinalRowCnt = 0


		---- Determine Initial Row Cnt
		--SELECT @InitialRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_DimOccupation]

		UPDATE STG SET
			   [OccupationKey] = -1
		     , [OccupationSSID] = '-2'
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE COALESCE(STG.[OccupationSSID], '0') = '0'
			AND STG.[DataPkgKey] = @DataPkgKey

		------------------------
		-- There might be some other load that just added them
		-- Update [OccupationKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [OccupationKey] = COALESCE(DW.[OccupationKey], 0)
		FROM [bi_mktg_stage].[FactActivity] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimOccupation] DW ON
				DW.[OccupationSSID] = STG.[OccupationSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[OccupationKey], 0) = 0
			AND STG.[OccupationSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivity_LoadInferred_DimOccupation] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [OccupationKey] = COALESCE(DW.[OccupationKey], 0)
		FROM [bi_mktg_stage].[FactActivity] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimOccupation] DW ON
				DW.[OccupationSSID] = STG.[OccupationSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[OccupationKey], 0) = 0
			AND STG.[OccupationSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [OccupationKey]
		-----------------------
		UPDATE STG SET
		     [OccupationKey] = -1
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[OccupationKey] IS NULL

		-----------------------
		-- Fix [OccupationSSID]
		-----------------------
		UPDATE STG SET
		       [OccupationKey]  = -1
		     , [OccupationSSID] = -2
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[OccupationSSID] IS NULL )

		-----------------------
		-- Exception if [OccupationSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage= 'OccupationSSID is null - FA_Trans_Lkup'
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[OccupationSSID] IS NULL


		-----------------------
		-- Exception if [OccupationKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage= 'OccupationKey is null - FA_Trans_Lkup'
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[OccupationKey] IS NULL
				OR STG.[OccupationKey] = 0)


		---- Determine the number of inserted and updated rows
		--SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		--SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt


		---- Determine Final Row Cnt
		--SELECT @FinalRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_DimOccupation]

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
