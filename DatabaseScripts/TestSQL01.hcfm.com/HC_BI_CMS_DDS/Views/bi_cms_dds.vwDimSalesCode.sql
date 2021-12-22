/* CreateDate: 05/03/2010 12:17:24.460 , ModifyDate: 09/16/2019 09:33:49.917 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bi_cms_dds].[vwDimSalesCode]
AS
-------------------------------------------------------------------------
-- [vwDimSalesCode] is used to retrieve a
-- list of Sales Codes
--
--   SELECT * FROM [bi_cms_dds].[vwDimSalesCode]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

		SELECT	  [SalesCodeKey]
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
				, [Barcode]
				, [PriceDefault]
				, [GLNumber]
				, [ServiceDuration]
				, [RowIsCurrent]
				, [RowStartDate]
				, [RowEndDate]
		FROM [bi_cms_dds].[DimSalesCode]
GO
