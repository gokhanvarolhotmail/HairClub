/* CreateDate: 05/03/2010 12:26:27.817 , ModifyDate: 08/05/2019 11:23:24.500 */
GO
CREATE PROCEDURE [bi_mktg_stage].[zzzspHC_DimActivityResult_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimActivityResult_Extract] is used to retrieve
--  Activity Results
--
--   exec [bi_mktg_stage].[spHC_DimActivityResult_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009  RLifke       Initial Creation
--			08/07/2012  KMurdoch     Added Completion date
--			11/13/2017	RHut		 Added VOID to the statement ((oncd_activity.[Result_code] NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN', 'VOID' ))
--			11/21/2017  KMurdoch	 Added SFDC_Lead/Task_ID
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

 	SET @TableName = N'[bi_mktg_dds].[DimActivityResult]'


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
							)
				SELECT @DataPkgKey
						, NULL AS [ActivityResultKey]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[contact_completion_id])),'') AS nvarchar(10)) AS [ActivityResultSSID]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[company_id])),'') AS nvarchar(10)) AS [CenterSSID]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[activity_id])),'') AS nvarchar(10)) AS [ActivitySSID]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[contact_id])),'') AS nvarchar(10)) AS [ContactSSID]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[sale_type_code])),'') AS nvarchar(10)) AS [SalesTypeSSID]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[sale_type_description])),'') AS nvarchar(50)) AS [SalesTypeDescription]
						, CAST(ISNULL(LTRIM(RTRIM(oncd_activity.[action_code])),'') AS nvarchar(10)) AS [ActionCodeSSID]
						, CAST(ISNULL(LTRIM(RTRIM(onca_action.[description])),'') AS nvarchar(50)) AS [ActionCodeDescription]
						, CAST(ISNULL(LTRIM(RTRIM(oncd_activity.[result_code])),'') AS nvarchar(10)) AS [ResultCodeSSID]
						, CAST(ISNULL(LTRIM(RTRIM(onca_result.[description])),'') AS nvarchar(50)) AS [ResultCodeDescription]
						, CAST(ISNULL(LTRIM(RTRIM(oncd_activity.[source_code])),'') AS nvarchar(20)) AS [SourceSSID]
						, CAST(ISNULL(LTRIM(RTRIM(onca_source.[description])),'') AS nvarchar(50)) AS [SourceCodeDescription]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[show_no_show_flag])),'') AS nchar(1)) AS [IsShow]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[sale_no_sale_flag])),'') AS nchar(1)) AS [IsSale]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[contract_number])),'') AS nvarchar(10)) AS [ContractNumber]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[contract_amount])),0) AS decimal(15,4)) AS [ContractAmount]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[client_number])),'') AS nvarchar(50)) AS [ClientNumber]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[initial_payment])),0) AS decimal(15,4)) AS [InitialPayment]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[number_of_graphs])),'') AS int) AS [NumOfGraphs]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[original_appointment_date])),'1753-01-01 00:00:00.000') AS date) AS [OrigApptDate]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[date_saved])),'1753-01-01 00:00:00.000') AS date) AS [DateSaved]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[reschedule_flag])),'') AS nchar(1)) AS [RescheduleFlag]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[date_rescheduled])),'1753-01-01 00:00:00.000') AS date) AS [RescheduledDate]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[surgery_offered_flag])),'') AS nchar(1)) AS [SurgeryOffered]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[referred_to_doctor_flag])),'') AS nchar(1)) AS [ReferredToDoctor]
						, oncd_contact.cst_sfdc_lead_id
						, oncd_activity.cst_sfdc_task_id
						, GETDATE() --[LastUpdate] AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, CAST(ISNULL(LTRIM(RTRIM(activityresult.[contact_completion_id])),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM [bi_mktg_stage].[synHC_SRC_TBL_MKTG_cstd_contact_completion] activityresult WITH (NOLOCK)
				LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity] AS oncd_activity WITH (NOLOCK)
							ON oncd_activity.activity_id  = activityresult.activity_id
				LEFT OUTER JOIN hcm.dbo.oncd_contact oncd_contact
							ON oncd_contact.contact_id = activityresult.contact_id
				LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_onca_action] onca_action  WITH (NOLOCK)
							ON oncd_activity.[action_code] = onca_action.[action_code]
				LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_onca_result] onca_result WITH (NOLOCK)
							ON oncd_activity.[result_code] = onca_result.[result_code]
				LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_onca_source] onca_source WITH (NOLOCK)
							ON oncd_activity.[source_code] = onca_source.[source_code]

				--WHERE (ActivityResult.[creation_date] >= @LSET AND ActivityResult.[creation_date] < @CET)
				--   OR (ActivityResult.[updated_date] >= @LSET AND ActivityResult.[updated_date] < @CET)
				--   OR (ActivityResult.[date_saved] >= @LSET AND ActivityResult.[date_saved] < @CET)
				--   OR (oncd_activity.[completion_date] >= @LSET AND oncd_activity.[completion_date] < @CET)

				--OR (ActivityResult.[creation_date] IS NULL)    -- Use on initial Load
				--OR (ActivityResult.[creation_date] < '1/1/1990')   -- Use on initial Load

				WHERE (((oncd_activity.[action_code] IN ('APPOINT', 'INHOUSE', 'BEBACK')) AND ((oncd_activity.[Result_code] NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN', 'VOID' )) OR (oncd_activity.[Result_code] IS NULL) ))
						OR ((oncd_activity.[action_code] IN ('RECOVERY')) AND ((oncd_activity.[Result_code] IS NOT NULL)) AND (oncd_activity.[Result_code] IN ('SHOWSALE','SHOWNOSALE','NOSHOW'))))

				AND (
						   (oncd_activity.[creation_date] >= @LSET AND oncd_activity.[creation_date] < @CET)
						OR (oncd_activity.[updated_date] >= @LSET AND oncd_activity.[updated_date] < @CET)
						OR (oncd_activity.[completion_date] >= @LSET AND oncd_activity.[completion_date] < @CET)
						OR (oncd_activity.[due_date] >= @LSET AND oncd_activity.[due_date] <  @CET)
						OR (activityresult.[date_saved] >= @LSET AND activityresult.[date_saved] <  @CET)   -- 1/26/2010
						OR (activityresult.[creation_date] >= @LSET AND activityresult.[creation_date] < @CET)
						OR (activityresult.[updated_date] >= @LSET AND activityresult.[updated_date] < @CET)


						--OR  (oncd_activity.[creation_date] < '1/1/1900')   -- Use on initial Load
						--OR  (oncd_activity.[creation_date] < '1/1/2007')   -- Use on initial Load
						--OR  (oncd_activity.[creation_date] IS NULL)   -- Use on initial Load
						--OR  (oncd_activity.[due_date] IS NULL)   -- Use on initial Load
						--OR  (oncd_activity.[updated_date] IS NULL)   -- Use on initial Load
						--OR  (oncd_activity.[completion_date] IS NULL)   -- Use on initial Load
					)


/*

				SELECT
				t.ActivityDate,
				'' AS '@DataPkgKey'
				, NULL AS  ActivityResultKey
				,null AS  ActivityResultSSID
				,ISNULL(t.CenterID__c,t.CenterNumber__c) AS CenterSSID
				,t.ActivityID__c AS ActivitySSID
				,t.LeadOncContactID__c AS ContactSSID
				,t.SaleTypeCode__c AS SalesTypeSSID
				,t.Result__c AS SalesTypeDescription
				,ac.ONC_ActionCode AS ActionCodeSSID
				,t.Action__c AS ActionCodeDescription
				,rc.onc_resultcode AS ResultCodeSSID
                ,t.Result__c AS ResultCodeDescription
				,t.SourceCode__c AS SourceSSID
				,t.SourceCode__c AS SourceCodeDescription
				,CASE WHEN rc.onc_resultcode = 'NOSHOW' THEN 'N'
				      WHEN rc.onc_resultcode IN ('SHOWSALE','SHOWNOSALE') THEN 'Y'
				 ELSE '' END AS IsShow
				,CASE WHEN rc.onc_resultcode = 'SHOWSALE' THEN 'Y'
				 ELSE '' END AS IsSale
				,'' AS ContractNumber
				,0  AS ContractAmount
				,l.ContactID__c AS ClientNumber
				,0  AS InitialPayment
				,0  AS NumOfGraphs
				,null AS OrigApptDate
				,null AS DateSaved
				,null AS RescheduleFlag
				,null AS RescheduledDate
				,null AS SurgeryOffered
				,null AS ReferredToDoctor
				,t.whoid AS cst_sfdc_lead_id
				,t.id AS cst_sfdc_task_id
				,t.LastModifiedDate AS 'ModifiedDate'
				, 0 AS  IsNew
				, 0 AS  IsType1
				, 0 AS  IsType2
				, 0 AS  IsException
				, 0 AS  IsInferredMember
				, 0 AS  IsDelete
				, 0 AS  IsDuplicate
				, null AS  SourceSystemKey

				FROM
				HC_BI_SFDC.dbo.Task t
				        LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l ON l.Id = t.WhoId
				        LEFT OUTER JOIN HC_BI_SFDC.dbo.Action__c ac ON ac.Action__c = t.Action__c
						LEFT OUTER JOIN HC_BI_SFDC.dbo.Result__c rc ON rc.result__c = t.result__c



				--WHERE t.ActivityDate >= @LSET AND t.ActivityDate < @CET AND
				--t.IsDeleted = 0 AND
				-- (((ac.ONC_ActionCode IN ('APPOINT', 'INHOUSE', 'BEBACK')) AND ((rc.ONC_ResultCode NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN', 'VOID' )) OR (rc.ONC_ResultCode IS NULL) ))
				--		OR ((ac.ONC_ActionCode IN ('RECOVERY')) AND ((rc.ONC_ResultCode IS NOT NULL)) AND (rc.ONC_ResultCode IN ('SHOWSALE','SHOWNOSALE','NOSHOW'))))



				Where t.IsDeleted = 0 AND
				    (
					(t.CreatedDate >= @LSET AND t.CreatedDate < @CET)
				    OR (t.lastmodifieddate >= @LSET AND t.lastmodifieddate < @CET)
				    OR (t.CompletionDate__c >= @LSET AND t.CompletionDate__c < @CET)
				    OR (t.ActivityDate >= @LSET AND t.ActivityDate <  @CET)
				    OR (l.CreatedDate >= @LSET AND l.CreatdeDate < @CET)
				    OR (l.lastmodifieddate >= @LSET AND l.lastmodifieddate < @CET)
					) AND
				 (((ac.ONC_ActionCode IN ('APPOINT', 'INHOUSE', 'BEBACK')) AND ((rc.ONC_ResultCode NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN', 'VOID' )) OR (rc.ONC_ResultCode IS NULL) )) OR
				  ((ac.ONC_ActionCode IN ('RECOVERY')) AND ((rc.ONC_ResultCode IS NOT NULL)) AND (rc.ONC_ResultCode IN ('SHOWSALE','SHOWNOSALE','NOSHOW'))))



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
