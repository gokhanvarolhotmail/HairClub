/* CreateDate: 08/09/2011 10:06:48.893 , ModifyDate: 08/28/2019 08:54:15.503 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimClient_Transform_ContactKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimClient_Transform_ContactKey] is used to
--  transform ContactKey
--
--
--   exec [bi_cms_stage].[spHC_DimClient_Transform_ContactKey] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/09/2011  KMurdoch       Initial Creation
--			10/04/2018  KMurdoch       Added SFDC_LeadID to update to get contactkey
--			08/07/2019  KMurdoch       Modified check for ContactSSID to SFDC_LeadID
--			08/26/2019	KMurdoch	   Set SFDC_LeadID to -2 like ContactSSID
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
		-- Update [ContactKey]
		-----------------------
		UPDATE STG SET
		     [ContactKey] = DW.[ContactKey]
		FROM [bi_cms_stage].[DimClient] STG
		INNER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimContact] DW ON
				DW.[SFDC_LeadID] = STG.[SFDC_LeadID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Fix [ContactKey]
		-----------------------
		UPDATE STG SET
		     [ContactKey] = -1
		FROM [bi_cms_stage].[DimClient] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ContactKey] IS NULL

		-----------------------
		-- Fix [ContactSSID]
		-----------------------
		UPDATE STG SET
		     [ContactSSID] = -2  -- Not Assigned
			 ,[STG].[SFDC_Leadid] = -2   -- Not Assigned
		FROM [bi_cms_stage].[DimClient] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SFDC_LeadID] IS NULL
			OR	STG.[SFDC_LeadID] = '' )

		-----------------------
		-- Exception if [ContactSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_cms_stage].[DimClient] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SFDC_LeadID] IS NULL
			OR	STG.[SFDC_LeadID] = '' )

		-----------------------
		-- Exception if [ContactKey]IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_cms_stage].[DimClient] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ContactKey] IS NULL






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
