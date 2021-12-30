/* CreateDate: 05/03/2010 12:20:12.063 , ModifyDate: 05/03/2010 12:20:12.063 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimSalesOrderTender_Transform_SalesOrderKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimSalesOrderTender_Transform_SalesOrderKey] is used to
--  transform SalesOrderKey
--
--
--   exec [bi_cms_stage].[spHC_DimSalesOrderTender_Transform_SalesOrderKey] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/03/2009  RLifke       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrderTender]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY



		-----------------------
		-- Update [SalesOrderKey]
		-----------------------
		UPDATE STG SET
		     [SalesOrderKey] = DW.[SalesOrderKey]
		FROM [bi_cms_stage].[DimSalesOrderTender] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrder] DW ON
				DW.[SalesOrderSSID] = STG.[SalesOrderSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Fix [SalesOrderKey]
		-----------------------
		UPDATE STG SET
		     [SalesOrderKey] = -1
		FROM [bi_cms_stage].[DimSalesOrderTender] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SalesOrderKey] IS NULL

		-----------------------
		-- Fix [SalesOrderSSID]
		-----------------------
		UPDATE STG SET
				  [SalesOrderKey] = -2
				, [SalesOrderSSID] = CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')  -- Not Assigned
		FROM [bi_cms_stage].[DimSalesOrderTender] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalesOrderSSID] IS NULL)

		-----------------------
		-- Exception if [SalesOrderSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_cms_stage].[DimSalesOrderTender] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalesOrderSSID] IS NULL)

		-----------------------
		-- Exception if [SalesOrderKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_cms_stage].[DimSalesOrderTender] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SalesOrderKey] IS NULL






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
