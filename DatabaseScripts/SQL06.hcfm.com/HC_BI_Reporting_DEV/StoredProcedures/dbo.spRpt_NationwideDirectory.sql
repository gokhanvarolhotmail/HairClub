/* CreateDate: 12/16/2014 10:25:33.753 , ModifyDate: 07/07/2020 13:17:51.960 */
GO
/***********************************************************************
PROCEDURE:				spRpt_NationwideDirectory
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			rptNationwideDirectory
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		01/16/2014
------------------------------------------------------------------------
NOTES:
12/22/2014	RH	Added Assistant Regional Directors as Managers
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_NationwideDirectory

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_NationwideDirectory]

AS
BEGIN

	SET FMTONLY OFF;
	SET NOCOUNT OFF;

	/***********Create temp tables***************************************/


	CREATE TABLE #managers  (
		ID INT IDENTITY(1,1)
		,	CenterSSID INT
		,	CenterDescriptionNumber NVARCHAR(103)
		,	CenterDescription VARCHAR(50)
		,	Manager NVARCHAR(102)
		)


	CREATE TABLE #rank(
	CenterSSID INT
	,	Manager NVARCHAR(102)
	,	TPRANK INT)


	CREATE TABLE #corp(
		ID INT IDENTITY(1,1)
		,	RegionSSID INT
		,	RegionDescription NVARCHAR(50)
		,	CenterSSID	INT
		,	CenterDescriptionNumber NVARCHAR(103)
		,	CenterDescription NVARCHAR(50)
		,	Manager1	NVARCHAR(102)
		,	Manager2	NVARCHAR(102)
		,	CenterAddress1	NVARCHAR(50)
		,	CenterAddress2	NVARCHAR(50)
		,	City	NVARCHAR(50)
		,	StateProvinceDescriptionShort  NVARCHAR(10)
		,	StateProvinceDescription NVARCHAR(100)
		,	PostalCode	NVARCHAR(15)
		,	CenterPhone1	NVARCHAR(15)
		,	CenterPhone2	NVARCHAR(15)
		,	CenterPhone3	NVARCHAR(15)
		,	CenterOwnershipDescription NVARCHAR(50)
		,	CenterTypeDescriptionShort NVARCHAR(10)
		,	CenterType NVARCHAR(15)
		)

	/********************************************************************/
	--Find the Managers - where EmployeePositionSSID = 6
	INSERT INTO #managers
	SELECT DC.CenterSSID
	,	DC.CenterDescriptionNumber
	,	DC.CenterDescription
	,	E.EmployeeFullName AS 'Manager'
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
	LEFT JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployee E
		ON E.CenterSSID = DC.CenterSSID
	LEFT JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimEmployeePositionJoin] EPJ
		ON E.EmployeeSSID = EPJ.EmployeeGUID
	LEFT JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimEmployeePosition] EP
		ON EPJ.EmployeePositionID = EP.EmployeePositionSSID
	WHERE (CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
				OR CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%')
		AND DC.Active = 'Y'
		AND EP.EmployeePositionSSID IN(6,16,47)
		AND E.IsActiveFlag = 1
		AND E.EmployeeFullName NOT LIKE '%Test'
		AND E.EmployeeFullName NOT LIKE '%EC'

	--Insert Assistant Regional Director D'Souza into #managers
	INSERT INTO #managers
	        ( CenterSSID
	       , CenterDescriptionNumber
	       , CenterDescription
	       , Manager
	        )
	VALUES  (229, '229 - Toronto', 'Toronto', 'Simon D''Souza')

	--Assign a 1 or 2 to the managers where there are multiple managers (Manager and Assistant Manager)
	INSERT INTO #rank
	SELECT CenterSSID, Manager
	,ROW_NUMBER() OVER(PARTITION BY CenterSSID ORDER BY Manager DESC) TPRANK
	FROM #managers
	WHERE CenterSSID IN(SELECT CenterSSID FROM #managers)
	GROUP BY #managers.CenterSSID, #managers.Manager

	--Assign Manager1 into the final table - WHERE TPRANK = 1
	INSERT INTO #corp
	SELECT  DR.RegionSSID
	,	DR.RegionDescription
	,	DC.CenterSSID
		,	DC.CenterDescriptionNumber
		,	DC.CenterDescription
		,	NULL AS Manager1
		,	NULL AS Manager2
		,	DC.CenterAddress1
		,	DC.CenterAddress2
		,	DC.City
		,	DC.StateProvinceDescriptionShort
		,	DC.StateProvinceDescription
		,	DC.PostalCode
		,	DC.CenterPhone1
		,	DC.CenterPhone2
		,	DC.CenterPhone3
		,	DCO.CenterOwnershipDescription
		,	DCT.CenterTypeDescriptionShort
		,	DCT.CenterTypeDescription AS 'CenterType'
	FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
				ON DC.CenterTypeKey = DCT.CenterTypeKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
				ON DC.RegionKey = DR.RegionKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterOwnership DCO
				ON DC.CenterOwnershipKey = DCO.CenterOwnershipKey
	WHERE   DCT.CenterTypeDescriptionShort IN ( 'C', 'HW', 'JV', 'F' )
			AND DC.Active = 'Y'

	--UPDATE with Manager1 where Manager1 has a value from #rank - WHERE TPRANK = 1
	UPDATE cor
	SET Manager1 = r.Manager
	FROM #corp cor
	INNER JOIN #rank r
	ON cor.CenterSSID = r.CenterSSID
	WHERE TPRANK = 1
	AND cor.Manager2 IS NULL

	--UPDATE with Manager2 where Manager2 has a value from #rank - WHERE TPRANK = 2
	UPDATE cor
	SET Manager2 = r.Manager
	FROM #corp cor
	INNER JOIN #rank r
	ON cor.CenterSSID = r.CenterSSID
	WHERE TPRANK = 2
	AND cor.Manager2 IS NULL


	/*********************************** Final Select ****************************************/

	SELECT RegionSSID
		,	RegionDescription
		,	CenterSSID
		,	CenterDescriptionNumber
		,	CenterDescription
		,	Manager1
		,	Manager2
		,	CenterAddress1
		,	CenterAddress2
		,	City
		,	StateProvinceDescriptionShort
		,	StateProvinceDescription
		,	PostalCode
		,	CenterPhone1
		,	CenterPhone2
		,	CenterPhone3
		,	CenterOwnershipDescription
		,	CenterTypeDescriptionShort
		,	CenterType
	FROM #corp
	ORDER BY CenterDescriptionNumber


END
GO
