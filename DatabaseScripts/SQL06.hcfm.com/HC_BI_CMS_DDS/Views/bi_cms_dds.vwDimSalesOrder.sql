/* CreateDate: 03/17/2022 11:57:12.257 , ModifyDate: 03/17/2022 11:57:12.257 */
GO
CREATE VIEW [bi_cms_dds].[vwDimSalesOrder]
AS
-------------------------------------------------------------------------
-- [vwDimSalesOrder] is used to retrieve a
-- list of Sales Codes
--
--   SELECT * FROM [bi_cms_dds].[vwDimSalesOrder]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/01/2009  RLifke       Initial Creation
--			07/11/2011  KMurdoch	 Surgery Reversal Flag
--			11/05/2015	KMurdoch     Added Membership Promotion
-------------------------------------------------------------------------

		SELECT dso.[SalesOrderKey]
			  ,dso.[SalesOrderSSID]
			  ,[TenderTransactionNumber_Temp]
			  ,[TicketNumber_Temp]
			  ,[CenterKey]
			  ,[CenterSSID]
			  ,[ClientHomeCenterKey]
			  ,[ClientHomeCenterSSID]
			  ,[SalesOrderTypeKey]
			  ,[SalesOrderTypeSSID]
			  ,[ClientKey]
			  ,[ClientSSID]
			  ,[ClientMembershipKey]
			  ,[ClientMembershipSSID]
			  ,dso.[OrderDate]
			  ,[InvoiceNumber]
			  ,[IsTaxExemptFlag]
			  ,dso.[IsVoidedFlag]
			  ,dso.[IsClosedFlag]
			  ,[EmployeeKey]
			  ,[EmployeeSSID]
			  ,[FulfillmentNumber]
			  ,[IsWrittenOffFlag]
			  ,dso.[IsRefundedFlag]
			  ,[RefundedSalesOrderKey]
			  ,[RefundedSalesOrderSSID]
			  ,[IsSurgeryReversalFlag]
			  --,MAX(dsod.membershippromotion) AS MembershipPromotion
			  ,dso.[RowIsCurrent]
			  ,dso.[RowStartDate]
			  ,dso.[RowEndDate]
		FROM [bi_cms_dds].[DimSalesOrder] DSO
		--INNER JOIN bi_cms_dds.DimSalesOrderDetail AS DSOD
		--	ON DSO.SalesOrderKey = DSOD.SalesOrderkey
		--WHERE dso.OrderDate > '01/01/15'
		--GROUP BY dso.SalesOrderKey,dso.[SalesOrderSSID]
		--	  ,[TenderTransactionNumber_Temp]
		--	  ,[TicketNumber_Temp]
		--	  ,[CenterKey]
		--	  ,[CenterSSID]
		--	  ,[ClientHomeCenterKey]
		--	  ,[ClientHomeCenterSSID]
		--	  ,[SalesOrderTypeKey]
		--	  ,[SalesOrderTypeSSID]
		--	  ,[ClientKey]
		--	  ,[ClientSSID]
		--	  ,[ClientMembershipKey]
		--	  ,[ClientMembershipSSID]
		--	  ,dso.[OrderDate]
		--	  ,[InvoiceNumber]
		--	  ,[IsTaxExemptFlag]
		--	  ,dso.[IsVoidedFlag]
		--	  ,dso.[IsClosedFlag]
		--	  ,[EmployeeKey]
		--	  ,[EmployeeSSID]
		--	  ,[FulfillmentNumber]
		--	  ,[IsWrittenOffFlag]
		--	  ,dso.[IsRefundedFlag]
		--	  ,[RefundedSalesOrderKey]
		--	  ,[RefundedSalesOrderSSID]
		--	  ,[IsSurgeryReversalFlag]
		--	  ,dso.[RowIsCurrent]
		--	  ,dso.[RowStartDate]
		--	  ,dso.[RowEndDate]
GO
