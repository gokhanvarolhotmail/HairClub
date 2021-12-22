/* CreateDate: 01/16/2014 15:34:24.760 , ModifyDate: 02/20/2017 16:30:54.900 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

	IF OBJECT_ID('tempdb..#managers')IS NOT NULL
	BEGIN
		DROP TABLE #managers
	END

	CREATE TABLE #managers  (
		ID INT IDENTITY(1,1)
		,	CenterSSID INT
		,	CenterDescriptionNumber NVARCHAR(103)
		,	CenterDescription NVARCHAR(50)
		,	Manager NVARCHAR(102))

	IF OBJECT_ID('tempdb..#rank')IS NOT NULL
	BEGIN
		DROP TABLE #rank
	END

	CREATE TABLE #rank(
	CenterSSID INT
	,	Manager NVARCHAR(102)
	,	TPRANK INT)

	IF OBJECT_ID('tempdb..#franchise')IS NOT NULL
	BEGIN
		DROP TABLE #franchise
	END

	CREATE TABLE #franchise(
		CenterSSID	INT
		,	CenterDescriptionNumber NVARCHAR(103)
		,	CenterDescription NVARCHAR(50)
		,	Manager1	NVARCHAR(102)
		,	Manager2	NVARCHAR(102)
		,	CenterAddress1	NVARCHAR(50)
		,	CenterAddress2	NVARCHAR(50)
		,	City	NVARCHAR(50)
		,	StateProvinceDescriptionShort  NVARCHAR(10)
		,	PostalCode	NVARCHAR(15)
		,	CenterPhone1	NVARCHAR(15)
		,	CenterPhone2	NVARCHAR(15)
		,	CenterPhone3	NVARCHAR(15)
		)


	/********************************************************************/
	--Find the Managers - where EmployeePositionSSID = 6
	INSERT INTO #managers
	SELECT C.CenterSSID, C.CenterDescriptionNumber, C.CenterDescription, E.EmployeeFullName AS 'Manager'
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
	LEFT JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployee E
		ON E.CenterSSID = C.CenterSSID
	LEFT JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimEmployeePositionJoin] EPJ
		ON E.EmployeeSSID = EPJ.EmployeeGUID
	LEFT JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimEmployeePosition] EP
		ON EPJ.EmployeePositionID = EP.EmployeePositionSSID
	WHERE C.CenterSSID LIKE '[78]%'
		AND C.Active = 'Y'
		AND (EP.EmployeePositionSSID IS NULL OR EP.EmployeePositionSSID = 16)
		AND (E.IsActiveFlag IS NULL OR E.IsActiveFlag = 1)
		AND (E.EmployeeFullName IS NULL OR E.EmployeeFullName NOT LIKE 'MGRTEST%')

	--Assign a 1 or 2 to the managers where there are multiple managers (Manager and Assistant Manager)
	INSERT INTO #rank
	SELECT CenterSSID, Manager
	,ROW_NUMBER() OVER(PARTITION BY CenterSSID ORDER BY Manager DESC) TPRANK
	FROM #managers
	WHERE CenterSSID IN(SELECT CenterSSID FROM #managers)

	--Assign Manager1 into the final table - WHERE TPRANK = 1
	INSERT INTO #franchise
	SELECT m.CenterSSID
		,	m.CenterDescriptionNumber
		,	m.CenterDescription
		,	r.Manager AS Manager1
		,	NULL AS Manager2
		,	NULL AS CenterAddress1
		,	NULL AS CenterAddress2
		,	NULL AS City
		,	NULL AS StateProvinceDescriptionShort
		,	NULL AS PostalCode
		,	NULL AS CenterPhone1
		,	NULL AS CenterPhone2
		,	NULL AS CenterPhone3
	FROM #managers m
	INNER JOIN #rank r
		ON r.CenterSSID = m.CenterSSID
	WHERE TPRANK = 1
	GROUP BY m.CenterSSID
		,	m.CenterDescriptionNumber
		,	m.CenterDescription
		,	r.Manager
	ORDER BY CenterSSID

	--SELECT * FROM #franchise

	--UPDATE with Manager2 where Manager2 has a value from #rank - WHERE TPRANK = 2
	UPDATE f
	SET Manager2 = r.Manager
	FROM #franchise f
	INNER JOIN #rank r
	ON f.CenterSSID = r.CenterSSID
	WHERE TPRANK = 2
	AND f.Manager2 IS NULL


	--UPDATE final table with values from DimCenter
	UPDATE f
	SET f.CenterAddress1 = C.CenterAddress1
	,	f.CenterAddress2 = C.CenterAddress2
	,	f.City = C.City
	,	f.StateProvinceDescriptionShort = C.StateProvinceDescriptionShort
	,	f.PostalCode = C.PostalCode
	,	f.CenterPhone1 = C.CenterPhone1
	,	f.CenterPhone2 = C.CenterPhone2
	,	f.CenterPhone3 = C.CenterPhone3
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
	INNER JOIN #franchise f
		ON f.CenterSSID = C.CenterSSID

	SELECT * FROM #franchise


END
GO
