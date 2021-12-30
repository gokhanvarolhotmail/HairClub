/* CreateDate: 05/03/2010 12:20:25.893 , ModifyDate: 05/01/2013 11:00:21.650 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactSales_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_FactSales_Extract] is used to retrieve a
-- list Sales Transactions
--
--   exec [bi_cms_stage].[spHC_FactSales_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    07/01/2009  RLifke       Initial Creation
--			01/03/2013  EKnapp       Use UTC Current Extraction Time. Also include logic to pick up sales detail table changes.
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

 	SET @TableName = N'[bi_cms_dds].[FactSales]'


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

				-- declare table variable
				create table #DetailChangedOrders(SalesOrderGUID uniqueidentifier, MaxLastUpdate datetime)

				--
				-- Select distinct SalesOrderGUIDs where the Maximum LastUpdate date for any sales detail row changed since the Last extract.
				--
				INSERT INTO #DetailChangedOrders(SalesOrderGUID, MaxLastUpdate)
				SELECT sod.SalesOrderGUID,  MAX(sod.LastUpdate)
				FROM HairClubCMS.dbo.datSalesOrderDetail sod with (nolock)
				JOIN HairClubCMS.dbo.datSalesOrder so with (nolock)
					ON sod.SalesOrderGUID=so.SalesOrderGUID
				WHERE sod.LastUpdate >= @LSET AND CAST(so.IsClosedFlag AS INT) = 1 AND  CAST(so.IsVoidedFlag AS INT) = 0
				GROUP BY sod.SalesOrderGUID

				INSERT INTO [bi_cms_stage].[FactSales]
						   ( [DataPkgKey]
							, [OrderDateKey]
							, [OrderDate]
							, [SalesOrderKey]
							, [SalesOrderSSID]
							, [SalesOrderTypeKey]
							, [SalesOrderTypeSSID]
							, [CenterKey]
							, [CenterSSID]
							, [ClientHomeCenterKey]
							, [ClientHomeCenterSSID]
							, [ClientKey]
							, [ClientSSID]
							, [MembershipKey]
							, [ClientMembershipKey]
							, [ClientMembershipSSID]
							, [EmployeeKey]
							, [EmployeeSSID]
							, [IsRefunded]
							, [IsTaxExempt]
							, [IsWrittenOff]
							, [IsVoided]
							, [IsClosed]
							, [TotalDiscount]
							, [TotalTax]
							, [TotalExtendedPrice]
							, [TotalExtendedPricePlusTax]
							, [TotalTender]

							, [IsException]
							, [IsDelete]
							, [IsDuplicate]
							, [SourceSystemKey]
							)

					SELECT	  @DataPkgKey
							, 0 AS [OrderDateKey]
							--Converting OrderDate to UTC
							--, so.OrderDate
							,[bief_stage].[fn_GetUTCDateTime](so.OrderDate, so.[CenterID])
							, NULL AS [SalesOrderKey]
							, COALESCE(so.[SalesOrderGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [SalesOrderSSID]
							, 0 AS [SalesOrderTypeKey]
							, COALESCE(so.[SalesOrderTypeID],-2) AS [SalesOrderTypeSSID]
							, 0 AS [CenterKey]
							, COALESCE(so.[CenterID],-2) AS [CenterSSID]
							, 0 AS [ClientHomeCenterKey]
							, COALESCE(so.[ClientHomeCenterID],-2) AS [ClientHomeCenterSSID]
							, 0 AS [ClientKey]
							, COALESCE(so.[ClientGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [ClientSSID]
							, 0 AS [MembershipKey]
							, 0 AS [ClientMembershipKey]
							, COALESCE(so.[ClientMembershipGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [ClientMembershipSSID]
							, 0 AS [EmployeeKey]
							, COALESCE(so.[EmployeeGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [EmployeeSSID]
							, CAST(so.IsRefundedFlag AS INT) AS IsRefunded
							, CAST(so.IsTaxExemptFlag AS INT) AS IsTaxExempt
							, CAST(so.IsWrittenOffFlag AS INT) AS IsWrittenOff
							, CAST(so.IsVoidedFlag AS INT) AS IsVoided
							, CAST(so.IsClosedFlag AS INT) AS IsClosed
							, COALESCE(SUM(sod.Discount),0) AS TotalDiscount
							, COALESCE(SUM(sod.TotalTaxCalc),0) AS TotalTax
							, COALESCE(SUM(sod.ExtendedPriceCalc),0) AS TotalExtendedPrice
							, COALESCE(SUM(sod.PriceTaxCalc),0) AS TotalExtendedPricePlusTax
							, COALESCE((SELECT SUM(Amount)
										FROM [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrderTender] sot
 										WHERE  sot.SalesOrderGUID = so.SalesOrderGUID),0) AS TotalTender
							--, COALESCE(SUM(sot.Amount),0) AS TotalTender
							, 0 AS [IsException]
							, 0 AS [IsDelete]
							, 0 AS [IsDuplicate]
							, CAST(ISNULL(LTRIM(RTRIM(so.[SalesOrderGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
					FROM         [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrder] so
							LEFT OUTER JOIN	[bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrderDetail] sod ON so.SalesOrderGUID = sod.SalesOrderGUID
							LEFT JOIN #DetailChangedOrders temp on so.SalesOrderGUID=temp.SalesOrderGUID
					GROUP BY	  so.SalesOrderGUID
								, so.CenterID
								, so.ClientHomeCenterID
								, so.SalesOrderTypeID
								, so.ClientGUID
								, so.ClientMembershipGUID
								, so.EmployeeGUID
								, so.OrderDate
								, CAST(so.IsWrittenOffFlag AS INT)
								, CAST(so.IsTaxExemptFlag AS INT)
								, CAST(so.IsRefundedFlag AS INT)
								, CAST(so.IsVoidedFlag AS INT)
								, CAST(so.IsClosedFlag AS INT)
								, so.CreateDate
								, so.LastUpdate
								, isnull(temp.MaxLastUpdate,'1/1/1980')
					HAVING ( (so.[CreateDate] >= @LSET AND so.[CreateDate] < @CET_UTC)
						   OR (so.[LastUpdate] >= @LSET AND so.[LastUpdate] < @CET_UTC)
						   OR (isnull(temp.MaxLastUpdate,'1/1/1980') >= @LSET ) )

							AND (CAST(so.IsClosedFlag AS INT) = 1 AND  CAST(so.IsVoidedFlag AS INT) = 0)


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
