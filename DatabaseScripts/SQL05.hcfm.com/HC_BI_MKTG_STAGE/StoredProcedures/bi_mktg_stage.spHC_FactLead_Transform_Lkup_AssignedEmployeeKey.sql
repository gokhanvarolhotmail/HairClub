/* CreateDate: 08/09/2011 12:55:32.017 , ModifyDate: 10/26/2011 10:43:51.610 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_AssignedEmployeeKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactLead_Transform_Lkup_AssignedEmployeeKey] is used to determine
-- the AssignedEmployeeKey foreign key values in the FactLead table using DimEmployee.
--
--
--   exec [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_AssignedEmployeeKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/10/2011  KMurdoch       Initial Creation
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
		-- Update [AssignedEmployeeKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [AssignedEmployeeKey] = COALESCE(DW.[EmployeeKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimEmployee] DW ON
				DW.[EmployeeSSID] = STG.[AssignedEmployeeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[AssignedEmployeeKey], 0) = 0
			AND STG.[AssignedEmployeeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactLead_LoadInferred_DimEmployee_Assigned] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [AssignedEmployeeKey] = COALESCE(DW.[EmployeeKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimEmployee] DW ON
				DW.[EmployeeSSID] = STG.[AssignedEmployeeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[AssignedEmployeeKey], 0) = 0
			AND STG.[AssignedEmployeeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [AssignedEmployeeKey]
		-----------------------
		UPDATE STG SET
		     [AssignedEmployeeKey] = -1
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[AssignedEmployeeKey] IS NULL

		-----------------------
		-- Fix [AssignedEmployeeSSID]
		-----------------------
		UPDATE STG SET
		       [AssignedEmployeeKey]  = -1
		     , [AssignedEmployeeSSID] = -2
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[AssignedEmployeeSSID] IS NULL )

		-----------------------
		-- Exception if [AssignedEmployeeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'AssignedEmployeeSSID IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[AssignedEmployeeSSID] IS NULL


		-----------------------
		-- Exception if [AssignedEmployeeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'AssignedEmployeeKey IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[AssignedEmployeeKey] IS NULL
				OR STG.[AssignedEmployeeKey] = 0)


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
