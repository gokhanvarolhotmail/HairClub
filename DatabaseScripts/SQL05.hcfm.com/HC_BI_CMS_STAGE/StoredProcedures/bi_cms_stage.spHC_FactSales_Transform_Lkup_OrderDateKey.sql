/* CreateDate: 05/03/2010 12:20:28.253 , ModifyDate: 10/26/2011 11:32:05.020 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactSales_Transform_Lkup_OrderDateKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactSales_Transform_Lkup_eadCreationDateKey] is used to determine
-- which records have late arriving dimensions and adds them
--
--
--   exec [bi_cms_stage].[spHC_FactSales_Transform_Lkup_OrderDateKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011  KMurdoch     Added exception Mesage
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

		------------------------
		-- Update [DateKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [OrderDateKey] = COALESCE(DW.[DateKey], 0)
		FROM [bi_cms_stage].[FactSales] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimDate] DW  WITH (NOLOCK)
			ON DW.[ISODate] = CONVERT(char(8),STG.[OrderDate],112)
		WHERE COALESCE(STG.[OrderDateKey], 0) = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		----------------------------------------------------------------------
		-- DO NOT ADD Inferred Members  use the DimDate_Populate SP
		-- to add dates to the DimDate table
		----------------------------------------------------------------------






		-----------------------
		-- Exception if [OrderDate] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'OrderDate is null - FSales_Trans_Lkup'
		FROM [bi_cms_stage].[FactSales] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[OrderDate] IS NULL


		-----------------------
		-- Exception if [OrderDateKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'OrderDateKey is null - FSales_Trans_Lkup'
		FROM [bi_cms_stage].[FactSales] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[OrderDateKey] IS NULL
				OR STG.[OrderDateKey] = 0)



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
