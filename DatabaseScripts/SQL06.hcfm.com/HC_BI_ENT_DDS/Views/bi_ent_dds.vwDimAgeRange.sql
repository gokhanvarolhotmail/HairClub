/* CreateDate: 01/08/2021 15:21:54.247 , ModifyDate: 01/08/2021 15:21:54.247 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
