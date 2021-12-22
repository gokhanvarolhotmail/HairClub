/***********************************************************************
PROCEDURE:				spRpt_ActivePCPClients
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES:

12/11/2013 - DL - Created Stored Procedure
07/13/2015 - RH - Changed FactPCPDetail to vwFactPCPDetail to pull ActiveBIO only
07/30/2015 - DL - Created views on SQL06 HC_Accounting to limit unnecessary across server calls to SQL05
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_ActivePCPClients 0
EXEC spRpt_ActivePCPClients 220
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ActivePCPClients]
(
	@Center INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;

IF	@Center = 0
	BEGIN
		SELECT  CTR.CenterDescriptionNumber AS 'Center'
		,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'Client'
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
		ORDER BY CTR.CenterSSID
		,		CLT.ClientIdentifier
	END
ELSE
	BEGIN
		SELECT  CTR.CenterDescriptionNumber AS 'Center'
		,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'Client'
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
		WHERE   CTR.CenterSSID = @Center
				AND MONTH(DD.FullDate) = MONTH(GETDATE())
				AND YEAR(DD.FullDate) = YEAR(GETDATE())
				AND ( FPD.PCP - FPD.EXT - FPD.XTR ) = 1
		ORDER BY CTR.CenterSSID
		,		CLT.ClientIdentifier
	END

END
