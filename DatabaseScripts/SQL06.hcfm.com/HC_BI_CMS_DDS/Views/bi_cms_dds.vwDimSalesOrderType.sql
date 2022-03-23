/* CreateDate: 03/17/2022 11:57:12.433 , ModifyDate: 03/17/2022 11:57:12.433 */
GO
CREATE VIEW [bi_cms_dds].[vwDimSalesOrderType]
AS
-------------------------------------------------------------------------
-- [vwDimSalesOrderType] is used to retrieve a
-- list of Sales Order Types
--
--   SELECT * FROM [bi_cms_dds].[vwDimSalesOrderType]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT	  [SalesOrderTypeKey]
			, [SalesOrderTypeSSID]
			, [SalesOrderTypeDescription]
			, [SalesOrderTypeDescriptionShort]
			, [RowIsCurrent]
			, [RowStartDate]
			, [RowEndDate]
	FROM [bi_cms_dds].[DimSalesOrderType]
GO
