/* CreateDate: 06/27/2011 16:35:34.050 , ModifyDate: 09/16/2019 09:33:49.893 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
