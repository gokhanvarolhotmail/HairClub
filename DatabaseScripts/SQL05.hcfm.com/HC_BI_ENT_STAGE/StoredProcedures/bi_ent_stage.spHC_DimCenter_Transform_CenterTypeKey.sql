/* CreateDate: 05/03/2010 12:09:51.273 , ModifyDate: 05/03/2010 12:09:51.273 */
GO
CREATE PROCEDURE [bi_ent_stage].[spHC_DimCenter_Transform_CenterTypeKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimCenter_Transform_CenterTypeKey] is used to
--  transform CenterTypeKey
--
--
--   exec [bi_ent_stage].[spHC_DimCenter_Transform_CenterTypeKey] 422
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

 	SET @TableName = N'[bi_ent_dds].[DimCenter]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY


		-----------------------
		-- Update CenterTypeKey
		-----------------------
		UPDATE STG SET
		     [CenterTypeKey] = DW.[CenterTypeKey]
		FROM [bi_ent_stage].[DimCenter] STG
		LEFT OUTER JOIN [bi_ent_stage].[synHC_DDS_DimCenterType] DW ON
				DW.[CenterTypeSSID] = STG.[CenterTypeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Fix CenterTypeKey
		-----------------------
		UPDATE STG SET
		     [CenterTypeKey] = -1
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[CenterTypeKey] IS NULL

		-----------------------
		-- Fix [CenterTypeSSID]
		-----------------------
		UPDATE STG SET
		     [CenterTypeSSID] = -2  -- Not Assigned
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[CenterTypeSSID] IS NULL
			OR	STG.[CenterTypeSSID] = '' )

		-----------------------
		-- Exception if [CenterTypeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[CenterTypeSSID] IS NULL
			OR	STG.[CenterTypeSSID] = '' )

		-----------------------
		-- Exception if [CenterTypeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[CenterTypeKey] IS NULL






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
