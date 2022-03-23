/* CreateDate: 03/17/2022 11:57:11.547 , ModifyDate: 03/17/2022 11:57:11.547 */
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
