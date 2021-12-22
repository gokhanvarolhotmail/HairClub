/* CreateDate: 05/23/2019 16:01:49.150 , ModifyDate: 11/05/2020 14:07:28.223 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
SAMPLE EXECUTION:

EXEC [spRpt_IC_ScorecardEmailList_Area]
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_IC_ScorecardEmailList_Area]
AS

SET FMTONLY OFF;

BEGIN


CREATE TABLE #Centers (
	CenterNumber INT
,	CenterDescription NVARCHAR(50)
)

CREATE TABLE #ICScorecardEmailList (
	CenterNumber NVARCHAR(150)
,	EmployeeKey INT
,	EmployeeEmailAddress NVARCHAR(300)
,	Subject NVARCHAR(150)
,	Copy NVARCHAR(300)
,	Position NVARCHAR(5)
)


INSERT	INTO #Centers
		SELECT	CTR.CenterNumber
		,		CTR.CenterDescription
		FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = CTR.CenterTypeKey
		WHERE	CT.CenterTypeDescriptionShort = 'C'
				AND CTR.Active = 'Y'
				AND CTR.CenterNumber <> 100


--Insert areas for the ICScorecard Areas
INSERT	INTO #ICScorecardEmailList
		SELECT	STUFF(P.CenterNumbers, 1, 1, '') AS 'CenterNumber'
		,		0 AS EmployeeKey
		,		E.UserLogin + '@hairclub.com' AS EmployeeEmailAddress
		,		'IC Scorecard Area for ' + CMA.CenterManagementAreaDescription + ' - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
		,		CASE WHEN CMA.CenterManagementAreaDescription IN ( 'East' ) THEN 'MOakes@hairclub.com;NKridel@hairclub.com;HMatthews@hairclub.com'
					WHEN CMA.CenterManagementAreaDescription IN ( 'West' ) THEN 'MOakes@hairclub.com;NKridel@hairclub.com;GDeBono@hairclub.com'
					WHEN CMA.CenterManagementAreaDescription IN ( 'Central' ) THEN 'MOakes@hairclub.com;NKridel@hairclub.com;NBowman@hairclub.com'
					WHEN CMA.CenterManagementAreaDescription IN ( 'South' ) THEN 'MOakes@hairclub.com;NKridel@hairclub.com'
					WHEN CMA.CenterManagementAreaDescription IN ( 'Canada' ) THEN 'MOakes@hairclub.com;NKridel@hairclub.com;AAbusafieh@hairclub.com'
					WHEN CMA.CenterManagementAreaDescription IN ( 'Mid-Atlantic' ) THEN 'MOakes@hairclub.com;NKridel@hairclub.com;NBowman@hairclub.com'
					WHEN CMA.CenterManagementAreaDescription IN ( 'Midwest' ) THEN 'MOakes@hairclub.com;NKridel@hairclub.com;CConsolmagno@hairclub.com'
					ELSE 'MOakes@hairclub.com;NKridel@hairclub.com'
				END AS 'Copy'
		,		'MULTI' AS Position
		FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
					ON CMA.OperationsManagerSSID = E.EmployeeSSID
				CROSS APPLY (
								SELECT	', ' + CAST(CTR.CenterNumber AS NVARCHAR(5))
								FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
								WHERE	CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
										AND CenterNumber NOT IN ( 199, 340 )
								FOR XML PATH('')
							) P(CenterNumbers)
		WHERE	CMA.Active = 'Y'
				AND CMA.OperationsManagerSSID IS NOT NULL
				AND CMA.CenterManagementAreaSSID <> 11


SELECT	CenterNumber
,		EmployeeKey
,		EmployeeEmailAddress
,		Subject
,		Copy
,		Position
FROM	#ICScorecardEmailList
WHERE	CenterNumber IS NOT NULL

END
GO
