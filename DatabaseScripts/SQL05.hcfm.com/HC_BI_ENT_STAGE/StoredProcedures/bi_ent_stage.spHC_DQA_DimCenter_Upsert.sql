/* CreateDate: 05/03/2010 12:10:02.523 , ModifyDate: 02/28/2017 16:08:02.277 */
GO
CREATE procedure [bi_ent_stage].[spHC_DQA_DimCenter_Upsert]
			  @DataPkgKey				int
			, @RuleKey				int				-- Rule to Validate
			, @RuleActionKey		int				-- Key to RuleAction table
			, @RuleActionName		varchar(30)		-- Rule Action Name  (Allow,Fix,Reject)
			, @TableKey				int				-- Key to DQA table
			, @TableName			varchar(100)	-- Name of DQA table
			, @ViolationStatusKey	int				-- Key to Violation Status table


AS
-------------------------------------------------------------------------
-- [spHC_DQA_DimCenter_Upsert]  loads data to Data Quality
-- table
--
--
--   exec [bi_ent_stage].[spHC_DQA_DimCenter_Upsert]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/06/2010  RLifke       Initial Creation
--			03/19/2012  KMurdoch     Added Reporting Center SSID
--			03/26/2013  KMurdoch     Added HasFullAccessFlag
--			05/29/2013  KMurdoch     Added CenterBusinessTypeID
--			08/26/2013  KMurdoch	 Added Regional Employee Roll-ups
--          07/23/2015  KMurdoch     Added Regional Operations Manager
--          12/29/2016  DLeiba		 Added CenterManagementAreaSSID
--          02/28/2016  RHut		 Added NewBusinessSize, RecurringBusinessSize, CenterNumber
-------------------------------------------------------------------------
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
		FROM [bi_ent_stage].[DimCenter] STG
		LEFT OUTER JOIN [bi_ent_stage].[synHC_DQA_DimCenter] DQA ON
				DQA.[CenterSSID] = STG.[CenterSSID]
				AND DQA.DataPkgKey = STG.DataPkgKey
		WHERE STG.DataPkgKey = @DataPkgKey

		-----------------------
		-- Put new rows into DQA
		-----------------------
		INSERT INTO [bi_ent_stage].[synHC_DQA_DimCenter]
					( [DataPkgKey]
					, [CenterKey]
					, [CenterSSID]
					, [RegionKey]
					, [RegionSSID]
					, [TimeZoneKey]
					, [TimeZoneSSID]
					, [CenterTypeKey]
					, [CenterTypeSSID]
					, [DoctorRegionKey]
					, [DoctorRegionSSID]
					, [CenterOwnershipKey]
					, [CenterOwnershipSSID]
					, [CenterDescription]
					, [CenterAddress1]
					, [CenterAddress2]
					, [CenterAddress3]
					, [CountryRegionDescription]
					, [CountryRegionDescriptionShort]
					, [StateProvinceDescription]
					, [StateProvinceDescriptionShort]
					, [City]
					, [PostalCode]
					, [CenterPhone1]
					, [Phone1TypeSSID]
					, [CenterPhone1TypeDescription]
					, [CenterPhone1TypeDescriptionShort]
					, [CenterPhone2]
					, [Phone2TypeSSID]
					, [CenterPhone2TypeDescription]
					, [CenterPhone2TypeDescriptionShort]
					, [CenterPhone3]
					, [Phone3TypeSSID]
					, [CenterPhone3TypeDescription]
					, [CenterPhone3TypeDescriptionShort]
					, [ReportingCenterSSID]
					, [HasFullAccessFlag]
					, [CenterBusinessTypeID]
					, [RegionRSMNBConsultantSSID]
					, [RegionRSMMembershipAdvisorSSID]
					, [RegionRTMTechnicalManagerSSID]
					, [RegionROMOperationsManagerSSID]
					, [CenterManagementAreaSSID]
					, [NewBusinessSize]
					, [RecurringBusinessSize]
					, [CenterNumber]

					, [Active]
					, [ModifiedDate]
					, [IsNew]
					, [IsType1]
					, [IsType2]
					, [IsException]
					, [IsInferredMember]
					, [IsHealthy]
					, [IsRejected]
					, [IsAllowed]
					, [IsFixed]
					, [IsDelete]
					, [IsDuplicate]
					, [SourceSystemKey]
					)
			SELECT
					  [DataPkgKey]
					, [CenterKey]
					, [CenterSSID]
					, [RegionKey]
					, [RegionSSID]
					, [TimeZoneKey]
					, [TimeZoneSSID]
					, [CenterTypeKey]
					, [CenterTypeSSID]
					, [DoctorRegionKey]
					, [DoctorRegionSSID]
					, [CenterOwnershipKey]
					, [CenterOwnershipSSID]
					, [CenterDescription]
					, [CenterAddress1]
					, [CenterAddress2]
					, [CenterAddress3]
					, [CountryRegionDescription]
					, [CountryRegionDescriptionShort]
					, [StateProvinceDescription]
					, [StateProvinceDescriptionShort]
					, [City]
					, [PostalCode]
					, [CenterPhone1]
					, [Phone1TypeSSID]
					, [CenterPhone1TypeDescription]
					, [CenterPhone1TypeDescriptionShort]
					, [CenterPhone2]
					, [Phone2TypeSSID]
					, [CenterPhone2TypeDescription]
					, [CenterPhone2TypeDescriptionShort]
					, [CenterPhone3]
					, [Phone3TypeSSID]
					, [CenterPhone3TypeDescription]
					, [CenterPhone3TypeDescriptionShort]
					, [ReportingCenterSSID]
					, [HasFullAccessFlag]
					, [CenterBusinessTypeID]
					, [RegionRSMNBConsultantSSID]
					, [RegionRSMMembershipAdvisorSSID]
					, [RegionRTMTechnicalManagerSSID]
					, [RegionROMOperationsManagerSSID]
					, [CenterManagementAreaSSID]
					, [NewBusinessSize]
					, [RecurringBusinessSize]
					, [CenterNumber]
					, [Active]
					, [ModifiedDate]
					, [IsNew]
					, [IsType1]
					, [IsType2]
					, [IsException]
					, [IsInferredMember]
					, [IsHealthy]
					, [IsRejected]
					, [IsAllowed]
					, [IsFixed]
					, [IsDelete]
					, [IsDuplicate]
					, [SourceSystemKey]
			FROM	[bi_ent_stage].[DimCenter] STG
			WHERE	RuleKey = @RuleKey
				AND	STG.[IsNewDQA] = 1
				AND STG.DataPkgKey = @DataPkgKey

		-----------------------
		-- Update DataQualityAuditKey of rows added
		-----------------------
		UPDATE STG SET
		     [DataQualityAuditKey] = DQA.[DataQualityAuditKey]
		FROM [bi_ent_stage].[DimCenter] STG
		LEFT OUTER JOIN [bi_ent_stage].[synHC_DQA_DimCenter] DQA ON
				DQA.[CenterSSID] = STG.[CenterSSID]
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
			FROM	[bi_ent_stage].[DimCenter] STG
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
