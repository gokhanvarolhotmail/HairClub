/* CreateDate: 05/03/2010 12:20:09.817 , ModifyDate: 08/07/2017 10:30:14.990 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimSalesOrderDetail_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimSalesOrderDetail_Extract_CDC] is used to retrieve a
-- list SalesOrderDetail
--
--   exec [bi_cms_stage].[spHC_DimSalesOrderDetail_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    05/27/2009  RLifke       Initial Creation
--			03/26/2012  KMurdoch	 Added Performer & 2, Member1Price, CancelReasonID
--			11/04/2015  KMurdoch     Added Membership Promotion
--			04/03/2017  DLeiba		 Added HairSystemOrderSSID
--			08/07/2017  DLeiba		 Added ClientMembershipAddOnID
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrderDetail]'
 	SET @CDCTableName = N'dbo_datSalesOrderDetail'


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


						INSERT INTO [bi_cms_stage].[DimSalesOrderDetail]
								   (  [DataPkgKey]
									, [SalesOrderDetailKey]
									, [SalesOrderDetailSSID]
									, [TransactionNumber_Temp]
									, [SalesOrderKey]
									, [SalesOrderSSID]
									, [OrderDate]
									, [SalesCodeSSID]
									, [SalesCodeDescription]
									, [SalesCodeDescriptionShort]
									, [IsVoidedFlag]
									, [IsClosedFlag]
									, [Quantity]
									, [Price]
									, [Discount]
									, [Tax1]
									, [Tax2]
									, [TaxRate1]
									, [TaxRate2]
									, [IsRefundedFlag]
									, [RefundedSalesOrderDetailSSID]
									, [RefundedTotalQuantity]
									, [RefundedTotalPrice]
									, [Employee1SSID]
									, [Employee1FirstName]
									, [Employee1LastName]
									, [Employee1Initials]
									, [Employee2SSID]
									, [Employee2FirstName]
									, [Employee2LastName]
									, [Employee2Initials]
									, [Employee3SSID]
									, [Employee3FirstName]
									, [Employee3LastName]
									, [Employee3Initials]
									, [Employee4SSID]
									, [Employee4FirstName]
									, [Employee4LastName]
									, [Employee4Initials]
									, [Performer_temp]
									, [Performer2_temp]
									, [Member1Price_Temp]
									, [CancelReasonID]
									, [PreviousClientMembershipSSID]
									, [NewCenterSSID]
									, [MembershipOrderReasonID]
									, [MembershipPromotion]
									, [HairSystemOrderSSID]
									, [ClientMembershipAddOnID]
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
								, NULL AS [SalesOrderDetailKey]
								, COALESCE(chg.[SalesOrderDetailGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [SalesOrderDetailSSID]
								, COALESCE(chg.[TransactionNumber_Temp], '') AS [TransactionNumber_Temp]
								, 0 AS [SalesOrderKey]
								, COALESCE(so.[SalesOrderGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [SalesOrderSSID]
								, COALESCE(so.[OrderDate], '12/31/9999') AS [OrderDate]
								, COALESCE(chg.[SalesCodeID], '') AS [SalesCodeSSID]
								, COALESCE(sc.[SalesCodeDescription], '') AS [SalesCodeDescription]
								, COALESCE(sc.[SalesCodeDescriptionShort], '') AS [SalesCodeDescriptionShort]
								, CAST(COALESCE(so.IsVoidedFlag,0) AS TINYINT) AS [IsVoided]
								, CAST(COALESCE(so.IsClosedFlag,0) AS TINYINT) AS [IsClosed]
								, COALESCE(chg.[Quantity],0) AS [Quantity]
								, COALESCE(chg.[Price],0) AS [Price]
								, COALESCE(chg.[Discount],0) AS [Discount]
								, COALESCE(chg.[Tax1],0) AS [Tax1]
								, COALESCE(chg.[Tax2],0) AS [Tax2]
								, COALESCE(chg.[TaxRate1],0) AS [TaxRate1]
								, COALESCE(chg.[TaxRate2],0) AS [TaxRate2]
								, CAST(COALESCE(chg.IsRefundedFlag,0) AS TINYINT) AS [IsRefundedFlag]
								, COALESCE(chg.[RefundedSalesOrderDetailGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [RefundedSalesOrderDetailSSID]
								, COALESCE(chg.[RefundedTotalQuantity],0) AS [RefundedTotalQuantity]
								, COALESCE(chg.[RefundedTotalPrice],0) AS [RefundedTotalPrice]
								, COALESCE( chg.[Employee1GUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [Employee1SSID]
								, COALESCE(emp1.[FirstName], '') AS [Employee1FirstName]
								, COALESCE(emp1.[LastName], '') AS [Employee1LastName]
								, COALESCE(emp1.[EmployeeInitials], '') AS [Employee1Initials]
								, COALESCE( chg.[Employee2GUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [Employee2SSID]
								, COALESCE(emp2.[FirstName], '') AS [Employee2FirstName]
								, COALESCE(emp2.[LastName], '') AS [Employee2LastName]
								, COALESCE(emp2.[EmployeeInitials], '') AS [Employee2Initials]
								, COALESCE( chg.[Employee3GUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [Employee3SSID]
								, COALESCE(emp3.[FirstName], '') AS [Employee3FirstName]
								, COALESCE(emp3.[LastName], '') AS [Employee3LastName]
								, COALESCE(emp3.[EmployeeInitials], '')AS [Employee3Initials]
								, COALESCE( chg.[Employee4GUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [Employee4SSID]
								, COALESCE(emp4.[FirstName], '') AS [Employee4FirstName]
								, COALESCE(emp4.[LastName], '') AS [Employee4LastName]
								, COALESCE(emp4.[EmployeeInitials], '') AS [Employee4Initials]
								, COALESCE(chg.[Performer_temp], '') AS [Performer_temp]
								, COALESCE(chg.[Performer2_temp], '') AS [Performer2_temp]
								, COALESCE(chg.[Member1Price_Temp], 0) AS [Member1Price_Temp]
								, COALESCE(chg.[CancelReasonID], 0) AS [CancelReasonID]
								, COALESCE(chg.[PreviousClientMembershipGUID],CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [PreviousClientMembershipSSID]
								, COALESCE(chg.[NewCenterID],0) AS [NewCenterSSID]
								, COALESCE(chg.[MembershipOrderReasonID], 0) AS [MembershipOrderReasonID]
								, ISNULL(CMP.MembershipPromotionDescriptionShort,'NoPromo') AS [MembershipPromotion]
								, COALESCE(chg.[HairSystemOrderGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [HairSystemOrderSSID]
								, COALESCE(chg.[ClientMembershipAddOnID], 0) AS [ClientMembershipAddOnID]
								, [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time](__$start_lsn) AS [ModifiedDate]
								, 0 AS [IsNew]
								, 0 AS [IsType1]
								, 0 AS [IsType2]
								, 0 AS [IsException]
								, 0 AS [IsInferredMember]
								, 0 AS [IsDelete]
								, 0 AS [IsDuplicate]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[SalesOrderDetailGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
								, CASE [__$operation]
										WHEN 1 THEN 'D'
										WHEN 2 THEN 'I'
										WHEN 3 THEN 'UO'
										WHEN 4 THEN 'UN'
										WHEN 5 THEN 'M'
										ELSE NULL
									END AS [CDC_Operation]
						FROM [HairClubCMS].[cdc].[fn_cdc_get_net_changes_dbo_datSalesOrderDetail](@From_LSN, @To_LSN, @row_filter_option) chg
							LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrder] so
									ON chg.[SalesOrderGUID] = so.[SalesOrderGUID]
							LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datEmployee] emp1
									ON chg.[Employee1GUID] = emp1.[EmployeeGUID]
							LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datEmployee] emp2
									ON chg.[Employee2GUID] = emp2.[EmployeeGUID]
							LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datEmployee] emp3
									ON chg.[Employee3GUID] = emp3.[EmployeeGUID]
							LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datEmployee] emp4
									ON chg.[Employee4GUID] = emp4.[EmployeeGUID]
							LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_cfgSalesCode] sc
									ON chg.[SalesCodeID] = sc.[SalesCodeID]
							LEFT JOIN HairClubCMS.dbo.cfgMembershipPromotion AS CMP
									ON chg.MembershipPromotionID = cmp.MembershipPromotionID

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
