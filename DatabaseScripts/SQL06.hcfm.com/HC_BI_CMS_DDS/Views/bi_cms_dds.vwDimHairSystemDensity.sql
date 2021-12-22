CREATE VIEW [bi_cms_dds].[vwDimHairSystemDensity]
AS
-------------------------------------------------------------------------
-- [vwDimHairSystemDensity] is used to retrieve a
-- list of Hair System Density Records
--
--   SELECT * FROM [bi_cms_dds].[vwDimHairSystemDensity]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/24/2011  KMurdoch     Initial Creation
-------------------------------------------------------------------------


SELECT [HairSystemDensityKey]
      ,[HairSystemDensitySSID]
      ,[HairSystemDensitySortOrder]
      ,[HairSystemDensityDescription]
      ,[HairSystemDensityDescriptionShort]
      ,[HairSystemDensityDescriptionShort] + ' - ' + [HairSystemDensityDescription]
			as 'HairSystemDensityDescriptionCalc'
      ,[Active]
      ,[RowIsCurrent]
      ,[RowStartDate]
      ,[RowEndDate]
  FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimHairSystemDensity]
