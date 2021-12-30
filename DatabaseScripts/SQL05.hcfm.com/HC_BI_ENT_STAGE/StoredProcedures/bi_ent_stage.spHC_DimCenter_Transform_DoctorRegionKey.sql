/* CreateDate: 05/03/2010 12:09:51.290 , ModifyDate: 05/03/2010 12:09:51.290 */
GO
CREATE PROCEDURE [bi_ent_stage].[spHC_DimCenter_Transform_DoctorRegionKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimCenter_Transform_DoctorRegionKey] is used to
--  transform DoctorRegionKey
--
--
--   exec [bi_ent_stage].[spHC_DimCenter_Transform_DoctorRegionKey] 422
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
		-- Update DoctorRegionKey
		-----------------------
		UPDATE STG SET
		     [DoctorRegionKey] = DW.[DoctorRegionKey]
		FROM [bi_ent_stage].[DimCenter] STG
		LEFT OUTER JOIN [bi_ent_stage].[synHC_DDS_DimDoctorRegion] DW ON
				DW.[DoctorRegionSSID] = STG.[DoctorRegionSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Fix DoctorRegionKey
		-----------------------
		UPDATE STG SET
		     [DoctorRegionKey] = -1
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[DoctorRegionKey] IS NULL

		-----------------------
		-- Fix [DoctorRegionSSID]
		-----------------------
		UPDATE STG SET
		     [DoctorRegionSSID] = -2 --Not Assigned
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[DoctorRegionSSID] IS NULL
			OR	STG.[DoctorRegionSSID] = '' )

		-----------------------
		-- Exception if [DoctorRegionSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[DoctorRegionSSID] IS NULL
			OR	STG.[DoctorRegionSSID] = '' )

		-----------------------
		-- Exception if [DoctorRegionKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[DoctorRegionKey] IS NULL






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
