/* CreateDate: 05/03/2010 12:26:27.747 , ModifyDate: 05/03/2010 12:26:27.747 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimActivityDemographic_Transform_HairLossType]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_DimActivityDemographic_Transform_HairLossType] is used to determine
-- the HairLossType foreign key values in the DimActivityDemographic table using DimHairLossType.
--
--
--   exec [bi_mktg_stage].[spHC_DimActivityDemographic_Transform_HairLossType] -1
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

 	SET @TableName = N'[bi_mktg_dds].[DimHairLossType]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY



		-----------------------
		-- Update HairLossTypeSSID based upon Norwood
		-----------------------
		UPDATE STG SET
				STG.[HairLossTypeSSID]	 = STG.[NorwoodSSID]
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[NorwoodSSID] <> 'Unknown'
		AND STG.[NorwoodSSID] <> '0'
		AND LEN(STG.[NorwoodSSID]) > 0

		-----------------------
		-- Update HairLossTypeSSID based upon Ludwig
		-----------------------
		UPDATE STG SET
				STG.[HairLossTypeSSID]	 = STG.[LudwigSSID]
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[LudwigSSID] <> 'Unknown'
		AND STG.[LudwigSSID] <> '0'
		AND LEN(STG.[LudwigSSID]) > 0

		-----------------------
		-- Update HairLossTypeSSID
		-----------------------
		UPDATE STG SET
				STG.[HairLossTypeSSID] = -2
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[NorwoodSSID] = ''
		AND STG.[LudwigSSID] = ''

		-----------------------
		-- Update HairLossTypeSSID
		-----------------------
		UPDATE STG SET
				STG.[HairLossTypeSSID] = -2
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[NorwoodSSID] = '0'
		AND STG.[LudwigSSID] = '0'

		------------------------
		-- There might be some other load that just added them
		-- Update [HairLossType] Keys in STG
		------------------------
		UPDATE STG SET
				 [HairLossTypeDescription] = COALESCE(DW.[HairLossTypeDescription], '')
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimHairLossType] DW ON
				DW.[HairLossTypeSSID] = STG.[HairLossTypeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE  STG.[HairLossTypeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Fix [HairLossTypeSSID]
		-----------------------
		UPDATE STG SET
			   [HairLossTypeSSID] = -2
			 , [HairLossTypeDescription] = 'Unknown'
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[HairLossTypeSSID] IS NULL )

		-----------------------
		-- Exception if [HairLossTypeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[HairLossTypeSSID] IS NULL




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
