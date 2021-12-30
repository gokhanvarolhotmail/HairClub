/* CreateDate: 08/05/2019 11:21:08.610 , ModifyDate: 08/31/2021 00:03:19.690 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimActivityDemographic_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimActivityDemographic_Extract_CDC] is used to retrieve a
-- list ActivityDemographic
--
--   exec [bi_mktg_stage].[spHC_DimActivityDemographic_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009  RLifke       Initial Creation
--			03/29/2013  KMurdoch	 Added DiscStyleSSID
--			11/21/2017  KMurdoch     Added SFDC_Lead/Task_ID
--			08/05/2019	KMurdoch	 Migrate ONC to SFDC
--			09/10/2020  KMurdoch     Added SFDC_PersonAccountID
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

 	SET @TableName = N'[bi_mktg_dds].[DimActivityDemographic]'
 	SET @CDCTableName = N'dbo_cstd_activity_demographic'


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


				INSERT INTO [bi_mktg_stage].[DimActivityDemographic]
						   ( [DataPkgKey]
						   , [ActivityDemographicKey]
						   , [ActivityDemographicSSID]
						   , [ActivitySSID]
						   , [ContactSSID]
						   , [GenderSSID]
						   , [GenderDescription]
						   , [EthnicitySSID]
						   , [EthnicityDescription]
						   , [OccupationSSID]
						   , [OccupationDescription]
						   , [MaritalStatusSSID]
						   , [MaritalStatusDescription]
						   , [Birthday]
						   , [Age]
						   , [AgeRangeSSID]
						   , [AgeRangeDescription]
						   , [HairLossTypeSSID]
						   , [HairLossTypeDescription]
						   , [NorwoodSSID]
						   , [LudwigSSID]
						   , [Performer]
						   , [PriceQuoted]
						   , [SolutionOffered]
						   , [NoSaleReason]
						   , [DateSaved]
						   , [ModifiedDate]
						   , [DiscStyleSSID]
						   , [SFDC_LeadID]
						   , [SFDC_PersonAccountID]
						   , [SFDC_TaskID]
						   , [IsNew]
						   , [IsType1]
						   , [IsType2]
						   , [IsException]
						   , [IsInferredMember]
							, [IsDelete]
							, [IsDuplicate]
						   , [SourceSystemKey]
							)
				SELECT	@DataPkgKey
				,		NULL AS [ActivityDemographicKey]
				,		CAST(ISNULL(LTRIM(RTRIM(t.ActivityID__c)),'') AS varchar(10)) AS [ActivityDemographicSSID]
				,		CAST(ISNULL(LTRIM(RTRIM(t.ActivityID__c)),'') AS varchar(10)) AS [ActivitySSID]
				,		CAST(ISNULL(LTRIM(RTRIM(t.LeadOncContactID__c)),'') AS varchar(10)) AS [ContactSSID]
				,		CASE WHEN t.LeadOncGender__c = 'Male' THEN 'M'
							WHEN t.LeadOncGender__c = 'Female' THEN 'F'
							WHEN t.LeadOncGender__c = '?' THEN 'U'
							WHEN t.LeadOncGender__c = 'U' THEN 'U'
							ELSE 'U'
							END AS [GenderSSID]
				,		CASE WHEN t.LeadOncGender__c = 'Male' THEN 'Male'
							WHEN t.LeadOncGender__c = 'Female' THEN 'Female'
							WHEN t.LeadOncGender__c = '?' THEN 'Unknown'
							WHEN t.LeadOncGender__c = 'U' THEN 'Unknown'
							ELSE 'Unknown'
							END AS [GenderDescription]
				,		CASE WHEN e.BOSEthnicityCode = 0 THEN '-2'
							ELSE CAST(ISNULL(LTRIM(RTRIM(e.BOSEthnicityCode)),'-2') AS varchar(10))
							END AS [EthnicitySSID]
				,		CASE WHEN e.BOSEthnicityCode = 0 THEN ''
							ELSE CAST(ISNULL(LTRIM(RTRIM(t.LeadOncEthnicity__c)),'') AS varchar(50))
							END AS [EthnicityDescription]
				,		CASE WHEN o.BOSOccupationCode = 0 THEN '-2'
							ELSE CAST(ISNULL(LTRIM(RTRIM(o.BOSOccupationCode)),'-2') AS varchar(10))
							END AS [OccupationSSID]
				,		CASE WHEN o.BOSOccupationCode = 0 THEN ''
							ELSE CAST(ISNULL(LTRIM(RTRIM(t.Occupation__c)),'') AS varchar(50))
							END AS [OccupationDescription]
				,		CASE WHEN m.BOSMaritalStatusCode = 0 THEN '-2'
							ELSE  CAST(ISNULL(LTRIM(RTRIM(m.BOSMaritalStatusCode)),'-2') AS varchar(10))
							END AS [MaritalStatusSSID]
				,		CASE WHEN m.BOSMaritalStatusCode = 0 THEN ''
							ELSE CAST(ISNULL(LTRIM(RTRIM(t.MaritalStatus__c)),'') AS varchar(50))
							END AS [MaritalStatusDescription]
				,		CAST(CONVERT (VARCHAR(11), l.Birthday__c,120 )as date) AS [Birthday]
				,		COALESCE(l.Age__c, 0) AS [Age]
				,		'' AS [AgeRangeSSID]
				,		'' AS [AgeRangeDescription]
				,		'' AS [HairLossTypeSSID]
				,		'' AS [HairLossTypeDescription]
				,		CAST(ISNULL(LTRIM(RTRIM(t.NorwoodScale__c)),'Unknown') AS varchar(50)) AS [NorwoodSSID]
				,		CAST(ISNULL(LTRIM(RTRIM(t.LudwigScale__c)),'Unknown') AS varchar(50)) AS [LudwigSSID]
				,		CAST(ISNULL(LTRIM(RTRIM(t.Performer__c)),'') AS varchar(50)) AS [Performer]
				,		COALESCE(t.PriceQuoted__c,0) AS [PriceQuoted]
				,		CAST(ISNULL(LTRIM(RTRIM(t.SolutionOffered__c)),'') AS varchar(100)) AS [SolutionOffered]
				,		CAST(ISNULL(LTRIM(RTRIM(t.NoSaleReason__c)),'') AS varchar(200)) AS [NoSaleReason]
				,		CAST(ISNULL(LTRIM(RTRIM(ISNULL(t.LastModifiedDate,t.createdDate))),'') AS date) AS [DateSaved]
				,		ISNULL(t.LastModifiedDate,t.createdDate) AS [ModifiedDate]
				,		CAST(ISNULL(LTRIM(RTRIM(d.DISCStyleDescriptionShort)),'u') AS nvarchar(20)) AS [DiscStyleSSID]
				,		l.Id AS 'SFDC_LeadID'
				,		l.ConvertedContactId AS 'SFDC_PersonAccountID'
				,		t.Id
				,		0 AS [IsNew]
				,		0 AS [IsType1]
				,		0 AS [IsType2]
				,		0 AS [IsException]
				,		0 AS [IsInferredMember]
				,		0 AS [IsDelete]
				,		0 AS [IsDuplicate]
				,		CAST(ISNULL(LTRIM(RTRIM(t.Id)),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM	SQL06.HC_BI_SFDC.dbo.Task t
						INNER JOIN SQL06.HC_BI_SFDC.dbo.Lead l
							ON t.WhoId = l.Id
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
				WHERE	LEFT(t.WhoId, 3) = '00Q'
						AND t.Result__c IN ( 'Show No Sale', 'Show Sale' )
						AND ( ( ISNULL(t.ReportCreateDate__c,t.CreatedDate) >= @LSET AND ISNULL(t.ReportCreateDate__c,t.CreatedDate) < @CET )
								OR ( t.LastModifiedDate >= @LSET AND t.LastModifiedDate < @CET )
								OR ( t.ActivityDate >= @LSET AND t.ActivityDate < @CET )
								OR ( t.CompletionDate__c >= @LSET AND t.CompletionDate__c < @CET ) )


				SET @ExtractRowCnt = @@ROWCOUNT


				INSERT INTO [bi_mktg_stage].[DimActivityDemographic]
						   ( [DataPkgKey]
						   , [ActivityDemographicKey]
						   , [ActivityDemographicSSID]
						   , [ActivitySSID]
						   , [ContactSSID]
						   , [GenderSSID]
						   , [GenderDescription]
						   , [EthnicitySSID]
						   , [EthnicityDescription]
						   , [OccupationSSID]
						   , [OccupationDescription]
						   , [MaritalStatusSSID]
						   , [MaritalStatusDescription]
						   , [Birthday]
						   , [Age]
						   , [AgeRangeSSID]
						   , [AgeRangeDescription]
						   , [HairLossTypeSSID]
						   , [HairLossTypeDescription]
						   , [NorwoodSSID]
						   , [LudwigSSID]
						   , [Performer]
						   , [PriceQuoted]
						   , [SolutionOffered]
						   , [NoSaleReason]
						   , [DateSaved]
						   , [ModifiedDate]
						   , [DiscStyleSSID]
						   , [SFDC_LeadID]
						   , [SFDC_PersonAccountID]
						   , [SFDC_TaskID]
						   , [IsNew]
						   , [IsType1]
						   , [IsType2]
						   , [IsException]
						   , [IsInferredMember]
							, [IsDelete]
							, [IsDuplicate]
						   , [SourceSystemKey]
							)
				SELECT	@DataPkgKey
				,		NULL AS [ActivityDemographicKey]
				,		CAST(ISNULL(LTRIM(RTRIM(t.ActivityID__c)),'') AS varchar(10)) AS [ActivityDemographicSSID]
				,		CAST(ISNULL(LTRIM(RTRIM(t.ActivityID__c)),'') AS varchar(10)) AS [ActivitySSID]
				,		CAST(ISNULL(LTRIM(RTRIM(t.LeadOncContactID__c)),'') AS varchar(10)) AS [ContactSSID]
				,		CASE WHEN t.LeadOncGender__c = 'Male' THEN 'M'
							WHEN t.LeadOncGender__c = 'Female' THEN 'F'
							WHEN t.LeadOncGender__c = '?' THEN 'U'
							WHEN t.LeadOncGender__c = 'U' THEN 'U'
							ELSE 'U'
							END AS [GenderSSID]
				,		CASE WHEN t.LeadOncGender__c = 'Male' THEN 'Male'
							WHEN t.LeadOncGender__c = 'Female' THEN 'Female'
							WHEN t.LeadOncGender__c = '?' THEN 'Unknown'
							WHEN t.LeadOncGender__c = 'U' THEN 'Unknown'
							ELSE 'Unknown'
							END AS [GenderDescription]
				,		CASE WHEN e.BOSEthnicityCode = 0 THEN '-2'
							ELSE CAST(ISNULL(LTRIM(RTRIM(e.BOSEthnicityCode)),'-2') AS varchar(10))
							END AS [EthnicitySSID]
				,		CASE WHEN e.BOSEthnicityCode = 0 THEN ''
							ELSE CAST(ISNULL(LTRIM(RTRIM(t.LeadOncEthnicity__c)),'') AS varchar(50))
							END AS [EthnicityDescription]
				,		CASE WHEN o.BOSOccupationCode = 0 THEN '-2'
							ELSE CAST(ISNULL(LTRIM(RTRIM(o.BOSOccupationCode)),'-2') AS varchar(10))
							END AS [OccupationSSID]
				,		CASE WHEN o.BOSOccupationCode = 0 THEN ''
							ELSE CAST(ISNULL(LTRIM(RTRIM(t.Occupation__c)),'') AS varchar(50))
							END AS [OccupationDescription]
				,		CASE WHEN m.BOSMaritalStatusCode = 0 THEN '-2'
							ELSE  CAST(ISNULL(LTRIM(RTRIM(m.BOSMaritalStatusCode)),'-2') AS varchar(10))
							END AS [MaritalStatusSSID]
				,		CASE WHEN m.BOSMaritalStatusCode = 0 THEN ''
							ELSE CAST(ISNULL(LTRIM(RTRIM(t.MaritalStatus__c)),'') AS varchar(50))
							END AS [MaritalStatusDescription]
				,		CAST(CONVERT (VARCHAR(11), l.Birthday__c,120 )as date) AS [Birthday]
				,		COALESCE(l.Age__c, 0) AS [Age]
				,		'' AS [AgeRangeSSID]
				,		'' AS [AgeRangeDescription]
				,		'' AS [HairLossTypeSSID]
				,		'' AS [HairLossTypeDescription]
				,		CAST(ISNULL(LTRIM(RTRIM(t.NorwoodScale__c)),'Unknown') AS varchar(50)) AS [NorwoodSSID]
				,		CAST(ISNULL(LTRIM(RTRIM(t.LudwigScale__c)),'Unknown') AS varchar(50)) AS [LudwigSSID]
				,		CAST(ISNULL(LTRIM(RTRIM(t.Performer__c)),'') AS varchar(50)) AS [Performer]
				,		COALESCE(t.PriceQuoted__c,0) AS [PriceQuoted]
				,		CAST(ISNULL(LTRIM(RTRIM(t.SolutionOffered__c)),'') AS varchar(100)) AS [SolutionOffered]
				,		CAST(ISNULL(LTRIM(RTRIM(t.NoSaleReason__c)),'') AS varchar(200)) AS [NoSaleReason]
				,		CAST(ISNULL(LTRIM(RTRIM(ISNULL(t.LastModifiedDate,t.createdDate))),'') AS date) AS [DateSaved]
				,		ISNULL(t.LastModifiedDate,t.createdDate) AS [ModifiedDate]
				,		CAST(ISNULL(LTRIM(RTRIM(d.DISCStyleDescriptionShort)),'u') AS nvarchar(20)) AS [DiscStyleSSID]
				,		l.Id AS 'SFDC_LeadID'
				,		l.ConvertedContactId AS 'SFDC_PersonAccountID'
				,		t.Id
				,		0 AS [IsNew]
				,		0 AS [IsType1]
				,		0 AS [IsType2]
				,		0 AS [IsException]
				,		0 AS [IsInferredMember]
				,		0 AS [IsDelete]
				,		0 AS [IsDuplicate]
				,		CAST(ISNULL(LTRIM(RTRIM(t.Id)),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM	SQL06.HC_BI_SFDC.dbo.Task t
						INNER JOIN SQL06.HC_BI_SFDC.dbo.Lead l
							ON t.WhoId = l.Id
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
				WHERE	LEFT(t.WhoId, 3) = '003'
						AND t.Result__c IN ( 'Show No Sale', 'Show Sale' )
						AND ( ( ISNULL(t.ReportCreateDate__c,t.CreatedDate) >= @LSET AND ISNULL(t.ReportCreateDate__c,t.CreatedDate) < @CET )
								OR ( t.LastModifiedDate >= @LSET AND t.LastModifiedDate < @CET )
								OR ( t.ActivityDate >= @LSET AND t.ActivityDate < @CET )
								OR ( t.CompletionDate__c >= @LSET AND t.CompletionDate__c < @CET ) )


				SET @ExtractRowCnt = ISNULL(@ExtractRowCnt, 0) + @@ROWCOUNT


						-- Set the Last Successful Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET LSET = @CET
								, [Status] = 'Extraction Completed'
							WHERE [TableName] = @TableName

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
