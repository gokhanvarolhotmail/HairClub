/***********************************************************************
PROCEDURE:				[spRpt_CRM_ScorecardEmailList]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			[CRM_Scorecard]
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		7/22/2019
------------------------------------------------------------------------
NOTES:
This stored proc creates the list of email addresses for the subscription,
if there is no consultant, then the center manager, if no center manager, then the area manager
------------------------------------------------------------------------
CHANGE HISTORY:
08/20/2019 - (Email from TrishaG) Added MMangieri@hairclub.com for The Woodlands
08/20/2019 - (Email from TrishaG) Added MFaresh@hairclub.com for Glendale(214)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_CRM_ScorecardEmailList]
***********************************************************************/

CREATE PROCEDURE [dbo].[spRpt_CRM_ScorecardEmailList]
AS


BEGIN

SET FMTONLY OFF;

SELECT CTR.CenterNumber, CTR.CenterDescription
INTO #Centers
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
	ON CT.CenterTypeKey = CTR.CenterTypeKey
WHERE CT.CenterTypeDescriptionShort = 'C'
AND CTR.Active = 'Y'
AND CTR.CenterNumber NOT IN(100,199)


CREATE TABLE #CRMScorecardEmailList(
	CenterNumber  NVARCHAR(150)
,	EmployeeKey INT
,	EmployeeEmailAddress NVARCHAR(300)
,	[Subject] NVARCHAR(150)
,	[Copy]  NVARCHAR(300)
,	Position NVARCHAR(5)
)

INSERT INTO #CRMScorecardEmailList
SELECT CTR.CenterNumber
,	e.EmployeeKey
,   CASE WHEN e.UserLogin = 'JPetsche Flores' THEN 'JPetscheFlores@hairclub.com'
		ELSE REPLACE(e.UserLogin,' ','') + '@hairclub.com' END AS 'EmployeeEmailAddress'
,  'CRM Scorecard - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
,	CASE WHEN e.UserLogin IN('amallard') THEN 'tgoldsmith@hairclub.com;rhut@hairclub.com'		--amallard
		--WHEN e.UserLogin IN('eword') THEN 'tgoldsmith@hairclub.com;rhut@hairclub.com'			--eword
		--WHEN e.UserLogin IN('JPetsche Flores') THEN 'tpetersen@hairclub.com;rhut@hairclub.com'	--JPetsche Flores
		--WHEN e.UserLogin IN('SArmstrong') THEN 'tpetersen@hairclub.com;rhut@hairclub.com'		--SArmstrong
		WHEN CTR.CenterSSID = 286 THEN 'dgarrison@hairclub.com;rhut@hairclub.com'				--DGarrison
		WHEN CTR.CenterSSID = 214 THEN 'mfaresh@hairclub.com;rhut@hairclub.com'					--MFaresh
	ELSE '' END AS 'Copy'
,	'CRM' AS Position
FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin epj
	ON e.EmployeeSSID = epj.EmployeeGUID
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition ep
	ON epj.EmployeePositionID = ep.EmployeePositionSSID
LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON CTR.CenterSSID = e.CenterSSID
LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
	ON CT.CenterTypeKey = CTR.CenterTypeKey
WHERE ep.EmployeePositionDescription LIKE 'Client Relationship Manager%'
	AND e.IsActiveFlag = 1
	AND e.EmployeeFullName NOT LIKE '%Test%'
	AND ct.CenterTypeDescriptionShort = 'C'
	AND CTR.Active = 'Y'
	--AND e.UserLogin IN('scolacino','amallard','mambe','cmyers','econtreras')  --These are our test employees


--Insert center managers where there are no CRM's
INSERT INTO #CRMScorecardEmailList
SELECT CTR.CenterNumber
,	CTR.CenterNumber AS EmployeeKey
,	REPLACE(e.UserLogin,' ','') + '@hairclub.com'  AS 'EmployeeEmailAddress'
,	'CRM Scorecard - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
,	'' AS 'Copy'
,	'CM' AS Position
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
	ON CT.CenterTypeKey = CTR.CenterTypeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e
	ON e.CenterSSID = CTR.CenterSSID
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin epj
	ON e.EmployeeSSID = epj.EmployeeGUID
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition ep
	ON epj.EmployeePositionID = ep.EmployeePositionSSID
WHERE CTR.CenterNumber NOT IN(SELECT CenterNumber FROM #CRMScorecardEmailList)
	AND CTR.CenterNumber NOT IN(-2,100)
	AND CT.CenterTypeDescriptionShort = 'C'
	AND ep.EmployeePositionDescription = 'Manager'
	AND e.IsActiveFlag = 1
	AND e.EmployeeFullName NOT LIKE '%Test%'
	AND e.IsActiveFlag = 1
	AND CTR.Active = 'Y'
UNION
SELECT 249 AS CenterNumber
,       249 AS EmployeeKey
,		'MMangieri@hairclub.com' AS EmployeeEmailAddress
,		'CRM Scorecard - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
,		'' AS 'Copy'
,		'CM' AS Position


--Insert area managers where there is no center managers
INSERT INTO #CRMScorecardEmailList
SELECT #Centers.CenterNumber
,	#Centers.CenterNumber AS EmployeeKey
,	REPLACE(e.UserLogin,' ','') + '@hairclub.com'  AS 'EmployeeEmailAddress'
,	'CRM Scorecard - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
,	'' AS 'Copy'
,	'AM' AS Position
FROM #Centers
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON	CTR.CenterNumber = #Centers.CenterNumber
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
	ON CT.CenterTypeKey = CTR.CenterTypeKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
	ON CMA.CenterManagementAreaSSID = CTR.CenterManagementAreaSSID
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e
	ON e.EmployeeSSID = CMA.OperationsManagerSSID
WHERE #Centers.CenterNumber NOT IN(SELECT CenterNumber FROM #CRMScorecardEmailList)
AND CTR.CenterNumber NOT IN(-2,100)
	AND CT.CenterTypeDescriptionShort = 'C'
	AND e.IsActiveFlag = 1
	AND e.EmployeeFullName NOT LIKE '%Test%'
	AND e.IsActiveFlag = 1
	AND CMA.Active = 'Y'
	AND CTR.Active = 'Y'


SELECT CenterNumber
,       EmployeeKey
,       EmployeeEmailAddress
,       [Subject]
,       [Copy]
,		Position
FROM #CRMScorecardEmailList



END
