/* CreateDate: 06/27/2011 16:35:34.037 , ModifyDate: 09/16/2019 09:33:49.893 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bi_cms_dds].[vwDimHairSystemMatrixColor]
AS
-------------------------------------------------------------------------
-- [vwDimHairSystemDensity] is used to retrieve a
-- list of Hair System Frontal Density Records
--
--   SELECT * FROM [bi_cms_dds].[vwDimHairSystemMatrixColor]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/24/2011  KMurdoch     Initial Creation
-------------------------------------------------------------------------


SELECT [HairSystemMatrixColorKey]
      ,[HairSystemMatrixColorSSID]
      ,[HairSystemMatrixColorDescription]
      ,[HairSystemMatrixColorDescriptionShort]
      ,[HairSystemMatrixColorSortOrder]
      ,[HairSystemMatrixColorDescriptionShort]+' - '+[HairSystemMatrixColorDescription]
			as 'HairSystemMatrixColorDescriptionCalc'
      ,[Active]
      ,[RowIsCurrent]
      ,[RowStartDate]
      ,[RowEndDate]

  FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimHairSystemMatrixColor]
GO
