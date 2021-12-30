/* CreateDate: 06/27/2011 16:35:33.997 , ModifyDate: 09/16/2019 09:33:49.890 */
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
