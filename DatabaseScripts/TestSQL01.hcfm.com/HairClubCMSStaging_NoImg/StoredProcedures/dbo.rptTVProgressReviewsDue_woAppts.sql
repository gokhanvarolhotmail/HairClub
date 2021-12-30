/* CreateDate: 12/22/2015 15:21:32.047 , ModifyDate: 12/12/2018 10:26:25.203 */
GO
/*===============================================================================================
 Procedure Name:            rptTVProgressReviewsDue_woAppts
 Procedure Description:     This stored procedure provides client information such as Last Visit,
								Next Appt, and Days since Last Measurement where days > 110
								or no measurement has been taken.
 Created By:				Rachelen Hut
 Date Created:              09/28/2015
 Destination Server:        HairclubCMS
 Related Application:       Conect
================================================================================================
CHANGE HISTORY:
12/22/2015 - RH  - Proc Created
08/01/2017 - PRM - Added new replacement statuses for Cancel CM Status (up, down, convert, renew)
12/22/2015 - RH  - Changed the report to pull only today's appointments
12/05/2017 - RH  - Changed logic to find more clients - too many were being removed (#145400)
================================================================================================
SAMPLE EXECUTION:

EXEC [rptTVProgressReviewsDue_woAppts] 745
================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVProgressReviewsDue_woAppts](
	@CenterID INT
)

AS
BEGIN

--Find CenterDescription
DECLARE @CenterDescription NVARCHAR(100)
SET @CenterDescription = (SELECT CenterDescriptionFullCalc FROM cfgCenter WHERE CenterID = @CenterID)

/********************************** Find EXT Memberships *************************************/

CREATE TABLE #Membership(MembershipID INT
,	MembershipDescription nvarchar(50))

INSERT INTO #Membership
SELECT MembershipID
,	MembershipDescription
FROM dbo.cfgMembership
WHERE MembershipDescription LIKE 'EXT%'


/********************************** Get Clients *************************************/

SELECT CenterSSID
     , CenterDescription
     , ClientGUID
     , ClientIdentifier
     , CMSClientIdentifier
     , ClientName
     , GenderID
     , SiebelID
     , ClientMembershipGUID
     , MembershipSSID
     , MembershipDescription
     , MembershipDescriptionShort
     , MembershipStatus
     , MembershipSortOrder
     , ContractPrice
     , ContractPaidAmount
     , MonthlyFee
     , MembershipBeginDate
     , MembershipEndDate
     , BusinessSegmentID
     , RevenueGroupID
     , ClientMembershipIdentifier
INTO #Clients
FROM dbo.fnGetCurrentMembershipDetailsByCenterID(@CenterID)
WHERE MembershipSSID IN (SELECT MembershipID FROM #Membership)
AND MembershipEndDate > DATEADD(day,DATEDIFF(day,0,GETDATE()),0)  --Today


/********************************** Get Todays Appointment *************************************/

SELECT CL.ClientGUID
,	dbo.fn_GetTodaysAppointmentDate(CL.ClientMembershipGUID) AS 'TodaysAppointmentDate'
INTO	#Appointment
FROM   #Clients CL


/********************************** Get Next Appointment *************************************/

SELECT CL.ClientGUID
,      dbo.fn_GetNextAppointmentDate(CL.ClientMembershipGUID) NextAppointmentDate
INTO	#NextAppointment
FROM   #Clients CL


/********************************** Get LastMeasurement *************************************/

SELECT r.ClientGUID
,	r.LastMeasurementDate
,	DATEDIFF(DAY,r.LastMeasurementDate,GETDATE()) AS 'DaysSince'
INTO #LastMeasurement
FROM(
		SELECT	ROW_NUMBER() OVER ( PARTITION BY C.ClientGUID ORDER BY C.ClientGUID, APPT.AppointmentDate DESC ) AS Ranking
		,   C.ClientGUID
		,	APPT.AppointmentDate AS 'LastMeasurementDate'
		FROM	datAppointment APPT
				INNER JOIN #Clients C
					ON APPT.ClientGUID = C.ClientGUID
				INNER JOIN dbo.datAppointmentPhoto AP
					ON APPT.AppointmentGUID = AP.AppointmentGUID
				INNER JOIN dbo.datAppointmentPhotoMarkup APM
					ON AP.AppointmentPhotoID = APM.AppointmentPhotoID
		WHERE   APPT.IsDeletedFlag = 0
			AND PointX > 0
			AND APM.PointY > 0
		GROUP BY C.ClientGUID
		,	APPT.AppointmentDate
	)r
WHERE Ranking = 1

/********************************** Get Last Visit *************************************/

SELECT q.ClientGUID
,	q.LastVisitDate
,	q.LastCode
,	q.LastStylist
,	q.NotesClient
INTO #LastVisit
FROM(
		SELECT	ROW_NUMBER() OVER ( PARTITION BY C.ClientGUID ORDER BY C.ClientGUID, APPT.AppointmentDate DESC ) AS Ranking
		,   C.ClientGUID
		,	APPT.AppointmentDate AS 'LastVisitDate'
		,	SC.SalesCodeDescriptionShort AS 'LastCode'
		,	E.EmployeeFullNameCalc AS 'LastStylist'
		,	NOTES.NotesClient
		FROM	datAppointment APPT
				INNER JOIN #Clients C
					ON APPT.ClientGUID = C.ClientGUID
				INNER JOIN dbo.datClientMembership CM
					ON APPT.ClientMembershipGUID = CM.ClientMembershipGUID
				INNER JOIN dbo.datAppointmentDetail AD
					ON APPT.AppointmentGUID = AD.AppointmentGUID
				LEFT OUTER JOIN dbo.datNotesClient NOTES
					ON APPT.AppointmentGUID = NOTES.AppointmentGUID
				INNER JOIN dbo.cfgSalesCode SC
					ON AD.SalesCodeID = SC.SalesCodeID
				LEFT OUTER JOIN dbo.datAppointmentEmployee AE
					ON APPT.AppointmentGUID = AE.AppointmentGUID
				LEFT OUTER JOIN dbo.datEmployee E
					ON AE.EmployeeGUID = E.EmployeeGUID
		WHERE   APPT.IsDeletedFlag = 0
		AND APPT.AppointmentDate < GETDATE()
		GROUP BY C.ClientGUID
		,	APPT.AppointmentDate
		,	SC.SalesCodeDescriptionShort
		,	E.EmployeeFullNameCalc
		,	NOTES.NotesClient
	)q
WHERE Ranking = 1

/********************************** Display Data *************************************/

SELECT  @CenterDescription AS 'CenterDescription'
	,	C.ClientIdentifier
	,	C.ClientName AS 'ClientFullNameCalc'
	,	C.MembershipDescription
	,	A.TodaysAppointmentDate
	,	NA.NextAppointmentDate
	,	LM.LastMeasurementDate AS 'LastMeasurementDate'
	,	ISNULL(LM.DaysSince,'0') AS 'DaysSinceLM'
	,	LV.LastVisitDate
	,	LV.LastCode
	,	LV.LastStylist
	,	LV.NotesClient
INTO #NoAppts
FROM    #Clients C
LEFT OUTER JOIN #Appointment A
	ON C.ClientGUID = A.ClientGUID
LEFT OUTER JOIN #NextAppointment NA
	ON C.ClientGUID = NA.ClientGUID
LEFT OUTER JOIN #LastMeasurement LM
	ON C.ClientGUID = LM.ClientGUID
LEFT OUTER JOIN #LastVisit LV
	ON C.ClientGUID = LV.ClientGUID
WHERE (ISNULL(LM.DaysSince,'0') = 0 OR ISNULL(LM.DaysSince,'0') > 100)
GROUP BY C.ClientIdentifier
    ,	C.ClientName
    ,	C.MembershipDescription
    ,	A.TodaysAppointmentDate
	,	NA.NextAppointmentDate
    ,	LM.LastMeasurementDate
    ,	LM.DaysSince
    ,	LV.LastVisitDate
    ,	LV.LastCode
    ,	LV.LastStylist
	,	LV.NotesClient

SELECT * FROM #NoAppts
WHERE TodaysAppointmentDate IS NULL


END
GO
