/* CreateDate: 05/03/2010 12:08:49.293 , ModifyDate: 09/16/2019 09:25:18.210 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bi_ent_dds].[vwDimIncomeRange]
AS
-------------------------------------------------------------------------
-- [vwDimIncomeRange] is used to retrieve a
-- list of IncomeRange
--
--   SELECT * FROM [bi_ent_dds].[vwDimIncomeRange]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT	   [IncomeRangeKey]
			  ,[IncomeRangeSSID]
			  ,[IncomeRangeDescription]
			  ,[IncomeRangeDescriptionShort]
			  ,[RowIsCurrent]
			  ,[RowStartDate]
			  ,[RowEndDate]
	FROM [bi_ent_dds].[DimIncomeRange]
GO
