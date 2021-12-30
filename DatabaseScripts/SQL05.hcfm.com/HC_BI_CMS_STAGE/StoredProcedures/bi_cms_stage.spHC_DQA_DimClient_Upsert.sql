/* CreateDate: 05/03/2010 12:20:19.043 , ModifyDate: 05/15/2020 08:33:24.643 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DQA_DimClient_Upsert]
			  @DataPkgKey				int
			, @RuleKey				int				-- Rule to Validate
			, @RuleActionKey		int				-- Key to RuleAction table
			, @RuleActionName		varchar(30)		-- Rule Action Name  (Allow,Fix,Reject)
			, @TableKey				int				-- Key to DQA table
			, @TableName			varchar(100)	-- Name of DQA table
			, @ViolationStatusKey	int				-- Key to Violation Status table


AS
-------------------------------------------------------------------------
-- [spHC_DQA_DimClient_Upsert]  loads data to Data Quality
-- table
--
--
--   exec [bi_cms_stage].[spHC_DQA_DimClient_Upsert]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/06/2010  RLifke       Initial Creation
--          08/09/2010  EKnapp		 Added Contact logic
--			04/08/2015  KMurdoch	 Added BosleyConsultOffice, BosleyProcedureOffice,
--									 BosleySiebelID, ExpectConversionDate
--			05/14/2020  KMurdoch     Added ClientEmailAddressHashed
------------------------------------------------------------------------
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DECLARE		  @intError			int				-- error code
				, @intDBErrorLogID	int				-- ID of error record logged
				, @intRowCount		int				-- count of rows modified
				, @vchTagValueList	nvarchar(1000)	-- Named Valued Pairs of Parameters

	BEGIN TRY

	   -- Put parameters in name value list to aid in reporting
		EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey
				, N'@RuleKey'
				, @RuleKey
				, N'@RuleActionKey'
				, @RuleActionKey
				, N'@RuleActionName'
				, @RuleActionName
				, N'@TableKey'
				, @TableKey
				, N'@TableName'
				, @TableName
				, N'@ViolationStatusKey'
				, @ViolationStatusKey


		-----------------------
		-- Check for new rows to put into DQA
		-----------------------
		UPDATE STG SET
		     [DataQualityAuditKey] = DQA.[DataQualityAuditKey]
			,IsNewDQA = CASE WHEN DQA.[DataQualityAuditKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimClient] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DQA_DimClient] DQA ON
				DQA.[ClientSSID] = STG.[ClientSSID]
				AND DQA.DataPkgKey = STG.DataPkgKey
		WHERE STG.DataPkgKey = @DataPkgKey

		-----------------------
		-- Put new rows into DQA
		-----------------------
		INSERT INTO [bi_cms_stage].[synHC_DQA_DimClient]
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
					, [ClientPhone1TypeDescription]
					, [ClientPhone1TypeDescriptionShort]
					, [ClientPhone2]
					, [ClientPhone2TypeDescription]
					, [ClientPhone2TypeDescriptionShort]
					, [ClientPhone3]
					, [ClientPhone3TypeDescription]
					, [ClientPhone3TypeDescriptionShort]
					, [CurrentBioMatrixClientMembershipSSID]
					, [CurrentSurgeryClientMembershipSSID]
					, [CurrentExtremeTherapyClientMembershipSSID]
					, [ClientARBalance]
					, [ContactKey]
					, [BosleyConsultOffice]
					, [BosleyProcedureOffice]
					, [BosleySiebelID]
					, [ExpectedConversionDate]
					, [ClientEmailAddressHashed]
					, [ModifiedDate]
					, [IsNew]
					, [IsType1]
					, [IsType2]
					, [IsDelete]
					, [IsDuplicate]
					, [IsInferredMember]
					, [IsException]
					, [IsHealthy]
					, [IsRejected]
					, [IsAllowed]
					, [IsFixed]
					, [SourceSystemKey]
					)
			SELECT
					  [DataPkgKey]
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
					, [ClientPhone1TypeDescription]
					, [ClientPhone1TypeDescriptionShort]
					, [ClientPhone2]
					, [ClientPhone2TypeDescription]
					, [ClientPhone2TypeDescriptionShort]
					, [ClientPhone3]
					, [ClientPhone3TypeDescription]
					, [ClientPhone3TypeDescriptionShort]
					, [CurrentBioMatrixClientMembershipSSID]
					, [CurrentSurgeryClientMembershipSSID]
					, [CurrentExtremeTherapyClientMembershipSSID]
					, [ClientARBalance]
					, [ContactKey]
					, [BosleyConsultOffice]
					, [BosleyProcedureOffice]
					, [BosleySiebelID]
					, [ExpectedConversionDate]
					, [ClientEmailAddressHashed]
					, [ModifiedDate]
					, [IsNew]
					, [IsType1]
					, [IsType2]
					, [IsDelete]
					, [IsDuplicate]
					, [IsInferredMember]
					, [IsException]
					, [IsHealthy]
					, [IsRejected]
					, [IsAllowed]
					, [IsFixed]
					, [SourceSystemKey]
			FROM	[bi_cms_stage].[DimClient] STG
			WHERE	RuleKey = @RuleKey
				AND	STG.[IsNewDQA] = 1
				AND STG.DataPkgKey = @DataPkgKey


		-----------------------
		-- Update DataQualityAuditKey of rows added
		-----------------------
		UPDATE STG SET
		     [DataQualityAuditKey] = DQA.[DataQualityAuditKey]
		FROM [bi_cms_stage].[DimClient] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DQA_DimClient] DQA ON
				DQA.[ClientSSID] = STG.[ClientSSID]
				AND DQA.DataPkgKey = STG.DataPkgKey
		WHERE STG.DataPkgKey = @DataPkgKey

		-----------------------
		-- Put Violations in Violation Header table
		-----------------------
		INSERT INTO [bief_stage].[syn_DQ_Violation]
					( [RuleKey]
					, [RuleActionKey]
					, [ViolationStatusKey]
					, [TableKey]
					, [SourceSystemKey]
					, [DataQualityAuditKey]
					, [CreateTimestamp]
					, [UpdateTimestamp]
					)
			SELECT
				      @RuleKey
					, @RuleActionKey
					, @ViolationStatusKey
					, @TableKey
					, STG.[SourceSystemKey]
					, STG.[DataQualityAuditKey]
					, GETDATE()
					, GETDATE()
			FROM	[bi_cms_stage].[DimClient] STG
			WHERE	STG.[RuleKey] = @RuleKey
				AND STG.DataPkgKey = @DataPkgKey


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
