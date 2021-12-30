/* CreateDate: 05/03/2010 12:20:07.610 , ModifyDate: 07/17/2017 14:34:26.710 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimSalesCode_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimSalesCode_Extract_CDC] is used to retrieve a
-- list SalesCode
--
--   exec [bi_cms_stage].[spHC_DimSalesCode_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    05/27/2009  RLifke       Initial Creation
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
				, @CDCTableName			varchar(150)	-- Name of CDC table
				, @ExtractRowCnt		int

 	SET @TableName = N'[bi_cms_dds].[DimSalesCode]'
 	SET @CDCTableName = N'dbo_cfgSalesCode'


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
								   , [CDC_Operation]
									)
						SELECT @DataPkgKey
								, NULL AS [SalesCodeKey]
								, COALESCE(chg.[SalesCodeID], -2) AS [SalesCodeSSID]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[SalesCodeDescription])),'') AS nvarchar(50)) AS [SalesCodeDescription]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[SalesCodeDescriptionShort])),'') AS nvarchar(15)) AS [SalesCodeDescriptionShort]
								, COALESCE(chg.[SalesCodeTypeID], -2) AS [SalesCodeTypeSSID]
								, CAST(ISNULL(LTRIM(RTRIM(sct.[SalesCodeTypeDescription])),'') AS nvarchar(50)) AS [SalesCodeTypeDescription]
								, CAST(ISNULL(LTRIM(RTRIM(sct.[SalesCodeTypeDescriptionShort])),'') AS nvarchar(10)) AS [SalesCodeTypeDescriptionShort]
								, COALESCE(chg.[VendorID], -2) AS [ProductVendorSSID]
								, CAST(ISNULL(LTRIM(RTRIM(pv.[VendorDescription])),'') AS nvarchar(50)) AS [ProductVendorDescription]
								, CAST(ISNULL(LTRIM(RTRIM(pv.[VendorDescriptionShort])),'') AS nvarchar(10)) AS [ProductVendorDescriptionShort]
								, NULL AS [SalesCodeDepartmentKey]
								, COALESCE(chg.[SalesCodeDepartmentID], -2) AS [SalesCodeDepartmentSSID]
								, COALESCE(chg.[BarCode], '') AS [BarCode]
								, COALESCE(chg.[PriceDefault], 0) AS [PriceDefault]
								, COALESCE(chg.[GLNumber], 0) AS [GLNumber]
								, COALESCE(chg.[ServiceDuration], 0) AS [ServiceDuration]
								, [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time](__$start_lsn) AS [ModifiedDate]
								, 0 AS [IsNew]
								, 0 AS [IsType1]
								, 0 AS [IsType2]
								, 0 AS [IsException]
								, 0 AS [IsInferredMember]
								, 0 AS [IsDelete]
								, 0 AS [IsDuplicate]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[SalesCodeID])),'') AS nvarchar(50)) AS [SourceSystemKey]
								, CASE [__$operation]
										WHEN 1 THEN 'D'
										WHEN 2 THEN 'I'
										WHEN 3 THEN 'UO'
										WHEN 4 THEN 'UN'
										WHEN 5 THEN 'M'
										ELSE NULL
									END AS [CDC_Operation]
						FROM [HairClubCMS].[cdc].[fn_cdc_get_net_changes_dbo_cfgSalesCode](@From_LSN, @To_LSN, @row_filter_option) chg
							Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpSalesCodeType] sct ON
									chg.[SalesCodeTypeID] = sct.[SalesCodeTypeID]
							Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_cfgVendor] pv ON
									chg.[VendorID] = pv.[VendorID]

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
