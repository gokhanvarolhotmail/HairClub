/* CreateDate: 05/03/2010 12:26:54.493 , ModifyDate: 08/05/2019 11:16:00.677 */
GO
CREATE PROCEDURE [bi_mktg_stage].[zzzspHC_FactActivityResults_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_FactActivityResults_Extract_CDC] is used to retrieve a
-- list FactActivityResults
--
--   exec [bi_mktg_stage].[spHC_FactActivityResults_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009  RLifke       Initial Creation
--			08/11/2011	KMurdoch	 Added ActivityEmployeeKey
--			06/06/2012  KMurdoch	 Changed Gender to be derived from Contact
--			04/01/2016  KMurdoch     Updated select to be Inner Joins
--			04/27/2017	RHut		 Added oncd_activity_company to find the CenterSSID on the activity
--			11/13/2017	RHut		 Added VOID to the statement ((oncd_activity.[Result_code] NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN', 'VOID' ))
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
				, @CDCTableName2		varchar(150)	-- Name of CDC table
				, @ExtractRowCnt		int
				, @ExtractRowCnt1		int
				, @ExtractRowCnt2		int

 	SET @TableName = N'[bi_mktg_dds].[FactActivityResults]'
 	SET @CDCTableName = N'dbo_cstd_contact_completion'
 	SET @CDCTableName2 = N'dbo_oncd_activity'


	BEGIN TRY

	   -- Put parameters in name value list to aid in reporting
		EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@LSET'
				, @LSET
				, N'@CET'
				, @CET

		-- Subtract 15 minutes to help ensure Dims have been loaded
		SET @CET = DATEADD(mi,-5,@CET)

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

						INSERT INTO [bi_mktg_stage].[FactActivityResults]
								   ( [DataPkgKey]
									, [ActivityResultDateKey]
									, [ActivityResultDateSSID]
									, [ActivityResultKey]
									, [ActivityResultSSID]
									, [ActivityResultTimeKey]
									, [ActivityResultTimeSSID]

									, [ActivityKey]
									, [ActivitySSID]
									, [ActivityDateKey]
									, [ActivityDateSSID]
									, [ActivityTimeKey]
									, [ActivityTimeSSID]
									, [ActivityDueDateKey]
									, [ActivityDueDateSSID]
									, [ActivityStartTimeKey]
									, [ActivityStartTimeSSID]
									, [ActivityCompletedDateKey]
									, [ActivityCompletedDateSSID]
									, [ActivityCompletedTimeKey]
									, [ActivityCompletedTimeSSID]
									, [OriginalAppointmentDateKey]
									, [OriginalAppointmentDateSSID]
									, [ActivitySavedDateKey]
									, [ActivitySavedDateSSID]
									, [ActivitySavedTimeKey]
									, [ActivitySavedTimeSSID]
									, [ContactKey]
									, [ContactSSID]
									, [CenterKey]
									, [CenterSSID]
									, [SalesTypeKey]
									, [SalesTypeSSID]
									, [SourceKey]
									, [SourceSSID]
									, [ActionCodeKey]
									, [ActionCodeSSID]
									, [ResultCodeKey]
									, [ResultCodeSSID]

									, [GenderKey]
									, [GenderSSID]
									, [OccupationKey]
									, [OccupationSSID]
									, [EthnicityKey]
									, [EthnicitySSID]
									, [MaritalStatusKey]
									, [MaritalStatusSSID]
									, [HairLossTypeKey]
									, [HairLossTypeSSID]
									, [NorwoodSSID]
									, [LudwigSSID]
									, [AgeRangeKey]
									, [AgeRangeSSID]
									, [Age]
									, [CompletedByEmployeeKey]
									, [CompletedByEmployeeSSID]
									, [ClientNumber]
									, [ShowNoShowFlag]
									, [SaleNoSaleFlag]
									, [SurgeryOfferedFlag]
									, [ReferredToDoctorFlag]
									, [Show]
									, [NoShow]
									, [Sale]
									, [NoSale]
									, [Consultation]
									, [BeBack]

									, [SurgeryOffered]
									, [ReferredToDoctor]
									, [InitialPayment]
								    , [ActivityEmployeeKey]
								    , [ActivityEmployeeSSID]

									, [IsNew]
									, [IsUpdate]
									, [IsException]
									, [IsDelete]
									, [IsDuplicate]
									, [SourceSystemKey]

								    , [CDC_Operation]
									)
						SELECT @DataPkgKey
							, 0 AS [ActivityResultDateKey]
							, CAST(oncd_activity.[due_date] AS DATE) AS [ActivityResultDateSSID]
							, 0 AS [ActivityResultKey]
							, CAST(ISNULL(LTRIM(RTRIM(chg.[contact_completion_id])),'-2') AS varchar(10)) AS [ActivityResultSSID]
							, 0 AS [ActivityResultTimeKey]
							, CAST(oncd_activity.[due_date] AS TIME) AS [ActivityResultTimeSSID]

							, 0 AS [ActivityKey]
							, CAST(ISNULL(LTRIM(RTRIM(oncd_activity.[Activity_ID])),'') AS varchar(10)) AS [ActivitySSID]
							, 0 AS [ActivityDateKey]
							, CAST(oncd_activity.Creation_Date AS DATE) AS [ActivityDateSSID]
							, 0 AS [ActivityTimeKey]
							, CAST(oncd_activity.Creation_Date AS TIME) AS [ActivityTimeSSID]

							, 0 AS [ActivityDueDateKey]
							, CAST(oncd_activity.[due_date] AS DATE) AS [ActivityDueDateSSID]
							, 0 AS [ActivityStartTimeKey]
							, CAST(oncd_activity.[start_time] AS TIME) AS [ActivityStartTimeSSID]
							, 0 AS [ActivityCompletedDateKey]
							, CAST(oncd_activity.[completion_date] AS DATE) AS [ActivityCompletedDateSSID]
							, 0 AS [ActivityCompletedTimeKey]
							, CAST(oncd_activity.[completion_date] AS TIME) AS [ActivityCompletedTimeSSID]

							, 0 AS [OriginalAppointmentDateKey]
							, CAST(chg.original_appointment_date AS DATE) AS [OriginalAppointmentDateSSID]
							, 0 AS [ActivitySavedDateKey]
							, CAST(oncd_activity.[due_date] AS DATE) AS [ActivitySavedDateSSID]
							, 0 AS [ActivitySavedTimeKey]
							, CAST(oncd_activity.[due_date] AS TIME) AS [ActivitySavedTimeSSID]

							, 0 AS [ContactKey]
							, CAST(LTRIM(RTRIM(oncd_activity_contact.[contact_id])) AS nvarchar(10)) AS [ContactSSID]
							, 0 AS [CenterKey]

							--, CAST(ISNULL(LTRIM(RTRIM(oncd_company.[cst_center_number])),'-2') AS nvarchar(10)) AS [CenterSSID]
							--New COALESCE - 4/27/2017
							, CAST(ISNULL(COALESCE(LTRIM(RTRIM(activitycompany.[cst_center_number])), (LTRIM(RTRIM(contactcompany.[cst_center_number])))),'-2') AS nvarchar(10)) AS [CenterSSID]

							, 0 AS [SalesTypeKey]
							, CAST(ISNULL(LTRIM(RTRIM(chg.[sale_type_code])),'-2') AS nvarchar(10)) AS [SalesTypeSSID]
							, 0 AS [SourceKey]
							, CAST(LTRIM(RTRIM(oncd_activity.[Source_code])) AS nvarchar(20)) AS [SourceSSID]
							, 0 AS [ActionCodeKey]
							, CAST(LTRIM(RTRIM(oncd_activity.[action_code])) AS nvarchar(10)) AS [ActionCodeSSID]
							, 0 AS [ResultCodeKey]
							, CAST(LTRIM(RTRIM(oncd_activity.[Result_code])) AS nvarchar(10)) AS [ResultCodeSSID]

							, 0 AS [GenderKey]
							, CAST(LTRIM(RTRIM(ISNULL(LEFT(oncd_contact.cst_gender_code,1), 'M'))) AS nvarchar(10)) AS [GenderSSID]
							, 0 AS [OccupationKey]
							, CAST(LTRIM(RTRIM(cstd_activity_demographic.occupation_code)) AS nvarchar(10)) AS [OccupationSSID]
							, 0 AS [EthnicityKey]
							, CAST(LTRIM(RTRIM(cstd_activity_demographic.ethnicity_code)) AS nvarchar(10)) AS [EthnicitySSID]
							, 0 AS [MaritalStatusKey]
							, CAST(LTRIM(RTRIM(cstd_activity_demographic.maritalstatus_code)) AS nvarchar(10)) AS [MaritalStatusSSID]
							, 0 AS [HairLossTypeKey]
							, '-2' AS [HairLossTypeSSID]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.norwood)),'') AS varchar(50)) AS [NorwoodSSID]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.ludwig)),'') AS varchar(50)) AS [LudwigSSID]
							, 0 AS [AgeRangeKey]
							, '-2' AS [AgeRangeSSID]
							, cstd_activity_demographic.age AS [Age]
							, 0 AS [CompletedByEmployeeKey]
							, CAST(LTRIM(RTRIM(oncd_activity.[completed_by_user_code])) AS nvarchar(20)) AS [CompletedByEmployeeSSID]
							, CAST(ISNULL(LTRIM(RTRIM(chg.[Client_Number])),'') AS nvarchar(50)) AS [ClientNumber]
							, CAST(ISNULL(LTRIM(RTRIM(chg.[show_no_show_flag])),'') AS char(1)) AS [ShowNoShowFlag]
							, CAST(ISNULL(LTRIM(RTRIM(chg.[sale_no_sale_flag])),'') AS char(1)) AS [SaleNoSaleFlag]
							, CAST(ISNULL(LTRIM(RTRIM(chg.[surgery_offered_flag])),'') AS char(1)) AS [SurgeryOfferedFlag]
							, CAST(ISNULL(LTRIM(RTRIM(chg.[referred_to_doctor_flag])),'') AS char(1)) AS [ReferredToDoctorFlag]
							, 0 AS [Show]
							, 0 AS [NoShow]
							, 0 AS [Sale]
							, 0 AS [NoSale]
						    , 0 AS [Consultation]
						    , 0 AS [BeBack]
							, 0 AS [SurgeryOffered]
							, 0 AS [ReferredToDoctor]
							, CAST(ISNULL(LTRIM(RTRIM(chg.[Initial_Payment])),0) AS decimal (15,4)) AS [InitialPayment]
							, 0 AS [ActivityEmployeeKey]
							, CAST(LTRIM(RTRIM(oncd_activity_user.[user_code])) AS nvarchar(20)) AS [ActivityEmployeeSSID]

							, 0 AS [IsNew]
							, 0 AS [IsUpdate]
							, 0 AS [IsException]
							, 0 AS [IsDelete]
							, 0 AS [IsDuplicate]
							, CAST(LTRIM(RTRIM(chg.[contact_completion_id])) AS nvarchar(50)) AS [SourceSystemKey]
								, CASE [__$operation]
										WHEN 1 THEN 'D'
										WHEN 2 THEN 'I'
										WHEN 3 THEN 'UO'
										WHEN 4 THEN 'UN'
										WHEN 5 THEN 'M'
										ELSE NULL
									END AS [CDC_Operation]

						FROM [HCM].[cdc].[fn_cdc_get_net_changes_dbo_cstd_contact_completion](@From_LSN, @To_LSN, @row_filter_option) chg
						INNER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity] oncd_activity  WITH (NOLOCK)
								ON oncd_activity.activity_id  = chg.activity_id
						INNER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity_contact] AS oncd_activity_contact WITH (NOLOCK)
				    			ON oncd_activity_contact.activity_id = oncd_activity.activity_id
							   AND oncd_activity_contact.primary_flag = 'Y'
						INNER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_contact] AS oncd_contact WITH (NOLOCK)
						    	ON oncd_activity_contact.contact_id = oncd_contact.contact_id
						LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_cstd_activity_demographic] AS cstd_activity_demographic WITH (NOLOCK)
								ON cstd_activity_demographic.activity_id  = oncd_activity.activity_id
						--INNER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_contact_company] AS oncd_contact_company WITH (NOLOCK)
						--		ON  oncd_activity_contact.[contact_id] = oncd_contact_company.contact_id
						--		AND oncd_contact_company.primary_flag = 'Y'
						--INNER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_company] AS oncd_company WITH (NOLOCK)
						--		ON  oncd_contact_company.company_id = oncd_company.company_id
						LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity_user] AS oncd_activity_user WITH (NOLOCK)
					    	ON oncd_activity_user.activity_id = oncd_activity.activity_id
						   AND oncd_activity_user.primary_flag = 'Y'

				--New table to use
				LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity_company]  oncd_activity_company  --Newly created synonym
					ON oncd_activity_company.activity_id = oncd_activity.activity_id
					AND oncd_activity_company.primary_flag = 'Y'

				--Change to LEFT OUTER JOIN
				LEFT OUTER JOIN[bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_contact_company] oncd_contact_company
						ON  oncd_activity_contact.[contact_id] = oncd_contact_company.contact_id
						AND oncd_contact_company.primary_flag = 'Y'

				LEFT JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_company] activitycompany
						ON  activitycompany.company_id = oncd_activity_company.company_id 		--NEW
				LEFT JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_company] contactcompany
						ON  contactcompany.company_id = oncd_contact_company.company_id 		--NEW


						WHERE (((oncd_activity.[action_code] IN ('APPOINT', 'INHOUSE', 'BEBACK')) AND ((oncd_activity.[Result_code] NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN', 'VOID' )) OR (oncd_activity.[Result_code] IS NULL) ))
							OR ((oncd_activity.[action_code] IN ('RECOVERY')) AND ((oncd_activity.[Result_code] IS NOT NULL)) AND (oncd_activity.[Result_code] IN ('SHOWSALE','SHOWNOSALE','NOSHOW'))))


						SET @ExtractRowCnt1 = @@ROWCOUNT

					END


					-- Now check activities which changed and get list of activities
					IF (@Start_Time is null)
						SELECT @From_LSN = [HCM].[sys].[fn_cdc_get_min_lsn](@CDCTableName2)
					ELSE
					BEGIN
						IF ([HCM].[sys].[fn_cdc_map_lsn_to_time]([HCM].[sys].[fn_cdc_get_min_lsn](@CDCTableName2)) > @Start_Time) or
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

						INSERT INTO [bi_mktg_stage].[FactActivityResults]
								   (
									  [ActivitySSID]
									, [ActivityKey]
									, [ActivityDateKey]
									, [ActivityDateSSID]
									, [ActivityTimeKey]
									, [ActivityTimeSSID]
									, [DataPkgKey]

									, [ActivityResultDateKey]
									, [ActivityResultDateSSID]
									, [ActivityResultKey]
									, [ActivityResultSSID]
									, [ActivityResultTimeKey]
									, [ActivityResultTimeSSID]


									, [ActivityDueDateKey]
									, [ActivityDueDateSSID]
									, [ActivityStartTimeKey]
									, [ActivityStartTimeSSID]
									, [ActivityCompletedDateKey]
									, [ActivityCompletedDateSSID]
									, [ActivityCompletedTimeKey]
									, [ActivityCompletedTimeSSID]
									, [OriginalAppointmentDateKey]
									, [OriginalAppointmentDateSSID]
									, [ActivitySavedDateKey]
									, [ActivitySavedDateSSID]
									, [ActivitySavedTimeKey]
									, [ActivitySavedTimeSSID]
									, [ContactKey]
									, [ContactSSID]
									, [CenterKey]
									, [CenterSSID]
									, [SalesTypeKey]
									, [SalesTypeSSID]
									, [SourceKey]
									, [SourceSSID]
									, [ActionCodeKey]
									, [ActionCodeSSID]
									, [ResultCodeKey]
									, [ResultCodeSSID]

									, [GenderKey]
									, [GenderSSID]
									, [OccupationKey]
									, [OccupationSSID]
									, [EthnicityKey]
									, [EthnicitySSID]
									, [MaritalStatusKey]
									, [MaritalStatusSSID]
									, [HairLossTypeKey]
									, [HairLossTypeSSID]
									, [NorwoodSSID]
									, [LudwigSSID]
									, [AgeRangeKey]
									, [AgeRangeSSID]
									, [Age]
									, [CompletedByEmployeeKey]
									, [CompletedByEmployeeSSID]
									, [ClientNumber]
									, [ShowNoShowFlag]
									, [SaleNoSaleFlag]
									, [SurgeryOfferedFlag]
									, [ReferredToDoctorFlag]
									, [Show]
									, [NoShow]
									, [Sale]
									, [NoSale]
									, [Consultation]
									, [BeBack]

									, [SurgeryOffered]
									, [ReferredToDoctor]
									, [InitialPayment]
								    , [ActivityEmployeeKey]
								    , [ActivityEmployeeSSID]

									, [IsNew]
									, [IsUpdate]
									, [IsDelete]
									, [IsException]
									, [SourceSystemKey]

								    , [CDC_Operation]
									)
						SELECT DISTINCT
							  CAST(ISNULL(LTRIM(RTRIM(chg.[Activity_ID])),'') AS varchar(10)) AS [ActivitySSID]
							, 0 AS [ActivityKey]
							, 0 AS [ActivityDateKey]
							, CAST(chg.Creation_Date AS DATE) AS [ActivityDateSSID]
							, 0 AS [ActivityTimeKey]
							, CAST(chg.Creation_Date AS TIME) AS [ActivityTimeSSID]
							, @DataPkgKey

							, 0 AS [ActivityResultDateKey]
							, CAST(chg.[due_date] AS DATE) AS [ActivityResultDateSSID]
							, 0 AS [ActivityResultKey]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.[contact_completion_id])),'-2') AS varchar(10)) AS [ActivityResultSSID]
							, 0 AS [ActivityResultTimeKey]
							, CAST(chg.[due_date] AS TIME) AS [ActivityResultTimeSSID]


							, 0 AS [ActivityDueDateKey]
							, CAST(chg.[due_date] AS DATE) AS [ActivityDueDateSSID]
							, 0 AS [ActivityStartTimeKey]
							, CAST(chg.[start_time] AS TIME) AS [ActivityStartTimeSSID]
							, 0 AS [ActivityCompletedDateKey]
							, CAST(chg.[completion_date] AS DATE) AS [ActivityCompletedDateSSID]
							, 0 AS [ActivityCompletedTimeKey]
							, CAST(chg.[completion_date] AS TIME) AS [ActivityCompletedTimeSSID]

							, 0 AS [OriginalAppointmentDateKey]
							, CAST(cstd_contact_completion.original_appointment_date AS DATE) AS [OriginalAppointmentDateSSID]
							, 0 AS [ActivitySavedDateKey]
							, CAST(chg.[due_date] AS DATE) AS [ActivitySavedDateSSID]
							, 0 AS [ActivitySavedTimeKey]
							, CAST(chg.[due_date] AS TIME) AS [ActivitySavedTimeSSID]

							, 0 AS [ContactKey]
							, CAST(LTRIM(RTRIM(oncd_activity_contact.[contact_id])) AS nvarchar(10)) AS [ContactSSID]
							, 0 AS [CenterKey]
							, CAST(ISNULL(LTRIM(RTRIM(oncd_company.[cst_center_number])),'-2') AS nvarchar(10)) AS [CenterSSID]
							, 0 AS [SalesTypeKey]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.[sale_type_code])),'-2') AS nvarchar(10)) AS [SalesTypeSSID]
							, 0 AS [SourceKey]
							, CAST(LTRIM(RTRIM(chg.[Source_code])) AS nvarchar(20)) AS [SourceSSID]
							, 0 AS [ActionCodeKey]
							, CAST(LTRIM(RTRIM(chg.[action_code])) AS nvarchar(10)) AS [ActionCodeSSID]
							, 0 AS [ResultCodeKey]
							, CAST(LTRIM(RTRIM(chg.[Result_code])) AS nvarchar(10)) AS [ResultCodeSSID]

							, 0 AS [GenderKey]
							, CAST(LTRIM(RTRIM(cstd_activity_demographic.gender)) AS nvarchar(10)) AS [GenderSSID]
							, 0 AS [OccupationKey]
							, CAST(LTRIM(RTRIM(cstd_activity_demographic.occupation_code)) AS nvarchar(10)) AS [OccupationSSID]
							, 0 AS [EthnicityKey]
							, CAST(LTRIM(RTRIM(cstd_activity_demographic.ethnicity_code)) AS nvarchar(10)) AS [EthnicitySSID]
							, 0 AS [MaritalStatusKey]
							, CAST(LTRIM(RTRIM(cstd_activity_demographic.maritalstatus_code)) AS nvarchar(10)) AS [MaritalStatusSSID]
							, 0 AS [HairLossTypeKey]
							, '-2' AS [HairLossTypeSSID]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.norwood)),'') AS varchar(50)) AS [NorwoodSSID]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.ludwig)),'') AS varchar(50)) AS [LudwigSSID]
							, 0 AS [AgeRangeKey]
							, '-2' AS [AgeRangeSSID]
							, cstd_activity_demographic.age AS [Age]
							, 0 AS [CompletedByEmployeeKey]
							, CAST(LTRIM(RTRIM(chg.[completed_by_user_code])) AS nvarchar(20)) AS [CompletedByEmployeeSSID]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.[Client_Number])),'') AS nvarchar(50)) AS [ClientNumber]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.[show_no_show_flag])),'') AS char(1)) AS [ShowNoShowFlag]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.[sale_no_sale_flag])),'') AS char(1)) AS [SaleNoSaleFlag]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.[surgery_offered_flag])),'') AS char(1)) AS [SurgeryOfferedFlag]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.[referred_to_doctor_flag])),'') AS char(1)) AS [ReferredToDoctorFlag]
							, 0 AS [Show]
							, 0 AS [NoShow]
							, 0 AS [Sale]
							, 0 AS [NoSale]
						    , 0 AS [Consultation]
						    , 0 AS [BeBack]
							, 0 AS [SurgeryOffered]
							, 0 AS [ReferredToDoctor]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.[Initial_Payment])),0) AS decimal (15,4)) AS [InitialPayment]
							, 0 AS [ActivityEmployeeKey]
							, CAST(LTRIM(RTRIM(oncd_activity_user.[user_code])) AS nvarchar(20)) AS [ActivityEmployeeSSID]

							, 0 AS [IsNew]
							, 0 AS [IsUpdate]
							, 0 AS [IsDelete]
							, 0 AS [IsException]
							, CAST(LTRIM(RTRIM(cstd_contact_completion.[contact_completion_id])) AS nvarchar(50)) AS [SourceSystemKey]
								, CASE [__$operation]
										WHEN 1 THEN 'D'
										WHEN 2 THEN 'I'
										WHEN 3 THEN 'UO'
										WHEN 4 THEN 'UN'
										WHEN 5 THEN 'M'
										ELSE NULL
									END AS [CDC_Operation]

						FROM [HCM].[cdc].[fn_cdc_get_net_changes_dbo_oncd_activity](@From_LSN, @To_LSN, @row_filter_option) chg
						LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_cstd_contact_completion] cstd_contact_completion  WITH (NOLOCK)
								ON chg.activity_id  = cstd_contact_completion.activity_id
						LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity_contact] AS oncd_activity_contact WITH (NOLOCK)
				    			ON oncd_activity_contact.activity_id = chg.activity_id
							   AND oncd_activity_contact.primary_flag = 'Y'
						LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_cstd_activity_demographic] AS cstd_activity_demographic WITH (NOLOCK)
								ON cstd_activity_demographic.activity_id  = chg.activity_id
						LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_contact_company] AS oncd_contact_company WITH (NOLOCK)
								ON  oncd_activity_contact.[contact_id] = oncd_contact_company.contact_id
								AND oncd_contact_company.primary_flag = 'Y'
						LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_company] AS oncd_company WITH (NOLOCK)
								ON  oncd_contact_company.company_id = oncd_company.company_id
						LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity_user] AS oncd_activity_user WITH (NOLOCK)
					    	ON oncd_activity_user.activity_id = chg.activity_id
						   AND oncd_activity_user.primary_flag = 'Y'

						WHERE (((chg.[action_code] IN ('APPOINT', 'INHOUSE', 'BEBACK')) AND ((chg.[Result_code] NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN' )) OR (chg.[Result_code] IS NULL) ))
							OR ((chg.[action_code] IN ('RECOVERY')) AND ((chg.[Result_code] IS NOT NULL)) AND (chg.[Result_code] IN ('SHOWSALE','SHOWNOSALE','NOSHOW'))))


						SET @ExtractRowCnt2 = @@ROWCOUNT





						-- Set the Last Successful Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET LSET = @CET
								, [Status] = 'Extraction Completed'
							WHERE [TableName] = @TableName

					END
		END

		SET @ExtractRowCnt = @ExtractRowCnt1 + @ExtractRowCnt2
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
