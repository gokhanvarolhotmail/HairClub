/* CreateDate: 10/03/2019 23:03:43.663 , ModifyDate: 10/03/2019 23:03:43.663 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
