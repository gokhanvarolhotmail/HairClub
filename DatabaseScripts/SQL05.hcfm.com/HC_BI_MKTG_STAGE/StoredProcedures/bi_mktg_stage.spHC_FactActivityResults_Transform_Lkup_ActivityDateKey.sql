/* CreateDate: 05/03/2010 12:26:54.880 , ModifyDate: 10/26/2011 10:30:45.830 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivityDateKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactActivityResults_Transform_Lkup_ActivityDateKey] is used to populate
-- the ActivityDateKey in the FactActivityResults rows
--
--
--   exec [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivityDateKey] -1
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

 	SET @TableName = N'[bi_mktg_dds].[DimDate]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		------------------------
		-- Update [ActivityDateKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [ActivityDateKey] = COALESCE(DW.[DateKey], 0)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimDate] DW ON
				DW.[ISODate] = CONVERT(char(8),STG.[ActivityDateSSID],112)
		WHERE COALESCE(STG.[ActivityDateKey], 0) = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		----------------------------------------------------------------------
		-- DO NOT ADD Inferred Members  use the DimDate_Populate SP
		-- to add dates to the DimDate table.  No audit logging is needed.
		----------------------------------------------------------------------

		-----------------------
		-- Set [ActivityDate] to UnKnown date if IS NULL
		-----------------------
		UPDATE STG SET
		       [ActivityDateKey] = -1
		     , [ActivityDateSSID] = '1753-01-01 00:00:00.000'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ActivityDateSSID] IS NULL

		-----------------------
		-- Exception if [ActivityDate] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'ActivityDateSSID IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ActivityDateSSID] IS NULL

		-----------------------
		-- Exception if [ActivityDateKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'ActivityDateKey IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[ActivityDateKey] IS NULL
				OR STG.[ActivityDateKey] = 0)

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
