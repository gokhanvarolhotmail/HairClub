/* CreateDate: 05/24/2012 14:02:12.167 , ModifyDate: 05/24/2012 14:02:12.167 */
GO
CREATE PROCEDURE [bi_cms_stage].[SAVEspHC_DDS_FactSalesTransaction_Upsert]
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
-- [spHC_DDS_FactSalesTransaction_Upsert] is used to determine
-- which records have late arriving dimensions and adds them
--
--
--   exec [bi_cms_stage].[spHC_DDS_FactSalesTransaction_Upsert] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    03/19/2009  RLifke       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[FactSalesTransaction]'


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
		SELECT @InitialRowCnt = COUNT(1) FROM [bi_cms_stage].[synHC_DDS_FactSalesTransaction]

		-- Determine the number of extracted rows
		SELECT @ExtractRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey


		INSERT INTO [bi_cms_stage].[synHC_DDS_FactSalesTransaction](
					  [SalesOrderDetailKey]
					, [OrderDateKey]
					, [SalesOrderKey]
					, [SalesOrderTypeKey]
					, [CenterKey]
					, [ClientKey]
					, [MembershipKey]
					, [ClientMembershipKey]
					, [SalesCodeKey]
					, [Employee1Key]
					, [Employee2Key]
					, [Employee3Key]
					, [Employee4Key]
					, [Quantity]
					, [Price]
					, [Discount]
					, [Tax1]
					, [Tax2]
					, [TaxRate1]
					, [TaxRate2]
					, [InsertAuditKey]
					, [UpdateAuditKey]
					)
			SELECT DISTINCT
					  STG.[SalesOrderDetailKey]
					, STG.[OrderDateKey]
					, STG.[SalesOrderKey]
					, STG.[SalesOrderTypeKey]
					, STG.[CenterKey]
					, STG.[ClientKey]
					, STG.[MembershipKey]
					, STG.[ClientMembershipKey]
					, STG.[SalesCodeKey]
					, STG.[Employee1Key]
					, STG.[Employee2Key]
					, STG.[Employee3Key]
					, STG.[Employee4Key]
					, STG.[Quantity]
					, STG.[Price]
					, STG.[Discount]
					, STG.[Tax1]
					, STG.[Tax2]
					, STG.[TaxRate1]
					, STG.[TaxRate2]
					, @DataPkgKey
					, -2 -- 'Not Updated Yet'
			FROM [bi_cms_stage].[FactSalesTransaction] STG
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
			  DW.[OrderDateKey] = STG.[OrderDateKey]
			, DW.[SalesOrderKey] = STG.[SalesOrderKey]
			, DW.[SalesOrderTypeKey] = STG.[SalesOrderTypeKey]
			, DW.[CenterKey] = STG.[CenterKey]
			, DW.[ClientKey] = STG.[ClientKey]
			, DW.[MembershipKey] = STG.[MembershipKey]
			, DW.[ClientMembershipKey] = STG.[ClientMembershipKey]
			, DW.[SalesCodeKey] = STG.[SalesCodeKey]
			, DW.[Employee1Key] = STG.[Employee1Key]
			, DW.[Employee2Key] = STG.[Employee2Key]
			, DW.[Employee3Key] = STG.[Employee3Key]
			, DW.[Employee4Key] = STG.[Employee4Key]
			, DW.[Quantity] = STG.[Quantity]
			, DW.[Price] = STG.[Price]
			, DW.[Discount] = STG.[Discount]
			, DW.[Tax1] = STG.[Tax1]
			, DW.[Tax2] = STG.[Tax2]
			, DW.[TaxRate1] = STG.[TaxRate1]
			, DW.[TaxRate2] = STG.[TaxRate2]
			, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		JOIN [bi_cms_stage].[synHC_DDS_FactSalesTransaction] DW WITH (NOLOCK)
			ON DW.[SalesOrderDetailKey] = STG.[SalesOrderDetailKey]
		WHERE	STG.[IsUpdate] = 1
			AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @UpdateSCD1RowCnt = @@ROWCOUNT

		-- Determine the number of exception rows
		SELECT @ExceptionRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[IsException] = 1
			AND STG.[DataPkgKey] = @DataPkgKey

		-- Determine the number of inserted and updated rows
		SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt


		-- Determine the number of ignored rows
		SELECT @IgnoreRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[IsException] = 0
		AND STG.[IsNew] = 0
		AND STG.[IsUpdate] = 0
		AND STG.[IsDelete] = 0
		OR STG.[IsDuplicate] = 1
		AND STG.[DataPkgKey] = @DataPkgKey


		-- Determine Final Row Cnt
		SELECT @FinalRowCnt = COUNT(1) FROM [bi_cms_stage].[synHC_DDS_FactSalesTransaction]


		-- Determine the number of Fixed rows
		SELECT @FixedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsFixed] = 1

		-- Determine the number of Allowed rows
		SELECT @AllowedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsAllowed] = 1

		-- Determine the number of Rejected rows
		SELECT @RejectedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 1

		-- Determine the number of Healthy rows
		SELECT @HealthyRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 0
		AND STG.[IsAllowed] = 0
		AND STG.[IsFixed] = 0

		-- Determine the number of Duplicate rows
		SELECT @DuplicateRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDuplicate] = 1

		-- Determine the number of Deleted rows
		SELECT @DeletedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDelete] = 1

		-----------------------
		-- Flag records as loaded
		-----------------------
		UPDATE STG SET
			IsLoaded = 1
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE DataPkgKey = @DataPkgKey
			AND	STG.[IsException] = 0

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
