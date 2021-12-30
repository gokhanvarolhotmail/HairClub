/* CreateDate: 05/03/2010 12:26:40.640 , ModifyDate: 08/24/2021 18:33:10.400 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimContact_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimContact_Extract] is used to retrieve a
-- list Contacts
--
--   exec [bi_mktg_stage].[spHC_DimContact_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009  RLifke       Initial Creation
--			07/25/2011  KMurdoch	 Added Adi Flag/Removed ADI Flag
--			08/22/2017  KMurdoch	 Added HairLoss Question/Answers
--			10/24/2017  KMurdoch     Added Creation and Update Date
--			11/20/2017  KMurdoch     Added SFDC_LeadID
--			04/13/2018  KMurdoch	 Added SiebelID
--			07/22/2019  DLeiba		 Added JOINs to DimAgeRange table to properly determine Age Range based on either Age__c or AgeRange__c
--			07/14/2020  KMurdoch     Added DMARegion & DMADescription
--			07/16/2020  KMurdoch     Fixed issue with Centernumber__c and CenterID__c on join
--			07/23/2020  KMurdoch	 Added Address info to DimContact
--			08/21/2020  KMurdoch     Added GCLID to DimContact
--			09/10/2020  KMurdoch     Changed length of ContactStatusSSID to Nvarchar(50)
--			09/10/2020  KMurdoch     added SFDC_PersonAccountID
--			10/26/2020  KMurdoch     Added SFDC_IsDeleted
--			11/24/2020  KMurdoch     Added LeadSource
--			12/15/2020  KMurdoch     Changed Derivation of LeadSource
--			02/09/2021  KMurdoch     Added Phone, Email, & Mobile Phone
--			03/22/2021  KMurdoch     Added Lead_Activity_Status__c
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

 	SET @TableName = N'[bi_mktg_dds].[DimContact]'


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


				INSERT INTO [bi_mktg_stage].[DimContact]
						   ( [DataPkgKey]
						   , [ContactKey]
						   , [ContactSSID]
						   , [ContactFirstName]
						   , [ContactMiddleName]
						   , [ContactLastName]
						   , [ContactSuffix]
						   , [Salutation]
						   , [ContactStatusSSID]
						   , [ContactStatusDescription]
						   , [ContactMethodSSID]
						   , [ContactMethodDescription]
						   , [DoNotSolicitFlag]
						   , [DoNotCallFlag]
						   , [DoNotEmailFlag]
						   , [DoNotMailFlag]
						   , [DoNotTextFlag]
						   , [ContactGender]
						   , [ContactCallTime]
						   , [CompleteSale]
						   , [ContactResearch]
						   , [ReferringStore]
						   , [ReferringStylist]
						   , [ContactLanguageSSID]
						   , [ContactLanguageDescription]
						   , [ContactPromotonSSID]
						   , [ContactPromotionDescription]
						   , [ContactRequestSSID]
						   , [ContactRequestDescription]
						   , [ContactAgeRangeSSID]
						   , [ContactAgeRangeDescription]
						   , [ContactHairLossSSID]
						   , [ContactHairLossDescription]
						   , [DNCFlag]
						   , [DNCDate]
						   , [ContactAffiliateID]
						   , [ContactCenterSSID]
						   , [ContactCenter]
						   , [ContactAlternateCenter]
						   , [HairLossTreatment]
						   , [HairLossSpot]
						   , [HairLossExperience]
						   , [HairLossInFamily]
						   , [HairLossFamily]
						   , [CreationDate]
						   , [UpdateDate]
						   , [ContactSessionid]
						   , [SFDC_LeadID]
						   , [SFDC_PersonAccountID]
						   , [BosleySiebelID]
						   , [Street]
						   , [City]
						   , [State]
						   , [StateCode]
						   , [Country]
						   , [CountryCode]
						   , [PostalCode]
						   , [GCLID]
						   , [LeadSource]
						   , [Phone]
						   , [MobilePhone]
						   , [Email]
						   , [Lead_Activity_Status__c]
						   --, [AdiFlag]
						   , [ModifiedDate]
						   , [IsNew]
						   , [IsType1]
						   , [IsType2]
						   , [IsException]
						   , [IsInferredMember]
							, [IsDelete]
							, [IsDuplicate]
						   , [SourceSystemKey]
						   , [DMARegion]
						   , [DMADescription]
						   , [SFDC_IsDeleted]

							)
				SELECT  @DataPkgKey
				,		NULL AS 'ContactKey'
				,       CAST(ISNULL(LTRIM(RTRIM(l.ContactID__c)), '') AS NVARCHAR(10)) AS 'ContactSSID'
				,       CAST(ISNULL(LTRIM(RTRIM(l.FirstName)), '') AS NVARCHAR(50)) AS 'ContactFirstName'
				,       '' AS 'ContactMiddleName'
				,       CAST(ISNULL(LTRIM(RTRIM(l.LastName)), '') AS NVARCHAR(50)) AS 'ContactLastName'
				,       '' AS 'ContactSuffix'
				,       '' AS 'Salutation'
				,       CASE WHEN l.Source_Code_Legacy__c = 'DGEMAEXDREM11680' THEN 'Prospect' ELSE CAST(ISNULL(LTRIM(RTRIM(l.Status)), '') AS NVARCHAR(50)) END AS 'ContactStatusSSID'
				,       CASE WHEN l.Source_Code_Legacy__c = 'DGEMAEXDREM11680' THEN 'Prospect' ELSE CAST(ISNULL(LTRIM(RTRIM(l.Status)), '') AS NVARCHAR(50)) END AS 'ContactStatusDescription'
				,       CASE WHEN l.Source_Code_Legacy__c = 'DGEMAEXDREM11680' THEN 'Prospect' ELSE CAST(ISNULL(LTRIM(RTRIM(l.Status)), '') AS NVARCHAR(50)) END AS 'ContactMethodSSID'
				,       '' AS 'ContactMethodDescription'
				,       'N' AS 'DoNotSolicitFlag'

				,       CASE WHEN l.DoNotCall = 0 THEN 'N'
							 WHEN l.DoNotCall = 1 THEN 'Y'
							 ELSE '' END  AS 'DoNotCallFlag'

				,       CASE WHEN l.DoNotEmail__c = 0 THEN 'N'
							 WHEN l.DoNotEmail__c = 1 THEN 'Y'
							 ELSE '' END  AS 'DoNotEmailFlag'

				,       CASE WHEN l.DoNotMail__c = 0 THEN 'N'
							 WHEN l.DoNotMail__c = 1 THEN 'Y'
							 ELSE '' END  AS 'DoNotMailFlag'

				,       CASE WHEN l.DoNotText__c = 0 THEN 'N'
							 WHEN l.DoNotText__c = 1 THEN 'Y'
							 ELSE '' END  AS 'DoNotTextFlag'
				,		ISNULL(l.Gender__c, 'Male')  AS Gender__c
				,       '' AS 'ContactCallTime'
				,       '' AS 'CompleteSale'
				,       '' AS 'ContactResearch'
				,       '' AS 'ReferringStore'
				,       '' AS 'ReferringStylist'
				,       CAST(ISNULL(LTRIM(RTRIM(l.Language__c)), 'ENGLISH') AS NVARCHAR(10)) AS 'ContactLanguageSSID'
				,       CAST(ISNULL(LTRIM(RTRIM(l.Language__c)), 'English') AS NVARCHAR(50)) AS 'ContactLanguageDescription'
				,       CASE WHEN LEN(l.Promo_Code_Legacy__c) > 10 THEN '' ELSE CAST(ISNULL(LTRIM(RTRIM(l.Promo_Code_Legacy__c)), '') AS NVARCHAR(10)) END AS 'ContactPromotonSSID'
				,       CASE WHEN LEN(l.Promo_Code_Legacy__c) > 10 THEN '' ELSE CAST(ISNULL(LTRIM(RTRIM(p.PromoCodeDescription__c)), '') AS NVARCHAR(50)) END AS 'ContactPromotionDescription'
				,       '' AS 'ContactRequestSSID'
				,       '' AS 'ContactRequestDescription'
				--,       CAST(ISNULL(LTRIM(RTRIM(l.AgeRange__c)), 'UNKNOWN') AS NVARCHAR(10)) AS 'ContactAgeRangeSSID'
				--,       CAST(ISNULL(LTRIM(RTRIM(l.AgeRange__c)), 'UNKNOWN') AS NVARCHAR(50)) AS 'ContactAgeRangeDescription'
				,		CASE WHEN ISNULL(COALESCE(o_C.AgeCalc, l.Age__c), 0) = 0 AND ISNULL(l.AgeRange__c, 'Unknown') <> 'Unknown' THEN darAR.AgeRangeSSID
							WHEN (ISNULL(COALESCE(o_C.AgeCalc, l.Age__c), 0) <> 0 AND ISNULL(COALESCE(o_C.AgeCalc, l.Age__c), 0) <= 120) AND ISNULL(l.AgeRange__c, 'Unknown') = 'Unknown' THEN darA.AgeRangeSSID
							WHEN ISNULL(COALESCE(o_C.AgeCalc, l.Age__c), 0) > 120 THEN -2
							ELSE -2
						END AS 'ContactAgeRangeSSID'
				,		CASE WHEN ISNULL(COALESCE(o_C.AgeCalc, l.Age__c), 0) = 0 AND ISNULL(l.AgeRange__c, 'Unknown') <> 'Unknown' THEN darAR.AgeRangeDescription
							WHEN (ISNULL(COALESCE(o_C.AgeCalc, l.Age__c), 0) <> 0 AND ISNULL(COALESCE(o_C.AgeCalc, l.Age__c), 0) <= 120) AND ISNULL(l.AgeRange__c, 'Unknown') = 'Unknown' THEN darA.AgeRangeDescription
							WHEN ISNULL(COALESCE(o_C.AgeCalc, l.Age__c), 0) > 120 THEN 'Unknown'
							ELSE 'Unknown'
						END AS 'ContactAgeRangeDescription'
				,       CAST(ISNULL(LTRIM(RTRIM(l.HairLossProductUsed__c)), 'UNKNOWN') AS NVARCHAR(10)) AS 'ContactHairLossSSID'
				,       CAST(ISNULL(LTRIM(RTRIM(l.HairLossProductUsed__c)), 'UNKNOWN') AS NVARCHAR(50)) AS 'ContactHairLossDescription'
				,       CAST(ISNULL(LTRIM(RTRIM(l.DoNotCall)), '0') AS NVARCHAR(255)) AS 'DNCFlag'
				,       l.LastModifiedDate AS 'DNCDate'
				,       CAST(ISNULL(LTRIM(RTRIM(l.OnCAffiliateID__c)), '') AS NVARCHAR(50)) AS 'ContactAffiliateID'
				,       CAST(ISNULL(LTRIM(RTRIM(ISNULL(l.CenterNumber__c, l.CenterID__c))), '') AS NVARCHAR(10)) AS 'ContactCenterSSID'
				,       CAST(ISNULL(LTRIM(RTRIM(ISNULL(l.CenterNumber__c, l.CenterID__c))), '') AS NVARCHAR(10)) AS 'ContactCenter'
				,       CAST(ISNULL(LTRIM(RTRIM(ISNULL(l.CenterNumber__c, l.CenterID__c))), '') AS NVARCHAR(10)) AS 'ContactAlternateCenter'
				,       CAST(ISNULL(LTRIM(RTRIM(l.HairLossProductOther__c)), '') AS NVARCHAR(50)) AS 'HairLossTreatment'
				,       CAST(ISNULL(LTRIM(RTRIM(l.HairLossSpot__c)), '') AS NVARCHAR(50)) AS 'HairLossSpot'
				,       CAST(ISNULL(LTRIM(RTRIM(l.HairLossExperience__c)), '') AS NVARCHAR(50)) AS 'HairLossExperience'
				,       NULL AS 'HairLossInFamily'
				,       CAST(ISNULL(LTRIM(RTRIM(l.HairLossFamily__c)), '') AS NVARCHAR(50)) AS 'HairLossFamily'
				,       l.ReportCreateDate__c AS 'creation_date'
				,       l.LastModifiedDate AS 'updated_date'
				,       l.GCLID__c AS 'cst_sessionid'
				,       l.Id AS 'cst_sfdc_lead_id'
				,		l.ConvertedContactID AS 'SFDC_PersonAccountID'
				,       l.SiebelID__c AS 'cst_siebel_id'
				,		l.Street AS 'Street'
				,		l.City AS 'City'
				,		l.State AS 'State'
				,		l.StateCode AS 'StateCode'
				,		l.Country AS 'Country'
				,		l.CountryCode AS 'CountryCode'
				,		l.PostalCode AS 'PostalCode'
				,		l.GCLID__c
				,		CASE	WHEN l.LeadSource IS NULL AND U.Username = 'bosleyintegration@hairclub.com' THEN 'Other-Bos'
								WHEN l.LeadSource IS NULL AND U.Username = 'conectintegration@hcfm.com' THEN 'Other-HC'
								WHEN l.LeadSource IS NULL AND U.Username = 'hanswiemannintegration@hcfm.com' THEN 'Other-HW'
								WHEN l.LeadSource IS NULL AND U.Username = 'sfintegration@hcfm.com' THEN 'Other-Web'
								ELSE l.LeadSource END AS 'LeadSource'
				,		l.Phone
				,		l.MobilePhone
				,		l.Email
				,		l.Lead_Activity_Status__c
				,       GETDATE() AS 'TimeStamp'
				,       0 AS 'IsNew'
				,       0 AS 'IsType1'
				,       0 AS 'IsType2'
				,       0 AS 'IsException'
				,       0 AS 'IsInferredMember'
				,       0 AS 'IsDelete'
				,       0 AS 'IsDuplicate'
				,       CAST(ISNULL(LTRIM(RTRIM(l.id)), '') AS NVARCHAR(18)) AS 'SourceSystemKey'
				,		ISNULL(C.DMARegion, 'Unknown')
				,		ISNULL(Mkt.DMA_Name_Nielsen, 'Unknown')
				,		ISNULL(l.IsDeleted,0)
					FROM    SQL06.HC_BI_SFDC.dbo.Lead l WITH ( NOLOCK )
					        LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.PromoCode__c p WITH ( NOLOCK )
								ON l.Promo_Code_Legacy__c = p.PromoCode__c
							LEFT OUTER JOIN SQL06.HC_BI_SFDC.dbo.[User] U
								ON U.CreatedById = L.ID
							OUTER APPLY (
								SELECT	TOP 1
										clt.DateOfBirth
								,		clt.AgeCalc
								FROM	HairClubCMS.dbo.datClient clt
								WHERE	clt.SalesforceContactID = l.Id
								ORDER BY clt.CreateDate DESC
							) o_C
							LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange darA
								ON ISNULL(COALESCE(o_C.AgeCalc, l.Age__c), 0) BETWEEN darA.BeginAge AND darA.EndAge
							LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange darAR
								ON ISNULL(l.AgeRange__c, 'Unknown') = darAR.AgeRangeDescription
							LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.dimcenter C
								ON ISNULL(L.CenterNumber__c, l.CenterID__c) = C.CenterNumber
							LEFT OUTER JOIN HC_Marketing.dbo.lkpDMAtoZipCode Mkt
								ON l.PostalCode = mkt.zipcode
					WHERE   (( ISNULL(l.ReportCreateDate__c,l.CreatedDate) >= @LSET AND ISNULL(l.ReportCreateDate__c,l.CreatedDate) < @CET )
							OR ( l.LastModifiedDate >= @LSET AND l.LastModifiedDate < @CET ))


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




/****** Object:  StoredProcedure [bi_mktg_stage].[spHC_DimContact_Extract_CDC]    Script Date: 11/30/2018 12:31:11 PM ******/
SET ANSI_NULLS ON
GO
