/***********************************************************************
PROCEDURE:				[spRpt_TotalSalesRevenueDashboard_EmailList_Area]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			[spRpt_TotalSalesRevenueDashboard_EmailList_Area]
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		7/22/2019
------------------------------------------------------------------------
NOTES:
This stored proc creates the list of email addresses for the subscription,
if there is no consultant, then the center manager, if no center manager, then the area manager
------------------------------------------------------------------------
CHANGE HISTORY:
11/06/2019 - RH - Changed distribution of centers and removed Adam Wotherspoon
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_TotalSalesRevenueDashboard_EmailList_Area]
***********************************************************************/

CREATE PROCEDURE [dbo].[spRpt_TotalSalesRevenueDashboard_EmailList_Area]
AS


BEGIN

SET FMTONLY OFF;


CREATE TABLE #AreaD
		( CenterManagementAreaSSID INT
		,	CenterManagementAreaDescription NVARCHAR(50)
		,	EmployeeEmailAddress NVARCHAR(50)
		,	CenterNumber NVARCHAR(400)
		,	CC NVARCHAR(400)
		,	[Subject] NVARCHAR(50)
		)

INSERT INTO #AreaD
SELECT CMA.CenterManagementAreaSSID
,	CMA.CenterManagementAreaDescription
,	E.UserLogin + '@hairclub.com' AS EmployeeEmailAddress
--,	STUFF(P.CenterNumbers, 1, 1, '') AS 'CenterNumber'			--KEEP this code for later use
,	CASE WHEN CMA.CenterManagementAreaSSID = 1 THEN '213,249,250,261,282,290,293,294,296,396,222,223,224,254,253,236,262,273,298,396,258,209,208,260,207,255,269,232,289,266'
		WHEN CMA.CenterManagementAreaSSID = 9 THEN '228,229,265,264,242,244,239,241,341,243,245,246,247,230,231,235'
		WHEN CMA.CenterManagementAreaSSID = 20 THEN '201,203,204,205,206,210,212,216,220,225,226,237,259,267,268,219,227,202,217,234,256,257,299,297,218,283,263,284,240'
		WHEN CMA.CenterManagementAreaSSID = 21 THEN '211,214,215,270,271,274,276,278,280,281,286,287,288,291,292,295,275,272,277,238'
		WHEN CMA.CenterManagementAreaSSID = 24 THEN '285,251,252,221'
	END AS 'CenterNumber'
,	CASE WHEN e.UserLogin = 'RKalra' THEN 'nkridel@hairclub.com;rhut@hairclub.com'
		WHEN CMA.CenterManagementAreaDescription = 'Canada' THEN 'AAbusafieh@hairclub.com;rhut@hairclub.com'
	ELSE 'rhut@hairclub.com' END AS 'CC'
,	'Total Sales Revenue Dashboard for ' + CMA.CenterManagementAreaDescription AS 'Subject'
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
		ON CMA.OperationsManagerSSID = E.EmployeeSSID
--CROSS APPLY (SELECT ', ' + CAST(CTR.CenterNumber AS NVARCHAR(5)) --KEEP this code for later use
--			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
--		WHERE CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
--			FOR XML PATH('') ) AS P (CenterNumbers)
WHERE CMA.Active = 'Y'
AND CMA.OperationsManagerSSID IS NOT NULL
AND CMA.CenterManagementAreaSSID <> 11

UPDATE #AreaD
SET EmployeeEmailAddress = 'moakes@hairclub.com'
WHERE CenterManagementAreaSSID = 24

SELECT * FROM #AreaD


END
