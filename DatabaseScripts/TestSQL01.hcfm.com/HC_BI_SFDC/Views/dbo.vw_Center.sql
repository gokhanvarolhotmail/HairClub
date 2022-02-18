/* CreateDate: 07/14/2020 07:28:32.583 , ModifyDate: 07/14/2020 07:31:58.900 */
GO
CREATE VIEW [dbo].[vw_Center] AS
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
       PostalCode AS 'CenterPostalCode',
	   DMADescription,
	   DMARegion,
	   ISNULL(CMA.CenterManagementAreaDescription, 'Unknown') AS 'CenterArea'
FROM HC_BI_ENT_DDS.[bi_ent_dds].[DimCenter] C
LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
ON CMA.CenterManagementAreaSSID = C.CenterManagementAreaSSID
GO
