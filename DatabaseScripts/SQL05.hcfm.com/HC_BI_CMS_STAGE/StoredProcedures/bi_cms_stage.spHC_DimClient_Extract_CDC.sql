/* CreateDate: 05/03/2010 12:19:56.713 , ModifyDate: 10/01/2020 11:24:17.463 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimClient_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimClient_Extract_CDC] is used to retrieve a
-- list Client
--
--   exec [bi_cms_stage].[spHC_DimClient_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    05/27/2009  RLifke       Initial Creation
--  v1.1	06/24/2011  KMurdoch	 Added CenterID and Default Client membershipGUIDS
--       	08/09/2011  EKnapp  	 Added Contact info
--			04/08/2015  KMurdoch	 Added BosleyConsultOffice, BosleyProcedureOffice,
--									 BosleySiebelID, ExpectConversionDate
--			05/05/2015  KMurdoch     Added in Marital, Occupation, Ethnicity to DimClient
--			10/04/2018  KMurdoch     Added SFDC_LeadID
--			08/19/2019  RHut		 Added CurrentMDPClientMembershipSSID
--			05/14/2020  KMurdoch     Added ClientEmailAddressHashed
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
				, @CDCTableName			varchar(150)	-- Name of CDC table
				, @ExtractRowCnt		int

 	SET @TableName = N'[bi_cms_dds].[DimClient]'
 	SET @CDCTableName = N'dbo_datClient'


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

				DECLARE	@Start_Time datetime = null,
						@End_Time datetime = null,
						@row_filter_option nvarchar(30) = N'all'

				DECLARE @From_LSN binary(10), @To_LSN binary(10)

				SET @Start_Time = @LSET
				SET @End_Time = @CET

				IF (@Start_Time is null)
					SELECT @From_LSN = [HairClubCMS].[sys].[fn_cdc_get_min_lsn](@CDCTableName)
				ELSE
				BEGIN
					IF ([HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_min_lsn](@CDCTableName)) > @Start_Time) or
					   ([HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_max_lsn]()) < @Start_Time)
						SELECT @From_LSN = null
					ELSE
						SELECT @From_LSN = [HairClubCMS].[sys].[fn_cdc_increment_lsn]([HairClubCMS].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@Start_Time))
				END

				IF (@End_Time is null)
					SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_get_max_lsn]()
				ELSE
				BEGIN
					IF [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_max_lsn]()) < @End_Time
						--SELECT @To_LSN = null
						SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_get_max_lsn]()
					ELSE
						SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@End_Time)
				END


				-- Get the Actual Current Extraction Time
				SELECT @CET = [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time](@To_LSN)

				IF (@From_LSN IS NOT NULL) AND (@To_LSN IS NOT NULL) AND (@From_LSN <> [HairClubCMS].[sys].[fn_cdc_increment_lsn](@To_LSN))
					BEGIN

						-- Set the Current Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET CET = @CET
								, [Status] = 'Extracting'
							WHERE [TableName] = @TableName


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
									, [CDC_Operation]
									)
						SELECT @DataPkgKey
								, NULL AS [ClientKey]
								, chg.[ClientGUID] AS [ClientSSID]
								, chg.[ClientNumber_Temp] AS [ClientNumber_Temp]
								, chg.[ClientIdentifier] AS [ClientIdentifier]
								, chg.[CenterID] AS [CenterSSID]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[FirstName])),'') AS nvarchar(50)) AS [ClientFirstName]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[MiddleName])),'') AS nvarchar(20)) AS [ClientMiddleName]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[LastName])),'') AS nvarchar(50)) AS [ClientLastName]
								, COALESCE(chg.[SalutationID], -2) AS [SalutationSSID]
								, CAST(ISNULL(LTRIM(RTRIM(sal.[SalutationDescription])),'') AS nvarchar(50)) AS [ClientSalutationDescription]
								, CAST(ISNULL(LTRIM(RTRIM(sal.[SalutationDescription])),'') AS nvarchar(10)) AS [ClientSalutationDescriptionShort]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[Address1])),'') AS nvarchar(50)) AS [ClientAddress1]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[Address2])),'') AS nvarchar(50)) AS [ClientAddress2]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[Address3])),'') AS nvarchar(50)) AS [ClientAddress3]
								, CAST(ISNULL(LTRIM(RTRIM(cn.[CountryDescription])),'') AS nvarchar(50)) AS [CountryRegionDescription]
								, CAST(ISNULL(LTRIM(RTRIM(cn.[CountryDescriptionShort])),'') AS nvarchar(10)) AS [CountryRegionDescriptionShort]
								, CAST(ISNULL(LTRIM(RTRIM(st.[StateDescription])),'') AS nvarchar(50)) AS [StateProvinceDescription]
								, CAST(ISNULL(LTRIM(RTRIM(st.[StateDescriptionShort])),'') AS nvarchar(10)) AS [StateProvinceDescriptionShort]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[City])),'') AS nvarchar(50)) AS [City]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[PostalCode])),'') AS nvarchar(15)) AS [PostalCode]
								, chg.[DateOfBirth] AS [ClientDateOfBirth]
								, COALESCE(chg.[GenderID], -2) AS [GenderSSID]
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
								, chg.[DoNotCallFlag] AS [DoNotCallFlag]
								, chg.[DoNotContactFlag] AS [DoNotContactFlag]
								, chg.[IsHairModelFlag] AS [IsHairModelFlag]
								, chg.[IsTaxExemptFlag] AS [IsTaxExemptFlag]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[EMailAddress])),'') AS nvarchar(50)) AS [ClientEMailAddress]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[TextMessageAddress])),'') AS nvarchar(50)) AS [ClientTextMessageAddress]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[Phone1])),'') AS nvarchar(15)) AS [ClientPhone1]
								, COALESCE(chg.[Phone1TypeID], -2) AS [Phone1TypeSSID]
								, CAST(ISNULL(LTRIM(RTRIM(pht1.[PhoneTypeDescription])),'') AS nvarchar(50)) AS [ClientPhone1TypeDescription]
								, CAST(ISNULL(LTRIM(RTRIM(pht1.[PhoneTypeDescriptionShort])),'') AS nvarchar(10)) AS [ClientPhone1TypeDescriptionShort]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[Phone2])),'') AS nvarchar(15)) AS [ClientPhone2]
								, COALESCE(chg.[Phone2TypeID], -2) AS [Phone2TypeSSID]
								, CAST(ISNULL(LTRIM(RTRIM(pht2.[PhoneTypeDescription])),'') AS nvarchar(50)) AS [ClientPhone2TypeDescription]
								, CAST(ISNULL(LTRIM(RTRIM(pht2.[PhoneTypeDescriptionShort])),'') AS nvarchar(10)) AS [ClientPhone2TypeDescriptionShort]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[Phone3])),'') AS nvarchar(15)) AS [ClientPhone3]
								, COALESCE(chg.[Phone3TypeID], -2) AS [Phone3TypeSSID]
								, CAST(ISNULL(LTRIM(RTRIM(pht3.[PhoneTypeDescription])),'') AS nvarchar(50)) AS [ClientPhone3TypeDescription]
								, CAST(ISNULL(LTRIM(RTRIM(pht3.[PhoneTypeDescriptionShort])),'') AS nvarchar(10)) AS [ClientPhone3TypeDescriptionShort]
								, chg.[CurrentBioMatrixClientMembershipGUID] AS [CurrentBioMatrixClientMembershipSSID]
								, chg.[CurrentSurgeryClientMembershipGUID] AS [CurrentSurgeryClientMembershipSSID]
								, chg.[CurrentExtremeTherapyClientMembershipGUID] AS [CurrentExtremeTherapyClientMembershipSSID]
								, chg.[CurrentXtrandsClientMembershipGUID] AS [CurrentXtrandsClientMembershipSSID]
								, chg.[CurrentMDPClientMembershipGUID] AS [CurrentMDPClientMembershipSSID]
								, COALESCE(chg.ARBalance,0) AS ARBalance
								, ISNULL(chg.ContactId, -2) as ContactSSID
								, -1 as ContactKey
								, CAST(ISNULL(LTRIM(RTRIM(BosleyConsultOffice)),'') AS nvarchar(50)) AS [BosleyConsultOffice]
								, CAST(ISNULL(LTRIM(RTRIM(BosleyProcedureOffice)),'') AS nvarchar(50)) AS [BosleyProcedureOffice]
								, CAST(ISNULL(LTRIM(RTRIM(SiebelID)),'') AS nvarchar(50)) AS [BosleySiebelID]
								, chg.ExpectedConversionDate AS [ExpectedConversionDate]
								, chg.SalesforceContactID
								, HASHBYTES('SHA2_256',CASE
									   WHEN PATINDEX(
														'%[&'',":;!+=\/()<>]%',
														LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,chg.emailaddress), NULL), ']', ''), '[', ''))))
													) > 0 -- Invalid characters
											OR PATINDEX(
														   '[@.-_]%',
														   LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,chg.emailaddress), NULL), ']', ''), '[', ''))))
													   ) > 0 -- Valid but cannot be starting character
											OR PATINDEX(
														   '%[@.-_]',
														   LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,chg.emailaddress), NULL), ']', ''), '[', ''))))
													   ) > 0 -- Valid but cannot be ending character
											OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,chg.emailaddress), NULL), ']', ''), '[', '')))) NOT LIKE '%@%.%' -- Must contain at least one @ and one .
											OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,chg.emailaddress), NULL), ']', ''), '[', '')))) LIKE '%..%' -- Cannot have two periods in a row
											OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,chg.emailaddress), NULL), ']', ''), '[', '')))) LIKE '%@%@%' -- Cannot have two @ anywhere
											OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,chg.emailaddress), NULL), ']', ''), '[', '')))) LIKE '%.@%'
											OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,chg.emailaddress), NULL), ']', ''), '[', '')))) LIKE '%@.%' -- Cannot have @ and . next to each other
											OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,chg.emailaddress), NULL), ']', ''), '[', '')))) LIKE '%.cm'
											OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,chg.emailaddress), NULL), ']', ''), '[', '')))) LIKE '%.co' -- Camaroon or Colombia? Unlikely. Probably typos
											OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,chg.emailaddress), NULL), ']', ''), '[', '')))) LIKE '%.or'
											OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,chg.emailaddress), NULL), ']', ''), '[', '')))) LIKE '%.ne' -- Missing last letter
										THEN
										   NULL
										ELSE
										   LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,chg.emailaddress), NULL), ']', ''), '[', ''))))
										END) AS [ClientEmailAddressHashed]
								, [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time](__$start_lsn) AS [ModifiedDate]
								, 0 AS [IsNew]
								, 0 AS [IsType1]
								, 0 AS [IsType2]
								, 0 AS [IsException]
								, 0 AS [IsInferredMember]
								, 0 AS [IsDelete]
								, 0 AS [IsDuplicate]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[ClientGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
								, CASE [__$operation]
										WHEN 1 THEN 'D'
										WHEN 2 THEN 'I'
										WHEN 3 THEN 'UO'
										WHEN 4 THEN 'UN'
										WHEN 5 THEN 'M'
										ELSE NULL
									END AS [CDC_Operation]
							FROM [HairClubCMS].[cdc].[fn_cdc_get_net_changes_dbo_datClient](@From_LSN, @To_LSN, @row_filter_option) chg
							Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpSalutation] sal
									ON chg.[SalutationID] = sal.[SalutationID]
							Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpGender] g
									ON chg.[GenderID] = g.[GenderID]
							Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpState] st
									ON chg.[StateID] = st.[StateID]
							Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpCountry] cn
									ON chg.[CountryID] = cn.[CountryID]
							Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpPhoneType] pht1
									ON chg.[Phone1TypeID] = pht1.[PhoneTypeID]
							Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpPhoneType] pht2
									ON chg.[Phone2TypeID] = pht2.[PhoneTypeID]
							Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpPhoneType] pht3
									ON chg.[Phone3TypeID] = pht3.[PhoneTypeID]
							LEFT OUTER JOIN HairClubCMS.dbo.datClientDemographic AS DCD
									ON DCD.ClientGUID = chg.ClientGUID
							LEFT OUTER JOIN HairClubCMS.dbo.lkpOccupation AS LO
									ON dcd.OccupationID = lo.OccupationID
							LEFT OUTER JOIN HairClubCMS.dbo.lkpMaritalStatus AS LMS
									ON dcd.MaritalStatusID = lms.MaritalStatusID
							LEFT OUTER JOIN HairClubCMS.dbo.lkpEthnicity AS LE
									ON dcd.EthnicityID = le.EthnicityID

						SET @ExtractRowCnt = @@ROWCOUNT

						-- Set the Last Successful Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET LSET = @CET
								, [Status] = 'Extraction Completed'
							WHERE [TableName] = @TableName

					END
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
