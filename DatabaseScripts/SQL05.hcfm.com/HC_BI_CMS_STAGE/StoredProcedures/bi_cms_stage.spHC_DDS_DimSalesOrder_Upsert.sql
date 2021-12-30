/* CreateDate: 05/03/2010 12:19:48.020 , ModifyDate: 09/28/2015 17:12:30.053 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DDS_DimSalesOrder_Upsert]
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
-- [spHC_DDS_DimSalesOrder_Upsert] is used to update
-- SCD Type 1 records, update SCD Type 2 records and insert
-- New records
--
--
--   exec [bi_cms_stage].[spHC_DDS_DimSalesOrder_Upsert] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/01/2009  RLifke       Initial Creation
--			07/01/2011  KMurdoch	 Added IsSurgeryReversalFlag
--			03/21/2013	EKnapp		 Delete Extra Rows
--			05/28/2013  KMurdoch	 Added IsGuaranteeFlag
--          10/30/2013  EKnapp       Removed Nolock statement in delete sub select.
--			11/22/2013  KMurdoch	 Add IncomingRequestid
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrder]'


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
		SELECT @InitialRowCnt = COUNT(1) FROM [bi_cms_stage].[synHC_DDS_DimSalesOrder]

		-- Determine the number of extracted rows
		SELECT @ExtractRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimSalesOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey

	    -- Delete rows which don't exist in HairClubCMS anymore
		DELETE FROM [bi_cms_stage].[synHC_DDS_DimSalesOrder]
		WHERE [SalesOrderKey] > -1
		AND [SalesOrderSSID] NOT
		IN (
				SELECT SRC.[SalesOrderGUID]
				FROM [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrder] SRC
				)

		SET @DeletedRowCnt =  @@ROWCOUNT

		------------------------
		-- New Records
		------------------------
		INSERT INTO [bi_cms_stage].[synHC_DDS_DimSalesOrder] (
					  [SalesOrderSSID]
					, [TenderTransactionNumber_Temp]
					, [TicketNumber_Temp]
					, [CenterKey]
					, [CenterSSID]
					, [ClientHomeCenterKey]
					, [ClientHomeCenterSSID]
					, [SalesOrderTypeKey]
					, [SalesOrderTypeSSID]
					, [ClientKey]
					, [ClientSSID]
					, [ClientMembershipKey]
					, [ClientMembershipSSID]
					, [OrderDate]
					, [InvoiceNumber]
					, [IsTaxExemptFlag]
					, [IsVoidedFlag]
					, [IsClosedFlag]
					, [EmployeeKey]
					, [EmployeeSSID]
					, [FulfillmentNumber]
					, [IsWrittenOffFlag]
					, [IsRefundedFlag]
					, [RefundedSalesOrderKey]
					, [RefundedSalesOrderSSID]
					, [IsSurgeryReversalFlag]
					, [IsGuaranteeFlag]
					, [IncomingRequestID]
					, [RowIsCurrent]
					, [RowStartDate]
					, [RowEndDate]
					, [RowChangeReason]
					, [RowIsInferred]
					, [InsertAuditKey]
					, [UpdateAuditKey]
					)
			SELECT
				  STG.[SalesOrderSSID]
				, STG.[TenderTransactionNumber_Temp]
				, STG.[TicketNumber_Temp]
				, STG.[CenterKey]
				, STG.[CenterSSID]
				, STG.[ClientHomeCenterKey]
				, STG.[ClientHomeCenterSSID]
				, STG.[SalesOrderTypeKey]
				, STG.[SalesOrderTypeSSID]
				, STG.[ClientKey]
				, STG.[ClientSSID]
				, STG.[ClientMembershipKey]
				, STG.[ClientMembershipSSID]
				, STG.[OrderDate]
				, STG.[InvoiceNumber]
				, STG.[IsTaxExemptFlag]
				, STG.[IsVoidedFlag]
				, STG.[IsClosedFlag]
				, STG.[EmployeeKey]
				, STG.[EmployeeSSID]
				, STG.[FulfillmentNumber]
				, STG.[IsWrittenOffFlag]
				, STG.[IsRefundedFlag]
				, STG.[RefundedSalesOrderKey]
				, STG.[RefundedSalesOrderSSID]
				, STG.[IsSurgeryReversalFlag]
				, STG.[IsGuaranteeFlag]
				, STG.[IncomingRequestID]
				, 1 -- [RowIsCurrent]
				, CAST('1753-01-01 00:00:00' AS DateTime) -- [RowStartDate]
				, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
				, 'New Record' -- [RowChangeReason]
				, 0
				, @DataPkgKey
				, -2 -- 'Not Updated Yet'
			FROM [bi_cms_stage].[DimSalesOrder] STG
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
				  DW.[TenderTransactionNumber_Temp] = STG.[TenderTransactionNumber_Temp]
				, DW.[TicketNumber_Temp] = STG.[TicketNumber_Temp]
				, DW.[CenterKey] = STG.[CenterKey]
				, DW.[CenterSSID] = STG.[CenterSSID]
				, DW.[ClientHomeCenterKey] = STG.[ClientHomeCenterKey]
				, DW.[ClientHomeCenterSSID] = STG.[ClientHomeCenterSSID]
				, DW.[SalesOrderTypeKey] = STG.[SalesOrderTypeKey]
				, DW.[SalesOrderTypeSSID] = STG.[SalesOrderTypeSSID]
				, DW.[ClientKey] = STG.[ClientKey]
				, DW.[ClientSSID] = STG.[ClientSSID]
				, DW.[ClientMembershipKey] = STG.[ClientMembershipKey]
				, DW.[ClientMembershipSSID] = STG.[ClientMembershipSSID]
				, DW.[OrderDate] = STG.[OrderDate]
				, DW.[InvoiceNumber] = STG.[InvoiceNumber]
				, DW.[IsTaxExemptFlag] = STG.[IsTaxExemptFlag]
				, DW.[IsVoidedFlag] = STG.[IsVoidedFlag]
				, DW.[IsClosedFlag] = STG.[IsClosedFlag]
				, DW.[EmployeeKey] = STG.[EmployeeKey]
				, DW.[EmployeeSSID] = STG.[EmployeeSSID]
				, DW.[FulfillmentNumber] = STG.[FulfillmentNumber]
				, DW.[IsWrittenOffFlag] = STG.[IsWrittenOffFlag]
				, DW.[IsRefundedFlag] = STG.[IsRefundedFlag]
				, DW.[RefundedSalesOrderKey] = STG.[RefundedSalesOrderKey]
				, DW.[RefundedSalesOrderSSID] = STG.[RefundedSalesOrderSSID]
				, DW.[IsSurgeryReversalFlag] = STG.[IsSurgeryReversalFlag]
				, DW.[IsGuaranteeFlag] = STG.[IsGuaranteeFlag]
				, DW.[IncomingRequestID] = STG.[IncomingRequestID]
				, DW.[RowChangeReason] = 'Updated Inferred Member'
				, DW.[RowIsInferred] = 0
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_cms_stage].[DimSalesOrder] STG
		JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrder] DW ON
				DW.[SalesOrderSSID] = STG.[SalesOrderSSID]
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
				  DW.[TenderTransactionNumber_Temp] = STG.[TenderTransactionNumber_Temp]
				, DW.[TicketNumber_Temp] = STG.[TicketNumber_Temp]
				, DW.[CenterKey] = STG.[CenterKey]
				, DW.[CenterSSID] = STG.[CenterSSID]
				, DW.[ClientHomeCenterKey] = STG.[ClientHomeCenterKey]
				, DW.[ClientHomeCenterSSID] = STG.[ClientHomeCenterSSID]
				, DW.[SalesOrderTypeKey] = STG.[SalesOrderTypeKey]
				, DW.[SalesOrderTypeSSID] = STG.[SalesOrderTypeSSID]
				, DW.[ClientKey] = STG.[ClientKey]
				, DW.[ClientSSID] = STG.[ClientSSID]
				, DW.[ClientMembershipKey] = STG.[ClientMembershipKey]
				, DW.[ClientMembershipSSID] = STG.[ClientMembershipSSID]
				, DW.[OrderDate] = STG.[OrderDate]
				, DW.[InvoiceNumber] = STG.[InvoiceNumber]
				, DW.[IsTaxExemptFlag] = STG.[IsTaxExemptFlag]
				, DW.[IsVoidedFlag] = STG.[IsVoidedFlag]
				, DW.[IsClosedFlag] = STG.[IsClosedFlag]
				, DW.[EmployeeKey] = STG.[EmployeeKey]
				, DW.[EmployeeSSID] = STG.[EmployeeSSID]
				, DW.[FulfillmentNumber] = STG.[FulfillmentNumber]
				, DW.[IsWrittenOffFlag] = STG.[IsWrittenOffFlag]
				, DW.[IsRefundedFlag] = STG.[IsRefundedFlag]
				, DW.[RefundedSalesOrderKey] = STG.[RefundedSalesOrderKey]
				, DW.[RefundedSalesOrderSSID] = STG.[RefundedSalesOrderSSID]
				, DW.[IsSurgeryReversalFlag] = STG.[IsSurgeryReversalFlag]
				, DW.[IsGuaranteeFlag] = STG.[IsGuaranteeFlag]
				, DW.[IncomingRequestID] = STG.[IncomingRequestID]
				, DW.[RowChangeReason] = 'SCD Type 1'
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_cms_stage].[DimSalesOrder] STG
		JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrder] DW ON
				DW.[SalesOrderSSID] = STG.[SalesOrderSSID]
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
		FROM [bi_cms_stage].[DimSalesOrder] STG
		JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrder] DW ON
				DW.[SalesOrderKey] = STG.[SalesOrderKey]
			AND DW.[RowIsCurrent] = 1
		WHERE	STG.[IsType2] = 1
			AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @UpdateSCD2RowCnt = @@ROWCOUNT

		--Next insert the record with the current values
		INSERT INTO [bi_cms_stage].[synHC_DDS_DimSalesOrder] (
					  [SalesOrderSSID]
					, [TenderTransactionNumber_Temp]
					, [TicketNumber_Temp]
					, [CenterKey]
					, [CenterSSID]
					, [ClientHomeCenterKey]
					, [ClientHomeCenterSSID]
					, [SalesOrderTypeKey]
					, [SalesOrderTypeSSID]
					, [ClientKey]
					, [ClientSSID]
					, [ClientMembershipKey]
					, [ClientMembershipSSID]
					, [OrderDate]
					, [InvoiceNumber]
					, [IsTaxExemptFlag]
					, [IsVoidedFlag]
					, [IsClosedFlag]
					, [EmployeeKey]
					, [EmployeeSSID]
					, [FulfillmentNumber]
					, [IsWrittenOffFlag]
					, [IsRefundedFlag]
					, [RefundedSalesOrderKey]
					, [RefundedSalesOrderSSID]
					, [IsSurgeryReversalFlag]
					, [IsGuaranteeFlag]
					, [IncomingRequestID]
					, [RowIsCurrent]
					, [RowStartDate]
					, [RowEndDate]
					, [RowChangeReason]
					, [RowIsInferred]
					, [InsertAuditKey]
					, [UpdateAuditKey]
					)
			SELECT
				  STG.[SalesOrderSSID]
				, STG.[TenderTransactionNumber_Temp]
				, STG.[TicketNumber_Temp]
				, STG.[CenterKey]
				, STG.[CenterSSID]
				, STG.[ClientHomeCenterKey]
				, STG.[ClientHomeCenterSSID]
				, STG.[SalesOrderTypeKey]
				, STG.[SalesOrderTypeSSID]
				, STG.[ClientKey]
				, STG.[ClientSSID]
				, STG.[ClientMembershipKey]
				, STG.[ClientMembershipSSID]
				, STG.[OrderDate]
				, STG.[InvoiceNumber]
				, STG.[IsTaxExemptFlag]
				, STG.[IsVoidedFlag]
				, STG.[IsClosedFlag]
				, STG.[EmployeeKey]
				, STG.[EmployeeSSID]
				, STG.[FulfillmentNumber]
				, STG.[IsWrittenOffFlag]
				, STG.[IsRefundedFlag]
				, STG.[RefundedSalesOrderKey]
				, STG.[RefundedSalesOrderSSID]
				, STG.[IsSurgeryReversalFlag]
				, STG.[IsGuaranteeFlag]
				, STG.[IncomingRequestID]
				, 1 -- [RowIsCurrent]
				, STG.[ModifiedDate] -- [RowStartDate]
				, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
				, 'SCD Type 2' -- [RowChangeReason]
				, 0
				, @DataPkgKey
				, -2 -- 'Not Updated Yet'
			FROM [bi_cms_stage].[DimSalesOrder] STG
			WHERE	STG.[IsType2] = 1
				AND	STG.[IsException] = 0
				AND STG.[DataPkgKey] = @DataPkgKey


		SET @InsertSCD2RowCnt = @@ROWCOUNT


		-- Determine the number of exception rows
		SELECT @ExceptionRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimSalesOrder] STG
		WHERE STG.[IsException] = 1
			AND STG.[DataPkgKey] = @DataPkgKey

		-- Determine the number of inserted and updated rows
		SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt

		-- Determine the number of ignored rows
		SELECT @IgnoreRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimSalesOrder] STG
		WHERE STG.[IsException] = 0
		AND STG.[IsNew] = 0
		AND STG.[IsType1] = 0
		AND STG.[IsType2] = 0
		OR STG.[IsDuplicate] = 1
		AND STG.[DataPkgKey] = @DataPkgKey


		-- Determine Final Row Cnt
		SELECT @FinalRowCnt = COUNT(1) FROM [bi_cms_stage].[synHC_DDS_DimSalesOrder]


		-- Determine the number of Fixed rows
		SELECT @FixedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimSalesOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsFixed] = 1

		-- Determine the number of Allowed rows
		SELECT @AllowedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimSalesOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsAllowed] = 1

		-- Determine the number of Rejected rows
		SELECT @RejectedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimSalesOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 1

		-- Determine the number of Healthy rows
		SELECT @HealthyRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimSalesOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 0
		AND STG.[IsAllowed] = 0
		AND STG.[IsFixed] = 0

		-- Determine the number of Duplicate rows
		SELECT @DuplicateRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimSalesOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDuplicate] = 1

		-- Determine the number of Deleted rows
		--SELECT @DeletedRowCnt = COUNT(1)
		--FROM [bi_cms_stage].[DimSalesOrder] STG
		--WHERE STG.[DataPkgKey] = @DataPkgKey
		--AND STG.[IsDelete] = 1


		-----------------------
		-- Flag records as validated
		-----------------------
		UPDATE STG SET
			IsLoaded = 1
		FROM [bi_cms_stage].[DimSalesOrder] STG
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
