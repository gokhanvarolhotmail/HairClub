CREATE VIEW [bi_cms_dds].[vwDimHairSystemType]
AS
-------------------------------------------------------------------------
-- [vwDimHairSystemDensity] is used to retrieve a
-- list of Hair System Texture records
--
--   SELECT * FROM [bi_cms_dds].[vwDimHairSystemType]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/24/2011  KMurdoch     Initial Creation
-------------------------------------------------------------------------

SELECT [HairSystemTypeKey]
      ,[HairSystemTypeSSID]
      ,[HairSystemTypeDescription]
      ,[HairSystemTypeDescriptionShort]
      ,[HairSystemTypeSortOrder]
      ,[HairSystemTypeDescriptionShort] + ' - ' + [HairSystemTypeDescription]
			as 'HairSystemTypeDescriptionCalc'
      ,[Active]
      ,[RowIsCurrent]
      ,[RowStartDate]
      ,[RowEndDate]

  FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimHairSystemType]
