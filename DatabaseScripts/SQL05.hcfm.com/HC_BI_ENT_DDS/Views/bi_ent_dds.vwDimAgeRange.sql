/* CreateDate: 05/03/2010 12:08:49.093 , ModifyDate: 10/03/2019 21:37:24.927 */
GO
CREATE VIEW [bi_ent_dds].[vwDimAgeRange]
AS
-------------------------------------------------------------------------
-- [vwDimAgeRange] is used to retrieve a
-- list of AgeRange
--
--   SELECT * FROM [bi_ent_dds].[vwDimAgeRange]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT	   [AgeRangeKey]
			  ,[AgeRangeSSID]
			  ,[AgeRangeDescription]
			  ,[AgeRangeDescriptionShort]
			  ,[RowIsCurrent]
			  ,[RowStartDate]
			  ,[RowEndDate]
	FROM [bi_ent_dds].[DimAgeRange]
GO
