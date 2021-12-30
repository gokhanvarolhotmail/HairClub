/* CreateDate: 10/05/2010 14:04:33.710 , ModifyDate: 10/04/2011 11:40:55.543 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimAccumulatorAdjustment_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimAccumulatorAdjustment_Extract_CDC] is used to retrieve a
-- list Accumulator
--
--   exec [bi_cms_stage].[spHC_DimAccumulatorAdjustment_Extract_CDC]  '2009-01-01 01:00:00'
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
				, @CDCTableName			varchar(150)	-- Name of CDC table
				, @ExtractRowCnt		int

 	SET @TableName = N'[bi_cms_dds].[DimAccumulatorAdjustment]'
 	SET @CDCTableName = N'dbo_datAccumulatorAdjustment'


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

				DECLARE	@Start_Time datetime = null,
						@End_Time datetime = null,
						@row_filter_option nvarchar(30) = N'all'

				DECLARE @From_LSN binary(10), @To_LSN binary(10)

				SET @Start_Time = @LSET
				SET @End_Time = @CET

				IF (@Start_Time is null)
					SELECT @From_LSN = [HairClubCMS].[sys].[fn_cdc_get_min_lsn](@CDCTableName)
				ELSE
				BEGIN
					IF ([HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_min_lsn](@CDCTableName)) > @Start_Time) or
					   ([HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_max_lsn]()) < @Start_Time)
						SELECT @From_LSN = null
					ELSE
						SELECT @From_LSN = [HairClubCMS].[sys].[fn_cdc_increment_lsn]([HairClubCMS].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@Start_Time))
				END

				IF (@End_Time is null)
					SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_get_max_lsn]()
				ELSE
				BEGIN
					IF [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_max_lsn]()) < @End_Time
						--SELECT @To_LSN = null
						SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_get_max_lsn]()
					ELSE
						SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@End_Time)
				END

				-- Get the Actual Current Extraction Time
				SELECT @CET = [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time](@To_LSN)

				IF (@From_LSN IS NOT NULL) AND (@To_LSN IS NOT NULL) AND (@From_LSN <> [HairClubCMS].[sys].[fn_cdc_increment_lsn](@To_LSN))
					BEGIN

						-- Set the Current Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET CET = @CET
								, [Status] = 'Extracting'
							WHERE [TableName] = @TableName



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
									, [CDC_Operation]
									)
						SELECT @DataPkgKey
								, NULL AS [AccumulatorAdjustmentKey]
								, chg.[AccumulatorAdjustmentGUID] AS [AccumulatorAdjustmentSSID]
								, NULL AS [ClientMembershipKey]
								, COALESCE(chg.[ClientMembershipGUID], '00000000-0000-0000-0000-000000000002') AS [ClientMembershipSSID]
								, NULL AS [SalesOrderDetailKey]
								, COALESCE(chg.[SalesOrderDetailGUID], '00000000-0000-0000-0000-000000000002') AS [SalesOrderDetailSSID]
								, -1 AS [AppointmentKey]
								, COALESCE(chg.[AppointmentGUID], '00000000-0000-0000-0000-000000000002') AS [AppointmentSSID]
								, NULL AS [AccumulatorKey]
								, chg.[AccumulatorID] AS [AccumulatorSSID]
								, CAST(ISNULL(LTRIM(RTRIM(acd.[AccumulatorDescription])),'') AS varchar(50)) AS [AccumulatorDescription]
								, CAST(ISNULL(LTRIM(RTRIM(acd.[AccumulatorDescriptionShort])),'') AS varchar(10)) AS [AccumulatorDescriptionShort]
								, COALESCE(chg.[QuantityUsedOriginal],0) AS [QuantityUsedOriginal]
								, COALESCE(chg.[QuantityUsedAdjustment],0) AS [QuantityUsedAdjustment]
								, COALESCE(chg.[QuantityTotalOriginal],0) AS [QuantityTotalOriginal]
								, COALESCE(chg.[QuantityTotalAdjustment],0) AS [QuantityTotalAdjustment]
								, COALESCE(chg.[MoneyOriginal],0.0) AS [MoneyOriginal]
								, COALESCE(chg.[MoneyAdjustment],0.0) AS [MoneyAdjustment]
								--, COALESCE([bief_stage].[fn_GetUTCDateTime](acc.[DateOriginal],so.[CenterID]),'1/1/1753') AS [DateOriginal]
								--, COALESCE([bief_stage].[fn_GetUTCDateTime](acc.[DateAdjustment],so.[CenterID]),'1/1/1753') AS [DateAdjustment]
								, COALESCE(chg.[DateOriginal],'1/1/1753') AS [DateOriginal]
								, COALESCE(convert(date,convert(varchar,[bief_stage].[fn_GetUTCDateTime](chg.[CreateDate],so.[CenterID]),101)),'1/1/1753') AS [DateAdjustment]
								--, COALESCE(chg.[QuantityUsedNewCalc],0) AS [QuantityUsedNew]
								--, COALESCE(chg.[QuantityUsedChangeCalc],0) AS [QuantityUsedChange]
								--, COALESCE(chg.[QuantityTotalNewCalc],0) AS [QuantityTotalNew]
								--, COALESCE(chg.[QuantityTotalChangeCalc],0) AS [QuantityTotalChange]
								--, COALESCE(chg.[MoneyNewCalc],0.0) AS [MoneyNew]
								--, COALESCE(chg.[MoneyChangeCalc],0.0) AS [MoneyChange]
								,(case when chg.[AccumulatorActionTypeID]=(1) then isnull(chg.[QuantityUsedOriginal],(0))+isnull(chg.[QuantityUsedAdjustment],(0)) when chg.[AccumulatorActionTypeID]=(2) then isnull(chg.[QuantityUsedOriginal],(0))-isnull(chg.[QuantityUsedAdjustment],(0)) when chg.[AccumulatorActionTypeID]=(3) then isnull(chg.[QuantityUsedAdjustment],(0)) else (0) end) AS [QuantityUsedNew]
								,(case when chg.[AccumulatorActionTypeID]=(1) then isnull(chg.[QuantityUsedAdjustment],(0)) when chg.[AccumulatorActionTypeID]=(2) then  -(1)*isnull(chg.[QuantityUsedAdjustment],(0)) when chg.[AccumulatorActionTypeID]=(3) then isnull(chg.[QuantityUsedAdjustment],(0))-isnull(chg.[QuantityUsedOriginal],(0)) else (0) end) AS [QuantityUsedChangeCalc]
								,(case when chg.[AccumulatorActionTypeID]=(1) then isnull(chg.[QuantityTotalOriginal],(0))+isnull(chg.[QuantityTotalAdjustment],(0)) when chg.[AccumulatorActionTypeID]=(2) then isnull(chg.[QuantityTotalOriginal],(0))-isnull(chg.[QuantityTotalAdjustment],(0)) when chg.[AccumulatorActionTypeID]=(3) then isnull(chg.[QuantityTotalAdjustment],(0)) else (0) end) AS [QuantityTotalNewCalc]
								,(case when chg.[AccumulatorActionTypeID]=(1) then isnull(chg.[QuantityTotalAdjustment],(0)) when chg.[AccumulatorActionTypeID]=(2) then  -(1)*isnull(chg.[QuantityTotalAdjustment],(0)) when chg.[AccumulatorActionTypeID]=(3) then isnull(chg.[QuantityTotalAdjustment],(0))-isnull(chg.[QuantityTotalOriginal],(0)) else (0) end) AS [QuantityTotalChangeCalc]
								,(case when chg.[AccumulatorActionTypeID]=(1) then isnull(chg.[MoneyOriginal],(0))+isnull(chg.[MoneyAdjustment],(0)) when chg.[AccumulatorActionTypeID]=(2) then isnull(chg.[MoneyOriginal],(0))-isnull(chg.[MoneyAdjustment],(0)) when chg.[AccumulatorActionTypeID]=(3) then isnull(chg.[MoneyAdjustment],(0)) else (0) end) AS [MoneyNewCalc]
								,(case when chg.[AccumulatorActionTypeID]=(1) then isnull(chg.[MoneyAdjustment],(0)) when chg.[AccumulatorActionTypeID]=(2) then  -(1)*isnull(chg.[MoneyAdjustment],(0)) when chg.[AccumulatorActionTypeID]=(3) then isnull(chg.[MoneyAdjustment],(0))-isnull(chg.[MoneyOriginal],(0)) else (0) end) AS [MoneyChangeCalc]

								, [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time](__$start_lsn) AS [ModifiedDate]
								, 0 AS [IsNew]
								, 0 AS [IsType1]
								, 0 AS [IsType2]
								, 0 AS [IsException]
								, 0 AS [IsInferredMember]
								, 0 AS [IsDelete]
								, 0 AS [IsDuplicate]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[AccumulatorAdjustmentGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
								, CASE [__$operation]
										WHEN 1 THEN 'D'
										WHEN 2 THEN 'I'
										WHEN 3 THEN 'UO'
										WHEN 4 THEN 'UN'
										WHEN 5 THEN 'M'
										ELSE NULL
									END AS [CDC_Operation]
						FROM [HairClubCMS].[cdc].[fn_cdc_get_net_changes_dbo_datAccumulatorAdjustment](@From_LSN, @To_LSN, @row_filter_option) chg
							Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_cfgAccumulator] acd
									ON chg.[AccumulatorID] = acd.[AccumulatorID]
							Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrderDetail] sod
									ON chg.[SalesOrderDetailGUID] = sod.[SalesOrderDetailGUID]
							Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrder] so
									ON sod.SalesOrderGUID = so.SalesOrderGUID



						SET @ExtractRowCnt = @@ROWCOUNT

						-- Set the Last Successful Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET LSET = @CET
								, [Status] = 'Extraction Completed'
							WHERE [TableName] = @TableName

				END

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
