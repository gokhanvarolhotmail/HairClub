/* CreateDate: 05/03/2010 12:19:56.783 , ModifyDate: 05/03/2010 12:19:56.783 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimClient_Transform_SalutationKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimClient_Transform_SalutationKey] is used to
--  transform SalutationKey
--
--
--   exec [bi_cms_stage].[spHC_DimClient_Transform_SalutationKey] 422
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

 	SET @TableName = N'[bi_cms_dds].[DimClient]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY




		-----------------------
		-- Fix [SalutationSSID]
		-----------------------
		UPDATE STG SET
		     [SalutationSSID] = -2  -- Not Assigned
		FROM [bi_cms_stage].[DimClient] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalutationSSID] IS NULL
			OR	STG.[SalutationSSID] = '' )

		-----------------------
		-- Exception if [SalutationSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_cms_stage].[DimClient] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalutationSSID] IS NULL
			OR	STG.[SalutationSSID] = '' )







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
