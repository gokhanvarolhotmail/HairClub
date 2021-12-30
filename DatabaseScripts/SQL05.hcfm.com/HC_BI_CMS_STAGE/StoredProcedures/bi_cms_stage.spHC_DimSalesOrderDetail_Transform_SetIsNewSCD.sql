/* CreateDate: 05/03/2010 12:20:09.877 , ModifyDate: 08/07/2017 10:29:15.340 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimSalesOrderDetail_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimSalesOrderDetail_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_cms_stage].[spHC_DimSalesOrderDetail_Transform_SetIsNewSCD] 11326
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/01/2009  RLifke       Initial Creation
--			03/26/2012  KMurdoch	 Added Performer & 2, CancelreasonID, Member1Price_Temp)
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrderDetail]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [SalesOrderDetailKey] = DW.[SalesOrderDetailKey]
			,IsNew = CASE WHEN DW.[SalesOrderDetailKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimSalesOrderDetail] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderDetail] DW ON
				DW.[SalesOrderDetailSSID] = STG.[SalesOrderDetailSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[SalesOrderDetailKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimSalesOrderDetail] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderDetail] DW ON
				 STG.[SalesOrderDetailSSID] = DW.[SalesOrderDetailSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[SalesOrderDetailKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimSalesOrderDetail] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderDetail] DW ON
				 STG.[SalesOrderDetailSSID] = DW.[SalesOrderDetailSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.TransactionNumber_Temp,'') <> COALESCE(DW.TransactionNumber_Temp,'')
				OR COALESCE(STG.SalesOrderKey,'') <> COALESCE(DW.SalesOrderKey,'')
				OR COALESCE(STG.SalesOrderSSID,'') <> COALESCE(DW.SalesOrderSSID,'')
				OR COALESCE(STG.OrderDate,'') <> COALESCE(DW.OrderDate,'')
				OR COALESCE(STG.SalesCodeSSID,'') <> COALESCE(DW.SalesCodeSSID,'')
				OR COALESCE(STG.SalesCodeDescription,'') <> COALESCE(DW.SalesCodeDescription,'')
				OR COALESCE(STG.SalesCodeDescriptionShort,'') <> COALESCE(DW.SalesCodeDescriptionShort,'')
				OR COALESCE(STG.Quantity,'') <> COALESCE(DW.Quantity,'')
				OR COALESCE(STG.Price,'') <> COALESCE(DW.Price,'')
				OR COALESCE(STG.Discount,'') <> COALESCE(DW.Discount,'')
				OR COALESCE(STG.Tax1,'') <> COALESCE(DW.Tax1,'')
				OR COALESCE(STG.Tax2,'') <> COALESCE(DW.Tax2,'')
				OR COALESCE(STG.TaxRate1,'') <> COALESCE(DW.TaxRate1,'')
				OR COALESCE(STG.TaxRate2,'') <> COALESCE(DW.TaxRate2,'')
				OR COALESCE(STG.IsRefundedFlag,'') <> COALESCE(DW.IsRefundedFlag,'')
				OR COALESCE(STG.IsVoidedFlag,'') <> COALESCE(DW.IsVoidedFlag,'')
				OR COALESCE(STG.RefundedSalesOrderDetailSSID,'') <> COALESCE(DW.RefundedSalesOrderDetailSSID,'')
				OR COALESCE(STG.RefundedTotalQuantity,'') <> COALESCE(DW.RefundedTotalQuantity,'')
				OR COALESCE(STG.RefundedTotalPrice,'') <> COALESCE(DW.RefundedTotalPrice,'')
				OR COALESCE(STG.Employee1SSID,'') <> COALESCE(DW.Employee1SSID,'')
				OR COALESCE(STG.Employee1FirstName,'') <> COALESCE(DW.Employee1FirstName,'')
				OR COALESCE(STG.Employee1LastName,'') <> COALESCE(DW.Employee1LastName,'')
				OR COALESCE(STG.Employee1Initials,'') <> COALESCE(DW.Employee1Initials,'')
				OR COALESCE(STG.Employee2SSID,'') <> COALESCE(DW.Employee2SSID,'')
				OR COALESCE(STG.Employee2FirstName,'') <> COALESCE(DW.Employee2FirstName,'')
				OR COALESCE(STG.Employee2LastName,'') <> COALESCE(DW.Employee2LastName,'')
				OR COALESCE(STG.Employee2Initials,'') <> COALESCE(DW.Employee2Initials,'')
				OR COALESCE(STG.Employee3SSID,'') <> COALESCE(DW.Employee3SSID,'')
				OR COALESCE(STG.Employee3FirstName,'') <> COALESCE(DW.Employee3FirstName,'')
				OR COALESCE(STG.Employee3LastName,'') <> COALESCE(DW.Employee3LastName,'')
				OR COALESCE(STG.Employee3Initials,'') <> COALESCE(DW.Employee3Initials,'')
				OR COALESCE(STG.Employee4SSID,'') <> COALESCE(DW.Employee4SSID,'')
				OR COALESCE(STG.Employee4FirstName,'') <> COALESCE(DW.Employee4FirstName,'')
				OR COALESCE(STG.Employee4LastName,'') <> COALESCE(DW.Employee4LastName,'')
				OR COALESCE(STG.Employee4Initials,'') <> COALESCE(DW.Employee4Initials,'')
				OR COALESCE(STG.Performer_Temp,'') <> COALESCE(DW.Performer_Temp,'')
				OR COALESCE(STG.Performer2_Temp,'') <> COALESCE(DW.Performer2_Temp,'')
				OR COALESCE(STG.Member1Price_Temp,'') <> COALESCE(DW.Member1Price_Temp,'')
				OR COALESCE(STG.CancelReasonID,'') <> COALESCE(DW.CancelReasonID,'')
				OR COALESCE(STG.PreviousClientMembershipSSID,'') <> COALESCE(DW.PreviousClientMembershipSSID,'')
				OR COALESCE(STG.NewCenterSSID,'') <> COALESCE(DW.NewCenterSSID,'')
				OR COALESCE(STG.MembershipOrderReasonID,'') <> COALESCE(DW.MembershipOrderReasonID,'')
				OR COALESCE(STG.ClientMembershipAddOnID,'') <> COALESCE(DW.ClientMembershipAddOnID,'')
				)
		AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[SalesOrderDetailKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimSalesOrderDetail] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderDetail] DW ON
				 STG.[SalesOrderDetailSSID] = DW.[SalesOrderDetailSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.TransactionNumber_Temp,'') <> COALESCE(DW.TransactionNumber_Temp,'')
			--OR COALESCE(STG.SalesOrderKey,'') <> COALESCE(DW.SalesOrderKey,'')
			--OR COALESCE(STG.SalesOrderSSID,'') <> COALESCE(DW.SalesOrderSSID,'')
			--OR COALESCE(STG.OrderDate,'') <> COALESCE(DW.OrderDate,'')
			--OR COALESCE(STG.SalesCodeSSID,'') <> COALESCE(DW.SalesCodeSSID,'')
			--OR COALESCE(STG.SalesCodeDescription,'') <> COALESCE(DW.SalesCodeDescription,'')
			--OR COALESCE(STG.SalesCodeDescriptionShort,'') <> COALESCE(DW.SalesCodeDescriptionShort,'')
			--	OR COALESCE(STG.Quantity,'') <> COALESCE(DW.Quantity,'')
			--	OR COALESCE(STG.Price,'') <> COALESCE(DW.Price,'')
			--	OR COALESCE(STG.Discount,'') <> COALESCE(DW.Discount,'')
			--	OR COALESCE(STG.Tax1,'') <> COALESCE(DW.Tax1,'')
			--	OR COALESCE(STG.Tax2,'') <> COALESCE(DW.Tax2,'')
			--	OR COALESCE(STG.TaxRate1,'') <> COALESCE(DW.TaxRate1,'')
			--	OR COALESCE(STG.TaxRate2,'') <> COALESCE(DW.TaxRate2,'')
			--	OR COALESCE(STG.IsRefundedFlag,'') <> COALESCE(DW.IsRefundedFlag,'')
			--	OR COALESCE(STG.RefundedSalesOrderDetailSSID,'') <> COALESCE(DW.RefundedSalesOrderDetailSSID,'')
			--	OR COALESCE(STG.RefundedTotalQuantity,'') <> COALESCE(DW.RefundedTotalQuantity,'')
			--	OR COALESCE(STG.RefundedTotalPrice,'') <> COALESCE(DW.RefundedTotalPrice,'')
			-- OR COALESCE(STG.Employee1SSID,'') <> COALESCE(DW.Employee1SSID,'')
			-- OR COALESCE(STG.Employee1FirstName,'') <> COALESCE(DW.Employee1FirstName,'')
			-- OR COALESCE(STG.Employee1LastName,'') <> COALESCE(DW.Employee1LastName,'')
			-- OR COALESCE(STG.Employee1Initials,'') <> COALESCE(DW.Employee1Initials,'')
			-- OR COALESCE(STG.Employee2SSID,'') <> COALESCE(DW.Employee2SSID,'')
			-- OR COALESCE(STG.Employee2FirstName,'') <> COALESCE(DW.Employee2FirstName,'')
			-- OR COALESCE(STG.Employee2LastName,'') <> COALESCE(DW.Employee2LastName,'')
			-- OR COALESCE(STG.Employee2Initials,'') <> COALESCE(DW.Employee2Initials,'')
			-- OR COALESCE(STG.Employee3SSID,'') <> COALESCE(DW.Employee3SSID,'')
			-- OR COALESCE(STG.Employee3FirstName,'') <> COALESCE(DW.Employee3FirstName,'')
			-- OR COALESCE(STG.Employee3LastName,'') <> COALESCE(DW.Employee3LastName,'')
			-- OR COALESCE(STG.Employee3Initials,'') <> COALESCE(DW.Employee3Initials,'')
			-- OR COALESCE(STG.Employee4SSID,'') <> COALESCE(DW.Employee4SSID,'')
			-- OR COALESCE(STG.Employee4FirstName,'') <> COALESCE(DW.Employee4FirstName,'')
			-- OR COALESCE(STG.Employee4LastName,'') <> COALESCE(DW.Employee4LastName,'')
			-- OR COALESCE(STG.Employee4Initials,'') <> COALESCE(DW.Employee4Initials,'')
			-- OR COALESCE(STG.PreviousClientMembershipSSID,'') <> COALESCE(DW.PreviousClientMembershipSSID,'')
			--	OR COALESCE(STG.NewCenterSSID,'') <> COALESCE(DW.NewCenterSSID,'')
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  SalesOrderDetailSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY SalesOrderDetailSSID ORDER BY SalesOrderDetailSSID ) AS RowNum
			   FROM  [bi_cms_stage].[DimSalesOrderDetail] STG
			   WHERE IsNew = 1
			   AND STG.[DataPkgKey] = @DataPkgKey

			)

			UPDATE STG SET
				IsDuplicate = 1
			FROM Duplicates STG
			WHERE   RowNum > 1

		-----------------------
		-- Check for deleted rows
		-----------------------
		UPDATE STG SET
				IsDelete = CASE WHEN COALESCE(STG.[CDC_Operation],'') = 'D'
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimSalesOrderDetail] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey



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
