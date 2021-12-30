/* CreateDate: 05/03/2010 12:26:59.733 , ModifyDate: 01/06/2021 12:59:58.390 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivity_Transform_Lkup_CenterKey]
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
-- [sspHC_FactActivity_Transform_Lkup_CenterKey] is used to determine
-- the CenterKey foreign key values in the FactActivity table using DimCenter.
--
--
--   exec [bi_mktg_stage].[spHC_FactActivity_Transform_Lkup_CenterKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/22/2011	KMurdoch	 Added Exception Message
--			01/20/2018	KMurdoch	 Added derivation of center number.
--			06/24/2020  Kmurdoch	 Added exclusion for Surgery centers
--			09/16/2020  KMurdoch     Added logic to use reporting centers and excluded Surgery Centers.
--			09/22/2020  KMurdoch     Removed logic to exclude surgery center
--			09/24/2020  KMurdoch     Added second Update query for centers where number is reused
--			09/24/2020  KMurdoch     Removed second query and reinstated logic to exclude surgery centers
--			01/06/2021  KMurdoch     Added logic to check for Center Active and changed Coalesce to look at both joins
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

 	SET @TableName = N'[bi_mktg_dds].[DimCenter]'

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
		--SELECT @InitialRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_DimCenter]

		-----------------------
		-- Found an instance where the center number was not numeric
		-- so fix this first
		-----------------------
		UPDATE STG SET
		       [CenterKey]  = -1
		     , [CenterSSID] = -2
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (ISNUMERIC(STG.[CenterSSID]) <> 1)


		------------------------
		-- There might be some other load that just added them
		-- Update [CenterKey] Keys in STG -
		------------------------
		UPDATE STG SET
		     [CenterKey] = COALESCE(DW_rc.[CenterKey], DW_c.[CenterKey])	--01/06/21
		FROM [bi_mktg_stage].[FactActivity] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimCenter] DW_c
			ON DW_c.[CenterNumber] = STG.[CenterSSID]
				AND DW_c.[RowIsCurrent] = 1
				AND DW_c.CenterSSID NOT BETWEEN 300 AND 399
				AND dw_c.Active = 'Y'										--01/06/21
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimCenter] DW_rc
			ON DW_rc.[CenterSSID] = DW_c.[ReportingCenterSSID]
				AND DW_rc.Active = 'Y'
				AND DW_rc.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[CenterKey], 0) = 0
			AND STG.[CenterSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivity_LoadInferred_DimCenter] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [CenterKey] = COALESCE(DW_rc.[CenterKey], 0)
		FROM [bi_mktg_stage].[FactActivity] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimCenter] DW_c
			ON DW_c.[CenterNumber] = STG.[CenterSSID]
				AND DW_c.[RowIsCurrent] = 1
				--AND DW_c.CenterSSID NOT BETWEEN 300 AND 399
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimCenter] DW_rc
			ON DW_rc.[CenterSSID] = DW_c.[ReportingCenterSSID]
				AND DW_rc.Active = 'Y'
				AND DW_rc.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[CenterKey], 0) = 0
			AND STG.[CenterSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [CenterKey]
		-----------------------
		UPDATE STG SET
		     [CenterKey] = -1
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[CenterKey] IS NULL

		-----------------------
		-- Fix [CenterSSID]
		-----------------------
		UPDATE STG SET
		       [CenterKey]  = -1
		     , [CenterSSID] = -2
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[CenterSSID] IS NULL )

		-----------------------
		-- Exception if [CenterSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage= 'CenterSSID is null - FA_Trans_Lkup'
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[CenterSSID] IS NULL


		-----------------------
		-- Exception if [CenterKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage= 'CenterKey is null - FA_Trans_Lkup'
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[CenterKey] IS NULL
				OR STG.[CenterKey] = 0)


		---- Determine the number of inserted and updated rows
		--SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		--SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt


		---- Determine Final Row Cnt
		--SELECT @FinalRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_DimCenter]

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
