/* CreateDate: 05/03/2010 12:20:16.603 , ModifyDate: 02/05/2014 15:27:34.363 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimSalesOrder_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimSalesOrder_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_cms_stage].[spHC_DimSalesOrder_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/01/2009  RLifke       Initial Creation
--			07/01/2011  KMurdoch	 Added IsSurgeryReversalFlag
--			02/02/2013	DLeiba	     Added IsGuaranteeFlag
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrder]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [SalesOrderKey] = DW.[SalesOrderKey]
			,IsNew = CASE WHEN DW.[SalesOrderKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimSalesOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrder] DW ON
				DW.[SalesOrderSSID] = STG.[SalesOrderSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[SalesOrderKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimSalesOrder] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrder] DW ON
				 STG.[SalesOrderSSID] = DW.[SalesOrderSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[SalesOrderKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimSalesOrder] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrder] DW ON
				 STG.[SalesOrderSSID] = DW.[SalesOrderSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.InvoiceNumber,'') <> COALESCE(DW.InvoiceNumber,'')
				OR COALESCE(STG.FulfillmentNumber,'') <> COALESCE(DW.FulfillmentNumber,'')
				OR COALESCE(STG.TenderTransactionNumber_Temp,'') <> COALESCE(DW.TenderTransactionNumber_Temp,'')
				OR COALESCE(STG.TicketNumber_Temp,'') <> COALESCE(DW.TicketNumber_Temp,'')
				OR COALESCE(STG.CenterKey,'') <> COALESCE(DW.CenterKey,'')
				OR COALESCE(STG.CenterSSID,'') <> COALESCE(DW.CenterSSID,'')
				OR COALESCE(STG.ClientHomeCenterKey,'') <> COALESCE(DW.ClientHomeCenterKey,'')
				OR COALESCE(STG.ClientHomeCenterSSID,'') <> COALESCE(DW.ClientHomeCenterSSID,'')
				OR COALESCE(STG.SalesOrderTypeKey,'') <> COALESCE(DW.SalesOrderTypeKey,'')
				OR COALESCE(STG.SalesOrderTypeSSID,'') <> COALESCE(DW.SalesOrderTypeSSID,'')
				OR COALESCE(STG.ClientKey,'') <> COALESCE(DW.ClientKey,'')
				OR COALESCE(STG.ClientSSID,'') <> COALESCE(DW.ClientSSID,'')
				OR COALESCE(STG.ClientMembershipKey,'') <> COALESCE(DW.ClientMembershipKey,'')
				OR COALESCE(STG.ClientMembershipSSID,'') <> COALESCE(DW.ClientMembershipSSID,'')
				OR COALESCE(STG.OrderDate,'') <> COALESCE(DW.OrderDate,'')
				OR COALESCE(STG.IsTaxExemptFlag,'') <> COALESCE(DW.IsTaxExemptFlag,'')
				OR COALESCE(STG.IsVoidedFlag,'') <> COALESCE(DW.IsVoidedFlag,'')
				OR COALESCE(STG.IsClosedFlag,'') <> COALESCE(DW.IsClosedFlag,'')
				OR COALESCE(STG.IsWrittenOffFlag,'') <> COALESCE(DW.IsWrittenOffFlag,'')
				OR COALESCE(STG.IsRefundedFlag,'') <> COALESCE(DW.IsRefundedFlag,'')
				OR COALESCE(STG.RefundedSalesOrderKey,'') <> COALESCE(DW.RefundedSalesOrderKey,'')
				OR COALESCE(STG.RefundedSalesOrderSSID,'') <> COALESCE(DW.RefundedSalesOrderSSID,'')
				OR COALESCE(STG.EmployeeKey,'') <> COALESCE(DW.EmployeeKey,'')
				OR COALESCE(STG.EmployeeSSID,'') <> COALESCE(DW.EmployeeSSID,'')
				OR COALESCE(STG.IsSurgeryReversalFlag,0) <> COALESCE(DW.IsSurgeryReversalFlag,0)
				OR COALESCE(STG.IsGuaranteeFlag,0) <> COALESCE(DW.IsGuaranteeFlag,0)
				)
		AND STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[SalesOrderKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimSalesOrder] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrder] DW ON
				 STG.[SalesOrderSSID] = DW.[SalesOrderSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.InvoiceNumber,'') <> COALESCE(DW.InvoiceNumber,'')
			--	OR COALESCE(STG.FulfillmentNumber,'') <> COALESCE(DW.FulfillmentNumber,'')
			--	OR COALESCE(STG.TenderTransactionNumber_Temp,'') <> COALESCE(DW.TenderTransactionNumber_Temp,'')
			--	OR COALESCE(STG.TicketNumber_Temp,'') <> COALESCE(DW.TicketNumber_Temp,'')
				--OR COALESCE(STG.TicketNumber_Temp,'') <> COALESCE(DW.TicketNumber_Temp,'')
				--OR COALESCE(STG.CenterKey,'') <> COALESCE(DW.CenterKey,'')
				--OR COALESCE(STG.CenterSSID,'') <> COALESCE(DW.CenterSSID,'')
				--OR COALESCE(STG.ClientHomeCenterKey,'') <> COALESCE(DW.ClientHomeCenterKey,'')
				--OR COALESCE(STG.ClientHomeCenterSSID,'') <> COALESCE(DW.ClientHomeCenterSSID,'')
				--OR COALESCE(STG.SalesOrderTypeKey,'') <> COALESCE(DW.SalesOrderTypeKey,'')
				--OR COALESCE(STG.SalesOrderTypeSSID,'') <> COALESCE(DW.SalesOrderTypeSSID,'')
				--OR COALESCE(STG.ClientKey,'') <> COALESCE(DW.ClientKey,'')
				--OR COALESCE(STG.ClientSSID,'') <> COALESCE(DW.ClientSSID,'')
				--OR COALESCE(STG.ClientMembershipKey,'') <> COALESCE(DW.ClientMembershipKey,'')
				--OR COALESCE(STG.ClientMembershipSSID,'') <> COALESCE(DW.ClientMembershipSSID,'')
			--	OR COALESCE(STG.OrderDate,'') <> COALESCE(DW.OrderDate,'')
			--	OR COALESCE(STG.IsTaxExemptFlag,'') <> COALESCE(DW.IsTaxExemptFlag,'')
			--	OR COALESCE(STG.IsVoidedFlag,'') <> COALESCE(DW.IsVoidedFlag,'')
			--	OR COALESCE(STG.IsClosedFlag,'') <> COALESCE(DW.IsClosedFlag,'')
			--	OR COALESCE(STG.IsWrittenOffFlag,'') <> COALESCE(DW.IsWrittenOffFlag,'')
			--	OR COALESCE(STG.IsRefundedFlag,'') <> COALESCE(DW.IsRefundedFlag,'')
				--OR COALESCE(STG.RefundedSalesOrderKey,'') <> COALESCE(DW.RefundedSalesOrderKey,'')
				--OR COALESCE(STG.RefundedSalesOrderGUID,'') <> COALESCE(DW.RefundedSalesOrderGUID,'')
				--OR COALESCE(STG.EmployeeKey,'') <> COALESCE(DW.EmployeeKey,'')
				--OR COALESCE(STG.EmployeeGUID,'') <> COALESCE(DW.EmployeeGUID,'')
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  SalesOrderSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY SalesOrderSSID ORDER BY SalesOrderSSID ) AS RowNum
			   FROM  [bi_cms_stage].[DimSalesOrder] STG
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
		FROM [bi_cms_stage].[DimSalesOrder] STG
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
