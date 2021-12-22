/***********************************************************************
VIEW:					[vw_dashbdActivePCP]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR:			Rachelen Hut
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM dbo.[vw_dashbdActivePCP]
***********************************************************************/
CREATE VIEW [dbo].[vw_dashbdActivePCP]
AS
SELECT  DC.CenterDescriptionNumber AS 'Center'
,       CONVERT(VARCHAR, DCLT.ClientIdentifier) + ' - ' + DCLT.ClientFullName AS 'Client'
,       DCLT.ClientAddress1 AS 'Address'
,		DCLT.City
,		DCLT.StateProvinceDescription AS 'State'
,		DCLT.CountryRegionDescriptionShort AS 'Country'
,		DCLT.PostalCode AS 'Zip'
,		CASE WHEN DCLT.ClientPhone1 ='0000000000' THEN DCLT.ClientPhone2 ELSE DCLT.ClientPhone1 END AS 'Phone'
,		CASE WHEN DCLT.ClientPhone1 ='0000000000' THEN DCLT.ClientPhone2TypeDescription ELSE DCLT.ClientPhone1TypeDescription END AS 'PhoneType'
,       DM.MembershipDescription AS 'Membership'
FROM    HC_Accounting.dbo.FactPCPDetail FPD
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FPD.DateKey = DD.DateKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
            ON FPD.CenterKey = DC.CenterKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DCLT
            ON FPD.ClientKey = DCLT.ClientKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
            ON FPD.MembershipKey = DM.MembershipKey
WHERE   FPD.PCP - FPD.EXT = 1
