/* CreateDate: 05/03/2010 12:26:55.030 , ModifyDate: 10/26/2011 10:35:21.093 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivitySavedTimeKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactActivityResults_Transform_Lkup_ActivitySavedTimeKey] is used to populate
-- the ActivitySavedTimeKey in the FactActivityResults rows
--
--
--   exec [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivitySavedTimeKey] -1
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

 	SET @TableName = N'[bi_mktg_dds].[DimTimeOfDay]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		------------------------
		-- Update [ActivitySavedTimeKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [ActivitySavedTimeKey] = COALESCE(DW.[TimeOfDayKey], 0)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimTimeOfDay] DW ON
				DW.[Time24] = cast(STG.[ActivitySavedTimeSSID] as varchar(8))
		WHERE COALESCE(STG.[ActivitySavedTimeKey], 0) = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		----------------------------------------------------------------------
		-- DO NOT ADD Inferred Members  use the DDS_DimTimeOfDay_Populate SP
		-- to add times to the DimTimeOfDay table.  No audit logging is needed.
		----------------------------------------------------------------------

		-----------------------
		-- Set [ActivitySavedTime]to Unknown Time if IS NULL
		-----------------------
		UPDATE STG SET
		       [ActivitySavedTimeKey] = -1
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ActivitySavedTimeSSID] IS NULL


		---------------------------
		------ Exception if [ActivitySavedTime] IS NULL
		---------------------------
		----UPDATE STG SET
		----     IsException = 1
		----FROM [bi_mktg_stage].[FactActivityResults] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[ActivitySavedTimeSSID] IS NULL

		-----------------------
		-- Exception if [ActivitySavedTimeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'ActivitySavedTimeKey IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[ActivitySavedTimeKey] IS NULL)

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
