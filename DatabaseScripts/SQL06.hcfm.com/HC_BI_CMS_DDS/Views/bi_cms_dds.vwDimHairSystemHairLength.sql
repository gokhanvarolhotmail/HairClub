/* CreateDate: 03/17/2022 11:57:11.737 , ModifyDate: 03/17/2022 11:57:11.737 */
GO
CREATE VIEW [bi_cms_dds].[vwDimHairSystemHairLength]
AS
-------------------------------------------------------------------------
-- [vwDimHairSystemDensity] is used to retrieve a
-- list of Hair System Frontal Density Records
--
--   SELECT * FROM [bi_cms_dds].[vwDimHairSystemHairLength]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/24/2011  KMurdoch     Initial Creation
-------------------------------------------------------------------------


SELECT [HairSystemHairLengthKey]
      ,[HairSystemHairLengthSSID]
      ,[HairSystemHairLengthDescription]
      ,[HairSystemHairLengthDescriptionShort]
      ,[HairSystemHairLengthValue]
      ,[HairSystemHairLengthSortOrder]
      ,[Active]
      ,[RowIsCurrent]
      ,[RowStartDate]
      ,[RowEndDate]

  FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimHairSystemHairLength]
GO
