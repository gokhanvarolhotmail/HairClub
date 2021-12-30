/* CreateDate: 05/03/2010 12:09:51.260 , ModifyDate: 05/03/2010 12:09:51.260 */
GO
CREATE PROCEDURE [bi_ent_stage].[spHC_DimCenter_Transform_CenterOwnershipKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimCenter_Transform_CenterOwnershipKey] is used to
--  transform CenterOwnershipKey
--
--
--   exec [bi_ent_stage].[spHC_DimCenter_Transform_CenterOwnershipKey] 422
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
		-- Update CenterOwnershipKey
		-----------------------
		UPDATE STG SET
		     [CenterOwnershipKey] = DW.[CenterOwnershipKey]
		FROM [bi_ent_stage].[DimCenter] STG
		LEFT OUTER JOIN [bi_ent_stage].[synHC_DDS_DimCenterOwnership] DW ON
				DW.[CenterOwnershipSSID] = STG.[CenterOwnershipSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Fix CenterOwnershipKey
		-----------------------
		UPDATE STG SET
		     [CenterOwnershipKey] = -1
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[CenterOwnershipKey] IS NULL

		-----------------------
		-- Fix [CenterOwnershipSSID]
		-----------------------
		UPDATE STG SET
		     [CenterOwnershipSSID] = -2   --Not Assigned
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[CenterOwnershipSSID] IS NULL
			OR	STG.[CenterOwnershipSSID] = '' )

		-----------------------
		-- Exception if [CenterOwnershipSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[CenterOwnershipSSID] IS NULL
			OR	STG.[CenterOwnershipSSID] = '' )

		-----------------------
		-- Exception if [CenterOwnershipKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[CenterOwnershipKey] IS NULL






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
