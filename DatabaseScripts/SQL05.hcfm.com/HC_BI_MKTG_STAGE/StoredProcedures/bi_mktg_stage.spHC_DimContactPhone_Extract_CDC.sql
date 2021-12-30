/* CreateDate: 05/03/2010 12:26:38.453 , ModifyDate: 09/14/2020 14:03:06.200 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimContactPhone_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimContactPhone_Extract_CDC] is used to retrieve a
-- list Contact Phones
--
--   exec [bi_mktg_stage].[spHC_DimContactPhone_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009  RLifke       Initial Creation
--			11/21/2017  KMurdoch     Added SFDC_Lead/LeadPhone_ID
--			09/14/2020	KMurdoch     removed check for OnContact IDS
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

 	SET @TableName = N'[bi_mktg_dds].[DimContactPhone]'
 	SET @CDCTableName = N'dbo_oncd_contact_phone'


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

				INSERT INTO [bi_mktg_stage].[DimContactPhone]
									( [DataPkgKey]
									, [ContactPhoneKey]
									, [ContactPhoneSSID]
									, [ContactSSID]
									, [PhoneTypeCode]
									, [CountryCodePrefix]
									, [AreaCode]
									, [PhoneNumber]
									, [Extension]
									, [Description]
									, [PrimaryFlag]
									, [SFDC_LeadID]
									, [SFDC_LeadPhoneID]
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

						SELECT
							@DataPkgKey
						,  NULL AS ContactPhoneKey
						,	Phone__c.ContactPhoneID__c AS  ContactPhoneSSID
						,	Phone__c.OncContactID__c  AS ContactSSID
						,	Phone__c.Type__c
						,	'' AS CountryCodePrefix
						,	SUBSTRING(Phone__c.PhoneAbr__c, 1,3) as AreaCode
						,	SUBSTRING(Phone__c.PhoneAbr__c, 4,len(Phone__c.PhoneAbr__c)) as PhoneNumber
						,	'' as Extension
						,	'' as 'Description'
						,	CASE WHEN Phone__c.Primary__c = 1 THEN 'Y'
									WHEN Phone__c.Primary__c = 0 THEN 'N'
									ELSE '' END AS PrimaryFlag
						,	Phone__c.Lead__c AS 'cst_sfdc_lead_id'
						,	Phone__c.Id AS 'cst_sfdc_leadphone_id'
						,   Phone__c.LastModifiedDate
						,	0 as IsNew
						,	0 as IsType1
						,	0 as IsType2
						,	0 as IsException
						,   0 AS IsInferredMember
						,   0 AS IsDelete
						,	0 as IsDuplicate
						--,	CAST(ISNULL(LTRIM(RTRIM(phone__c.ContactPhoneID__c)),'') AS nvarchar(50)) AS SourceSystemKey
						,	CAST(ISNULL(LTRIM(RTRIM(phone__c.id)),'') AS nvarchar(18)) AS SourceSystemKey

						FROM    HC_BI_SFDC.dbo.Phone__c WITH ( NOLOCK )
								LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l WITH ( NOLOCK ) ON l.Id = Phone__c.Lead__c

						WHERE   ((Phone__c.CreatedDate >= @LSET AND Phone__c.CreatedDate < @CET ) OR
								(Phone__c.LastModifiedDate >= @LSET AND Phone__c.LastModifiedDate < @CET) OR
								(l.ReportCreateDate__c >= @LSET AND l.ReportCreateDate__c < @CET ) OR
								(l.LastModifiedDate >= @LSET AND l.LastModifiedDate < @CET))
						--AND ISNULL(Phone__c.IsDeleted, 0) = 0
						--AND ISNULL(l.IsDeleted, 0) = 0
						--AND Phone__c.ContactPhoneID__c IS NOT NULL
						--AND Phone__c.OncContactID__c IS NOT NULL

						SET @ExtractRowCnt = @@ROWCOUNT

						-- Set the Last Successful Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET LSET = @CET
								, [Status] = 'Extraction Completed'
							WHERE [TableName] = @TableName

					--END
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




/****** Object:  StoredProcedure [bi_mktg_stage].[spHC_DimContactSource_Extract]    Script Date: 11/30/2018 12:41:23 PM ******/
SET ANSI_NULLS ON
GO
