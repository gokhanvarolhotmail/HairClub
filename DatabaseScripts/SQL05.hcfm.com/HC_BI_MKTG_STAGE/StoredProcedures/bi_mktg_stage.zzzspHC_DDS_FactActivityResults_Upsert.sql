/* CreateDate: 05/03/2010 12:26:23.640 , ModifyDate: 08/05/2019 11:16:21.310 */
GO
CREATE PROCEDURE [bi_mktg_stage].[zzzspHC_DDS_FactActivityResults_Upsert]
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
-- [spHC_DDS_FactActivityResults_Upsert] loads records into the FactActivityResults table
--
--
--   exec [bi_mktg_stage].[spHC_DDS_FactActivityResults_Upsert] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    07/01/2009  RLifke       Initial Creation
--			08/10/2011  KMurdoch	 Added ActivityEmployeeKey
--			11/13/2017	RHut		 Added VOID to the statement ((oncd_activity.[Result_code] NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN', 'VOID' ))
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

	DECLARE		@TableName			varchar(150)	-- Name of table

	DECLARE		  @DeletedRowCnt		bigint
				, @DuplicateRowCnt		bigint
				, @HealthyRowCnt		bigint
				, @RejectedRowCnt		bigint
				, @AllowedRowCnt		bigint
				, @FixedRowCnt			bigint

 	SET @TableName = N'[bi_mktg_dds].[FactActivityResults]'

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
		SELECT @InitialRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_FactActivityResults]

		-- Determine the number of extracted rows
		SELECT @ExtractRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey

		------------------------
		-- Deleted Records
		------------------------
		DELETE
		FROM [bi_mktg_stage].[synHC_DDS_FactActivityResults]
		WHERE [ActivityKey] IN ( SELECT STG.[ActivityKey]
										FROM [bi_mktg_stage].[FactActivityResults] STG
										WHERE	STG.[IsDelete] = 1
											AND STG.[DataPkgKey] = @DataPkgKey
									)

		------------------------
		-- Deleted Records that changed result code
		------------------------
		DELETE
		FROM [bi_mktg_stage].[synHC_DDS_FactActivityResults]
		WHERE  ActivityKey IN (
				SELECT DW.[ActivityKey]
				FROM [bi_mktg_stage].[synHC_DDS_FactActivityResults] DW WITH (NOLOCK)
				LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimActivity] da WITH (NOLOCK)
				ON da.ActivityKey = DW.[ActivityKey]
				WHERE da.[ActivitySSID] NOT
				IN (
						SELECT SRC.activity_id
						FROM [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity] SRC WITH (NOLOCK)
						WHERE (((SRC.[action_code] IN ('APPOINT', 'INHOUSE', 'BEBACK')) AND ((SRC.[Result_code] NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN', 'VOID' )) OR (SRC.[Result_code] IS NULL) ))
								OR ((SRC.[action_code] IN ('RECOVERY')) AND ((SRC.[Result_code] IS NOT NULL)) AND (SRC.[Result_code] IN ('SHOWSALE','SHOWNOSALE','NOSHOW'))))
					)
				)


		------------------------
		-- New Records
		------------------------
		INSERT INTO [bi_mktg_stage].[synHC_DDS_FactActivityResults](
					   [ActivityKey]
					  ,[ActivityDateKey]
					  ,[ActivityTimeKey]

					  ,[ActivityResultDateKey]
					  ,[ActivityResultKey]
					  ,[ActivityResultTimeKey]

					  ,[ActivityCompletedDateKey]
					  ,[ActivityCompletedTimeKey]
					  ,[ActivityDueDateKey]
					  ,[ActivityStartTimeKey]

					  ,[OriginalAppointmentDateKey]
					  ,[ActivitySavedDateKey]
					  ,[ActivitySavedTimeKey]

					  ,[ContactKey]
					  ,[CenterKey]
					  ,[SalesTypeKey]
					  ,[SourceKey]
					  ,[ActionCodeKey]
					  ,[ResultCodeKey]

					  ,[GenderKey]
					  ,[OccupationKey]
					  ,[EthnicityKey]
					  ,[MaritalStatusKey]
					  ,[HairLossTypeKey]
					  ,[AgeRangeKey]
					  ,[CompletedByEmployeeKey]
					  ,[ClientNumber]
					  ,[Appointments]
					  ,[Show]
					  ,[NoShow]
					  ,[Sale]
					  ,[NoSale]
					  ,[Consultation]
					  ,[BeBack]

					  ,[SurgeryOffered]
					  ,[ReferredToDoctor]
					  ,[InitialPayment]
					  ,[ActivityEmployeeKey]
					  ,[InsertAuditKey]
					)
			SELECT DISTINCT
					   STG.[ActivityKey]
					  ,STG.[ActivityDateKey]
					  ,STG.[ActivityTimeKey]

					  ,STG.[ActivityResultDateKey]
					  ,STG.[ActivityResultKey]
					  ,STG.[ActivityResultTimeKey]

					  ,STG.[ActivityCompletedDateKey]
					  ,STG.[ActivityCompletedTimeKey]
					  ,STG.[ActivityDueDateKey]
					  ,STG.[ActivityStartTimeKey]

					  ,STG.[OriginalAppointmentDateKey]
					  ,STG.[ActivitySavedDateKey]
					  ,STG.[ActivitySavedTimeKey]

					  ,STG.[ContactKey]
					  ,STG.[CenterKey]
					  ,STG.[SalesTypeKey]
					  ,STG.[SourceKey]
					  ,STG.[ActionCodeKey]
					  ,STG.[ResultCodeKey]

					  ,STG.[GenderKey]
					  ,STG.[OccupationKey]
					  ,STG.[EthnicityKey]
					  ,STG.[MaritalStatusKey]
					  ,STG.[HairLossTypeKey]
					  ,STG.[AgeRangeKey]
					  ,STG.[CompletedByEmployeeKey]
					  ,STG.[ClientNumber]
					  ,STG.[Appointments]
					  ,STG.[Show]
					  ,STG.[NoShow]
					  ,STG.[Sale]
					  ,STG.[NoSale]
					  ,STG.[Consultation]
					  ,STG.[BeBack]
					  ,STG.[SurgeryOffered]
					  ,STG.[ReferredToDoctor]
					  ,STG.[InitialPayment]
					  ,STG.[ActivityEmployeeKey]

					  ,@DataPkgKey

			FROM [bi_mktg_stage].[FactActivityResults] STG
			WHERE	STG.[IsNew] = 1
				AND	STG.[IsException] = 0
				AND STG.[IsDuplicate] = 0
				AND STG.[DataPkgKey] = @DataPkgKey

		SET @InsertNewRowCnt = @@ROWCOUNT


		------------------------
		-- Update Records
		------------------------
		-- Just update the record
		UPDATE DW SET
				  DW.[ActivityResultDateKey] = STG.[ActivityResultDateKey]
				, DW.[ActivityResultKey] = STG.[ActivityResultKey]
				, DW.[ActivityResultTimeKey] = STG.[ActivityResultTimeKey]
				, DW.[ActivityDateKey] = STG.[ActivityDateKey]
				, DW.[ActivityTimeKey] = STG.[ActivityTimeKey]
				, DW.[ActivityCompletedDateKey] = STG.[ActivityCompletedDateKey]
				, DW.[ActivityCompletedTimeKey] = STG.[ActivityCompletedTimeKey]
				, DW.[ActivityDueDateKey] = STG.[ActivityDueDateKey]
				, DW.[ActivityStartTimeKey] = STG.[ActivityStartTimeKey]

				, DW.[OriginalAppointmentDateKey] = STG.[OriginalAppointmentDateKey]
				, DW.[ActivitySavedDateKey] = STG.[ActivitySavedDateKey]
				, DW.[ActivitySavedTimeKey] = STG.[ActivitySavedTimeKey]

				, DW.[ContactKey] = STG.[ContactKey]
				, DW.[CenterKey] = STG.[CenterKey]
				, DW.[SalesTypeKey] = STG.[SalesTypeKey]
				, DW.[SourceKey] = STG.[SourceKey]
				, DW.[ActionCodeKey] = STG.[ActionCodeKey]
				, DW.[ResultCodeKey] = STG.[ResultCodeKey]

				, DW.[GenderKey] = STG.[GenderKey]
				, DW.[OccupationKey] = STG.[OccupationKey]
				, DW.[EthnicityKey] = STG.[EthnicityKey]
				, DW.[MaritalStatusKey] = STG.[MaritalStatusKey]
				, DW.[HairLossTypeKey] = STG.[HairLossTypeKey]
				, DW.[AgeRangeKey] = STG.[AgeRangeKey]
				, DW.[CompletedByEmployeeKey] = STG.[CompletedByEmployeeKey]
				, DW.[ClientNumber] = STG.[ClientNumber]
				, DW.[Appointments] = STG.[Appointments]
				, DW.[Show] = STG.[Show]
				, DW.[NoShow] = STG.[NoShow]
				, DW.[Sale] = STG.[Sale]
				, DW.[NoSale] = STG.[NoSale]
				, DW.[Consultation] = STG.[Consultation]
				, DW.[BeBack] = STG.[BeBack]
				, DW.[SurgeryOffered] = STG.[SurgeryOffered]
				, DW.[ReferredToDoctor] = STG.[ReferredToDoctor]
				, DW.[InitialPayment] = STG.[InitialPayment]
				, DW.[ActivityEmployeeKey] = STG.[ActivityEmployeeKey]
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_mktg_stage].[FactActivityResults] STG
		JOIN [bi_mktg_stage].[synHC_DDS_FactActivityResults] DW ON
				DW.[ActivityKey] = STG.[ActivityKey]
				----DW.[ActivityResultKey] = STG.[ActivityResultKey]
		WHERE	STG.[IsUpdate] = 1
			AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @UpdateSCD1RowCnt = @@ROWCOUNT


		-- Determine the number of exception rows
		SELECT @ExceptionRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[IsException] = 1
			AND STG.[DataPkgKey] = @DataPkgKey

		-- Determine the number of inserted and updated rows
		SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt


		-- Determine the number of ignored rows
		SELECT @IgnoreRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[IsException] = 0
		AND STG.[IsNew] = 0
		AND STG.[IsUpdate] = 0
		AND STG.[IsDelete] = 0
		OR STG.[IsDuplicate] = 1
		AND STG.[DataPkgKey] = @DataPkgKey

		-- Determine Final Row Cnt
		SELECT @FinalRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_FactActivityResults]

		-- Determine the number of Fixed rows
		SELECT @FixedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsFixed] = 1

		-- Determine the number of Allowed rows
		SELECT @AllowedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsAllowed] = 1

		-- Determine the number of Rejected rows
		SELECT @RejectedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 1

		-- Determine the number of Healthy rows
		SELECT @HealthyRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 0
		AND STG.[IsAllowed] = 0
		AND STG.[IsFixed] = 0

		-- Determine the number of Duplicate rows
		SELECT @DuplicateRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDuplicate] = 1

		-- Determine the number of Deleted rows
		SELECT @DeletedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDelete] = 1


		-----------------------
		-- Flag records as loaded
		-----------------------
		UPDATE STG SET
			IsLoaded = 1
		FROM [bi_mktg_stage].[FactActivityResults] STG
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
