/* CreateDate: 05/03/2010 12:27:06.157 , ModifyDate: 10/26/2011 10:45:15.290 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_EmployeeKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactLead_Transform_Lkup_EmployeeKey] is used to determine
-- the EmployeeKey foreign key values in the FactLead table using DimEmployee.
--
--
--   exec [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_EmployeeKey] -1
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

 	SET @TableName = N'[bi_mktg_dds].[DimEmployee]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		------------------------
		-- There might be some other load that just added them
		-- Update [EmployeeKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [EmployeeKey] = COALESCE(DW.[EmployeeKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimEmployee] DW ON
				DW.[EmployeeSSID] = STG.[EmployeeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[EmployeeKey], 0) = 0
			AND STG.[EmployeeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactLead_LoadInferred_DimEmployee] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [EmployeeKey] = COALESCE(DW.[EmployeeKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimEmployee] DW ON
				DW.[EmployeeSSID] = STG.[EmployeeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[EmployeeKey], 0) = 0
			AND STG.[EmployeeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [EmployeeKey]
		-----------------------
		UPDATE STG SET
		     [EmployeeKey] = -1
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[EmployeeKey] IS NULL

		-----------------------
		-- Fix [EmployeeSSID]
		-----------------------
		UPDATE STG SET
		       [EmployeeKey]  = -1
		     , [EmployeeSSID] = -2
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[EmployeeSSID] IS NULL )

		-----------------------
		-- Exception if [EmployeeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'EmployeeSSID IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[EmployeeSSID] IS NULL


		-----------------------
		-- Exception if [EmployeeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'EmployeeKey IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[EmployeeKey] IS NULL
				OR STG.[EmployeeKey] = 0)


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
