/* CreateDate: 05/03/2010 12:09:38.120 , ModifyDate: 02/28/2017 16:22:20.687 */
GO
CREATE procedure [bi_ent_stage].[spHC_DDS_DimCenter_Upsert]
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
-- [spHC_DDS_DimCenter_Upsert] is used to update
-- SCD Type 1 records, update SCD Type 2 records and insert
-- New records
--
--
--   exec [bi_ent_stage].[spHC_DDS_DimCenter_Upsert] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/25/2009  RLifke       Initial Creation
--			03/19/2012  KMurdoch     Added ReportingCenterSSID
--			03/26/2013  KMurdoch     Added HasFullAccessFlag
--			05/29/2013  KMurdoch     Added CenterBusinessTypeID
--			08/26/2013	KMurdoch	 Added Region Employee Roll-ups
--			09/26/2013  KMurdoch     Fixed RegionSSID Update
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
				, @return_value		int

	DECLARE		  @TableName			varchar(150)	-- Name of table

	DECLARE		  @DeletedRowCnt		bigint
				, @DuplicateRowCnt		bigint
				, @HealthyRowCnt		bigint
				, @RejectedRowCnt		bigint
				, @AllowedRowCnt		bigint
				, @FixedRowCnt			bigint

 	SET @TableName = N'[bi_ent_dds].[DimCenter]'

 	   -- Put parameters in name value list to aid in reporting
		EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


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
		SELECT @InitialRowCnt = COUNT(1) FROM [bi_ent_stage].[synHC_DDS_DimCenter]

		-- Determine the number of extracted rows
		SELECT @ExtractRowCnt = COUNT(1)
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey

		------------------------
		-- New Records
		------------------------
		INSERT INTO [bi_ent_stage].[synHC_DDS_DimCenter] (
					  [CenterSSID]
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
					, [RowIsCurrent]
					, [RowStartDate]
					, [RowEndDate]
					, [RowChangeReason]
					, [RowIsInferred]
					, [InsertAuditKey]
					, [UpdateAuditKey]
					)
			SELECT
				  STG.[CenterSSID]
				, STG.[RegionKey]
				, STG.[RegionSSID]
				, STG.[TimeZoneKey]
				, STG.[TimeZoneSSID]
				, STG.[CenterTypeKey]
				, STG.[CenterTypeSSID]
				, STG.[DoctorRegionKey]
				, STG.[DoctorRegionSSID]
				, STG.[CenterOwnershipKey]
				, STG.[CenterOwnershipSSID]
				, STG.[CenterDescription]
				, STG.[CenterAddress1]
				, STG.[CenterAddress2]
				, STG.[CenterAddress3]
				, STG.[CountryRegionDescription]
				, STG.[CountryRegionDescriptionShort]
				, STG.[StateProvinceDescription]
				, STG.[StateProvinceDescriptionShort]
				, STG.[City]
				, STG.[PostalCode]
				, STG.[CenterPhone1]
				, STG.[Phone1TypeSSID]
				, STG.[CenterPhone1TypeDescription]
				, STG.[CenterPhone1TypeDescriptionShort]
				, STG.[CenterPhone2]
				, STG.[Phone2TypeSSID]
				, STG.[CenterPhone2TypeDescription]
				, STG.[CenterPhone2TypeDescriptionShort]
				, STG.[CenterPhone3]
				, STG.[Phone3TypeSSID]
				, STG.[CenterPhone3TypeDescription]
				, STG.[CenterPhone3TypeDescriptionShort]
				, STG.[ReportingCenterSSID]
				, STG.[HasFullAccessFlag]
				, STG.[CenterBusinessTypeID]
				, STG.[RegionRSMNBConsultantSSID]
				, STG.[RegionRSMMembershipAdvisorSSID]
				, STG.[RegionRTMTechnicalManagerSSID]
				, STG.[RegionROMOperationsManagerSSID]
				, STG.[CenterManagementAreaSSID]
				, STG.[NewBusinessSize]
				, STG.[RecurringBusinessSize]
				, STG.[CenterNumber]
				, STG.[Active]
				, 1 -- [RowIsCurrent]
				, CAST('1753-01-01 00:00:00' AS DateTime) -- [RowStartDate]
				, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
				, 'New Record' -- [RowChangeReason]
				, 0
				, @DataPkgKey
				, -2 -- 'Not Updated Yet'
			FROM [bi_ent_stage].[DimCenter] STG
			WHERE	STG.[IsNew] = 1
				AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @InsertNewRowCnt = @@ROWCOUNT


		------------------------
		-- Inferred Members
		------------------------
		-- Just update the record
		UPDATE DW SET
				  DW.[RegionKey] = STG.[RegionKey]
				, DW.[RegionSSID] = STG.[RegionSSID]
				, DW.[TimeZoneKey] = STG.[TimeZoneKey]
				, DW.[TimeZoneSSID] = STG.[TimeZoneSSID]
				, DW.[CenterTypeKey] = STG.[CenterTypeKey]
				, DW.[CenterTypeSSID] = STG.[CenterTypeSSID]
				, DW.[DoctorRegionKey] = STG.[DoctorRegionKey]
				, DW.[DoctorRegionSSID] = STG.[DoctorRegionSSID]
				, DW.[CenterOwnershipKey] = STG.[CenterOwnershipKey]
				, DW.[CenterOwnershipSSID] = STG.[CenterOwnershipSSID]
				, DW.[CenterDescription] = STG.[CenterDescription]
				, DW.[CenterAddress1] = STG.[CenterAddress1]
				, DW.[CenterAddress2] = STG.[CenterAddress2]
				, DW.[CenterAddress3] = STG.[CenterAddress3]
				, DW.[CountryRegionDescription] = STG.[CountryRegionDescription]
				, DW.[CountryRegionDescriptionShort] = STG.[CountryRegionDescriptionShort]
				, DW.[StateProvinceDescription] = STG.[StateProvinceDescription]
				, DW.[StateProvinceDescriptionShort] = STG.[StateProvinceDescriptionShort]
				, DW.[City] = STG.[City]
				, DW.[PostalCode] = STG.[PostalCode]
				, DW.[CenterPhone1] = STG.[CenterPhone1]
				, DW.[Phone1TypeSSID] = STG.[Phone1TypeSSID]
				, DW.[CenterPhone1TypeDescription] = STG.[CenterPhone1TypeDescription]
				, DW.[CenterPhone1TypeDescriptionShort] = STG.[CenterPhone1TypeDescriptionShort]
				, DW.[CenterPhone2] = STG.[CenterPhone2]
				, DW.[Phone2TypeSSID] = STG.[Phone2TypeSSID]
				, DW.[CenterPhone2TypeDescription] = STG.[CenterPhone2TypeDescription]
				, DW.[CenterPhone2TypeDescriptionShort] = STG.[CenterPhone2TypeDescriptionShort]
				, DW.[CenterPhone3] = STG.[CenterPhone3]
				, DW.[Phone3TypeSSID] = STG.[Phone3TypeSSID]
				, DW.[CenterPhone3TypeDescription] = STG.[CenterPhone3TypeDescription]
				, DW.[CenterPhone3TypeDescriptionShort] = STG.[CenterPhone3TypeDescriptionShort]
				, DW.[ReportingCenterSSID] = STG.[ReportingCenterSSID]
				, DW.[HasFullAccessFlag] = STG.[HasFullAccessFlag]
				, DW.[CenterBusinessTypeID] = STG.[CenterBusinessTypeID]
				, DW.[RegionRSMNBConsultantSSID] = STG.[RegionRSMNBConsultantSSID]
				, DW.[RegionRSMMembershipAdvisorSSID] = STG.[RegionRSMMembershipAdvisorSSID]
				, DW.[RegionRTMTechnicalManagerSSID] = STG.[RegionRTMTechnicalManagerSSID]
				, DW.[RegionROMOperationsManagerSSID] = STG.[RegionROMOperationsManagerSSID]
				, DW.[CenterManagementAreaSSID] = STG.[CenterManagementAreaSSID]
				, DW.[NewBusinessSize] = STG.[NewBusinessSize]
				, DW.[RecurringBusinessSize] = STG.[RecurringBusinessSize]
				, DW.[CenterNumber] = STG.[CenterNumber]
				, DW.[Active] = STG.[Active]
				, DW.[RowChangeReason] = 'Updated Inferred Member'
				, DW.[RowIsInferred] = 0
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_ent_stage].[DimCenter] STG
		JOIN [bi_ent_stage].[synHC_DDS_DimCenter] DW ON
				DW.[CenterSSID] = STG.[CenterSSID]
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
				  DW.[RegionKey] = STG.[RegionKey]
				, DW.[RegionSSID] = STG.[RegionSSID]
				, DW.[TimeZoneKey] = STG.[TimeZoneKey]
				, DW.[TimeZoneSSID] = STG.[TimeZoneSSID]
				, DW.[CenterTypeKey] = STG.[CenterTypeKey]
				, DW.[CenterTypeSSID] = STG.[CenterTypeSSID]
				, DW.[DoctorRegionKey] = STG.[DoctorRegionKey]
				, DW.[DoctorRegionSSID] = STG.[DoctorRegionSSID]
				, DW.[CenterOwnershipKey] = STG.[CenterOwnershipKey]
				, DW.[CenterOwnershipSSID] = STG.[CenterOwnershipSSID]
				, DW.[CenterDescription] = STG.[CenterDescription]
				, DW.[CenterAddress1] = STG.[CenterAddress1]
				, DW.[CenterAddress2] = STG.[CenterAddress2]
				, DW.[CenterAddress3] = STG.[CenterAddress3]
				, DW.[CountryRegionDescription] = STG.[CountryRegionDescription]
				, DW.[CountryRegionDescriptionShort] = STG.[CountryRegionDescriptionShort]
				, DW.[StateProvinceDescription] = STG.[StateProvinceDescription]
				, DW.[StateProvinceDescriptionShort] = STG.[StateProvinceDescriptionShort]
				, DW.[City] = STG.[City]
				, DW.[PostalCode] = STG.[PostalCode]
				, DW.[CenterPhone1] = STG.[CenterPhone1]
				, DW.[Phone1TypeSSID] = STG.[Phone1TypeSSID]
				, DW.[CenterPhone1TypeDescription] = STG.[CenterPhone1TypeDescription]
				, DW.[CenterPhone1TypeDescriptionShort] = STG.[CenterPhone1TypeDescriptionShort]
				, DW.[CenterPhone2] = STG.[CenterPhone2]
				, DW.[Phone2TypeSSID] = STG.[Phone2TypeSSID]
				, DW.[CenterPhone2TypeDescription] = STG.[CenterPhone2TypeDescription]
				, DW.[CenterPhone2TypeDescriptionShort] = STG.[CenterPhone2TypeDescriptionShort]
				, DW.[CenterPhone3] = STG.[CenterPhone3]
				, DW.[Phone3TypeSSID] = STG.[Phone3TypeSSID]
				, DW.[CenterPhone3TypeDescription] = STG.[CenterPhone3TypeDescription]
				, DW.[CenterPhone3TypeDescriptionShort] = STG.[CenterPhone3TypeDescriptionShort]
				, DW.[ReportingCenterSSID] = STG.[ReportingCenterSSID]
				, DW.[CenterBusinessTypeID] = STG.[CenterBusinessTypeID]
				, DW.[HasFullAccessFlag] = STG.[HasFullAccessFlag]
				, DW.[RegionRSMNBConsultantSSID] = STG.[RegionRSMNBConsultantSSID]
				, DW.[RegionRSMMembershipAdvisorSSID] = STG.[RegionRSMMembershipAdvisorSSID]
				, DW.[RegionRTMTechnicalManagerSSID] = STG.[RegionRTMTechnicalManagerSSID]
				, DW.[RegionROMOperationsManagerSSID] = STG.[RegionROMOperationsManagerSSID]
				, DW.[CenterManagementAreaSSID] = STG.[CenterManagementAreaSSID]
				, DW.[NewBusinessSize] = STG.[NewBusinessSize]
				, DW.[RecurringBusinessSize] = STG.[RecurringBusinessSize]
				, DW.[CenterNumber] = STG.[CenterNumber]
				, DW.[Active] = STG.[Active]
				, DW.[RowChangeReason] = 'SCD Type 1'
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_ent_stage].[DimCenter] STG
		JOIN [bi_ent_stage].[synHC_DDS_DimCenter] DW ON
				DW.[CenterSSID] = STG.[CenterSSID]
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
		FROM [bi_ent_stage].[DimCenter] STG
		JOIN [bi_ent_stage].[synHC_DDS_DimCenter] DW ON
				DW.[CenterKey] = STG.[CenterKey]
			AND DW.[RowIsCurrent] = 1
		WHERE	STG.[IsType2] = 1
			AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @UpdateSCD2RowCnt = @@ROWCOUNT

		--Next insert the record with the current values
		INSERT INTO [bi_ent_stage].[synHC_DDS_DimCenter] (
					  [CenterSSID]
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
					, [RegionRSMNBConsultantSSID]
					, [RegionRSMMembershipAdvisorSSID]
					, [RegionRTMTechnicalManagerSSID]
					, [RegionROMOperationsManagerSSID]
					, [CenterManagementAreaSSID]
					, [NewBusinessSize]
					, [RecurringBusinessSize]
					, [CenterNumber]
					, [Active]
					, [RowIsCurrent]
					, [RowStartDate]
					, [RowEndDate]
					, [RowChangeReason]
					, [RowIsInferred]
					, [InsertAuditKey]
					, [UpdateAuditKey]
					)
			SELECT
				  STG.[CenterSSID]
				, STG.[RegionKey]
				, STG.[RegionSSID]
				, STG.[TimeZoneKey]
				, STG.[TimeZoneSSID]
				, STG.[CenterTypeKey]
				, STG.[CenterTypeSSID]
				, STG.[DoctorRegionKey]
				, STG.[DoctorRegionSSID]
				, STG.[CenterOwnershipKey]
				, STG.[CenterOwnershipSSID]
				, STG.[CenterDescription]
				, STG.[CenterAddress1]
				, STG.[CenterAddress2]
				, STG.[CenterAddress3]
				, STG.[CountryRegionDescription]
				, STG.[CountryRegionDescriptionShort]
				, STG.[StateProvinceDescription]
				, STG.[StateProvinceDescriptionShort]
				, STG.[City]
				, STG.[PostalCode]
				, STG.[CenterPhone1]
				, STG.[Phone1TypeSSID]
				, STG.[CenterPhone1TypeDescription]
				, STG.[CenterPhone1TypeDescriptionShort]
				, STG.[CenterPhone2]
				, STG.[Phone2TypeSSID]
				, STG.[CenterPhone2TypeDescription]
				, STG.[CenterPhone2TypeDescriptionShort]
				, STG.[CenterPhone3]
				, STG.[Phone3TypeSSID]
				, STG.[CenterPhone3TypeDescription]
				, STG.[CenterPhone3TypeDescriptionShort]
				, STG.[ReportingCenterSSID]
				, STG.[HasFullAccessFlag]
				, STG.[RegionRSMNBConsultantSSID]
				, STG.[RegionRSMMembershipAdvisorSSID]
				, STG.[RegionRTMTechnicalManagerSSID]
				, STG.[RegionROMOperationsManagerSSID]
				, STG.[CenterManagementAreaSSID]
				, STG.[NewBusinessSize]
				, STG.[RecurringBusinessSize]
				, STG.[CenterNumber]
				, STG.[Active]
				, 1 -- [RowIsCurrent]
				, STG.[ModifiedDate] -- [RowStartDate]
				, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
				, 'SCD Type 2' -- [RowChangeReason]
				, 0
				, @DataPkgKey
				, -2 -- 'Not Updated Yet'
			FROM [bi_ent_stage].[DimCenter] STG
			WHERE	STG.[IsType2] = 1
				AND	STG.[IsException] = 0
				AND STG.[DataPkgKey] = @DataPkgKey


		SET @InsertSCD2RowCnt = @@ROWCOUNT


		-- Determine the number of exception rows
		SELECT @ExceptionRowCnt = COUNT(1)
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[IsException] = 1
			AND STG.[DataPkgKey] = @DataPkgKey

		-- Determine the number of inserted and updated rows
		SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt

		-- Determine the number of ignored rows
		SELECT @IgnoreRowCnt = COUNT(1)
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[IsException] = 0
		AND STG.[IsNew] = 0
		AND STG.[IsType1] = 0
		AND STG.[IsType2] = 0
		OR STG.[IsDuplicate] = 1
		AND STG.[DataPkgKey] = @DataPkgKey


		-- Determine Final Row Cnt
		SELECT @FinalRowCnt = COUNT(1) FROM [bi_ent_stage].[synHC_DDS_DimCenter]

		-- Determine the number of Fixed rows
		SELECT @FixedRowCnt = COUNT(1)
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsFixed] = 1

		-- Determine the number of Allowed rows
		SELECT @AllowedRowCnt = COUNT(1)
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsAllowed] = 1

		-- Determine the number of Rejected rows
		SELECT @RejectedRowCnt = COUNT(1)
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 1

		-- Determine the number of Healthy rows
		SELECT @HealthyRowCnt = COUNT(1)
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 0
		AND STG.[IsAllowed] = 0
		AND STG.[IsFixed] = 0

		-- Determine the number of Duplicate rows
		SELECT @DuplicateRowCnt = COUNT(1)
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDuplicate] = 1

		-- Determine the number of Deleted rows
		SELECT @DeletedRowCnt = COUNT(1)
		FROM [bi_ent_stage].[DimCenter] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDelete] = 1


		-----------------------
		-- Flag records as validated
		-----------------------
		UPDATE STG SET
			IsLoaded = 1
		FROM [bi_ent_stage].[DimCenter] STG
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
