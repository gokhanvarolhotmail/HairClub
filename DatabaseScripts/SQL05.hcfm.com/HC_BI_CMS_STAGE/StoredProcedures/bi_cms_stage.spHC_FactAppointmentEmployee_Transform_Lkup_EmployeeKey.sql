/* CreateDate: 06/27/2011 17:23:48.040 , ModifyDate: 10/26/2011 11:05:37.753 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactAppointmentEmployee_Transform_Lkup_EmployeeKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactAppointmentEmployee_Transform_Lkup_EmployeeKey] is used to determine
-- the EmployeeKey foreign key values in the FactAppointmentEmployee table using DimEmployee.
--
--
--   exec [bi_cms_stage].[spHC_FactAppointmentEmployee_Transform_Lkup_EmployeeKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/22/2011  KMurdoch     Initial Creation
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
		FROM [bi_cms_stage].[FactAppointmentEmployee] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimEmployee] DW  WITH (NOLOCK)
				ON DW.[EmployeeSSID] = STG.[EmployeeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[EmployeeKey], 0) = 0
			AND STG.[EmployeeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactAppointmentEmployee_LoadInferred_DimEmployee] @DataPkgKey


		-----------------------
		-- Update Employee Keys in STG
		-----------------------
		UPDATE STG SET
		     [EmployeeKey] = COALESCE(DW.[EmployeeKey], 0)
		FROM [bi_cms_stage].[FactAppointmentEmployee] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimEmployee] DW  WITH (NOLOCK)
				ON DW.[EmployeeSSID] = STG.[EmployeeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[EmployeeKey], 0) = 0
			AND STG.[EmployeeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		---------------------------
		------ Fix [EmployeeKey]
		---------------------------
		----UPDATE STG SET
		----     [EmployeeKey] = -1
		----FROM [bi_cms_stage].[FactAppointmentEmployee] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[EmployeeKey] IS NULL

		---------------------------
		------ Fix [EmployeeSSID]
		---------------------------
		----UPDATE STG SET
		----     [EmployeeKey] = -1
		----     , [EmployeeSSID] = CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')
		----FROM [bi_cms_stage].[FactAppointmentEmployee] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND (STG.[EmployeeSSID] IS NULL )

		-----------------------
		-- Exception if [EmployeeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'EmployeeSSID is null - FApptEmp_Trans_Lkup'
		FROM [bi_cms_stage].[FactAppointmentEmployee] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[EmployeeSSID] IS NULL


		-----------------------
		-- Exception if [EmployeeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'EmployeeKey is null - FApptEmp_Trans_Lkup'
		FROM [bi_cms_stage].[FactAppointmentEmployee] STG
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
