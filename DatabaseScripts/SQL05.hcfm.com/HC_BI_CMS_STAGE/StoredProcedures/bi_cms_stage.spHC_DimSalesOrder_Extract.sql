/* CreateDate: 05/03/2010 12:20:14.350 , ModifyDate: 11/20/2013 11:52:02.073 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimSalesOrder_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimSalesOrder_Extract] is used to retrieve a
-- list Sales Orders
--
--   exec [bi_cms_stage].[spHC_DimSalesOrder_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/08/2009  RLifke       Initial Creation
--			07/01/2011  KMurdoch	 Added IsSurgeryReversalFlag
--			01/03/2013  EKnapp       Use UTC Current Extraction Time.
--			04/03/2013  KMurdoch	 Modified isrefunded flag to not be null
--			05/28/2013  KMurdoch	 Added IsGuaranteeFlag
--			11/20/2013  KMurdoch     Added IncomingRequestID
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
				, @CET_UTC              datetime

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrder]'


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

				-- Convert our Current Extraction Time to UTC time for compare in the Where clause to ensure we pick up latest data.
				SELECT @CET_UTC = [bief_stage].[fn_CorporateToUTCDateTime](@CET)

				INSERT INTO [bi_cms_stage].[DimSalesOrder]
						   ( [DataPkgKey]
						   , [SalesOrderKey]
						   , [SalesOrderSSID]
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
						   , [ModifiedDate]
						   , [IsNew]
						   , [IsType1]
						   , [IsType2]
						   , [IsException]
						   , [IsInferredMember]
							, [IsDelete]
							, [IsDuplicate]
						   , [SourceSystemKey]
							)
				SELECT @DataPkgKey
						, NULL AS [SalesOrderKey]
						, COALESCE(so.[SalesOrderGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [SalesOrderSSID]
						, COALESCE(so.[TenderTransactionNumber_Temp], '') AS [TenderTransactionNumber_Temp]
						, COALESCE(so.[TicketNumber_Temp], '') AS [TicketNumber_Temp]
						, 0 AS [CenterKey]
						, COALESCE(so.[CenterID],-2) AS [CenterSSID]
						, 0 AS [ClientHomeCenterKey]
						, COALESCE(so.[ClientHomeCenterID],-2) AS [ClientHomeCenterSSID]
						, 0 AS [SalesOrderTypeKey]
						, COALESCE(so.[SalesOrderTypeID],-2) AS [SalesOrderTypeSSID]
						, 0 AS [ClientKey]
						, COALESCE(so.[ClientGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [ClientSSID]
						, 0 AS [ClientMembershipKey]
						, COALESCE(so.[ClientMembershipGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [ClientMembershipSSID]
						, so.[OrderDate] AS [OrderDate]
						, COALESCE(so.[InvoiceNumber], '') AS [InvoiceNumber]
						, CAST(so.IsTaxExemptFlag AS TINYINT) AS [IsTaxExemptFlag]
						, CAST(so.IsVoidedFlag AS TINYINT) AS [IsVoided]
						, CAST(so.IsClosedFlag AS TINYINT) AS [IsClosed]
						, 0 AS [EmployeeKey]
						, COALESCE(so.[EmployeeGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [EmployeeSSID]
						, COALESCE(so.[FulfillmentNumber], '') AS [FulfillmentNumber]
						, CAST(so.IsWrittenOffFlag AS TINYINT) AS [IsWrittenOffFlag]
						, CAST(ISNULL(so.IsRefundedFlag,0) AS TINYINT) AS [IsRefundedFlag]
						, 0 AS [RefundedSalesOrderKey]
						, COALESCE(so.[RefundedSalesOrderGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [RefundedSalesOrderSSID]
						, COALESCE([IsSurgeryReversalFlag],0) as [IsSurgeryReversalFlag]
						, COALESCE([IsGuaranteeFlag],0) as [IsGuaranteeFlag]
						, [IncomingRequestID]
						, so.[LastUpdate] AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, CAST(ISNULL(LTRIM(RTRIM(so.[SalesOrderGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrder] so
				WHERE ([CreateDate] >= @LSET AND [CreateDate] < @CET_UTC)
				   OR ([LastUpdate] >= @LSET AND [LastUpdate] < @CET_UTC)

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
