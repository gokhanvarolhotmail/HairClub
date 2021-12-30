/* CreateDate: 05/03/2010 12:26:55.257 , ModifyDate: 10/26/2011 10:41:25.890 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ResultCodeKey]
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
-- [sspHC_FactActivityResults_Transform_Lkup_ResultCodeKey] is used to determine
-- the ResultCodeKey foreign key values in the FactActivityResults table using DimResultCode.
--
--
--   exec [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ResultCodeKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011	MBurrell	 Added exception message

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

 	SET @TableName = N'[bi_mktg_dds].[DimResultCode]'

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
		--SELECT @InitialRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_DimResultCode]

		------------------------
		-- There might be some other load that just added them
		-- Update [ResultCodeKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [ResultCodeKey] = COALESCE(DW.[ResultCodeKey], 0)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimResultCode] DW ON
				DW.[ResultCodeSSID] = STG.[ResultCodeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[ResultCodeKey], 0) = 0
			AND STG.[ResultCodeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_LoadInferred_DimResultCode] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [ResultCodeKey] = COALESCE(DW.[ResultCodeKey], 0)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimResultCode] DW ON
				DW.[ResultCodeSSID] = STG.[ResultCodeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[ResultCodeKey], 0) = 0
			AND STG.[ResultCodeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [ResultCodeKey]
		-----------------------
		UPDATE STG SET
		     [ResultCodeKey] = -1
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ResultCodeKey] IS NULL

		-----------------------
		-- Fix [ResultCodeSSID]
		-----------------------
		UPDATE STG SET
		       [ResultCodeKey]  = -1
		     , [ResultCodeSSID] = -2
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[ResultCodeSSID] IS NULL )

		-----------------------
		-- Exception if [ResultCodeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'ResultCodeSSID IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ResultCodeSSID] IS NULL


		-----------------------
		-- Exception if [ResultCodeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'ResultCodeKey IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[ResultCodeKey] IS NULL
				OR STG.[ResultCodeKey] = 0)


		---- Determine the number of inserted and updated rows
		--SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		--SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt


		---- Determine Final Row Cnt
		--SELECT @FinalRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_DimResultCode]

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
