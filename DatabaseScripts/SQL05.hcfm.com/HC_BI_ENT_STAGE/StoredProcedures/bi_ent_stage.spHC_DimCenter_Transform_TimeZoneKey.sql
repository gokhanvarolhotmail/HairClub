/* CreateDate: 05/03/2010 12:09:51.337 , ModifyDate: 05/03/2010 12:09:51.337 */
GO
CREATE PROCEDURE [bi_ent_stage].[spHC_DimCenter_Transform_TimeZoneKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimCenter_Transform_TimeZoneKey] is used to
--  transform TimeZoneKey
--
--
--   exec [bi_ent_stage].[spHC_DimCenter_Transform_TimeZoneKey] 422
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
		-- Update TimeZoneKey
		-----------------------
		UPDATE STG SET
		     [TimeZoneKey] = DW.[TimeZoneKey]
		FROM [bi_ent_stage].[DimCenter] STG
		LEFT OUTER JOIN [bi_ent_stage].[synHC_DDS_DimTimeZone] DW ON
				DW.[TimeZoneSSID] = STG.[TimeZoneSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [TimeZoneKey]
		-----------------------
		UPDATE STG SET
		     [TimeZoneKey] = -1
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[TimeZoneKey] IS NULL

		-----------------------
		-- Fix [TimeZoneSSID]
		-----------------------
		UPDATE STG SET
		     [TimeZoneSSID] = -2  --Not Assigned
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[TimeZoneSSID] IS NULL
			OR	STG.[TimeZoneSSID] = '' )

		-----------------------
		-- Exception if [TimeZoneSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[TimeZoneSSID] IS NULL
			OR	STG.[TimeZoneSSID] = '' )

		-----------------------
		-- Exception if [TimeZoneKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[TimeZoneKey] IS NULL






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
