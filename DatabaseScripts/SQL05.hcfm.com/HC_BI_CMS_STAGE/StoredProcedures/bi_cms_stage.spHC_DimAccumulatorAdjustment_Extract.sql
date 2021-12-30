/* CreateDate: 10/05/2010 14:04:31.103 , ModifyDate: 01/03/2013 14:34:35.170 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimAccumulatorAdjustment_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimAccumulatorAdjustment_Extract] is used to retrieve a
-- list Accumulator
--
--   exec [bi_cms_stage].[spHC_DimAccumulatorAdjustment_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/03/2010  RLifke       Initial Creation
--			07/16/2011	KMurdoch	 Added UTC function to DateAdjust & Original
--			10/4/2011	KMurdoch	 Removed UTC Function from DateAdjust & Original
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

 	SET @TableName = N'[bi_cms_dds].[DimAccumulatorAdjustment]'


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

				INSERT INTO [bi_cms_stage].[DimAccumulatorAdjustment]
							( [DataPkgKey]
							, [AccumulatorAdjustmentKey]
							, [AccumulatorAdjustmentSSID]
							, [ClientMembershipKey]
							, [ClientMembershipSSID]
							, [SalesOrderDetailKey]
							, [SalesOrderDetailSSID]
							, [AppointmentKey]
							, [AppointmentSSID]
							, [AccumulatorKey]
							, [AccumulatorSSID]
							, [AccumulatorDescription]
							, [AccumulatorDescriptionShort]
						    , [QuantityUsedOriginal]
						    , [QuantityUsedAdjustment]
						    , [QuantityTotalOriginal]
						    , [QuantityTotalAdjustment]
						    , [MoneyOriginal]
						    , [MoneyAdjustment]
						    , [DateOriginal]
						    , [DateAdjustment]
						    , [QuantityUsedNew]
						    , [QuantityUsedChange]
						    , [QuantityTotalNew]
						    , [QuantityTotalChange]
						    , [MoneyNew]
						    , [MoneyChange]

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
						, NULL AS [AccumulatorAdjustmentKey]
						, acc.[AccumulatorAdjustmentGUID] AS [AccumulatorAdjustmentSSID]
						, NULL AS [ClientMembershipKey]
						, COALESCE(acc.[ClientMembershipGUID], '00000000-0000-0000-0000-000000000002') AS [ClientMembershipSSID]
						, NULL AS [SalesOrderDetailKey]
						, COALESCE(acc.[SalesOrderDetailGUID], '00000000-0000-0000-0000-000000000002') AS [SalesOrderDetailSSID]
						, -1 AS [AppointmentKey]
						, COALESCE(acc.[AppointmentGUID], '00000000-0000-0000-0000-000000000002') AS [AppointmentSSID]
						, NULL AS [AccumulatorKey]
						, acc.[AccumulatorID] AS [AccumulatorSSID]
						, CAST(ISNULL(LTRIM(RTRIM(acd.[AccumulatorDescription])),'') AS varchar(50)) AS [AccumulatorDescription]
						, CAST(ISNULL(LTRIM(RTRIM(acd.[AccumulatorDescriptionShort])),'') AS varchar(10)) AS [AccumulatorDescriptionShort]
						, COALESCE(acc.[QuantityUsedOriginal],0) AS [QuantityUsedOriginal]
						, COALESCE(acc.[QuantityUsedAdjustment],0) AS [QuantityUsedAdjustment]
						, COALESCE(acc.[QuantityTotalOriginal],0) AS [QuantityTotalOriginal]
						, COALESCE(acc.[QuantityTotalAdjustment],0) AS [QuantityTotalAdjustment]
						, COALESCE(acc.[MoneyOriginal],0.0) AS [MoneyOriginal]
						, COALESCE(acc.[MoneyAdjustment],0.0) AS [MoneyAdjustment]
						--, COALESCE([bief_stage].[fn_GetUTCDateTime](acc.[DateOriginal],so.[CenterID]),'1/1/1753') AS [DateOriginal]
						--, COALESCE([bief_stage].[fn_GetUTCDateTime](acc.[DateAdjustment],so.[CenterID]),'1/1/1753') AS [DateAdjustment]
						, COALESCE(acc.[DateOriginal],'1/1/1753') AS [DateOriginal]
						, COALESCE(convert(date,convert(varchar,[bief_stage].[fn_GetUTCDateTime](acc.[CreateDate],so.[CenterID]),101)),'1/1/1753') AS [DateAdjustment]
						, COALESCE(acc.[QuantityUsedNewCalc],0) AS [QuantityUsedNew]
						, COALESCE(acc.[QuantityUsedChangeCalc],0) AS [QuantityUsedChange]
						, COALESCE(acc.[QuantityTotalNewCalc],0) AS [QuantityTotalNew]
						, COALESCE(acc.[QuantityTotalChangeCalc],0) AS [QuantityTotalChange]
						, COALESCE(acc.[MoneyNewCalc],0.0) AS [MoneyNew]
						, COALESCE(acc.[MoneyChangeCalc],0.0) AS [MoneyChange]
						, acc.[LastUpdate] AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, CAST(ISNULL(LTRIM(RTRIM([AccumulatorAdjustmentGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM [bi_cms_stage].[synHC_SRC_TBL_CMS_datAccumulatorAdjustment] acc
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_cfgAccumulator] acd
							ON acc.[AccumulatorID] = acd.[AccumulatorID]
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrderDetail] sod
							ON acc.[SalesOrderDetailGUID] = sod.[SalesOrderDetailGUID]
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrder] so
							ON sod.SalesOrderGUID = so.SalesOrderGUID


				WHERE (acc.[CreateDate] >= @LSET AND acc.[CreateDate] < @CET_UTC)
				   OR (acc.[LastUpdate] >= @LSET AND acc.[LastUpdate] < @CET_UTC)

				--OR  (acc.[CreateDate] IS NULL)   -- Use on initial Load

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
