/* CreateDate: 06/27/2011 16:35:34.100 , ModifyDate: 09/16/2019 09:33:49.897 */
GO
CREATE VIEW [bi_cms_dds].[vwDimHairSystemCapSize]
AS
-------------------------------------------------------------------------
-- [vwDimHairSystemCapSize] is used to retrieve a
-- list of Cap Sizes
--
--   SELECT * FROM [bi_cms_dds].[vwDimHairSystemCapSize]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/24/2011  KMurdoch     Initial Creation
-------------------------------------------------------------------------

SELECT [HairSystemCapSizeKey]
      ,[HairSystemCapSizeDescription]
      ,[HairSystemCapSizeDescriptionShort]
      ,[HairSystemCapSizeDescriptionSortOrder]
      ,[RowIsCurrent]
      ,[RowStartDate]
      ,[RowEndDate]
  FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimHairSystemCapSize]
GO
