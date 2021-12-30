/* CreateDate: 06/27/2011 17:23:32.337 , ModifyDate: 11/28/2017 15:51:51.043 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DDS_DimAppointment_Upsert]
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
-- [spHC_DDS_DimAppointment_Upsert] is used to update
-- SCD Type 1 records, update SCD Type 2 records and insert
-- New records
--
--
--   exec [bi_cms_stage].[spHC_DDS_DimAppointment_Upsert] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/22/2011	KMurdoch     Initial Creation
--			03/22/2013  EKnapp		 Delete Extra rows
--			07/13/2015	DLeiba		 Added Delete Logic
--			11/28/2017	KMurdoch	 Added SFDC_Lead/Task_ID
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

 	SET @TableName = N'[bi_cms_dds].[DimAppointment]'


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
		SELECT @InitialRowCnt = COUNT(1) FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimAppointment]

		-- Determine the number of extracted rows
		SELECT @ExtractRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimAppointment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-- Delete DimAppointment records which don't exist in HairClubCMS anymore
		DELETE	DA
		FROM    HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
				LEFT OUTER JOIN HairClubCMS.dbo.datAppointment A
					ON A.AppointmentGUID = DA.AppointmentSSID
		WHERE	DA.AppointmentKey > -1
				AND A.AppointmentGUID IS NULL

		SET @DeletedRowCnt =  @@ROWCOUNT

		------------------------
		-- New Records
		------------------------
		INSERT INTO [HC_BI_CMS_DDS].[bi_cms_dds].[DimAppointment] (
					  [AppointmentSSID]
					   , [CenterKey]
					   , [CenterSSID]
					   , [ClientHomeCenterKey]
					   , [ClientHomeCenterSSID]
					   , [ClientKey]
					   , [ClientSSID]
					   , [ClientMembershipKey]
					   , [ClientMembershipSSID]
					   , [AppointmentDate]
					   , [ResourceSSID]
					   , [ResourceDescription]
					   , [ConfirmationTypeSSID]
					   , [ConfirmationTypeDescription]
					   , [AppointmentTypeSSID]
					   , [AppointmentTypeDescription]
					   , [AppointmentStartTime]
					   , [AppointmentEndTime]
					   , [CheckInTime]
					   , [CheckOutTime]
					   , [AppointmentSubject]
					   , [AppointmentStatusSSID]
					   , [AppointmentStatusDescription]
					   , [OnContactActivitySSID]
					   , [OnContactContactSSID]
					   , [CanPrinTCommentFlag]
					   , [IsNonAppointmentFlag]
					   , [IsDeletedFlag]
					   , [SFDC_LeadID]
					   , [SFDC_TaskID]
					   , [RowIsCurrent]
					   , [RowStartDate]
					   , [RowEndDate]
					   , [RowChangeReason]
					   , [RowIsInferred]
					   , [InsertAuditKey]
					   , [UpdateAuditKey]
								)
			SELECT
						 STG.[AppointmentSSID]
						, STG.[CenterKey]
						, STG.[CenterSSID]
						, STG.[ClientHomeCenterKey]
						, STG.[ClientHomeCenterSSID]
						, STG.[ClientKey]
						, STG.[ClientSSID]
						, STG.[ClientMembershipKey]
						, STG.[ClientMembershipSSID]
						, STG.[AppointmentDate]
						, STG.[ResourceSSID]
						, STG.[ResourceDescription]
						, STG.[ConfirmationTypeSSID]
						, STG.[ConfirmationTypeDescription]
						, STG.[AppointmentTypeSSID]
						, STG.[AppointmentTypeDescription]
						, STG.[AppointmentStartTime]
						, STG.[AppointmentEndTime]
						, STG.[CheckInTime]
						, STG.[CheckOutTime]
						, STG.[AppointmentSubject]
						, STG.[AppointmentStatusSSID]
						, STG.[AppointmentStatusDescription]
						, STG.[OnContactActivitySSID]
						, STG.[OnContactContactSSID]
						, STG.[CanPrinTCommentFlag]
						, STG.[IsNonAppointmentFlag]
						, STG.[IsDeletedFlag]
						, STG.[SFDC_LeadID]
					    , STG.[SFDC_TaskID]
						, 1 -- [RowIsCurrent]
						, CAST('1753-01-01 00:00:00' AS DateTime) -- [RowStartDate]
						, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
						, 'New Record' -- [RowChangeReason]
						, 0
						, @DataPkgKey
						, -2 -- 'Not Updated Yet'
			FROM [bi_cms_stage].[DimAppointment] STG
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
				  DW.[AppointmentSSID] = STG.[AppointmentSSID]
				, DW.[CenterKey] = STG.[CenterKey]
				, DW.[CenterSSID] = STG.[CenterSSID]
				, DW.[ClientHomeCenterKey] = STG.[ClientHomeCenterKey]
				, DW.[ClientHomeCenterSSID] = STG.[ClientHomeCenterSSID]
				, DW.[ClientKey] = STG.[ClientKey]
				, DW.[ClientSSID] = STG.[ClientSSID]
				, DW.[ClientMembershipKey] = STG.[ClientMembershipKey]
				, DW.[ClientMembershipSSID] = STG.[ClientMembershipSSID]
				, DW.[AppointmentDate] = STG.[AppointmentDate]
				, DW.[ResourceSSID] = STG.[ResourceSSID]
				, DW.[ResourceDescription] = STG.[ResourceDescription]
				, DW.[ConfirmationTypeSSID] = STG.[ConfirmationTypeSSID]
				, DW.[ConfirmationTypeDescription] = STG.[ConfirmationTypeDescription]
				, DW.[AppointmentTypeSSID] = STG.[AppointmentTypeSSID]
				, DW.[AppointmentStartTime] = STG.[AppointmentStartTime]
				, DW.[AppointmentEndTime] = STG.[AppointmentEndTime]
				, DW.[CheckInTime] = STG.[CheckInTime]
				, DW.[CheckOutTime] = STG.[CheckOutTime]
				, DW.[AppointmentSubject] = STG.[AppointmentSubject]
				, DW.[AppointmentStatusSSID] = STG.[AppointmentStatusSSID]
				, DW.[AppointmentStatusDescription] = STG.[AppointmentStatusDescription]
				, DW.[OnContactActivitySSID] = STG.[OnContactActivitySSID]
				, DW.[OnContactContactSSID] = STG.[OnContactContactSSID]
				, DW.[CanPrinTCommentFlag] = STG.[CanPrinTCommentFlag]
				, DW.[IsNonAppointmentFlag] = STG.[IsNonAppointmentFlag]
				, DW.[IsDeletedFlag] = STG.[IsDeletedFlag]
				, DW.[SFDC_LeadID] = STG.[SFDC_LeadID]
				, DW.[SFDC_TaskID] = STG.[SFDC_TaskID]
				, DW.[RowChangeReason] = 'Updated Inferred Member'
				, DW.[RowIsInferred] = 0
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_cms_stage].[DimAppointment] STG
		JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimAppointment] DW ON
				DW.[AppointmentSSID] = STG.[AppointmentSSID]
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
				  DW.[AppointmentSSID] = STG.[AppointmentSSID]
				, DW.[CenterKey] = STG.[CenterKey]
				, DW.[CenterSSID] = STG.[CenterSSID]
				, DW.[ClientHomeCenterKey] = STG.[ClientHomeCenterKey]
				, DW.[ClientHomeCenterSSID] = STG.[ClientHomeCenterSSID]
				, DW.[ClientKey] = STG.[ClientKey]
				, DW.[ClientSSID] = STG.[ClientSSID]
				, DW.[ClientMembershipKey] = STG.[ClientMembershipKey]
				, DW.[ClientMembershipSSID] = STG.[ClientMembershipSSID]
				, DW.[AppointmentDate] = STG.[AppointmentDate]
				, DW.[ResourceSSID] = STG.[ResourceSSID]
				, DW.[ResourceDescription] = STG.[ResourceDescription]
				, DW.[ConfirmationTypeSSID] = STG.[ConfirmationTypeSSID]
				, DW.[ConfirmationTypeDescription] = STG.[ConfirmationTypeDescription]
				, DW.[AppointmentTypeSSID] = STG.[AppointmentTypeSSID]
				, DW.[AppointmentStartTime] = STG.[AppointmentStartTime]
				, DW.[AppointmentEndTime] = STG.[AppointmentEndTime]
				, DW.[CheckInTime] = STG.[CheckInTime]
				, DW.[CheckOutTime] = STG.[CheckOutTime]
				, DW.[AppointmentSubject] = STG.[AppointmentSubject]
				, DW.[AppointmentStatusSSID] = STG.[AppointmentStatusSSID]
				, DW.[AppointmentStatusDescription] = STG.[AppointmentStatusDescription]
				, DW.[OnContactActivitySSID] = STG.[OnContactActivitySSID]
				, DW.[OnContactContactSSID] = STG.[OnContactContactSSID]
				, DW.[CanPrinTCommentFlag] = STG.[CanPrinTCommentFlag]
				, DW.[IsNonAppointmentFlag] = STG.[IsNonAppointmentFlag]
				, DW.[IsDeletedFlag] = STG.[IsDeletedFlag]
				, DW.[SFDC_LeadID] = STG.[SFDC_LeadID]
				, DW.[SFDC_TaskID] = STG.[SFDC_TaskID]
				, DW.[RowChangeReason] = 'SCD Type 1'
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_cms_stage].[DimAppointment] STG
		JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimAppointment] DW ON
				DW.[AppointmentSSID] = STG.[AppointmentSSID]
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
		FROM [bi_cms_stage].[DimAppointment] STG
		JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimAppointment] DW ON
				DW.[AppointmentKey] = STG.[AppointmentKey]
			AND DW.[RowIsCurrent] = 1
		WHERE	STG.[IsType2] = 1
			AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @UpdateSCD2RowCnt = @@ROWCOUNT

		--Next insert the record with the current values
		INSERT INTO [HC_BI_CMS_DDS].[bi_cms_dds].[DimAppointment] (
					  [AppointmentSSID]
					   , [CenterKey]
					   , [CenterSSID]
					   , [ClientHomeCenterKey]
					   , [ClientHomeCenterSSID]
					   , [ClientKey]
					   , [ClientSSID]
					   , [ClientMembershipKey]
					   , [ClientMembershipSSID]
					   , [AppointmentDate]
					   , [ResourceSSID]
					   , [ResourceDescription]
					   , [ConfirmationTypeSSID]
					   , [ConfirmationTypeDescription]
					   , [AppointmentTypeSSID]
					   , [AppointmentTypeDescription]
					   , [AppointmentStartTime]
					   , [AppointmentEndTime]
					   , [CheckInTime]
					   , [CheckOutTime]
					   , [AppointmentSubject]
					   , [AppointmentStatusSSID]
					   , [AppointmentStatusDescription]
					   , [OnContactActivitySSID]
					   , [OnContactContactSSID]
					   , [CanPrinTCommentFlag]
					   , [IsNonAppointmentFlag]
					   , [IsDeletedFlag]
					   , [SFDC_LeadID]
					   , [SFDC_TaskID]
					   , [RowIsCurrent]
					   , [RowStartDate]
					   , [RowEndDate]
					   , [RowChangeReason]
					   , [RowIsInferred]
					   , [InsertAuditKey]
					   , [UpdateAuditKey]
					)
			SELECT
				STG.[AppointmentSSID]
				, STG.[CenterKey]
				, STG.[CenterSSID]
				, STG.[ClientHomeCenterKey]
				, STG.[ClientHomeCenterSSID]
				, STG.[ClientKey]
				, STG.[ClientSSID]
				, STG.[ClientMembershipKey]
				, STG.[ClientMembershipSSID]
				, STG.[AppointmentDate]
				, STG.[ResourceSSID]
				, STG.[ResourceDescription]
				, STG.[ConfirmationTypeSSID]
				, STG.[ConfirmationTypeDescription]
				, STG.[AppointmentTypeSSID]
				, STG.[AppointmentTypeDescription]
				, STG.[AppointmentStartTime]
				, STG.[AppointmentEndTime]
				, STG.[CheckInTime]
				, STG.[CheckOutTime]
				, STG.[AppointmentSubject]
				, STG.[AppointmentStatusSSID]
				, STG.[AppointmentStatusDescription]
				, STG.[OnContactActivitySSID]
				, STG.[OnContactContactSSID]
				, STG.[CanPrinTCommentFlag]
				, STG.[IsNonAppointmentFlag]
				, STG.[IsDeletedFlag]
				, STG.[SFDC_LeadID]
				, STG.[SFDC_TaskID]
				, 1 -- [RowIsCurrent]
				, STG.[ModifiedDate] -- [RowStartDate]
				, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
				, 'SCD Type 2' -- [RowChangeReason]
				, 0
				, @DataPkgKey
				, -2 -- 'Not Updated Yet'
			FROM [bi_cms_stage].[DimAppointment] STG
			WHERE	STG.[IsType2] = 1
				AND	STG.[IsException] = 0
				AND STG.[DataPkgKey] = @DataPkgKey


		SET @InsertSCD2RowCnt = @@ROWCOUNT


		-- Determine the number of exception rows
		SELECT @ExceptionRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimAppointment] STG
		WHERE STG.[IsException] = 1
			AND STG.[DataPkgKey] = @DataPkgKey

		-- Determine the number of inserted and updated rows
		SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt

		-- Determine the number of ignored rows
		SELECT @IgnoreRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimAppointment] STG
		WHERE STG.[IsException] = 0
		AND STG.[IsNew] = 0
		AND STG.[IsType1] = 0
		AND STG.[IsType2] = 0
		OR STG.[IsDuplicate] = 1
		AND STG.[DataPkgKey] = @DataPkgKey


		-- Determine Final Row Cnt
		SELECT @FinalRowCnt = COUNT(1) FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimAppointment]

		-- Determine the number of Fixed rows
		SELECT @FixedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimAppointment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsFixed] = 1

		-- Determine the number of Allowed rows
		SELECT @AllowedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimAppointment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsAllowed] = 1

		-- Determine the number of Rejected rows
		SELECT @RejectedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimAppointment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 1

		-- Determine the number of Healthy rows
		SELECT @HealthyRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimAppointment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 0
		AND STG.[IsAllowed] = 0
		AND STG.[IsFixed] = 0

		-- Determine the number of Duplicate rows
		SELECT @DuplicateRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimAppointment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDuplicate] = 1

		-- Determine the number of Deleted rows
		--SELECT @DeletedRowCnt = COUNT(1)
		--FROM [bi_cms_stage].[DimAppointment] STG
		--WHERE STG.[DataPkgKey] = @DataPkgKey
		--AND STG.[IsDelete] = 1


		-----------------------
		-- Flag records as validated
		-----------------------
		UPDATE STG SET
			IsLoaded = 1
		FROM [bi_cms_stage].[DimAppointment] STG
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
