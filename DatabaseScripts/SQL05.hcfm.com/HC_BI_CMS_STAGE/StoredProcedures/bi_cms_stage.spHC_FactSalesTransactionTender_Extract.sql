/* CreateDate: 05/03/2010 12:20:20.677 , ModifyDate: 06/10/2014 07:54:34.837 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactSalesTransactionTender_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_FactSalesTransactionTender_Extract] is used to retrieve a
-- list Sales Transactions
--
--   exec [bi_cms_stage].[spHC_FactSalesTransactionTender_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/13/2009  RLifke       Initial Creation
--			07/14/2011	KMurdoch	 Removed logic for IsClosed or IsVoided
--			01/03/2013  EKnapp       Use UTC Current Extraction Time.
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
				, @ExtractRowCnt		int
				, @CET_UTC              datetime

 	SET @TableName = N'[bi_cms_dds].[FactSalesTransactionTender]'


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
							, [TenderAmount]
							, [IsVoided]
							, [IsClosed]
							, [AccountID]

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
							, COALESCE(sot.[TenderTypeID],-2) AS [TenderTypeSSID]
							, sot.[SalesOrderGUID] AS [SalesOrderSSID]
							, sot.[SalesOrderTenderGUID] AS [SalesOrderTenderSSID]
							, ISNULL(sot.[Amount], 0) AS [Amount]
							, CAST(so.IsVoidedFlag AS TINYINT) AS [IsVoided]
							, CAST(so.IsClosedFlag AS TINYINT) AS [IsClosed]
							, CASE WHEN so.SalesOrderTypeID = 3 then glfo.GeneralLedgerDescriptionShort
									ELSE glso.GeneralLedgerDescriptionShort end
							, 0 AS [IsException]
							, 0 AS [IsDelete]
							, 0 AS [IsDuplicate]
							, CAST(ISNULL(LTRIM(RTRIM(sot.[SalesOrderTenderGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
					FROM	[bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrder] so
						INNER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrderTender] sot
							ON so.[SalesOrderGUID] = sot.[SalesOrderGUID]
						INNER JOIN [HairClubCMS].dbo.lkpTenderType tt with (nolock)
							ON tt.TenderTypeID = sot.TenderTypeID
						LEFT OUTER JOIN [HairClubCMS].dbo.lkpGeneralLedger GLSO with (nolock)
							ON tt.GeneralLedgerID = GLSO.GeneralLedgerID
						LEFT OUTER JOIN [HairClubCMS].dbo.lkpGeneralLedger GLFO with (nolock)
							ON tt.EFTGeneralLedgerID = GLFO.GeneralLedgerID

				WHERE ((so.[CreateDate] >= @LSET AND so.[CreateDate] < @CET_UTC)
				   OR (so.[LastUpdate] >= @LSET AND so.[LastUpdate] < @CET_UTC))
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
