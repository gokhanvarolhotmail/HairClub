/* CreateDate: 05/03/2010 12:20:05.557 , ModifyDate: 07/17/2017 14:34:11.127 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimSalesCode_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimSalesCode_Extract] is used to retrieve a
-- list Business Units
--
--   exec [bi_cms_stage].[spHC_DimSalesCode_Extract]  22, '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/25/2009  RLifke       Initial Creation
--			07/17/2017  KMurdoch      Fixed SalesCodedescriptionshort to be 15 not 10
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesCode]'


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


				INSERT INTO [bi_cms_stage].[DimSalesCode]
						   ( [DataPkgKey]
						   , [SalesCodeKey]
						   , [SalesCodeSSID]
						   , [SalesCodeDescription]
						   , [SalesCodeDescriptionShort]
						   , [SalesCodeTypeSSID]
						   , [SalesCodeTypeDescription]
						   , [SalesCodeTypeDescriptionShort]
						   , [ProductVendorSSID]
						   , [ProductVendorDescription]
						   , [ProductVendorDescriptionShort]
						   , [SalesCodeDepartmentKey]
						   , [SalesCodeDepartmentSSID]
						   , [BarCode]
						   , [PriceDefault]
						   , [GLNumber]
						   , [ServiceDuration]
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
						, NULL AS [SalesCodeKey]
						, COALESCE(sc.[SalesCodeID], -2) AS [SalesCodeSSID]
						, CAST(ISNULL(LTRIM(RTRIM(sc.[SalesCodeDescription])),'') AS nvarchar(50)) AS [SalesCodeDescription]
						, CAST(ISNULL(LTRIM(RTRIM(sc.[SalesCodeDescriptionShort])),'') AS nvarchar(15)) AS [SalesCodeDescriptionShort]
						, COALESCE(sc.[SalesCodeTypeID], -2) AS [SalesCodeTypeSSID]
						, CAST(ISNULL(LTRIM(RTRIM(sct.[SalesCodeTypeDescription])),'') AS nvarchar(50)) AS [SalesCodeTypeDescription]
						, CAST(ISNULL(LTRIM(RTRIM(sct.[SalesCodeTypeDescriptionShort])),'') AS nvarchar(10)) AS [SalesCodeTypeDescriptionShort]
						, COALESCE(sc.[VendorID], -2) AS [ProductVendorSSID]
						, CAST(ISNULL(LTRIM(RTRIM(pv.[VendorDescription])),'') AS nvarchar(50)) AS [ProductVendorDescription]
						, CAST(ISNULL(LTRIM(RTRIM(pv.[VendorDescriptionShort])),'') AS nvarchar(10)) AS [ProductVendorDescriptionShort]
						, NULL AS [SalesCodeDepartmentKey]
						, COALESCE(sc.[SalesCodeDepartmentID], -2) AS [SalesCodeDepartmentSSID]
						, COALESCE(sc.[BarCode], '') AS [BarCode]
						, COALESCE(sc.[PriceDefault], 0) AS [PriceDefault]
						, COALESCE(sc.[GLNumber], 0) AS [GLNumber]
						, COALESCE(sc.[ServiceDuration], 0) AS [ServiceDuration]
						, sc.[LastUpdate] AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, CAST(ISNULL(LTRIM(RTRIM([SalesCodeID])),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM [bi_cms_stage].[synHC_SRC_TBL_CMS_cfgSalesCode] sc
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpSalesCodeType] sct ON
							sc.[SalesCodeTypeID] = sct.[SalesCodeTypeID]
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_cfgVendor] pv ON
							sc.[VendorID] = pv.[VendorID]
				WHERE (sc.[CreateDate] >= @LSET AND sc.[CreateDate] < @CET)
				   OR (sc.[LastUpdate] >= @LSET AND sc.[LastUpdate] < @CET)

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
