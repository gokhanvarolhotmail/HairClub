/* CreateDate: 05/03/2010 12:26:32.083 , ModifyDate: 08/31/2021 00:24:09.763 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimContactAddress_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimContactAddress_Extract] is used to retrieve a
-- list of Contact Addresses
--
--   exec [bi_mktg_stage].[spHC_DimContactAddress_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009  RLifke       Initial Creation
--			11/27/2017	KMurdoch     Added SFDC_Lead/LeadAddress_ID
--			07/23/2020	KMurdoch	 Changed select to be from Lead rather than address
--			07/23/2020  KMurdoch     Changed back to Address as primary
--			09/14/2020  KMurdoch     Removed Check for OnContactIDs
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

 	SET @TableName = N'[bi_mktg_dds].[DimContactAddress]'


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


				INSERT INTO [bi_mktg_stage].[DimContactAddress]
						   ( [DataPkgKey]
						   , [ContactAddressKey]
						   , [ContactAddressSSID]
						   , [ContactSSID]
						   , [AddressTypeCode]
						   , [AddressLine1]
						   , [AddressLine2]
						   , [AddressLine3]
						   , [AddressLine4]
						   , [AddressLine1Soundex]
						   , [AddressLine2Soundex]
						   , [City]
						   , [CitySoundex]
						   , [StateCode]
						   , [StateName]
						   , [ZipCode]
						   , [CountyCode]
						   , [CountyName]
						   , [CountryCode]
						   , [CountryName]
						   , [CountryPrefix]
						   , [TimeZoneCode]
						   , [PrimaryFlag]
						   , [SFDC_LeadID]
						   , [SFDC_LeadAddressID]
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
				,NULL AS ContactAddressKey
				,Address__c.OncContactAddressID__c AS ContactAddressSSID
				,Address__c.OncContactID__c AS ContactSSID
				,'' AS AddressType
				,COALESCE(Address__c.Street__c, Lead.Street) AS 'Street__c'
				,Address__c.Street2__c
				,Address__c.Street3__c
				,Address__c.Street4__c
				,'' AS AddressLine1Soundex
				,'' AS AddressLine2Soundex
				,ISNULL(COALESCE(Address__c.City__c, Lead.City), '') AS city
				,'' AS CitySoundex
				,COALESCE(Address__c.State__c, Lead.StateCode) AS 'State__c'
				,'' AS 'statename'
				,COALESCE(Address__c.Zip__c, Lead.PostalCode) AS 'Zip__c'
				,'' AS 'CountyCode'
				,'' AS 'CountyName'
				,CASE WHEN COALESCE(Address__c.Country__c,lead.[Country]) = 'United States' THEN 'US'
					  WHEN COALESCE(Address__c.Country__c,lead.[Country])  = 'Canada' THEN 'CA'
					  ELSE '' END AS CountryCode
				,ISNULL(ISNULL(Address__c.Country__c, lead.country),'')
				,CASE WHEN Address__c.Country__c = 'United States' THEN 1 ELSE '' end  AS 'countryPrefix'
				--,Task.TimeZone__c AS 'TimeZoneCode'
				, ''  AS 'TimeZoneCode'
				,CASE WHEN Address__c.id IS NULL THEN 'Y'
					  WHEN Address__c.Primary__c = 1 THEN 'Y'
					  WHEN Address__c.Primary__c = 0 THEN 'N'
					  ELSE '' END AS PrimaryFlag
				,Address__c.Lead__c
				,Address__c.Id
				,Address__c.LastModifiedDate
				, 0 AS IsNew
				, 0 AS IsType1
				, 0 AS IsType2
				, 0 AS IsException
				, 0 AS IsInferredMember
				, 0 AS IsDelete
				, 0 AS IsDuplicate
				--,CAST(ISNULL(LTRIM(RTRIM(Address__c.id)),'') AS nvarchar(50)) AS SourceSystemKey
				,CAST(ISNULL(LTRIM(RTRIM(Address__c.id)),'') AS nvarchar(18)) AS SourceSystemKey

				FROM SQL06.HC_BI_SFDC.dbo.Address__c WITH ( NOLOCK )
						LEFT Outer JOIN SQL06.HC_BI_SFDC.dbo.Lead WITH ( NOLOCK ) ON Address__c.Lead__c = lead.Id

				WHERE   (( ISNULL(lead.ReportCreateDate__c,lead.CreatedDate) >= @LSET AND  ISNULL(lead.ReportCreateDate__c,lead.CreatedDate) < @CET ) OR
						(lead.LastModifiedDate >= @LSET AND lead.LastModifiedDate < @CET) OR
						(Address__c.CreatedDate >= @LSET AND Address__c.CreatedDate < @CET ) OR
						(Address__c.LastModifiedDate >= @LSET AND Address__c.LastModifiedDate < @CET))
					 --   AND ISNULL(Address__c.IsDeleted, 0) = 0
						--AND ISNULL(lead.IsDeleted, 0) = 0
						--AND Address__c.OncContactAddressID__c IS NOT NULL
						--AND Address__c.OncContactID__c IS NOT NULL

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


SET ANSI_NULLS ON
GO
