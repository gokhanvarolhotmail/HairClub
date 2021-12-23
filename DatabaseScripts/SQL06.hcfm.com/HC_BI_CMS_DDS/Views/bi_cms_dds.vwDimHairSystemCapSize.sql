/* CreateDate: 10/03/2019 23:03:43.627 , ModifyDate: 10/03/2019 23:03:43.627 */
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