/* CreateDate: 05/03/2010 12:26:32.000 , ModifyDate: 08/05/2019 10:24:21.820 */
GO
CREATE PROCEDURE [bi_mktg_stage].[zzzspHC_DimActivity_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimActivity_Extract_CDC] is used to retrieve
-- Activities
--
--   exec [bi_mktg_stage].[spHC_DimActivity_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author      Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009  RLifke      Initial Creation
--  v1.1	04/27/2017	RHut		Added oncd_activity_company	to find the CenterSSID on the activity
--			10/20/2017  KMurdoch     Added SFDC_TaskID & SFDC_LeadID; Added join to ONCD_Contact
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

 	SET @TableName = N'[bi_mktg_dds].[DimActivity]'
 	SET @CDCTableName = N'dbo_oncd_activity'


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


				INSERT INTO [bi_mktg_stage].[DimActivity]
						   ( [DataPkgKey]
						   , [ActivityKey]
						   , [ActivitySSID]
						   , [ActivityDueDate]
						   , [ActivityStartTime]
						   , [ActivityCompletionDate]
						   , [ActivityCompletionTime]
						   , [ActionCodeSSID]
						   , [ActionCodeDescription]
						   , [ResultCodeSSID]
						   , [ResultCodeDescription]
						   , [SourceSSID]
						   , [SourceDescription]
						   , [CenterSSID]
						   , [ContactSSID]
						   , [SalesTypeSSID]
						   , [SalesTypeDescription]
						   , [ActivityTypeSSID]
						   , [ActivityTypeDescription]
						   , [TimeZoneSSID]
						   , [TimeZoneDescription]
						   , [GreenwichOffset]
						   , [PromotionCodeSSID]
						   , [PromotionCodeDescription]
						   , [IsAppointment]
						   , [IsShow]
						   , [IsNoShow]
						   , [IsSale]
						   , [IsNoSale]
						   , [IsConsultation]
						   , [IsBeBack]
						   , [SFDC_TaskID]
						   , [SFDC_LeadID]
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
							SELECT	@DataPkgKey AS 'DataPkgKey'
							,		NULL AS 'ActivityKey'
							,		CAST(ISNULL(LTRIM(RTRIM(activity.activity_id)),'') AS nvarchar(10)) AS 'ActivitySSID'
							,		CAST(ISNULL(LTRIM(RTRIM(activity.due_date)),'') AS date) AS 'ActivityDueDate'
							,		CAST(ISNULL(LTRIM(RTRIM(activity.start_time)),'') AS time) AS 'ActivityStartTime'
							,		CAST(ISNULL(LTRIM(RTRIM(activity.completion_date)),'') AS date) AS 'ActivityCompletionDate'
							,		CAST(ISNULL(LTRIM(RTRIM(activity.completion_date)),'') AS time) AS 'ActivityCompletionTime'
							,		CAST(ISNULL(LTRIM(RTRIM(activity.action_code)),'') AS nvarchar(10)) AS 'ActionCodeSSID'
							,		CAST(ISNULL(LTRIM(RTRIM(onca_action.description)),'') AS nvarchar(50)) AS 'ActionCodeDescription'
							,		CAST(ISNULL(LTRIM(RTRIM(activity.result_code)),'') AS nvarchar(10)) AS 'ResultCodeSSID'
							,		CAST(ISNULL(LTRIM(RTRIM(onca_result.description)),'') AS nvarchar(50)) AS 'ResultCodeDescription'
							,		CAST(ISNULL(LTRIM(RTRIM(activity.source_code)),'') AS nvarchar(20)) AS 'SourceSSID'
							,		CAST(ISNULL(LTRIM(RTRIM(onca_source.description)),'') AS nvarchar(50)) AS 'SourceCodeDescription'
							,		CAST(ISNULL(COALESCE(LTRIM(RTRIM(activitycompany.cst_center_number)), (LTRIM(RTRIM(contactcompany.cst_center_number)))),'-2') AS nvarchar(10)) AS 'CenterSSID'
							,		CAST(ISNULL(LTRIM(RTRIM(oncd_activity_contact.contact_id)),'') AS nvarchar(10)) AS 'ContactSSID'
							,		CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.sale_type_code)),'') AS nvarchar(10)) AS 'SalesTypeSSID'
							,		CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.sale_type_description)),'') AS nvarchar(50)) AS 'SalesTypeDescription'
							,		CAST(ISNULL(LTRIM(RTRIM(activity.cst_activity_type_code)),'') AS nvarchar(10)) AS 'ActivityTypeSSID'
							,		CAST(ISNULL(LTRIM(RTRIM(acttype.description)),'') AS nvarchar(50)) AS 'ActivityTypeDescription'
							,		CAST(ISNULL(LTRIM(RTRIM(activity.cst_time_zone_code)),'') AS nvarchar(10)) AS 'TimeZoneSSID'
							,		CAST(ISNULL(LTRIM(RTRIM(timezone.description)),'') AS nvarchar(50)) AS 'TimeZoneDescription'
							,		CAST(ISNULL(LTRIM(RTRIM(timezone.greenwich_offset)),'') AS float) AS 'GreenwichOffset'
							,		CAST(ISNULL(LTRIM(RTRIM(activity.cst_promotion_code)),'') AS nvarchar(10)) AS 'PromotionCodeSSID'
							,		CAST(ISNULL(LTRIM(RTRIM(promo.description)),'') AS nvarchar(50)) AS 'PromotionCodeDescription'
							,		bi_mktg_stage.fn_IsAppointment(activity.action_code, activity.result_code) AS 'IsAppointment'
							,		bi_mktg_stage.fn_IsShow(activity.result_code) AS 'IsShow'
							,		bi_mktg_stage.fn_IsNoShow(activity.result_code) AS 'IsNoShow'
							,		bi_mktg_stage.fn_IsSale(activity.result_code) AS 'IsSale'
							,		bi_mktg_stage.fn_IsNoSale(activity.result_code) AS 'IsNoSale'
							,		bi_mktg_stage.fn_IsConsultation(activity.action_code, activity.result_code) AS 'IsConsultation'
							,		bi_mktg_stage.fn_IsBeBack(activity.action_code, activity.result_code) AS 'IsBeBack'
							,		activity.cst_sfdc_task_id
							,		oncd_contact.cst_sfdc_lead_id
							,		GETDATE() AS 'ModifiedDate'
							,		0 AS 'IsNew'
							,		0 AS 'IsType1'
							,		0 AS 'IsType2'
							,		0 AS 'IsException'
							,		0 AS 'IsInferredMember'
							,		0 AS 'IsDelete'
							,		0 AS 'IsDuplicate'
							,		CAST(ISNULL(LTRIM(RTRIM(activity.activity_id)),'') AS nvarchar(50)) AS 'SourceSystemKey'
							, CASE [__$operation]
										WHEN 1 THEN 'D'
										WHEN 2 THEN 'I'
										WHEN 3 THEN 'UO'
										WHEN 4 THEN 'UN'
										WHEN 5 THEN 'M'
										ELSE NULL
									END AS [CDC_Operation]
							FROM	[HCM].[cdc].[fn_cdc_get_net_changes_dbo_oncd_activity](@From_LSN, @To_LSN, @row_filter_option) activity
									LEFT OUTER JOIN bi_mktg_stage.synHC_SRC_TBL_MKTG_onca_action onca_action WITH ( NOLOCK )
										ON activity.action_code = onca_action.action_code
									LEFT OUTER JOIN bi_mktg_stage.synHC_SRC_TBL_MKTG_onca_result onca_result WITH ( NOLOCK )
										ON activity.result_code = onca_result.result_code
									LEFT OUTER JOIN bi_mktg_stage.synHC_SRC_TBL_MKTG_onca_source onca_source WITH ( NOLOCK )
										ON activity.source_code = onca_source.source_code
									LEFT OUTER JOIN bi_mktg_stage.synHC_SRC_TBL_MKTG_csta_activity_type acttype WITH ( NOLOCK )
										ON activity.cst_activity_type_code = acttype.activity_type_code
									LEFT OUTER JOIN bi_mktg_stage.synHC_SRC_TBL_MKTG_onca_time_zone timezone WITH ( NOLOCK )
										ON activity.cst_time_zone_code = timezone.time_zone_code
									LEFT OUTER JOIN bi_mktg_stage.synHC_SRC_TBL_MKTG_csta_promotion_code promo WITH ( NOLOCK )
										ON activity.cst_promotion_code = promo.promotion_code
									LEFT OUTER JOIN bi_mktg_stage.synHC_SRC_TBL_MKTG_oncd_activity_contact oncd_activity_contact WITH ( NOLOCK )
										ON oncd_activity_contact.activity_id = activity.activity_id
										AND oncd_activity_contact.primary_flag = 'Y'
									LEFT OUTER JOIN bi_mktg_stage.synHC_SRC_TBL_MKTG_oncd_contact oncd_contact
										ON oncd_contact.contact_id = oncd_activity_contact.contact_id
									LEFT OUTER JOIN bi_mktg_stage.synHC_SRC_TBL_MKTG_cstd_contact_completion cstd_contact_completion WITH ( NOLOCK )
										ON cstd_contact_completion.activity_id = activity.activity_id
									LEFT OUTER JOIN bi_mktg_stage.synHC_SRC_TBL_MKTG_oncd_activity_company oncd_activity_company
										ON oncd_activity_company.activity_id = activity.activity_id
										AND oncd_activity_company.primary_flag = 'Y'
									LEFT OUTER JOIN bi_mktg_stage.synHC_SRC_TBL_MKTG_oncd_contact_company oncd_contact_company
										ON oncd_activity_contact.contact_id = oncd_contact_company.contact_id
										AND oncd_contact_company.primary_flag = 'Y'
									LEFT JOIN bi_mktg_stage.synHC_SRC_TBL_MKTG_oncd_company activitycompany
										ON activitycompany.company_id = oncd_activity_company.company_id
									LEFT JOIN bi_mktg_stage.synHC_SRC_TBL_MKTG_oncd_company contactcompany
										ON contactcompany.company_id = oncd_contact_company.company_id


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
