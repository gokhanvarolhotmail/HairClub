/* CreateDate: 10/05/2010 14:04:36.640 , ModifyDate: 10/05/2010 14:04:36.640 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimClientMembershipAccum_Transform_AccumulatorKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimClientMembershipAccum_Transform_AccumulatorKey] is used to
--  transform AccumulatorKey
--
--
--   exec [bi_cms_stage].[spHC_DimClientMembershipAccum_Transform_AccumulatorKey] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/03/2010  RLifke       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[DimClientMembershipAccum]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY


		-----------------------
		-- Update [AccumulatorKey]
		-----------------------
		UPDATE STG SET
		     [AccumulatorKey] = DW.[AccumulatorKey]
		FROM [bi_cms_stage].[DimClientMembershipAccum] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimAccumulator] DW ON
				DW.[AccumulatorSSID] = STG.[AccumulatorSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Fix [AccumulatorKey]
		-----------------------
		UPDATE STG SET
		     [AccumulatorKey] = -1
		FROM [bi_cms_stage].[DimClientMembershipAccum] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[AccumulatorKey] IS NULL

		-----------------------
		-- Fix [AccumulatorSSID]
		-----------------------
		UPDATE STG SET
		     [AccumulatorSSID] = -2  -- Not Assigned
		FROM [bi_cms_stage].[DimClientMembershipAccum] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[AccumulatorSSID] IS NULL
			OR	STG.[AccumulatorSSID] = '' )

		-----------------------
		-- Exception if [AccumulatorSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_cms_stage].[DimClientMembershipAccum] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[AccumulatorSSID] IS NULL
			OR	STG.[AccumulatorSSID] = '' )

		-----------------------
		-- Exception if [AccumulatorKey]IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_cms_stage].[DimClientMembershipAccum] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[AccumulatorKey] IS NULL






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
