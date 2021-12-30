/* CreateDate: 08/05/2019 11:24:19.180 , ModifyDate: 08/24/2021 16:48:56.820 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimActivityResult_Extract]
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
--			08/05/2019	KMurdoch	 Migrate ONC to SFDC
--			07/10/2020  KMurdoch     Added Accomodation
--			08/10/2020  KMurdoch     Removed restriction for result code
--			09/10/2020  KMurdoch     Added SFDC_PersonAccountID and then an update statement
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
						   , [SFDC_PersonAccountID]
						   , [SFDC_TaskID]
						   , [Accomodation]
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
				,		NULL AS [ActivityResultKey]
				,		CAST(ISNULL(LTRIM(RTRIM(t.ActivityID__c)),'') AS nvarchar(10)) AS [ActivityResultSSID]
				,		ISNULL(t.CenterNumber__c, t.CenterID__c) AS [CenterSSID]
				,		CAST(ISNULL(LTRIM(RTRIM(t.ActivityID__c)),'') AS nvarchar(10)) AS [ActivitySSID]
				,		CAST(ISNULL(LTRIM(RTRIM(t.LeadOncContactID__c)),'') AS nvarchar(10)) AS [ContactSSID]
				,		CAST(ISNULL(LTRIM(RTRIM(t.SaleTypeCode__c)),'0') AS nvarchar(10)) AS [SalesTypeSSID]
				,		CAST(ISNULL(LTRIM(RTRIM(t.SaleTypeDescription__c)),'') AS nvarchar(50)) AS [SalesTypeDescription]
				,		CAST(ISNULL(LTRIM(RTRIM(a.ONC_ActionCode)),'') AS nvarchar(10)) AS [ActionCodeSSID]
				,		CAST(ISNULL(LTRIM(RTRIM(t.Action__c)),'') AS nvarchar(50)) AS [ActionCodeDescription]
				,		CAST(ISNULL(LTRIM(RTRIM(r.ONC_ResultCode)),'') AS nvarchar(10)) AS [ResultCodeSSID]
				,		CAST(ISNULL(LTRIM(RTRIM(t.Result__c)),'') AS nvarchar(50)) AS [ResultCodeDescription]
				,		CAST(ISNULL(LTRIM(RTRIM(t.SourceCode__c)),'') AS nvarchar(30)) AS [SourceSSID]
				,		CAST(ISNULL(LTRIM(RTRIM(t.SourceCode__c)),'') AS nvarchar(50)) AS [SourceCodeDescription]
				,		CASE
							WHEN t.Result__c = 'No Show' THEN 'N'
							WHEN t.Result__c IN ( 'Show Sale', 'Show No Sale' ) THEN 'S'
							ELSE ''
						END AS [IsShow]
				,		CASE
							WHEN t.Result__c = 'Show Sale' THEN 'S'
							ELSE 'N'
						END AS [IsSale]
				,		'' AS [ContractNumber]
				,		0 AS [ContractAmount]
				,		'' AS [ClientNumber]
				,		0 AS [InitialPayment]
				,		'' AS [NumOfGraphs]
				,		CAST(ISNULL(LTRIM(RTRIM(t.ActivityDate)),'1753-01-01 00:00:00.000') AS date) AS [OrigApptDate]
				,		CAST(ISNULL(LTRIM(RTRIM(t.LastModifiedDate)),'1753-01-01 00:00:00.000') AS date) AS [DateSaved]
				,		'' AS [RescheduleFlag]
				,		'1753-01-01 00:00:00.000' AS [RescheduledDate]
				,		'' AS [SurgeryOffered]
				,		'' AS [ReferredToDoctor]
				,		t.WhoId  AS 'SFDC_LeadID'
				,		NULL AS 'SFDC_PersonAccountID'
				,		t.Id
				,		t.Accommodation__c
				,		GETDATE() AS [ModifiedDate]
				,		0 AS [IsNew]
				,		0 AS [IsType1]
				,		0 AS [IsType2]
				,		0 AS [IsException]
				,		0 AS [IsInferredMember]
				,		0 AS [IsDelete]
				,		0 AS [IsDuplicate]
				,		CAST(ISNULL(LTRIM(RTRIM(t.Id)),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM	SQL06.HC_BI_SFDC.dbo.Task t
						LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.Action__c a
							ON a.Action__c = t.Action__c
								AND a.IsActiveFlag = 1
						LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.Result__c r
							ON r.Result__c = t.Result__c
								AND r.IsActiveFlag = 1
				WHERE	t.Action__c IN ( 'Appointment', 'In House', 'Be Back' ) --AND t.Result__c IN ( 'Show Sale', 'Show No Sale', 'No Show', 'Cancel', 'Reschedule' )
						AND ( ( ISNULL(t.CreatedDate,t.ReportCreateDate__c) >= @LSET AND ISNULL(t.CreatedDate,t.ReportCreateDate__c) < @CET )
							OR ( t.LastModifiedDate >= @LSET AND t.LastModifiedDate < @CET )
							OR ( t.ActivityDate >= @LSET AND t.ActivityDate < @CET )
							OR ( t.CompletionDate__c >= @LSET AND t.CompletionDate__c < @CET ) )

				SET @ExtractRowCnt = @@ROWCOUNT


				-- The INSERT statement would have loaded the Person Account ID as the SFDC_LeadID initially
				-- We need to join back to the Lead table to get the Original Lead ID and then update both the SFDC_LeadID and SFDC_PersonAccountID in DimActivity

				UPDATE da
				SET da.SFDC_LeadID = l.Id,
					da.SFDC_PersonAccountID = l.ConvertedContactId
				FROM bi_mktg_stage.DimActivityResult da
					INNER JOIN HC_BI_SFDC.dbo.Lead l
						ON da.SFDC_LeadID = l.ConvertedContactId
				WHERE LEFT(da.SFDC_LeadID,3) = '003'



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
