/* CreateDate: 05/03/2010 12:17:24.507 , ModifyDate: 03/15/2022 15:31:46.760 */
GO
CREATE VIEW [bi_cms_dds].[vwDimSalesOrderDetail]
AS
-------------------------------------------------------------------------
-- [vwDimSalesOrderDetail] is used to retrieve a
-- list of Sales Codes
--
--   SELECT * FROM [bi_cms_dds].[vwDimSalesOrderDetail]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/01/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

		SELECT [SalesOrderDetailKey]
			  ,[SalesOrderDetailSSID]
			  ,[TransactionNumber_Temp]
			  ,[SalesOrderKey]
			  ,[SalesOrderSSID]
			  ,[OrderDate]
			  ,[SalesCodeSSID]
			  ,[SalesCodeDescription]
			  ,[SalesCodeDescriptionShort]
			  ,[Quantity]
			  ,[Price]
			  ,[Discount]
			  ,[Tax1]
			  ,[Tax2]
			  ,[TaxRate1]
			  ,[TaxRate2]
			  ,[ExtendedPriceCalc]
			  ,[TotalTaxCalc]
			  ,[PriceTaxCalc]
			  ,[IsRefundedFlag]
			  ,[RefundedSalesOrderDetailSSID]
			  ,[RefundedTotalQuantity]
			  ,[RefundedTotalPrice]
			  ,[Employee1SSID]
			  ,[Employee1FullName]
			  ,[Employee1FirstName]
			  ,[Employee1LastName]
			  ,[Employee1Initials]
			  ,[Employee2SSID]
			  ,[Employee2FullName]
			  ,[Employee2FirstName]
			  ,[Employee2LastName]
			  ,[Employee2Initials]
			  ,[Employee3SSID]
			  ,[Employee3FullName]
			  ,[Employee3FirstName]
			  ,[Employee3LastName]
			  ,[Employee3Initials]
			  ,[Employee4SSID]
			  ,[Employee4FullName]
			  ,[Employee4FirstName]
			  ,[Employee4LastName]
			  ,[Employee4Initials]
			  ,[PreviousClientMembershipSSID]
			  ,[NewCenterSSID]
			  ,ISNULL([MembershipPromotion], 'NoPromo') AS [MembershipPromotion]
			  ,[RowIsCurrent]
			  ,[RowStartDate]
			  ,[RowEndDate]
		FROM [bi_cms_dds].[DimSalesOrderDetail]
GO
