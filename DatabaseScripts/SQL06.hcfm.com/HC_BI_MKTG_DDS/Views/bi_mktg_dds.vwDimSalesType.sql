/* CreateDate: 09/03/2021 09:37:08.257 , ModifyDate: 09/03/2021 09:37:08.257 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
