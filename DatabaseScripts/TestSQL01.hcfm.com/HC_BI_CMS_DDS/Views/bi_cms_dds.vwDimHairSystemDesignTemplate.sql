/* CreateDate: 06/27/2011 16:35:34.080 , ModifyDate: 09/16/2019 09:33:49.897 */
GO
CREATE VIEW [bi_cms_dds].[vwDimHairSystemDesignTemplate]
AS
-------------------------------------------------------------------------
-- [vwDimHairSystemDesignTemplate] is used to retrieve a
-- list of Hair System Design Templates
--
--   SELECT * FROM [bi_cms_dds].[vwDimHairSystemDesignTemplate]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/24/2011  KMurdoch     Initial Creation
-------------------------------------------------------------------------


SELECT [HairSystemDesignTemplateKey]
      ,[HairSystemDesignTemplateSSID]
      ,[HairSystemDesignTemplateDescription]
      ,[HairSystemDesignTemplateDescriptionShort]
      ,[HairSystemDesignTemplateDescriptionShort] + ' - ' + [HairSystemDesignTemplateDescription]
			as 'HairSystemDesignTemplateDescriptionCalc'
      ,[HairSystemDesignTemplateSortOrder]
      ,[Active]
      ,[RowIsCurrent]
      ,[RowStartDate]
      ,[RowEndDate]
  FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimHairSystemDesignTemplate]
GO
