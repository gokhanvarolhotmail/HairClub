/* CreateDate: 05/03/2010 12:26:59.717 , ModifyDate: 10/26/2011 10:39:39.643 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivity_Transform_Lkup_AgeRangeKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [sspHC_FactActivity_Transform_Lkup_AgeRangeKey] is used to determine
-- the AgeRangeKey foreign key values in the FactActivity table using DimAgeRange.
--
--
--   exec [bi_mktg_stage].[spHC_FactActivity_Transform_Lkup_AgeRangeKey] -1
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

 	SET @TableName = N'[bi_mktg_dds].[DimAgeRange]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		-----------------------
		-- Update AgeRangeSSID based upon age
		-----------------------
		UPDATE STG SET
				STG.[AgeRangeSSID]	 = CASE
										WHEN Age IS NULL THEN '-2'
										WHEN Age < 18 THEN '1'
										WHEN Age >= 18 AND Age <= 24 THEN '2'
										WHEN Age >= 25 AND Age <= 34 THEN '3'
										WHEN Age >= 35 AND Age <= 44 THEN '4'
										WHEN Age >= 45 AND Age <= 54 THEN '5'
										WHEN Age >= 55 AND Age <= 64 THEN '6'
										WHEN Age > 64 THEN '7'
										ELSE '-2'
									END
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Fix [AgeRangeSSID]
		-----------------------
		UPDATE STG SET
		       [AgeRangeKey]  = -1
		     , [AgeRangeSSID] = '-2'
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[AgeRangeSSID] IS NULL
				OR STG.[AgeRangeSSID] = ''
				OR STG.[AgeRangeSSID] = '0')


		------------------------
		-- There might be some other load that just added them
		-- Update [AgeRangeKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [AgeRangeKey] = COALESCE(DW.[AgeRangeKey], 0)
		FROM [bi_mktg_stage].[FactActivity] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimAgeRange] DW ON
				DW.[AgeRangeSSID] = STG.[AgeRangeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[AgeRangeKey], 0) = 0
			AND STG.[AgeRangeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivity_LoadInferred_DimAgeRange] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [AgeRangeKey] = COALESCE(DW.[AgeRangeKey], 0)
		FROM [bi_mktg_stage].[FactActivity] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimAgeRange] DW ON
				DW.[AgeRangeSSID] = STG.[AgeRangeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[AgeRangeKey], 0) = 0
			AND STG.[AgeRangeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [AgeRangeKey]
		-----------------------
		UPDATE STG SET
		     [AgeRangeKey] = -1
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[AgeRangeKey] IS NULL

		-----------------------
		-- Fix [AgeRangeSSID]
		-----------------------
		UPDATE STG SET
		       [AgeRangeKey]  = -1
		     , [AgeRangeSSID] = '-2'
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[AgeRangeSSID] IS NULL )

		-----------------------
		-- Exception if [AgeRangeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage= 'AgeRangeSSID is null - FA_Trans_Lkup'
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[AgeRangeSSID] IS NULL


		-----------------------
		-- Exception if [AgeRangeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage= 'AgeRangeKeyis null - FA_Trans_Lkup'
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[AgeRangeKey] IS NULL
				OR STG.[AgeRangeKey] = 0)


		---- Determine the number of inserted and updated rows
		--SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		--SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt


		---- Determine Final Row Cnt
		--SELECT @FinalRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_DimAgeRange]

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
