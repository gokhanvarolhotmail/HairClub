/* CreateDate: 05/03/2010 12:26:23.687 , ModifyDate: 04/15/2021 08:51:32.877 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DDS_FactLead_Upsert]
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
-- [spHC_DDS_FactLead_Upsert] is used to
-- add Leads
--
--
--   exec [bi_mktg_stage].[spHC_DDS_FactLead_Upsert] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    11/18/2009  RLifke       Initial Creation
--          02/03/2011               Add Promo Code and Sales type
--			08/09/2011  KMurdoch	 Added Assigned EmployeeKey
--			03/28/2016  KMurdoch	 Added Sale & ShowDiff
--			07/25/2019  KMurdoch	 Fixed the changing of Creation date & time
--			08/24/2020  KMurdoch     Added Recent Source to FactLead
--			04/09/2021  KMurdoch     Added cONEct revenue to FactLead
--			04/14/2021  KMurdoch	 Changed revenue to go back to 2001
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

 	SET @TableName = N'[bi_mktg_dds].[FactLead]'

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
		SELECT @InitialRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_FactLead]

		-- Determine the number of extracted rows
		SELECT @ExtractRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey

		------------------------
		-- Deleted Records
		------------------------
		DELETE
		FROM [bi_mktg_stage].[synHC_DDS_FactLead]
		WHERE [ContactKey] IN ( SELECT STG.[ContactKey]
										FROM [bi_mktg_stage].[FactLead] STG
										WHERE	STG.[IsDelete] = 1
											AND STG.[DataPkgKey] = @DataPkgKey
									)


		------------------------
		-- New Records
		------------------------
		INSERT INTO [bi_mktg_stage].[synHC_DDS_FactLead](
					  [ContactKey]
					, [LeadCreationDateKey]
					, [LeadCreationTimeKey]
					, [CenterKey]
					, [SourceKey]

					, [GenderKey]
					, [OccupationKey]
					, [EthnicityKey]
					, [MaritalStatusKey]
					, [HairLossTypeKey]
					, [AgeRangeKey]
					, [EmployeeKey]

					, [PromotionCodeKey]
					, [SalesTypeKey]

					, [Leads]
					, [Appointments]
					, [Shows]
					, [Sales]
					, [Activities]
					, [NoShows]
					, [NoSales]
					, [ShowDiff]
					, [SaleDiff]
					, [AssignedEmployeeKey]
					, [RecentSourceKey]
					, [InsertAuditKey]
					, [UpdateAuditKey]
					)
			SELECT DISTINCT
					  STG.[ContactKey]
					, STG.[LeadCreationDateKey]
					, STG.[LeadCreationTimeKey]
					, STG.[CenterKey]
					, STG.[SourceKey]

					, STG.[GenderKey]
					, STG.[OccupationKey]
					, STG.[EthnicityKey]
					, STG.[MaritalStatusKey]
					, STG.[HairLossTypeKey]
					, STG.[AgeRangeKey]
					, STG.[EmployeeKey]

					, STG.PromotionCodeKey
					, STG.SalesTypeKey

					, STG.[Leads]
					, STG.[Appointments]
					, STG.[Shows]
					, STG.[Sales]
 					, STG.[Activities]
					, STG.[NoShows]
					, STG.[NoSales]
					, STG.[ShowDiff]
					, STG.[SaleDiff]
					, STG.[AssignedEmployeeKey]
					, STG.[RecentSourceKey]
  					, @DataPkgKey
   					, -2

			FROM [bi_mktg_stage].[FactLead] STG
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
				  DW.[CenterKey] = STG.[CenterKey]
				, DW.[SourceKey] = STG.[SourceKey]
				, DW.[GenderKey] = STG.[GenderKey]
				, DW.[OccupationKey] = STG.[OccupationKey]
				, DW.[EthnicityKey] = STG.[EthnicityKey]
				, DW.[MaritalStatusKey] = STG.[MaritalStatusKey]
				, DW.[HairLossTypeKey] = STG.[HairLossTypeKey]
				, DW.[AgeRangeKey] = STG.[AgeRangeKey]
				, DW.[EmployeeKey] = STG.[EmployeeKey]
				, DW.[Leads] = STG.[Leads]
				, DW.[PromotionCodeKey] = STG.[PromotionCodeKey]
				, DW.[SalesTypeKey] = STG.[SalesTypeKey]
				, DW.[Appointments] = STG.[Appointments]
				, DW.[Shows] = STG.[Shows]
				, DW.[Sales] = STG.[Sales]
				, DW.[Activities] = STG.[Activities]
				, DW.[NoShows] = STG.[NoShows]
				, DW.[NoSales] = STG.[NoSales]
				, DW.[ShowDiff] = STG.[ShowDiff]
				, DW.[SaleDiff] = STG.[SaleDiff]
				, DW.[AssignedEmployeeKey] = STG.[AssignedEmployeeKey]
				, DW.[LeadCreationDateKey] = STG.[LeadCreationDateKey]
				, DW.[LeadCreationTimeKey] = STG.[LeadCreationTimeKey]
				, DW.[RecentSourceKey] = STG.[RecentSourceKey]
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_mktg_stage].[FactLead] STG
		JOIN [bi_mktg_stage].[synHC_DDS_FactLead] DW ON
				DW.[ContactKey] = STG.[ContactKey]
		WHERE	STG.[IsUpdate] = 1
			AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @UpdateSCD1RowCnt = @@ROWCOUNT

-------------------------------------------------------------------------
--  Update Lead Revenue on Fact Lead from a VW that sums up the cONEct
-------------------------------------------------------------------------
		UPDATE DW
			SET DW.[NewBusinessRevenue] = LR.NewBusinessRevenue,
				DW.PCPMemberRevenue = LR.PCPMemberRevenue,
				DW.PCPLaserRevenue = LR.PCPLaserRevenue,
				DW.RetailRevenue = LR.RetailRevenue,
				DW.ServiceRevenue = LR.ServiceRevenue,
				DW.NBLaserRevenue = LR.NBLaserRevenue
		FROM [bi_mktg_stage].[synHC_DDS_FactLead] DW
			INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwLeadRevenue LR
				ON DW.ContactKey = LR.ContactKey
		WHERE	LR.LeadCreateDate >= '01/01/2001'

		-- Determine the number of exception rows
		SELECT @ExceptionRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[IsException] = 1
			AND STG.[DataPkgKey] = @DataPkgKey

		-- Determine the number of inserted and updated rows
		SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt

		-- Determine the number of ignored rows
		SELECT @IgnoreRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[IsException] = 0
		AND STG.[IsNew] = 0
		AND STG.[IsUpdate] = 0
		AND STG.[IsDelete] = 0
		OR STG.[IsDuplicate] = 1
		AND STG.[DataPkgKey] = @DataPkgKey


		-- Determine Final Row Cnt
		SELECT @FinalRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_FactLead]

		-- Determine the number of Fixed rows
		SELECT @FixedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsFixed] = 1

		-- Determine the number of Allowed rows
		SELECT @AllowedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsAllowed] = 1

		-- Determine the number of Rejected rows
		SELECT @RejectedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 1

		-- Determine the number of Healthy rows
		SELECT @HealthyRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 0
		AND STG.[IsAllowed] = 0
		AND STG.[IsFixed] = 0

		-- Determine the number of Duplicate rows
		SELECT @DuplicateRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDuplicate] = 1

		-- Determine the number of Deleted rows
		SELECT @DeletedRowCnt = COUNT(1)
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDelete] = 1


		-----------------------
		-- Flag records as loaded
		-----------------------
		UPDATE STG SET
			IsLoaded = 1
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE DataPkgKey = @DataPkgKey
		AND STG.[IsException] = 0

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
