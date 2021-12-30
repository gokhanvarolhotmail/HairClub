/* CreateDate: 05/03/2010 12:20:22.727 , ModifyDate: 06/10/2014 07:58:23.600 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactSalesTransactionTender_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_FactSalesTransactionTender_Extract_CDC] is used to retrieve a
-- list SalesOrder
--
--   exec [bi_cms_stage].[spHC_FactSalesTransactionTender_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    05/27/2009  RLifke       Initial Creation
--          10/31/2012  EKnapp		 Added the CDC Operation code
--			10/16/2013	MBurrell	 Updated procedure to default tender to 0 if NULL
--			06/10/2014  KMurdoch     Added AccountID
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

 	SET @TableName = N'[bi_cms_dds].[FactSalesTransactionTender]'
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


							INSERT INTO [bi_cms_stage].[FactSalesTransactionTender]
									   ( [DataPkgKey]
										, [OrderDateKey]
										, [OrderDate]
										, [SalesOrderTypeKey]
										, [SalesOrderTypeSSID]
										, [CenterKey]
										, [CenterSSID]
										, [ClientKey]
										, [ClientSSID]
										, [MembershipKey]
										, [ClientMembershipKey]
										, [ClientMembershipSSID]
										, [TenderTypeKey]
										, [TenderTypeSSID]
										, [SalesOrderSSID]
										, [SalesOrderTenderSSID]
										, [SalesOrderTenderKey]
										, [TenderAmount]
										, [IsVoided]
										, [IsClosed]
										, [AccountID]

										, [IsException]
										, [IsDelete]
										, [IsDuplicate]
										, [SourceSystemKey]
										, [CDC_Operation]
										)
							SELECT @DataPkgKey
										, 0 AS [OrderDateKey]
										--Converting OrderDate to UTC
										--, chg.[OrderDate] AS [OrderDate]
										,[bief_stage].[fn_GetUTCDateTime](so.[OrderDate], so.[CenterID])
										, 0 AS [SalesOrderTypeKey]
										, COALESCE(so.[SalesOrderTypeID],-2) AS [SalesOrderTypeSSID]
										, 0 AS [CenterKey]
										, COALESCE(so.[CenterID],-2) AS [CenterSSID]
										, 0 AS [ClientKey]
										, so.[ClientGUID] AS [ClientSSID]
										, 0 AS [MembershipKey]
										, 0 AS [ClientMembershipKey]
										, so.[ClientMembershipGUID] AS [ClientMembershipSSID]
										, 0 AS [TenderTypeKey]
										, COALESCE(chg.[TenderTypeID],-2) AS [TenderTypeSSID]
										, chg.[SalesOrderGUID] AS [SalesOrderSSID]
										, chg.[SalesOrderTenderGUID] AS [SalesOrderTenderSSID]
										, DWTend.SalesOrderTenderKey
										, ISNULL(chg.[Amount], 0) AS [Amount]
										, CAST(so.IsVoidedFlag AS TINYINT) AS [IsVoided]
										, CAST(so.IsClosedFlag AS TINYINT) AS [IsClosed]
										, CASE WHEN so.SalesOrderTypeID = 3 then glfo.GeneralLedgerDescriptionShort
												ELSE glso.GeneralLedgerDescriptionShort end
										, 0 AS [IsException]
										, 0 AS [IsDelete]
										, 0 AS [IsDuplicate]
										, CAST(ISNULL(LTRIM(RTRIM(chg.[SalesOrderTenderGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
										, CASE [__$operation]
										WHEN 1 THEN 'D'
										WHEN 2 THEN 'I'
										WHEN 3 THEN 'UO'
										WHEN 4 THEN 'UN'
										WHEN 5 THEN 'M'
										ELSE NULL
									END AS [CDC_Operation]
							FROM [HairClubCMS].[cdc].[fn_cdc_get_net_changes_dbo_datSalesOrderTender](@From_LSN, @To_LSN, @row_filter_option) chg
							INNER JOIN	  [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrder] so
								ON chg.[SalesOrderGUID] = so.[SalesOrderGUID]
						    LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderTender DWTend
								on chg.[SalesOrderTenderGUID] = DWTend.SalesOrderTenderSSID AND __$operation=1 -- look up the salesordertenderkey right away here	for deleted rows
							INNER JOIN [HairClubCMS].dbo.lkpTenderType tt with (nolock)
								ON tt.TenderTypeID = chg.TenderTypeID
							LEFT OUTER JOIN [HairClubCMS].dbo.lkpGeneralLedger GLSO with (nolock)
								ON tt.GeneralLedgerID = GLSO.GeneralLedgerID
							LEFT OUTER JOIN [HairClubCMS].dbo.lkpGeneralLedger GLFO with (nolock)
								ON tt.EFTGeneralLedgerID = GLFO.GeneralLedgerID
							WHERE (so.IsClosedFlag = 1 AND  so.IsVoidedFlag = 0) OR (__$operation = 1)

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
