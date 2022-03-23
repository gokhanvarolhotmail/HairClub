/* CreateDate: 03/17/2022 11:57:11.970 , ModifyDate: 03/17/2022 11:57:11.970 */
GO
CREATE VIEW [bi_cms_dds].[vwDimHairSystemStyle]
AS
-------------------------------------------------------------------------
-- [vwDimHairSystemDensity] is used to retrieve a
-- list of Hair System Style records
--
--   SELECT * FROM [bi_cms_dds].[vwDimHairSystemStyle]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/24/2011  KMurdoch     Initial Creation
-------------------------------------------------------------------------

SELECT [HairSystemStyleKey]
      ,[HairSystemStyleSSID]
      ,[HairSystemStyleDescription]
      ,[HairSystemStyleDescriptionShort]
      ,[HairSystemStyleDescriptionShort] + ' - ' + [HairSystemStyleDescription]
		as 'HairSystemStyleDescriptionCalc'
      ,[HairSystemStyleSortOrder]
      ,[Active]
      ,[RowIsCurrent]
      ,[RowStartDate]
      ,[RowEndDate]

  FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimHairSystemStyle]
GO
