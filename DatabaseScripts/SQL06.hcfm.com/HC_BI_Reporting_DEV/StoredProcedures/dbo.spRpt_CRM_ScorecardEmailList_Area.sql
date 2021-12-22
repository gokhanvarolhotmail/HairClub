/* CreateDate: 07/22/2019 14:21:26.077 , ModifyDate: 08/13/2019 15:12:49.510 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[spRpt_CRM_ScorecardEmailList]
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
08/13/2019 - RH - Added MOakes@hairclub.com to the copy
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_CRM_ScorecardEmailList_Area]
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_CRM_ScorecardEmailList_Area]
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
AND CTR.CenterNumber NOT IN (100,199)


CREATE TABLE #CRMScorecardEmailList(
	CenterNumber  NVARCHAR(150)
,	EmployeeKey INT
,	EmployeeEmailAddress NVARCHAR(300)
,	[Subject] NVARCHAR(150)
,	[Copy]  NVARCHAR(300)
,	Position NVARCHAR(5)
)



--Insert areas for the CRMScorecard Areas
INSERT INTO #CRMScorecardEmailList
SELECT STUFF(P.CenterNumbers, 1, 1, '') AS 'CenterNumber'
,	0 AS EmployeeKey
,	E.UserLogin + '@hcfm.com' AS EmployeeEmailAddress
,	'CRM Scorecard Area for ' + CMA.CenterManagementAreaDescription + ' - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
,	CASE WHEN CMA.CenterManagementAreaDescription IN('South') THEN 'moakes@hairclub.com;tgoldsmith@hairclub.com;rhut@hairclub.com;dlittle@hairclub.com'
		WHEN CMA.CenterManagementAreaDescription IN('Canada') THEN 'moakes@hairclub.com;tgoldsmith@hairclub.com;rhut@hairclub.com;nwahl@hairclub.com'
		WHEN CMA.CenterManagementAreaDescription IN('East') THEN 'moakes@hairclub.com;tgoldsmith@hairclub.com;rhut@hairclub.com;nwahl@hairclub.com'
		WHEN CMA.CenterManagementAreaDescription IN('West') THEN 'moakes@hairclub.com;tgoldsmith@hairclub.com;rhut@hairclub.com;dlittle@hairclub.com'
		WHEN CMA.CenterManagementAreaDescription IN('Central') THEN 'moakes@hairclub.com;tgoldsmith@hairclub.com;rhut@hairclub.com;dlittle@hairclub.com;nwahl@hairclub.com'
	END AS 'Copy'
,	'MULTI' AS Position
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
		ON CMA.OperationsManagerSSID = E.EmployeeSSID
CROSS APPLY (SELECT ', ' + CAST(CTR.CenterNumber AS NVARCHAR(5))
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		WHERE CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			FOR XML PATH('') ) AS P (CenterNumbers)
WHERE CMA.Active = 'Y'
AND CMA.OperationsManagerSSID IS NOT NULL
AND CMA.CenterManagementAreaSSID <> 11


SELECT CenterNumber
,       EmployeeKey
,       EmployeeEmailAddress
,       [Subject]
,       [Copy]
,	Position
FROM #CRMScorecardEmailList

END
GO
