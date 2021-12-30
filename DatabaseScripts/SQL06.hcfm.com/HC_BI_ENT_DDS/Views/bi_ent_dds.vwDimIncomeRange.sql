/* CreateDate: 01/08/2021 15:21:54.437 , ModifyDate: 01/08/2021 15:21:54.437 */
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
