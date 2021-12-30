/* CreateDate: 05/03/2010 12:20:09.937 , ModifyDate: 08/12/2013 15:24:27.193 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimSalesOrderTender_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimSalesOrderTender_Extract] is used to retrieve a
-- list Sales Order Tender
--
--   exec [bi_cms_stage].[spHC_DimSalesOrderTender_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/08/2009  RLifke       Initial Creation
--			01/03/2013  EKnapp       Use UTC Current Extraction Time.
--          08/12/2013  EKnapp       Strip out line feed carriage returns from approval code
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrderTender]'


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


				INSERT INTO [bi_cms_stage].[DimSalesOrderTender]
						   (  [DataPkgKey]
							, [SalesOrderTenderKey]
							, [SalesOrderTenderSSID]
							, [SalesOrderKey]
							, [SalesOrderSSID]
							, [OrderDate]
							, [TenderTypeSSID]
							, [TenderTypeDescription]
							, [TenderTypeDescriptionShort]
							, [IsVoidedFlag]
							, [IsClosedFlag]
							, [Amount]
							, [CheckNumber]
							, [CreditCardLast4Digits]
							, [ApprovalCode]
							, [CreditCardTypeSSID]
							, [CreditCardTypeDescription]
							, [CreditCardTypeDescriptionShort]
							, [FinanceCompanySSID]
							, [FinanceCompanyDescription]
							, [FinanceCompanyDescriptionShort]
							, [InterCompanyReasonSSID]
							, [InterCompanyReasonDescription]
							, [InterCompanyReasonDescriptionShort]
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
						, NULL AS [SalesOrderTenderKey]
 						, COALESCE(sot.[SalesOrderTenderGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [SalesOrderTenderSSID]
						, 0 AS [SalesOrderKey]
						, COALESCE(so.[SalesOrderGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [SalesOrderSSID]
						, COALESCE(so.[OrderDate], '12/31/9999') AS [OrderDate]
						, COALESCE(sot.[TenderTypeID], '') AS [TenderTypeSSID]
						, COALESCE(td.[TenderTypeDescription], '') AS [TenderTypeDescription]
						, COALESCE(td.[TenderTypeDescriptionShort], '') AS [TenderTypeDescriptionShort]
						, CAST(COALESCE(so.IsVoidedFlag,0) AS TINYINT) AS [IsVoided]
						, CAST(COALESCE(so.IsClosedFlag,0) AS TINYINT) AS [IsClosed]
 						, COALESCE(sot.[Amount],0) AS [Amount]
  						, COALESCE(sot.[CheckNumber],-1) AS [CheckNumber]
						, COALESCE(sot.[CreditCardLast4Digits], '') AS [CreditCardLast4Digits]
						, REPLACE(REPLACE(COALESCE(sot.[ApprovalCode], ''),Char(13),''),Char(10),'') AS [ApprovalCode]
 						, COALESCE(sot.[CreditCardTypeID], '') AS [CreditCardTypeSSID]
						, COALESCE(cc.[CreditCardTypeDescription], '') AS [CreditCardTypeDescription]
						, COALESCE(cc.[CreditCardTypeDescriptionShort], '') AS [CreditCardTypeDescriptionShort]
  						, COALESCE(sot.[FinanceCompanyID], '') AS [FinanceCompanySSID]
						, COALESCE(fc.[FinanceCompanyDescription], '') AS [FinanceCompanyDescription]
						, COALESCE(fc.[FinanceCompanyDescriptionShort], '') AS [FinanceCompanyDescriptionShort]
  						, COALESCE(sot.[InterCompanyReasonID], '') AS [InterCompanyReasonID]
						, COALESCE(icr.[InterCompanyReasonDescription], '') AS [InterCompanyReasonDescription]
						, COALESCE(icr.[InterCompanyReasonDescriptionShort], '') AS [InterCompanyReasonDescriptionShort]
						, sot.[LastUpdate] AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, CAST(ISNULL(LTRIM(RTRIM(sot.[SalesOrderTenderGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrderTender] sot
					LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrder] so
							ON sot.[SalesOrderGUID] = so.[SalesOrderGUID]
					LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpCreditCardType] cc
							ON sot.[CreditCardTypeID] = cc.[CreditCardTypeID]
					LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpFinanceCompany] fc
							ON sot.[FinanceCompanyID] = fc.[FinanceCompanyID]
					LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpInterCompanyReason] icr
							ON sot.[InterCompanyReasonID] = icr.[InterCompanyReasonID]
					LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpTenderType] td
							ON sot.[TenderTypeID] = td.[TenderTypeID]
				WHERE (sot.[CreateDate] >= @LSET AND sot.[CreateDate] < @CET_UTC)
				   OR (sot.[LastUpdate] >= @LSET AND sot.[LastUpdate] < @CET_UTC)

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
