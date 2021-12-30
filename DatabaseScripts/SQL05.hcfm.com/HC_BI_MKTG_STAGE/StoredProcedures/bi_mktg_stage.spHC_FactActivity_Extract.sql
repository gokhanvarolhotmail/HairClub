/* CreateDate: 08/05/2019 11:08:37.580 , ModifyDate: 08/06/2021 13:19:56.500 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivity_Extract]
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
--			08/05/2019	DLeiba		 Migrated ONC to SFDC
--			09/10/2020  KMurdoch	 Added SFDC_PersonAccountID
--			09/24/2020  KMurdoch     Changed derivation of CenterSSID to accomodate for Re-used CenterNumbers
--			09/24/2020  KMurdoch     Removed the above logic
--			01/06/2021  KMurdoch     Modified Center extract to handle Bad Philadelphia data
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
							, [SFDC_TaskID]

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
							, [SFDC_LeadID]
							, [SFDC_PersonAccountID]

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
					,		0 AS [ActivityDateKey]
					,		CAST(t.ReportCreateDate__c AS DATE) AS [ActivityDateSSID]
					,		0 AS [ActivityTimeKey]
					,		CAST(t.ReportCreateDate__c AS TIME) AS [ActivityTimeSSID]
					,		0 AS [ActivityKey]
					,		t.ActivityID__c AS [ActivitySSID]
					,		t.Id AS [SFDC_TaskID]
					,		0 AS [ActivityDueDateKey]
					,		CAST(t.ActivityDate AS DATE) AS [ActivityDueDateSSID]
					,		0 AS [ActivityStartTimeKey]
					,		CAST(t.StartTime__c AS TIME) AS [ActivityStartTimeSSID]
					,		0 AS [ActivityCompletedDateKey]
					,		CAST(t.CompletionDate__c AS DATE) AS [ActivityCompletedDateSSID]
					,		0 AS [ActivityCompletedTimeKey]
					,		CAST(t.CompletionDate__c AS TIME) AS [ActivityCompletedTimeSSID]
					,		0 AS [GenderKey]
					,		CASE WHEN t.LeadOncGender__c = 'Male' THEN 'M'
								WHEN t.LeadOncGender__c = 'Female' THEN 'F'
								WHEN t.LeadOncGender__c = '?' THEN 'U'
								WHEN t.LeadOncGender__c = 'U' THEN 'U'
								ELSE '-2'
								END AS [GenderSSID]
					,		0 AS [EthnicityKey]
					,		CASE WHEN e.BOSEthnicityCode = 0 THEN '-2'
								ELSE CAST(ISNULL(LTRIM(RTRIM(e.BOSEthnicityCode)),'-2') AS varchar(10))
								END AS [EthnicitySSID]
					,		0 AS [OccupationKey]
					,		CASE WHEN o.BOSOccupationCode = 0 THEN '-2'
								ELSE CAST(ISNULL(LTRIM(RTRIM(o.BOSOccupationCode)),'-2') AS varchar(10))
								END AS [OccupationSSID]
					,		0 AS [MaritalStatusKey]
					,		CASE WHEN m.BOSMaritalStatusCode = 0 THEN '-2'
								ELSE  CAST(ISNULL(LTRIM(RTRIM(m.BOSMaritalStatusCode)),'-2') AS varchar(10))
								END AS [MaritalStatusSSID]
					,		0 AS [AgeRangeKey]
					,		COALESCE(l.Age__c, 0) AS [Age]
					,		'-2' AS [AgeRangeSSID]
					,		0 AS [HairLossTypeKey]
					,		'-2' AS [HairLossTypeSSID]
					,		CAST(ISNULL(LTRIM(RTRIM(t.NorwoodScale__c)),'Unknown') AS varchar(50)) AS [NorwoodSSID]
					,		CAST(ISNULL(LTRIM(RTRIM(t.LudwigScale__c)),'Unknown') AS varchar(50)) AS [LudwigSSID]
					,		0 AS [CenterKey]
					,       CAST(ISNULL(CASE WHEN l.CenterNumber__c = '890' THEN '233' ELSE l.CenterNumber__c END,
										CASE WHEN l.CenterID__c = '890' THEN '233' ELSE l.CenterID__c END)	AS NVARCHAR(10)) AS 'CenterSSID'  --01/06/2021
					,		0 AS [ContactKey]
					,		CAST(LTRIM(RTRIM(t.LeadOncContactID__c)) AS nvarchar(10)) AS [ContactSSID]
					,		l.Id AS [SFDC_LeadID]
					,       l.ConvertedContactId AS [SFDC_PersonAccountID]
					,		0 AS [ActionCodeKey]
					,		CAST(ISNULL(LTRIM(RTRIM(a.ONC_ActionCode)),'') AS nvarchar(10)) AS [ActionCodeSSID]
					,		0 AS [ResultCodeKey]
					,		CAST(ISNULL(LTRIM(RTRIM(r.ONC_ResultCode)),'') AS nvarchar(10)) AS [ResultCodeSSID]
					,		0 AS [SourceKey]
					,		CAST(ISNULL(LTRIM(RTRIM(t.SourceCode__c)),'') AS nvarchar(30)) AS [SourceSSID]
					,		0 AS [ActivityTypeKey]
					,		CAST(LTRIM(RTRIM(CASE WHEN t.Action__c IN ( 'Inbound Call' ) OR ( t.Action__c IN ( 'Appointment' ) AND t.ActivityType__c = 'Inbound' ) THEN 'INBOUND' --NOT ACTIVITY TYPE Inbound Found it, logic with out sense in new Environment.
										WHEN t.Action__c IN ( 'Brochure Call', 'Exception Call', 'No Show Call',' Cancel Call' ) OR ( t.Action__c IN ( 'Appointment' ) 	AND t.ActivityType__c = 'Outbound' ) THEN 'OUTBOUND'
										WHEN t.Action__c IN ( 'Be Back' ) THEN 'BEBACK'
										WHEN t.Action__c IN ( 'In House' ) THEN 'INHOUSE'
										WHEN t.Action__c IN ( 'Confirmation Call' ) THEN 'CONFIRM'
										ELSE 'UNKNOWN'
										END
							)) AS nvarchar(10)) AS [ActivityTypeSSID]  --//This logic did not apply now!!!! appo are not being clasified as that.
					,		0 AS [CompletedByEmployeeKey]
					,		'' AS [CompletedByEmployeeSSID]
					,		0 AS [StartedByEmployeeKey]
					,		CAST(LTRIM(RTRIM(u_c.UserCode__c)) AS nvarchar(20)) AS [StartedByEmployeeSSID] --LegacyField from OldCrm to SalesForce, field not being update.
					,		0 AS [ActivityEmployeeKey]
					,		CAST(LTRIM(RTRIM(u_o.UserCode__c)) AS nvarchar(20)) AS [ActivityEmployeeSSID] --LegacyField from OldCrm to SalesForce, field not being update.
					,		0 AS [IsNew]
					,		0 AS [IsUpdate]
					,		0 AS [IsException]
					,		0 AS [IsDelete]
					,		0 AS [IsDuplicate]
					,		CAST(LTRIM(RTRIM(t.Id)) AS nvarchar(50)) AS [SourceSystemKey]
					FROM	SQL06.HC_BI_SFDC.dbo.Task t
							LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.Lead l
								ON l.Id = t.WhoId
							LEFT OUTER JOIN HC_BI_SFDC.dbo.HairClubCMS_lkpEthnicity_TABLE e
								ON e.EthnicityDescription = l.Ethnicity__c
							LEFT OUTER JOIN HC_BI_SFDC.dbo.HairClubCMS_lkpOccupation_TABLE o
								ON o.OccupationDescription = t.Occupation__c
							LEFT OUTER JOIN HC_BI_SFDC.dbo.HairClubCMS_lkpMaritalStatus_TABLE m
								ON m.MaritalStatusDescription = t.MaritalStatus__c
							LEFT OUTER JOIN HC_BI_SFDC.dbo.HairClubCMS_lkpDISCStyle_TABLE d
								ON d.DISCStyleDescription = t.DISC__c
							LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.Action__c a
								ON a.Action__c = t.Action__c
									AND a.IsActiveFlag = 1
							LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.Result__c r
								ON r.Result__c = t.Result__c
									AND r.IsActiveFlag = 1
							LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.[User] u_c
								ON u_c.Id = t.CreatedById
							LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.[User] u_o
								ON u_o.Id = t.OwnerId
					WHERE	 ( ISNULL(t.ReportCreateDate__c,t.CreatedDate) >= @LSET AND ISNULL(t.ReportCreateDate__c,t.CreatedDate) < @CET )
									OR ( t.LastModifiedDate >= @LSET AND t.LastModifiedDate < @CET )
									OR ( t.ActivityDate >= @LSET AND t.ActivityDate < @CET )
									OR ( t.CompletionDate__c >= @LSET AND t.CompletionDate__c < @CET )
							AND LEFT(t.WhoId, 3) = '00Q'


				SET @ExtractRowCnt = @@ROWCOUNT


				INSERT INTO [bi_mktg_stage].[FactActivity]
						   ( [DataPkgKey]
						    , [ActivityDateKey]
						    , [ActivityDateSSID]
						    , [ActivityTimeKey]
						    , [ActivityTimeSSID]
						    , [ActivityKey]
						    , [ActivitySSID]
							, [SFDC_TaskID]

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
							, [SFDC_LeadID]
							, [SFDC_PersonAccountID]

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
					,		0 AS [ActivityDateKey]
					,		CAST(t.ReportCreateDate__c AS DATE) AS [ActivityDateSSID]
					,		0 AS [ActivityTimeKey]
					,		CAST(t.ReportCreateDate__c AS TIME) AS [ActivityTimeSSID]
					,		0 AS [ActivityKey]
					,		t.ActivityID__c AS [ActivitySSID]
					,		t.Id AS [SFDC_TaskID]
					,		0 AS [ActivityDueDateKey]
					,		CAST(t.ActivityDate AS DATE) AS [ActivityDueDateSSID]
					,		0 AS [ActivityStartTimeKey]
					,		CAST(t.StartTime__c AS TIME) AS [ActivityStartTimeSSID]
					,		0 AS [ActivityCompletedDateKey]
					,		CAST(t.CompletionDate__c AS DATE) AS [ActivityCompletedDateSSID]
					,		0 AS [ActivityCompletedTimeKey]
					,		CAST(t.CompletionDate__c AS TIME) AS [ActivityCompletedTimeSSID]
					,		0 AS [GenderKey]
					,		CASE WHEN t.LeadOncGender__c = 'Male' THEN 'M'
								WHEN t.LeadOncGender__c = 'Female' THEN 'F'
								WHEN t.LeadOncGender__c = '?' THEN 'U'
								WHEN t.LeadOncGender__c = 'U' THEN 'U'
								ELSE '-2'
								END AS [GenderSSID]
					,		0 AS [EthnicityKey]
					,		CASE WHEN e.BOSEthnicityCode = 0 THEN '-2'
								ELSE CAST(ISNULL(LTRIM(RTRIM(e.BOSEthnicityCode)),'-2') AS varchar(10))
								END AS [EthnicitySSID]
					,		0 AS [OccupationKey]
					,		CASE WHEN o.BOSOccupationCode = 0 THEN '-2'
								ELSE CAST(ISNULL(LTRIM(RTRIM(o.BOSOccupationCode)),'-2') AS varchar(10))
								END AS [OccupationSSID]
					,		0 AS [MaritalStatusKey]
					,		CASE WHEN m.BOSMaritalStatusCode = 0 THEN '-2'
								ELSE  CAST(ISNULL(LTRIM(RTRIM(m.BOSMaritalStatusCode)),'-2') AS varchar(10))
								END AS [MaritalStatusSSID]
					,		0 AS [AgeRangeKey]
					,		COALESCE(l.Age__c, 0) AS [Age]
					,		'-2' AS [AgeRangeSSID]
					,		0 AS [HairLossTypeKey]
					,		'-2' AS [HairLossTypeSSID]
					,		CAST(ISNULL(LTRIM(RTRIM(t.NorwoodScale__c)),'Unknown') AS varchar(50)) AS [NorwoodSSID]
					,		CAST(ISNULL(LTRIM(RTRIM(t.LudwigScale__c)),'Unknown') AS varchar(50)) AS [LudwigSSID]
					,		0 AS [CenterKey]
					,       CAST(ISNULL(CASE WHEN l.CenterNumber__c = '890' THEN '233' ELSE l.CenterNumber__c END,
										CASE WHEN l.CenterID__c = '890' THEN '233' ELSE l.CenterID__c END)	AS NVARCHAR(10)) AS 'CenterSSID'  --01/06/2021
					,		0 AS [ContactKey]
					,		CAST(LTRIM(RTRIM(t.LeadOncContactID__c)) AS nvarchar(10)) AS [ContactSSID]
					,		l.Id AS [SFDC_LeadID]
					,       l.ConvertedContactId AS [SFDC_PersonAccountID]
					,		0 AS [ActionCodeKey]
					,		CAST(ISNULL(LTRIM(RTRIM(a.ONC_ActionCode)),'') AS nvarchar(10)) AS [ActionCodeSSID]
					,		0 AS [ResultCodeKey]
					,		CAST(ISNULL(LTRIM(RTRIM(r.ONC_ResultCode)),'') AS nvarchar(10)) AS [ResultCodeSSID]
					,		0 AS [SourceKey]
					,		CAST(ISNULL(LTRIM(RTRIM(t.SourceCode__c)),'') AS nvarchar(30)) AS [SourceSSID]
					,		0 AS [ActivityTypeKey]
					,		CAST(LTRIM(RTRIM(CASE WHEN t.Action__c IN ( 'Inbound Call' ) OR ( t.Action__c IN ( 'Appointment' ) AND t.ActivityType__c = 'Inbound' ) THEN 'INBOUND' --NOT ACTIVITY TYPE Inbound Found it, logic with out sense in new Environment.
										WHEN t.Action__c IN ( 'Brochure Call', 'Exception Call', 'No Show Call',' Cancel Call' ) OR ( t.Action__c IN ( 'Appointment' ) 	AND t.ActivityType__c = 'Outbound' ) THEN 'OUTBOUND'
										WHEN t.Action__c IN ( 'Be Back' ) THEN 'BEBACK'
										WHEN t.Action__c IN ( 'In House' ) THEN 'INHOUSE'
										WHEN t.Action__c IN ( 'Confirmation Call' ) THEN 'CONFIRM'
										ELSE 'UNKNOWN'
										END
							)) AS nvarchar(10)) AS [ActivityTypeSSID]  --//This logic did not apply now!!!! appo are not being clasified as that.
					,		0 AS [CompletedByEmployeeKey]
					,		'' AS [CompletedByEmployeeSSID]
					,		0 AS [StartedByEmployeeKey]
					,		CAST(LTRIM(RTRIM(u_c.UserCode__c)) AS nvarchar(20)) AS [StartedByEmployeeSSID] --LegacyField from OldCrm to SalesForce, field not being update.
					,		0 AS [ActivityEmployeeKey]
					,		CAST(LTRIM(RTRIM(u_o.UserCode__c)) AS nvarchar(20)) AS [ActivityEmployeeSSID] --LegacyField from OldCrm to SalesForce, field not being update.
					,		0 AS [IsNew]
					,		0 AS [IsUpdate]
					,		0 AS [IsException]
					,		0 AS [IsDelete]
					,		0 AS [IsDuplicate]
					,		CAST(LTRIM(RTRIM(t.Id)) AS nvarchar(50)) AS [SourceSystemKey]
					FROM	SQL06.HC_BI_SFDC.dbo.Task t
							LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.Lead l
								ON l.Id = t.WhoId
							LEFT OUTER JOIN HC_BI_SFDC.dbo.HairClubCMS_lkpEthnicity_TABLE e
								ON e.EthnicityDescription = l.Ethnicity__c
							LEFT OUTER JOIN HC_BI_SFDC.dbo.HairClubCMS_lkpOccupation_TABLE o
								ON o.OccupationDescription = t.Occupation__c
							LEFT OUTER JOIN HC_BI_SFDC.dbo.HairClubCMS_lkpMaritalStatus_TABLE m
								ON m.MaritalStatusDescription = t.MaritalStatus__c
							LEFT OUTER JOIN HC_BI_SFDC.dbo.HairClubCMS_lkpDISCStyle_TABLE d
								ON d.DISCStyleDescription = t.DISC__c
							LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.Action__c a
								ON a.Action__c = t.Action__c
									AND a.IsActiveFlag = 1
							LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.Result__c r
								ON r.Result__c = t.Result__c
									AND r.IsActiveFlag = 1
							LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.[User] u_c
								ON u_c.Id = t.CreatedById
							LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.[User] u_o
								ON u_o.Id = t.OwnerId
					WHERE	 ( ISNULL(t.ReportCreateDate__c,t.CreatedDate) >= @LSET AND ISNULL(t.ReportCreateDate__c,t.CreatedDate) < @CET )
									OR ( t.LastModifiedDate >= @LSET AND t.LastModifiedDate < @CET )
									OR ( t.ActivityDate >= @LSET AND t.ActivityDate < @CET )
									OR ( t.CompletionDate__c >= @LSET AND t.CompletionDate__c < @CET )
							AND LEFT(t.WhoId, 3) = '003'


				SET @ExtractRowCnt = ISNULL(@ExtractRowCnt, 0) + @@ROWCOUNT


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
