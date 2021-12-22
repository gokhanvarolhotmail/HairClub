/* CreateDate: 10/05/2015 17:04:38.517 , ModifyDate: 12/05/2017 15:23:09.040 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:            rptTVClientHistory
 Procedure Description:     This stored procedure provides client history of TrichoView appointments
								in Ascending order.
 Created By:				Rachelen Hut
 Date Created:              10/05/2015
 Destination Server:        HairclubCMS
 Related Application:       Conect
================================================================================================
Change History:
================================================================================================

10/05/2015 - RH - Proc Created
08/01/2017 - PM - Added new replacement statuses for Cancel CM Status (up, down, convert, renew)
12/05/2017 - RH - Changed to find client memberships using fnGetCurrentMembershipDetailsByClientID

Sample Execution:

EXEC [rptTVClientHistory] 357420
================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVClientHistory](
	@ClientIdentifier INT
)

AS
BEGIN

--Find CenterDescription
DECLARE @CenterDescription NVARCHAR(100)
SET @CenterDescription = (SELECT CenterDescriptionFullCalc
							FROM cfgCenter CTR
							INNER JOIN dbo.datClient CLT
								ON CLT.CenterID = CTR.CenterID
							WHERE ClientIdentifier = @ClientIdentifier)

/**********  Create temp tables ****************************************************************/

CREATE TABLE #Membership(MembershipID INT
	,	MembershipDescription nvarchar(50)
)

CREATE TABLE #MeasurementAppts(
	MyApptID INT IDENTITY(1,1)
	,	ClientGUID UNIQUEIDENTIFIER
	,	AppointmentGUID UNIQUEIDENTIFIER
	,	AppointmentDate DATETIME
	,	CheckinTime DATETIME
	,	Stylist NVARCHAR(102)
	,	ConsultantCRM  NVARCHAR(102)
	,   GenderDescriptionShort NVARCHAR(1)
	,	SalesCodeDescriptionShort  NVARCHAR(50)
	,	NotesClient NVARCHAR(4000)
	,	Ranking INT
)

CREATE TABLE #Calc( AppointmentGUID UNIQUEIDENTIFIER
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

/********************************** Find EXT Memberships *************************************/

INSERT INTO #Membership
SELECT MembershipID
,	MembershipDescription
FROM dbo.cfgMembership
WHERE MembershipDescription LIKE 'EXT%'

/********************************** Get Clients *********************************************/

SELECT CenterID
     , CenterDescription
     , ClientIdentifier
     , CMSClientIdentifier
     , ClientName
     , GenderID
     , ClientMembershipGUID
     , ClientMembershipIdentifier
     , MembershipID
     , Membership
     , MembershipDescriptionShort
     , MembershipStatus
     , MembershipSortOrder
     , ContractPrice
     , MonthlyFee
     , MembershipBeginDate
     , MembershipEndDate
     , BusinessSegmentID
     , RevenueGroupID
INTO #Clients
FROM dbo.fnGetCurrentMembershipDetailsByClientID(@ClientIdentifier)
WHERE MembershipID IN (SELECT MembershipID FROM #Membership)
AND MembershipEndDate > DATEADD(day,DATEDIFF(day,0,GETDATE()),0)  --Today


/********************************** Find measurement appointments *************************************/

INSERT INTO #MeasurementAppts
SELECT	APPT.ClientGUID
,	APPT.AppointmentGUID
,	APPT.AppointmentDate
,	APPT.CheckinTime
,	E.EmployeeFullNameCalc AS 'Stylist'
,	E2.EmployeeFullNameCalc AS 'ConsultantCRM'
,	CASE WHEN CLT.GenderID = 1 THEN 'M' WHEN CLT.GenderID = 2 THEN 'F' ELSE '' END AS 'GenderDescriptionShort'
,	SC.SalesCodeDescriptionShort
,	NOTES.NotesClient
,	ROW_NUMBER() OVER ( PARTITION BY APPT.ClientGUID ORDER BY APPT.ClientGUID, APPT.AppointmentDate ASC ) AS Ranking
FROM	datAppointment APPT
	INNER JOIN dbo.datClient CLT
		ON CLT.ClientGUID = APPT.ClientGUID
	INNER JOIN #Clients C
		ON CLT.ClientIdentifier = C.ClientIdentifier
	INNER JOIN dbo.datAppointmentEmployee AE
		ON APPT.AppointmentGUID = AE.AppointmentGUID
	INNER JOIN dbo.datAppointmentPhoto AP
		ON APPT.AppointmentGUID = AP.AppointmentGUID
	INNER JOIN dbo.datAppointmentPhotoMarkup APM
		ON AP.AppointmentPhotoID = APM.AppointmentPhotoID
	INNER JOIN dbo.datEmployee E
		ON AE.EmployeeGUID = E.EmployeeGUID
				LEFT JOIN dbo.datSalesOrder SO
					ON APPT.AppointmentGUID = SO.AppointmentGUID
				LEFT JOIN dbo.datSalesOrderDetail SOD
					ON SO.SalesOrderGUID = SOD.SalesOrderGUID
				LEFT JOIN dbo.cfgSalesCode SC
					ON SOD.SalesCodeID = SC.SalesCodeID
				LEFT JOIN dbo.datEmployee E2
					ON SOD.Employee1GUID = E2.EmployeeGUID --For Employee1 - Consultant CRM
				LEFT JOIN dbo.datNotesClient NOTES
					ON APPT.AppointmentGUID = NOTES.AppointmentGUID
WHERE   APPT.IsDeletedFlag = 0
	AND APM.PointX > 0
	AND APM.PointY > 0
	AND (SC.SalesCodeDescriptionShort <> 'SALECNSLT' OR SC.SalesCodeDescriptionShort IS NULL)  --Remove duplicate appointments
	AND ISNUMERIC(SC.SalesCodeDescriptionShort)<>1
GROUP BY APPT.ClientGUID
,	APPT.AppointmentGUID
,	APPT.AppointmentDate
,	APPT.CheckinTime
,	E.EmployeeFullNameCalc
,	E2.EmployeeFullNameCalc
,	CLT.GenderID
,	SC.SalesCodeDescriptionShort
,	NOTES.NotesClient


/********************************** Loop to find calculations ***********************************/

DECLARE @ClientGUID UNIQUEIDENTIFIER
DECLARE @AppointmentGUID UNIQUEIDENTIFIER
DECLARE @AppointmentGUID2 UNIQUEIDENTIFIER
DECLARE @Gender NVARCHAR(1)
DECLARE @ID INT


--Set the @ProjectID Variable for first iteration
SELECT @ID = MIN(MyApptID)
FROM #MeasurementAppts

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
END


/********************************** Get Days Since Last Measurement *************************************/

SELECT r.ClientGUID
,	r.LastMeasurementDate
,	DATEDIFF(DAY,r.LastMeasurementDate,GETDATE()) AS 'DaysSince'
INTO #LastMeasurement
FROM(
		SELECT	ROW_NUMBER() OVER ( PARTITION BY CLT.ClientGUID ORDER BY CLT.ClientGUID, APPT.AppointmentDate DESC ) AS Ranking
		,   CLT.ClientGUID
		,	APPT.AppointmentDate AS 'LastMeasurementDate'
		FROM	datAppointment APPT
				INNER JOIN dbo.datClient CLT
					ON CLT.ClientGUID = APPT.ClientGUID
				INNER JOIN #Clients C
					ON CLT.ClientIdentifier = C.ClientIdentifier
				INNER JOIN dbo.datAppointmentPhoto AP
					ON APPT.AppointmentGUID = AP.AppointmentGUID
				INNER JOIN dbo.datAppointmentPhotoMarkup APM
					ON AP.AppointmentPhotoID = APM.AppointmentPhotoID
		WHERE   APPT.IsDeletedFlag = 0
			AND PointX > 0
			AND APM.PointY > 0
		GROUP BY CLT.ClientGUID
		,	APPT.AppointmentDate
	)r
WHERE Ranking = 1



/**********************  Final select **************************************************/

SELECT @CenterDescription AS 'CenterDescription'
,	CALC.AppointmentGUID
,	CLT.ClientGUID
,	ROW_NUMBER() OVER ( PARTITION BY CLT.ClientGUID ORDER BY CLT.ClientGUID, CALC.AppointmentDate ASC ) AS ApptOrder
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	C.Membership
,	LM.LastMeasurementDate AS 'LastMeasurement'
,	LM.DaysSince
,	CALC.AppointmentDate
,	MA.CheckinTime
,	MA.Stylist
,	MA.NotesClient
,	CALC.HMIC
,	CALC.HMIT
,	MA.ConsultantCRM
,	SH.ScalpHealthDescription
,	CASE WHEN SUM(CASE WHEN AP.PhotoTypeID = 1 THEN 1 ELSE 0 END)> 5 THEN 5 ELSE SUM(CASE WHEN AP.PhotoTypeID = 1 THEN 1 ELSE 0 END) END AS  'Profile'
,	CASE WHEN SUM(CASE WHEN AP.PhotoTypeID = 2 THEN 1 ELSE 0 END)> 8 THEN 8 ELSE SUM(CASE WHEN AP.PhotoTypeID = 2 THEN 1 ELSE 0 END) END AS  'Scalp'
FROM #Clients	C
INNER JOIN dbo.datClient CLT
	ON CLT.ClientIdentifier = C.ClientIdentifier
LEFT OUTER JOIN #Calc CALC
	ON CLT.ClientGUID = CALC.ClientGUID
INNER JOIN dbo.datAppointment APPT
	ON CALC.AppointmentGUID = APPT.AppointmentGUID
LEFT OUTER JOIN #MeasurementAppts MA
	ON CLT.ClientGUID = MA.ClientGUID
	AND CALC.AppointmentGUID = MA.AppointmentGUID
LEFT OUTER JOIN #LastMeasurement LM
	ON CLT.ClientGUID = LM.ClientGUID
INNER JOIN dbo.datAppointmentPhoto AP
	ON CALC.AppointmentGUID = AP.AppointmentGUID
LEFT JOIN dbo.lkpScalpHealth SH
	ON APPT.ScalpHealthID = SH.ScalpHealthID
GROUP BY CALC.AppointmentGUID
       , CLT.ClientGUID
       , CLT.ClientIdentifier
       , CLT.ClientFullNameCalc
       , C.Membership
       , LM.LastMeasurementDate
       , LM.DaysSince
       , CALC.AppointmentDate
       , MA.CheckinTime
       , MA.Stylist
       , MA.NotesClient
       , CALC.HMIC
       , CALC.HMIT
       , MA.ConsultantCRM
       , SH.ScalpHealthDescription

END
GO
