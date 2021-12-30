/* CreateDate: 08/05/2019 11:23:52.527 , ModifyDate: 08/31/2021 16:54:32.600 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivityResults_Extract]
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
--			08/05/2019	DLeiba		 Migrated ONC to Salesforce.
--			07/10/2020  KMurdoch     Added Accomodation to table
--			08/10/2020  KMurdoch     Removed restriction for result code
--			09/10/2020  KMurdoch     Added SFDC_PersonAccountID
--			09/24/2020  KMurdoch     Added logic to deal with reused centernumbers
--			09/24/2020  KMurdoch     Removed the above logic
--			01/05/2020  KMurdoch     Modified logic to use Task center if task center is 360 virtual for CenterSSID
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
							, [SFDC_TaskID]

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
							, [SFDC_LeadID]
							, [SFDC_PersonAccountID]

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
							, [Accomodation]
							)

				SELECT	  @DataPkgKey
						,		0 AS [ActivityResultDateKey]
						,		CAST(t.CompletionDate__c AS DATE) AS [ActivityResultDateSSID]
						,		0 AS [ActivityResultKey]
						,		CAST(ISNULL(LTRIM(RTRIM(t.ActivityID__c)),'-2') AS varchar(10)) AS [ActivityResultSSID]
						,		0 AS [ActivityResultTimeKey]
						,		CAST(t.CompletionDate__c AS TIME) AS [ActivityResultTimeSSID]
						,		0 AS [ActivityKey]
						,		CAST(ISNULL(LTRIM(RTRIM(t.ActivityID__c)),'') AS varchar(10)) AS [ActivitySSID]
						,		t.Id AS [SFDC_TaskID]
						,		0 AS [ActivityDateKey]
						,		CAST(ISNULL(t.ReportCreateDate__c,t.CreatedDate) AS DATE) AS [ActivityDateSSID]
						,		0 AS [ActivityTimeKey]
						,		CAST(ISNULL(t.ReportCreateDate__c,t.CreatedDate) AS TIME) AS [ActivityTimeSSID]
						,		0 AS [ActivityDueDateKey]
						,		CAST(t.ActivityDate AS DATE) AS [ActivityDueDateSSID]
						,		0 AS [ActivityStartTimeKey]
						,		CAST(t.StartTime__c AS TIME) AS [ActivityStartTimeSSID]
						,		0 AS [ActivityCompletedDateKey]
						,		CAST(t.CompletionDate__c AS DATE) AS [ActivityCompletedDateSSID]
						,		0 AS [ActivityCompletedTimeKey]
						,		CAST(t.CompletionDate__c AS TIME) AS [ActivityCompletedTimeSSID]
						,		0 AS [OriginalAppointmentDateKey]
						,		CAST(t.ActivityDate AS DATE) AS [OriginalAppointmentDateSSID]
						,		0 AS [ActivitySavedDateKey]
						,		CAST(t.LastModifiedDate AS DATE) AS [ActivitySavedDateSSID]
						,		0 AS [ActivitySavedTimeKey]
						,		CAST(t.LastModifiedDate AS TIME) AS [ActivitySavedTimeSSID]
						,		0 AS [ContactKey]
						,		CAST(LTRIM(RTRIM(t.LeadOncContactID__c)) AS nvarchar(10)) AS [ContactSSID]
						,		ISNULL(l.Id,t.whoId) AS [SFDC_LeadID]
						,		l.ConvertedContactId AS [SFDC_PersonAccountID]
						,		0 AS [CenterKey]
						,       CASE WHEN ISNULL(t.CenterNumber__c, t.CenterID__c) = 360 THEN
										CAST(ISNULL(t.CenterNumber__c, t.CenterID__c) AS NVARCHAR(10))
									ELSE
										CAST(ISNULL(CASE WHEN l.CenterNumber__c = '890' THEN '233' ELSE l.CenterNumber__c END,
														CASE WHEN l.CenterID__c = '890' THEN '233' ELSE l.CenterID__c END)	AS NVARCHAR(10))
									END AS 'CenterSSID'  --01/06/2021
						,		0 AS [SalesTypeKey]
						,		CAST(ISNULL(LTRIM(RTRIM(t.SaleTypeCode__c)),'-2') AS nvarchar(10)) AS [SalesTypeSSID]
						,		0 AS [SourceKey]
						,		CAST(LTRIM(RTRIM(t.SourceCode__c)) AS nvarchar(20)) AS [SourceSSID]
						,		0 AS [ActionCodeKey]
						,		CAST(ISNULL(LTRIM(RTRIM(a.ONC_ActionCode)),'') AS nvarchar(10)) AS [ActionCodeSSID]
						,		0 AS [ResultCodeKey]
						,		CAST(ISNULL(LTRIM(RTRIM(r.ONC_ResultCode)),'') AS nvarchar(10)) AS [ResultCodeSSID]
						,		0 AS [GenderKey]
						,		CASE WHEN t.LeadOncGender__c = 'Male' THEN 'M'
									WHEN t.LeadOncGender__c = 'Female' THEN 'F'
									WHEN t.LeadOncGender__c = '?' THEN 'U'
									WHEN t.LeadOncGender__c = 'U' THEN 'U'
									ELSE '-2'
									END AS [GenderSSID]
						,		0 AS [OccupationKey]
						,		CASE WHEN o.BOSOccupationCode = 0 THEN '-2'
									ELSE CAST(ISNULL(LTRIM(RTRIM(o.BOSOccupationCode)),'-2') AS varchar(10))
									END AS [OccupationSSID]
						,		0 AS [EthnicityKey]
						,		CASE WHEN e.BOSEthnicityCode = 0 THEN '-2'
									ELSE CAST(ISNULL(LTRIM(RTRIM(e.BOSEthnicityCode)),'-2') AS varchar(10))
									END AS [EthnicitySSID]
						,		0 AS [MaritalStatusKey]
						,		CASE WHEN m.BOSMaritalStatusCode = 0 THEN '-2'
									ELSE  CAST(ISNULL(LTRIM(RTRIM(m.BOSMaritalStatusCode)),'-2') AS varchar(10))
									END AS [MaritalStatusSSID]
						,		0 AS [HairLossTypeKey]
						,		'-2' AS [HairLossTypeSSID]
						,		CAST(ISNULL(LTRIM(RTRIM(t.NorwoodScale__c)),'Unknown') AS varchar(50)) AS [NorwoodSSID]
						,		CAST(ISNULL(LTRIM(RTRIM(t.LudwigScale__c)),'Unknown') AS varchar(50)) AS [LudwigSSID]
						,		0 AS [AgeRangeKey]
						,		'-2' AS [AgeRangeSSID]
						,		COALESCE(l.Age__c, 0) AS [Age]
						,		0 AS [CompletedByEmployeeKey]
						,		'' AS [CompletedByEmployeeSSID]
						,		'' AS [ClientNumber]
						,		CASE
									WHEN t.Result__c = 'No Show' THEN 'N'
									WHEN t.Result__c IN ( 'Show Sale', 'Show No Sale' ) THEN 'S'
									ELSE ''
								END AS [ShowNoShowFlag]
						,		CASE
									WHEN t.Result__c = 'Show Sale' THEN 'S'
									ELSE 'N'
								END AS [SaleNoSaleFlag]
						,		'' AS [SurgeryOfferedFlag]
						,		'' AS [ReferredToDoctorFlag]
						,		0 AS [Show]
						,		0 AS [NoShow]
						,		0 AS [Sale]
						,		0 AS [NoSale]
						,		0 AS [Consultation]
						,		0 AS [BeBack]
						,		0 AS [SurgeryOffered]
						,		0 AS [ReferredToDoctor]
						,		0 AS [InitialPayment]
						,		0 AS [ActivityEmployeeKey]
						,		CAST(LTRIM(RTRIM(u_o.UserCode__c)) AS nvarchar(20)) AS [ActivityEmployeeSSID]
						,		0 AS [IsNew]
						,		0 AS [IsUpdate]
						,		0 AS [IsException]
						,		0 AS [IsDelete]
						,		0 AS [IsDuplicate]
						,		CAST(LTRIM(RTRIM(t.Id)) AS nvarchar(50)) AS [SourceSystemKey]
						,		t.Accommodation__c
					FROM	SQL06.HC_BI_SFDC.dbo.Task t
							LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l
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
							LEFT OUTER JOIN SQL06. HC_BI_SFDC.dbo.Result__c r
								ON r.Result__c = t.Result__c
									AND r.IsActiveFlag = 1
							LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.[User] u_c
								ON u_c.Id = t.CreatedById
							LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.[User] u_o
								ON u_o.Id = t.OwnerId
					WHERE	t.Action__c IN ( 'Appointment', 'In House', 'Be Back' ) --AND t.Result__c IN ( 'Show Sale', 'Show No Sale', 'No Show' )
							AND ( ( ISNULL(t.ReportCreateDate__c,t.CreatedDate) >= @LSET AND ISNULL(t.ReportCreateDate__c,t.createdDate) < @CET )
								OR ( t.LastModifiedDate >= @LSET AND t.LastModifiedDate < @CET )
								OR ( t.ActivityDate >= @LSET AND t.ActivityDate < @CET )
								OR ( t.CompletionDate__c >= @LSET AND t.CompletionDate__c < @CET ) )
							AND LEFT(t.WhoId, 3) = '00Q'


				SET @ExtractRowCnt = @@ROWCOUNT


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
							, [SFDC_TaskID]

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
							, [SFDC_LeadID]
							, [SFDC_PersonAccountID]

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
							, [Accomodation]
							)

				SELECT	  @DataPkgKey
						,		0 AS [ActivityResultDateKey]
						,		CAST(t.CompletionDate__c AS DATE) AS [ActivityResultDateSSID]
						,		0 AS [ActivityResultKey]
						,		CAST(ISNULL(LTRIM(RTRIM(t.ActivityID__c)),'-2') AS varchar(10)) AS [ActivityResultSSID]
						,		0 AS [ActivityResultTimeKey]
						,		CAST(t.CompletionDate__c AS TIME) AS [ActivityResultTimeSSID]
						,		0 AS [ActivityKey]
						,		CAST(ISNULL(LTRIM(RTRIM(t.ActivityID__c)),'') AS varchar(10)) AS [ActivitySSID]
						,		t.Id AS [SFDC_TaskID]
						,		0 AS [ActivityDateKey]
						,		CAST(ISNULL(t.ReportCreateDate__c,t.CreatedDate) AS DATE) AS [ActivityDateSSID]
						,		0 AS [ActivityTimeKey]
						,		CAST(ISNULL(t.ReportCreateDate__c,t.CreatedDate) AS TIME) AS [ActivityTimeSSID]
						,		0 AS [ActivityDueDateKey]
						,		CAST(t.ActivityDate AS DATE) AS [ActivityDueDateSSID]
						,		0 AS [ActivityStartTimeKey]
						,		CAST(t.StartTime__c AS TIME) AS [ActivityStartTimeSSID]
						,		0 AS [ActivityCompletedDateKey]
						,		CAST(t.CompletionDate__c AS DATE) AS [ActivityCompletedDateSSID]
						,		0 AS [ActivityCompletedTimeKey]
						,		CAST(t.CompletionDate__c AS TIME) AS [ActivityCompletedTimeSSID]
						,		0 AS [OriginalAppointmentDateKey]
						,		CAST(t.ActivityDate AS DATE) AS [OriginalAppointmentDateSSID]
						,		0 AS [ActivitySavedDateKey]
						,		CAST(t.LastModifiedDate AS DATE) AS [ActivitySavedDateSSID]
						,		0 AS [ActivitySavedTimeKey]
						,		CAST(t.LastModifiedDate AS TIME) AS [ActivitySavedTimeSSID]
						,		0 AS [ContactKey]
						,		CAST(LTRIM(RTRIM(t.LeadOncContactID__c)) AS nvarchar(10)) AS [ContactSSID]
						,		ISNULL(l.Id,t.whoId) AS [SFDC_LeadID]
						,		l.ConvertedContactId AS [SFDC_PersonAccountID]
						,		0 AS [CenterKey]
						,       CASE WHEN ISNULL(t.CenterNumber__c, t.CenterID__c) = 360 THEN
										CAST(ISNULL(t.CenterNumber__c, t.CenterID__c) AS NVARCHAR(10))
									ELSE
										CAST(ISNULL(CASE WHEN l.CenterNumber__c = '890' THEN '233' ELSE l.CenterNumber__c END,
														CASE WHEN l.CenterID__c = '890' THEN '233' ELSE l.CenterID__c END)	AS NVARCHAR(10))
									END AS 'CenterSSID'  --01/06/2021
						,		0 AS [SalesTypeKey]
						,		CAST(ISNULL(LTRIM(RTRIM(t.SaleTypeCode__c)),'-2') AS nvarchar(10)) AS [SalesTypeSSID]
						,		0 AS [SourceKey]
						,		CAST(LTRIM(RTRIM(t.SourceCode__c)) AS nvarchar(20)) AS [SourceSSID]
						,		0 AS [ActionCodeKey]
						,		CAST(ISNULL(LTRIM(RTRIM(a.ONC_ActionCode)),'') AS nvarchar(10)) AS [ActionCodeSSID]
						,		0 AS [ResultCodeKey]
						,		CAST(ISNULL(LTRIM(RTRIM(r.ONC_ResultCode)),'') AS nvarchar(10)) AS [ResultCodeSSID]
						,		0 AS [GenderKey]
						,		CASE WHEN t.LeadOncGender__c = 'Male' THEN 'M'
									WHEN t.LeadOncGender__c = 'Female' THEN 'F'
									WHEN t.LeadOncGender__c = '?' THEN 'U'
									WHEN t.LeadOncGender__c = 'U' THEN 'U'
									ELSE '-2'
									END AS [GenderSSID]
						,		0 AS [OccupationKey]
						,		CASE WHEN o.BOSOccupationCode = 0 THEN '-2'
									ELSE CAST(ISNULL(LTRIM(RTRIM(o.BOSOccupationCode)),'-2') AS varchar(10))
									END AS [OccupationSSID]
						,		0 AS [EthnicityKey]
						,		CASE WHEN e.BOSEthnicityCode = 0 THEN '-2'
									ELSE CAST(ISNULL(LTRIM(RTRIM(e.BOSEthnicityCode)),'-2') AS varchar(10))
									END AS [EthnicitySSID]
						,		0 AS [MaritalStatusKey]
						,		CASE WHEN m.BOSMaritalStatusCode = 0 THEN '-2'
									ELSE  CAST(ISNULL(LTRIM(RTRIM(m.BOSMaritalStatusCode)),'-2') AS varchar(10))
									END AS [MaritalStatusSSID]
						,		0 AS [HairLossTypeKey]
						,		'-2' AS [HairLossTypeSSID]
						,		CAST(ISNULL(LTRIM(RTRIM(t.NorwoodScale__c)),'Unknown') AS varchar(50)) AS [NorwoodSSID]
						,		CAST(ISNULL(LTRIM(RTRIM(t.LudwigScale__c)),'Unknown') AS varchar(50)) AS [LudwigSSID]
						,		0 AS [AgeRangeKey]
						,		'-2' AS [AgeRangeSSID]
						,		COALESCE(l.Age__c, 0) AS [Age]
						,		0 AS [CompletedByEmployeeKey]
						,		'' AS [CompletedByEmployeeSSID]
						,		'' AS [ClientNumber]
						,		CASE
									WHEN t.Result__c = 'No Show' THEN 'N'
									WHEN t.Result__c IN ( 'Show Sale', 'Show No Sale' ) THEN 'S'
									ELSE ''
								END AS [ShowNoShowFlag]
						,		CASE
									WHEN t.Result__c = 'Show Sale' THEN 'S'
									ELSE 'N'
								END AS [SaleNoSaleFlag]
						,		'' AS [SurgeryOfferedFlag]
						,		'' AS [ReferredToDoctorFlag]
						,		0 AS [Show]
						,		0 AS [NoShow]
						,		0 AS [Sale]
						,		0 AS [NoSale]
						,		0 AS [Consultation]
						,		0 AS [BeBack]
						,		0 AS [SurgeryOffered]
						,		0 AS [ReferredToDoctor]
						,		0 AS [InitialPayment]
						,		0 AS [ActivityEmployeeKey]
						,		CAST(LTRIM(RTRIM(u_o.UserCode__c)) AS nvarchar(20)) AS [ActivityEmployeeSSID]
						,		0 AS [IsNew]
						,		0 AS [IsUpdate]
						,		0 AS [IsException]
						,		0 AS [IsDelete]
						,		0 AS [IsDuplicate]
						,		CAST(LTRIM(RTRIM(t.Id)) AS nvarchar(50)) AS [SourceSystemKey]
						,		t.Accommodation__c
					FROM	SQL06.HC_BI_SFDC.dbo.Task t
							LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l
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
							LEFT OUTER JOIN SQL06. HC_BI_SFDC.dbo.Result__c r
								ON r.Result__c = t.Result__c
									AND r.IsActiveFlag = 1
							LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.[User] u_c
								ON u_c.Id = t.CreatedById
							LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.[User] u_o
								ON u_o.Id = t.OwnerId
					WHERE	t.Action__c IN ( 'Appointment', 'In House', 'Be Back' ) --AND t.Result__c IN ( 'Show Sale', 'Show No Sale', 'No Show' )
							AND ( ( ISNULL(t.ReportCreateDate__c,t.CreatedDate) >= @LSET AND ISNULL(t.ReportCreateDate__c,t.createdDate) < @CET )
								OR ( t.LastModifiedDate >= @LSET AND t.LastModifiedDate < @CET )
								OR ( t.ActivityDate >= @LSET AND t.ActivityDate < @CET )
								OR ( t.CompletionDate__c >= @LSET AND t.CompletionDate__c < @CET ) )
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
