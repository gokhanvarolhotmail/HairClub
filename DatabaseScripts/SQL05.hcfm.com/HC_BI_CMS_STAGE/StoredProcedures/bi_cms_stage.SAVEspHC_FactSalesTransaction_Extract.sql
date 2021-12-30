/* CreateDate: 05/24/2012 14:04:30.867 , ModifyDate: 05/24/2012 14:04:30.867 */
GO
CREATE PROCEDURE [bi_cms_stage].[SAVEspHC_FactSalesTransaction_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_FactSalesTransaction_Extract] is used to retrieve a
-- list Sales Transactions
--
--   exec [bi_cms_stage].[spHC_FactSalesTransaction_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    03/19/2009  RLifke       Initial Creation
--			07/14/2011	KMurdoch	 Removed logic for IsClosed or IsVoided
--			03/07/2012	KMurdoch	 Added Isnull statement for ClientMembershipGUID
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

 	SET @TableName = N'[bi_cms_dds].[FactSalesTransaction]'


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


				INSERT INTO [bi_cms_stage].[FactSalesTransaction]
						   ( [DataPkgKey]
							, [OrderDateKey]
							, [OrderDate]
							, [SalesOrderKey]
							, [SalesOrderSSID]
							, [SalesOrderDetailKey]
							, [SalesOrderDetailSSID]
							, [SalesOrderTypeKey]
							, [SalesOrderTypeSSID]
							, [CenterKey]
							, [CenterSSID]
							, [ClientKey]
							, [ClientSSID]
							, [MembershipKey]
							, [ClientMembershipKey]
							, [ClientMembershipSSID]
							, [SalesCodeKey]
							, [SalesCodeSSID]
							, [Employee1Key]
							, [Employee1SSID]
							, [Employee2Key]
							, [Employee2SSID]
							, [Employee3Key]
							, [Employee3SSID]
							, [Employee4Key]
							, [Employee4SSID]
							, [Quantity]
							, [Price]
							, [Discount]
							, [Tax1]
							, [Tax2]
							, [TaxRate1]
							, [TaxRate2]
							, [IsClosed]
							, [IsVoided]

							, [IsException]
							, [IsDelete]
							, [IsDuplicate]
							, [SourceSystemKey]
							)

					SELECT	  @DataPkgKey
							, 0 AS [OrderDateKey]
							--Converting OrderDate to UTC
							--, so.[OrderDate] AS [OrderDate]
							,[bief_stage].[fn_GetUTCDateTime](so.[OrderDate], so.[CenterID])
							, 0 AS [SalesOrderKey]
							, so.[SalesOrderGUID] AS [SalesOrderSSID]
							, 0 AS [SalesOrderDetailKey]
							, sod.[SalesOrderDetailGUID] AS [SalesOrderDetailSSID]
							, 0 AS [SalesOrderTypeKey]
							, COALESCE(so.[SalesOrderTypeID],-2) AS [SalesOrderTypeSSID]
							, 0 AS [CenterKey]
							, COALESCE(so.[CenterID],-2) AS [CenterSSID]
							, 0 AS [ClientKey]
							, so.[ClientGUID] AS [ClientSSID]
							, 0 AS [MembershipKey]
							, 0 AS [ClientMembershipKey]
							, CASE WHEN so.CENTERID LIKE '[1278]%' THEN
											ISNULL(sod.[PreviousClientMembershipGUID],so.[ClientMembershipGUID])
										ELSE
											so.[ClientMembershipGUID]
										END AS [ClientMembershipSSID]
							, 0 AS [SalesCodeKey]
							, COALESCE(sod.[SalesCodeID],-2) AS [SalesCodeSSID]
							, 0 AS [Employee1Key]
							, COALESCE( sod.[Employee1GUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [Employee1SSID]
							, 0 AS [Employee2Key]
							, COALESCE(sod.[Employee2GUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [Employee2SSID]
							, 0 AS [Employee3Key]
							, COALESCE(sod.[Employee3GUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [Employee3SSID]
							, 0 AS [Employee4Key]
							, COALESCE(sod.[Employee4GUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [Employee4SSID]
							, COALESCE(sod.[Quantity],0) AS [Quantity]
							, COALESCE(sod.[Price],0) AS [Price]
							, COALESCE(sod.[Discount],0) AS [Discount]
							, COALESCE(sod.[Tax1],0) AS [Tax1]
							, COALESCE(sod.[Tax2],0) AS [Tax2]
							, COALESCE(sod.[TaxRate1],0) AS [TaxRate1]
							, COALESCE(sod.[TaxRate2],0) AS [TaxRate2]
							, CAST(so.IsClosedFlag AS TINYINT) AS [IsClosed]
							, CAST(so.IsVoidedFlag AS TINYINT) AS [IsVoided]
							, 0 AS [IsException]
							, 0 AS [IsDelete]
							, 0 AS [IsDuplicate]
							, CAST(ISNULL(LTRIM(RTRIM(sod.[SalesOrderDetailGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
					FROM	[bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrder] so
							INNER JOIN  [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrderDetail] sod
								  ON so.[SalesOrderGUID] = sod.[SalesOrderGUID]

				WHERE ((so.[CreateDate] >= @LSET AND so.[CreateDate] < @CET)
				   OR (so.[LastUpdate] >= @LSET AND so.[LastUpdate] < @CET))
					AND (so.IsClosedFlag = 1 AND  so.IsVoidedFlag = 0)


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
