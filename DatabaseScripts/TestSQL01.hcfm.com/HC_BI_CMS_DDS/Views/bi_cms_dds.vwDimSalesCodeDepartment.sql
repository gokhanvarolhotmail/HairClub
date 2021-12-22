/* CreateDate: 05/03/2010 12:17:24.470 , ModifyDate: 09/16/2019 09:33:49.917 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bi_cms_dds].[vwDimSalesCodeDepartment]
AS
-------------------------------------------------------------------------
-- [vwDimSalesCodeDepartment] is used to retrieve a
-- list of Sales Code Departments
--
--   SELECT * FROM [bi_cms_dds].[vwDimSalesCodeDepartment]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT	  [SalesCodeDepartmentKey]
			, [SalesCodeDepartmentSSID]
			, [SalesCodeDepartmentDescription]
			, [SalesCodeDepartmentDescriptionShort]
			, [SalesCodeDivisionKey]
			, [SalesCodeDivisionSSID]
			, [RowIsCurrent]
			, [RowStartDate]
			, [RowEndDate]
	FROM [bi_cms_dds].[DimSalesCodeDepartment]
GO
