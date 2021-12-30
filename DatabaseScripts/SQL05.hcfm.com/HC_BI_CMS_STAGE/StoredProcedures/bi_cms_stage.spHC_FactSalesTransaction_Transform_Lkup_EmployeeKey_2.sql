/* CreateDate: 05/03/2010 12:20:25.630 , ModifyDate: 10/26/2011 11:37:43.667 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_EmployeeKey_2]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactSalesTransaction_Transform_Lkup_EmployeeKey_2] is used to determine
-- the EmployeeKey foreign key values in the FactSalesTransaction table using DimEmployee.
--
--
--   exec [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_EmployeeKey_2] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011  KMurdoch     Added Exception Key
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
		     [Employee2Key] = COALESCE(DW.[EmployeeKey], 0)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimEmployee] DW  WITH (NOLOCK)
				ON DW.[EmployeeSSID] = STG.[Employee2SSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[Employee2Key], 0) = 0
			AND STG.[Employee2SSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransaction_LoadInferred_DimEmployee_2] @DataPkgKey


		-----------------------
		-- Update Employee Keys in STG
		-----------------------
		UPDATE STG SET
		     [Employee2Key] = COALESCE(DW.[EmployeeKey], 0)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimEmployee] DW  WITH (NOLOCK)
				ON DW.[EmployeeSSID] = STG.[Employee2SSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[Employee2Key], 0) = 0
			AND STG.[Employee2SSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [EmployeeKey]
		-----------------------
		UPDATE STG SET
		     [Employee2Key] = -1
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[Employee2Key] IS NULL

		-----------------------
		-- Fix [EmployeeSSID]
		-----------------------
		UPDATE STG SET
		     [Employee2Key] = -1
		     , [Employee2SSID] = CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[Employee2SSID] IS NULL )

		-----------------------
		-- Exception if [EmployeeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'Employee2SSID is null - FSalesTrx_Trans_Lkup'
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[Employee2SSID] IS NULL


		-----------------------
		-- Exception if [EmployeeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'Employee2Key is null - FSalesTrx_Trans_Lkup'
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[Employee2Key] IS NULL
				OR STG.[Employee2Key] = 0)


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
