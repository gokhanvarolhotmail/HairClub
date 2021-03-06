/* CreateDate: 03/17/2022 11:57:11.753 , ModifyDate: 03/17/2022 11:57:11.753 */
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
