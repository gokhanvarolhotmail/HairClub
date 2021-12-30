/* CreateDate: 05/03/2010 12:20:28.333 , ModifyDate: 05/03/2010 12:20:28.333 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactSales_Transform_SetIsNewUpdDel]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactSales_Transform_SetIsNewUpdDel] is used to determine
-- the SetIsNewUpdDel
--
--
--   exec [bi_cms_stage].[spHC_FactSales_Transform_SetIsNewUpdDel] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
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

	DECLARE		@TableName			varchar(150)	-- Name of table
	DECLARE		@DataPkgDetailKey	int

 	SET @TableName = N'[bi_cms_dds].[FactSales]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		-----------------------
		-- For Fact tables, only load Closed NonVoided
		-- Exception if [IsVoided] IS 1
		-- or [IsClosed] is 0
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_cms_stage].[FactSales] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[IsClosed] = 0
				OR STG.[IsVoided] = 1)

		-----------------------
		-- Check for new and existing rows
		-----------------------
		UPDATE STG SET
			IsNew = CASE WHEN DW.[SalesOrderKey] IS NULL
					THEN 1 ELSE 0 END
			,IsUpdate = CASE WHEN DW.[SalesOrderKey] IS NOT NULL
					THEN 1 ELSE 0 END

		FROM [bi_cms_stage].[FactSales] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_FactSales] DW ON
				DW.[SalesOrderKey] = STG.[SalesOrderKey]
		WHERE STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  SalesOrderSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY SalesOrderSSID ORDER BY SalesOrderSSID ) AS RowNum
			   FROM  [bi_cms_stage].[FactSales] STG
			   WHERE IsNew = 1
			   AND STG.[DataPkgKey] = @DataPkgKey

			)

			UPDATE STG SET
				IsDuplicate = 1
			FROM Duplicates STG
			WHERE   RowNum > 1


		-----------------------
		-- Check for deleted rows
		-----------------------
		UPDATE STG SET
				IsDelete = CASE WHEN COALESCE(STG.[CDC_Operation],'') = 'D'
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[FactSales] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey

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
