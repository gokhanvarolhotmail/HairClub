/* CreateDate: 01/10/2014 15:57:54.060 , ModifyDate: 08/30/2018 09:40:28.380 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:	[spSVC_GetJKGClientsForExport]

DESTINATION SERVER:	   SQL06

DESTINATION DATABASE: HC_BI_Reporting

AUTHOR: Marlon Burrell

IMPLEMENTOR: Marlon Burrell

DATE IMPLEMENTED: 01/10/2014
------------------------------------------------------------------------
This procedure gets a list of all clients who have had some activity over
the past 15 months for export to JKG
------------------------------------------------------------------------
Notes:
------------------------------------------------------------------------
SAMPLE EXEC:
exec [spSVC_GetJKGClientsForExport]

***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_GetJKGClientsForExport] AS
BEGIN

	SELECT DISTINCT ctr.CenterNumber AS 'Center'
	,	CLT.ClientIdentifier AS 'Client_No'
	,	CLT.ClientLastName AS 'last_name'
	,	CLT.ClientFirstName AS 'first_name'
	,	CLT.ClientAddress1 AS 'address'
	,	CLT.City AS 'city'
	,	CLT.StateProvinceDescriptionShort AS 'state'
	,	CLT.PostalCode AS 'zip'
	,	CLT.ClientPhone1 AS 'Phone_home'
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterSSID = CLT.CenterSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
			ON CLT.ClientKey = FST.ClientKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
	WHERE DD.FullDate > DATEADD(MM, -15, GETDATE())
		AND ctr.CenterNumber LIKE '2%'
	ORDER BY ctr.CenterNumber
	,	CLT.ClientIdentifier

END
GO
