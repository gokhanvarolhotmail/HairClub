/* CreateDate: 10/03/2019 23:03:43.290 , ModifyDate: 05/06/2021 10:10:56.150 */
GO
CREATE VIEW [bi_cms_dds].[vwDimSalesCode] as
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
--			05/06/2021  KMurdoch	 Added SalesCode and Description
-------------------------------------------------------------------------

		select	  [SalesCodeKey]
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
				, [SalesCodeDescriptionShort] + '/' + [SalesCodeDescription] as 'SalesCodeAndDescription'
				, [Barcode]
				, [PriceDefault]
				, [GLNumber]
				, [ServiceDuration]
				, [RowIsCurrent]
				, [RowStartDate]
				, [RowEndDate]
		from [bi_cms_dds].[DimSalesCode]
GO
