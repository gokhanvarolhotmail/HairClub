/* CreateDate: 12/30/2015 15:36:56.123 , ModifyDate: 01/04/2017 14:11:28.500 */
GO
--select * from [vw_AreaManager]ORDER BY RegionSortOrder, EmployeeFullName

--select DISTINCT EmployeeKey, CenterManagementAreaDescription from [vw_AreaManager]

CREATE VIEW [dbo].[vw_AreaManager]
AS

SELECT  CTR.CenterKey
,       CTR.CenterSSID
,		DR.RegionKey
,       DR.RegionSSID
,       DR.RegionSortOrder
,       CTR.CenterTypeKey
,       CTR.CenterDescription
,       CTR.CenterDescriptionNumber
,		CTR.Active
,		COALESCE(CMA.OperationsManagerSSID, CTR.RegionROMOperationsManagerSSID) AS 'OperationsManagerSSID'
,		COALESCE(DE.EmployeeKey,DE2.EmployeeKey) AS 'EmployeeKey'
,       CMA.CenterManagementAreaDescription AS 'EmployeeFullName'
,       CMA.CenterManagementAreaSSID
,       CMA.CenterManagementAreaDescription
,       DR.RegionDescription
,       CMA.CenterManagementAreaSortOrder
FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
            ON DR.RegionKey = CTR.RegionKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON CMA.CenterManagementAreaSSID = CTR.CenterManagementAreaSSID
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
				ON DE.EmployeeSSID = CMA.OperationsManagerSSID
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE2
				ON DE2.EmployeeSSID = CTR.RegionROMOperationsManagerSSID
WHERE   CTR.CenterSSID LIKE '[2]%'
        AND CTR.Active = 'Y'
		AND CMA.Active = 'Y'
GO
