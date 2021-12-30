/* CreateDate: 05/03/2010 12:26:25.757 , ModifyDate: 08/05/2019 11:19:31.243 */
GO
CREATE PROCEDURE [bi_mktg_stage].[zzzspHC_DimActivityDemographic_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimActivityDemographic_Extract] is used to retrieve a
-- list ActivityDemographics
--
--   exec [bi_mktg_stage].[spHC_DimActivityDemographic_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    11/11/2009  RLifke       Initial Creation
--			03/29/2013  KMurdoch	 Added DiscStyleSSID
--			11/21/2017  KMurdoch     Added SFDC_Lead/Task_ID
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

 	SET @TableName = N'[bi_mktg_dds].[DimActivityDemographic]'


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
				SELECT @DataPkgKey
						, NULL AS [ActivityDemographicKey]
						, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.[activity_demographic_id])),'') AS varchar(10)) AS [ActivityDemographicSSID]
						, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.[activity_id])),'') AS varchar(10)) AS [ActivitySSID]
						, CAST(ISNULL(LTRIM(RTRIM(oncd_activity_contact.contact_id)),'') AS varchar(10)) AS [ContactSSID]
						, CASE WHEN cstd_activity_demographic.gender = 'M' THEN 'M'
								WHEN cstd_activity_demographic.gender = 'F' THEN 'F'
								WHEN cstd_activity_demographic.gender = '?' THEN 'U'
								WHEN cstd_activity_demographic.gender = 'U' THEN 'U'
								ELSE '-2'
								END AS [GenderSSID]
						, CASE WHEN cstd_activity_demographic.gender = 'M' THEN 'Male'
								WHEN cstd_activity_demographic.gender = 'F' THEN 'Female'
								WHEN cstd_activity_demographic.gender = '?' THEN 'Unknown'
								WHEN cstd_activity_demographic.gender = 'U' THEN 'Unknown'
								ELSE ''
								END AS [GenderDescription]
						, CASE WHEN cstd_activity_demographic.ethnicity_code = 0 THEN '-2'
								ELSE CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.ethnicity_code)),'-2') AS varchar(10))
								END AS [EthnicitySSID]
						, CASE WHEN cstd_activity_demographic.ethnicity_code = 0 THEN ''
								ELSE CAST(ISNULL(LTRIM(RTRIM(csta_contact_ethnicity.[description])),'') AS varchar(50))
								END AS [EthnicityDescription]
						, CASE WHEN cstd_activity_demographic.occupation_code = 0 THEN '-2'
								ELSE CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.occupation_code)),'-2') AS varchar(10))
								END AS [OccupationSSID]
						, CASE WHEN cstd_activity_demographic.occupation_code = 0 THEN ''
								ELSE CAST(ISNULL(LTRIM(RTRIM(csta_contact_occupation.[description])),'') AS varchar(50))
								END AS [OccupationDescription]
						, CASE WHEN cstd_activity_demographic.maritalstatus_code = 0 THEN '-2'
								ELSE  CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.maritalstatus_code)),'-2') AS varchar(10))
								END AS [MaritalStatusSSID]
						, CASE WHEN cstd_activity_demographic.maritalstatus_code = 0 THEN ''
								ELSE CAST(ISNULL(LTRIM(RTRIM(csta_contact_maritalstatus.[description])),'') AS varchar(50))
								END AS [MaritalStatusDescription]


						, CAST(CONVERT (VARCHAR(11), cstd_activity_demographic.[Birthday],120 )as date) AS [Birthday]
						, COALESCE(cstd_activity_demographic.age,0) AS [Age]
						, '' AS [AgeRangeSSID]
						, '' AS [AgeRangeDescription]
						, '' AS [HairLossTypeSSID]
						, '' AS [HairLossTypeDescription]
						, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.[norwood])),'') AS varchar(50)) AS [NorwoodSSID]
						, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.[ludwig])),'') AS varchar(50)) AS [LudwigSSID]
						, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.[performer])),'') AS varchar(50)) AS [Performer]
						, COALESCE(cstd_activity_demographic.price_quoted,0) AS [PriceQuoted]
						, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.[solution_offered])),'') AS varchar(100)) AS [SolutionOffered]
						, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.[no_sale_reason])),'') AS varchar(200)) AS [NoSaleReason]
						, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.[updated_date])),'') AS date) AS [DateSaved]
						, cstd_activity_demographic.updated_date AS [ModifiedDate]
						, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.[Disc_Style])),'u') AS nvarchar(20)) AS [DiscStyleSSID]
						, oncd_contact.[cst_sfdc_lead_id]
						, oncd_activity.[cst_sfdc_task_id]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, CAST(ISNULL(LTRIM(RTRIM(cstd_activity_demographic.[activity_demographic_id])),'') AS nvarchar(50)) AS [SourceSystemKey]


				FROM [bi_mktg_stage].[synHC_SRC_TBL_MKTG_cstd_activity_demographic] cstd_activity_demographic WITH (NOLOCK)
				LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity_contact] AS oncd_activity_contact WITH (NOLOCK)
						ON cstd_activity_demographic.activity_id  = oncd_activity_contact.activity_id
						AND oncd_activity_contact.primary_flag = 'Y'
				LEFT OUTER JOIN hcm.dbo.oncd_contact oncd_contact WITH (NOLOCK)
						ON oncd_activity_contact.contact_id = oncd_contact.contact_id
				INNER JOIN hcm.dbo.oncd_activity oncd_activity WITH (NOLOCK)
						ON oncd_activity.activity_id = cstd_activity_demographic.activity_id
				LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_csta_contact_occupation] AS csta_contact_occupation WITH (NOLOCK)
					ON cstd_activity_demographic.occupation_code  = csta_contact_occupation.occupation_code
				LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_csta_contact_ethnicity] AS csta_contact_ethnicity WITH (NOLOCK)
					ON cstd_activity_demographic.ethnicity_code = csta_contact_ethnicity.ethnicity_code
				LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_csta_contact_maritalstatus] AS csta_contact_maritalstatus WITH (NOLOCK)
					ON cstd_activity_demographic.maritalstatus_code = csta_contact_maritalstatus.maritalstatus_code

				WHERE (cstd_activity_demographic.[creation_date] >= @LSET AND cstd_activity_demographic.[creation_date] < @CET)
				OR (cstd_activity_demographic.[updated_date] >= @LSET AND cstd_activity_demographic.[updated_date] < @CET)

				--OR (cstd_activity_demographic.[creation_date] IS NULL)    -- Use on initial Load
				--OR  (cstd_activity_demographic.[creation_date] < '1/1/1990')   -- Use on initial Load

				/*

				SELECT  0 AS '@DataPkgKey'
						, NULL AS ActivityDemographicKey
						, '' AS ActivityDemographicSSID
						, t.ActivityID__c AS ActivitySSID
						, l.ContactID__c AS ContactSSID
						, CASE WHEN Gender__c = 'Male' THEN 'M'
								WHEN Gender__c = 'Female' THEN 'F'
								END AS GenderSSID
						, l.Gender__c
						, e.BosEthnicityCode AS EthnicitySSID
						, l.Ethnicity__c
						, o.BOSOccupationCode AS OccupationSSID
						, t.Occupation__c
						, m.BOSMaritalStatusCode AS MaritalStatusSSID
						, t.MaritalStatus__c
						, l.Birthday__c
						, l.Age__c
						, '' AS AgeRangeSSID
						, l.AgeRange__c AS AgeRangeDescription
						, '' AS HairLossTypeSSID
						, '' AS HairLossTypeDescription
						, t.NorwoodScale__c AS NorwoodSSID
						, t.LudwigScale__c AS LudwigSSID
						, t.Performer__c AS Performer
						, t.PriceQuoted__c AS PriceQuoted
						, t.SolutionOffered__c AS SolutionOffered
						, t.NoSaleReason__c  AS NoSaleReason
						, NULL AS DateSaved
						, t.LastModifiedDate AS ModifiedDate
						, l.DISC__c AS DiscStyleSSID
						, t.WhoId AS cst_sfdc_lead_id
						, t.id AS cst_sfdc_task_id
						, 0 AS IsNew
						, 0 AS IsType1
						, 0 AS IsType2
						, 0 AS IsException
						, 0 AS IsInferredMember
						, l.IsDeleted
						, 0 AS IsDuplicate
						, '' AS SourceSystemKey
						, t.ActivityDate

				FROM HC_BI_SFDC.dbo.Task t
						LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l ON l.Id = t.WhoId
						LEFT OUTER JOIN HC_BI_SFDC.dbo.Result__c r ON r.Result__c = t.Result__c
						LEFT OUTER JOIN HC_BI_SFDC.dbo.HairClubCMS_lkpEthnicity_TABLE e ON e.EthnicityDescription = l.Ethnicity__c
						LEFT OUTER JOIN HC_BI_SFDC.dbo.HairClubCMS_lkpOccupation_TABLE o ON o.OccupationDescription = t.Occupation__c
						LEFT OUTER JOIN HC_BI_SFDC.dbo.HairClubCMS_lkpMaritalStatus_TABLE m ON m.MaritalStatusDescription = t.MaritalStatus__c

				WHERE --t.ActivityDate >= @LSET AND t.ActivityDate < @CET
					  (t.ReportCreateDate__c >= @LSET AND t.ReportCreateDate__c < @CET OR
					   t.LastModifiedDate >= @LSET AND t.LastModifiedDate < @CET) AND
				       t.IsDeleted = 0 AND
	                   r.ONC_ResultCode IN ('SHOWNOSALE', 'SHOWSALE')

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
