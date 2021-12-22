/***********************************************************************
PROCEDURE:				[spRpt_IC_ScorecardEmailList_Area]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			[IC_Scorecard]
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		5/16/2019
------------------------------------------------------------------------
NOTES:
This stored proc creates the list of email addresses for the subscription,
if there is no consultant, then the center manager, if no center manager, then the area manager
------------------------------------------------------------------------
CHANGE HISTORY:
07/01/2019 - RH - (Per Nicole K.) Added Gina DeBono to 'Copy' for East, West and Canada; Nicole Bowman removed from East and West.
11/08/2019 - RH - Added insert for Central since there is no Area Director; redistributed centers
12/19/2019 - RH - TrackIT 4753 Altered recipients per Nicole K.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_IC_ScorecardEmailList_Area]
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_IC_ScorecardEmailList_Area]
AS

SET FMTONLY OFF;

BEGIN

SELECT CTR.CenterNumber, CTR.CenterDescription
INTO #Centers
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
	ON CT.CenterTypeKey = CTR.CenterTypeKey
WHERE CT.CenterTypeDescriptionShort = 'C'
AND CTR.Active = 'Y'
AND CTR.CenterNumber <> 100


CREATE TABLE #ICScorecardEmailList(
	CenterNumber  NVARCHAR(150)
,	EmployeeKey INT
,	EmployeeEmailAddress NVARCHAR(300)
,	[Subject] NVARCHAR(150)
,	[Copy]  NVARCHAR(300)
,	Position NVARCHAR(5)
)



--Insert areas for the ICScorecard Areas
INSERT INTO #ICScorecardEmailList
SELECT CASE WHEN CMA.CenterManagementAreaSSID = 1 THEN '213,249,250,261,282,290,293,294,296,396,222,223,224,254,253,236,262,273,298,396,258,209,208,260,207,255,269,232,289,266'
		WHEN CMA.CenterManagementAreaSSID = 9 THEN '228,229,265,264,242,244,239,241,341,243,245,246,247,230,231,235'
		WHEN CMA.CenterManagementAreaSSID = 20 THEN '201,203,204,205,206,210,212,216,220,225,226,237,259,267,268,219,227,202,217,234,256,257,299,297,218,283,263,284,240'
		WHEN CMA.CenterManagementAreaSSID = 21 THEN '211,214,215,270,271,274,276,278,280,281,286,287,288,291,292,295,275,272,277,238'
	END AS 'CenterNumber'
,	0 AS EmployeeKey
,	E.UserLogin + '@hairclub.com' AS EmployeeEmailAddress
,	'IC Scorecard Area for ' + CMA.CenterManagementAreaDescription + ' - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
,	CASE WHEN CMA.CenterManagementAreaDescription IN('East') THEN 'moakes@hairclub.com;nkridel@hairclub.com;hmatthews@hairclub.com;rhut@hairclub.com'
		WHEN CMA.CenterManagementAreaDescription IN('West') THEN 'moakes@hairclub.com;nkridel@hairclub.com;gdebono@hairclub.com;rhut@hairclub.com'
		WHEN CMA.CenterManagementAreaDescription IN('South') THEN 'moakes@hairclub.com;nkridel@hairclub.com;nbowman@hairclub.com;dlittle@hairclub.com;rhut@hairclub.com'
		WHEN CMA.CenterManagementAreaDescription IN('Canada') THEN 'moakes@hairclub.com;nkridel@hairclub.com;nbowman@hairclub.com;AAbusafieh@hairclub.com;rhut@hairclub.com'
	END AS 'Copy'
,	'MULTI' AS Position
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
		ON CMA.OperationsManagerSSID = E.EmployeeSSID
WHERE CMA.Active = 'Y'
AND CMA.OperationsManagerSSID IS NOT NULL
AND CMA.CenterManagementAreaSSID <> 11

--Insert information for Central since there is no Area Director
INSERT INTO #ICScorecardEmailList
SELECT '285,251,252,221' AS CenterNumber
,	0 AS EmployeeKey
,	'MOakes@hairclub.com' AS EmployeeEmailAddress
,	'IC Scorecard Area for Central' + ' - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
,	'nkridel@hairclub.com;nbowman@hairclub.com;rhut@hairclub.com' AS 'Copy'
,	'MULTI' AS Position
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
WHERE CMA.Active = 'Y'
AND CMA.CenterManagementAreaSSID = 24

/*  KEEP this code for future use - when we get another Area Director
--Insert areas for the ICScorecard Areas
INSERT INTO #ICScorecardEmailList
SELECT STUFF(P.CenterNumbers, 1, 1, '') AS 'CenterNumber'
,	0 AS EmployeeKey
,	E.UserLogin + '@hairclub.com' AS EmployeeEmailAddress
,	'IC Scorecard Area for ' + CMA.CenterManagementAreaDescription + ' - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
,	CASE WHEN CMA.CenterManagementAreaDescription IN('East','West') THEN 'moakes@hairclub.com;nkridel@hairclub.com;gdebono@hairclub.com;rhut@hairclub.com'
		WHEN CMA.CenterManagementAreaDescription IN('Central','South') THEN 'moakes@hairclub.com;nkridel@hairclub.com;nbowman@hairclub.com;rhut@hairclub.com'
		WHEN CMA.CenterManagementAreaDescription IN('Canada') THEN 'moakes@hairclub.com;nkridel@hairclub.com;nbowman@hairclub.com;gdebono@hairclub.com;rhut@hairclub.com'
	END AS 'Copy'
,	'MULTI' AS Position
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
		ON CMA.OperationsManagerSSID = E.EmployeeSSID
CROSS APPLY (SELECT ', ' + CAST(CTR.CenterNumber AS NVARCHAR(5))
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		WHERE CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID  AND CenterNumber NOT IN(199,340)
			FOR XML PATH('') ) AS P (CenterNumbers)
WHERE CMA.Active = 'Y'
AND CMA.OperationsManagerSSID IS NOT NULL
AND CMA.CenterManagementAreaSSID <> 11

*/

SELECT CenterNumber
,       EmployeeKey
,       EmployeeEmailAddress
,       [Subject]
,       [Copy]
,	Position
FROM #ICScorecardEmailList
WHERE CenterNumber IS NOT NULL

END
