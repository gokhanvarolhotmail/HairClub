/* CreateDate: 09/30/2015 14:37:18.317 , ModifyDate: 12/07/2018 09:46:30.563 */
GO
/*===============================================================================================
 Procedure Name:            rptTVProgressReviewsDue
 Procedure Description:     This stored procedure provides client information such as Last Visit,
								Next Appt, and Days since Last Measurement where days > 120
								or no measurement has been taken.
 Created By:				Rachelen Hut
 Date Created:              09/28/2015
 Destination Server:        HairclubCMS
 Related Application:       Conect
================================================================================================
Change History:
12/22/2015 - RH - Changed the report to pull only today's appointments
12/29/2015 - RH - Changed report to include clients without a membership; removed unused fields
10/19/2017 - RH - Changed logic for Today's Appts to be any appointment, not just those like 'EXT%'; LM.DaysSinceLM > 100
12/05/2017 - RH - Changed logic to find more clients - too many were being removed (#145400)
08/23/2018 - RH - (#152658) Removed where MembershipEndDate > DATEADD(day,DATEDIFF(day,0,GETDATE()),0) --Today-- to include Expired Memberships
12/06/2018 - RH - Removed Haircuts, color or checkup appointments (Case 6238)
================================================================================================
Sample Execution:

EXEC [rptTVProgressReviewsDue] 746
================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVProgressReviewsDue](
	@CenterID INT
)

AS
BEGIN

--Find CenterDescription
DECLARE @CenterDescription NVARCHAR(100)
SET @CenterDescription = (SELECT CenterDescriptionFullCalc FROM cfgCenter WHERE CenterID = @CenterID)

--Find today's dates
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME

SET @StartDate = DATEADD(day,DATEDIFF(day,0,GETDATE()),0)						--Today at 12:00AM
SET @EndDate = DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETDATE()+1),0) )) --Today at 11:59PM


/********************************** Find EXT Memberships *************************************/

CREATE TABLE #Membership(MembershipID INT
,	MembershipDescription nvarchar(50))

INSERT INTO #Membership
SELECT MembershipID
,	MembershipDescription
FROM dbo.cfgMembership
WHERE MembershipDescription LIKE 'EXT%'

/********************************** Get Client Memberships *************************************/

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
--AND MembershipEndDate > DATEADD(day,DATEDIFF(day,0,GETDATE()),0) --Today  --Removed RH 8/23/2018 to include Expired Memberships

/********************************** Find Today's Clients *************************************/

SELECT AP.ClientGUID
,	CLT.ClientName
,	CLT.ClientIdentifier
,	AD.SalesCodeID
,	SC.SalesCodeDescriptionShort
,	CAST(AP.AppointmentDate AS DATE) AS 'AppointmentDate'
,	CAST(AP.StartTime AS TIME) AS 'StartTime'
,	E.EmployeeFullNameCalc
INTO #TodaysClients
FROM dbo.datAppointment AP
INNER JOIN dbo.datAppointmentDetail AD
	ON AP.AppointmentGUID = AD.AppointmentGUID
INNER JOIN dbo.cfgSalesCode SC
	ON AD.SalesCodeID = SC.SalesCodeID
INNER JOIN #Clients CLT
	ON AP.ClientGUID = CLT.ClientGUID
LEFT JOIN dbo.datAppointmentEmployee AE
	ON AP.AppointmentGUID = AE.AppointmentGUID
LEFT JOIN dbo.datEmployee E
	ON AE.EmployeeGUID = E.EmployeeGUID
WHERE ap.IsDeletedFlag = 0
	AND ap.AppointmentDate BETWEEN @StartDate AND @EndDate
	AND ap.CenterID = @CenterID
	AND SC.SalesCodeDescriptionShort IN ('EXTPROSVC','EXTSVC','EXTMEMSVC','WEXTMEMSVC','WEXTSVC')


/********************************** Get LastMeasurement and DaysSince *************************************/


SELECT r.ClientGUID
,	r.LastMeasurementDate
,	DATEDIFF(DAY,r.LastMeasurementDate,GETDATE()) AS 'DaysSinceLM'
INTO #LastMeasurement
FROM(
		SELECT	ROW_NUMBER() OVER ( PARTITION BY TC.ClientGUID ORDER BY TC.ClientGUID, APPT.AppointmentDate DESC ) AS Ranking
		,   TC.ClientGUID
		,	APPT.AppointmentDate AS 'LastMeasurementDate'
		FROM	datAppointment APPT
				INNER JOIN #TodaysClients TC
					ON APPT.ClientGUID = TC.ClientGUID
				INNER JOIN dbo.datAppointmentPhoto AP
					ON APPT.AppointmentGUID = AP.AppointmentGUID
				INNER JOIN dbo.datAppointmentPhotoMarkup APM
					ON AP.AppointmentPhotoID = APM.AppointmentPhotoID
		WHERE   APPT.IsDeletedFlag = 0
			AND PointX > 0
			AND APM.PointY > 0
		GROUP BY TC.ClientGUID
		,	APPT.AppointmentDate
	)r
WHERE Ranking = 1

/*********** Find Last Visit Date, Last Code and Last Stylist ********************************************/

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

/********************************** Final select *********************************************************/

SELECT TC.ClientGUID
,	CM.ClientIdentifier
,	TC.ClientName AS 'ClientFullNameCalc'
,	TC.SalesCodeID
,	TC.SalesCodeDescriptionShort
,	CAST((CAST(TC.AppointmentDate AS VARCHAR(10)) + ' ' + CAST(TC.StartTime AS VARCHAR(8))) AS DATETIME) AS 'TodaysAppointmentDate'
,	TC.EmployeeFullNameCalc
,	CM.MembershipDescription
,	LM.LastMeasurementDate
,	LM.DaysSinceLM
,	#LastVisit.LastVisitDate
,	#LastVisit.LastCode
,	#LastVisit.LastStylist
,	#LastVisit.NotesClient
FROM #TodaysClients TC
LEFT OUTER JOIN #Clients CM
	ON TC.ClientGUID = CM.ClientGUID
LEFT OUTER JOIN #LastMeasurement LM
	ON TC.ClientGUID = LM.ClientGUID
LEFT OUTER JOIN #LastVisit
	ON #LastVisit.ClientGUID = CM.ClientGUID
WHERE LM.DaysSinceLM > 100  --per Joe 10/19/2017

END
GO
