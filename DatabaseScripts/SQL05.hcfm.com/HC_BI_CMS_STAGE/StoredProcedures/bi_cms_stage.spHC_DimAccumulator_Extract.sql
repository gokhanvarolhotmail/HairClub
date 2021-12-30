/* CreateDate: 05/03/2010 12:19:50.383 , ModifyDate: 01/03/2013 14:24:49.293 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimAccumulator_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimAccumulator_Extract] is used to retrieve a
-- list Accumulator
--
--   exec [bi_cms_stage].[spHC_DimAccumulator_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/01/2009  RLifke       Initial Creation
--			01/03/2013  EKnapp       Use UTC Current Extraction Time.
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
				, @ExtractRowCnt		int
				, @CET_UTC              datetime

 	SET @TableName = N'[bi_cms_dds].[DimAccumulator]'


	BEGIN TRY

	   -- Put parameters in name value list to aid in reporting
		EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@LSET'
				, @LSET
				, N'@CET'
				, @CET

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_ExtractStart] @DataPkgKey, @TableName, @LSET, @CET

		IF (@CET IS NOT NULL) AND (@LSET IS NOT NULL)
			BEGIN

				-- Set the Current Extraction Time & Status
				UPDATE [bief_stage].[_DataFlow]
					SET CET = @CET
						, [Status] = 'Extracting'
					WHERE [TableName] = @TableName

			-- Convert our Current Extraction Time to UTC time for compare in the Where clause to ensure we pick up latest data.
				SELECT @CET_UTC = [bief_stage].[fn_CorporateToUTCDateTime](@CET)

				INSERT INTO [bi_cms_stage].[DimAccumulator]
							( [DataPkgKey]
							, [AccumulatorKey]
							, [AccumulatorSSID]
							, [AccumulatorDescription]
							, [AccumulatorDescriptionShort]
							, [AccumulatorDataTypeSSID]
							, [AccumulatorDataTypeDescription]
							, [AccumulatorDataTypeDescriptionShort]
							, [SchedulerActionTypeSSID]
							, [SchedulerActionTypeDescription]
							, [SchedulerActionTypeDescriptionShort]
							, [SchedulerAdjustmentTypeSSID]
							, [SchedulerAdjustmentTypeDescription]
							, [SchedulerAdjustmentTypeDescriptionShort]
							, [ModifiedDate]
							, [IsNew]
							, [IsType1]
							, [IsType2]
							, [IsException]
							, [IsInferredMember]
							, [IsDelete]
							, [IsDuplicate]
							, [SourceSystemKey]
							)
				SELECT @DataPkgKey
						, NULL AS [AccumulatorKey]
						, [AccumulatorID] AS [AccumulatorSSID]
						, CAST(ISNULL(LTRIM(RTRIM([AccumulatorDescription])),'') AS nvarchar(50)) AS [AccumulatorDescription]
						, CAST(ISNULL(LTRIM(RTRIM([AccumulatorDescriptionShort])),'') AS nvarchar(10)) AS [AccumulatorDescriptionShort]
						, COALESCE(acc.[AccumulatorDataTypeID], -2) AS [AccumulatorDataTypeSSID]
						, CAST(ISNULL(LTRIM(RTRIM([AccumulatorDataTypeDescription])),'') AS nvarchar(50)) AS [AccumulatorDataTypeDescription]
						, CAST(ISNULL(LTRIM(RTRIM([AccumulatorDataTypeDescriptionShort])),'') AS nvarchar(10)) AS [AccumulatorDataTypeDescriptionShort]
						, COALESCE(acc.[SchedulerActionTypeID], -2) AS [SchedulerActionTypeSSID]
						, CAST(ISNULL(LTRIM(RTRIM(accact.[AccumulatorActionTypeDescription])),'') AS nvarchar(50)) AS [AccumulatorActionTypeDescription]
						, CAST(ISNULL(LTRIM(RTRIM(accact.[AccumulatorActionTypeDescriptionShort])),'') AS nvarchar(10)) AS [AccumulatorActionTypeDescriptionShort]
						, COALESCE(acc.[SchedulerAdjustmentTypeID], -2) AS [SchedulerAdjustmentTypeSSID]
						, CAST(ISNULL(LTRIM(RTRIM(acca.[AccumulatorAdjustmentTypeDescription])),'') AS nvarchar(50)) AS [AccumulatorAdjustmentTypeDescription]
						, CAST(ISNULL(LTRIM(RTRIM(acca.[AccumulatorAdjustmentTypeDescriptionShort])),'') AS nvarchar(10)) AS [AccumulatorAdjustmentTypeDescriptionShort]
						, acc.[LastUpdate] AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, CAST(ISNULL(LTRIM(RTRIM([AccumulatorID])),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM [bi_cms_stage].[synHC_SRC_TBL_CMS_cfgAccumulator] acc
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpAccumulatorDataType] acd
							ON acc.[AccumulatorDataTypeID] = acd.[AccumulatorDataTypeID]
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpAccumulatorActionType] accact
							ON acc.[AccumulatorDataTypeID] = accact.[AccumulatorActionTypeID]
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpAccumulatorAdjustmentType] acca
							ON acc.[AccumulatorDataTypeID] = acca.[AccumulatorAdjustmentTypeID]
				WHERE (acc.[CreateDate] >= @LSET AND acc.[CreateDate] < @CET_UTC)
				   OR (acc.[LastUpdate] >= @LSET AND acc.[LastUpdate] < @CET_UTC)

				SET @ExtractRowCnt = @@ROWCOUNT

				-- Set the Last Successful Extraction Time & Status
				UPDATE [bief_stage].[_DataFlow]
					SET LSET = @CET
						, [Status] = 'Extraction Completed'
					WHERE [TableName] = @TableName
		END

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_ExtractStop] @DataPkgKey, @TableName, @ExtractRowCnt

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
