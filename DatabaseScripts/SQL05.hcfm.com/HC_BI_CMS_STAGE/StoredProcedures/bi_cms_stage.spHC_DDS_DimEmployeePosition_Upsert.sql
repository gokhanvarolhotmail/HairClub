/* CreateDate: 08/02/2012 15:08:06.957 , ModifyDate: 12/17/2012 11:25:34.370 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DDS_DimEmployeePosition_Upsert]
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
-- [spHC_DDS_DimEmployeePosition_Upsert] is used to update
-- SCD Type 1 records, update SCD Type 2 records and insert
-- New records
--
--
--   exec [bi_cms_stage].[spHC_DDS_DimEmployeePosition_Upsert] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/02/2012  KMurdoch     Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[DimEmployeePosition]'


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
		SET @DeletedRowCnt = 0
		SET @DuplicateRowCnt = 0
		SET @HealthyRowCnt = 0
		SET @RejectedRowCnt = 0
		SET @AllowedRowCnt = 0
		SET @FixedRowCnt = 0

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_LoadStart] @DataPkgKey, @TableName

		-- Determine Initial Row Cnt
		SELECT @InitialRowCnt = COUNT(1) FROM [bi_cms_stage].[synHC_DDS_DimEmployeePosition]

		-- Determine the number of extracted rows
		SELECT @ExtractRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimEmployeePosition] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey

		------------------------
		-- New Records
		------------------------
		INSERT INTO [bi_cms_stage].[synHC_DDS_DimEmployeePosition] (
					  [EmployeePositionSSID]
					, [EmployeePositionDescription]
					, [EmployeePositionDescriptionShort]
					, [EmployeePositionSortOrder]
					, [ActiveDirectoryGroup]
					, [IsAdministratorFlag]
					, [IsEmployeeOneFlag]
					, [IsEmployeeTwoFlag]
					, [IsEmployeeThreeFlag]
					, [IsEmployeeFourFlag]
					, [CanScheduleFlag]
					, [ApplicationTimeoutMinutes]
					, [UseDefaultCenterFlag]
					, [IsSurgeryCenterEmployeeFlag]
					, [IsNonSurgeryCenterEmployeeFlag]
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
				  STG.[EmployeePositionSSID]
				, STG.[EmployeePositionDescription]
				, STG.[EmployeePositionDescriptionShort]
				, STG.[EmployeePositionSortOrder]
				, STG.[ActiveDirectoryGroup]
				, STG.[IsAdministratorFlag]
				, STG.[IsEmployeeOneFlag]
				, STG.[IsEmployeeTwoFlag]
				, STG.[IsEmployeeThreeFlag]
				, STG.[IsEmployeeFourFlag]
				, STG.[CanScheduleFlag]
				, STG.[ApplicationTimeoutMinutes]
				, STG.[UseDefaultCenterFlag]
				, STG.[IsSurgeryCenterEmployeeFlag]
				, STG.[IsNonSurgeryCenterEmployeeFlag]
				, STG.[Active]
				, 1 -- [RowIsCurrent]
				, CAST('1753-01-01 00:00:00' AS DateTime) -- [RowStartDate]
				, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
				, 'New Record' -- [RowChangeReason]
				, 0
				, @DataPkgKey
				, -2 -- 'Not Updated Yet'
			FROM [bi_cms_stage].[DimEmployeePosition] STG
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
				  DW.[EmployeePositionDescription] = STG.[EmployeePositionDescription]
				, DW.[EmployeePositionDescriptionShort] = STG.[EmployeePositionDescriptionShort]
				, DW.[EmployeePositionSortOrder] = STG.[EmployeePositionSortOrder]
				, DW.[ActiveDirectoryGroup] = STG.[ActiveDirectoryGroup]
				, DW.[IsAdministratorFlag] = STG.[IsAdministratorFlag]
				, DW.[IsEmployeeOneFlag] = STG.[IsEmployeeOneFlag]
				, DW.[IsEmployeeTwoFlag] = STG.[IsEmployeeTwoFlag]
				, DW.[IsEmployeeThreeFlag] = STG.[IsEmployeeThreeFlag]
				, DW.[IsEmployeeFourFlag] = STG.[IsEmployeeFourFlag]
				, DW.[CanScheduleFlag] = STG.[CanScheduleFlag]
				, DW.[ApplicationTimeoutMinutes] = STG.[ApplicationTimeoutMinutes]
				, DW.[UseDefaultCenterFlag] = STG.[UseDefaultCenterFlag]
				, DW.[IsSurgeryCenterEmployeeFlag] = STG.[IsSurgeryCenterEmployeeFlag]
				, DW.[IsNonSurgeryCenterEmployeeFlag] = STG.[IsNonSurgeryCenterEmployeeFlag]
				, DW.[Active]= STG.[Active]
				, DW.[RowChangeReason] = 'Updated Inferred Member'
				, DW.[RowIsInferred] = 0
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_cms_stage].[DimEmployeePosition] STG
		JOIN [bi_cms_stage].[synHC_DDS_DimEmployeePosition] DW ON
				DW.[EmployeePositionSSID] = STG.[EmployeePositionSSID]
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
				  DW.[EmployeePositionDescription] = STG.[EmployeePositionDescription]
				, DW.[EmployeePositionDescriptionShort] = STG.[EmployeePositionDescriptionShort]
				, DW.[EmployeePositionSortOrder] = STG.[EmployeePositionSortOrder]
				, DW.[ActiveDirectoryGroup] = STG.[ActiveDirectoryGroup]
				, DW.[IsAdministratorFlag] = STG.[IsAdministratorFlag]
				, DW.[IsEmployeeOneFlag] = STG.[IsEmployeeOneFlag]
				, DW.[IsEmployeeTwoFlag] = STG.[IsEmployeeTwoFlag]
				, DW.[IsEmployeeThreeFlag] = STG.[IsEmployeeThreeFlag]
				, DW.[IsEmployeeFourFlag] = STG.[IsEmployeeFourFlag]
				, DW.[CanScheduleFlag] = STG.[CanScheduleFlag]
				, DW.[ApplicationTimeoutMinutes] = STG.[ApplicationTimeoutMinutes]
				, DW.[UseDefaultCenterFlag] = STG.[UseDefaultCenterFlag]
				, DW.[IsSurgeryCenterEmployeeFlag] = STG.[IsSurgeryCenterEmployeeFlag]
				, DW.[IsNonSurgeryCenterEmployeeFlag] = STG.[IsNonSurgeryCenterEmployeeFlag]
				, DW.[Active]= STG.[Active]
				, DW.[RowChangeReason] = 'SCD Type 1'
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_cms_stage].[DimEmployeePosition] STG
		JOIN [bi_cms_stage].[synHC_DDS_DimEmployeePosition] DW ON
				DW.[EmployeePositionSSID] = STG.[EmployeePositionSSID]
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
		FROM [bi_cms_stage].[DimEmployeePosition] STG
		JOIN [bi_cms_stage].[synHC_DDS_DimEmployeePosition] DW ON
				DW.[EmployeePositionKey] = STG.[EmployeePositionKey]
			AND DW.[RowIsCurrent] = 1
		WHERE	STG.[IsType2] = 1
			AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @UpdateSCD2RowCnt = @@ROWCOUNT

		--Next insert the record with the current values
		INSERT INTO [bi_cms_stage].[synHC_DDS_DimEmployeePosition] (
					  [EmployeePositionSSID]
					, [EmployeePositionDescription]
					, [EmployeePositionDescriptionShort]
					, [EmployeePositionSortOrder]
					, [ActiveDirectoryGroup]
					, [IsAdministratorFlag]
					, [IsEmployeeOneFlag]
					, [IsEmployeeTwoFlag]
					, [IsEmployeeThreeFlag]
					, [IsEmployeeFourFlag]
					, [CanScheduleFlag]
					, [ApplicationTimeoutMinutes]
					, [UseDefaultCenterFlag]
					, [IsSurgeryCenterEmployeeFlag]
					, [IsNonSurgeryCenterEmployeeFlag]
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
				  STG.[EmployeePositionSSID]
				, STG.[EmployeePositionDescription]
				, STG.[EmployeePositionDescriptionShort]
				, STG.[EmployeePositionSortOrder]
				, STG.[ActiveDirectoryGroup]
				, STG.[IsAdministratorFlag]
				, STG.[IsEmployeeOneFlag]
				, STG.[IsEmployeeTwoFlag]
				, STG.[IsEmployeeThreeFlag]
				, STG.[IsEmployeeFourFlag]
				, STG.[CanScheduleFlag]
				, STG.[ApplicationTimeoutMinutes]
				, STG.[UseDefaultCenterFlag]
				, STG.[IsSurgeryCenterEmployeeFlag]
				, STG.[IsNonSurgeryCenterEmployeeFlag]
				, STG.[Active]
				, 1 -- [RowIsCurrent]
				, STG.[ModifiedDate] -- [RowStartDate]
				, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
				, 'SCD Type 2' -- [RowChangeReason]
				, 0
				, @DataPkgKey
				, -2 -- 'Not Updated Yet'
			FROM [bi_cms_stage].[DimEmployeePosition] STG
			WHERE	STG.[IsType2] = 1
				AND	STG.[IsException] = 0
				AND STG.[DataPkgKey] = @DataPkgKey


		SET @InsertSCD2RowCnt = @@ROWCOUNT


		-- Determine the number of exception rows
		SELECT @ExceptionRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimEmployeePosition] STG
		WHERE STG.[IsException] = 1
			AND STG.[DataPkgKey] = @DataPkgKey

		-- Determine the number of inserted and updated rows
		SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt

		-- Determine the number of ignored rows
		SELECT @IgnoreRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimEmployeePosition] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND ((STG.[IsException] = 0
		AND STG.[IsNew] = 0
		AND STG.[IsType1] = 0
		AND STG.[IsType2] = 0)
		OR STG.[IsDuplicate] = 1)


		-- Determine Final Row Cnt
		SELECT @FinalRowCnt = COUNT(1) FROM [bi_cms_stage].[synHC_DDS_DimEmployeePosition]

		-- Determine the number of Fixed rows
		SELECT @FixedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimEmployeePosition] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsFixed] = 1

		-- Determine the number of Allowed rows
		SELECT @AllowedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimEmployeePosition] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsAllowed] = 1

		-- Determine the number of Rejected rows
		SELECT @RejectedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimEmployeePosition] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 1

		-- Determine the number of Healthy rows
		SELECT @HealthyRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimEmployeePosition] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 0
		AND STG.[IsAllowed] = 0
		AND STG.[IsFixed] = 0

		-- Determine the number of Duplicate rows
		SELECT @DuplicateRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimEmployeePosition] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDuplicate] = 1

		-- Determine the number of Deleted rows
		SELECT @DeletedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimEmployeePosition] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDelete] = 1


		-----------------------
		-- Flag records as validated
		-----------------------
		UPDATE STG SET
			IsLoaded = 1
		FROM [bi_cms_stage].[DimEmployeePosition] STG
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
