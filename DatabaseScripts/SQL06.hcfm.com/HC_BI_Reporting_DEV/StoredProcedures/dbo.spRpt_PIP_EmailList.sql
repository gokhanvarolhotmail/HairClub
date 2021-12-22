/* CreateDate: 08/07/2019 15:41:08.070 , ModifyDate: 12/19/2019 14:15:35.910 */
GO
/***********************************************************************
PROCEDURE:				[spRpt_PIP_EmailList]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			[PIP]
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		8/7/2019
------------------------------------------------------------------------
NOTES:
This stored proc creates the list of email addresses for the subscription,
if there is no consultant, then the center manager, if no center manager, then the area manager
------------------------------------------------------------------------
CHANGE HISTORY:
08/23/2019 - RH - Updated list for Center Managers (per Jimmy's roster)
09/05/2019 - RH - Updated list for Center Managers (per Jimmy's roster)
11/08/2019 - RH - Updated the list since there is no Area Director for Central
11/13/2019 - RH - Removed Cindy Sneed (TFS13439); Changed EmployeeEmailAddress AS NVARCHAR(MAX); corrected center managers (per Jimmy's center roster)
12/19/2019 - RH - TrackIT 4753 Changed recipients per Nicole K.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_PIP_EmailList]
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_PIP_EmailList]
AS

SET FMTONLY OFF;

BEGIN


IF OBJECT_ID('tempdb..#CenterManager') IS NOT NULL
BEGIN
	DROP TABLE #CenterManager
END
CREATE TABLE #CenterManager(
	CenterKey INT
,   CenterNumber INT
,   CenterDescriptionNumber NVARCHAR(50)
,	CenterManager NVARCHAR(102)
,	UserLogin NVARCHAR(150)
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription NVARCHAR(50)
,	AreaManager NVARCHAR(102)
,	EmployeePositionDescription NVARCHAR(50)
)

INSERT INTO #CenterManager
SELECT  CTR.CenterKey
,	CTR.CenterNumber
,	CTR.CenterDescriptionNumber
,	NULL AS CenterManager
,	NULL AS UserLogin
,	CTR.CenterManagementAreaSSID
,	CMA.CenterManagementAreaDescription
,	AREA.EmployeeFullName AS 'AreaManager'
,	'AreaManager' AS EmployeePositionDescription
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR		WITH(NOLOCK)
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT	WITH(NOLOCK)
		ON CT.CenterTypeKey = CTR.CenterTypeKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA	WITH(NOLOCK)
	ON CMA.CenterManagementAreaSSID = CTR.CenterManagementAreaSSID
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee AREA	WITH(NOLOCK)
	ON CMA.OperationsManagerSSID = AREA.EmployeeSSID
WHERE CT.CenterTypeDescriptionShort = 'C'
AND CTR.CenterNumber NOT IN (199,340)

--Insert records for Central since there is no Center Manager
INSERT INTO #CenterManager
SELECT CTR.CenterKey
,	CTR.CenterNumber
,	CTR.CenterDescriptionNumber
,	NULL AS CenterManager
,	NULL AS UserLogin
,	CTR.CenterManagementAreaSSID
,	'Central' AS CenterManagementAreaDescription
,	NULL AS 'AreaManager'
,	'AreaManager' AS EmployeePositionDescription
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR		WITH(NOLOCK)
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT	WITH(NOLOCK)
		ON CT.CenterTypeKey = CTR.CenterTypeKey
WHERE CT.CenterTypeDescriptionShort = 'C'
AND CTR.CenterNumber NOT IN (199,340)
AND CTR.Active = 'Y'
AND CTR.CenterManagementAreaSSID = 24


UPDATE CM
SET CM.CenterManager = E.EmployeeFullName, CM.UserLogin = E.UserLogin
FROM #CenterManager CM
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR WITH(NOLOCK)
	ON CTR.CenterNumber = CM.CenterNumber
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E WITH(NOLOCK)
	ON E.CenterSSID = CTR.CenterSSID
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin EPJ	WITH(NOLOCK)
	ON E.EmployeeSSID = EPJ.EmployeeGUID
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition EP	WITH(NOLOCK)
	ON EPJ.EmployeePositionID = EP.EmployeePositionSSID
WHERE EP.EmployeePositionDescription IN('Manager')
       AND E.IsActiveFlag = 1
       AND E.EmployeeFullName NOT LIKE '%Test%'
       AND CTR.Active = 'Y'
       AND E.EmployeeFullName NOT IN( --These are inactive center managers
       'Ambe, Mara'
,      'Ardeleanu, Raluca'
,      'Atchley, Elissa'
,      'Calhoun, Rochelle'
,      'Chacon, Angela'
,	   'El-Dick, Joseph'
,      'Hickman, Natasha'
,      'Hitt, Erica'
,      'Holz, Jennifer'
,      'Johnson, Lasandra'
,      'Johnson, Lonzell'
,      'King, Sherri'
,      'Lyon, Deena'
,      'Mallard, Anthony'
,      'Masterson, Elizabeth'
,      'Mozafary, Mahmood'
,      'Myers, Caleena'
,      'Perez, Kalena'
,      'Riggi, JoAnn'
,      'Rivera Herth, Ginger'
,      'Rose Baker, Deana'
,      'Santos, Marco'
,      'Spencer, Keyana'
,      'Suddath, Sharon'
,      'Torres, Gladys'
,      'Vitale, Nicole'
,      'Wahl, Nolan'
,      'Wilson, Audrey'
)

--As of 11/13/2019

UPDATE CM
SET CM.CenterManager = 'Wehman, Mark'
FROM #CenterManager CM
WHERE CenterNumber = 290


UPDATE CM
SET CM.CenterManager = 'Wheat, Danielle'
FROM #CenterManager CM
WHERE CenterNumber = 231


UPDATE CM
SET CM.CenterManager = 'Larson, Denise'
FROM #CenterManager CM
WHERE CenterNumber = 222

UPDATE CM
SET CM.CenterManager = 'Kalra, Ricky'
FROM #CenterManager CM
WHERE CenterNumber = 258

UPDATE CM
SET CM.CenterManager = 'Kay, John'
FROM #CenterManager CM
WHERE CenterNumber = 202

UPDATE CM
SET CM.CenterManager = 'Redden, Kristen'
FROM #CenterManager CM
WHERE CenterNumber = 283

UPDATE CM
SET CM.CenterManager = 'Schurman, Matthew'
FROM #CenterManager CM
WHERE CenterNumber = 237

UPDATE CM
SET CM.CenterManager = 'Garrison, Duane'
FROM #CenterManager CM
WHERE CenterNumber = 280


UPDATE CM
SET CM.CenterManager = 'Petersen,Tina'
FROM #CenterManager CM
WHERE CenterNumber = 232

UPDATE CM
SET CM.CenterManager = 'Hudson, William'
FROM #CenterManager CM
WHERE CenterNumber = 259

UPDATE CM
SET CM.CenterManager = 'Corbella, Fernan'
FROM #CenterManager CM
WHERE CenterNumber = 216


UPDATE CM
SET CM.CenterManager = 'Gonzales, Alexander'
FROM #CenterManager CM
WHERE CenterNumber = 278

UPDATE CM
SET CM.CenterManager = 'Gonzales, Alexander'
FROM #CenterManager CM
WHERE CenterNumber = 271

UPDATE CM
SET CM.CenterManager = 'Garrison, Duane'
FROM #CenterManager CM
WHERE CenterNumber = 286

UPDATE CM
SET CM.CenterManager = 'Ziman, Todd'
FROM #CenterManager CM
WHERE CenterNumber = 217

UPDATE CM
SET CM.CenterManager = 'Boyd, Chet'
FROM #CenterManager CM
WHERE CenterNumber = 272

UPDATE CM
SET CM.CenterManager = 'Ziman, Todd'
FROM #CenterManager CM
WHERE CenterNumber = 205

UPDATE CM
SET CM.CenterManager = 'Petersen,Tina'
FROM #CenterManager CM
WHERE CenterNumber = 266

UPDATE CM
SET CM.CenterManager = 'Kalra, Ricky'
FROM #CenterManager CM
WHERE CenterNumber = 269

--SELECT '#CenterManager' AS tablename,*
--FROM #CenterManager
--ORDER BY CenterDescriptionNumber
/****************** Create table with the subscription information ********************/


IF OBJECT_ID('tempdb..#Email') IS NOT NULL
BEGIN
	DROP TABLE #Email
END
CREATE TABLE #Email
( CenterNumber INT
,	CenterManagementAreaSSID INT
,	EmployeeEmailAddress NVARCHAR(30)
)

INSERT INTO #Email
SELECT CenterNumber
,	CenterManagementAreaSSID
,	UserLogin + '@hairclub.com' AS EmployeeEmailAddress
FROM #CenterManager

--SELECT * FROM #Email

--Insert areas for the #PIP_EmailList

IF OBJECT_ID('tempdb..#PIP_Center') IS NOT NULL
BEGIN
	DROP TABLE #PIP_Center
END

CREATE TABLE #PIP_Center(
CenterManagementAreaDescription NVARCHAR(25)
,	CenterNumber  NVARCHAR(250)
,	EmployeeEmailAddress NVARCHAR(MAX)
,	[Subject] NVARCHAR(150)
,	[Copy]  NVARCHAR(400)
)

INSERT INTO #PIP_Center

SELECT CMA.CenterManagementAreaDescription
,	STUFF(P.CenterNumbers, 1, 1, '') AS 'CenterNumber'
,	STUFF(Q.EmployeeEmailAddress, 1, 1, '') AS  EmployeeEmailAddress
,	'PIP Area for ' + CMA.CenterManagementAreaDescription + ' - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
,	CASE WHEN CMA.CenterManagementAreaDescription IN('South') THEN	'rkalra@hairclub.com;moakes@hairclub.com;nkridel@hairclub.com;nbowman@hairclub.com;gdebono@hairclub.com;dlittle@hairclub.com;rhut@hairclub.com'
		 WHEN CMA.CenterManagementAreaDescription IN('Canada') THEN 'JEl-Dick@hairclub.com;moakes@hairclub.com;nkridel@hairclub.com;nbowman@hairclub.com;AAbusafieh@hairclub.com;rhut@hairclub.com'
		 WHEN CMA.CenterManagementAreaDescription IN('East') THEN	'AChristy@hairclub.com;moakes@hairclub.com;nkridel@hairclub.com;nbowman@hairclub.com;hmatthews@hairclub.com;rhut@hairclub.com'
		 WHEN CMA.CenterManagementAreaDescription IN('West') THEN	'AGonzales@hairclub.com;moakes@hairclub.com;nkridel@hairclub.com;nbowman@hairclub.com;gdebono@hairclub.com;rhut@hairclub.com'
		 WHEN CMA.CenterManagementAreaDescription IN('Central') THEN 'moakes@hairclub.com;nkridel@hairclub.com;nbowman@hairclub.com;gdebono@hairclub.com;rhut@hairclub.com'
	END AS 'Copy'
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
		ON CMA.OperationsManagerSSID = E.EmployeeSSID
CROSS APPLY (SELECT ', ' + CAST(CTR.CenterNumber AS NVARCHAR(5))
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		WHERE CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			FOR XML PATH('') ) AS P (CenterNumbers)
CROSS APPLY (SELECT '; ' + CAST(EmployeeEmailAddress AS NVARCHAR(300))
			FROM #Email
		WHERE CMA.CenterManagementAreaSSID = #Email.CenterManagementAreaSSID
			FOR XML PATH('') ) AS Q (EmployeeEmailAddress)
WHERE CMA.Active = 'Y'
AND CMA.OperationsManagerSSID IS NOT NULL
AND CMA.CenterManagementAreaSSID <> 11



SELECT * FROM #PIP_Center


END
GO
