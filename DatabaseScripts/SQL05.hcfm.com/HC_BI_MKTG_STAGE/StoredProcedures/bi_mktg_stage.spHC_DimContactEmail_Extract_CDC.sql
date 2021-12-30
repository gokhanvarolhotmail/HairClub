/* CreateDate: 05/03/2010 12:26:36.277 , ModifyDate: 08/31/2021 10:54:24.963 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimContactEmail_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimContactEmail_Extract_CDC] is used to retrieve a
-- list Contact Emails
--
--   exec [bi_mktg_stage].[spHC_DimContactEmail_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009  RLifke       Initial Creation
--			11/21/2017  KMurdoch     Added SFDC_Lead/LeadEmail_ID
--			05/15/2018  KMurdoch     Added [ContactEmailHashed]
--			09/14/2020	KMurdoch     Removed checks for OnContactIDs
--			10/01/2020  KMurdoch	Fixed Hashed email to use Varchar
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

 	SET @TableName = N'[bi_mktg_dds].[DimContactEmail]'
 	SET @CDCTableName = N'dbo_oncd_contact_email'


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


						INSERT INTO [bi_mktg_stage].[DimContactEmail]
								   ( [DataPkgKey]
								   , [ContactEmailKey]
								   , [ContactEmailSSID]
								   , [ContactSSID]
								   , [EmailTypeCode]
								   , [Email]
								   , [Description]
								   , [PrimaryFlag]
								   , [SFDC_LeadID]
								   , [SFDC_LeadEmailID]
								   , [ContactEmailHashed]
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

						SELECT  @DataPkgKey
						,       NULL AS 'ContactEmailKey'
						,       CAST(ISNULL(LTRIM(RTRIM(ec.OncContactEmailID__c)), '') AS NVARCHAR(10)) AS 'ContactEmailSSID'
						,       CAST(ISNULL(LTRIM(RTRIM(l.ContactID__c)), '') AS NVARCHAR(10)) AS 'ContactSSID'
						,       '' AS 'EmailTypeCode'
						,       CAST(ISNULL(LTRIM(RTRIM(ec.Name)), '') AS NVARCHAR(100)) AS 'Email'
						,       '' AS 'Description'
						,       CASE WHEN ec.Primary__c = 1 THEN 'Y' ELSE 'N' END AS 'PrimaryFlag'
						,       ec.Lead__c
						,       ec.Id
						,		HASHBYTES('SHA2_256',CASE
									WHEN PATINDEX(
													'%[&'',":;!+=\/()<>]%',
													LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,ec.[name]), NULL), ']', ''), '[', ''))))
												) > 0 -- Invalid characters
										OR PATINDEX(
														'[@.-_]%',
														LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,ec.[name]), NULL), ']', ''), '[', ''))))
													) > 0 -- Valid but cannot be starting character
										OR PATINDEX(
														'%[@.-_]',
														LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,ec.[name]), NULL), ']', ''), '[', ''))))
													) > 0 -- Valid but cannot be ending character
										OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,ec.[name]), NULL), ']', ''), '[', '')))) NOT LIKE '%@%.%' -- Must contain at least one @ and one .
										OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,ec.[name]), NULL), ']', ''), '[', '')))) LIKE '%..%' -- Cannot have two periods in a row
										OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,ec.[name]), NULL), ']', ''), '[', '')))) LIKE '%@%@%' -- Cannot have two @ anywhere
										OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,ec.[name]), NULL), ']', ''), '[', '')))) LIKE '%.@%'
										OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,ec.[name]), NULL), ']', ''), '[', '')))) LIKE '%@.%' -- Cannot have @ and . next to each other
										OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,ec.[name]), NULL), ']', ''), '[', '')))) LIKE '%.cm'
										OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,ec.[name]), NULL), ']', ''), '[', '')))) LIKE '%.co' -- Camaroon or Colombia? Unlikely. Probably typos
										OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,ec.[name]), NULL), ']', ''), '[', '')))) LIKE '%.or'
										OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,ec.[name]), NULL), ']', ''), '[', '')))) LIKE '%.ne' -- Missing last letter
									THEN
										NULL
									ELSE
										LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,ec.[name]), NULL), ']', ''), '[', ''))))
								END) AS [ContactEmailHashed]
						,       ec.LastModifiedDate AS 'ModifiedDate'
						,       0 AS 'IsNew'
						,       0 AS 'IsType1'
						,       0 AS 'IsType2'
						,       0 AS 'IsException'
						,       0 AS 'IsInferredMember'
						,       0 AS 'IsDelete'
						,       0 AS 'IsDuplicate'
						,       CAST(ISNULL(LTRIM(RTRIM(ec.id)), '') AS NVARCHAR(18)) AS 'SourceSystemKey'

						FROM    SQL06.HC_BI_SFDC.dbo.Email__c ec WITH ( NOLOCK )
				        INNER JOIN SQL06.HC_BI_SFDC.dbo.Lead l WITH ( NOLOCK ) ON l.Id = ec.Lead__c

				WHERE      ((ec.CreatedDate >= @LSET AND ec.CreatedDate < @CET)
							 OR (ec.LastModifiedDate >= @LSET AND ec.LastModifiedDate < @CET)
							 OR (ISNULL(l.ReportCreateDate__c,l.CreatedDate) >= @LSET AND ISNULL(l.ReportCreateDate__c,l.CreatedDate) < @CET)
							 OR (l.LastModifiedDate >= @LSET AND l.LastModifiedDate < @CET)
							)
							 --AND ISNULL(ec.IsDeleted, 0) = 0
							 --AND ISNULL(l.IsDeleted, 0) = 0
							 --AND ec.OncContactEmailID__c IS NOT NULL
							 --AND l.ContactID__c IS NOT NULL

						SET @ExtractRowCnt = @@ROWCOUNT

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



SET ANSI_NULLS ON
GO
