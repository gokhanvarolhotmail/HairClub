/* CreateDate: 05/03/2010 12:09:49.097 , ModifyDate: 05/06/2019 11:02:30.957 */
GO
CREATE procedure [bi_ent_stage].[spHC_DimCenter_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimCenter_Extract] is used to retrieve a
-- list Business Unit Brands
--
--   exec [bi_ent_stage].[spHC_DimCenter_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    03/12/2009  RLifke       Initial Creation
--			03/19/2012  KMurdoch     Added CenterReportingSSID
--			03/26/2013  KMurdoch	 Added HasFullAccessFlag
--			05/29/2013  KMurdoch	 Added CenterBusinessTypeID
--			08/26/2013  KMurdoch	 Added Regional Employee Roll-ups
--			07/23/2015  KMurdoch	 Added Regional Operations Manager
--          12/29/2016  DLeiba		 Added CenterManagementAreaSSID
--          02/28/2016  RHut		 Added NewBusinessSize, RecurringBusinessSize, CenterNumber
--			05/01/2019	DLeiba		 Removed date criteria
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

 	SET @TableName = N'[bi_ent_dds].[DimCenter]'


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


				INSERT INTO [bi_ent_stage].[DimCenter]
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
						   , [CenterBusinessTypeID]
						   , [RegionRSMNBConsultantSSID]
						   , [RegionRSMMembershipAdvisorSSID]
						   , [RegionRTMTechnicalManagerSSID]
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
						   , [IsDelete]
						   , [IsDuplicate]
						   , [SourceSystemKey]
						   , [HasFullAccessFlag]
							)
				SELECT @DataPkgKey
						, NULL AS [CenterKey]
						, COALESCE(co.[CenterID], -2) AS [CenterSSID]
						, NULL AS [RegionKey]
						, COALESCE([RegionID], -2) AS [RegionSSID]
						, NULL AS [TimeZoneKey]
						,COALESCE( [TimeZoneID], -2) AS [TimeZoneSSID]
						, NULL AS [CenterTypeKey]
						,COALESCE( [CenterTypeID], -2) AS [CenterTypeSSID]
						, NULL AS [DoctorRegionKey]
						, COALESCE([DoctorRegionID], -2) AS [DoctorRegionSSID]
						, NULL AS [CenterOwnershipKey]
						, COALESCE([CenterOwnershipID], -2) AS [CenterOwnershipSSID]
						, CAST(ISNULL(LTRIM(RTRIM([CenterDescription])),'') AS nvarchar(50)) AS [CenterDescription]
						, CAST(ISNULL(LTRIM(RTRIM([Address1])),'') AS nvarchar(50)) AS [CenterAddress1]
						, CAST(ISNULL(LTRIM(RTRIM([Address2])),'') AS nvarchar(50)) AS [CenterAddress2]
						, CAST(ISNULL(LTRIM(RTRIM([Address3])),'') AS nvarchar(50)) AS [CenterAddress3]
						, CAST(ISNULL(LTRIM(RTRIM(cn.[CountryDescription])),'') AS nvarchar(50)) AS [CountryRegionDescription]
						, CAST(ISNULL(LTRIM(RTRIM(cn.[CountryDescriptionShort])),'') AS nvarchar(10)) AS [CountryRegionDescriptionShort]
						, CAST(ISNULL(LTRIM(RTRIM(st.[StateDescription])),'') AS nvarchar(50)) AS [StateProvinceDescription]
						, CAST(ISNULL(LTRIM(RTRIM(st.[StateDescriptionShort])),'') AS nvarchar(10)) AS [StateProvinceDescriptionShort]
						, CAST(ISNULL(LTRIM(RTRIM([City])),'') AS nvarchar(50)) AS [City]
						, CAST(ISNULL(LTRIM(RTRIM([PostalCode])),'') AS nvarchar(15)) AS [PostalCode]
						, CAST(ISNULL(LTRIM(RTRIM([Phone1])),'') AS nvarchar(15)) AS [CenterPhone1]
						, COALESCE([Phone1TypeID], -2) AS [Phone1TypeSSID]
						, CAST(ISNULL(LTRIM(RTRIM(pht1.[PhoneTypeDescription])),'') AS nvarchar(50)) AS [CenterPhone1TypeDescription]
						, CAST(ISNULL(LTRIM(RTRIM(pht1.[PhoneTypeDescriptionShort])),'') AS nvarchar(10)) AS [CenterPhone1TypeDescriptionShort]
						, CAST(ISNULL(LTRIM(RTRIM([Phone2])),'') AS nvarchar(15)) AS [CenterPhone2]
						, COALESCE([Phone2TypeID], -2) AS [Phone2TypeSSID]
						, CAST(ISNULL(LTRIM(RTRIM(pht2.[PhoneTypeDescription])),'') AS nvarchar(50)) AS [CenterPhone2TypeDescription]
						, CAST(ISNULL(LTRIM(RTRIM(pht2.[PhoneTypeDescriptionShort])),'') AS nvarchar(10)) AS [CenterPhone2TypeDescriptionShort]
						, CAST(ISNULL(LTRIM(RTRIM([Phone3])),'') AS nvarchar(15)) AS [CenterPhone3]
						, COALESCE([Phone3TypeID], -2) AS [Phone3TypeSSID]
						, CAST(ISNULL(LTRIM(RTRIM(pht3.[PhoneTypeDescription])),'') AS nvarchar(50)) AS [CenterPhone3TypeDescription]
						, CAST(ISNULL(LTRIM(RTRIM(pht3.[PhoneTypeDescriptionShort])),'') AS nvarchar(10)) AS [CenterPhone3TypeDescriptionShort]
						, COALESCE(co.[ReportingCenterID], co.CenterID) AS [ReportingCenterSSID]
						, cc.[CenterBusinessTypeID]
						, COALESCE([RegionRSMNBConsultantGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [RegionRSMNBConsultantSSID]
						, COALESCE([RegionRSMMembershipAdvisorGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [RegionRSMMembershipAdvisorSSID]
						, COALESCE([RegionRTMTechnicalManagerGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [RegionRTMTechnicalManagerSSID]
						, COALESCE([CenterManagementAreaID], -2) AS [CenterManagementAreaSSID]
						, CASE WHEN cc.NewBusinessSizeID = 3 THEN 'Large'
							WHEN  cc.NewBusinessSizeID = 2 THEN 'Medium'
							WHEN cc.NewBusinessSizeID = 1 THEN 'Small'
							ELSE 'Unknown'
							END AS [NewBusinessSize]
						, CASE WHEN cc.RecurringBusinessSizeID = 3 THEN 'Large'
							WHEN cc.RecurringBusinessSizeID = 2 THEN 'Medium'
							WHEN cc.RecurringBusinessSizeID = 1 THEN 'Small'
							ELSE 'Unknown'
							END AS [RecurringBusinessSize]
						, COALESCE([CenterNumber], -2) AS [CenterNumber]
						, case  when ISNULL(co.IsActiveFlag,0) = 1 then 'Y' else 'N' END
						, co.[LastUpdate] AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, CAST(ISNULL(LTRIM(RTRIM(co.[CenterID])),'') AS nvarchar(50)) AS [SourceSystemKey]
						, ISNULL(HasFullAccess,0) AS [HasFullAccessFlag]
				FROM [bi_ent_stage].[synHC_SRC_TBL_CMS_cfgCenter] co
					Left Outer JOIN [bi_ent_stage].[synHC_SRC_TBL_CMS_lkpState] st
							ON co.[StateID] = st.[StateID]
					Left Outer JOIN [bi_ent_stage].[synHC_SRC_TBL_CMS_lkpCountry] cn
							ON co.[CountryID] = cn.[CountryID]
					Left Outer JOIN [bi_ent_stage].[synHC_SRC_TBL_CMS_lkpPhoneType] pht1
							ON co.[Phone1TypeID] = pht1.[PhoneTypeID]
					Left Outer JOIN [bi_ent_stage].[synHC_SRC_TBL_CMS_lkpPhoneType] pht2
							ON co.[Phone2TypeID] = pht2.[PhoneTypeID]
					Left Outer JOIN [bi_ent_stage].[synHC_SRC_TBL_CMS_lkpPhoneType] pht3
							ON co.[Phone3TypeID] = pht3.[PhoneTypeID]
					Left Outer JOIN HairClubCMS.dbo.cfgConfigurationCenter cc
							on co.CenterID = cc.CenterID

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
