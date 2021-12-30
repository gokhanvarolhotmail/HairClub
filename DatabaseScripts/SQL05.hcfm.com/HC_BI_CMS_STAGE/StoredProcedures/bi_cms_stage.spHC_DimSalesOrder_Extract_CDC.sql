/* CreateDate: 05/03/2010 12:20:16.463 , ModifyDate: 11/20/2013 11:51:55.733 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimSalesOrder_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimSalesOrder_Extract_CDC] is used to retrieve a
-- list SalesOrder
--
--   exec [bi_cms_stage].[spHC_DimSalesOrder_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    05/27/2009  RLifke       Initial Creation
--			07/01/2011  KMurdoch	 Added IsSurgeryReversalFlag
--			04/03/2013  KMurdoch     Modified isRefundedFlag to not be null
--			05/28/2013  KMurdoch	 Added IsGuaranteeFlag
--          11/20/2013  KMurdoch     Added IncomingRequestID
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
				, @CDCTableName			varchar(150)	-- Name of CDC table
				, @ExtractRowCnt		int

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrder]'
 	SET @CDCTableName = N'dbo_datSalesOrder'


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

				DECLARE	@Start_Time datetime = null,
						@End_Time datetime = null,
						@row_filter_option nvarchar(30) = N'all'

				DECLARE @From_LSN binary(10), @To_LSN binary(10)

				SET @Start_Time = @LSET
				SET @End_Time = @CET

				IF (@Start_Time is null)
					SELECT @From_LSN = [HairClubCMS].[sys].[fn_cdc_get_min_lsn](@CDCTableName)
				ELSE
				BEGIN
					IF ([HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_min_lsn](@CDCTableName)) > @Start_Time) or
					   ([HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_max_lsn]()) < @Start_Time)
						SELECT @From_LSN = null
					ELSE
						SELECT @From_LSN = [HairClubCMS].[sys].[fn_cdc_increment_lsn]([HairClubCMS].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@Start_Time))
				END

				IF (@End_Time is null)
					SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_get_max_lsn]()
				ELSE
				BEGIN
					IF [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_max_lsn]()) < @End_Time
						--SELECT @To_LSN = null
						SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_get_max_lsn]()
					ELSE
						SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@End_Time)
				END


				-- Get the Actual Current Extraction Time
				SELECT @CET = [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time](@To_LSN)

				IF (@From_LSN IS NOT NULL) AND (@To_LSN IS NOT NULL) AND (@From_LSN <> [HairClubCMS].[sys].[fn_cdc_increment_lsn](@To_LSN))
					BEGIN

						-- Set the Current Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET CET = @CET
								, [Status] = 'Extracting'
							WHERE [TableName] = @TableName


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
								   , [CDC_Operation]
									)
						SELECT @DataPkgKey
								, NULL AS [SalesOrderKey]
								, COALESCE(chg.[SalesOrderGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [SalesOrderSSID]
								, COALESCE(chg.[TenderTransactionNumber_Temp], '') AS [TenderTransactionNumber_Temp]
								, COALESCE(chg.[TicketNumber_Temp], '') AS [TicketNumber_Temp]
								, 0 AS [CenterKey]
								, COALESCE(chg.[CenterID],-2) AS [CenterSSID]
								, 0 AS [ClientHomeCenterKey]
								, COALESCE(chg.[ClientHomeCenterID],-2) AS [ClientHomeCenterSSID]
								, 0 AS [SalesOrderTypeKey]
								, COALESCE(chg.[SalesOrderTypeID],-2) AS [SalesOrderTypeSSID]
								, 0 AS [ClientKey]
								, COALESCE(chg.[ClientGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [ClientSSID]
								, 0 AS [ClientMembershipKey]
								, COALESCE(chg.[ClientMembershipGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [ClientMembershipSSID]
								, chg.[OrderDate] AS [OrderDate]
								, COALESCE(chg.[InvoiceNumber], '') AS [InvoiceNumber]
								, CAST(chg.IsTaxExemptFlag AS TINYINT) AS [IsTaxExemptFlag]
								, CAST(chg.IsVoidedFlag AS TINYINT) AS [IsVoided]
								, CAST(chg.IsClosedFlag AS TINYINT) AS [IsClosed]
								, 0 AS [EmployeeKey]
								, COALESCE(chg.[EmployeeGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [EmployeeSSID]
								, COALESCE(chg.[FulfillmentNumber], '') AS [FulfillmentNumber]
								, CAST(chg.IsWrittenOffFlag AS TINYINT) AS [IsWrittenOffFlag]
								, CAST(ISNULL(chg.IsRefundedFlag,0) AS TINYINT) AS [IsRefundedFlag]
								, 0 AS [RefundedSalesOrderKey]
								, COALESCE(chg.[RefundedSalesOrderGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [RefundedSalesOrderSSID]
								, COALESCE([IsSurgeryReversalFlag], 0) as [IsSurgeryReversalFlag]
								, COALESCE([IsGuaranteeFlag], 0) as [IsGuaranteeFlag]
								, IncomingRequestID
								, [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time](__$start_lsn) AS [ModifiedDate]
								, 0 AS [IsNew]
								, 0 AS [IsType1]
								, 0 AS [IsType2]
								, 0 AS [IsException]
								, 0 AS [IsInferredMember]
								, 0 AS [IsDelete]
								, 0 AS [IsDuplicate]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[SalesOrderGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
								, CASE [__$operation]
										WHEN 1 THEN 'D'
										WHEN 2 THEN 'I'
										WHEN 3 THEN 'UO'
										WHEN 4 THEN 'UN'
										WHEN 5 THEN 'M'
										ELSE NULL
									END AS [CDC_Operation]
						FROM [HairClubCMS].[cdc].[fn_cdc_get_net_changes_dbo_datSalesOrder](@From_LSN, @To_LSN, @row_filter_option) chg

						SET @ExtractRowCnt = @@ROWCOUNT

						-- Set the Last Successful Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET LSET = @CET
								, [Status] = 'Extraction Completed'
							WHERE [TableName] = @TableName

					END
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
