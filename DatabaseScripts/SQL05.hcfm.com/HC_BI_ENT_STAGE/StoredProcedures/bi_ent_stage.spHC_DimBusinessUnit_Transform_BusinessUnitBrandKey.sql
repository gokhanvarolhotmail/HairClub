/* CreateDate: 05/03/2010 12:09:44.637 , ModifyDate: 03/26/2018 15:51:44.650 */
GO
CREATE PROCEDURE [bi_ent_stage].[spHC_DimBusinessUnit_Transform_BusinessUnitBrandKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimBusinessUnit_Transform_BusinessUnitBrandKey] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_ent_stage].[spHC_DimBusinessUnit_Transform_BusinessUnitBrandKey] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/25/2009  RLifke       Initial Creation
--			03/26/2018  KMurdoch	 commented out code
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

 	SET @TableName = N'[bi_ent_dds].[DimBusinessUnit]'
/*
	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY


		-----------------------
		-- Update BusinessUnitBrandKey
		-----------------------
		UPDATE STG SET
		     [BusinessUnitBrandKey] = DW.[BusinessUnitBrandKey]
		FROM [bi_ent_stage].[DimBusinessUnit] STG
		LEFT OUTER JOIN [bi_ent_stage].[synHC_DDS_DimBusinessUnitBrand] DW ON
				DW.[BusinessUnitBrandSSID] = STG.[BusinessUnitBrandSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Exception if BusinessUnitBrandSSID IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_ent_stage].[DimBusinessUnit] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[BusinessUnitBrandSSID] IS NULL


		-----------------------
		-- Exception if BusinessUnitBrandKey IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_ent_stage].[DimBusinessUnit] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[BusinessUnitBrandKey] IS NULL




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
*/

END
GO
