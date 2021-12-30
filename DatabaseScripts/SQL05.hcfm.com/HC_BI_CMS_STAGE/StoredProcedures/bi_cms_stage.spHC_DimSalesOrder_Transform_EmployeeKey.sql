/* CreateDate: 05/03/2010 12:20:16.560 , ModifyDate: 10/26/2011 14:20:52.127 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimSalesOrder_Transform_EmployeeKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimSalesOrder_Transform_EmployeeKey] is used to
--  transform EmployeeKey
--
--
--   exec [bi_cms_stage].[spHC_DimSalesOrder_Transform_EmployeeKey] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/03/2009  RLifke       Initial Creation
--			10/26/2011  KMurdoch	 Added Exception message
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

	DECLARE		  @TableName			varchar(150)	-- Name of table

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrder]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY



		-----------------------
		-- Update [EmployeeKey]
		-----------------------
		UPDATE STG SET
		     [EmployeeKey] = DW.[EmployeeKey]
		FROM [bi_cms_stage].[DimSalesOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimEmployee] DW ON
				DW.[EmployeeSSID] = STG.[EmployeeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Fix [EmployeeKey]
		-----------------------
		UPDATE STG SET
		     [EmployeeKey] = -1
		FROM [bi_cms_stage].[DimSalesOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[EmployeeKey] IS NULL

		-----------------------
		-- Fix [EmployeeSSID]
		-----------------------
		UPDATE STG SET
				  [EmployeeKey] = -2
				, [EmployeeSSID] = CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')  -- Not Assigned
		FROM [bi_cms_stage].[DimSalesOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[EmployeeSSID] IS NULL)

		-----------------------
		-- Exception if [EmployeeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'EmployeeSSID is null - DSO_Lkup'
		FROM [bi_cms_stage].[DimSalesOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[EmployeeSSID] IS NULL)

		-----------------------
		-- Exception if [EmployeeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'EmployeeKey is null - DSO_Lkup'
		FROM [bi_cms_stage].[DimSalesOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[EmployeeKey] IS NULL






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
