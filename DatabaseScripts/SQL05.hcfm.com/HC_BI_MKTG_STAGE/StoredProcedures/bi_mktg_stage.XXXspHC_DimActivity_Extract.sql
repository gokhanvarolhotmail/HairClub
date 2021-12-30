/* CreateDate: 05/03/2010 12:26:29.967 , ModifyDate: 08/05/2019 12:01:07.977 */
GO
CREATE PROCEDURE [bi_mktg_stage].[XXXspHC_DimActivity_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimActivity_Extract] is used to retrieve
--  Activites
--
--   exec [bi_mktg_stage].[spHC_DimActivity_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author      Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009  RLifke      Initial Creation
--  v1.1	04/27/2017	RHut
--			10/20/2017  KMurdoch     Added SFDC_TaskID & SFDC_LeadID; Added join to ONCD_Contact
--			08/05/2019	DLeiba		Modified to derive data from Salesforce
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

 	SET @TableName = N'[bi_mktg_dds].[DimActivity]'


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
							)
							SELECT	@DataPkgKey AS 'DataPkgKey'
							,		NULL AS 'ActivityKey'
							,		CAST(ISNULL(LTRIM(RTRIM(t.ActivityID__c)),'') AS nvarchar(10)) AS 'ActivitySSID'
							,		CAST(ISNULL(LTRIM(RTRIM(t.ActivityDate)),'') AS date) AS 'ActivityDueDate'
							,		CAST(ISNULL(LTRIM(RTRIM(t.StartTime__c)),'') AS time) AS 'ActivityStartTime'
							,		CAST(ISNULL(LTRIM(RTRIM(t.CompletionDate__c)),'') AS date) AS 'ActivityCompletionDate'
							,		CAST(ISNULL(LTRIM(RTRIM(t.CompletionDate__c)),'') AS time) AS 'ActivityCompletionTime'
							,		CAST(ISNULL(LTRIM(RTRIM(a.ONC_ActionCode)),'') AS nvarchar(10)) AS 'ActionCodeSSID'
							,		CAST(ISNULL(LTRIM(RTRIM(t.Action__c)),'') AS nvarchar(50)) AS 'ActionCodeDescription'
							,		CAST(ISNULL(LTRIM(RTRIM(r.ONC_ResultCode)),'') AS nvarchar(10)) AS 'ResultCodeSSID'
							,		CAST(ISNULL(LTRIM(RTRIM(t.Result__c)),'') AS nvarchar(50)) AS 'ResultCodeDescription'
							,		CAST(ISNULL(LTRIM(RTRIM(t.SourceCode__c)),'') AS nvarchar(20)) AS 'SourceSSID'
							,		CAST(ISNULL(LTRIM(RTRIM(t.SourceCode__c)),'') AS nvarchar(50)) AS 'SourceCodeDescription'
							,		CAST(ISNULL(COALESCE(LTRIM(RTRIM(t.CenterNumber__c)), (LTRIM(RTRIM(t.CenterID__c)))),'-2') AS nvarchar(10)) AS 'CenterSSID'
							,		CAST(ISNULL(LTRIM(RTRIM(t.LeadOncContactID__c)),'') AS nvarchar(10)) AS 'ContactSSID'
							,		CAST(ISNULL(LTRIM(RTRIM(t.SaleTypeCode__c)),'') AS nvarchar(10)) AS 'SalesTypeSSID'
							,		CAST(ISNULL(LTRIM(RTRIM(t.SaleTypeDescription__c)),'') AS nvarchar(50)) AS 'SalesTypeDescription'
							,		CAST(ISNULL(LTRIM(RTRIM(t.ActivityType__c)),'') AS nvarchar(10)) AS 'ActivityTypeSSID'
							,		CAST(ISNULL(LTRIM(RTRIM(t.ActivityType__c)),'') AS nvarchar(50)) AS 'ActivityTypeDescription'
							,		CAST(ISNULL(LTRIM(RTRIM(t.TimeZone__c)),'') AS nvarchar(10)) AS 'TimeZoneSSID'
							,		CASE
										WHEN TimeZone__C = 'AKS' THEN 'Alaskan Standard'
										WHEN TimeZone__C = 'AST' THEN 'Atlantic Standard'
										WHEN TimeZone__C = 'ChST' THEN 'Chamorro Standard'
										WHEN TimeZone__C = 'CST' THEN 'Central Standard'
										WHEN TimeZone__C = 'EST' THEN 'Eastern Standard'
										WHEN TimeZone__C = 'HST' THEN 'Hawaii-Aleutian Standard'
										WHEN TimeZone__C = 'MST' THEN 'Mountain Standard'
										WHEN TimeZone__C = 'NST' THEN 'Newfoundland Standard'
										WHEN TimeZone__C = 'PST' THEN 'Pacific Standard'
										WHEN TimeZone__C = 'UNK' THEN 'Unknown'
										ELSE ''
									END AS 'TimeZoneDescription'
							,		CAST(CASE
										WHEN TimeZone__C = 'AKS' THEN -9
										WHEN TimeZone__C = 'AST' THEN -4
										WHEN TimeZone__C = 'ChST' THEN 10
										WHEN TimeZone__C = 'CST' THEN -6
										WHEN TimeZone__C = 'EST' THEN -5
										WHEN TimeZone__C = 'HST' THEN -10
										WHEN TimeZone__C = 'MST' THEN -7
										WHEN TimeZone__C = 'NST' THEN -3.5
										WHEN TimeZone__C = 'PST' THEN -8
										WHEN TimeZone__C = 'UNK' THEN 0
										ELSE ''
									END AS FLOAT) AS 'GreenwichOffset'
							,		CAST(ISNULL(LTRIM(RTRIM(t.PromoCode__c)),'') AS nvarchar(10)) AS 'PromotionCodeSSID'
							,		CAST(ISNULL(LTRIM(RTRIM(t.PromoCode__c)),'') AS nvarchar(50)) AS 'PromotionCodeDescription'
							,		bi_mktg_stage.fn_IsAppointment(a.ONC_ActionCode, r.ONC_ResultCode) AS 'IsAppointment'
							,		bi_mktg_stage.fn_IsShow(r.ONC_ResultCode) AS 'IsShow'
							,		bi_mktg_stage.fn_IsNoShow(r.ONC_ResultCode) AS 'IsNoShow'
							,		bi_mktg_stage.fn_IsSale(r.ONC_ResultCode) AS 'IsSale'
							,		bi_mktg_stage.fn_IsNoSale(r.ONC_ResultCode) AS 'IsNoSale'
							,		bi_mktg_stage.fn_IsConsultation(a.ONC_ActionCode, r.ONC_ResultCode) AS 'IsConsultation'
							,		bi_mktg_stage.fn_IsBeBack(a.ONC_ActionCode, r.ONC_ResultCode) AS 'IsBeBack'
							,		t.Id
							,		t.WhoId
							,		GETDATE() AS 'ModifiedDate'
							,		0 AS 'IsNew'
							,		0 AS 'IsType1'
							,		0 AS 'IsType2'
							,		0 AS 'IsException'
							,		0 AS 'IsInferredMember'
							,		0 AS 'IsDelete'
							,		0 AS 'IsDuplicate'
							,		CAST(ISNULL(LTRIM(RTRIM(t.Id)),'') AS nvarchar(50)) AS 'SourceSystemKey'
							FROM	HC_BI_SFDC.dbo.Task t
									LEFT OUTER JOIN HC_BI_SFDC.dbo.Action__c a
										ON a.Action__c = t.Action__c
											AND a.IsActiveFlag = 1
									LEFT OUTER JOIN HC_BI_SFDC.dbo.Result__c r
										ON r.Result__c = t.Result__c
											AND r.IsActiveFlag = 1
							WHERE	 ( t.ReportCreateDate__c >= @LSET AND t.ReportCreateDate__c < @CET )
											OR ( t.LastModifiedDate >= @LSET AND t.LastModifiedDate < @CET )
											OR ( t.ActivityDate >= @LSET AND t.ActivityDate < @CET )
											OR ( t.CompletionDate__c >= @LSET AND t.CompletionDate__c < @CET )


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
