CREATE VIEW [bi_ent_dds].[vwDimRevenueGroup]
AS
-------------------------------------------------------------------------
-- [vwDimRevenueGroup] is used to retrieve a
-- list of Revenue Groups
--
--   SELECT * FROM [bi_ent_dds].[vwDimRevenueGroup]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT  [RevenueGroupKey]
		  , [RevenueGroupSSID]
		  , [RevenueGroupDescription]
		  , [RevenueGroupDescriptionShort]
		  , [RowIsCurrent]
		  , [RowStartDate]
		  , [RowEndDate]
	  FROM [bi_ent_dds].[DimRevenueGroup]
