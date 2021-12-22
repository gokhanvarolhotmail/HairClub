/* CreateDate: 06/27/2011 16:35:33.977 , ModifyDate: 09/16/2019 09:33:49.890 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
