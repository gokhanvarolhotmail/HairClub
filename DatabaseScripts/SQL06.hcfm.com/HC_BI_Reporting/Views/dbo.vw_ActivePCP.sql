CREATE VIEW [dbo].[vw_ActivePCP]
AS

SELECT  CTR.CenterDescriptionNumber AS 'Center'
,       CLT.ClientIdentifier AS 'ClientNumber'
,       CLT.ClientFirstName AS 'FirstName'
,       CLT.ClientLastName AS 'LastName'
,       CLT.ClientAddress1 AS 'Address'
,		CLT.City
,		CLT.StateProvinceDescription AS 'State'
,		CLT.CountryRegionDescriptionShort AS 'Country'
,		CLT.PostalCode AS 'Zip'
,		CASE WHEN CLT.ClientPhone1 ='0000000000' THEN CLT.ClientPhone2 ELSE CLT.ClientPhone1 END AS 'Phone'
,		CASE WHEN CLT.ClientPhone1 ='0000000000' THEN CLT.ClientPhone2TypeDescription ELSE CLT.ClientPhone1TypeDescription END AS 'PhoneType'
,       DM.MembershipDescription AS 'Membership'
FROM    HC_Accounting.dbo.FactPCPDetail FPD
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON DD.DateKey = FPD.DateKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON CTR.CenterKey = FPD.CenterKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
            ON CLT.ClientKey = FPD.ClientKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
            ON DM.MembershipKey = FPD.MembershipKey
WHERE   MONTH(DD.FullDate) = MONTH(GETDATE())
        AND YEAR(DD.FullDate) = YEAR(GETDATE())
        AND ( FPD.PCP - FPD.EXT - FPD.XTR ) = 1
