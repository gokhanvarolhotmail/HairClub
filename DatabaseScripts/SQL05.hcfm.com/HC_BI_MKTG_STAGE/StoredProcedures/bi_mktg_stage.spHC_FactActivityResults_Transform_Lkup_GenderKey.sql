/* CreateDate: 05/03/2010 12:26:55.177 , ModifyDate: 10/26/2011 10:39:02.017 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_GenderKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [sspHC_FactActivityResults_Transform_Lkup_GenderKey] is used to determine
-- the GenderKey foreign key values in the FactActivityResults table using DimGender.
--
--
--   exec [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_GenderKey] -1
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

 	SET @TableName = N'[bi_mktg_dds].[DimGender]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		UPDATE STG SET
		       [GenderKey]  = -1
		     , [GenderSSID] = 'U'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[GenderSSID]= '?')

		------------------------
		-- There might be some other load that just added them
		-- Update [GenderKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [GenderKey] = COALESCE(DW.[GenderKey], 0)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimGender] DW ON
				DW.[GenderSSID] = STG.[GenderSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[GenderKey], 0) = 0
			AND STG.[GenderSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_LoadInferred_DimGender] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [GenderKey] = COALESCE(DW.[GenderKey], 0)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimGender] DW ON
				DW.[GenderSSID] = STG.[GenderSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[GenderKey], 0) = 0
			AND STG.[GenderSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [GenderKey]
		-----------------------
		UPDATE STG SET
		     [GenderKey] = -1
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[GenderKey] IS NULL

		-----------------------
		-- Fix [GenderSSID]
		-----------------------
		UPDATE STG SET
		       [GenderKey]  = -1
		     , [GenderSSID] = 'U'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[GenderSSID] IS NULL )

		-----------------------
		-- Exception if [GenderSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'GenderSSID IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[GenderSSID] IS NULL


		-----------------------
		-- Exception if [GenderKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'GenderKey IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[GenderKey] IS NULL
				OR STG.[GenderKey] = 0)


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
