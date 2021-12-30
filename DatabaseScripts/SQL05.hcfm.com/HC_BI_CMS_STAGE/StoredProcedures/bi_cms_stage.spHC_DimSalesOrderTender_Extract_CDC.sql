/* CreateDate: 05/03/2010 12:20:12.030 , ModifyDate: 08/12/2013 15:27:04.753 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimSalesOrderTender_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimSalesOrderTender_Extract_CDC] is used to retrieve a
-- list SalesOrderTender
--
--   exec [bi_cms_stage].[spHC_DimSalesOrderTender_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    05/27/2009  RLifke       Initial Creation
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
				, @CDCTableName			varchar(150)	-- Name of CDC table
				, @ExtractRowCnt		int

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrderTender]'
 	SET @CDCTableName = N'dbo_datSalesOrderTender'


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
									, [CDC_Operation]
									)
						SELECT @DataPkgKey
								, NULL AS [SalesOrderTenderKey]
 								, COALESCE(chg.[SalesOrderTenderGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [SalesOrderTenderSSID]
								, 0 AS [SalesOrderKey]
								, COALESCE(so.[SalesOrderGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [SalesOrderSSID]
								, COALESCE(so.[OrderDate], '12/31/9999') AS [OrderDate]
								, COALESCE(chg.[TenderTypeID], '') AS [TenderTypeSSID]
								, COALESCE(td.[TenderTypeDescription], '') AS [TenderTypeDescription]
								, COALESCE(td.[TenderTypeDescriptionShort], '') AS [TenderTypeDescriptionShort]
								, CAST(COALESCE(so.IsVoidedFlag,0) AS TINYINT) AS [IsVoided]
								, CAST(COALESCE(so.IsClosedFlag,0) AS TINYINT) AS [IsClosed]
 								, COALESCE(chg.[Amount],0) AS [Amount]
  								, COALESCE(chg.[CheckNumber],-1) AS [CheckNumber]
								, COALESCE(chg.[CreditCardLast4Digits], '') AS [CreditCardLast4Digits]
								, REPLACE(REPLACE(COALESCE(chg.[ApprovalCode], ''),Char(13),''),Char(10),'') as ApprovalCode
 								, COALESCE(chg.[CreditCardTypeID], '') AS [CreditCardTypeSSID]
								, COALESCE(cc.[CreditCardTypeDescription], '') AS [CreditCardTypeDescription]
								, COALESCE(cc.[CreditCardTypeDescriptionShort], '') AS [CreditCardTypeDescriptionShort]
  								, COALESCE(chg.[FinanceCompanyID], '') AS [FinanceCompanySSID]
								, COALESCE(fc.[FinanceCompanyDescription], '') AS [FinanceCompanyDescription]
								, COALESCE(fc.[FinanceCompanyDescriptionShort], '') AS [FinanceCompanyDescriptionShort]
  								, COALESCE(chg.[InterCompanyReasonID], '') AS [InterCompanyReasonID]
								, COALESCE(icr.[InterCompanyReasonDescription], '') AS [InterCompanyReasonDescription]
								, COALESCE(icr.[InterCompanyReasonDescriptionShort], '') AS [InterCompanyReasonDescriptionShort]
								, [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time](__$start_lsn) AS [ModifiedDate]
								, 0 AS [IsNew]
								, 0 AS [IsType1]
								, 0 AS [IsType2]
								, 0 AS [IsException]
								, 0 AS [IsInferredMember]
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
							LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrder] so
									ON chg.[SalesOrderGUID] = so.[SalesOrderGUID]
							LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpCreditCardType] cc
									ON chg.[CreditCardTypeID] = cc.[CreditCardTypeID]
							LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpFinanceCompany] fc
									ON chg.[FinanceCompanyID] = fc.[FinanceCompanyID]
							LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpInterCompanyReason] icr
									ON chg.[InterCompanyReasonID] = icr.[InterCompanyReasonID]
							LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpTenderType] td
									ON chg.[TenderTypeID] = td.[TenderTypeID]

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
