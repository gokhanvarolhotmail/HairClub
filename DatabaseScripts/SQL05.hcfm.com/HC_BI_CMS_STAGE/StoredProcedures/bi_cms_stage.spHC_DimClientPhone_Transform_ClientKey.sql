/* CreateDate: 07/07/2017 11:37:53.753 , ModifyDate: 07/07/2017 11:37:53.753 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimClientPhone_Transform_ClientKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimClientPhone_Transform_ClientKey] is used to
--  transform ClientKey
--
--
--   exec [bi_cms_stage].[spHC_DimClientPhone_Transform_ClientKey] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/25/2009  RLifke       Initial Creation
--		    10/26/2011  KMurdoch     Added exception message
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

 	SET @TableName = N'[bi_cms_dds].[DimClientPhone]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY



		-----------------------
		-- Update [ClientKey]
		-----------------------
		UPDATE STG SET
		     [ClientKey] = DW.[ClientKey]
		FROM [bi_cms_stage].[DimClientPhone] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimClient] DW ON
				DW.[ClientSSID] = STG.[lkpClientKey_ClientSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Fix [ClientKey]
		-----------------------
		UPDATE STG SET
		     [ClientKey] = -1
		FROM [bi_cms_stage].[DimClientPhone] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ClientKey] IS NULL

		-----------------------
		-- Fix [ClientSSID]
		-----------------------
		UPDATE STG SET
				  [ClientKey] = -2
				, [lkpClientKey_ClientSSID] = CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')  -- Not Assigned
		FROM [bi_cms_stage].[DimClientPhone] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[lkpClientKey_ClientSSID] IS NULL)

		-----------------------
		-- Exception if [ClientSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'ClientSSID is null - DCLM_Lkup'
		FROM [bi_cms_stage].[DimClientPhone] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[lkpClientKey_ClientSSID] IS NULL)

		-----------------------
		-- Exception if [ClientKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'ClientKey is null - DCLM_Lkup'
		FROM [bi_cms_stage].[DimClientPhone] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ClientKey] IS NULL






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
