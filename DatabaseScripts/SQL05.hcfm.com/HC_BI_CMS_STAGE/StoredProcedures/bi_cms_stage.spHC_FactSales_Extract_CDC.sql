/* CreateDate: 05/03/2010 12:20:27.913 , ModifyDate: 05/01/2013 10:47:35.197 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactSales_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_FactSales_Extract_CDC] is used to retrieve a
-- list SalesOrder
--
--   exec [bi_cms_stage].[spHC_FactSales_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    07/01/2009  RLifke       Initial Creation
--			01/03/2013  EKnapp       Include logic to pick up sales detail table changes.
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
				, @CDCTableNameDtl		varchar(150)	-- Name of CDC table
				, @ExtractRowCnt		int

 	SET @TableName = N'[bi_cms_dds].[FactSales]'
 	SET @CDCTableName = N'dbo_datSalesOrder'
 	SET @CDCTableNameDtl = N'dbo_datSalesOrderDetail'

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
					   ([HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_min_lsn](@CDCTableNameDtl)) > @Start_Time) or
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

						--- Get a unique list of SalesOrderGuids where either the Sales order or Sales Order detail was changed.
							DECLARE @ChangedSalesOrders as table(id int identity(1,1),SalesOrderGUID uniqueidentifier)
							create table #DistinctChangedSO (id int identity(1,1),SalesOrderGUID uniqueidentifier)

							INSERT INTO @ChangedSalesOrders
							select distinct(SalesOrderGUID) FROM [HairClubCMS].[cdc].[fn_cdc_get_net_changes_dbo_datSalesOrder](@From_LSN, @To_LSN, @row_filter_option)
									UNION
							select distinct(SalesOrderGUID) FROM [HairClubCMS].[cdc].[fn_cdc_get_net_changes_dbo_datSalesOrderDetail](@From_LSN, @To_LSN, @row_filter_option)

							-- Now just the unique sales orders from all changes into the DistinctChangedSO table
							INSERT INTO #DistinctChangedSO
							select distinct(SalesOrderGUID) FROM  @ChangedSalesOrders

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
							SELECT @DataPkgKey
									, 0 AS [OrderDateKey]
									--Converting OrderDate to UTC
									--, chg.OrderDate
									,[bief_stage].[fn_GetUTCDateTime](chg.OrderDate, chg.[CenterID])
									, NULL AS [SalesOrderKey]
									, COALESCE(chg.[SalesOrderGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [SalesOrderSSID]
									, 0 AS [SalesOrderTypeKey]
									, COALESCE(chg.[SalesOrderTypeID],-2) AS [SalesOrderTypeSSID]
									, 0 AS [CenterKey]
									, COALESCE(chg.[CenterID],-2) AS [CenterSSID]
									, 0 AS [ClientHomeCenterKey]
									, COALESCE(chg.[ClientHomeCenterID],-2) AS [ClientHomeCenterSSID]
									, 0 AS [ClientKey]
									, COALESCE(chg.[ClientGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [ClientSSID]
									, 0 AS [MembershipKey]
									, 0 AS [ClientMembershipKey]
									, COALESCE(chg.[ClientMembershipGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [ClientMembershipSSID]
									, 0 AS [EmployeeKey]
									, COALESCE(chg.[EmployeeGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [EmployeeSSID]
									, CAST(chg.IsRefundedFlag AS INT) AS IsRefunded
									, CAST(chg.IsTaxExemptFlag AS INT) AS IsTaxExempt
									, CAST(chg.IsWrittenOffFlag AS INT) AS IsWrittenOff
									, CAST(chg.IsVoidedFlag AS INT) AS IsVoided
									, CAST(chg.IsClosedFlag AS INT) AS IsClosed
									, COALESCE(SUM(sod.Discount),0) AS TotalDiscount
									, COALESCE(SUM(sod.TotalTaxCalc),0) AS TotalTax
									, COALESCE(SUM(sod.ExtendedPriceCalc),0) AS TotalExtendedPrice
									, COALESCE(SUM(sod.PriceTaxCalc),0) AS TotalExtendedPricePlusTax
									, COALESCE((SELECT SUM(Amount)
												FROM [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrderTender] sot
 												WHERE  sot.SalesOrderGUID = chg.SalesOrderGUID),0) AS TotalTender
									--, COALESCE(SUM(sot.Amount),0) AS TotalTender
									, 0 AS [IsException]
									, 0 AS [IsDelete]
									, 0 AS [IsDuplicate]
									, CAST(ISNULL(LTRIM(RTRIM(chg.[SalesOrderGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
							FROM #DistinctChangedSO temp
							        JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrder] chg ON temp.SalesOrderGUID = chg.SalesOrderGUID
									LEFT OUTER JOIN	[bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrderDetail] sod ON chg.SalesOrderGUID = sod.SalesOrderGUID

							GROUP BY	  chg.SalesOrderGUID
										, chg.CenterID
										, chg.ClientHomeCenterID
										, chg.SalesOrderTypeID
										, chg.ClientGUID
										, chg.ClientMembershipGUID
										, chg.EmployeeGUID
										, chg.OrderDate
										, CAST(chg.IsWrittenOffFlag AS INT)
										, CAST(chg.IsTaxExemptFlag AS INT)
										, CAST(chg.IsRefundedFlag AS INT)
										, CAST(chg.IsVoidedFlag AS INT)
										, CAST(chg.IsClosedFlag AS INT)
							HAVING (CAST(chg.IsClosedFlag AS INT) = 1 AND  CAST(chg.IsVoidedFlag AS INT) = 0)

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
