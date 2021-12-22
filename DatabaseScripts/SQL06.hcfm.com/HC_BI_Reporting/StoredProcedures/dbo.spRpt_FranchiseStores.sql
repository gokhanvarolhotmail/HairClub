/***********************************************************************
PROCEDURE:				spRpt_FranchiseStores
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Corporate Stores
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		01/16/2014
------------------------------------------------------------------------
NOTES:
02/20/2017 - RH - Added IS NULL statements to the #managers' WHERE clause - for centers with no manager assigned.  (Center 820 - Sarasota was missing)
04/18/2018 - RH - Change logic to pull from a new table, FranchiseDirectory, that is populated with the data supplied from Joe Barth (#148826)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_FranchiseStores

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_FranchiseStores]

AS
BEGIN

	SET FMTONLY OFF;
	SET NOCOUNT OFF;


/***********Create temp tables***************************************/


CREATE TABLE #franchise(
	RegionKey INT
,	RegionSSID INT
,	RegionDescription NVARCHAR(50)
,	CenterKey INT
,	CenterNumber INT
,	CenterSSID	INT
,	CenterDescriptionNumber NVARCHAR(103)
,	Owners NVARCHAR(102)
,	Manager	NVARCHAR(102)
,	AssistantManager	NVARCHAR(102)
,	CenterAddress1	NVARCHAR(50)
,	CenterAddress2	NVARCHAR(50)
,	City	NVARCHAR(50)
,	StateProvinceDescriptionShort  NVARCHAR(10)
,	PostalCode	NVARCHAR(15)
,	CenterPhone	 NVARCHAR(20)
,	CenterPhone2	NVARCHAR(20)
,	Backline	NVARCHAR(20)
,	NB1 NVARCHAR(250)
,	CRM NVARCHAR(250)
	)


/********************************************************************/


INSERT INTO #franchise
SELECT R.RegionKey
,	R.RegionSSID
,	R.RegionDescription
,	FD.CenterKey
,	FD.CenterNumber
,	FD.CenterSSID
,	FD.CenterDescriptionNumber
,	FD.Owners
,	FD.Manager
,	FD.AssistantManager
,	FD.CenterAddress1
,	FD.CenterAddress2
,	FD.City
,	FD.StateProvinceDescriptionShort
,	FD.PostalCode
,	FD.CenterPhone
,	C.CenterPhone2
,	FD.Backline
,	FD.NB1
,	FD.CRM
FROM dbo.FranchiseDirectory FD
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
	ON C.CenterKey = FD.CenterKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
	ON C.RegionKey = R.RegionKey
WHERE C.Active = 'Y'




SELECT * FROM #franchise


END
