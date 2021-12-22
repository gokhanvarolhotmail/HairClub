/* CreateDate: 08/07/2019 15:36:44.167 , ModifyDate: 08/07/2019 15:38:25.047 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[spRpt_PIP_EmailList_Area]
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
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_PIP_EmailList_Area]
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_PIP_EmailList_Area]
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


CREATE TABLE #PIP_EmailList(
CenterManagementAreaDescription NVARCHAR(25)
,	CenterNumber  NVARCHAR(150)
,	EmployeeKey INT
,	EmployeeEmailAddress NVARCHAR(300)
,	[Subject] NVARCHAR(150)
,	[Copy]  NVARCHAR(300)
,	Position NVARCHAR(5)
)



--Insert areas for the #PIP_EmailList Areas
INSERT INTO #PIP_EmailList

SELECT CMA.CenterManagementAreaDescription
,	STUFF(P.CenterNumbers, 1, 1, '') AS 'CenterNumber'
,	0 AS EmployeeKey
,	E.UserLogin + '@hairclub.com' AS EmployeeEmailAddress
,	'PIP Area for ' + CMA.CenterManagementAreaDescription + ' - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
,	CASE WHEN CMA.CenterManagementAreaDescription IN('South') THEN 'nkridel@hairclub.com;rhut@hairclub.com;dlittle@hairclub.com'
		WHEN CMA.CenterManagementAreaDescription IN('Canada') THEN 'tgoldsmith@hairclub.com;rhut@hairclub.com;nwahl@hairclub.com'
		WHEN CMA.CenterManagementAreaDescription IN('East') THEN 'tgoldsmith@hairclub.com;rhut@hairclub.com;nwahl@hairclub.com'
		WHEN CMA.CenterManagementAreaDescription IN('West') THEN 'tgoldsmith@hairclub.com;rhut@hairclub.com;dlittle@hairclub.com'
		WHEN CMA.CenterManagementAreaDescription IN('Central') THEN 'tgoldsmith@hairclub.com;rhut@hairclub.com;dlittle@hairclub.com;nwahl@hairclub.com'
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


SELECT  CenterManagementAreaDescription
,		CenterNumber
,       EmployeeKey
,       EmployeeEmailAddress
,       [Subject]
,       [Copy]
,	Position
FROM #PIP_EmailList

END
GO
