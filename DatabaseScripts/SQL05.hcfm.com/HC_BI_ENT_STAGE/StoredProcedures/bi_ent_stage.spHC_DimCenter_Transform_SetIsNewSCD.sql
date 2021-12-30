/* CreateDate: 05/03/2010 12:09:51.320 , ModifyDate: 06/24/2020 09:30:37.523 */
GO
CREATE procedure [bi_ent_stage].[spHC_DimCenter_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimCenter_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_ent_stage].[spHC_DimCenter_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    03/16/2009  RLifke       Initial Creation
--			08/27/2013  KMurdoch	 Added Regional Employee Roll-ups
--          07/23/2015  KMurdoch     Added Regional Operations Manager
--          12/29/2016  DLeiba		 Added CenterManagementAreaSSID
--          02/28/2016  RHut		 Added NewBusinessSize, RecurringBusinessSize, CenterNumber
--			06/24/2020  KMurdoch     Fixed mistake in code
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

 	SET @TableName = N'[bi_ent_dds].[DimCenter]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [CenterKey] = DW.[CenterKey]
			,IsNew = CASE WHEN DW.[CenterKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_ent_stage].[DimCenter] STG
		LEFT OUTER JOIN [bi_ent_stage].[synHC_DDS_DimCenter] DW ON
				DW.[CenterSSID] = STG.[CenterSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[CenterKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_ent_stage].[DimCenter] STG
		INNER JOIN [bi_ent_stage].[synHC_DDS_DimCenter] DW ON
				 STG.[CenterSSID] = DW.[CenterSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[CenterKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_ent_stage].[DimCenter] STG
		INNER JOIN [bi_ent_stage].[synHC_DDS_DimCenter] DW ON
				 STG.[CenterSSID] = DW.[CenterSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.[CenterDescription],'') <> COALESCE(DW.[CenterDescription],'')
				OR COALESCE(STG.[RegionKey],'') <> COALESCE(DW.[RegionKey],'')
				OR COALESCE(STG.[RegionSSID],'') <> COALESCE(DW.[RegionSSID],'')
				OR COALESCE(STG.[TimeZoneKey],'') <> COALESCE(DW.[TimeZoneKey],'')
				OR COALESCE(STG.[TimeZoneSSID],'') <> COALESCE(DW.[TimeZoneSSID],'')
				OR COALESCE(STG.[CenterTypeKey],'') <> COALESCE(DW.[CenterTypeKey],'')
				OR COALESCE(STG.[CenterTypeSSID],'') <> COALESCE(DW.[CenterTypeSSID],'')
				OR COALESCE(STG.[DoctorRegionKey],'') <> COALESCE(DW.[DoctorRegionKey],'')
				OR COALESCE(STG.[DoctorRegionSSID],'') <> COALESCE(DW.[DoctorRegionSSID],'')
				OR COALESCE(STG.[CenterOwnershipKey],'') <> COALESCE(DW.[CenterOwnershipKey],'')
				OR COALESCE(STG.[DoctorRegionSSID],'') <> COALESCE(DW.[DoctorRegionSSID],'')
				OR COALESCE(STG.[CenterOwnershipSSID],'') <> COALESCE(DW.[CenterOwnershipSSID],'')
				OR COALESCE(STG.[CenterAddress1],'') <> COALESCE(DW.[CenterAddress1],'')
				OR COALESCE(STG.[CenterAddress2],'') <> COALESCE(DW.[CenterAddress2],'')
				OR COALESCE(STG.[CenterAddress3],'') <> COALESCE(DW.[CenterAddress3],'')
				OR COALESCE(STG.[CountryRegionDescription],'') <> COALESCE(DW.[CountryRegionDescription],'')
				OR COALESCE(STG.[CountryRegionDescriptionShort],'') <> COALESCE(DW.[CountryRegionDescriptionShort],'')
				OR COALESCE(STG.[StateProvinceDescription],'') <> COALESCE(DW.[StateProvinceDescription],'')
				OR COALESCE(STG.[StateProvinceDescriptionShort],'') <> COALESCE(DW.[StateProvinceDescriptionShort],'')
				OR COALESCE(STG.[City],'') <> COALESCE(DW.[City],'')
				OR COALESCE(STG.[PostalCode],'') <> COALESCE(DW.[PostalCode],'')
				OR COALESCE(STG.[CenterPhone1],'') <> COALESCE(DW.[CenterPhone1],'')
				OR COALESCE(STG.[CenterPhone1TypeDescription],'') <> COALESCE(DW.[CenterPhone1TypeDescription],'')
				OR COALESCE(STG.[CenterPhone1TypeDescriptionShort],'') <> COALESCE(DW.[CenterPhone1TypeDescriptionShort],'')
				OR COALESCE(STG.[CenterPhone2],'') <> COALESCE(DW.[CenterPhone2],'')
				OR COALESCE(STG.[CenterPhone2TypeDescription],'') <> COALESCE(DW.[CenterPhone2TypeDescription],'')
				OR COALESCE(STG.[CenterPhone2TypeDescriptionShort],'') <> COALESCE(DW.[CenterPhone2TypeDescriptionShort],'')
				OR COALESCE(STG.[CenterPhone3],'') <> COALESCE(DW.[CenterPhone3],'')
				OR COALESCE(STG.[CenterPhone3TypeDescription],'') <> COALESCE(DW.[CenterPhone3TypeDescription],'')
				OR COALESCE(STG.[CenterPhone3TypeDescriptionShort],'') <> COALESCE(DW.[CenterPhone3TypeDescriptionShort],'')
				OR COALESCE(STG.ReportingCenterSSID,'') <> COALESCE(DW.ReportingCenterSSID,'')
				OR COALESCE(STG.HasFullAccessFlag,'') <> COALESCE(DW.HasFullAccessFlag,'')
				OR COALESCE(STG.CenterBusinessTypeID,'') <> COALESCE(DW.CenterBusinessTypeID,'')
				OR COALESCE(STG.RegionRSMNBConsultantSSID,CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) <> COALESCE(DW.RegionRSMNBConsultantSSID,CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002'))
				OR COALESCE(STG.RegionRSMMembershipAdvisorSSID,CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) <> COALESCE(DW.RegionRSMMembershipAdvisorSSID,CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002'))
				OR COALESCE(STG.RegionRTMTechnicalManagerSSID,CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) <> COALESCE(DW.RegionRTMTechnicalManagerSSID,CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002'))
				OR COALESCE(STG.RegionROMOperationsManagerSSID,CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) <> COALESCE(DW.RegionROMOperationsManagerSSID,CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002'))
				OR COALESCE(STG.CenterManagementAreaSSID,'') <> COALESCE(DW.CenterManagementAreaSSID,'')

				OR COALESCE(STG.NewBusinessSize,'') <> COALESCE(DW.NewBusinessSize,'')
				OR COALESCE(STG.RecurringBusinessSize,'') <> COALESCE(DW.RecurringBusinessSize,'')
				OR COALESCE(STG.CenterNumber,'') <> COALESCE(DW.CenterNumber,'')

				OR COALESCE(STG.[Active],'N') <> COALESCE(DW.[Active],'N')
				)
		AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[CenterKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_ent_stage].[DimCenter] STG
		INNER JOIN [bi_ent_stage].[synHC_DDS_DimCenter] DW ON
				 STG.[CenterSSID] = DW.[CenterSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.[CenterDescription],'') <> COALESCE(DW.[CenterDescription],'')
				--OR COALESCE(STG.[RegionKey],'') <> COALESCE(DW.[RegionKey],'')
				--OR COALESCE(STG.[RegionSSID],'') <> COALESCE(DW.[RegionSSID],'')
				--OR COALESCE(STG.[TimeZoneKey],'') <> COALESCE(DW.[TimeZoneKey],'')
				--OR COALESCE(STG.[TimeZoneSSID],'') <> COALESCE(DW.[TimeZoneSSID],'')
				--OR COALESCE(STG.[CenterTypeKey],'') <> COALESCE(DW.[CenterTypeKey],'')
				--OR COALESCE(STG.[CenterTypeSSID],'') <> COALESCE(DW.[CenterTypeSSID],'')
				--OR COALESCE(STG.[DoctorRegionKey],'') <> COALESCE(DW.[DoctorRegionKey],'')
				--OR COALESCE(STG.[DoctorRegionSSID],'') <> COALESCE(DW.[DoctorRegionSSID],'')
				--OR COALESCE(STG.[CenterOwnershipKey],'') <> COALESCE(DW.[CenterOwnershipKey],'')
				--OR COALESCE(STG.[DoctorRegionSSID],'') <> COALESCE(DW.[DoctorRegionSSID],'')
				--OR COALESCE(STG.[CenterOwnershipSSID],'') <> COALESCE(DW.[CenterOwnershipSSID],'')
				--OR COALESCE(STG.[CenterAddress1],'') <> COALESCE(DW.[CenterAddress1],'')
				--OR COALESCE(STG.[CenterAddress2],'') <> COALESCE(DW.[CenterAddress2],'')
				--OR COALESCE(STG.[CenterAddress3],'') <> COALESCE(DW.[CenterAddress3],'')
				--OR COALESCE(STG.[CountryRegionDescription],'') <> COALESCE(DW.[CountryRegionDescription],'')
				--OR COALESCE(STG.[CountryRegionDescriptionShort],'') <> COALESCE(DW.[CountryRegionDescriptionShort],'')
				--OR COALESCE(STG.[StateProvinceDescription],'') <> COALESCE(DW.[StateProvinceDescription],'')
				--OR COALESCE(STG.[StateProvinceDescriptionShort],'') <> COALESCE(DW.[StateProvinceDescriptionShort],'')
				--OR COALESCE(STG.[City],'') <> COALESCE(DW.[City],'')
				--OR COALESCE(STG.[PostalCode],'') <> COALESCE(DW.[PostalCode],'')
				--OR COALESCE(STG.[CenterPhone1],'') <> COALESCE(DW.[CenterPhone1],'')
				--OR COALESCE(STG.[CenterPhone1TypeDescription],'') <> COALESCE(DW.[CenterPhone1TypeDescription],'')
				--OR COALESCE(STG.[CenterPhone1TypeDescriptionShort],'') <> COALESCE(DW.[CenterPhone1TypeDescriptionShort],'')
				--OR COALESCE(STG.[CenterPhone2],'') <> COALESCE(DW.[CenterPhone2],'')
				--OR COALESCE(STG.[CenterPhone2TypeDescription],'') <> COALESCE(DW.[CenterPhone2TypeDescription],'')
				--OR COALESCE(STG.[CenterPhone2TypeDescriptionShort],'') <> COALESCE(DW.[CenterPhone2TypeDescriptionShort],'')
				--OR COALESCE(STG.[CenterPhone3],'') <> COALESCE(DW.[CenterPhone3],'')
				--OR COALESCE(STG.[CenterPhone3TypeDescription],'') <> COALESCE(DW.[CenterPhone3TypeDescription],'')
				--OR COALESCE(STG.[CenterPhone3TypeDescriptionShort],'') <> COALESCE(DW.[CenterPhone3TypeDescriptionShort],'')
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  CenterSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY CenterSSID ORDER BY CenterSSID ) AS RowNum
			   FROM  [bi_ent_stage].[DimCenter] STG
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
		FROM [bi_ent_stage].[DimCenter] STG
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
