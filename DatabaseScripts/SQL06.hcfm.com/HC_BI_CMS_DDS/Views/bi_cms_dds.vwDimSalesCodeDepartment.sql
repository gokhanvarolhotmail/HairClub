/* CreateDate: 03/17/2022 11:57:10.907 , ModifyDate: 03/17/2022 11:57:10.907 */
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
