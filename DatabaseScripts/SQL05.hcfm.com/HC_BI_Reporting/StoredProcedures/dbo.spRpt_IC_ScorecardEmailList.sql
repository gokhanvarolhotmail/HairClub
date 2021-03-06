/* CreateDate: 05/16/2019 17:16:23.980 , ModifyDate: 11/05/2020 13:46:35.660 */
GO
/***********************************************************************
PROCEDURE:				[spRpt_IC_ScorecardEmailList]
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
08/28/2019 - RH - Added Julie Jones, 12464, Portland (287) per Nicole K
11/21/2019 - RH - Added Diane Ba-Gouhar, 15569, Rye Brook (257) per Nicole K and Amy Christy
03/06/2020 - RH - TrackIT 7693 Removed Melissa Oakes, Kevin Murdoch and Nicole Kridel from PKaul's scorecard
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_IC_ScorecardEmailList]
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_IC_ScorecardEmailList]
AS
BEGIN

SET FMTONLY OFF;


CREATE TABLE #ICScorecardEmailList (
	CenterNumber NVARCHAR(150)
,	EmployeeKey INT
,	EmployeeEmailAddress NVARCHAR(300)
,	Subject NVARCHAR(150)
,	Copy NVARCHAR(300)
,	Position NVARCHAR(5)
)


SELECT	CTR.CenterNumber
,		CTR.CenterDescription
INTO	#Centers
FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = CTR.CenterTypeKey
WHERE	CT.CenterTypeDescriptionShort = 'C'
		AND CTR.CenterNumber NOT IN ( 100, 360 )
		AND CTR.Active = 'Y'


--Insert center IC's
INSERT	INTO #ICScorecardEmailList
		SELECT	CTR.CenterNumber
		,		e.EmployeeKey
		,		REPLACE(e.UserLogin, ' ', '') + '@hairclub.com' AS 'EmployeeEmailAddress'
		,		'Image Consultant Scorecard - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
		,		'' AS 'Copy'
		,		'IC' AS Position
		FROM	HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin epj
					ON e.EmployeeSSID = epj.EmployeeGUID
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition ep
					ON epj.EmployeePositionID = ep.EmployeePositionSSID
				LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					ON CTR.CenterSSID = e.CenterSSID
				LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = CTR.CenterTypeKey
		WHERE	ep.EmployeePositionDescription LIKE 'Consultant%'
				AND e.IsActiveFlag = 1
				AND e.EmployeeFullName NOT LIKE '%Test%'
				AND e.IsActiveFlag = 1
				AND CT.CenterTypeDescriptionShort = 'C'
				AND CTR.Active = 'Y'
		UNION
		SELECT	CTR.CenterNumber
		,		e.EmployeeKey
		,		REPLACE(e.UserLogin, ' ', '') + '@hairclub.com' AS 'EmployeeEmailAddress'
		,		'Image Consultant Scorecard - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
		,		'' AS 'Copy'
		,		'IC' AS Position
		FROM	HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin epj
					ON e.EmployeeSSID = epj.EmployeeGUID
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition ep
					ON epj.EmployeePositionID = ep.EmployeePositionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					ON CTR.CenterSSID = e.CenterSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = CTR.CenterTypeKey
		WHERE	e.EmployeeFullName = 'Heller, Dina'
				AND CT.CenterTypeDescriptionShort = 'C'
				AND CTR.Active = 'Y'
		UNION
		SELECT	CTR.CenterNumber
		,		e.EmployeeKey
		,		REPLACE(e.UserLogin, ' ', '') + '@hairclub.com' AS 'EmployeeEmailAddress'
		,		'Image Consultant Scorecard - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
		,		'' AS 'Copy'
		,		'IC' AS Position
		FROM	HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin epj
					ON e.EmployeeSSID = epj.EmployeeGUID
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition ep
					ON epj.EmployeePositionID = ep.EmployeePositionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					ON CTR.CenterSSID = e.CenterSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = CTR.CenterTypeKey
		WHERE	e.EmployeeFullName = 'Jones, Julie'
				AND CT.CenterTypeDescriptionShort = 'C'
				AND CTR.Active = 'Y'
		UNION
		SELECT	CTR.CenterNumber
		,		e.EmployeeKey
		,		REPLACE(e.UserLogin, ' ', '') + '@hairclub.com' AS 'EmployeeEmailAddress'
		,		'Image Consultant Scorecard - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
		,		'' AS 'Copy'
		,		'IC' AS Position
		FROM	HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin epj
					ON e.EmployeeSSID = epj.EmployeeGUID
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition ep
					ON epj.EmployeePositionID = ep.EmployeePositionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					ON CTR.CenterSSID = e.CenterSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = CTR.CenterTypeKey
		WHERE	e.EmployeeFullName = 'Ba-Gouhar, Diane'
				AND CT.CenterTypeDescriptionShort = 'C'
				AND CTR.Active = 'Y'


--Insert center managers where there are no IC's
INSERT	INTO #ICScorecardEmailList
		SELECT	c.CenterNumber
		,		c.CenterNumber AS 'EmployeeKey'
		,		REPLACE(e.UserLogin, ' ', '') + '@hairclub.com' AS 'EmployeeEmailAddress'
		,		'Image Consultant Scorecard - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
		,		'' AS 'Copy'
		,		'CM' AS Position
		FROM	tmpCenterManagers tcm
				INNER JOIN #Centers c
					ON c.CenterNumber = tcm.CenterNumber
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e
					ON e.EmployeeSSID = tcm.CenterManagerUserGUID
		WHERE	c.CenterNumber NOT IN ( SELECT CenterNumber FROM #ICScorecardEmailList )


--Insert area managers where there is no center managers
INSERT	INTO #ICScorecardEmailList
		SELECT	c.CenterNumber
		,		c.CenterNumber AS 'EmployeeKey'
		,		REPLACE(e.UserLogin, ' ', '') + '@hairclub.com' AS 'EmployeeEmailAddress'
		,		'Image Consultant Scorecard - ' + DATENAME(DW, GETDATE()) + ', ' + CONVERT(VARCHAR, GETDATE(), 101) AS 'Subject'
		,		'' AS 'Copy'
		,		'CM' AS Position
		FROM	tmpCenterManagers tcm
				INNER JOIN #Centers c
					ON c.CenterNumber = tcm.CenterNumber
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee e
					ON e.EmployeeSSID = tcm.AreaDirectorUserGUID
		WHERE	c.CenterNumber NOT IN ( SELECT CenterNumber FROM #ICScorecardEmailList )


SELECT	CenterNumber
,		EmployeeKey
,		EmployeeEmailAddress
,		Subject
,		Copy
,		Position
FROM	#ICScorecardEmailList

END
GO
