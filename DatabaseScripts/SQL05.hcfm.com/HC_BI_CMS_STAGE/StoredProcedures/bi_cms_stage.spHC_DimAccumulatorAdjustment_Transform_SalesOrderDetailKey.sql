/* CreateDate: 10/05/2010 14:04:33.857 , ModifyDate: 04/09/2015 12:03:09.977 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimAccumulatorAdjustment_Transform_SalesOrderDetailKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimAccumulatorAdjustment_Transform_SalesOrderDetailKey] is used to
--  transform SalesOrderDetailKey
--
--
--   exec [bi_cms_stage].[spHC_DimAccumulatorAdjustment_Transform_SalesOrderDetailKey] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/03/2010  RLifke       Initial Creation
--			10/26/2011  KMurdoch	 Added exception message
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

 	SET @TableName = N'[bi_cms_dds].[DimAccumulatorAdjustment]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY
					-- Set the Current Extraction Time & Status
				UPDATE [bief_stage].[_DataFlow]
					SET CET = GETDATE()
						, [Status] = 'Extracting-s'
					WHERE [TableName] = @TableName



		-----------------------
		-- Update [SalesOrderDetailKey]
		-----------------------
		UPDATE STG SET
		     [SalesOrderDetailKey] = DW.[SalesOrderDetailKey]
		FROM [bi_cms_stage].[DimAccumulatorAdjustment] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderDetail] DW ON
				DW.[SalesOrderDetailSSID] = STG.[SalesOrderDetailSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Fix [SalesOrderDetailKey]
		-----------------------
		UPDATE STG SET
		     [SalesOrderDetailKey] = -1
		     , [SalesOrderDetailSSID] = CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')  -- Not Assigned
		FROM [bi_cms_stage].[DimAccumulatorAdjustment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SalesOrderDetailKey] IS NULL

		-----------------------
		-- Fix [SalesOrderDetailSSID]
		-----------------------
		UPDATE STG SET
		     [SalesOrderDetailKey] = -1
		     , [SalesOrderDetailSSID] = CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')  -- Not Assigned
		FROM [bi_cms_stage].[DimAccumulatorAdjustment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalesOrderDetailSSID] IS NULL
				 )

		-----------------------
		-- Exception if [SalesOrderDetailSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'SalesOrderDetailSSID is null - DAccAdj_Trans_Lkup'
		FROM [bi_cms_stage].[DimAccumulatorAdjustment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalesOrderDetailSSID] IS NULL
				 )

		-----------------------
		-- Exception if [SalesOrderDetailKey]IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'SalesOrderDetailKey is null - DAccAdj_Trans_Lkup'
		FROM [bi_cms_stage].[DimAccumulatorAdjustment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SalesOrderDetailKey] IS NULL







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
