/* CreateDate: 04/13/2018 16:41:04.263 , ModifyDate: 12/07/2018 09:45:04.047 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:            rptTVProgressReviewAuditBarth
 Procedure Description:     This stored procedure provides client information such as Last Visit,
								Next Appt, and Days since Last Measurement where days > 120
								or no measurement has been taken.  It reflects only the previous day's
								appointment where progress reviews were due. This is for the subscription
								for Barth centers only.
 Created By:				Rachelen Hut
 Date Created:              04/13/2018
 Destination Server:        HairclubCMS
 Related Application:       Conect
================================================================================================
Change History:
04/16/2018 - RH - (#148739) Removed any Xtrands or expired memberships, only current active EXT memberships remain
04/23/2018 - RH - (#148739) Changed logic to match the rptTVProgressReviewAuditByDate
12/06/2018 - RH - Removed Haircuts, color or checkup appointments (Case 6238)
================================================================================================
Sample Execution:

EXEC [rptTVProgressReviewAuditBarth]
================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVProgressReviewAuditBarth]

AS
BEGIN




--Find Yesterday's Dates
DECLARE @YesterdayStartDate DATETIME
DECLARE @YesterdayEndDate DATETIME

SET @YesterdayStartDate = DATEADD(day,DATEDIFF(day,0,GETDATE()-1),0)					--Yesterday at 12:00AM
SET @YesterdayEndDate = DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETDATE()),0) ))	--Yesterday at 11:59PM

--For testing
--SET @YesterdayStartDate = '3/21/2018 00:00.000'
--SET @YesterdayEndDate = '3/21/2018 23:59.000'

PRINT @YesterdayStartDate
PRINT @YesterdayEndDate


/**********  Create temp tables ****************************************************************/

CREATE TABLE #Centers(
	CenterID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionFullCalc NVARCHAR(103)
)

CREATE TABLE #Clients(
		ClientGUID UNIQUEIDENTIFIER
	,	CenterID INT
	,	CenterDescription NVARCHAR(150)
	,	ClientFullNameCalc NVARCHAR(250)
	,	ClientIdentifier INT
	,	MembershipID INT
	,	MembershipDescription NVARCHAR(50)
	,	MembershipDescriptionShort NVARCHAR(10)
	,	BusinessSegmentID INT
	,	SalesCodeID INT
	,	SalesCodeDescriptionShort NVARCHAR(50)
	,	AppointmentGUID UNIQUEIDENTIFIER
	,	AppointmentDate DATE
	,	CheckinTime TIME
	,	CheckoutTime TIME
	,	EmployeeFullNameCalc NVARCHAR(250)
	,	NotesClient NVARCHAR(600)
	,	CLTRank INT
)


CREATE TABLE #MeasurementAppts(
		ClientGUID UNIQUEIDENTIFIER
	,	CenterID INT
	,	ClientIdentifier INT
	,	ClientFullNameCalc NVARCHAR(250)
	,	AppointmentGUID UNIQUEIDENTIFIER
	,	AppointmentDate DATE
	,	CheckinTime DATETIME
	,	EmployeeFullNameCalc NVARCHAR(102)
	,	ConsultantCRM  NVARCHAR(102)
	,   GenderDescriptionShort NVARCHAR(1)
	,	Ranking INT
)


CREATE TABLE #CurrentAppts(
	ClientGUID UNIQUEIDENTIFIER
	,	CenterID INT
	,	ClientIdentifier INT
	,	ClientFullNameCalc NVARCHAR(250)
	,	AppointmentGUID UNIQUEIDENTIFIER
	,	AppointmentDate DATE
	,	CheckinTime DATETIME
	,	EmployeeFullNameCalc NVARCHAR(102)
	,	ConsultantCRM  NVARCHAR(102)
	,   GenderDescriptionShort NVARCHAR(1)
	,	Ranking INT
)


CREATE TABLE #PreviousMeasures(
	[DateDiff] INT
	,	ClientGUID UNIQUEIDENTIFIER
	,	CenterID INT
	,	ClientIdentifier INT
	,	ClientFullNameCalc NVARCHAR(250)
	,	AppointmentGUID UNIQUEIDENTIFIER
	,	AppointmentDate DATE
	,	CheckinTime DATETIME
	,	LMAppointmentGUID UNIQUEIDENTIFIER
	,	LMAppointmentDate DATETIME
	,	EmployeeFullNameCalc NVARCHAR(102)
	,	ConsultantCRM  NVARCHAR(102)
	,   GenderDescriptionShort NVARCHAR(1)
	,	Ranking INT
,	Completed INT
,	Due INT
)


CREATE TABLE #DueAppts(
[DateDiff] INT
	,	ClientGUID UNIQUEIDENTIFIER
	,	CenterID INT
	,	ClientIdentifier INT
	,	ClientFullNameCalc NVARCHAR(250)
	,	AppointmentGUID UNIQUEIDENTIFIER
	,	AppointmentDate DATE
	,	CheckinTime DATETIME
	,	LMAppointmentGUID UNIQUEIDENTIFIER
	,	LMAppointmentDate DATETIME
	,	EmployeeFullNameCalc NVARCHAR(102)
	,	ConsultantCRM  NVARCHAR(102)
	,   GenderDescriptionShort NVARCHAR(1)
	,	Ranking INT
,	Completed INT
,	Due INT
	)



CREATE TABLE #Combined(
	CombinedID INT IDENTITY(1,1)
,	[DateDiff] INT
,	ClientGUID UNIQUEIDENTIFIER
,	CenterID INT
,	ClientIdentifier INT
,	ClientFullNameCalc NVARCHAR(250)
,	AppointmentGUID UNIQUEIDENTIFIER
,	AppointmentDate DATETIME
,	CheckinTime DATETIME
,	LMAppointmentGUID UNIQUEIDENTIFIER
,	LMAppointmentDate DATETIME
,	EmployeeFullNameCalc NVARCHAR(250)
,	ConsultantCRM NVARCHAR(250)
,	GenderDescriptionShort NVARCHAR(1)
,	Ranking INT
,	Completed INT
,	Due INT
)


CREATE TABLE #Calc( AppointmentGUID UNIQUEIDENTIFIER
	,	AppointmentDate DATE
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



CREATE TABLE #CombiCalc( [DateDiff] INT
      , ClientGUID UNIQUEIDENTIFIER
      , CenterID INT
      , ClientIdentifier INT
      , ClientFullNameCalc NVARCHAR(250)
      , AppointmentGUID UNIQUEIDENTIFIER
      , AppointmentDate DATETIME
	  ,	ApptHMIC INT
	  ,	ApptHMIT INT
      , CheckinTime DATETIME
      , LMAppointmentGUID UNIQUEIDENTIFIER
      , LMAppointmentDate DATETIME
	  ,	LMHMIC INT
	  ,	LMHMIT INT
      , EmployeeFullNameCalc NVARCHAR(250)
      , ConsultantCRM NVARCHAR(250)
      , GenderDescriptionShort NVARCHAR(1)
      , Ranking INT
      , Completed INT
      , Due INT
)


CREATE TABLE #Final(	CenterID INT
	,	CenterDescription VARCHAR(50)
	,	CenterDescriptionFullCalc VARCHAR(104)
	,	AppointmentGUID UNIQUEIDENTIFIER
	,	ClientGUID UNIQUEIDENTIFIER
	,	ClientIdentifier INT
	,	ClientFullNameCalc NVARCHAR(125)
	,	MembershipDescription NVARCHAR(50)
	,	LastMeasurement DATETIME
	,	CtrlBaseHMI INT
	,	ThinBaseHMI INT
	,	DaysSince INT
	,	AppointmentDate DATE
	,	CheckinTime DATETIME
	,	CtrlTargetHMI INT
	,	ThinTargetHMI INT
	,	Code NVARCHAR(50)
	,	Stylist NVARCHAR(150)
	,	NotesClient  NVARCHAR(600)
	,	Completed INT
	,	Due INT
)


/********************************** Find Centers ********************************************/

INSERT INTO #Centers
SELECT CenterID
,	CenterDescription
,	CenterDescriptionFullCalc
FROM dbo.cfgCenter C
WHERE C.RegionID = 6  --Barth Centers
	AND C.IsActiveFlag = 1


/********************************** Find Yesterday's Clients *************************************/

INSERT INTO #Clients
SELECT AP.ClientGUID
,	CTR.CenterID
,	CTR.CenterDescription
,	CLT.ClientFullNameCalc
,	CLT.ClientIdentifier
,	M.MembershipID
,	M.MembershipDescription
,	M.MembershipDescriptionShort
,	M.BusinessSegmentID
,	AD.SalesCodeID
,	SC.SalesCodeDescriptionShort
,	AP.AppointmentGUID
,	CAST(AP.AppointmentDate AS DATE) AS 'AppointmentDate'
,	CAST(AP.CheckinTime AS TIME) AS 'CheckinTime'
,	CAST(AP.CheckoutTime AS TIME) AS 'CheckoutTime'
,	E.EmployeeFullNameCalc
,	LEFT(P.NotesClient,600) AS 'NotesClient'
,	ROW_NUMBER() OVER ( PARTITION BY AP.ClientGUID ORDER BY AP.ClientGUID, AP.AppointmentDate ASC ) AS CLTRank
FROM dbo.datAppointment AP
INNER JOIN dbo.datAppointmentDetail AD
	ON AP.AppointmentGUID = AD.AppointmentGUID
INNER JOIN dbo.cfgSalesCode SC
	ON AD.SalesCodeID = SC.SalesCodeID
INNER JOIN dbo.datClient CLT
	ON AP.ClientGUID = CLT.ClientGUID
INNER JOIN #Centers CTR
	ON AP.CenterID = CTR.CenterID
INNER JOIN dbo.datClientMembership CM
	ON CM.ClientMembershipGUID = AP.ClientMembershipGUID
INNER JOIN dbo.cfgMembership M
	ON CM.MembershipID = M.MembershipID
CROSS APPLY (SELECT ', ' + DN.NotesClient
			FROM datNotesClient AS DN
			WHERE AP.ClientGUID = DN.ClientGUID
			AND AP.AppointmentGUID = DN.AppointmentGUID
			ORDER BY DN.NotesClientDate
			FOR XML PATH('') ) AS P (NotesClient)
LEFT OUTER JOIN dbo.datAppointmentEmployee AE
	ON AP.AppointmentGUID = AE.AppointmentGUID
LEFT OUTER JOIN dbo.datEmployee E
	ON AE.EmployeeGUID = E.EmployeeGUID
WHERE ap.IsDeletedFlag = 0
	AND ap.AppointmentDate BETWEEN @YesterdayStartDate AND @YesterdayEndDate
	AND M.BusinessSegmentID = 2
	AND AP.CheckoutTime IS NOT NULL
	AND SC.SalesCodeDescriptionShort <> 'SALECNSLT'  --Remove consultations
	AND SC.SalesCodeDescriptionShort IN ('EXTPROSVC','EXTSVC','EXTMEMSVC','WEXTMEMSVC','WEXTSVC')




/********************************** Find measurement appointments BEFORE @StartDate *************************************/

INSERT INTO #MeasurementAppts
SELECT	C.ClientGUID
,	CTR.CenterID
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	AP.AppointmentGUID
,	APPT.AppointmentDate
,	APPT.CheckinTime
,	E.EmployeeFullNameCalc
,	E2.EmployeeFullNameCalc AS 'ConsultantCRM'
,	CASE WHEN CLT.GenderID = 2 THEN 'F' ELSE 'M' END AS GenderDescriptionShort
,	ROW_NUMBER() OVER ( PARTITION BY C.ClientGUID ORDER BY C.ClientGUID, APPT.AppointmentDate DESC ) AS Ranking
FROM	datAppointment APPT
	INNER JOIN #Clients C
		ON APPT.ClientGUID = C.ClientGUID
	INNER JOIN #Centers CTR
		ON CTR.CenterID = APPT.CenterID
	LEFT OUTER JOIN dbo.datClient CLT
		ON APPT.ClientGUID = CLT.ClientGUID
	LEFT OUTER JOIN dbo.datAppointmentEmployee AE
		ON APPT.AppointmentGUID = AE.AppointmentGUID
	LEFT OUTER JOIN dbo.datAppointmentPhoto AP
		ON APPT.AppointmentGUID = AP.AppointmentGUID
	LEFT OUTER JOIN dbo.datAppointmentPhotoMarkup APM
		ON AP.AppointmentPhotoID = APM.AppointmentPhotoID
	LEFT OUTER JOIN dbo.datEmployee E
		ON AE.EmployeeGUID = E.EmployeeGUID
	LEFT JOIN dbo.datSalesOrder SO
		ON APPT.AppointmentGUID = SO.AppointmentGUID
	LEFT JOIN dbo.datSalesOrderDetail SOD
		ON SO.SalesOrderGUID = SOD.SalesOrderGUID
	LEFT JOIN dbo.cfgSalesCode SC
		ON SOD.SalesCodeID = SC.SalesCodeID
	LEFT JOIN dbo.datEmployee E2
		ON SOD.Employee1GUID = E2.EmployeeGUID
WHERE   APPT.IsDeletedFlag = 0
	AND APM.PointX > 0
	AND APM.PointY > 0
	AND APPT.AppointmentDate < @YesterdayStartDate
GROUP BY C.ClientGUID
,	CTR.CenterID
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	AP.AppointmentGUID
,	APPT.AppointmentDate
,	APPT.CheckinTime
,	E.EmployeeFullNameCalc
,	E2.EmployeeFullNameCalc,	CLT.GenderID



/*************** Find current measurement appointments BETWEEN @StartDate and @EndDate *************************************/

INSERT INTO #CurrentAppts
SELECT	C.ClientGUID
,	CTR.CenterID
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	AP.AppointmentGUID
,	APPT.AppointmentDate
,	APPT.CheckinTime
,	E.EmployeeFullNameCalc
,	E2.EmployeeFullNameCalc AS 'ConsultantCRM'
,	CASE WHEN CLT.GenderID = 2 THEN 'F' ELSE 'M' END AS GenderDescriptionShort
,	ROW_NUMBER() OVER ( PARTITION BY C.ClientGUID ORDER BY C.ClientGUID, APPT.AppointmentDate DESC ) AS Ranking
FROM	datAppointment APPT
	INNER JOIN #Clients C
		ON APPT.ClientGUID = C.ClientGUID
	INNER JOIN #Centers CTR
		ON CTR.CenterID = APPT.CenterID
	LEFT OUTER JOIN dbo.datClient CLT
		ON APPT.ClientGUID = CLT.ClientGUID
	LEFT OUTER JOIN dbo.datAppointmentEmployee AE
		ON APPT.AppointmentGUID = AE.AppointmentGUID
	LEFT OUTER JOIN dbo.datAppointmentPhoto AP
		ON APPT.AppointmentGUID = AP.AppointmentGUID
	LEFT OUTER JOIN dbo.datAppointmentPhotoMarkup APM
		ON AP.AppointmentPhotoID = APM.AppointmentPhotoID
	LEFT OUTER JOIN dbo.datEmployee E
		ON AE.EmployeeGUID = E.EmployeeGUID
	LEFT JOIN dbo.datSalesOrder SO
		ON APPT.AppointmentGUID = SO.AppointmentGUID
	LEFT JOIN dbo.datSalesOrderDetail SOD
		ON SO.SalesOrderGUID = SOD.SalesOrderGUID
	LEFT JOIN dbo.cfgSalesCode SC
		ON SOD.SalesCodeID = SC.SalesCodeID
	LEFT JOIN dbo.datEmployee E2
		ON SOD.Employee1GUID = E2.EmployeeGUID
WHERE   APPT.IsDeletedFlag = 0
	AND APM.PointX > 0
	AND APM.PointY > 0
	AND APPT.AppointmentDate BETWEEN @YesterdayStartDate AND @YesterdayEndDate
GROUP BY C.ClientGUID
,	CTR.CenterID
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	AP.AppointmentGUID
,	APPT.AppointmentDate
,	APPT.CheckinTime
,	E.EmployeeFullNameCalc
,	E2.EmployeeFullNameCalc
,	CLT.GenderID


/****************These are active clients that have a datediff between their last measurement and this month's measurement  **************************/


INSERT INTO #PreviousMeasures
SELECT DATEDIFF(DAY,MA.AppointmentDate,CA.AppointmentDate) AS 'DateDiff'
,	CA.ClientGUID
,	CA.CenterID
,	CA.ClientIdentifier
,	CA.ClientFullNameCalc
,	CA.AppointmentGUID
,	CA.AppointmentDate
,	CA.CheckinTime
,	MA.AppointmentGUID AS 'LMAppointmentGUID'
,	MA.AppointmentDate AS 'LMAppointmentDate'
,	CA.EmployeeFullNameCalc
,	CA.ConsultantCRM
,	CA.GenderDescriptionShort
,	CA.Ranking
,	1 AS 'Completed'
,	CASE WHEN DATEDIFF(DAY,MA.AppointmentDate,CA.AppointmentDate) > 100 THEN 1 ELSE 0 END AS 'Due'
FROM #CurrentAppts CA
INNER JOIN #MeasurementAppts MA
	ON MA.ClientIdentifier = CA.ClientIdentifier
WHERE CA.Ranking =1
AND MA.Ranking = 1


/********** These are active clients that have measurements DUE ********************************************************/

INSERT INTO #DueAppts
SELECT DATEDIFF(DAY,MA.AppointmentDate,CLT.AppointmentDate) AS 'DateDiff'
,	MA.ClientGUID
,	MA.CenterID
,	MA.ClientIdentifier
,	MA.ClientFullNameCalc
,	CLT.AppointmentGUID
,	CLT.AppointmentDate
,	CLT.CheckinTime
,	MA.AppointmentGUID AS 'LMAppointmentGUID'
,	MA.AppointmentDate AS 'LMAppointmentDate'
,	MA.EmployeeFullNameCalc
,	MA.ConsultantCRM
,	MA.GenderDescriptionShort
, MA.Ranking
,	0 AS Completed
,	1 AS Due
FROM #MeasurementAppts MA
INNER JOIN #Clients CLT
	ON CLT.ClientIdentifier = MA.ClientIdentifier
WHERE CLT.ClientIdentifier NOT IN(SELECT ClientIdentifier FROM #CurrentAppts)
AND CLT.CLTRank = 1
AND MA.Ranking = 1
AND DATEDIFF(DAY,MA.AppointmentDate,CLT.AppointmentDate) > 100





/*************** Combine the records into one table ***************************************************************/

INSERT INTO #Combined
SELECT * FROM #PreviousMeasures
UNION
SELECT * FROM #DueAppts


/************* Insert combined records from #Combined and #Calc ***************************************************/

INSERT INTO #CombiCalc
SELECT   [DateDiff]
      , ClientGUID
      , CenterID
      , ClientIdentifier
      , ClientFullNameCalc
      , AppointmentGUID
      , AppointmentDate
	  ,	NULL AS ApptHMIC
	  ,	NULL AS ApptHMIT
      , CheckinTime
      , LMAppointmentGUID
      , LMAppointmentDate
	  ,	NULL AS LMHMIC
	  ,	NULL AS LMHMIT
      , EmployeeFullNameCalc
      , ConsultantCRM
      , GenderDescriptionShort
      , Ranking
      , Completed
      , Due
FROM #Combined



/********************************** Loop to find calculations ***********************************/

DECLARE @ClientGUID UNIQUEIDENTIFIER
DECLARE @AppointmentGUID UNIQUEIDENTIFIER
DECLARE @AppointmentGUID2 UNIQUEIDENTIFIER
DECLARE @Gender NVARCHAR(1)
DECLARE @ID INT


--Set the @ID Variable for first iteration
SELECT @ID = MIN(CombinedID)
FROM #Combined

--Loop through each set
WHILE @ID IS NOT NULL
BEGIN

SET @ClientGUID = (SELECT ClientGUID FROM #Combined
						WHERE CombinedID = @ID
						)
SET @AppointmentGUID  =  (SELECT  CASE WHEN AppointmentGUID IS NULL THEN LMAppointmentGUID ELSE AppointmentGUID END FROM #Combined
							WHERE ClientGUID = @ClientGUID AND CombinedID = @ID
							AND (AppointmentGUID <> LMAppointmentGUID OR AppointmentGUID IS NULL ))
SET @AppointmentGUID2  = (SELECT CASE WHEN AppointmentGUID IS NULL THEN LMAppointmentGUID ELSE LMAppointmentGUID END FROM #Combined
							WHERE ClientGUID = @ClientGUID AND CombinedID = @ID
							AND (AppointmentGUID <> LMAppointmentGUID OR AppointmentGUID IS NULL ))

SET @Gender = (SELECT  TOP 1 GenderDescriptionShort FROM #Combined WHERE CombinedID = @ID)

INSERT INTO #Calc
EXEC rptTVComparativeCalculations @AppointmentGUID, @AppointmentGUID2 ,@Gender


--Then at the end of the loop
SELECT @ID = MIN(CombinedID)
FROM #Combined
WHERE CombinedID > @ID
END



/************* Update the fields HMIC and HMIT for both Appointments and Last Measurements ******************************/

UPDATE #CombiCalc
SET #CombiCalc.ApptHMIC = #Calc.HMIC
FROM #Calc
WHERE #Calc.AppointmentGUID = #CombiCalc.AppointmentGUID
AND #CombiCalc.ApptHMIC IS NULL

UPDATE #CombiCalc
SET #CombiCalc.ApptHMIT = #Calc.HMIT
FROM #Calc
WHERE #Calc.AppointmentGUID = #CombiCalc.AppointmentGUID
AND #CombiCalc.ApptHMIT IS NULL

UPDATE #CombiCalc
SET #CombiCalc.LMHMIC = #Calc.HMIC
FROM #Calc
WHERE #Calc.AppointmentGUID = #CombiCalc.LMAppointmentGUID
AND #CombiCalc.LMHMIC IS NULL

UPDATE #CombiCalc
SET #CombiCalc.LMHMIT = #Calc.HMIT
FROM #Calc
WHERE #Calc.AppointmentGUID = #CombiCalc.LMAppointmentGUID
AND #CombiCalc.LMHMIT IS NULL



/***************** Insert into #Final ***********************************************************************/

INSERT INTO #Final
SELECT 	C.CenterID
	,	C.CenterDescription
	,	C.CenterDescriptionFullCalc
	,	#CombiCalc.AppointmentGUID
	,	#CombiCalc.ClientGUID
	,	#CombiCalc.ClientIdentifier
	,	CLTS.ClientFullNameCalc
	,	CLTS.MembershipDescription
	,	#CombiCalc.LMAppointmentDate AS 'LastMeasurement'
	,	#CombiCalc.LMHMIC AS'CtrlBaseHMI'
	,	#CombiCalc.LMHMIT AS 'ThinBaseHMI'
	,	#CombiCalc.[DateDiff] AS 'DaysSince'
	,	#CombiCalc.AppointmentDate
	,	#CombiCalc.CheckinTime
	,	#CombiCalc.ApptHMIC AS 'CtrlTargetHMI'
	,	#CombiCalc.ApptHMIT AS 'ThinTargetHMI'
	,	STUFF(Q.SalesCodeDescriptionShort, 1, 1, '') AS 'Code'
	,	ISNULL(#CombiCalc.EmployeeFullNameCalc, CLTS.EmployeeFullNameCalc)  AS 'Stylist'
	,	STUFF(P.Notes, 1, 1, '') AS 'NotesClient'
	,	#CombiCalc.Completed
	,	#CombiCalc.Due
FROM #Clients	CLTS
INNER JOIN #Centers C
	ON CLTS.CenterID = C.CenterID
INNER JOIN #CombiCalc
	ON CLTS.ClientGUID = #CombiCalc.ClientGUID
CROSS APPLY (SELECT ', ' + DN.NotesClient
			FROM datNotesClient AS DN
			WHERE CLTS.ClientGUID = DN.ClientGUID
			AND #CombiCalc.AppointmentGUID = DN.AppointmentGUID
			ORDER BY DN.NotesClientDate
			FOR XML PATH('') ) AS P (Notes)
CROSS APPLY (SELECT ', ' + SC.SalesCodeDescriptionShort
			FROM #Clients CLTS
			INNER JOIN cfgSalesCode SC
				ON CLTS.SalesCodeDescriptionShort = SC.SalesCodeDescriptionShort
			WHERE CLTS.ClientGUID = #CombiCalc.ClientGUID
			FOR XML PATH('') ) AS Q (SalesCodeDescriptionShort)
GROUP BY 	C.CenterID
	,	C.CenterDescription
	,	C.CenterDescriptionFullCalc
	,	#CombiCalc.AppointmentGUID
	,	#CombiCalc.ClientGUID
	,	#CombiCalc.ClientIdentifier
	,	CLTS.ClientFullNameCalc
	,	CLTS.MembershipDescription
	,	#CombiCalc.LMAppointmentDate
	,	#CombiCalc.LMHMIC
	,	#CombiCalc.LMHMIT
	,	#CombiCalc.[DateDiff]
	,	#CombiCalc.AppointmentDate
	,	#CombiCalc.CheckinTime
	,	#CombiCalc.ApptHMIC
	,	#CombiCalc.ApptHMIT
	,	STUFF(Q.SalesCodeDescriptionShort ,1 ,1 ,'')
	,	ISNULL(#CombiCalc.EmployeeFullNameCalc, CLTS.EmployeeFullNameCalc)
	,	STUFF(P.Notes, 1, 1, '')
	,	#CombiCalc.Completed
	,	#CombiCalc.Due

SELECT  CenterID
      , CenterDescription
      , CenterDescriptionFullCalc
      , AppointmentGUID
      , ClientGUID
      , ClientIdentifier
      , ClientFullNameCalc
      , MembershipDescription
      , LastMeasurement
      , ISNULL(CtrlBaseHMI,0) AS 'CtrlBaseHMI'
      , ISNULL(ThinBaseHMI,0) AS 'ThinBaseHMI'
      , DaysSince
      , AppointmentDate
      , CheckinTime
      , ISNULL(CtrlTargetHMI,0) AS 'CtrlTargetHMI'
      , ISNULL(ThinTargetHMI,0) AS 'ThinTargetHMI'
      , Code
      , Stylist
      , NotesClient
      , Completed
      , Due
FROM #Final
WHERE DaysSince > 100
--AND Completed = 0

END
GO
