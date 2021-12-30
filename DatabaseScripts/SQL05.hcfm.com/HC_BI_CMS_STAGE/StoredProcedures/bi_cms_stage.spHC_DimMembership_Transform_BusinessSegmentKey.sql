/* CreateDate: 05/03/2010 12:20:01.147 , ModifyDate: 05/03/2010 12:20:01.147 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimMembership_Transform_BusinessSegmentKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimMembership_Transform_BusinessSegmentKey] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_cms_stage].[spHC_DimMembership_Transform_BusinessSegmentKey] 422
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

 	SET @TableName = N'[bi_cms_dds].[DimMembership]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY


		-----------------------
		-- Update BusinessSegmentKey
		-----------------------
		UPDATE STG SET
		     [BusinessSegmentKey] = DW.[BusinessSegmentKey]
		FROM [bi_cms_stage].[DimMembership] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimBusinessSegment] DW ON
				DW.[BusinessSegmentSSID] = STG.[BusinessSegmentSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [BusinessSegmentKey]
		-----------------------
		UPDATE STG SET
		     [BusinessSegmentKey] = -1
		FROM [bi_cms_stage].[DimMembership] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[BusinessSegmentKey] IS NULL

		-----------------------
		-- Fix [BusinessSegmentSSID]
		-----------------------
		UPDATE STG SET
		     [BusinessSegmentKey] = -1
		     , [BusinessSegmentSSID] = -2
		FROM [bi_cms_stage].[DimMembership] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[BusinessSegmentSSID] IS NULL
			OR	STG.[BusinessSegmentSSID] = '' )

		-----------------------
		-- Exception if BusinessSegmentSSID IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_cms_stage].[DimMembership] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[BusinessSegmentSSID] IS NULL
			OR	STG.[BusinessSegmentSSID] = '' )


		-----------------------
		-- Exception if [BusinessSegmentKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_cms_stage].[DimMembership] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[BusinessSegmentKey] IS NULL


		-----------------------
		-- Update GenderSSID if it is not assigned
		-----------------------
		UPDATE STG SET
		     [GenderSSID] = -2    -- Not Assigned
		FROM [bi_cms_stage].[DimMembership] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[GenderSSID] IS NULL

		-----------------------
		-- Update RevenueGroupSSID if it is not assigned
		-----------------------
		UPDATE STG SET
		     [RevenueGroupSSID] = -2    -- Not Assigned
		FROM [bi_cms_stage].[DimMembership] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[RevenueGroupSSID] IS NULL


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
