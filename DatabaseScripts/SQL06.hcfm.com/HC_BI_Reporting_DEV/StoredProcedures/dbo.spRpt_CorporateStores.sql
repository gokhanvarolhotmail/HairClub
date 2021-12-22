/***********************************************************************
PROCEDURE:				spRpt_CorporateStores
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Corporate Stores
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		01/16/2014
------------------------------------------------------------------------
NOTES:
12/22/2014 - RH - Added Assistant Regional Directors as Managers
04/17/2015 - RH - Changed the Employee Position query for managers to join on AD groups.
02/17/2017 - RH - Added CenterAddress3 (#135994)
06/17/2019 - RH - Added Hans Wiemann (Case 11759)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_CorporateStores

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_CorporateStores]
AS
BEGIN

	SET FMTONLY OFF;
	SET NOCOUNT OFF;

	/***********Create temp tables***************************************/

	IF OBJECT_ID('tempdb..#managers')IS NOT NULL
	BEGIN
		DROP TABLE #managers
	END

	CREATE TABLE #managers  (
		ID INT IDENTITY(1,1)
		,	CenterSSID INT
		,	CenterDescriptionNumber NVARCHAR(103)
		,	CenterDescription VARCHAR(50)
		,	Manager NVARCHAR(102))

	IF OBJECT_ID('tempdb..#rank')IS NOT NULL
	BEGIN
		DROP TABLE #rank
	END

	CREATE TABLE #rank(
	CenterSSID INT
	,	Manager NVARCHAR(102)
	,	TPRANK INT)

	IF OBJECT_ID('tempdb..#corp')IS NOT NULL
	BEGIN
		DROP TABLE #corp
	END

	CREATE TABLE #corp(
		ID INT IDENTITY(1,1)
		,	CenterSSID	INT
		,	CenterDescriptionNumber NVARCHAR(103)
		,	CenterDescription NVARCHAR(50)
		,	Manager1	NVARCHAR(102)
		,	Manager2	NVARCHAR(102)
		,	CenterAddress1	NVARCHAR(50)
		,	CenterAddress2	NVARCHAR(50)
		,	CenterAddress3	NVARCHAR(50)
		,	City	NVARCHAR(50)
		,	StateProvinceDescriptionShort  NVARCHAR(10)
		,	PostalCode	NVARCHAR(15)
		,	CenterPhone1	NVARCHAR(15)
		,	CenterPhone2	NVARCHAR(15)
		,	CenterPhone3	NVARCHAR(15)
		)

	/********************************************************************/
	--Find the Managers
	/*ActiveDirectoryGroupID	ActiveDirectoryGroup
		416						Role_Ops Managing Director
		419						Role_Ops Regional Assistant Director*/

	INSERT INTO #managers
	SELECT C.CenterSSID
	,	C.CenterDescriptionNumber
	,	C.CenterDescription
	,	E.EmployeeFullName AS 'Manager'

	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
	LEFT JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployee E
		ON E.CenterSSID = C.CenterSSID
	LEFT JOIN SQL05.HairclubCMS.dbo.cfgEmployeeActiveDirectoryGroupJoin eadgj
		ON E.EmployeeSSID = eadgj.EmployeeGUID
	WHERE C.CenterTypeSSID = 1
		AND C.Active = 'Y'
		AND E.IsActiveFlag = 1
		AND E.EmployeeFirstName NOT IN ( 'EC', 'Test' )
		AND eadgj.ActiveDirectoryGroupID IN(416,419)
	GROUP BY C.CenterSSID
	,	C.CenterDescriptionNumber
	,	C.CenterDescription
	,	E.EmployeeFullName

		--ORDER BY CenterSSID
		--SELECT * FROM #managers

	--Assign a 1 or 2 to the managers where there are multiple managers (Manager and Assistant Manager)
	INSERT INTO #rank
	SELECT CenterSSID, Manager
	,ROW_NUMBER() OVER(PARTITION BY CenterSSID ORDER BY Manager DESC) TPRANK
	FROM #managers
	WHERE CenterSSID IN(SELECT CenterSSID FROM #managers)
	GROUP BY #managers.CenterSSID, #managers.Manager

	--SELECT * FROM #managers

	--SELECT * FROM #rank

	INSERT INTO #corp
	SELECT DC.CenterSSID
		,	DC.CenterDescriptionNumber
		,	DC.CenterDescription
		,	NULL AS Manager1
		,	NULL AS Manager2
		,	DC.CenterAddress1
		,	DC.CenterAddress2
		,	DC.CenterAddress3
		,	DC.City
		,	DC.StateProvinceDescriptionShort
		,	DC.PostalCode
		,	DC.CenterPhone1
		,	DC.CenterPhone2
		,	DC.CenterPhone3
	FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
			ON DC.CenterTypeKey = DCT.CenterTypeKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
			ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
			ON DC.RegionKey = DR.RegionKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterOwnership DCO
			ON DC.CenterOwnershipKey = DCO.CenterOwnershipKey
	WHERE   DCT.CenterTypeDescriptionShort IN('C','HW')
			AND DC.CenterSSID <> 100
			AND DC.Active = 'Y'
			AND CMA.Active = 'Y'

	--UPDATE with Manager1 where Manager1 has a value from #rank - WHERE TPRANK = 1
	UPDATE cor
	SET Manager1 = r.Manager
	FROM #corp cor
	INNER JOIN #rank r
	ON cor.CenterSSID = r.CenterSSID
	WHERE TPRANK = 1
	AND cor.Manager1 IS NULL

	--UPDATE with Manager2 where Manager2 has a value from #rank - WHERE TPRANK = 2
	UPDATE cor
	SET Manager2 = r.Manager
	FROM #corp cor
	INNER JOIN #rank r
	ON cor.CenterSSID = r.CenterSSID
	WHERE TPRANK = 2
	AND cor.Manager2 IS NULL



	SELECT ID
		,	CenterSSID
		,	CenterDescriptionNumber
		,	CenterDescription
		,	Manager1
		,	Manager2
		,	CenterAddress1
		,	CenterAddress2
		,	CenterAddress3
		,	City
		,	StateProvinceDescriptionShort
		,	PostalCode
		,	CenterPhone1
		,	CenterPhone2
		,	CenterPhone3
	FROM #corp
	ORDER BY CenterDescription

END
