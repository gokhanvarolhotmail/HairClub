/* CreateDate: 07/03/2014 12:09:00.250 , ModifyDate: 07/14/2014 15:05:27.077 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[pop_dashbdActivePCP]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:
AUTHOR:					Rachelen Hut

------------------------------------------------------------------------
CHANGE HISTORY:
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [pop_dashbdActivePCP]
***********************************************************************/
CREATE PROCEDURE [dbo].[pop_dashbdActivePCP]

AS
BEGIN

	SET ARITHABORT OFF
	SET ANSI_WARNINGS OFF

	CREATE TABLE #activepcp
		(Center NVARCHAR(100)
		,	ClientKey INT
		,   Client  NVARCHAR(100)
		,   [Address]  NVARCHAR(100)
		,	City  NVARCHAR(100)
		,	[State]  NVARCHAR(100)
		,	Country  NVARCHAR(100)
		,	Zip  NVARCHAR(100)
		,	Phone  NVARCHAR(100)
		,	PhoneType  NVARCHAR(100)
		,   Membership  NVARCHAR(100))

	INSERT INTO #activepcp
	SELECT  DC.CenterDescriptionNumber AS 'Center'
		,	FPD.ClientKey
		,   CONVERT(VARCHAR, DCLT.ClientKey) + ' - ' + DCLT.ClientFullName AS 'Client'
		,	DCLT.ClientAddress1 AS 'Address'
		,	DCLT.City
		,	DCLT.StateProvinceDescription AS 'State'
		,	DCLT.CountryRegionDescriptionShort AS 'Country'
		,	DCLT.PostalCode AS 'Zip'
		,	CASE WHEN DCLT.ClientPhone1 ='0000000000' THEN DCLT.ClientPhone2 ELSE DCLT.ClientPhone1 END AS 'Phone'
		,	CASE WHEN DCLT.ClientPhone1 ='0000000000' THEN DCLT.ClientPhone2TypeDescription ELSE DCLT.ClientPhone1TypeDescription END AS 'PhoneType'
		,	DM.MembershipDescription AS 'Membership'
	FROM HC_Accounting.dbo.FactPCPDetail FPD
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FPD.DateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FPD.CenterKey = DC.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DCLT
			ON FPD.ClientKey = DCLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON FPD.MembershipKey = DM.MembershipKey
	WHERE FPD.PCP - FPD.EXT = 1
	ORDER BY DCLT.ClientLastName
		,	DCLT.ClientFirstName


--merge records with Target and Source --Populate the table dashbdActivePCP
MERGE dashbdActivePCP AS Target
USING (SELECT Center
		,	ClientKey
		,   Client
		,   [Address]
		,	City
		,	[State]
		,	Country
		,	Zip
		,	Phone
		,	PhoneType
		,   Membership
		FROM #activepcp
		GROUP BY Center
		,	ClientKey
		,   Client
		,   [Address]
		,	City
		,	[State]
		,	Country
		,	Zip
		,	Phone
		,	PhoneType
		,   Membership) AS Source
ON (Target.Center = Source.Center AND Target.ClientKey = Source.ClientKey
		AND Target.Membership = Source.Membership
		AND Target.Zip = Source.Zip
		AND Target.Phone = Source.Phone
		AND Target.PhoneType = Source.PhoneType )
WHEN MATCHED THEN
	UPDATE SET Target.Client = Source.Client
	,	Target.[Address] = Source.[Address]
	,	Target.City = Source.City
	,	Target.[State] = Source.[State]
	,	Target.Country = Source.Country
	,	Target.Zip = Source.Zip
		,	Target.Phone = Source.Phone
	,	Target.PhoneType = Source.PhoneType
	,	Target.Membership = Source.Membership

WHEN NOT MATCHED BY TARGET THEN
	INSERT(Center
		,	ClientKey
		,   Client
		,   [Address]
		,	City
		,	[State]
		,	Country
		,	Zip
		,	Phone
		,	PhoneType
		,   Membership  )
	VALUES(Source.Center
	,	Source.ClientKey
	,	Source.Client
	,	Source.[Address]
	,	Source.City
	,	Source.[State]
	,	Source.Country
	,	Source.Zip
	,	Source.Phone
	,	Source.PhoneType
	,	Source.Membership )
;


END
GO
