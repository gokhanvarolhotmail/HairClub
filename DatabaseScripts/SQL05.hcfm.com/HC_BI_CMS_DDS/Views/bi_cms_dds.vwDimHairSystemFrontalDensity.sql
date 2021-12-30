/* CreateDate: 06/27/2011 16:35:34.067 , ModifyDate: 10/03/2019 22:52:22.313 */
GO
CREATE VIEW [bi_cms_dds].[vwDimHairSystemFrontalDensity]
AS
-------------------------------------------------------------------------
-- [vwDimHairSystemDensity] is used to retrieve a
-- list of Hair System Frontal Density Records
--
--   SELECT * FROM [bi_cms_dds].[vwDimHairSystemFrontalDensity]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/24/2011  KMurdoch     Initial Creation
-------------------------------------------------------------------------


SELECT [HairSystemFrontalDensityKey]
      ,[HairSystemFrontalDensitySSID]
      ,[HairSystemFrontalDensityDescription]
      ,[HairSystemFrontalDensityDescriptionShort]
      ,[HairSystemFrontalDensityDescriptionShort]+' - '+[HairSystemFrontalDensityDescription]
			as 'HairSystemFrontalDensityDescriptionCalc'
      ,[HairSystemFrontalDensitySortOrder]
      ,[Active]
      ,[RowIsCurrent]
      ,[RowStartDate]
      ,[RowEndDate]

  FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimHairSystemFrontalDensity]
GO
