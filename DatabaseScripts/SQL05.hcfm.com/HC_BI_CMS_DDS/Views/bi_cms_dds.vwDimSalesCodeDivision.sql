/* CreateDate: 05/03/2010 12:17:24.483 , ModifyDate: 10/03/2019 22:52:22.620 */
GO
CREATE VIEW [bi_cms_dds].[vwDimSalesCodeDivision]
AS
-------------------------------------------------------------------------
-- [vwDimSalesCodeDivision] is used to retrieve a
-- list of Sales Code Divisions
--
--   SELECT * FROM [bi_cms_dds].[vwDimSalesCodeDivision]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT  [SalesCodeDivisionKey]
		  , [SalesCodeDivisionSSID]
		  , [SalesCodeDivisionDescription]
		  , [SalesCodeDivisionDescriptionShort]
		  , [RowIsCurrent]
		  , [RowStartDate]
		  , [RowEndDate]
	  FROM [bi_cms_dds].[DimSalesCodeDivision]
GO
