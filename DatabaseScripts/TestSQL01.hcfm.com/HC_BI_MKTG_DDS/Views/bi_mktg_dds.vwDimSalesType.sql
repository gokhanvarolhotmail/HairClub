/* CreateDate: 05/03/2010 12:21:10.920 , ModifyDate: 01/27/2022 09:18:11.503 */
GO
CREATE VIEW [bi_mktg_dds].[vwDimSalesType]
AS
-------------------------------------------------------------------------
-- [vwDimSalesType] is used to retrieve a
-- list of SalesType
--
--   SELECT * FROM [bi_mktg_dds].[vwDimSalesType]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
--			11/24/2014  KMurdoch     Added BusinessSegment
-------------------------------------------------------------------------

	SELECT	   [SalesTypeKey]
			  ,[SalesTypeSSID]
			  ,[BusinessSegment]
			  ,[SalesTypeDescription]
			  ,[SalesTypeDescriptionShort]
			  ,[RowIsCurrent]
			  ,[RowStartDate]
			  ,[RowEndDate]
	FROM [bi_mktg_dds].[DimSalesType]
GO
