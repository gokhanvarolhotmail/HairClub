/* CreateDate: 05/03/2010 12:26:50.443 , ModifyDate: 08/05/2019 11:15:52.627 */
GO
CREATE PROCEDURE [bi_mktg_stage].[zzzspHC_FactActivityResults_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_FactActivityResults_Extract] is used to retrieve a
-- list of Activity Transactions
--
--   exec [bi_mktg_stage].[spHC_FactActivityResults_Extract]  ''2009-01-01 01:00:00''
--                                       , ''2009-01-02 01:00:00''
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/20/2009  RLifke       Initial Creation
--			06/06/2012  KMurdoch	 Changed Gender to be derived from Contact
--			12/10/2013  KMurdoch     Updated select to be Inner Joins
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
				, @ExtractRowCnt		int

 	SET @TableName = N'[bi_mktg_dds].[FactActivityResults]'


	BEGIN TRY

	   -- Put parameters in name value list to aid in reporting
		EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@LSET'
				, @LSET
				, N'@CET'
				, @CET

		-- Subtract 60 minutes to help ensure Dims have been loaded
		SET @CET = DATEADD(mi,-60,@CET)

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_ExtractStart] @DataPkgKey, @TableName, @LSET, @CET

		IF (@CET IS NOT NULL) AND (@LSET IS NOT NULL)
			BEGIN

				-- Set the Current Extraction Time & Status
				UPDATE [bief_stage].[_DataFlow]
					SET CET = @CET
						, [Status] = 'Extracting'
					WHERE [TableName] = @TableName


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
							)

					SELECT	  @DataPkgKey
							, 0 AS [ActivityResultDateKey]
							, CAST(oncd_activity.[due_date] AS DATE) AS [ActivityResultDateSSID]
							, 0 AS [ActivityResultKey]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.[contact_completion_id])),'-2') AS varchar(10)) AS [ActivityResultSSID]
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
							, CAST(cstd_contact_completion.original_appointment_date AS DATE) AS [OriginalAppointmentDateSSID]
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
							, CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.[sale_type_code])),'-2') AS nvarchar(10)) AS [SalesTypeSSID]
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
							, 0 AS [IsException]
							, 0 AS [IsDelete]
							, 0 AS [IsDuplicate]
							, CAST(LTRIM(RTRIM(cstd_contact_completion.[contact_completion_id])) AS nvarchar(50)) AS [SourceSystemKey]
					FROM  [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity] AS oncd_activity       WITH (NOLOCK)
					INNER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity_contact] AS oncd_activity_contact WITH (NOLOCK)
					    	ON oncd_activity_contact.activity_id = oncd_activity.activity_id
						   AND oncd_activity_contact.primary_flag = 'Y'
					INNER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_contact] AS oncd_contact WITH (NOLOCK)
					    	ON oncd_activity_contact.contact_id = oncd_contact.contact_id
					LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_cstd_contact_completion] cstd_contact_completion  WITH (NOLOCK)
						    ON oncd_activity.activity_id  = cstd_contact_completion.activity_id
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

					AND (
							   (oncd_activity.[creation_date] >= @LSET AND oncd_activity.[creation_date] < @CET)
							OR (oncd_activity.[updated_date] >= @LSET AND oncd_activity.[updated_date] < @CET)
							OR (oncd_activity.[completion_date] >= @LSET AND oncd_activity.[completion_date] < @CET)
							OR (oncd_activity.[due_date] >= @LSET AND oncd_activity.[due_date] <  @CET)
							OR (cstd_contact_completion.[date_saved] >= @LSET AND cstd_contact_completion.[date_saved] <  @CET)   -- 1/26/2010
							OR (cstd_contact_completion.[creation_date] >= @LSET AND cstd_contact_completion.[creation_date] < @CET)
							OR (cstd_contact_completion.[updated_date] >= @LSET AND cstd_contact_completion.[updated_date] < @CET)


							--OR  (oncd_activity.[creation_date] < '1/1/1900')   -- Use on initial Load
							--OR  (oncd_activity.[creation_date] < '1/1/2007')   -- Use on initial Load
							--OR  (oncd_activity.[creation_date] IS NULL)   -- Use on initial Load
							--OR  (oncd_activity.[due_date] IS NULL)   -- Use on initial Load
							--OR  (oncd_activity.[updated_date] IS NULL)   -- Use on initial Load
							--OR  (oncd_activity.[completion_date] IS NULL)   -- Use on initial Load
						)


					----------SELECT	  @DataPkgKey
					----------		, 0 AS [ActivityResultDateKey]
					----------		, CAST(cstd_contact_completion.date_Saved AS DATE) AS [ActivityResultDateSSID]
					----------		, 0 AS [ActivityResultKey]
					----------		, CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.[contact_completion_id])),'') AS varchar(10)) AS [ActivityResultSSID]
					----------		, 0 AS [ActivityResultTimeKey]
					----------		, CAST(cstd_contact_completion.date_Saved AS TIME) AS [ActivityResultTimeSSID]

					----------		, 0 AS [ActivityKey]
					----------		, CAST(ISNULL(LTRIM(RTRIM(oncd_activity.[Activity_ID])),'') AS varchar(10)) AS [ActivitySSID]
					----------		, 0 AS [ActivityDateKey]
					----------		, CAST(oncd_activity.Creation_Date AS DATE) AS [ActivityDateSSID]
					----------		, 0 AS [ActivityTimeKey]
					----------		, CAST(oncd_activity.Creation_Date AS TIME) AS [ActivityTimeSSID]

					----------		, 0 AS [ActivityDueDateKey]
					----------		, CAST(oncd_activity.[due_date] AS DATE) AS [ActivityDueDateSSID]
					----------		, 0 AS [ActivityStartTimeKey]
					----------		, CAST(oncd_activity.[start_time] AS TIME) AS [ActivityStartTimeSSID]
					----------		, 0 AS [ActivityCompletedDateKey]
					----------		, CAST(oncd_activity.[completion_date] AS DATE) AS [ActivityCompletedDateSSID]
					----------		, 0 AS [ActivityCompletedTimeKey]
					----------		, CAST(oncd_activity.[completion_date] AS TIME) AS [ActivityCompletedTimeSSID]

					----------		, 0 AS [OriginalAppointmentDateKey]
					----------		, CAST(cstd_contact_completion.original_appointment_date AS DATE) AS [OriginalAppointmentDateSSID]
					----------		, 0 AS [ActivitySavedDateKey]
					----------		, CAST(cstd_contact_completion.date_Saved AS DATE) AS [ActivitySavedDateSSID]
					----------		, 0 AS [ActivitySavedTimeKey]
					----------		, CAST(cstd_contact_completion.date_Saved AS TIME) AS [ActivitySavedTimeSSID]

					----------		, 0 AS [ContactKey]
					----------		, CAST(LTRIM(RTRIM(cstd_contact_completion.[contact_id])) AS nvarchar(10)) AS [ContactSSID]
					----------		, 0 AS [CenterKey]
					----------		, CAST(LTRIM(RTRIM(cstd_contact_completion.[company_id])) AS nvarchar(10)) AS [CenterSSID]
					----------		, 0 AS [SalesTypeKey]
					----------		, CAST(LTRIM(RTRIM(cstd_contact_completion.[sale_type_code])) AS nvarchar(10)) AS [SalesTypeSSID]
					----------		, 0 AS [SourceKey]
					----------		, CAST(LTRIM(RTRIM(oncd_activity.[Source_code])) AS nvarchar(20)) AS [SourceSSID]
					----------		, 0 AS [ActionCodeKey]
					----------		, CAST(LTRIM(RTRIM(oncd_activity.[action_code])) AS nvarchar(10)) AS [ActionCodeSSID]
					----------		, 0 AS [ResultCodeKey]
					----------		, CAST(LTRIM(RTRIM(oncd_activity.[Result_code])) AS nvarchar(10)) AS [ResultCodeSSID]

					----------		, 0 AS [GenderKey]
					----------		, CAST(LTRIM(RTRIM(cstd_activity_demographic.gender)) AS nvarchar(10)) AS [GenderSSID]
					----------		, 0 AS [OccupationKey]
					----------		, CAST(LTRIM(RTRIM(cstd_activity_demographic.occupation_code)) AS nvarchar(10)) AS [OccupationSSID]
					----------		, 0 AS [EthnicityKey]
					----------		, CAST(LTRIM(RTRIM(cstd_activity_demographic.ethnicity_code)) AS nvarchar(10)) AS [EthnicitySSID]
					----------		, 0 AS [MaritalStatusKey]
					----------		, CAST(LTRIM(RTRIM(cstd_activity_demographic.maritalstatus_code)) AS nvarchar(10)) AS [MaritalStatusSSID]
					----------		, 0 AS [HairLossTypeKey]
					----------		, '' AS [HairLossTypeSSID]
					----------		, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.norwood)),'') AS varchar(50)) AS [NorwoodSSID]
					----------		, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.ludwig)),'') AS varchar(50)) AS [LudwigSSID]
					----------		, 0 AS [AgeRangeKey]
					----------		, 0 AS [AgeRangeSSID]
					----------		, cstd_activity_demographic.age AS [Age]
					----------		, 0 AS [CompletedByEmployeeKey]
					----------		, CAST(LTRIM(RTRIM(oncd_activity.[completed_by_user_code])) AS nvarchar(20)) AS [CompletedByEmployeeSSID]
					----------		, CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.[Client_Number])),'') AS nvarchar(50)) AS [ClientNumber]
					----------		, CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.[show_no_show_flag])),'') AS char(1)) AS [ShowNoShowFlag]
					----------		, CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.[sale_no_sale_flag])),'') AS char(1)) AS [SaleNoSaleFlag]
					----------		, CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.[surgery_offered_flag])),'') AS char(1)) AS [SurgeryOfferedFlag]
					----------		, CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.[referred_to_doctor_flag])),'') AS char(1)) AS [ReferredToDoctorFlag]
					----------		, 0 AS [Show]
					----------		, 0 AS [NoShow]
					----------		, 0 AS [Sale]
					----------		, 0 AS [NoSale]
					----------	    , 0 AS [Consultation]
					----------	    , 0 AS [BeBack]
					----------		, 0 AS [SurgeryOffered]
					----------		, 0 AS [ReferredToDoctor]
					----------		, CAST(ISNULL(LTRIM(RTRIM(cstd_contact_completion.[Initial_Payment])),0) AS decimal (15,4)) AS [InitialPayment]
					----------		, 0 AS [IsNew]
					----------		, 0 AS [IsUpdate]
					----------		, 0 AS [IsDelete]
					----------		, 0 AS [IsException]
					----------		, CAST(LTRIM(RTRIM(cstd_contact_completion.[contact_completion_id])) AS nvarchar(50)) AS [SourceSystemKey]
					----------FROM         [bi_mktg_stage].[synHC_SRC_TBL_MKTG_cstd_contact_completion] cstd_contact_completion WITH (NOLOCK)
					----------LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_cstd_activity_demographic] AS cstd_activity_demographic WITH (NOLOCK)
					----------	    ON cstd_activity_demographic.activity_id  = cstd_contact_completion.activity_id
					----------LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity] AS oncd_activity WITH (NOLOCK)
					----------	    ON oncd_activity.activity_id  = cstd_contact_completion.activity_id
					----------LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity_contact] AS oncd_activity_contact WITH (NOLOCK)
					----------    	ON oncd_activity_contact.activity_id = cstd_contact_completion.activity_id
					----------	   AND oncd_activity_contact.primary_flag = 'Y'

					----------WHERE (cstd_contact_completion.date_Saved >= @LSET AND cstd_contact_completion.date_Saved < @CET)
					----------	AND cstd_contact_completion.activity_id  <> 'UNKNOWN'

					--------------WHERE (cstd_contact_completion.[creation_date] >= @LSET AND cstd_contact_completion.[creation_date] < @CET)
					--------------      OR (cstd_contact_completion.[updated_date] >= @LSET AND cstd_contact_completion.[updated_date] < @CET)

/*

				SELECT
				 @DataPkgKey
				0	AS [ActivityResultDateKey]
				,CAST(Task.ActivityDate AS DATE) AS [ActivityResultDateSSID]
				,0	AS [ActivityResultKey]
				--,task.Result__c	 AS [ActivityResultSSID]
				,NULL AS [ActivityResultSSID]
				,0	AS [ActivityResultTimeKey]
				,CAST(Task.ActivityDate AS TIME)  AS [ActivityResultTimeSSID]
				,0	AS [ActivityKey]
				,Task.ActivityID__c	AS [ActivitySSID]
				,0	AS [ActivityDateKey]
				,CAST(Task.ReportCreateDate__c AS DATE)	AS [ActivityDateSSID]
				,0	AS [ActivityTimeKey]
				,CAST(Task.ReportCreateDate__c AS TIME) AS [ActivityTimeSSID]
				,0	AS [ActivityDueDateKey]
				,CAST(Task.ActivityDate AS DATE) AS [ActivityDueDateSSID]
				,0	AS [ActivityStartTimeKey]
				,CAST(Task.ActivityDate AS TIME) AS [ActivityStartTimeSSID]
				,0	AS [ActivityCompletedDateKey]
				,CAST(Task.CompletionDate__c AS DATE) AS [ActivityCompletedDateSSID]
				,0	AS [ActivityCompletedTimeKey]
				,CAST(Task.CompletionDate__c AS TIME) AS [ActivityCompletedTimeSSID]
				,0 AS [OriginalAppointmentDateKey]
				,CAST(Task.ActivityDate AS DATE) AS [OriginalAppointmentDateSSID]
				,0	AS [ActivitySavedDateKey]
				,CAST(Task.ActivityDate AS DATE) AS [ActivitySavedDateSSID]
				,0	AS [ActivitySavedTimeKey]
				,CAST(Task.ActivityDate AS TIME) AS [ActivitySavedTimeSSID]
				,0	AS [ContactKey]
				,Lead.ContactID__c	AS [ContactSSID]
				,0	AS [CenterKey]
				,ISNULL(Task.CenterID__c,Task.CenterNumber__c) AS [CenterSSID]
				,0	AS [SalesTypeKey]
				,ISNULL(Task.SaleTypeCode__c, '-2')	AS [SalesTypeSSID]
				,0	AS [SourceKey]
				,Lead.Source_Code_Legacy__c  AS [SourceSSID]
				,0	AS [ActionCodeKey]
				--,SFDC_HCM_ActionCode.OnContact_ActionCode
				,ac.ONC_ActionCode AS [ActionCodeSSID]
				--,CASE  WHEN Action__C = 'Appointment' THEN 'APPOINT'
				--      WHEN Action__C = 'BEBACK'      THEN 'BEBACK'
				--	  WHEN Action__C = 'Bosley Lead' THEN 'BOSLEAD'
				--	  WHEN Action__C = 'Outbound Bosley Referral Call' THEN 'BOSREFCALL'
				--	  WHEN Action__C = 'Outbound Brochure Call' THEN 'BROCHCALL'
				--	  WHEN Action__C = 'CANCEL' THEN 'CANCEL'
				--	  WHEN Action__C = 'Outbound Cancel Call' THEN 'CANCELCALL'
				--	  WHEN Action__C = 'Confirmation Call' THEN 'CONFIRM'
				--	  WHEN Action__C = 'Deleted' THEN 'DELETED'
				--	  WHEN Action__C = 'Exception Call' THEN 'EXOUTCALL'
				--	  WHEN Action__C = 'Inbound Call' THEN 'INCALL'
				--	  WHEN Action__C = 'INHOUSE' THEN 'INHOUSE'
				--	  WHEN Action__C = 'Outbound NoShow Call' THEN 'NOSHOWCALL'
				--      WHEN Action__C = 'Recovery' THEN 'RECOVERY'
				--      WHEN Action__C = 'Show No Buy Call' THEN 'SHNOBUYCAL'
				-- 	  WHEN Action__C = 'Confirmation Text Message' THEN 'TXTCONFIRM'
				--   	  WHEN Action__C = 'Web Chat' THEN 'WEBCHAT'
				--	  WHEN Action__C = 'Web Form' THEN 'WEBFORM'
				--	  ELSE '' END
				,0	AS [ResultCodeKey]
				,--SFDC_HCM_ResultCode.OnContact_ResultCode
				rc.ONC_ResultCode AS [ResultCodeSSID]
				,0	AS [GenderKey]
				,CASE WHEN LEAD.Gender__c = 'Male' THEN 'M'
					 WHEN LEAD.Gender__c = 'Female' THEN 'F' ELSE '' END  AS [GenderSSID]
				,0	AS [OccupationKey]
				--,HairClubCMS_lkpOccupation_TABLE.BOSOccupationCode AS [OccupationSSID]
				,o.BosOccupationCode
				--,CASE WHEN Task.Occupation__c = 'Administrative/Secretarial' THEN 2
				--     WHEN Task.Occupation__c = 'Artistic/Music/Writer' THEN 3
				--     WHEN Task.Occupation__c = 'Executive/Management' THEN 4
				--     WHEN Task.Occupation__c = 'Finance' THEN 5
				--     WHEN Task.Occupation__c = 'Food Services' THEN 6
				--     WHEN Task.Occupation__c = 'Government/State' THEN 7
				--     WHEN Task.Occupation__c = 'Homemaker' THEN 8
				--     WHEN Task.Occupation__c = 'Labor/Construction' THEN 9
				--     WHEN Task.Occupation__c = 'Medical/Dental' THEN 11
				--     WHEN Task.Occupation__c = 'Retired' THEN 12
				--     WHEN Task.Occupation__c = 'Sales/Marketing' THEN 13
				--     WHEN Task.Occupation__c = 'Self-employed' THEN 14
				--     WHEN Task.Occupation__c = 'Student' THEN 15
				--     WHEN Task.Occupation__c = 'Teacher/Professor' THEN 16
				--     WHEN Task.Occupation__c = 'Computer/Engineering/Science' THEN 17
				--     WHEN Task.Occupation__c = 'Transportation' THEN 18
				--     WHEN Task.Occupation__c = 'Unemployed' THEN 19
				--     WHEN Task.Occupation__c = 'Other' THEN 20
				--     ELSE 0 END
				,0 AS [EthnicityKey]
				,Ethnicity__c
				,e.BosEthnicityCode AS [EthnicitySSID]
				--,Case WHEN Ethnicity__c  = 'White/Caucasian' THEN 2
				--     WHEN Ethnicity__c  = 'Black/African Descent' THEN 3
				--     WHEN Ethnicity__c  =  'Latino/Hispanic' THEN 4
				--     WHEN Ethnicity__c = 'Asian' THEN 5
				--     WHEN Ethnicity__c  = 'East Indian' THEN 6
				--     WHEN Ethnicity__c  = 'Middle Eastern' THEN 7
				--     WHEN Ethnicity__c  = 'Other' THEN 8
				--     ELSE 0 END

				,0	AS [MaritalStatusKey]
				,m.BOSMaritalStatusCode AS [MaritalStatusSSID]
				--,Case WHEN Task.MaritalStatus__c  = 'Single' THEN 1
				--     WHEN Task.MaritalStatus__c = 'Married' THEN 2
				--     WHEN Task.MaritalStatus__c = 'Divorced' THEN 3
				--     WHEN Task.MaritalStatus__c = 'Widowed' THEN 4
				--     ELSE 0 END
				,0	 AS [HairLossTypeKey]
				,-2	 AS [HairLossTypeSSID]
				,ISNULL(task.NorwoodScale__c, 'Unknown')  AS [NorwoodSSID]
				,ISNULL(task.LudwigScale__c, 'Unknown')	  AS [LudwigSSID]
				,0	AS [AgeRangeKey]
				,'-2' AS [AgeRangeSSID]
				,Lead.Age__c	  AS [Age]
				,0	AS [CompletedByEmployeeKey]
				,Task.Performer__c	AS [CompletedByEmployeeSSID]
				,Task.WhoID	AS [ClientNumber]
				,CASE WHEN Task.Result__c = 'No Show' THEN 'N' ELSE 'S' END	 AS [ShowNoShowFlag]
				,CASE WHEN Task.Result__c = 'Show No Sale' THEN 'N' ELSE 'S' END 	AS [SaleNoSaleFlag]
				,Task.SolutionOffered__c	AS [SurgeryOfferedFlag]
				,'' AS 'ReferredToDoctorFlag'
				,0 AS [Show]
				,0 AS [NoShow]
				,0 AS [Sale]
				,0 AS [NoSale]
				,0 AS [Consultation]
				,0 AS [BeBack]
				,0 AS [SurgeryOffered]
				,0 AS [ReferredToDoctor]
				,NULL AS [InitialPayment]
				,0 AS [ActivityEmployeeKey]
				,CAST(LTRIM(RTRIM(Task.Performer__c)) AS nvarchar(20))	AS [ActivityEmployeeSSID]
				,0 AS [IsNew]
				,0 AS [IsUpdate]
				,0 AS [IsException]
				,0 AS [IsDelete]
				,0 AS [IsDuplicate]
				,ActivityID__c
				FROM HC_BI_SFDC.dbo.Lead    -- WITH (NOLOCK)
					INNER JOIN HC_BI_SFDC.dbo.Task ON Task.WhoID = Lead.ID
					LEFT OUTER JOIN HC_BI_SFDC.dbo.Action__c ac ON ac.Action__c = Task.Action__c
					LEFT OUTER JOIN HC_BI_SFDC.dbo.Result__c rc ON rc.Result__c = Task.Result__c
					LEFT OUTER JOIN HC_BI_SFDC.dbo.HairClubCMS_lkpMaritalStatus_TABLE m ON m.MaritalStatusDescription = Task.MaritalStatus__c
					LEFT OUTER JOIN HC_BI_SFDC.dbo.HairClubCMS_lkpEthnicity_TABLE e ON e.EthnicityDescription = Lead.Ethnicity__c
					LEFT OUTER JOIN [dbo].[HairClubCMS_lkpOccupation_TABLE] o ON o.OccupationDescription = Task.Occupation__c

				WHERE (((Task.Action__c IN ('Appointment', 'In House', 'Be Back')) AND ((Task.Result__c NOT IN ( 'Reschedule', 'Cancel', 'Center Exception', 'Void' )) OR (Task.Result__c IS NULL) ))
						OR ((Task.Action__c IN ('Recovery')) AND ((Task.Result__c IS NOT NULL)) AND (Task.Result__c IN ('Show Sale','Show No Sale','No Show'))))

						AND Task.IsDeleted = 0
						AND (
							(task.CreatedDate >= @LSET AND task.CreatedDate < @CET)
							OR (task.lastmodifieddate >= @LSET AND task.lastmodifieddate < @CET)
							OR (task.CompletionDate__c >= @LSET AND task.CompletionDate__c < @CET)
							OR (task.ActivityDate >= @LSET AND task.ActivityDate <  @CET)
							OR (lead.CreatedDate >= @LSET AND lead.CreatedDate < @CET)
							OR (lead.lastmodifieddate >= @LSET AND lead.lastmodifieddate < @CET)
							)


*/



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
