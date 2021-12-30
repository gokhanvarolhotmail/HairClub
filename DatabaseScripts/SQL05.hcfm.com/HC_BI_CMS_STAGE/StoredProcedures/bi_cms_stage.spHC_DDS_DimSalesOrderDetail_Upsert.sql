/* CreateDate: 05/03/2010 12:19:47.823 , ModifyDate: 08/07/2017 10:27:41.840 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DDS_DimSalesOrderDetail_Upsert]
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
-- [spHC_DDS_DimSalesOrderDetail_Upsert] is used to update
-- SCD Type 1 records, update SCD Type 2 records and insert
-- New records
--
--
--   exec [bi_cms_stage].[spHC_DDS_DimSalesOrderDetail_Upsert] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/01/2009  RLifke       Initial Creation
--			03/26/2012  KMurdoch     Added Performer & 2, Cancelreason, Member1Price
--			11/27/2012  KMurdoch     Added update of employee1ssid
--			03/21/2013	EKnapp		 Delete extra rows
--          10/30/2013  EKnapp       Removed Nolock statement in delete sub select.
--			11/04/2015  KMurdoch     Added MembershipPromotion
--			04/03/2017  DLeiba		 Added HairSystemOrderSSID
--			08/07/2017  DLeiba		 Added ClientMembershipAddOnID
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrderDetail]'


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
		SELECT @InitialRowCnt = COUNT(1) FROM [bi_cms_stage].[synHC_DDS_DimSalesOrderDetail]

		-- Determine the number of extracted rows
		SELECT @ExtractRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimSalesOrderDetail] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-- Delete rows which don't exist in HairClubCMS anymore
		DELETE FROM [bi_cms_stage].[synHC_DDS_DimSalesOrderDetail]
		WHERE [SalesOrderdetailKey] > -1
		AND [SalesOrderDetailSSID] NOT
		IN (
				SELECT SRC.[SalesOrderDetailGUID]
				FROM [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrderDetail] SRC
				)

		SET @DeletedRowCnt =  @@ROWCOUNT

		------------------------
		-- New Records
		------------------------
		INSERT INTO [bi_cms_stage].[synHC_DDS_DimSalesOrderDetail] (
					  [SalesOrderDetailSSID]
					, [TransactionNumber_Temp]
					, [SalesOrderKey]
					, [SalesOrderSSID]
					, [OrderDate]
					, [SalesCodeSSID]
					, [SalesCodeDescription]
					, [SalesCodeDescriptionShort]
					, [IsVoidedFlag]
					, [IsClosedFlag]
					, [Quantity]
					, [Price]
					, [Discount]
					, [Tax1]
					, [Tax2]
					, [TaxRate1]
					, [TaxRate2]
					, [IsRefundedFlag]
					, [RefundedSalesOrderDetailSSID]
					, [RefundedTotalQuantity]
					, [RefundedTotalPrice]
					, [Employee1SSID]
					, [Employee1FirstName]
					, [Employee1LastName]
					, [Employee1Initials]

					, [Employee2SSID]
					, [Employee2FirstName]
					, [Employee2LastName]
					, [Employee2Initials]

					, [Employee3SSID]
					, [Employee3FirstName]
					, [Employee3LastName]
					, [Employee3Initials]

					, [Employee4SSID]
					, [Employee4FirstName]
					, [Employee4LastName]
					, [Employee4Initials]
					, [Performer_Temp]
					, [Performer2_Temp]
					, [CancelReasonID]
					, [Member1Price_Temp]

					, [PreviousClientMembershipSSID]
					, [NewCenterSSID]

					, [MembershipOrderReasonID]

					, [MembershipPromotion]

					, [HairSystemOrderSSID]
					, [ClientMembershipAddOnID]

					, [RowIsCurrent]
					, [RowStartDate]
					, [RowEndDate]
					, [RowChangeReason]
					, [RowIsInferred]
					, [InsertAuditKey]
					, [UpdateAuditKey]

					)
			SELECT
				  STG.[SalesOrderDetailSSID]
				, STG.[TransactionNumber_Temp]
				, STG.[SalesOrderKey]
				, STG.[SalesOrderSSID]
				, STG.[OrderDate]
				, STG.[SalesCodeSSID]
				, STG.[SalesCodeDescription]
				, STG.[SalesCodeDescriptionShort]
				, STG.[IsVoidedFlag]
				, STG.[IsClosedFlag]
				, STG.[Quantity]
				, STG.[Price]
				, STG.[Discount]
				, STG.[Tax1]
				, STG.[Tax2]
				, STG.[TaxRate1]
				, STG.[TaxRate2]
				, STG.[IsRefundedFlag]
				, STG.[RefundedSalesOrderDetailSSID]
				, STG.[RefundedTotalQuantity]
				, STG.[RefundedTotalPrice]
				, STG.[Employee1SSID]
				, STG.[Employee1FirstName]
				, STG.[Employee1LastName]
				, STG.[Employee1Initials]
				, STG.[Employee2SSID]
				, STG.[Employee2FirstName]
				, STG.[Employee2LastName]
				, STG.[Employee2Initials]
				, STG.[Employee3SSID]
				, STG.[Employee3FirstName]
				, STG.[Employee3LastName]
				, STG.[Employee3Initials]
				, STG.[Employee4SSID]
				, STG.[Employee4FirstName]
				, STG.[Employee4LastName]
				, STG.[Employee4Initials]
				, STG.[Performer_temp]
				, STG.[Performer2_Temp]
				, STG.[CancelReasonID]
				, STG.[Member1Price_Temp]
				, STG.[PreviousClientMembershipSSID]
				, STG.[NewCenterSSID]
				, STG.[MembershipOrderReasonID]
				, STG.[MembershipPromotion]
				, STG.[HairSystemOrderSSID]
				, STG.[ClientMembershipAddOnID]
				, 1 -- [RowIsCurrent]
				, CAST('1753-01-01 00:00:00' AS DateTime) -- [RowStartDate]
				, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
				, 'New Record' -- [RowChangeReason]
				, 0
				, @DataPkgKey
				, -2 -- 'Not Updated Yet'
			FROM [bi_cms_stage].[DimSalesOrderDetail] STG
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
				  DW.[TransactionNumber_Temp] = STG.[TransactionNumber_Temp]
				, DW.[SalesOrderKey] = STG.[SalesOrderKey]
				, DW.[SalesOrderSSID] = STG.[SalesOrderSSID]
				, DW.[OrderDate] = STG.[OrderDate]
				, DW.[SalesCodeSSID] = STG.[SalesCodeSSID]
				, DW.[SalesCodeDescription] = STG.[SalesCodeDescription]
				, DW.[SalesCodeDescriptionShort] = STG.[SalesCodeDescriptionShort]
				, DW.[IsVoidedFlag] = STG.[IsVoidedFlag]
				, DW.[IsClosedFlag] = STG.[IsClosedFlag]
				, DW.[Quantity] = STG.[Quantity]
				, DW.[Price] = STG.[Price]
				, DW.[Discount] = STG.[Discount]
				, DW.[Tax1] = STG.[Tax1]
				, DW.[Tax2] = STG.[Tax2]
				, DW.[TaxRate1] = STG.[TaxRate1]
				, DW.[TaxRate2] = STG.[TaxRate2]
				, DW.[IsRefundedFlag] = STG.[IsRefundedFlag]
				, DW.[RefundedSalesOrderDetailSSID] = STG.[RefundedSalesOrderDetailSSID]
				, DW.[RefundedTotalQuantity] = STG.[RefundedTotalQuantity]
				, DW.[RefundedTotalPrice] = STG.[RefundedTotalPrice]
				, DW.[Employee1SSID] = STG.[Employee1SSID]
				, DW.[Employee1FirstName] = STG.[Employee1FirstName]
				, DW.[Employee1LastName] = STG.[Employee1LastName]
				, DW.[Employee1Initials] = STG.[Employee1Initials]
				, DW.[Employee2SSID] = STG.[Employee2SSID]
				, DW.[Employee2FirstName] = STG.[Employee2FirstName]
				, DW.[Employee2LastName] = STG.[Employee2LastName]
				, DW.[Employee2Initials] = STG.[Employee2Initials]
				, DW.[Employee3SSID] = STG.[Employee3SSID]
				, DW.[Employee3FirstName] = STG.[Employee3FirstName]
				, DW.[Employee3LastName] = STG.[Employee3LastName]
				, DW.[Employee3Initials] = STG.[Employee3Initials]
				, DW.[Employee4SSID] = STG.[Employee4SSID]
				, DW.[Employee4FirstName] = STG.[Employee4FirstName]
				, DW.[Employee4LastName] = STG.[Employee4LastName]
				, DW.[Employee4Initials] = STG.[Employee4Initials]
				, DW.[Performer_temp] = STG.[Performer_temp]
				, DW.[Performer2_Temp] = STG.[Performer2_Temp]
				, DW.[CancelReasonID] = STG.[CancelReasonID]
				, DW.[Member1Price_Temp] = STG.[Member1Price_Temp]
				, DW.[PreviousClientMembershipSSID] = STG.[PreviousClientMembershipSSID]
				, DW.[NewCenterSSID] = STG.[NewCenterSSID]
				, DW.[MembershipOrderReasonID] = STG.[MembershipOrderReasonID]
				, DW.[MembershipPromotion] = STG.[MembershipPromotion]
				, DW.[HairSystemOrderSSID] = STG.[HairSystemOrderSSID]
				, DW.[ClientMembershipAddOnID] = STG.[ClientMembershipAddOnID]
				, DW.[RowChangeReason] = 'Updated Inferred Member'
				, DW.[RowIsInferred] = 0
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_cms_stage].[DimSalesOrderDetail] STG
		JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderDetail] DW ON
				DW.[SalesOrderDetailSSID] = STG.[SalesOrderDetailSSID]
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
				  DW.[TransactionNumber_Temp] = STG.[TransactionNumber_Temp]
				, DW.[SalesOrderKey] = STG.[SalesOrderKey]
				, DW.[SalesOrderSSID] = STG.[SalesOrderSSID]
				, DW.[OrderDate] = STG.[OrderDate]
				, DW.[SalesCodeSSID] = STG.[SalesCodeSSID]
				, DW.[SalesCodeDescription] = STG.[SalesCodeDescription]
				, DW.[SalesCodeDescriptionShort] = STG.[SalesCodeDescriptionShort]
				, DW.[IsVoidedFlag] = STG.[IsVoidedFlag]
				, DW.[IsClosedFlag] = STG.[IsClosedFlag]
				, DW.[Quantity] = STG.[Quantity]
				, DW.[Price] = STG.[Price]
				, DW.[Discount] = STG.[Discount]
				, DW.[Tax1] = STG.[Tax1]
				, DW.[Tax2] = STG.[Tax2]
				, DW.[TaxRate1] = STG.[TaxRate1]
				, DW.[TaxRate2] = STG.[TaxRate2]
				, DW.[IsRefundedFlag] = STG.[IsRefundedFlag]
				, DW.[RefundedSalesOrderDetailSSID] = STG.[RefundedSalesOrderDetailSSID]
				, DW.[RefundedTotalQuantity] = STG.[RefundedTotalQuantity]
				, DW.[RefundedTotalPrice] = STG.[RefundedTotalPrice]
				, DW.[Employee1SSID] = STG.[Employee1SSID]
				, DW.[Employee1FirstName] = STG.[Employee1FirstName]
				, DW.[Employee1LastName] = STG.[Employee1LastName]
				, DW.[Employee1Initials] = STG.[Employee1Initials]
				, DW.[Employee2SSID] = STG.[Employee2SSID]
				, DW.[Employee2FirstName] = STG.[Employee2FirstName]
				, DW.[Employee2LastName] = STG.[Employee2LastName]
				, DW.[Employee2Initials] = STG.[Employee2Initials]
				, DW.[Employee3SSID] = STG.[Employee3SSID]
				, DW.[Employee3FirstName] = STG.[Employee3FirstName]
				, DW.[Employee3LastName] = STG.[Employee3LastName]
				, DW.[Employee3Initials] = STG.[Employee3Initials]
				, DW.[Employee4SSID] = STG.[Employee4SSID]
				, DW.[Employee4FirstName] = STG.[Employee4FirstName]
				, DW.[Employee4LastName] = STG.[Employee4LastName]
				, DW.[Employee4Initials] = STG.[Employee4Initials]
				, DW.[Performer_temp] = STG.[Performer_temp]
				, DW.[Performer2_Temp] = STG.[Performer2_Temp]
				, DW.[CancelReasonID] = STG.[CancelReasonID]
				, DW.[Member1Price_Temp] = STG.[Member1Price_Temp]
				, DW.[PreviousClientMembershipSSID] = STG.[PreviousClientMembershipSSID]
				, DW.[NewCenterSSID] = STG.[NewCenterSSID]
				, DW.[MembershipOrderReasonID] = STG.[MembershipOrderReasonID]
				, DW.[MembershipPromotion] = STG.[MembershipPromotion]
				, DW.[HairSystemOrderSSID] = STG.[HairSystemOrderSSID]
				, DW.[ClientMembershipAddOnID] = STG.[ClientMembershipAddOnID]
				, DW.[RowChangeReason] = 'SCD Type 1'
				, DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_cms_stage].[DimSalesOrderDetail] STG
		JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderDetail] DW ON
				DW.[SalesOrderDetailSSID] = STG.[SalesOrderDetailSSID]
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
		FROM [bi_cms_stage].[DimSalesOrderDetail] STG
		JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderDetail] DW ON
				DW.[SalesOrderDetailKey] = STG.[SalesOrderDetailKey]
			AND DW.[RowIsCurrent] = 1
		WHERE	STG.[IsType2] = 1
			AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @UpdateSCD2RowCnt = @@ROWCOUNT

		--Next insert the record with the current values
		INSERT INTO [bi_cms_stage].[synHC_DDS_DimSalesOrderDetail] (
					  [SalesOrderDetailSSID]
					, [TransactionNumber_Temp]
					, [SalesOrderKey]
					, [SalesOrderSSID]
					, [OrderDate]
					, [SalesCodeSSID]
					, [SalesCodeDescription]
					, [SalesCodeDescriptionShort]
					, [IsVoidedFlag]
					, [IsClosedFlag]
					, [Quantity]
					, [Price]
					, [Discount]
					, [Tax1]
					, [Tax2]
					, [TaxRate1]
					, [TaxRate2]
					, [IsRefundedFlag]
					, [RefundedSalesOrderDetailSSID]
					, [RefundedTotalQuantity]
					, [RefundedTotalPrice]
					, [Employee1SSID]
					, [Employee1FirstName]
					, [Employee1LastName]
					, [Employee1Initials]

					, [Employee2SSID]
					, [Employee2FirstName]
					, [Employee2LastName]
					, [Employee2Initials]

					, [Employee3SSID]
					, [Employee3FirstName]
					, [Employee3LastName]
					, [Employee3Initials]

					, [Employee4SSID]
					, [Employee4FirstName]
					, [Employee4LastName]
					, [Employee4Initials]

					, [Performer_Temp]
					, [Performer2_Temp]
					, [CancelReasonID]
					, [Member1Price_Temp]

					, [PreviousClientMembershipSSID]
					, [NewCenterSSID]

					, [MembershipOrderReasonID]

					, [MembershipPromotion]

					, [HairSystemOrderSSID]
					, [ClientMembershipAddOnID]

					, [RowIsCurrent]
					, [RowStartDate]
					, [RowEndDate]
					, [RowChangeReason]
					, [RowIsInferred]
					, [InsertAuditKey]
					, [UpdateAuditKey]
					)
			SELECT
				  STG.[SalesOrderDetailSSID]
				, STG.[TransactionNumber_Temp]
				, STG.[SalesOrderKey]
				, STG.[SalesOrderSSID]
				, STG.[OrderDate]
				, STG.[SalesCodeSSID]
				, STG.[SalesCodeDescription]
				, STG.[SalesCodeDescriptionShort]
				, STG.[IsVoidedFlag]
				, STG.[IsClosedFlag]
				, STG.[Quantity]
				, STG.[Price]
				, STG.[Discount]
				, STG.[Tax1]
				, STG.[Tax2]
				, STG.[TaxRate1]
				, STG.[TaxRate2]
				, STG.[IsRefundedFlag]
				, STG.[RefundedSalesOrderDetailSSID]
				, STG.[RefundedTotalQuantity]
				, STG.[RefundedTotalPrice]
				, STG.[Employee1SSID]
				, STG.[Employee1FirstName]
				, STG.[Employee1LastName]
				, STG.[Employee1Initials]
				, STG.[Employee2SSID]
				, STG.[Employee2FirstName]
				, STG.[Employee2LastName]
				, STG.[Employee2Initials]
				, STG.[Employee3SSID]
				, STG.[Employee3FirstName]
				, STG.[Employee3LastName]
				, STG.[Employee3Initials]
				, STG.[Employee4SSID]
				, STG.[Employee4FirstName]
				, STG.[Employee4LastName]
				, STG.[Employee4Initials]
				, STG.[Performer_Temp]
				, STG.[Performer2_Temp]
				, STG.[CancelReasonID]
				, STG.[Member1Price_Temp]
				, STG.[PreviousClientMembershipSSID]
				, STG.[NewCenterSSID]
				, STG.[MembershipOrderReasonID]
				, STG.[MembershipPromotion]
				, STG.[HairSystemOrderSSID]
				, STG.[ClientMembershipAddOnID]
				, 1 -- [RowIsCurrent]
				, STG.[ModifiedDate] -- [RowStartDate]
				, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
				, 'SCD Type 2' -- [RowChangeReason]
				, 0
				, @DataPkgKey
				, -2 -- 'Not Updated Yet'
			FROM [bi_cms_stage].[DimSalesOrderDetail] STG
			WHERE	STG.[IsType2] = 1
				AND	STG.[IsException] = 0
				AND STG.[DataPkgKey] = @DataPkgKey


		SET @InsertSCD2RowCnt = @@ROWCOUNT

		-- Determine the number of exception rows
		SELECT @ExceptionRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimSalesOrderDetail] STG
		WHERE STG.[IsException] = 1
			AND STG.[DataPkgKey] = @DataPkgKey

		-- Determine the number of inserted and updated rows
		SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt

		-- Determine the number of ignored rows
		SELECT @IgnoreRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimSalesOrderDetail] STG
		WHERE STG.[IsException] = 0
		AND STG.[IsNew] = 0
		AND STG.[IsType1] = 0
		AND STG.[IsType2] = 0
		OR STG.[IsDuplicate] = 1
		AND STG.[DataPkgKey] = @DataPkgKey


		-- Determine Final Row Cnt
		SELECT @FinalRowCnt = COUNT(1) FROM [bi_cms_stage].[synHC_DDS_DimSalesOrderDetail]


		-- Determine the number of Fixed rows
		SELECT @FixedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimSalesOrderDetail] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsFixed] = 1

		-- Determine the number of Allowed rows
		SELECT @AllowedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimSalesOrderDetail] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsAllowed] = 1

		-- Determine the number of Rejected rows
		SELECT @RejectedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimSalesOrderDetail] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 1

		-- Determine the number of Healthy rows
		SELECT @HealthyRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimSalesOrderDetail] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 0
		AND STG.[IsAllowed] = 0
		AND STG.[IsFixed] = 0

		-- Determine the number of Duplicate rows
		SELECT @DuplicateRowCnt = COUNT(1)
		FROM [bi_cms_stage].[DimSalesOrderDetail] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDuplicate] = 1

		-- Determine the number of Deleted rows
		--SELECT @DeletedRowCnt = COUNT(1)
		--FROM [bi_cms_stage].[DimSalesOrderDetail] STG
		--WHERE STG.[DataPkgKey] = @DataPkgKey
		--AND STG.[IsDelete] = 1


		-----------------------
		-- Flag records as validated
		-----------------------
		UPDATE STG SET
			IsLoaded = 1
		FROM [bi_cms_stage].[DimSalesOrderDetail] STG
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
