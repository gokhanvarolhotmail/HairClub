CREATE VIEW [bi_cms_dds].[vwDimHairSystemTexture]
AS
-------------------------------------------------------------------------
-- [vwDimHairSystemDensity] is used to retrieve a
-- list of Hair System Texture records
--
--   SELECT * FROM [bi_cms_dds].[vwDimHairSystemTexture]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/24/2011  KMurdoch     Initial Creation
-------------------------------------------------------------------------

SELECT [HairSystemTextureKey]
      ,[HairSystemTextureSSID]
      ,[HairSystemTextureDescription]
      ,[HairSystemTextureDescriptionShort]
      ,[HairSystemTextureDescriptionShort]+' - '+[HairSystemTextureDescription]
		 as 'HairSystemTextureDescriptionCalc'
      ,[HairSystemTextureSortOrder]
      ,[Active]
      ,[RowIsCurrent]
      ,[RowStartDate]
      ,[RowEndDate]

  FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimHairSystemTexture]
