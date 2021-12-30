/* CreateDate: 05/03/2010 12:20:07.640 , ModifyDate: 05/03/2010 12:20:07.640 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimSalesCode_Transform_SalesCodeDepartmentKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimSalesCode_Transform_SalesCodeDepartmentKey] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_cms_stage].[spHC_DimSalesCode_Transform_SalesCodeDepartmentKey] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/25/2009  RLifke       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesCode]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY


		-----------------------
		-- Update SalesCodeDepartmentKey
		-----------------------
		UPDATE STG SET
		     [SalesCodeDepartmentKey] = DW.[SalesCodeDepartmentKey]
		FROM [bi_cms_stage].[DimSalesCode] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimSalesCodeDepartment] DW ON
				DW.[SalesCodeDepartmentSSID] = STG.[SalesCodeDepartmentSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Fix [SalesCodeDepartmentKey]
		-----------------------
		UPDATE STG SET
		     SalesCodeDepartmentKey = -1
		FROM [bi_cms_stage].[DimSalesCode] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SalesCodeDepartmentKey] IS NULL

		-----------------------
		-- Fix [SalesCodeDepartmentKey]
		-----------------------
		UPDATE STG SET
		     [SalesCodeDepartmentKey] = -1
		     , [SalesCodeDepartmentSSID] = -2
		FROM [bi_cms_stage].[DimSalesCode] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalesCodeDepartmentSSID] IS NULL
			OR	STG.[SalesCodeDepartmentSSID] = '' )

		-----------------------
		-- Exception if [SalesCodeDepartmentKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_cms_stage].[DimSalesCode] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SalesCodeDepartmentKey] IS NULL

		-----------------------
		-- Exception if [SalesCodeDepartmentSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_cms_stage].[DimSalesCode] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalesCodeDepartmentSSID] IS NULL
			OR	STG.[SalesCodeDepartmentSSID] = '' )



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
