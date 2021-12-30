/* CreateDate: 05/03/2010 12:20:16.587 , ModifyDate: 10/26/2011 14:22:15.107 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimSalesOrder_Transform_SalesOrderTypeKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimSalesOrder_Transform_SalesOrderTypeKey] is used to
--  transform SalesOrderTypeKey
--
--
--   exec [bi_cms_stage].[spHC_DimSalesOrder_Transform_SalesOrderTypeKey] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/03/2009  RLifke       Initial Creation
--			10/26/2011  KMurdoch     Added exception message
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
		-- Update [SalesOrderTypeKey]
		-----------------------
		UPDATE STG SET
		     [SalesOrderTypeKey] = DW.[SalesOrderTypeKey]
		FROM [bi_cms_stage].[DimSalesOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderType] DW ON
				DW.[SalesOrderTypeSSID] = STG.[SalesOrderTypeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Fix [SalesOrderTypeKey]
		-----------------------
		UPDATE STG SET
		     [SalesOrderTypeKey] = -1
		FROM [bi_cms_stage].[DimSalesOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SalesOrderTypeKey] IS NULL

		-----------------------
		-- Fix [SalesOrderTypeSSID]
		-----------------------
		UPDATE STG SET
		     [SalesOrderTypeSSID] = -2  -- Not Assigned
		FROM [bi_cms_stage].[DimSalesOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalesOrderTypeSSID] IS NULL
			OR	STG.[SalesOrderTypeSSID] = '' )

		-----------------------
		-- Exception if [SalesOrderTypeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'SalesOrderTyepSSID is null - DSO_Lkup'
		FROM [bi_cms_stage].[DimSalesOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalesOrderTypeSSID] IS NULL
			OR	STG.[SalesOrderTypeSSID] = '' )

		-----------------------
		-- Exception if [SalesOrderTypeKey]IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'SalesOrderTypeKey is null - DSO_Lkup'
		FROM [bi_cms_stage].[DimSalesOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SalesOrderTypeKey] IS NULL






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
