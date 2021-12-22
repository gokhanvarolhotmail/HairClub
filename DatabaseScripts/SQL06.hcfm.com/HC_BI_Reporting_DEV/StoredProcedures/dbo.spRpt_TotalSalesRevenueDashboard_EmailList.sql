/* CreateDate: 08/13/2019 14:37:56.887 , ModifyDate: 01/07/2020 16:44:58.990 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[spRpt_TotalSalesRevenueDashboard_EmailList]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			[TotalSalesRevenueDashboard_]
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		7/22/2019
------------------------------------------------------------------------
NOTES:
This stored proc creates the list of email addresses for the subscription,
if there is no consultant, then the center manager, if no center manager, then the area manager
------------------------------------------------------------------------
CHANGE HISTORY:
08/23/2019 - RH - Updated list for Center Managers (per Jimmy's roster)
09/05/2019 - RH - Corrected the Center Manager list (per Jimmy's roster)
09/10/2019 - RH - Added Hannah Ewing to the Copy for Cincinnati (283)
11/13/2019 - RH - Removed Cindy Sneed (TFS13439); corrected center managers (per Jimmy's center roster)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_TotalSalesRevenueDashboard_EmailList]
***********************************************************************/

CREATE PROCEDURE [dbo].[spRpt_TotalSalesRevenueDashboard_EmailList]
AS


BEGIN

SET FMTONLY OFF;

/************** Query to populate CenterManager 20190823 ************************************/


CREATE TABLE #CenterManager(
	CenterKey INT
,   CenterNumber INT
,   CenterDescriptionNumber NVARCHAR(50)
,	CenterManager NVARCHAR(102)
,	UserLogin NVARCHAR(150)
,   EmployeeKey INT
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
,	NULL AS EmployeeKey
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
AND CMA.Active = 'Y'
AND CTR.Active = 'Y'


UPDATE CM
SET CM.CenterManager = E.EmployeeFullName, CM.UserLogin = E.UserLogin, CM.EmployeeKey = e.EmployeeKey
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

UPDATE CM
SET CM.CenterManager = 'Wehman, Mark', CM.EmployeeKey = 15741, CM.UserLogin = 'MWehman'
FROM #CenterManager CM
WHERE CenterNumber = 290


UPDATE CM
SET CM.CenterManager = 'Wheat, Danielle', CM.EmployeeKey =  2478, CM.UserLogin = 'DWheat'
FROM #CenterManager CM
WHERE CenterNumber = 231


UPDATE CM
SET CM.CenterManager = 'Larson, Denise', CM.EmployeeKey = 2941, CM.UserLogin = 'DLarson'
FROM #CenterManager CM
WHERE CenterNumber = 222

UPDATE CM
SET CM.CenterManager = 'Kalra, Ricky', CM.EmployeeKey = 16236, CM.UserLogin = 'RKalra'
FROM #CenterManager CM
WHERE CenterNumber = 258

UPDATE CM
SET CM.CenterManager = 'Kay, John', CM.EmployeeKey = 12467, CM.UserLogin = 'JKay'
FROM #CenterManager CM
WHERE CenterNumber = 202


UPDATE CM
SET CM.CenterManager = 'Schurman, Matthew', CM.EmployeeKey = 15806, CM.UserLogin = 'MSchurman'
FROM #CenterManager CM
WHERE CenterNumber = 237

UPDATE CM
SET CM.CenterManager = 'Garrison, Duane', CM.EmployeeKey = 15991, CM.UserLogin = 'DGarrison'
FROM #CenterManager CM
WHERE CenterNumber = 280


UPDATE CM
SET CM.CenterManager = 'Petersen,Tina', CM.EmployeeKey = 15778, CM.UserLogin = 'TPetersen'
FROM #CenterManager CM
WHERE CenterNumber = 232

UPDATE CM
SET CM.CenterManager = 'Hudson, William', CM.EmployeeKey = 12866, CM.UserLogin = 'WHudson'
FROM #CenterManager CM
WHERE CenterNumber = 259

UPDATE CM
SET CM.CenterManager = 'Corbella, Fernan', CM.EmployeeKey = 14000, CM.UserLogin = 'FCorbella'
FROM #CenterManager CM
WHERE CenterNumber = 216


UPDATE CM
SET CM.CenterManager = 'Gonzales, Alexander', CM.EmployeeKey = 3555, CM.UserLogin = 'AGonzales'
FROM #CenterManager CM
WHERE CenterNumber = 278

UPDATE CM
SET CM.CenterManager = 'Gonzales, Alexander', CM.EmployeeKey = 3555, CM.UserLogin =	'AGonzales'
FROM #CenterManager CM
WHERE CenterNumber = 271

UPDATE CM
SET CM.CenterManager = 'Garrison, Duane', CM.EmployeeKey = 	15991, CM.UserLogin = 'DGarrison'
FROM #CenterManager CM
WHERE CenterNumber = 286

UPDATE CM
SET CM.CenterManager = 'Ziman, Todd', CM.EmployeeKey = 12782, CM.UserLogin = 'TZiman'
FROM #CenterManager CM
WHERE CenterNumber = 217

UPDATE CM
SET CM.CenterManager = 'Bloyd, Chester', CM.EmployeeKey = 15506, CM.UserLogin = 'CBloyd'
FROM #CenterManager CM
WHERE CenterNumber = 272

UPDATE CM
SET CM.CenterManager = 'Ziman, Todd', CM.EmployeeKey = 12782, CM.UserLogin = 'TZiman'
FROM #CenterManager CM
WHERE CenterNumber = 205

UPDATE CM
SET CM.CenterManager = 'Petersen, Tina', CM.EmployeeKey = 15778, CM.UserLogin = 'TPetersen'
FROM #CenterManager CM
WHERE CenterNumber = 266

UPDATE CM
SET CM.CenterManager = 'Kalra, Ricky', CM.EmployeeKey = 16236, CM.UserLogin =  'RKalra'
FROM #CenterManager CM
WHERE CenterNumber = 269


--SELECT * FROM #CenterManager
--ORDER BY CenterDescriptionNumber

SELECT EmployeeKey
,	 UserLogin + '@hairclub.com'  AS EmployeeEmailAddress
,	CenterNumber
, CASE WHEN UserLogin = 'MOliphant' THEN 'kmurdoch@hairclub.com;moakes@hairclub.com;nkridel@hairclub.com;rhut@hairclub.com;dleiba@hairclub.com'
	WHEN CenterNumber = 250 THEN 'ehitt@hairclub.com'
	WHEN CenterNumber = 283 THEN 'hewing@hairclub.com' ELSE ''
	END AS 'Copy'
,	'Total Sales Revenue Dashboard for ' + CenterDescriptionNumber AS 'Subject'
FROM #CenterManager


END
GO
