/* CreateDate: 10/07/2015 09:03:53.603 , ModifyDate: 02/07/2020 16:29:40.763 */
GO
/*===============================================================================================
Procedure Name:            rptTVTrendingAnalysis
Procedure Description:     This report shows results of Progress Reviews at the center level
								to ensure audits of overall improvements/degradations,
								and allows for drill-down to the client level.
Created By:				Rachelen Hut
Date Created:              10/06/2015
Destination Server:        HairclubCMS
Related Application:       SharePoint page under MISC
================================================================================================
NOTES:
@Filter = 1 - "by a region", 2 - "by an area", 3 - "by a center"
@MainGroupID = the ID of the region, area or center
================================================================================================
CHANGE HISTORY:
10/06/2015 - RH - Proc Created
08/01/2017 - PRM - Added new replacement statuses for Cancel CM Status (up, down, convert, renew)
02/07/2020 - RH - Added @Filter to distinguish between Corporate, Franchise and Centers

Sample Execution:

EXEC [rptTVTrendingAnalysis] 1, 6
EXEC [rptTVTrendingAnalysis] 2, 9
EXEC [rptTVTrendingAnalysis] 3, 201
EXEC [rptTVTrendingAnalysis] 3, 804

================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVTrendingAnalysis](
	@Filter INT
,	@MainGroupID INT
)

AS
BEGIN


/**********  Create temp tables ************************************************************************/

CREATE TABLE #Centers(
		MainGroupID INT
	,	MainGroupDescription NVARCHAR(50)
	,	CenterID INT
	,	CenterDescription NVARCHAR(50)
)

CREATE TABLE #Membership(
		MembershipID INT
	,	MembershipDescription NVARCHAR(50)
)


CREATE TABLE #MeasurementAppts(
		MyApptID INT IDENTITY(1,1)
	,	CenterID INT
	,	CenterDescription NVARCHAR(50)
	,	ClientGUID UNIQUEIDENTIFIER
	,	AppointmentGUID UNIQUEIDENTIFIER
	,	AppointmentDate DATETIME
	,   GenderDescriptionShort NVARCHAR(1)
	,	Ranking INT
)


CREATE TABLE #Calc(
		AppointmentGUID UNIQUEIDENTIFIER
	,	AppointmentDate DATETIME
	,	ComparisonSet INT
	,	ClientGUID  UNIQUEIDENTIFIER
	,	ClientIdentifier INT
	,	DCTerminals INT
	,	DCArea DECIMAL(18,2)
	,	DensityControlRatio DECIMAL(18,2)
	,	DTTerminals DECIMAL(18,2)
	,	DTArea DECIMAL(18,2)
	,	DensityThinningRatio DECIMAL(18,2)
	,	WCMarkerWidth DECIMAL(18,2)
	,	WTMarkerWidth DECIMAL(18,2)
	,	HMIC  DECIMAL(18,2)
	,	HMIT  DECIMAL(18,2)
)

/******************  Find Center selected or Centers per Region/ Area selected *******************************/

IF @Filter = 1  --Then a region has been selected
BEGIN
	INSERT INTO #Centers
	SELECT  CTR.RegionID AS MainGroupID
	,	R.RegionDescription AS MainGroupDescription
	,	CTR.CenterID
	,	CTR.CenterDescription
	FROM dbo.cfgCenter CTR
	INNER JOIN dbo.lkpRegion R
		ON CTR.RegionID = R.RegionID
	WHERE CTR.RegionID = @MainGroupID
	AND CTR.IsActiveFlag = 1
END
ELSE IF @Filter = 2  --Then an area has been selected
BEGIN
	INSERT INTO #Centers
	SELECT  CTR.CenterManagementAreaID  AS MainGroupID
	,	CMA.CenterManagementAreaDescription  AS MainGroupDescription
	,	CTR.CenterID
	,	CTR.CenterDescription
	FROM dbo.cfgCenter CTR
	LEFT JOIN dbo.cfgCenterManagementArea CMA
		ON CMA.CenterManagementAreaID = CTR.CenterManagementAreaID
	WHERE CMA.CenterManagementAreaID = @MainGroupID
	AND CTR.IsActiveFlag = 1
END
ELSE IF @Filter = 3  --Then a center has been selected
BEGIN
	INSERT INTO #Centers
	SELECT  CASE WHEN CT.CenterTypeDescriptionShort IN ('F','JV') THEN CTR.RegionID ELSE CTR.CenterManagementAreaID END AS MainGroupID
	,	CASE WHEN CT.CenterTypeDescriptionShort IN ('F','JV') THEN R.RegionDescription ELSE CMA.CenterManagementAreaDescription END AS MainGroupDescription
	,	CTR.CenterID
	,	CTR.CenterDescription
	FROM dbo.cfgCenter CTR
	INNER JOIN dbo.lkpCenterType CT
		ON CTR.CenterTypeID = CT.CenterTypeID
	LEFT JOIN dbo.lkpRegion R
		ON R.RegionID = CTR.RegionID
	LEFT JOIN dbo.cfgCenterManagementArea CMA
		ON CMA.CenterManagementAreaID = CTR.CenterManagementAreaID
	WHERE CTR.CenterID = @MainGroupID
	AND CTR.IsActiveFlag = 1
END


/********************************** Find EXT Memberships *************************************/

INSERT INTO #Membership
SELECT MembershipID
,	MembershipDescription
FROM dbo.cfgMembership
WHERE MembershipDescription LIKE 'EXT%'

/********************************** Get Clients *************************************/


SELECT p.ClientIdentifier
     , p.ClientFullNameCalc
     , p.CenterID
     , p.ClientGUID
	 , p.GenderDescriptionShort
INTO #Clients
FROM
(SELECT   ROW_NUMBER() OVER ( PARTITION BY CLT.ClientGUID ORDER BY CLT.ClientGUID, CM.EndDate DESC ) AS RowNumber
,CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,   CLT.CenterID
,   CM.ClientGUID
,   CM.ClientMembershipGUID
,	G.GenderDescriptionShort
FROM dbo.datClient CLT
	INNER JOIN #Centers CTR
		ON CLT.CenterID = CTR.CenterID
    INNER JOIN dbo.datClientMembership CM
        ON CLT.CurrentExtremeTherapyClientMembershipGUID = CM.ClientMembershipGUID
	LEFT JOIN dbo.lkpClientMembershipStatus CMS ON CM.ClientMembershipStatusID = CMS.ClientMembershipStatusID
	INNER JOIN dbo.lkpGender G
		ON CLT.GenderID = G.GenderID
WHERE CM.MembershipID IN ( SELECT MembershipID FROM #Membership)
    AND CM.EndDate > DATEADD(MONTH, -12, CONVERT(VARCHAR(11), GETDATE(), 101))
    AND NOT CMS.ClientMembershipStatusDescriptionShort IN ('C', 'E', 'CNV', 'UP', 'DWN', 'REN')
   )p
WHERE p.RowNumber = 1


/********************************** Find measurement appointments *************************************/

INSERT INTO #MeasurementAppts

SELECT	CTR.CenterID
,	CTR.CenterDescription
,	CLT.ClientGUID
,	AP.AppointmentGUID
,	APPT.AppointmentDate
,	G.GenderDescriptionShort
,	ROW_NUMBER() OVER ( PARTITION BY CLT.ClientGUID ORDER BY CLT.ClientGUID, APPT.AppointmentDate ASC ) AS Ranking
FROM	datAppointment APPT
	INNER JOIN #Centers CTR
		ON APPT.CenterID = CTR.CenterID
	INNER JOIN dbo.datClient CLT
		ON APPT.ClientGUID = CLT.ClientGUID
	INNER JOIN dbo.lkpGender G
		ON CLT.GenderID = G.GenderID
	INNER JOIN dbo.datAppointmentPhoto AP
		ON APPT.AppointmentGUID = AP.AppointmentGUID
	INNER JOIN dbo.datAppointmentPhotoMarkup APM
		ON AP.AppointmentPhotoID = APM.AppointmentPhotoID
	INNER JOIN dbo.datAppointmentDetail AD
		ON APPT.AppointmentGUID = AD.AppointmentGUID
	INNER JOIN dbo.cfgSalesCode SC
		ON AD.SalesCodeID = SC.SalesCodeID
WHERE   APPT.IsDeletedFlag = 0
	AND APM.PointX > 0
	AND APM.PointY > 0
	AND SC.SalesCodeDescriptionShort <> 'SALECNSLT'
	AND ISNUMERIC(SC.SalesCodeDescriptionShort) <> 1
GROUP BY CTR.CenterID
,	CTR.CenterDescription
,	CLT.ClientGUID
,	AP.AppointmentGUID
,	APPT.AppointmentDate
,	G.GenderDescriptionShort


/********************************** Loop to find calculations ***********************************/

DECLARE @ClientGUID UNIQUEIDENTIFIER
DECLARE @AppointmentGUID UNIQUEIDENTIFIER
DECLARE @AppointmentGUID2 UNIQUEIDENTIFIER
DECLARE @Gender NVARCHAR(1)
DECLARE @ID INT

--Set the @ProjectID Variable for first iteration
SELECT @ID = MIN(MyApptID)
FROM #MeasurementAppts
WHERE Ranking > 1

--Loop through each project
WHILE @ID IS NOT NULL
BEGIN

SET @ClientGUID = (SELECT ClientGUID FROM #MeasurementAppts WHERE MyApptID = @ID)
SET @AppointmentGUID  = CASE WHEN (SELECT  TOP 1 AppointmentGUID FROM #MeasurementAppts WHERE ClientGUID = @ClientGUID AND Ranking = 2) IS NULL THEN
							(SELECT  TOP 1 AppointmentGUID FROM #MeasurementAppts WHERE MyApptID = @ID AND Ranking = 1) ELSE
							(SELECT  TOP 1 AppointmentGUID FROM #MeasurementAppts WHERE ClientGUID = @ClientGUID AND Ranking = 2) END	--Find a later appointment as @AppointmentGUID --Only two appointments are needed for [rptComparativeCalculations] even the same one.
SET @AppointmentGUID2  = (SELECT TOP 1 AppointmentGUID FROM #MeasurementAppts  WHERE MyApptID = @ID AND Ranking = 1)  --Find the earliest appointment as Ranking 1 = @AppointmentGUID2

SET @Gender = (SELECT  TOP 1 GenderDescriptionShort FROM #MeasurementAppts WHERE MyApptID = @ID)


INSERT INTO #Calc
EXEC rptTVComparativeCalculations @AppointmentGUID, @AppointmentGUID2 ,@Gender


--Then at the end of the loop
SELECT @ID = MIN(MyApptID)
FROM #MeasurementAppts
WHERE MyApptID > @ID
AND Ranking > 1
END


/**********************  Sub Select Statement **************************************************/

SELECT MA.CenterID
,	MA.CenterDescription
,	MainGroupID
,	MainGroupDescription
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc --Is this person still active??
,	CALC.AppointmentGUID
,	CALC.ClientGUID
,	CALC.AppointmentDate
,	CALC.DensityControlRatio
,	CALC.DensityThinningRatio
,	CALC.WCMarkerWidth
,	CALC.WTMarkerWidth
,	CALC.HMIC
,	CALC.HMIT
,	ROW_NUMBER() OVER ( PARTITION BY CALC.ClientGUID ORDER BY CALC.ClientGUID, CALC.AppointmentDate ASC ) AS ApptOrder
INTO #Sub
FROM #Calc CALC
INNER JOIN #MeasurementAppts MA
	ON CALC.ClientGUID = MA.ClientGUID
INNER JOIN #Centers CTR
	ON MA.CenterID = CTR.CenterID
INNER JOIN #Clients CLT
	ON CALC.ClientGUID = CLT.ClientGUID
GROUP BY MA.CenterID
,	MA.CenterDescription
,	CTR.MainGroupID
,	CTR.MainGroupDescription
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	CALC.AppointmentGUID
,	CALC.ClientGUID
,	CALC.AppointmentDate
,	CALC.DensityControlRatio
,	CALC.DensityThinningRatio
,	CALC.WCMarkerWidth
,	CALC.WTMarkerWidth
,	CALC.HMIC
,	CALC.HMIT


/********************** Populate #Baseline **************************************************/

SELECT CenterDescription
,	MainGroupID
,	MainGroupDescription
,	ClientIdentifier
,	ClientFullNameCalc
,	AppointmentDate
,	ROUND(HMIC,0) AS 'CtrlBaseHMI'
,	NULL AS 'CtrlTargetHMI'

,	ROUND(HMIT,0) AS 'ThinBaseHMI'
,	NULL AS 'ThinTargetHMI'

,	ROUND(DensityControlRatio,0) AS 'CtrlBaseDensity'
,	NULL AS 'CtrlTargetDensity'

,	ROUND(DensityThinningRatio,0) AS 'ThinBaseDensity'
,	NULL AS 'ThinTargetDensity'

,	ROUND(WCMarkerWidth,0) AS 'CtrlBaseWidth'
,	NULL AS 'CtrlTargetWidth'

,	ROUND(WTMarkerWidth,0) AS 'ThinBaseWidth'
,	NULL AS 'ThinTargetWidth'

INTO #Baseline
FROM #Sub
WHERE ApptOrder = 1

/********************** Populate #Target **************************************************/

SELECT CenterDescription
,	MainGroupID
,	MainGroupDescription
,	ClientIdentifier
,	ClientFullNameCalc
,	AppointmentDate
,	NULL AS 'CtrlBaseHMI'
,	ROUND(HMIC,0) AS 'CtrlTargetHMI'

,	NULL AS 'ThinBaseHMI'
,	ROUND(HMIT,0) AS 'ThinTargetHMI'

,	NULL AS 'CtrlBaseDensity'
,	ROUND(DensityControlRatio,0) AS 'CtrlTargetDensity'

,	NULL AS 'ThinBaseDensity'
,	ROUND(DensityThinningRatio,0)  AS 'ThinTargetDensity'

,	NULL AS 'CtrlBaseWidth'
,	ROUND(WCMarkerWidth,0) AS 'CtrlTargetWidth'

,	NULL AS 'ThinBaseWidth'
,	ROUND(WTMarkerWidth,0) AS 'ThinTargetWidth'

,	ROW_NUMBER() OVER ( PARTITION BY ClientIdentifier ORDER BY ClientIdentifier, AppointmentDate DESC ) AS TargetOrder

INTO #Target
FROM #Sub
WHERE ApptOrder > 1

/********************** Update the NULLs with the values from the latest appointment for Target **************************/

UPDATE B
SET B.AppointmentDate = T.AppointmentDate
	,	B.CtrlTargetHMI = T.CtrlTargetHMI
	,	B.ThinTargetHMI = T.ThinTargetHMI
	,	B.CtrlTargetDensity = T.CtrlTargetDensity
	,	B.ThinTargetDensity= T.ThinTargetDensity
	,	B.CtrlTargetWidth = T.CtrlTargetWidth
	,	B.ThinTargetWidth= T.ThinTargetWidth
FROM #Baseline B
INNER JOIN #Target T
	ON T.ClientIdentifier = B.ClientIdentifier
WHERE T.TargetOrder = 1

/********************** Populate #Final **************************************************/

SELECT CenterDescription
,	MainGroupID
,	MainGroupDescription
,	ClientIdentifier
,	ClientFullNameCalc
,	AppointmentDate
,	CtrlDensityDiff = CASE WHEN CtrlTargetDensity=0 THEN 0 ELSE (CtrlTargetDensity - CtrlBaseDensity)/CtrlTargetDensity END
,	ThinDensityDiff = CASE WHEN ThinTargetDensity=0 THEN 0 ELSE (ThinTargetDensity - ThinBaseDensity)/ThinTargetDensity END
,	CtrlWidthDiff = CASE WHEN CtrlTargetWidth=0 THEN 0 ELSE (CtrlTargetWidth - CtrlBaseWidth)/CtrlTargetWidth END
,	ThinWidthDiff = CASE WHEN ThinTargetWidth=0 THEN 0 ELSE (ThinTargetWidth - ThinBaseWidth)/ThinTargetWidth END
,	CtrlHMIDiff = CASE WHEN CtrlTargetHMI=0 THEN 0 ELSE (CtrlTargetHMI - CtrlBaseHMI)/CtrlTargetHMI END
,	ThinHMIDiff = CASE WHEN ThinTargetHMI=0 THEN 0 ELSE (ThinTargetHMI - ThinBaseHMI)/ThinTargetHMI END
INTO #Final
FROM #Baseline

/********************** #Final select **************************************************/

SELECT CenterDescription
,	MainGroupID
,	MainGroupDescription
,	ClientIdentifier
,	ClientFullNameCalc
,	AppointmentDate
,	ISNULL(CtrlDensityDiff,0) AS 'CtrlDensityDiff'
,	ISNULL(ThinDensityDiff,0) AS 'ThinDensityDiff'
,	ISNULL(CtrlWidthDiff,0) AS 'CtrlWidthDiff'
,	ISNULL(ThinWidthDiff,0) AS 'ThinWidthDiff'
,	ISNULL(CtrlHMIDiff,0) AS 'CtrlHMIDiff'
,	ISNULL(ThinHMIDiff,0) AS 'ThinHMIDiff'
FROM #Final
WHERE (CtrlDensityDiff IS NOT NULL
	OR ThinDensityDiff IS NOT NULL
	OR CtrlWidthDiff IS NOT NULL
	OR ThinWidthDiff IS NOT NULL
	OR CtrlHMIDiff IS NOT NULL
	OR ThinHMIDiff IS NOT NULL)

END
GO
