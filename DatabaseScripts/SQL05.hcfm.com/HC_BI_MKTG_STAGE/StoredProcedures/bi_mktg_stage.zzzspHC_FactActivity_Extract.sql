/* CreateDate: 05/03/2010 12:26:55.350 , ModifyDate: 08/05/2019 10:55:51.840 */
GO
CREATE PROCEDURE [bi_mktg_stage].[zzzspHC_FactActivity_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_FactActivity_Extract] is used to retrieve a
-- list of Activity Transactions
--
--   exec [bi_mktg_stage].[spHC_FactActivity_Extract]  ''2009-01-01 01:00:00''
--                                       , ''2009-01-02 01:00:00''
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/20/2009  RLifke       Initial Creation
--			08/05/2011	KMurdoch	 Added ActivityUserKey
--			08/29/2013  KMurdoch	 Modified ActivityTypeID
--			12/10/2013  KMurdoch	 Updated Select to be Inner Joins rather than Left Outer
--			04/27/2017	RHut		 Added oncd_activity_company to find the CenterSSID on the activity
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

 	SET @TableName = N'[bi_mktg_dds].[FactActivity]'


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


				INSERT INTO [bi_mktg_stage].[FactActivity]
						   ( [DataPkgKey]
						    , [ActivityDateKey]
						    , [ActivityDateSSID]
						    , [ActivityTimeKey]
						    , [ActivityTimeSSID]
						    , [ActivityKey]
						    , [ActivitySSID]

							, [ActivityDueDateKey]
						    , [ActivityDueDateSSID]
						    , [ActivityStartTimeKey]
						    , [ActivityStartTimeSSID]

						    , [ActivityCompletedDateKey]
						    , [ActivityCompletedDateSSID]
						    , [ActivityCompletedTimeKey]
						    , [ActivityCompletedTimeSSID]

						    , [GenderKey]
						    , [GenderSSID]
						    , [EthnicityKey]
						    , [EthnicitySSID]
						    , [OccupationKey]
						    , [OccupationSSID]
						    , [MaritalStatusKey]
						    , [MaritalStatusSSID]
						    , [AgeRangeKey]
						    , [Age]
						    , [AgeRangeSSID]
						    , [HairLossTypeKey]
						    , [HairLossTypeSSID]
							, [NorwoodSSID]
							, [LudwigSSID]
						    , [CenterKey]
						    , [CenterSSID]
						    , [ContactKey]
						    , [ContactSSID]
						    , [ActionCodeKey]
						    , [ActionCodeSSID]
						    , [ResultCodeKey]
						    , [ResultCodeSSID]
						    , [SourceKey]
						    , [SourceSSID]
						    , [ActivityTypeKey]
						    , [ActivityTypeSSID]
						    , [CompletedByEmployeeKey]
						    , [CompletedByEmployeeSSID]
						    , [StartedByEmployeeKey]
						    , [StartedByEmployeeSSID]
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
							, 0 AS [ActivityDateKey]
							, CAST(activity.Creation_Date AS DATE) AS [ActivityDateSSID]
							, 0 AS [ActivityTimeKey]
							, CAST(activity.Creation_Date AS TIME) AS [ActivityTimeSSID]
							, 0 AS [ActivityKey]
							, activity.[Activity_ID] AS [ActivitySSID]


							, 0 AS [ActivityDueDateKey]
							, CAST(activity.[due_date] AS DATE) AS [ActivityDueDateSSID]
							, 0 AS [ActivityStartTimeKey]
							, CAST(activity.[start_time] AS TIME) AS [ActivityStartTimeSSID]

							, 0 AS [ActivityCompletedDateKey]
							, CAST(activity.[completion_date] AS DATE) AS [ActivityCompletedDateSSID]
							, 0 AS [ActivityCompletedTimeKey]
							, CAST(activity.[completion_date] AS TIME) AS [ActivityCompletedTimeSSID]

							, 0 AS [GenderKey]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.gender)),'U') AS nvarchar(10)) AS [GenderSSID]
							, 0 AS [EthnicityKey]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.ethnicity_code)),'-2') AS nvarchar(10)) AS [EthnicitySSID]
							, 0 AS [OccupationKey]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.occupation_code)),'-2') AS nvarchar(10)) AS [OccupationSSID]
							, 0 AS [MaritalStatusKey]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.maritalstatus_code)),'-2') AS nvarchar(10)) AS [MaritalStatusSSID]
							, 0 AS [AgeRangeKey]
							, cstd_activity_demographic.age AS [Age]
							, '-2' AS [AgeRangeSSID]
							, 0 AS [HairLossTypeKey]
							, '-2' AS [HairLossTypeSSID]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.norwood)),'') AS varchar(50)) AS [NorwoodSSID]
							, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.ludwig)),'') AS varchar(50)) AS [LudwigSSID]
							, 0 AS [CenterKey]

							--, CAST(ISNULL(LTRIM(RTRIM(oncd_company.[cst_center_number])),'-2') AS nvarchar(10)) AS [CenterSSID]
							--New COALESCE - 4/27/2017
								, CAST(ISNULL(COALESCE(LTRIM(RTRIM(activitycompany.[cst_center_number])), (LTRIM(RTRIM(contactcompany.[cst_center_number])))),'-2') AS nvarchar(10)) AS [CenterSSID]

							, 0 AS [ContactKey]
							, CAST(LTRIM(RTRIM(oncd_activity_contact.[contact_id])) AS nvarchar(10)) AS [ContactSSID]
							, 0 AS [ActionCodeKey]
							, CAST(LTRIM(RTRIM(activity.[action_code])) AS nvarchar(10)) AS [ActionCodeSSID]
							, 0 AS [ResultCodeKey]
							, CAST(LTRIM(RTRIM(activity.[Result_code])) AS nvarchar(10)) AS [ResultCodeSSID]
							, 0 AS [SourceKey]
							, CAST(LTRIM(RTRIM(activity.[Source_code])) AS nvarchar(20)) AS [SourceSSID]
							, 0 AS [ActivityTypeKey]
							--, CAST(LTRIM(RTRIM(activity.[cst_Activity_Type_code])) AS nvarchar(10)) AS [ActivityTypeSSID]
							, CAST(LTRIM(RTRIM(CASE
											WHEN activity.[action_code] IN ('INCALL')
												OR (
													activity.[action_code] IN ('APPOINT')
													AND activity.[cst_Activity_Type_code] = 'Inbound'
													) THEN 'INBOUND'
											WHEN activity.[action_code] IN ('BROCHCALL', 'EXOUTCALL','NOSHOWCALL','CANCELCALL')
												OR (
													activity.[action_code] IN ('APPOINT')
													AND activity.[cst_Activity_Type_code] = 'Outbound'
													) THEN 'OUTBOUND'
											WHEN activity.[action_code] IN ('BEBACK') THEN 'BEBACK'
											WHEN activity.[action_code] IN ('INHOUSE') THEN 'INHOUSE'
											WHEN activity.[action_code] IN ('CONFIRM') THEN 'CONFIRM'
											ELSE 'UNKNOWN'
											END
											)) AS nvarchar(10)) AS [ActivityTypeSSID]
							, 0 AS [CompletedByEmployeeKey]
							, CAST(LTRIM(RTRIM(activity.[completed_by_user_code])) AS nvarchar(20)) AS [CompletedByEmployeeSSID]
							, 0 AS [StartedByEmployeeKey]
							, CAST(LTRIM(RTRIM(activity.[created_by_user_code])) AS nvarchar(20)) AS [StartedByEmployeeSSID]
							, 0 AS [ActivityEmployeeKey]
							, CAST(LTRIM(RTRIM(oncd_activity_user.[user_code])) AS nvarchar(20)) AS [ActivityEmployeeSSID]
							, 0 AS [IsNew]
							, 0 AS [IsUpdate]
							, 0 AS [IsException]
							, 0 AS [IsDelete]
							, 0 AS [IsDuplicate]
							, CAST(LTRIM(RTRIM(activity.[Activity_ID])) AS nvarchar(50)) AS [SourceSystemKey]
					FROM         [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity] activity WITH (NOLOCK)
					LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_cstd_activity_demographic] AS cstd_activity_demographic WITH (NOLOCK)
						    ON cstd_activity_demographic.activity_id  = activity.activity_id
					----LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_cstd_contact_completion] AS cstd_contact_completion WITH (NOLOCK)
					----	    ON  cstd_contact_completion.activity_id = activity.activity_id
					INNER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity_contact] AS oncd_activity_contact WITH (NOLOCK)
					    	ON oncd_activity_contact.activity_id = activity.activity_id
						   AND oncd_activity_contact.primary_flag = 'Y'
					LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity_user] AS oncd_activity_user WITH (NOLOCK)
					    	ON oncd_activity_user.activity_id = activity.activity_id
						   AND oncd_activity_user.primary_flag = 'Y'
					--INNER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_contact_company] AS oncd_contact_company WITH (NOLOCK)
					--			ON  oncd_activity_contact.[contact_id] = oncd_contact_company.contact_id
					--			AND oncd_contact_company.primary_flag = 'Y'
					--INNER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_company] AS oncd_company WITH (NOLOCK)
					--			ON  oncd_contact_company.company_id = oncd_company.company_id

				--New table to use
				LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity_company]  oncd_activity_company  --Newly created synonym
					ON oncd_activity_company.activity_id = activity.activity_id
					AND oncd_activity_company.primary_flag = 'Y'

				--Change to LEFT OUTER JOIN
				LEFT OUTER JOIN[bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_contact_company] oncd_contact_company
						ON  oncd_activity_contact.[contact_id] = oncd_contact_company.contact_id
						AND oncd_contact_company.primary_flag = 'Y'

				LEFT JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_company] activitycompany
						ON  activitycompany.company_id = oncd_activity_company.company_id 		--NEW
				LEFT JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_company] contactcompany
						ON  contactcompany.company_id = oncd_contact_company.company_id 		--NEW

					WHERE (activity.[creation_date] >= @LSET AND activity.[creation_date] < @CET)
					   OR (activity.[updated_date] >= @LSET AND activity.[updated_date] < @CET)
					   OR (activity.[due_date] >= @LSET AND activity.[due_date] < @CET)
					   OR (activity.[completion_date] >= @LSET AND activity.[completion_date] < @CET)
						OR (cstd_activity_demographic.[creation_date] >= @LSET AND cstd_activity_demographic.[creation_date] < @CET)    -- 1/30/2010
						OR (cstd_activity_demographic.[updated_date] >= @LSET AND cstd_activity_demographic.[updated_date] < @CET)    -- 1/30/2010

				--OR  (activity.[creation_date] < '1/1/1990')   -- Use on initial Load
				--OR  (activity.[creation_date] < '1/1/2007')   -- Use on initial Load
				--OR  (activity.[creation_date] IS NULL)   -- Use on initial Load
				--OR  (activity.[due_date] IS NULL)   -- Use on initial Load
				--OR  (activity.[updated_date] IS NULL)   -- Use on initial Load
				--OR  (activity.[completion_date] IS NULL)   -- Use on initial Load

					--Per Kevin 10/29/2009  use due_date
					--WHERE (activity.[completion_date] >= @LSET AND activity.[completion_date] < @CET)

/*


			SELECT
			@DataPkgKey
			,0	AS ActivityDateKey
			,CAST(Task.ActivityDate AS TIME) AS ActivityDateSSID
			,0	AS ActivityTimeKey
			,CAST(Task.ActivityDate AS TIME) AS ActivityTimeSSID
			,0	AS ActivityKey
			,Task.ActivityID__c AS ActivitySSID
			,0	AS ActivityDueDateKey
			,CAST(Task.ActivityDate AS DATE) AS ActivityDueDateSSID
			,0 AS ActivityStartTimeKey
			,CAST(Task.ActivityDate AS TIME) AS ActivityStartTimeSSID
			,0  AS ActivityCompletedDateKey
			,CAST(Task.CompletionDate__c AS DATE) AS ActivityCompletedDateSSID
			,0 AS ActivityCompletedTimeKey
			,CAST(Task.CompletionDate__c AS TIME) AS  ActivityCompletedTimeSSID
			,0 AS GenderKey
				,CASE WHEN Lead.Gender__c = 'M' THEN 'Male'
				WHEN Lead.Gender__c= 'F' THEN 'Female'
				ELSE '' END  AS GenderSSID
			,0	AS EthnicityKey
			,ISNULL(Task.LeadOncEthnicity__c, -2) AS EthnicitySSID
			,0 OccupationKey
			,ISNULL(Task.Occupation__c, -2)	AS OccupationSSID
			,0	AS MaritalStatusKey
			,ISNULL(m.BOSMaritalStatusCode, -2) AS MaritalStatusSSID
			,0 AS AgeRangeKey
			,ISNULL(Task.LeadOncAge__c, 0)	AS Age
			,-2	AS AgeRangeSSID
			,0	AS HairLossTypeKey
			,-2	AS HairLossTypeSSID
			,Task.NorwoodScale__c AS NorwoodSSID
			,Task.LudwigScale__c AS LudwigSSID
			,0	AS CenterKey
			,ISNULL(Task.CenterID__c, Task.CenterNumber__c)	AS CenterSSID
			,0	AS ContactKey
			,lead.ContactID__c AS ContactSSID
			,0	AS ActionCodeKey
			,ac.ONC_ActionCode AS ActionCodeSSID
			,0	AS ResultCodeKey
			,rc.ONC_ResultCode
			,0	AS SourceKey
			,Task.SourceCode__c AS SourceSSID
			,0	AS ActivityTypeKey
			,Task.ActivityType__c AS ActivityTypeSSID
			,0	AS CompletedByEmployeeKey
			,CASE WHEN Task.Result__c = 'Complete' THEN Task.Performer__c ELSE NULL END	AS CompletedByEmployeeSSID
			,0 AS StartedByEmployeeKey
			,''	AS StartedByEmployeeSSID
			,0 AS ActivityEmployeeKey
			,Task.Performer__c
			, 0 AS IsNew
			, 0 AS IsUpdate
			, 0 AS IsException
			, 0 AS IsDelete
			, 0 AS IsDuplicate
			,Task.ActivityID__c

			FROM dbo.Task
					LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead  ON Lead.Id = Task.WhoId
					LEFT OUTER JOIN HC_BI_SFDC.dbo.Action__c ac ON ac.Action__c = Task.Action__c
					LEFT OUTER JOIN HC_BI_SFDC.dbo.Result__c rc ON rc.Result__c = Task.Result__c
					LEFT OUTER JOIN HC_BI_SFDC.dbo.HairClubCMS_lkpMaritalStatus_TABLE m ON m.MaritalStatusDescription = Task.MaritalStatus__c

			--WHERE task.ActivityDate >= @LSET AND task.ActivityDate < @CET AND
			--		task.IsDeleted = 0

		   	WHERE ((task.CreatedDate >= @LSET AND task.CreatedDate < @CET)
				  OR (task.lastmodifieddate >= @LSET AND task.lastmodifieddate < @CET)
				  OR (task.CompletionDate__c >= @LSET AND task.CompletionDate__c < @CET)
				  OR (task.ActivityDate >= @LSET AND task.ActivityDate <  @CET)
				  OR (lead.CreateDate >= @LSET AND lead.CreateDate < @CET)
				  OR (lead.lastmodifieddate >= @LSET AND lead.lastmodifieddate < @CET))
				  AND task.IsDeleted = 0


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
