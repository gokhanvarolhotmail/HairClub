/* CreateDate: 05/03/2010 12:19:47.507 , ModifyDate: 05/15/2020 08:37:38.633 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DDS_DimClient_Upsert]
			   @DataPkgKey					int
			 , @IgnoreRowCnt				bigint output
			 , @InsertRowCnt				bigint output
			 , @UpdateRowCnt				bigint output
			 , @ExceptionRowCnt				bigint output
			 , @ExtractRowCnt				bigint output
			 , @InsertNewRowCnt				bigint output
			 , @InsertInferredRowCnt		bigint output
			 , @InsertSCD2RowCnt			bigint output
			 , @UpdateInferredRowCnt		bigint output
			 , @UpdateSCD1RowCnt			bigint output
			 , @UpdateSCD2RowCnt			bigint output
			 , @InitialRowCnt				bigint output
			 , @FinalRowCnt					bigint output

AS
-------------------------------------------------------------------------
-- [spHC_DDS_DimClient_Upsert] is used to update
-- SCD Type 1 records, update SCD Type 2 records and insert
-- New records
--
--
--   exec [bi_cms_stage].[spHC_DDS_DimClient_Upsert] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/25/2009  RLifke       Initial Creation
--  v1.1	06/24/2011  KMurdoch	 Added CenterID and Default Client membershipGUIDS
--			08/09/2011  EKnapp       Added ContactID
--			04/08/2015  KMurdoch	 Added BosleyConsultOffice, BosleyProcedureOffice, BosleySiebelID, ExpectConversionDate
--			10/04/2018	KMurdoch     Added SFDC_LeadID to DimClient
--			08/19/2019  RHut		 Added CurrentMDPClientMembershipSSID
--			05/15/2020  KMurdoch     Added ClientEmailAddressHashed
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

	DECLARE		  @DeletedRowCnt		bigint
				, @DuplicateRowCnt		bigint
				, @HealthyRowCnt		bigint
				, @RejectedRowCnt		bigint
				, @AllowedRowCnt		bigint
				, @FixedRowCnt			bigint

 	SET @TableName = N'[bi_cms_dds].[DimClient]'


	BEGIN TRY

		SET @IgnoreRowCnt = 0
		SET @InsertRowCnt = 0
		SET @UpdateRowCnt = 0
		SET @ExceptionRowCnt = 0
		SET @ExtractRowCnt = 0
		SET @InsertNewRowCnt = 0
		SET @InsertInferredRowCnt = 0
		SET @InsertSCD2RowCnt = 0
		SET @UpdateInferredRowCnt = 0
		SET @UpdateSCD1RowCnt = 0
		SET @UpdateSCD2RowCnt = 0
		SET @InitialRowCnt = 0
		SET @FinalRowCnt = 0
		SET @DeletedRowCnt = 0
		SET @DuplicateRowCnt = 0
		SET @HealthyRowCnt = 0
		SET @RejectedRowCnt = 0
		SET @AllowedRowCnt = 0
		SET @FixedRowCnt = 0

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_LoadStart] @DataPkgKey, @TableName

		-- Determine Initial Row Cnt
		SELECT @InitialRowCnt = COUNT(1) FROM [bi_cms_stage].[synHC_DDS_DimClient]

		-- Determine the number of extracted rows
		SELECT @ExtractRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimClient] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey

		------------------------
		-- New Records
		------------------------
		INSERT INTO [bi_cms_stage].[synHC_DDS_DimClient] (
					  [ClientSSID]
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
					, [ContactKey]
					, [BosleyConsultOffice]
					, [BosleyProcedureOffice]
					, [BosleySiebelID]
					, [ExpectedConversionDate]
					, [ClientEmailAddressHashed]
					, [SFDC_LeadID]
					, [RowIsCurrent]
					, [RowStartDate]
					, [RowEndDate]
					, [RowChangeReason]
					, [RowIsInferred]
					, [InsertAuditKey]
					, [UpdateAuditKey]
					)
			SELECT
				  STG.[ClientSSID]
				, STG.[ClientNumber_Temp]
				, STG.[ClientIdentifier]
				, STG.[CenterSSID]
				, STG.[ClientFirstName]
				, STG.[ClientMiddleName]
				, STG.[ClientLastName]
				, STG.[SalutationSSID]
				, STG.[ClientSalutationDescription]
				, STG.[ClientSalutationDescriptionShort]
				, STG.[ClientAddress1]
				, STG.[ClientAddress2]
				, STG.[ClientAddress3]
				, STG.[CountryRegionDescription]
				, STG.[CountryRegionDescriptionShort]
				, STG.[StateProvinceDescription]
				, STG.[StateProvinceDescriptionShort]
				, STG.[City]
				, STG.[PostalCode]
				, STG.[ClientDateOfBirth]
				, STG.[GenderSSID]
				, STG.[ClientGenderDescription]
				, STG.[ClientGenderDescriptionShort]
				, STG.[MaritalStatusSSID]
				, STG.[ClientMaritalStatusDescription]
				, STG.[ClientMaritalStatusDescriptionShort]
				, STG.[OccupationSSID]
				, STG.[ClientOccupationDescription]
				, STG.[ClientOccupationDescriptionShort]
				, STG.[EthinicitySSID]
				, STG.[ClientEthinicityDescription]
				, STG.[ClientEthinicityDescriptionShort]
				, STG.[DoNotCallFlag]
				, STG.[DoNotContactFlag]
				, STG.[IsHairModelFlag]
				, STG.[IsTaxExemptFlag]
				, STG.[ClientEMailAddress]
				, STG.[ClientTextMessageAddress]
				, STG.[ClientPhone1]
				, STG.[Phone1TypeSSID]
				, STG.[ClientPhone1TypeDescription]
				, STG.[ClientPhone1TypeDescriptionShort]
				, STG.[ClientPhone2]
				, STG.[Phone2TypeSSID]
				, STG.[ClientPhone2TypeDescription]
				, STG.[ClientPhone2TypeDescriptionShort]
				, STG.[ClientPhone3]
				, STG.[Phone3TypeSSID]
				, STG.[ClientPhone3TypeDescription]
				, STG.[ClientPhone3TypeDescriptionShort]
				, STG.[CurrentBioMatrixClientMembershipSSID]
				, STG.[CurrentSurgeryClientMembershipSSID]
				, STG.[CurrentExtremeTherapyClientMembershipSSID]
				, STG.[CurrentXtrandsClientMembershipSSID]
				, STG.[CurrentMDPClientMembershipSSID]
				, STG.[ClientARBalance]
				, STG.[ContactKey]
				, STG.[BosleyConsultOffice]
				, STG.[BosleyProcedureOffice]
				, STG.[BosleySiebelID]
				, STG.[ExpectedConversionDate]
				, STG.[ClientEmailAddressHashed]
				, STG.[SFDC_LeadID]
				, 1 -- [RowIsCurrent]
				, CAST('1753-01-01 00:00:00' AS DateTime) -- [RowStartDate]
				, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
				, 'New Record' -- [RowChangeReason]
				, 0
				, @DataPkgKey
				, -2 -- 'Not Updated Yet'
			FROM [bi_cms_stage].[DimClient] STG
			WHERE	STG.[IsNew] = 1
				AND	STG.[IsException] = 0
				AND STG.[IsDuplicate] = 0
				AND STG.[DataPkgKey] = @DataPkgKey

		SET @InsertNewRowCnt = @@ROWCOUNT


		------------------------
		-- Inferred Members
		------------------------
		-- Just update the record
		UPDATE DW SET
				  DW.[ClientNumber_Temp] = STG.[ClientNumber_Temp]
				, DW.[ClientIdentifier] = STG.[ClientIdentifier]
				, DW.[CenterSSID] = STG.[CenterSSID]
				, DW.[ClientFirstName] = STG.[ClientFirstName]
				, DW.[ClientMiddleName] = STG.[ClientMiddleName]
				, DW.[ClientLastName] = STG.[ClientLastName]
				, DW.[SalutationSSID] = STG.[SalutationSSID]
				, DW.[ClientSalutationDescription] = STG.[ClientSalutationDescription]
				, DW.[ClientSalutationDescriptionShort] = STG.[ClientSalutationDescriptionShort]
				, DW.[ClientAddress1] = STG.[ClientAddress1]
				, DW.[ClientAddress2] = STG.[ClientAddress2]
				, DW.[ClientAddress3] = STG.[ClientAddress3]
				, DW.[CountryRegionDescription] = STG.[CountryRegionDescription]
				, DW.[CountryRegionDescriptionShort] = STG.[CountryRegionDescriptionShort]
				, DW.[StateProvinceDescription] = STG.[StateProvinceDescription]
				, DW.[StateProvinceDescriptionShort] = STG.[StateProvinceDescriptionShort]
				, DW.[City] = STG.[City]
				, DW.[PostalCode] = STG.[PostalCode]
				, DW.[ClientDateOfBirth] = STG.[ClientDateOfBirth]
				, DW.[GenderSSID] = STG.[GenderSSID]
				, DW.[ClientGenderDescription] = STG.[ClientGenderDescription]
				, DW.[ClientGenderDescriptionShort] = STG.[ClientGenderDescriptionShort]
				, DW.[MaritalStatusSSID] = STG.[MaritalStatusSSID]
				, DW.[ClientMaritalStatusDescription] = STG.[ClientMaritalStatusDescription]
				, DW.[ClientMaritalStatusDescriptionShort] = STG.[ClientMaritalStatusDescriptionShort]
				, DW.[OccupationSSID] = STG.[OccupationSSID]
				, DW.[ClientOccupationDescription] = STG.[ClientOccupationDescription]
				, DW.[ClientOccupationDescriptionShort] = STG.[ClientOccupationDescriptionShort]
				, DW.[EthinicitySSID] = STG.[EthinicitySSID]
				, DW.[ClientEthinicityDescription] = STG.[ClientEthinicityDescription]
				, DW.[ClientEthinicityDescriptionShort] = STG.[ClientEthinicityDescriptionShort]
				, DW.[DoNotCallFlag] = STG.[DoNotCallFlag]
				, DW.[DoNotContactFlag] = STG.[DoNotContactFlag]
				, DW.[IsHairModelFlag] = STG.[IsHairModelFlag]
				, DW.[IsTaxExemptFlag] = STG.[IsTaxExemptFlag]
				, DW.[ClientEMailAddress] = STG.[ClientEMailAddress]
				, DW.[ClientTextMessageAddress] = STG.[ClientTextMessageAddress]
				, DW.[ClientPhone1] = STG.[ClientPhone1]
				, DW.[Phone1TypeSSID] = STG.[Phone1TypeSSID]
				, DW.[ClientPhone1TypeDescription] = STG.[ClientPhone1TypeDescription]
				, DW.[ClientPhone1TypeDescriptionShort] = STG.[ClientPhone1TypeDescriptionShort]
				, DW.[ClientPhone2] = STG.[ClientPhone2]
				, DW.[Phone2TypeSSID] = STG.[Phone2TypeSSID]
				, DW.[ClientPhone2TypeDescription] = STG.[ClientPhone2TypeDescription]
				, DW.[ClientPhone2TypeDescriptionShort] = STG.[ClientPhone2TypeDescriptionShort]
				, DW.[ClientPhone3] = STG.[ClientPhone3]
				, DW.[Phone3TypeSSID] = STG.[Phone3TypeSSID]
				, DW.[ClientPhone3TypeDescription] = STG.[ClientPhone3TypeDescription]
				, DW.[ClientPhone3TypeDescriptionShort]	 = STG.[ClientPhone3TypeDescriptionShort]
				, DW.[CurrentBioMatrixClientMembershipSSID] = STG.[CurrentBioMatrixClientMembershipSSID]
				, DW.[CurrentSurgeryClientMembershipSSID] = STG.[CurrentSurgeryClientMembershipSSID]
				, DW.[CurrentExtremeTherapyClientMembershipSSID] = STG.[CurrentExtremeTherapyClientMembershipSSID]
				, DW.[CurrentXtrandsClientMembershipSSID] = STG.[CurrentXtrandsClientMembershipSSID]
				, DW.[CurrentMDPClientMembershipSSID] = STG.[CurrentMDPClientMembershipSSID]
				, DW.[ClientARBalance] = STG.[ClientARBalance]
				, DW.[ContactKey] = STG.[ContactKey]
				, DW.[BosleyConsultOffice] = STG.[BosleyConsultOffice]
				, DW.[BosleyProcedureOffice] = STG.[BosleyProcedureOffice]
				, DW.[BosleySiebelID] = STG.[BosleySiebelID]
				, DW.[ExpectedConversionDate] = STG.[ExpectedConversionDate]
				, DW.[ClientEmailAddressHashed] = STG.[ClientEmailAddressHashed]
				, DW.[SFDC_LeadID] = STG.[SFDC_LeadID]
				, DW.[RowChangeReason] = 'Updated Inferred Member'
				, DW.[RowIsInferred] = 0
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_cms_stage].[DimClient] STG
		JOIN [bi_cms_stage].[synHC_DDS_DimClient] DW ON
				DW.[ClientSSID] = STG.[ClientSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE	STG.[IsInferredMember] = 1
			AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @UpdateInferredRowCnt = @@ROWCOUNT


		------------------------
		-- SCD Type 1
		------------------------
		-- Just update the record
		UPDATE DW SET
				  DW.[ClientNumber_Temp] = STG.[ClientNumber_Temp]
				, DW.[ClientIdentifier] = STG.[ClientIdentifier]
				, DW.[CenterSSID] = STG.[CenterSSID]
				, DW.[ClientFirstName] = STG.[ClientFirstName]
				, DW.[ClientMiddleName] = STG.[ClientMiddleName]
				, DW.[ClientLastName] = STG.[ClientLastName]
				, DW.[SalutationSSID] = STG.[SalutationSSID]
				, DW.[ClientSalutationDescription] = STG.[ClientSalutationDescription]
				, DW.[ClientSalutationDescriptionShort] = STG.[ClientSalutationDescriptionShort]
				, DW.[ClientAddress1] = STG.[ClientAddress1]
				, DW.[ClientAddress2] = STG.[ClientAddress2]
				, DW.[ClientAddress3] = STG.[ClientAddress3]
				, DW.[CountryRegionDescription] = STG.[CountryRegionDescription]
				, DW.[CountryRegionDescriptionShort] = STG.[CountryRegionDescriptionShort]
				, DW.[StateProvinceDescription] = STG.[StateProvinceDescription]
				, DW.[StateProvinceDescriptionShort] = STG.[StateProvinceDescriptionShort]
				, DW.[City] = STG.[City]
				, DW.[PostalCode] = STG.[PostalCode]
				, DW.[ClientDateOfBirth] = STG.[ClientDateOfBirth]
				, DW.[GenderSSID] = STG.[GenderSSID]
				, DW.[ClientGenderDescription] = STG.[ClientGenderDescription]
				, DW.[ClientGenderDescriptionShort] = STG.[ClientGenderDescriptionShort]
				, DW.[MaritalStatusSSID] = STG.[MaritalStatusSSID]
				, DW.[ClientMaritalStatusDescription] = STG.[ClientMaritalStatusDescription]
				, DW.[ClientMaritalStatusDescriptionShort] = STG.[ClientMaritalStatusDescriptionShort]
				, DW.[OccupationSSID] = STG.[OccupationSSID]
				, DW.[ClientOccupationDescription] = STG.[ClientOccupationDescription]
				, DW.[ClientOccupationDescriptionShort] = STG.[ClientOccupationDescriptionShort]
				, DW.[EthinicitySSID] = STG.[EthinicitySSID]
				, DW.[ClientEthinicityDescription] = STG.[ClientEthinicityDescription]
				, DW.[ClientEthinicityDescriptionShort] = STG.[ClientEthinicityDescriptionShort]
				, DW.[DoNotCallFlag] = STG.[DoNotCallFlag]
				, DW.[DoNotContactFlag] = STG.[DoNotContactFlag]
				, DW.[IsHairModelFlag] = STG.[IsHairModelFlag]
				, DW.[IsTaxExemptFlag] = STG.[IsTaxExemptFlag]
				, DW.[ClientEMailAddress] = STG.[ClientEMailAddress]
				, DW.[ClientTextMessageAddress] = STG.[ClientTextMessageAddress]
				, DW.[ClientPhone1] = STG.[ClientPhone1]
				, DW.[Phone1TypeSSID] = STG.[Phone1TypeSSID]
				, DW.[ClientPhone1TypeDescription] = STG.[ClientPhone1TypeDescription]
				, DW.[ClientPhone1TypeDescriptionShort] = STG.[ClientPhone1TypeDescriptionShort]
				, DW.[ClientPhone2] = STG.[ClientPhone2]
				, DW.[Phone2TypeSSID] = STG.[Phone2TypeSSID]
				, DW.[ClientPhone2TypeDescription] = STG.[ClientPhone2TypeDescription]
				, DW.[ClientPhone2TypeDescriptionShort] = STG.[ClientPhone2TypeDescriptionShort]
				, DW.[ClientPhone3] = STG.[ClientPhone3]
				, DW.[Phone3TypeSSID] = STG.[Phone3TypeSSID]
				, DW.[ClientPhone3TypeDescription] = STG.[ClientPhone3TypeDescription]
				, DW.[ClientPhone3TypeDescriptionShort]	 = STG.[ClientPhone3TypeDescriptionShort]
				, DW.[CurrentBioMatrixClientMembershipSSID] = STG.[CurrentBioMatrixClientMembershipSSID]
				, DW.[CurrentSurgeryClientMembershipSSID] = STG.[CurrentSurgeryClientMembershipSSID]
				, DW.[CurrentExtremeTherapyClientMembershipSSID] = STG.[CurrentExtremeTherapyClientMembershipSSID]
				, DW.[CurrentXtrandsClientMembershipSSID] = STG.[CurrentXtrandsClientMembershipSSID]
				, DW.[CurrentMDPClientMembershipSSID] = STG.[CurrentMDPClientMembershipSSID]
				, DW.[ClientARBalance] = STG.[ClientARBalance]
				, DW.[ContactKey] = STG.[ContactKey]
				, DW.[BosleyConsultOffice] = STG.[BosleyConsultOffice]
				, DW.[BosleyProcedureOffice] = STG.[BosleyProcedureOffice]
				, DW.[BosleySiebelID] = STG.[BosleySiebelID]
				, DW.[ExpectedConversionDate] = STG.[ExpectedConversionDate]
				, DW.[ClientEmailAddressHashed] = STG.[ClientEmailAddressHashed]
				, DW.[SFDC_LeadID] = STG.[SFDC_LeadID]
				, DW.[RowChangeReason] = 'SCD Type 1'
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_cms_stage].[DimClient] STG
		JOIN [bi_cms_stage].[synHC_DDS_DimClient] DW ON
				DW.[ClientSSID] = STG.[ClientSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE	STG.[IsType1] = 1
			AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @UpdateSCD1RowCnt = @@ROWCOUNT



		------------------------
		-- SCD Type 2
		------------------------
		-- First Expire the current row
		UPDATE DW SET
				  DW.[RowIsCurrent] = 0
				, DW.[RowEndDate] = DATEADD(minute, -1, STG.[ModifiedDate])
		FROM [bi_cms_stage].[DimClient] STG
		JOIN [bi_cms_stage].[synHC_DDS_DimClient] DW ON
				DW.[ClientKey] = STG.[ClientKey]
			AND DW.[RowIsCurrent] = 1
		WHERE	STG.[IsType2] = 1
			AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @UpdateSCD2RowCnt = @@ROWCOUNT

		--Next insert the record with the current values
		INSERT INTO [bi_cms_stage].[synHC_DDS_DimClient] (
					  [ClientSSID]
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
					, [ContactKey]
					, [BosleyConsultOffice]
					, [BosleyProcedureOffice]
					, [BosleySiebelID]
					, [ExpectedConversionDate]
					, [ClientEmailAddressHashed]
					, [SFDC_LeadID]
					, [RowIsCurrent]
					, [RowStartDate]
					, [RowEndDate]
					, [RowChangeReason]
					, [RowIsInferred]
					, [InsertAuditKey]
					, [UpdateAuditKey]
					)
			SELECT
				  STG.[ClientSSID]
				, STG.[ClientNumber_Temp]
				, STG.[ClientIdentifier]
				, STG.[CenterSSID]
				, STG.[ClientFirstName]
				, STG.[ClientMiddleName]
				, STG.[ClientLastName]
				, STG.[SalutationSSID]
				, STG.[ClientSalutationDescription]
				, STG.[ClientSalutationDescriptionShort]
				, STG.[ClientAddress1]
				, STG.[ClientAddress2]
				, STG.[ClientAddress3]
				, STG.[CountryRegionDescription]
				, STG.[CountryRegionDescriptionShort]
				, STG.[StateProvinceDescription]
				, STG.[StateProvinceDescriptionShort]
				, STG.[City]
				, STG.[PostalCode]
				, STG.[ClientDateOfBirth]
				, STG.[GenderSSID]
				, STG.[ClientGenderDescription]
				, STG.[ClientGenderDescriptionShort]
				, STG.[MaritalStatusSSID]
				, STG.[ClientMaritalStatusDescription]
				, STG.[ClientMaritalStatusDescriptionShort]
				, STG.[OccupationSSID]
				, STG.[ClientOccupationDescription]
				, STG.[ClientOccupationDescriptionShort]
				, STG.[EthinicitySSID]
				, STG.[ClientEthinicityDescription]
				, STG.[ClientEthinicityDescriptionShort]
				, STG.[DoNotCallFlag]
				, STG.[DoNotContactFlag]
				, STG.[IsHairModelFlag]
				, STG.[IsTaxExemptFlag]
				, STG.[ClientEMailAddress]
				, STG.[ClientTextMessageAddress]
				, STG.[ClientPhone1]
				, STG.[Phone1TypeSSID]
				, STG.[ClientPhone1TypeDescription]
				, STG.[ClientPhone1TypeDescriptionShort]
				, STG.[ClientPhone2]
				, STG.[Phone2TypeSSID]
				, STG.[ClientPhone2TypeDescription]
				, STG.[ClientPhone2TypeDescriptionShort]
				, STG.[ClientPhone3]
				, STG.[Phone3TypeSSID]
				, STG.[ClientPhone3TypeDescription]
				, STG.[ClientPhone3TypeDescriptionShort]
				, STG.[CurrentBioMatrixClientMembershipSSID]
				, STG.[CurrentSurgeryClientMembershipSSID]
				, STG.[CurrentExtremeTherapyClientMembershipSSID]
				, STG.[CurrentXtrandsClientMembershipSSID]
				, STG.CurrentMDPClientMembershipSSID
				, STG.[ClientARBalance]
				, STG.[ContactKey]
				, STG.[BosleyConsultOffice]
				, STG.[BosleyProcedureOffice]
				, STG.[BosleySiebelID]
				, STG.[ExpectedConversionDate]
				, STG.[ClientEmailAddressHashed]
				, STG.[SFDC_LeadID]
				, 1 -- [RowIsCurrent]
				, STG.[ModifiedDate] -- [RowStartDate]
				, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
				, 'SCD Type 2' -- [RowChangeReason]
				, 0
				, @DataPkgKey
				, -2 -- 'Not Updated Yet'
			FROM [bi_cms_stage].[DimClient] STG
			WHERE	STG.[IsType2] = 1
				AND	STG.[IsException] = 0
				AND STG.[DataPkgKey] = @DataPkgKey


		SET @InsertSCD2RowCnt = @@ROWCOUNT


		-- Determine the number of exception rows
		SELECT @ExceptionRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimClient] STG
		WHERE STG.[IsException] = 1
			AND STG.[DataPkgKey] = @DataPkgKey

		-- Determine the number of inserted and updated rows
		SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt

		-- Determine the number of ignored rows
		SELECT @IgnoreRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimClient] STG
		WHERE STG.[IsException] = 0
		AND STG.[IsNew] = 0
		AND STG.[IsType1] = 0
		AND STG.[IsType2] = 0
		OR STG.[IsDuplicate] = 1
		AND STG.[DataPkgKey] = @DataPkgKey


		-- Determine Final Row Cnt
		SELECT @FinalRowCnt = COUNT(1) FROM [bi_cms_stage].[synHC_DDS_DimClient]

		-- Determine the number of Fixed rows
		SELECT @FixedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimClient] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsFixed] = 1

		-- Determine the number of Allowed rows
		SELECT @AllowedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimClient] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsAllowed] = 1

		-- Determine the number of Rejected rows
		SELECT @RejectedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimClient] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 1

		-- Determine the number of Healthy rows
		SELECT @HealthyRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimClient] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 0
		AND STG.[IsAllowed] = 0
		AND STG.[IsFixed] = 0

		-- Determine the number of Duplicate rows
		SELECT @DuplicateRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimClient] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDuplicate] = 1

		-- Determine the number of Deleted rows
		SELECT @DeletedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimClient] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDelete] = 1


		-----------------------
		-- Flag records as validated
		-----------------------
		UPDATE STG SET
			IsLoaded = 1
		FROM [bi_cms_stage].[DimClient] STG
		WHERE DataPkgKey = @DataPkgKey

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_LoadStop] @DataPkgKey, @TableName
					, @IgnoreRowCnt, @InsertRowCnt, @UpdateRowCnt, @ExceptionRowCnt, @ExtractRowCnt
					, @InsertNewRowCnt, @InsertInferredRowCnt, @InsertSCD2RowCnt
					, @UpdateInferredRowCnt, @UpdateSCD1RowCnt, @UpdateSCD2RowCnt
					, @InitialRowCnt, @FinalRowCnt
					, @DeletedRowCnt, @DuplicateRowCnt, @HealthyRowCnt
					, @RejectedRowCnt, @AllowedRowCnt, @FixedRowCnt
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
