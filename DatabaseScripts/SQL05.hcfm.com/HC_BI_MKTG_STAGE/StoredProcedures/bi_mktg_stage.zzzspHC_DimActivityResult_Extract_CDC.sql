/* CreateDate: 05/03/2010 12:26:29.887 , ModifyDate: 08/05/2019 11:23:35.063 */
GO
CREATE PROCEDURE [bi_mktg_stage].[zzzspHC_DimActivityResult_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimActivityResult_Extract_CDC] is used to retrieve
-- Activity Results
--
--   exec [bi_mktg_stage].[spHC_DimActivityResult_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009  RLifke       Initial Creation
--			11/21/2017	KMurdoch	 Added SFDC_Lead/Task_ID
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

 	SET @TableName = N'[bi_mktg_dds].[DimActivityResult]'
 	SET @CDCTableName = N'dbo_cstd_contact_completion'


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
					SELECT @From_LSN = [HCM].[sys].[fn_cdc_get_min_lsn](@CDCTableName)
				ELSE
				BEGIN
					IF ([HCM].[sys].[fn_cdc_map_lsn_to_time]([HCM].[sys].[fn_cdc_get_min_lsn](@CDCTableName)) > @Start_Time) or
					   ([HCM].[sys].[fn_cdc_map_lsn_to_time]([HCM].[sys].[fn_cdc_get_max_lsn]()) < @Start_Time)
						SELECT @From_LSN = null
					ELSE
						SELECT @From_LSN = [HCM].[sys].[fn_cdc_increment_lsn]([HCM].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@Start_Time))
				END

				IF (@End_Time is null)
					SELECT @To_LSN = [HCM].[sys].[fn_cdc_get_max_lsn]()
				ELSE
				BEGIN
					IF [HCM].[sys].[fn_cdc_map_lsn_to_time]([HCM].[sys].[fn_cdc_get_max_lsn]()) < @End_Time
						--SELECT @To_LSN = null
						SELECT @To_LSN = [HCM].[sys].[fn_cdc_get_max_lsn]()
					ELSE
						SELECT @To_LSN = [HCM].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@End_Time)
				END


				-- Get the Actual Current Extraction Time
				SELECT @CET = [HCM].[sys].[fn_cdc_map_lsn_to_time](@To_LSN)

				IF (@From_LSN IS NOT NULL) AND (@To_LSN IS NOT NULL) AND (@From_LSN <> [HCM].[sys].[fn_cdc_increment_lsn](@To_LSN))
					BEGIN

						-- Set the Current Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET CET = @CET
								, [Status] = 'Extracting'
							WHERE [TableName] = @TableName


						INSERT INTO [bi_mktg_stage].[DimActivityResult]
								   ( [DataPkgKey]
								   , [ActivityResultKey]
								   , [ActivityResultSSID]
								   , [CenterSSID]
								   , [ActivitySSID]
								   , [ContactSSID]
								   , [SalesTypeSSID]
								   , [SalesTypeDescription]
								   , [ActionCodeSSID]
								   , [ActionCodeDescription]
								   , [ResultCodeSSID]
								   , [ResultCodeDescription]
								   , [SourceSSID]
								   , [SourceDescription]
								   , [IsShow]
								   , [IsSale]
								   , [ContractNumber]
								   , [ContractAmount]
								   , [ClientNumber]
								   , [InitialPayment]
								   , [NumberOfGraphs]
								   , [OrigApptDate]
								   , [DateSaved]
								   , [RescheduledFlag]
								   , [RescheduledDate]
								   , [SurgeryOffered]
								   , [ReferredToDoctor]
								   , [SFDC_LeadID]
								   , [SFDC_TaskID]
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
								, NULL AS [ActivityResultKey]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[contact_completion_id])),'') AS nvarchar(10)) AS [ActivityResultSSID]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[company_id])),'') AS nvarchar(10)) AS [CenterSSID]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[activity_id])),'') AS nvarchar(10)) AS [ActivitySSID]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[contact_id])),'') AS nvarchar(10)) AS [ContactSSID]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[sale_type_code])),'') AS nvarchar(10)) AS [SalesTypeSSID]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[sale_type_description])),'') AS nvarchar(50)) AS [SalesTypeDescription]
								, CAST(ISNULL(LTRIM(RTRIM(oncd_activity.[action_code])),'') AS nvarchar(10)) AS [ActionCodeSSID]
								, CAST(ISNULL(LTRIM(RTRIM(onca_action.[description])),'') AS nvarchar(50)) AS [ActionCodeDescription]
								, CAST(ISNULL(LTRIM(RTRIM(oncd_activity.[result_code])),'') AS nvarchar(10)) AS [ResultCodeSSID]
								, CAST(ISNULL(LTRIM(RTRIM(onca_result.[description])),'') AS nvarchar(50)) AS [ResultCodeDescription]
								, CAST(ISNULL(LTRIM(RTRIM(oncd_activity.[source_code])),'') AS nvarchar(20)) AS [SourceSSID]
								, CAST(ISNULL(LTRIM(RTRIM(onca_source.[description])),'') AS nvarchar(50)) AS [SourceCodeDescription]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[show_no_show_flag])),'') AS nchar(1)) AS [IsShow]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[sale_no_sale_flag])),'') AS nchar(1)) AS [IsSale]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[contract_number])),'') AS nvarchar(10)) AS [ContractNumber]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[contract_amount])),0) AS decimal(15,4)) AS [ContractAmount]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[client_number])),'') AS nvarchar(50)) AS [ClientNumber]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[initial_payment])),0) AS decimal(15,4)) AS [InitialPayment]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[number_of_graphs])),'') AS int) AS [NumOfGraphs]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[original_appointment_date])),'') AS date) AS [OrigApptDate]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[date_saved])),'') AS date) AS [DateSaved]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[reschedule_flag])),'') AS nchar(1)) AS [RescheduleFlag]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[date_rescheduled])),'') AS date) AS [RescheduledDate]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[surgery_offered_flag])),'') AS nchar(1)) AS [SurgeryOffered]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[referred_to_doctor_flag])),'') AS nchar(1)) AS [ReferredToDoctor]
								, oncd_contact.cst_sfdc_lead_id
								, oncd_activity.cst_sfdc_task_id
								, [HCM].[sys].[fn_cdc_map_lsn_to_time](__$start_lsn) AS [ModifiedDate]
								, 0 AS [IsNew]
								, 0 AS [IsType1]
								, 0 AS [IsType2]
								, 0 AS [IsException]
								, 0 AS [IsInferredMember]
								, 0 AS [IsDelete]
								, 0 AS [IsDuplicate]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[contact_completion_id])),'') AS nvarchar(50)) AS [SourceSystemKey]
								, CASE [__$operation]
										WHEN 1 THEN 'D'
										WHEN 2 THEN 'I'
										WHEN 3 THEN 'UO'
										WHEN 4 THEN 'UN'
										WHEN 5 THEN 'M'
										ELSE NULL
									END AS [CDC_Operation]
						FROM [HCM].[cdc].[fn_cdc_get_net_changes_dbo_cstd_contact_completion](@From_LSN, @To_LSN, @row_filter_option) chg
						LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity] AS oncd_activity WITH (NOLOCK)
									ON oncd_activity.activity_id  = chg.activity_id
						LEFT OUTER JOIN hcm.dbo.oncd_contact oncd_contact
									ON oncd_contact.contact_id = chg.contact_id
						LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_onca_action] onca_action  WITH (NOLOCK)
									ON oncd_activity.[action_code] = onca_action.[action_code]
						LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_onca_result] onca_result WITH (NOLOCK)
									ON oncd_activity.[result_code] = onca_result.[result_code]
						LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_onca_source] onca_source WITH (NOLOCK)
									ON oncd_activity.[source_code] = onca_source.[source_code]


						SET @ExtractRowCnt = @@ROWCOUNT

						-- Set the Last Successful Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET LSET = @CET
								, [Status] = 'Extraction Completed'
							WHERE [TableName] = @TableName

					END
		END

		IF (@ExtractRowCnt IS NULL) SET @ExtractRowCnt = 0

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
