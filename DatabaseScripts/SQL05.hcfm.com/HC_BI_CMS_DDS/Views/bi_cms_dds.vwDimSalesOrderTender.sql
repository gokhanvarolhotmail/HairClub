/* CreateDate: 05/03/2010 12:17:24.523 , ModifyDate: 10/03/2019 22:52:22.660 */
GO
CREATE VIEW [bi_cms_dds].[vwDimSalesOrderTender]
AS
-------------------------------------------------------------------------
-- [vwDimSalesOrderTender] is used to retrieve a
-- list of Sales Codes
--
--   SELECT * FROM [bi_cms_dds].[vwDimSalesOrderTender]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/01/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

		SELECT [SalesOrderTenderKey]
			  ,[SalesOrderTenderSSID]
			  ,[SalesOrderKey]
			  ,[SalesOrderSSID]
			  ,[OrderDate]
			  ,[TenderTypeSSID]
			  ,[TenderTypeDescription]
			  ,[TenderTypeDescriptionShort]
			  ,[Amount]
			  ,[CheckNumber]
			  ,[CreditCardLast4Digits]
			  ,[ApprovalCode]
			  ,[CreditCardTypeSSID]
			  ,[CreditCardTypeDescription]
			  ,[CreditCardTypeDescriptionShort]
			  ,[FinanceCompanySSID]
			  ,[FinanceCompanyDescription]
			  ,[FinanceCompanyDescriptionShort]
			  ,[InterCompanyReasonSSID]
			  ,[InterCompanyReasonDescription]
			  ,[InterCompanyReasonDescriptionShort]
			  ,[RowIsCurrent]
			  ,[RowStartDate]
			  ,[RowEndDate]
		FROM [bi_cms_dds].[DimSalesOrderTender]
GO