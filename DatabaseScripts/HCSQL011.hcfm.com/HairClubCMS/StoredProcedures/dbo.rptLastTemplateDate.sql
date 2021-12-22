/* CreateDate: 01/28/2016 09:32:03.173 , ModifyDate: 02/24/2017 17:05:33.050 */
GO
/*
==============================================================================

PROCEDURE:				rptLastTemplateDate
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairclubCMS
IMPLEMENTOR: 			Rachelen Hut
DATE IMPLEMENTED:		01/27/2016

==============================================================================
DESCRIPTION:	This is a report that lists the days since the last template measurement.
==============================================================================
NOTES:	DaysSince >= 60		--DATEDIFF(DAY,TPH.LastTemplateDate, GETDATE()) AS 'DaysSince'
@Filter = 1 By Regions, 2 By Area Managers, 3 By Corporate Centers
==============================================================================
CHANGE HISTORY:
09/20/2016 - RH - Added logic to find only active clients (#125558)
01/09/2017 - RH - Changed EmployeeKey to CenterManagementAreaID and CenterManagementAreaDescription as description (#132688)
02/24/2017 - RH - Changed datTechnicalProfileHistory to datTechnicalProfile
==============================================================================

SAMPLE EXECUTION:

EXEC [rptLastTemplateDate] 'C', 1
EXEC [rptLastTemplateDate] 'C', 2
EXEC [rptLastTemplateDate] 'C', 3

EXEC [rptLastTemplateDate] 'F', 1

=============================================================================
*/
CREATE PROCEDURE [dbo].[rptLastTemplateDate] (
	@sType CHAR(1)
,	@Filter INT
)

AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF



/******************* Define today as this morning at 12:00 am ******************************/
DECLARE @Today DATETIME
SET @Today = DATEADD(day,DATEDIFF(day,0,GETDATE()),0)

/******************* Create temp tables ****************************************************/
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(104)
,	CenterManagementAreaID INT
,	CenterManagementAreaDescription VARCHAR(102)
)

/********************************** Get list of centers *************************************/

IF @sType = 'C' AND @Filter = 1  --By Regions
	BEGIN
		INSERT  INTO #Centers
				SELECT  R.RegionID AS 'MainGroupID'
				,		R.RegionDescription AS 'MainGroup'
				,		C.CenterID
				,		C.CenterDescription
				,		C.CenterDescriptionFullCalc
				,		NULL AS CenterManagementAreaID
				,		NULL AS CenterManagementAreaDescription
				FROM    cfgCenter C
						INNER JOIN lkpRegion R
							ON C.RegionID = R.RegionID
				WHERE	CONVERT(VARCHAR, C.CenterID) LIKE '2%'
						AND C.IsActiveFlag = 1
	END

	IF @sType = 'C' AND @Filter = 2  --By Area Managers
	BEGIN
		INSERT  INTO #Centers
			SELECT		AM.CenterManagementAreaID AS MainGroupID
				,		AM.CenterManagementAreaDescription AS MainGroup
				,		AM.CenterID
				,		AM.CenterDescription
				,		AM.CenterDescriptionFullCalc
				,		AM.CenterManagementAreaID
				,		AM.CenterManagementAreaDescription
			FROM    dbo.vw_AreaManager AM

	END

	IF @sType = 'C' AND @Filter = 3  -- By Centers
	BEGIN
		INSERT  INTO #Centers
				SELECT  C.CenterID AS 'MainGroupID'
				,		C.CenterDescriptionFullCalc AS 'MainGroup'
				,		C.CenterID
				,		C.CenterDescription
				,		C.CenterDescriptionFullCalc
				,		NULL AS CenterManagementAreaID
				,		NULL AS CenterManagementAreaDescription
				FROM    cfgCenter C
						INNER JOIN lkpRegion R
							ON C.RegionID = R.RegionID
				WHERE	CONVERT(VARCHAR, C.CenterID) LIKE '[2]%'
						AND C.IsActiveFlag = 1
	END


IF @sType = 'F'  --Always By Regions for Franchises
	BEGIN
		INSERT  INTO #Centers
				SELECT  R.RegionID AS 'MainGroupID'
				,		R.RegionDescription AS 'MainGroup'
				,		C.CenterID
				,		C.CenterDescription
				,		C.CenterDescriptionFullCalc
				,		NULL AS CenterManagementAreaID
				,		NULL AS CenterManagementAreaDescription
				FROM    cfgCenter C
						INNER JOIN lkpRegion R
							ON C.RegionID = R.RegionID
				WHERE	CONVERT(VARCHAR, C.CenterID) LIKE '[78]%'
						AND C.IsActiveFlag = 1
	END

/******** Find clients with at least 60 days since last template date **********************************/

SELECT r.MainGroupID
     , r.MainGroup
     , r.CenterID
     , r.CenterDescription
     , r.CenterDescriptionFullCalc
     , r.ClientIdentifier
     , r.ClientFullNameCalc
     , r.ClientFullNameAltCalc
     , r.LastTemplateDate
     , r.TPRANK
     , r.DaysSince
INTO #TechProfile
FROM
	(SELECT q.MainGroupID
		 ,	q.MainGroup
		 ,	q.CenterID
		 ,	q.CenterDescription
		 ,	q.CenterDescriptionFullCalc
		 ,	q.ClientIdentifier
		 ,	q.ClientFullNameCalc
		 ,	q.ClientFullNameAltCalc
		 ,	q.LastTemplateDate
		 ,	q.TPRANK
		 ,	DATEDIFF(DAY,q.LastTemplateDate, GETDATE()) AS 'DaysSince'
	FROM
		(SELECT CTR.MainGroupID
		,	CTR.MainGroup
		,	CLT.CenterID
		,	C.CenterDescription
		,	C.CenterDescriptionFullCalc
		,	CLT.ClientIdentifier
		,	CLT.ClientFullNameCalc
		,	CLT.ClientFullNameAltCalc
		,	TPH.LastTemplateDate
		,	ROW_NUMBER() OVER(PARTITION BY TPH.ClientGUID ORDER BY TPH.LastTemplateDate DESC) TPRANK
		FROM  dbo.datTechnicalProfile TPH
		INNER JOIN datClient CLT
			ON TPH.ClientGUID = CLT.ClientGUID
		INNER JOIN #Centers CTR
			ON CLT.CenterID = CTR.CenterID
		INNER JOIN dbo.cfgCenter C
			ON CLT.CenterID = C.CenterID
		INNER JOIN lkpRegion R
			ON C.RegionID = R.RegionID
		)q
	WHERE TPRANK = 1
	)r
WHERE r.DaysSince >= 60

/******** Find clients that are still active from #TechProfile **********************************/

SELECT DISTINCT f.ClientIdentifier
, f.Membership
, f.MembershipBeginDate
, f.MembershipEndDate
INTO #ActiveClients
FROM #TechProfile TP
CROSS APPLY(SELECT * FROM dbo.fnGetCurrentMembershipDetailsByClientID(TP.ClientIdentifier)) f
WHERE f.MembershipStatus = 'Active'
	AND f.RevenueGroupID IN (2,3)
	AND f.Membership <> 'Hair Club For Kids'
	AND f.MembershipEndDate > GETDATE()

/******** Join the two groups *******************************************************************/

SELECT TP.MainGroupID
,	TP.MainGroup
,	TP.CenterID
,	TP.CenterDescription
,	TP.CenterDescriptionFullCalc
,	TP.ClientIdentifier
,	TP.ClientFullNameCalc
,	TP.ClientFullNameAltCalc
,	TP.LastTemplateDate
,	TP.TPRANK
,	TP.DaysSince
,	AC.Membership
,	AC.MembershipBeginDate
,	AC.MembershipEndDate
FROM #TechProfile TP
INNER JOIN #ActiveClients AC
	ON TP.ClientIdentifier = AC.ClientIdentifier

END
GO
