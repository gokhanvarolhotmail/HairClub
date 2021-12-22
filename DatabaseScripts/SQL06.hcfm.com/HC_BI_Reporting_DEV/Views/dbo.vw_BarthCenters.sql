CREATE VIEW [dbo].[vw_BarthCenters]
AS

SELECT  DC.CenterSSID
FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
            ON DC.RegionKey = DR.RegionKey
WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[578]%'
        AND DC.Active = 'Y'
        AND DR.RegionSSID = 6
