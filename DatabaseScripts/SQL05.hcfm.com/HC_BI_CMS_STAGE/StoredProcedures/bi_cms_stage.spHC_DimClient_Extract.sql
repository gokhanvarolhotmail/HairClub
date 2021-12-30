/* CreateDate: 05/03/2010 12:19:54.733 , ModifyDate: 10/01/2020 11:23:15.757 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimClient_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimClient_Extract] is used to retrieve a
-- list Business Unit Brands
--
--   exec [bi_cms_stage].[spHC_DimClient_Extract]  '2009-01-01 01:00:00'
--                                       , '2011-06-24 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    03/12/2009  RLifke       Initial Creation
--  v1.1	06/24/2011  KMurdoch	 Added CenterID and Default Client membershipGUIDS
--       	08/09/2011  EKnapp  	 Added Contact info
--			01/03/2013  EKnapp       Use UTC Current Extraction Time.
--			04/08/2015  KMurdoch	 Added BosleyConsultOffice, BosleyProcedureOffice,
--									 BosleySiebelID, ExpectConversionDate
--			05/05/2015  KMurdoch     Added in Marital, Occupation, Ethnicity to DimClient
--			10/04/2018  KMurdoch     Added SFDC_LeadID
--			08/19/2019  RHut		 Added CurrentMDPClientMembershipSSID
--			05/14/2020  KMurdoch     Added ClientEmailAddressHashed
--			09/30/2020  KMurdoch     Modified Hashed Email Code
--			10/01/2020  KMurdoch     Added conversion to VARCHAR to Email Hash Conversion
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
				, @CET_UTC              datetime

 	SET @TableName = N'[bi_cms_dds].[DimClient]'


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

				-- Convert our Current Extraction Time to UTC time for compare in the Where clause to ensure we pick up latest data.
				SELECT @CET_UTC = [bief_stage].[fn_CorporateToUTCDateTime](@CET)

				INSERT INTO [bi_cms_stage].[DimClient]
						   ( [DataPkgKey]
							, [ClientKey]
							, [ClientSSID]
							, [ClientNumber_Temp]
							, [ClientIdentifier]
							, [CenterSSID]
							, [ClientFirstName]
							, [ClientMiddleName]
							, [ClientLastName]
							, [SalutationSSID]
							, [ClientSalutationDescription]
							, [ClientSalutationDescriptionShort]
							, [ClientAddress1]
							, [ClientAddress2]
							, [ClientAddress3]
						    , [CountryRegionDescription]
						    , [CountryRegionDescriptionShort]
						    , [StateProvinceDescription]
						    , [StateProvinceDescriptionShort]
						    , [City]
							, [PostalCode]
							, [ClientDateOfBirth]
							, [GenderSSID]
							, [ClientGenderDescription]
							, [ClientGenderDescriptionShort]
							, [MaritalStatusSSID]
							, [ClientMaritalStatusDescription]
							, [ClientMaritalStatusDescriptionShort]
							, [OccupationSSID]
							, [ClientOccupationDescription]
							, [ClientOccupationDescriptionShort]
							, [EthinicitySSID]
							, [ClientEthinicityDescription]
							, [ClientEthinicityDescriptionShort]
							, [DoNotCallFlag]
							, [DoNotContactFlag]
							, [IsHairModelFlag]
							, [IsTaxExemptFlag]
							, [ClientEMailAddress]
							, [ClientTextMessageAddress]
							, [ClientPhone1]
							, [Phone1TypeSSID]
							, [ClientPhone1TypeDescription]
							, [ClientPhone1TypeDescriptionShort]
							, [ClientPhone2]
							, [Phone2TypeSSID]
							, [ClientPhone2TypeDescription]
							, [ClientPhone2TypeDescriptionShort]
							, [ClientPhone3]
							, [Phone3TypeSSID]
							, [ClientPhone3TypeDescription]
							, [ClientPhone3TypeDescriptionShort]
							, [CurrentBioMatrixClientMembershipSSID]
							, [CurrentSurgeryClientMembershipSSID]
							, [CurrentExtremeTherapyClientMembershipSSID]
							, [CurrentXtrandsClientMembershipSSID]
							, [CurrentMDPClientMembershipSSID]
							, [ClientARBalance]
							, [ContactSSID]
							, [ContactKey]
							, [BosleyConsultOffice]
							, [BosleyProcedureOffice]
							, [BosleySiebelID]
							, [ExpectedConversionDate]
							, [SFDC_LeadID]
							, [ClientEmailAddressHashed]
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
						, NULL AS [ClientKey]
						, cl.[ClientGUID] AS [ClientSSID]
						, [ClientNumber_Temp] AS [ClientNumber_Temp]
						, cl.[ClientIdentifier] AS [ClientIdentifier]
						, [CenterID] AS [CenterSSID]
						, CAST(ISNULL(LTRIM(RTRIM([FirstName])),'') AS nvarchar(50)) AS [ClientFirstName]
						, CAST(ISNULL(LTRIM(RTRIM([MiddleName])),'') AS nvarchar(20)) AS [ClientMiddleName]
						, CAST(ISNULL(LTRIM(RTRIM([LastName])),'') AS nvarchar(50)) AS [ClientLastName]
						, COALESCE(cl.[SalutationID], -2) AS [SalutationSSID]
						, CAST(ISNULL(LTRIM(RTRIM(sal.[SalutationDescription])),'') AS nvarchar(50)) AS [ClientSalutationDescription]
						, CAST(ISNULL(LTRIM(RTRIM(sal.[SalutationDescription])),'') AS nvarchar(10)) AS [ClientSalutationDescriptionShort]
						, CAST(ISNULL(LTRIM(RTRIM([Address1])),'') AS nvarchar(50)) AS [ClientAddress1]
						, CAST(ISNULL(LTRIM(RTRIM([Address2])),'') AS nvarchar(50)) AS [ClientAddress2]
						, CAST(ISNULL(LTRIM(RTRIM([Address3])),'') AS nvarchar(50)) AS [ClientAddress3]
						, CAST(ISNULL(LTRIM(RTRIM(cn.[CountryDescription])),'') AS nvarchar(50)) AS [CountryRegionDescription]
						, CAST(ISNULL(LTRIM(RTRIM(cn.[CountryDescriptionShort])),'') AS nvarchar(10)) AS [CountryRegionDescriptionShort]
						, CAST(ISNULL(LTRIM(RTRIM(st.[StateDescription])),'') AS nvarchar(50)) AS [StateProvinceDescription]
						, CAST(ISNULL(LTRIM(RTRIM(st.[StateDescriptionShort])),'') AS nvarchar(10)) AS [StateProvinceDescriptionShort]
						, CAST(ISNULL(LTRIM(RTRIM([City])),'') AS nvarchar(50)) AS [City]
						, CAST(ISNULL(LTRIM(RTRIM([PostalCode])),'') AS nvarchar(15)) AS [PostalCode]
						, cl.[DateOfBirth] AS [ClientDateOfBirth]
						, COALESCE(cl.[GenderID], -2) AS [GenderSSID]
						, CAST(ISNULL(LTRIM(RTRIM(g.[GenderDescription])),'') AS nvarchar(50)) AS [ClientGenderDescription]
						, CAST(ISNULL(LTRIM(RTRIM(g.[GenderDescription])),'') AS nvarchar(10)) AS [ClientGenderDescriptionShort]
						, COALESCE(lms.[BOSMaritalStatusCode], -2) AS [MaritalSSID]
						, CAST(ISNULL(LTRIM(RTRIM(lms.[MaritalStatusDescription])),'') AS nvarchar(50)) AS [ClientMaritalDescription]
						, CAST(ISNULL(LTRIM(RTRIM(lms.[MaritalStatusDescriptionShort])),'') AS nvarchar(10)) AS [ClientMaritalDescriptionShort]
						, COALESCE(lo.[BOSOccupationCode], -2) AS [OccupationSSID]
						, CAST(ISNULL(LTRIM(RTRIM(lo.[OccupationDescription])),'') AS nvarchar(50)) AS [ClientOccupationDescription]
						, CAST(ISNULL(LTRIM(RTRIM(lo.[OccupationDescriptionShort])),'') AS nvarchar(10)) AS [ClientOccupationDescriptionShort]
						, COALESCE(le.[BOSEthnicityCode], -2) AS [EthinicitySSID]
						, CAST(ISNULL(LTRIM(RTRIM(le.[EthnicityDescription])),'') AS nvarchar(50)) AS [ClientEthinicityDescription]
						, CAST(ISNULL(LTRIM(RTRIM(le.[EthnicityDescriptionShort])),'') AS nvarchar(10)) AS [ClientEthinicityDescriptionShort]
						, [DoNotCallFlag] AS [DoNotCallFlag]
						, [DoNotContactFlag] AS [DoNotContactFlag]
						, [IsHairModelFlag] AS [IsHairModelFlag]
						, [IsTaxExemptFlag] AS [IsTaxExemptFlag]
						, CAST(ISNULL(LTRIM(RTRIM([EMailAddress])),'') AS nvarchar(50)) AS [ClientEMailAddress]
						, CAST(ISNULL(LTRIM(RTRIM([TextMessageAddress])),'') AS nvarchar(50)) AS [ClientTextMessageAddress]
						, CAST(ISNULL(LTRIM(RTRIM([Phone1])),'') AS nvarchar(15)) AS [ClientPhone1]
						, COALESCE([Phone1TypeID], -2) AS [Phone1TypeSSID]
						, CAST(ISNULL(LTRIM(RTRIM(pht1.[PhoneTypeDescription])),'') AS nvarchar(50)) AS [ClientPhone1TypeDescription]
						, CAST(ISNULL(LTRIM(RTRIM(pht1.[PhoneTypeDescriptionShort])),'') AS nvarchar(10)) AS [ClientPhone1TypeDescriptionShort]
						, CAST(ISNULL(LTRIM(RTRIM([Phone2])),'') AS nvarchar(15)) AS [ClientPhone2]
						, COALESCE([Phone2TypeID], -2) AS [Phone2TypeSSID]
						, CAST(ISNULL(LTRIM(RTRIM(pht2.[PhoneTypeDescription])),'') AS nvarchar(50)) AS [ClientPhone2TypeDescription]
						, CAST(ISNULL(LTRIM(RTRIM(pht2.[PhoneTypeDescriptionShort])),'') AS nvarchar(10)) AS [ClientPhone2TypeDescriptionShort]
						, CAST(ISNULL(LTRIM(RTRIM([Phone3])),'') AS nvarchar(15)) AS [ClientPhone3]
						, COALESCE([Phone3TypeID], -2) AS [Phone3TypeSSID]
						, CAST(ISNULL(LTRIM(RTRIM(pht3.[PhoneTypeDescription])),'') AS nvarchar(50)) AS [ClientPhone3TypeDescription]
						, CAST(ISNULL(LTRIM(RTRIM(pht3.[PhoneTypeDescriptionShort])),'') AS nvarchar(10)) AS [ClientPhone3TypeDescriptionShort]
						, cl.[CurrentBioMatrixClientMembershipGUID]AS [CurrentBioMatrixClientMembershipSSID]
						, cl.[CurrentSurgeryClientMembershipGUID] AS [CurrentSurgeryClientMembershipSSID]
						, cl.[CurrentExtremeTherapyClientMembershipGUID] AS [CurrentExtremeTherapyClientMembershipSSID]
						, cl.[CurrentXtrandsClientMembershipGUID] AS [CurrentXtrandsClientMembershipSSID]
						, cl.[CurrentMDPClientMembershipGUID] AS [CurrentMDPClientMembershipSSID]
						, COALESCE(cl.ARBalance,0) AS ARBalance
						, ISNULL(cl.ContactId,-2) AS ContactSSID
						, -1 as ContactKey
						, CAST(ISNULL(LTRIM(RTRIM(BosleyConsultOffice)),'') AS nvarchar(50)) AS [BosleyConsultOffice]
						, CAST(ISNULL(LTRIM(RTRIM(BosleyProcedureOffice)),'') AS nvarchar(50)) AS [BosleyProcedureOffice]
						, CAST(ISNULL(LTRIM(RTRIM(SiebelID)),'') AS nvarchar(50)) AS [BosleySiebelID]
						, cl.ExpectedConversionDate AS [ExpectedConversionDate]
						, cl.SalesforceContactID
						, HASHBYTES('SHA2_256',CASE
						   WHEN PATINDEX(
											'%[&'',":;!+=\/()<>]%',
											LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,cl.emailaddress), NULL), ']', ''), '[', ''))))
										) > 0 -- Invalid characters
								OR PATINDEX(
											   '[@.-_]%',
											   LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,cl.emailaddress), NULL), ']', ''), '[', ''))))
										   ) > 0 -- Valid but cannot be starting character
								OR PATINDEX(
											   '%[@.-_]',
											   LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,cl.emailaddress), NULL), ']', ''), '[', ''))))
										   ) > 0 -- Valid but cannot be ending character
								OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,cl.emailaddress), NULL), ']', ''), '[', '')))) NOT LIKE '%@%.%' -- Must contain at least one @ and one .
								OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,cl.emailaddress), NULL), ']', ''), '[', '')))) LIKE '%..%' -- Cannot have two periods in a row
								OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,cl.emailaddress), NULL), ']', ''), '[', '')))) LIKE '%@%@%' -- Cannot have two @ anywhere
								OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,cl.emailaddress), NULL), ']', ''), '[', '')))) LIKE '%.@%'
								OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,cl.emailaddress), NULL), ']', ''), '[', '')))) LIKE '%@.%' -- Cannot have @ and . next to each other
								OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,cl.emailaddress), NULL), ']', ''), '[', '')))) LIKE '%.cm'
								OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,cl.emailaddress), NULL), ']', ''), '[', '')))) LIKE '%.co' -- Camaroon or Colombia? Unlikely. Probably typos
								OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,cl.emailaddress), NULL), ']', ''), '[', '')))) LIKE '%.or'
								OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,cl.emailaddress), NULL), ']', ''), '[', '')))) LIKE '%.ne' -- Missing last letter
							THEN
							   NULL
						    ELSE
							   LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,cl.emailaddress), NULL), ']', ''), '[', ''))))
							END) AS [ClientEmailAddressHashed]
						, cl.[LastUpdate] AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, CAST(ISNULL(LTRIM(RTRIM(cl.[ClientGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM [bi_cms_stage].[synHC_SRC_TBL_CMS_datClient] cl
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpSalutation] sal
							ON cl.[SalutationID] = sal.[SalutationID]
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpGender] g
							ON cl.[GenderID] = g.[GenderID]
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpState] st
							ON cl.[StateID] = st.[StateID]
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpCountry] cn
							ON cl.[CountryID] = cn.[CountryID]
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpPhoneType] pht1
							ON cl.[Phone1TypeID] = pht1.[PhoneTypeID]
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpPhoneType] pht2
							ON cl.[Phone2TypeID] = pht2.[PhoneTypeID]
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpPhoneType] pht3
							ON cl.[Phone3TypeID] = pht3.[PhoneTypeID]
					LEFT OUTER JOIN HairClubCMS.dbo.datClientDemographic AS DCD
							ON DCD.ClientGUID = cl.ClientGUID
					LEFT OUTER JOIN HairClubCMS.dbo.lkpOccupation AS LO
							ON dcd.OccupationID = lo.OccupationID
					LEFT OUTER JOIN HairClubCMS.dbo.lkpMaritalStatus AS LMS
							ON dcd.MaritalStatusID = lms.MaritalStatusID
					LEFT OUTER JOIN HairClubCMS.dbo.lkpEthnicity AS LE
							ON dcd.EthnicityID = le.EthnicityID
				WHERE (cl.[CreateDate] >= @LSET AND cl.[CreateDate] < @CET_UTC)
					OR (cl.[LastUpdate] >= @LSET AND cl.[LastUpdate] < @CET_UTC)
					--OR (cl.[LastUpdate] IS NULL)	--Initial Load
				--	OR (cl.[CreateDate] IS NULL)	--Initial Load

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
