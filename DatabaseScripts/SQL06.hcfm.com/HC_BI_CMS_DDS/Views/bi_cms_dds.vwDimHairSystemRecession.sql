/* CreateDate: 03/17/2022 11:57:11.930 , ModifyDate: 03/17/2022 11:57:11.930 */
GO
CREATE VIEW [bi_cms_dds].[vwDimHairSystemRecession]
AS
-------------------------------------------------------------------------
-- [vwDimHairSystemDensity] is used to retrieve a
-- list of Hair System Recession records
--
--   SELECT * FROM [bi_cms_dds].[vwDimHairSystemRecession]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/24/2011  KMurdoch     Initial Creation
-------------------------------------------------------------------------


SELECT [HairSystemRecessionKey]
      ,[HairSystemRecessionSSID]
      ,[HairSystemRecessionDescription]
      ,[HairSystemRecessionDescriptionShort]
      ,[HairSystemRecessionSortOrder]
      ,[Active]
      ,[RowIsCurrent]
      ,[RowStartDate]
      ,[RowEndDate]

  FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimHairSystemRecession]
GO
