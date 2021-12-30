/* CreateDate: 05/03/2010 12:17:24.537 , ModifyDate: 10/03/2019 22:52:22.677 */
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
