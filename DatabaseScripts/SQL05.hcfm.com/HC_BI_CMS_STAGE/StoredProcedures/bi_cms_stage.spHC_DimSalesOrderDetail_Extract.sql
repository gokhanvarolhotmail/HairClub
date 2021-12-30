/* CreateDate: 05/03/2010 12:20:07.700 , ModifyDate: 08/07/2017 10:30:58.993 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimSalesOrderDetail_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimSalesOrderDetail_Extract] is used to retrieve a
-- list Sales Order Details
--
--   exec [bi_cms_stage].[spHC_DimSalesOrderDetail_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/08/2009  RLifke       Initial Creation
--			03/26/2012  KMurdoch	 Added Performer & 2, Member1Price, CancelReasonID
--			01/03/2013  EKnapp       Use UTC Current Extraction Time.
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
				, @ExtractRowCnt		int
				, @CET_UTC              datetime

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrderDetail]'


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
							)
				SELECT @DataPkgKey
						, NULL AS [SalesOrderDetailKey]
						, COALESCE(sod.[SalesOrderDetailGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [SalesOrderDetailSSID]
						, COALESCE(sod.[TransactionNumber_Temp], -1) AS [TransactionNumber_Temp]
						, 0 AS [SalesOrderKey]
						, COALESCE(so.[SalesOrderGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [SalesOrderSSID]
						, COALESCE(so.[OrderDate], '12/31/9999') AS [OrderDate]
						, COALESCE(sod.[SalesCodeID], -1) AS [SalesCodeSSID]
						, COALESCE(sc.[SalesCodeDescription], '') AS [SalesCodeDescription]
						, COALESCE(sc.[SalesCodeDescriptionShort], '') AS [SalesCodeDescriptionShort]
						, CAST(COALESCE(so.IsVoidedFlag,0) AS TINYINT) AS [IsVoided]
						, CAST(COALESCE(so.IsClosedFlag,0) AS TINYINT) AS [IsClosed]
						, COALESCE(sod.[Quantity],0) AS [Quantity]
						, COALESCE(sod.[Price],0) AS [Price]
						, COALESCE(sod.[Discount],0) AS [Discount]
						, COALESCE(sod.[Tax1],0) AS [Tax1]
						, COALESCE(sod.[Tax2],0) AS [Tax2]
						, COALESCE(sod.[TaxRate1],0) AS [TaxRate1]
						, COALESCE(sod.[TaxRate2],0) AS [TaxRate2]
						, CAST(COALESCE(sod.IsRefundedFlag,0) AS TINYINT) AS [IsRefundedFlag]
						, COALESCE(sod.[RefundedSalesOrderDetailGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [RefundedSalesOrderDetailSSID]
						, COALESCE(sod.[RefundedTotalQuantity],0) AS [RefundedTotalQuantity]
						, COALESCE(sod.[RefundedTotalPrice],0) AS [RefundedTotalPrice]
						, COALESCE( sod.[Employee1GUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [Employee1SSID]
						, COALESCE(emp1.[FirstName], '') AS [Employee1FirstName]
						, COALESCE(emp1.[LastName], '') AS [Employee1LastName]
						, COALESCE(emp1.[EmployeeInitials], '') AS [Employee1Initials]
						, COALESCE( sod.[Employee2GUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [Employee2SSID]
						, COALESCE(emp2.[FirstName], '') AS [Employee2FirstName]
						, COALESCE(emp2.[LastName], '') AS [Employee2LastName]
						, COALESCE(emp2.[EmployeeInitials], '') AS [Employee2Initials]
						, COALESCE( sod.[Employee3GUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [Employee3SSID]
						, COALESCE(emp3.[FirstName], '') AS [Employee3FirstName]
						, COALESCE(emp3.[LastName], '') AS [Employee3LastName]
						, COALESCE(emp3.[EmployeeInitials], '')AS [Employee3Initials]
						, COALESCE( sod.[Employee4GUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [Employee4SSID]
						, COALESCE(emp4.[FirstName], '') AS [Employee4FirstName]
						, COALESCE(emp4.[LastName], '') AS [Employee4LastName]
						, COALESCE(emp4.[EmployeeInitials], '') AS [Employee4Initials]
						, COALESCE(sod.[Performer_temp], '') AS [Performer_temp]
						, COALESCE(sod.[Performer2_temp], '') AS [Performer2_temp]
						, COALESCE(sod.[Member1Price_Temp], 0) AS [Member1Price_Temp]
						, COALESCE(sod.[CancelReasonID], 0) AS [CancelReasonID]
						, COALESCE(sod.[PreviousClientMembershipGUID],CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [PreviousClientMembershipSSID]
						, COALESCE(sod.[NewCenterID],0) AS [NewCenterSSID]
						, COALESCE(sod.[MembershipOrderReasonID], 0) AS [MembershipOrderReasonID]
						, ISNULL(CMP.MembershipPromotionDescriptionShort,'NoPromo') AS [MembershipPromotion]
						, COALESCE(sod.[HairSystemOrderGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [HairSystemOrderSSID]
						, COALESCE(sod.[ClientMembershipAddOnID], 0) AS [ClientMembershipAddOnID]
						, sod.[LastUpdate] AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, CAST(ISNULL(LTRIM(RTRIM(sod.[SalesOrderDetailGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrderDetail] sod
					LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datSalesOrder] so
							ON so.[SalesOrderGUID] = sod.[SalesOrderGUID]
					LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datEmployee] emp1
							ON sod.[Employee1GUID] = emp1.[EmployeeGUID]
					LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datEmployee] emp2
							ON sod.[Employee2GUID] = emp2.[EmployeeGUID]
					LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datEmployee] emp3
							ON sod.[Employee3GUID] = emp3.[EmployeeGUID]
					LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_datEmployee] emp4
							ON sod.[Employee4GUID] = emp4.[EmployeeGUID]
					LEFT OUTER JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_cfgSalesCode] sc
							ON sod.[SalesCodeID] = sc.[SalesCodeID]
					LEFT JOIN HairClubCMS.dbo.cfgMembershipPromotion AS CMP
							ON sod.MembershipPromotionID = cmp.MembershipPromotionID
				WHERE (sod.[CreateDate] >= @LSET AND sod.[CreateDate] < @CET_UTC)
				   OR (sod.[LastUpdate] >= @LSET AND sod.[LastUpdate] < @CET_UTC)

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
