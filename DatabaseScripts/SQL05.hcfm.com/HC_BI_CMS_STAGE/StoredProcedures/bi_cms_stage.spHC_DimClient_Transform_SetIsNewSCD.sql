/* CreateDate: 05/03/2010 12:19:56.800 , ModifyDate: 05/18/2020 09:55:22.433 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimClient_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimClient_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_cms_stage].[spHC_DimClient_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    03/16/2009  RLifke       Initial Creation
--  v1.1	06/24/2011  KMurdoch	 Added CenterID and Default Client membershipGUIDS
--       	08/09/2011  EKnapp  	 Added Contact info
--			04/08/2015  KMurdoch	 Added BosleyConsultOffice, BosleyProcedureOffice,
--									 BosleySiebelID, ExpectConversionDate
--			10/04/2018	KMurdoch	 Added SFDC_LeadID
--			08/19/2019  RHut		 Added CurrentMDPClientMembershipSSID
--			05/18/2020  KMurdoch     Added ClientEmailAddressHashed
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

 	SET @TableName = N'[bi_cms_dds].[DimClient]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [ClientKey] = DW.[ClientKey]
			,IsNew = CASE WHEN DW.[ClientKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimClient] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimClient] DW ON
				DW.[ClientSSID] = STG.[ClientSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[ClientKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimClient] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimClient] DW ON
				 STG.[ClientSSID] = DW.[ClientSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[ClientKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimClient] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimClient] DW ON
				 STG.[ClientSSID] = DW.[ClientSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.[ClientNumber_Temp],0) <> COALESCE(DW.[ClientNumber_Temp],0)
				OR COALESCE(STG.[ClientIdentifier],0) <> COALESCE(DW.[ClientIdentifier],0)
				OR COALESCE(STG.[ClientFirstName],'') <> COALESCE(DW.[ClientFirstName],'')
				OR COALESCE(STG.[ClientMiddleName],'') <> COALESCE(DW.[ClientMiddleName],'')
				OR COALESCE(STG.[ClientLastName],'') <> COALESCE(DW.[ClientLastName],'')
				OR COALESCE(STG.[SalutationSSID],'') <> COALESCE(DW.[SalutationSSID],'')
				OR COALESCE(STG.[ClientSalutationDescription],'') <> COALESCE(DW.[ClientSalutationDescription],'')
				OR COALESCE(STG.[ClientSalutationDescriptionShort],'') <> COALESCE(DW.[ClientSalutationDescriptionShort],'')
				OR COALESCE(STG.[ClientAddress1],'') <> COALESCE(DW.[ClientAddress1],'')
				OR COALESCE(STG.[ClientAddress2],'') <> COALESCE(DW.[ClientAddress2],'')
				OR COALESCE(STG.[ClientAddress3],'') <> COALESCE(DW.[ClientAddress3],'')
				OR COALESCE(STG.[CountryRegionDescription],'') <> COALESCE(DW.[CountryRegionDescription],'')
				OR COALESCE(STG.[CountryRegionDescriptionShort],'') <> COALESCE(DW.[CountryRegionDescriptionShort],'')
				OR COALESCE(STG.[StateProvinceDescription],'') <> COALESCE(DW.[StateProvinceDescription],'')
				OR COALESCE(STG.[StateProvinceDescriptionShort],'') <> COALESCE(DW.[StateProvinceDescriptionShort],'')
				OR COALESCE(STG.[City],'') <> COALESCE(DW.[City],'')
				OR COALESCE(STG.[ContactKey],-1) <> COALESCE(DW.[ContactKey],-1)

				OR COALESCE(STG.[PostalCode],'') <> COALESCE(DW.[PostalCode],'')
				OR COALESCE(STG.[ClientDateOfBirth],'') <> COALESCE(DW.[ClientDateOfBirth],'')
				OR COALESCE(STG.[GenderSSID],'') <> COALESCE(DW.[GenderSSID],'')
				OR COALESCE(STG.[ClientGenderDescription],'') <> COALESCE(DW.[ClientGenderDescription],'')
				OR COALESCE(STG.[ClientGenderDescriptionShort],'') <> COALESCE(DW.[ClientGenderDescriptionShort],'')
				OR COALESCE(STG.[MaritalStatusSSID],'') <> COALESCE(DW.[MaritalStatusSSID],'')
				OR COALESCE(STG.[ClientMaritalStatusDescription],'') <> COALESCE(DW.[ClientMaritalStatusDescription],'')
				OR COALESCE(STG.[ClientMaritalStatusDescriptionShort],'') <> COALESCE(DW.[ClientMaritalStatusDescriptionShort],'')
				OR COALESCE(STG.[OccupationSSID],'') <> COALESCE(DW.[OccupationSSID],'')
				OR COALESCE(STG.[ClientOccupationDescription],'') <> COALESCE(DW.[ClientOccupationDescription],'')
				OR COALESCE(STG.[ClientOccupationDescriptionShort],'') <> COALESCE(DW.[ClientOccupationDescriptionShort],'')
				OR COALESCE(STG.[EthinicitySSID],'') <> COALESCE(DW.[EthinicitySSID],'')
				OR COALESCE(STG.[ClientEthinicityDescription],'') <> COALESCE(DW.[ClientEthinicityDescription],'')
				OR COALESCE(STG.[ClientEthinicityDescriptionShort],'') <> COALESCE(DW.[ClientEthinicityDescriptionShort],'')

				OR COALESCE(STG.[DoNotCallFlag],'') <> COALESCE(DW.[DoNotCallFlag],'')
				OR COALESCE(STG.[DoNotContactFlag],'') <> COALESCE(DW.[DoNotContactFlag],'')
				OR COALESCE(STG.[IsHairModelFlag],'') <> COALESCE(DW.[IsHairModelFlag],'')
				OR COALESCE(STG.[IsTaxExemptFlag],'') <> COALESCE(DW.[IsTaxExemptFlag],'')
				OR COALESCE(STG.[ClientEMailAddress],'') <> COALESCE(DW.[ClientEMailAddress],'')
				OR COALESCE(STG.[ClientTextMessageAddress],'') <> COALESCE(DW.[ClientTextMessageAddress],'')
				OR COALESCE(STG.[ClientDateOfBirth],'') <> COALESCE(DW.[ClientDateOfBirth],'')

				OR COALESCE(STG.[ClientPhone1],'') <> COALESCE(DW.[ClientPhone1],'')
				OR COALESCE(STG.[ClientPhone1TypeDescription],'') <> COALESCE(DW.[ClientPhone1TypeDescription],'')
				OR COALESCE(STG.[ClientPhone1TypeDescriptionShort],'') <> COALESCE(DW.[ClientPhone1TypeDescriptionShort],'')
				OR COALESCE(STG.[ClientPhone2],'') <> COALESCE(DW.[ClientPhone2],'')
				OR COALESCE(STG.[ClientPhone2TypeDescription],'') <> COALESCE(DW.[ClientPhone2TypeDescription],'')
				OR COALESCE(STG.[ClientPhone2TypeDescriptionShort],'') <> COALESCE(DW.[ClientPhone2TypeDescriptionShort],'')
				OR COALESCE(STG.[ClientPhone3],'') <> COALESCE(DW.[ClientPhone3],'')
				OR COALESCE(STG.[ClientPhone3TypeDescription],'') <> COALESCE(DW.[ClientPhone3TypeDescription],'')
				OR COALESCE(STG.[ClientPhone3TypeDescriptionShort],'') <> COALESCE(DW.[ClientPhone3TypeDescriptionShort],'')
				OR COALESCE(STG.[CenterSSID],0) <> COALESCE(DW.[CenterSSID],0)
				OR COALESCE(STG.[CurrentBioMatrixClientMembershipSSID],CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) <> COALESCE(DW.[CurrentBioMatrixClientMembershipSSID],CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002'))
				OR COALESCE(STG.[CurrentSurgeryClientMembershipSSID],CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) <> COALESCE(DW.[CurrentSurgeryClientMembershipSSID],CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002'))
				OR COALESCE(STG.[CurrentExtremeTherapyClientMembershipSSID],CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) <> COALESCE(DW.[CurrentExtremeTherapyClientMembershipSSID],CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002'))
				OR COALESCE(STG.[CurrentXtrandsClientMembershipSSID],CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) <> COALESCE(DW.[CurrentXtrandsClientMembershipSSID],CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002'))
				OR COALESCE(STG.[CurrentMDPClientMembershipSSID],CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) <> COALESCE(DW.[CurrentMDPClientMembershipSSID],CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002'))

				OR COALESCE(STG.[ClientARBalance],0) <> COALESCE(DW.[ClientARBalance],0)
				OR COALESCE(STG.[BosleySiebelID],'') <> COALESCE(DW.[BosleySiebelID],'')
				OR COALESCE(STG.[BosleyProcedureOffice],'') <> COALESCE(DW.[BosleyProcedureOffice],'')
				OR COALESCE(STG.[BosleyConsultOffice],'') <> COALESCE(DW.[BosleyConsultOffice],'')
				OR COALESCE(STG.[ExpectedConversionDate],'') <> COALESCE(DW.[ExpectedConversionDate],'')
				OR COALESCE(STG.[SFDC_LeadID],'') <> COALESCE(DW.[SFDC_LeadID],'')
				OR COALESCE(STG.[ClientEmailAddressHashed],'') <> COALESCE(DW.[ClientEmailAddressHashed],'')

				)
		AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[ClientKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimClient] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimClient] DW ON
				 STG.[ClientSSID] = DW.[ClientSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  ClientSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY ClientSSID ORDER BY ClientSSID ) AS RowNum
			   FROM  [bi_cms_stage].[DimClient] STG
			   WHERE IsNew = 1
			   AND STG.[DataPkgKey] = @DataPkgKey

			)

			UPDATE STG SET
				IsDuplicate = 1
			FROM Duplicates STG
			WHERE   RowNum > 1


		-----------------------
		-- Check for deleted rows
		-----------------------
		UPDATE STG SET
				IsDelete = CASE WHEN COALESCE(STG.[CDC_Operation],'') = 'D'
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimClient] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey


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
