/* CreateDate: 05/03/2010 12:26:59.680 , ModifyDate: 10/26/2011 10:28:38.280 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivity_Transform_Lkup_ActivityTimeKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactActivity_Transform_Lkup_ActivityTimeKey] is used to populate
-- the ActivityTimeKey in the FactActivity rows
--
--
--   exec [bi_mktg_stage].[spHC_FactActivity_Transform_Lkup_ActivityTimeKey] -1
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

 	SET @TableName = N'[bi_mktg_dds].[DimTimeOfDay]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		------------------------
		-- Update [ActivityTimeKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [ActivityTimeKey] = COALESCE(DW.[TimeOfDayKey], 0)
		FROM [bi_mktg_stage].[FactActivity] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimTimeOfDay] DW ON
				DW.[Time24] = cast(STG.[ActivityTimeSSID] as varchar(8))
		WHERE COALESCE(STG.[ActivityTimeKey], 0) = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		----------------------------------------------------------------------
		-- DO NOT ADD Inferred Members  use the DDS_DimTimeOfDay_Populate SP
		-- to add times to the DimTimeOfDay table.  No audit logging is needed.
		----------------------------------------------------------------------

		-----------------------
		-- Set [ActivityTime]to Unknown Time if IS NULL
		-----------------------
		UPDATE STG SET
		       [ActivityTimeKey] = -1
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ActivityTimeSSID] IS NULL


		---------------------------
		------ Exception if [ActivityTime] IS NULL
		---------------------------
		----UPDATE STG SET
		----     IsException = 1
		----FROM [bi_mktg_stage].[FactActivity] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[ActivityTimeSSID] IS NULL

		-----------------------
		-- Exception if [ActivityTimeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage= 'ActivityTimeKey is null - FA_Trans_Lkup'
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[ActivityTimeKey] IS NULL)

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
