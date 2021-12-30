/* CreateDate: 05/03/2010 12:26:27.730 , ModifyDate: 05/03/2010 12:26:27.730 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimActivityDemographic_Transform_AgeRange]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_DimActivityDemographic_Transform_AgeRange] is used to determine
-- the AgeRangeKey foreign key values in the DimActivityDemographic table using DimAgeRange.
--
--
--   exec [bi_mktg_stage].[spHC_DimActivityDemographic_Transform_AgeRange] -1
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

 	SET @TableName = N'[bi_mktg_dds].[DimAgeRange]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		-----------------------
		-- Update AgeRangeSSID based upon age
		-----------------------
		UPDATE STG SET
				STG.[AgeRangeSSID]	 = CASE
										WHEN Age IS NULL THEN -2
										WHEN Age < 18 THEN 1
										WHEN Age >= 18 AND Age <= 24 THEN 2
										WHEN Age >= 25 AND Age <= 34 THEN 3
										WHEN Age >= 35 AND Age <= 44 THEN 4
										WHEN Age >= 45 AND Age <= 54 THEN 5
										WHEN Age >= 55 AND Age <= 64 THEN 6
										WHEN Age > 64 THEN 7
										ELSE -2
									END
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey


		------------------------
		-- There might be some other load that just added them
		-- Update [AgeRangeKey] Keys in STG
		------------------------
		UPDATE STG SET
				 [AgeRangeDescription] = COALESCE(DW.[AgeRangeDescription], '')
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimAgeRange] DW ON
				DW.[AgeRangeSSID] = STG.[AgeRangeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE  STG.[AgeRangeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Fix [AgeRangeSSID]
		-----------------------
		UPDATE STG SET
			   [AgeRangeSSID] = -2
			 , [AgeRangeDescription] = 'Unknown'
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[AgeRangeSSID] IS NULL )

		-----------------------
		-- Exception if [AgeRangeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[AgeRangeSSID] IS NULL




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
