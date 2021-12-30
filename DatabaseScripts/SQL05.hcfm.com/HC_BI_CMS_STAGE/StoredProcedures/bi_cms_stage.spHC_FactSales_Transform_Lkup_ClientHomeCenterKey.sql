/* CreateDate: 05/03/2010 12:20:28.143 , ModifyDate: 10/26/2011 11:29:19.467 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactSales_Transform_Lkup_ClientHomeCenterKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [sspHC_FactSales_Transform_Lkup_ClientHomeCenterKey] is used to determine
-- the ClientHomeCenterKey foreign key values in the FactSales table using DimCenter.
--
--
--   exec [bi_cms_stage].[spHC_FactSales_Transform_Lkup_ClientHomeCenterKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011  KMurdoch     Added Exception Message
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


 	-- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY


		-----------------------
		-- Found an instance where the ClientHomeCenter number was not numeric
		-- so fix this first
		-----------------------
		UPDATE STG SET
		       [ClientHomeCenterKey]  = -1
		     , [ClientHomeCenterSSID] = -2
		FROM [bi_cms_stage].[FactSales] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (ISNUMERIC(STG.[ClientHomeCenterSSID]) <> 1)


		------------------------
		-- There might be some other load that just added them
		-- Update [ClientHomeCenterKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [ClientHomeCenterKey] = COALESCE(DW.[CenterKey], 0)
		FROM [bi_cms_stage].[FactSales] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimCenter] DW  WITH (NOLOCK)
			ON DW.[CenterSSID] = STG.[ClientHomeCenterSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[ClientHomeCenterKey], 0) = 0
			AND STG.[ClientHomeCenterSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactSales_LoadInferred_DimCenter_ClientHomeCenter] @DataPkgKey


		-- Update ClientHomeCenter Keys in STG
		UPDATE STG SET
		     [ClientHomeCenterKey] = COALESCE(DW.[CenterKey], 0)
		FROM [bi_cms_stage].[FactSales] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimCenter] DW  WITH (NOLOCK)
			ON DW.[CenterSSID] = STG.[ClientHomeCenterSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[ClientHomeCenterKey], 0) = 0
			AND STG.[ClientHomeCenterSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [ClientHomeCenterKey]
		-----------------------
		UPDATE STG SET
		     [ClientHomeCenterKey] = -1
		FROM [bi_cms_stage].[FactSales] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ClientHomeCenterKey] IS NULL

		-----------------------
		-- Fix [ClientHomeCenterSSID]
		-----------------------
		UPDATE STG SET
		       [ClientHomeCenterKey]  = -1
		     , [ClientHomeCenterSSID] = -2
		FROM [bi_cms_stage].[FactSales] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[ClientHomeCenterSSID] IS NULL )

		-----------------------
		-- Exception if [ClientHomeCenterSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'ClientHomeCenterSSID is null - FSales_Trans_Lkup'
		FROM [bi_cms_stage].[FactSales] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ClientHomeCenterSSID] IS NULL


		-----------------------
		-- Exception if [ClientHomeCenterKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'ClientHomeCenterKey is null - FSales_Trans_Lkup'
		FROM [bi_cms_stage].[FactSales] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[ClientHomeCenterKey] IS NULL
				OR STG.[ClientHomeCenterKey] = 0)


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
