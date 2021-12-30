/* CreateDate: 07/13/2020 13:45:46.833 , ModifyDate: 07/13/2020 13:45:46.833 */
GO
CREATE VIEW vw_Center AS
-------------------------------------------------------------------------
-- [vw_Center] is used to retrieve a
-- list of Centers

-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    07/13/2020  KMurdoch       Initial Creation

-------------------------------------------------------------------------

SELECT CenterNumber AS 'CenterNumber',
       CenterDescription AS 'CenterDescription',
       CenterDescriptionNumber AS 'CenterDescriptionNumber',
       CountryRegionDescriptionShort AS CountryAbbrev,
       CountryRegionDescription AS 'Country',
       StateProvinceDescriptionShort AS 'StateProvinceAbbrev',
       StateProvinceDescription AS 'StateProvince',
       City,
       PostalCode AS 'CenterPostalCode'
FROM HC_BI_ENT_DDS.[bi_ent_dds].[DimCenter];
GO
