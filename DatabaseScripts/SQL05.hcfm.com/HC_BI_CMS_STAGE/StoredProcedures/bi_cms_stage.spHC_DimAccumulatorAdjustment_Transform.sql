/* CreateDate: 10/05/2010 14:04:33.747 , ModifyDate: 04/09/2015 12:11:35.280 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimAccumulatorAdjustment_Transform]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimAccumulatorAdjustment_Transform] is used to transform records
--
--
--   exec [bi_cms_stage].[spHC_DimAccumulatorAdjustment_Transform] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/03/2010  RLifke       Initial Creation
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
						UPDATE [bief_stage].[_DataFlow]
					SET CET = GETDATE()
						, [Status] = 'Transform Started-before update'
					WHERE [TableName] = @TableName
		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_TransformStart] @DataPkgKey, @TableName
						-- Set the Current Extraction Time & Status
				UPDATE [bief_stage].[_DataFlow]
					SET CET = GETDATE()
						, [Status] = 'Transform Started-before cm'
					WHERE [TableName] = @TableName
		-----------------------
		-- Transform ClientMembershipKey
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DimAccumulatorAdjustment_Transform_ClientMembershipKey] @DataPkgKey
					UPDATE [bief_stage].[_DataFlow]
					SET CET = GETDATE()
						, [Status] = 'Transform Started-before s'
					WHERE [TableName] = @TableName
		-----------------------
		-- Transform SalesOrderDetailKey
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DimAccumulatorAdjustment_Transform_SalesOrderDetailKey] @DataPkgKey
							UPDATE [bief_stage].[_DataFlow]
					SET CET = GETDATE()
						, [Status] = 'Transform Started-before a'
					WHERE [TableName] = @TableName
		-----------------------
		-- Transform AccumulatorKey
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DimAccumulatorAdjustment_Transform_AccumulatorKey] @DataPkgKey
							UPDATE [bief_stage].[_DataFlow]
					SET CET = GETDATE()
						, [Status] = 'Transform Started-before n'
					WHERE [TableName] = @TableName
		-----------------------
		-- Set the ISNew and SCD fields
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DimAccumulatorAdjustment_Transform_SetIsNewSCD] @DataPkgKey


		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_TransformStop] @DataPkgKey, @TableName

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
