/* CreateDate: 09/06/2012 13:24:16.570 , ModifyDate: 09/18/2012 13:17:35.030 */
GO
CREATE PROCEDURE [dbo].[dbaCMSv40AppointmentImport] (
	@Center int
)AS
BEGIN
	SET NOCOUNT ON

declare @apptdate datetime

set @apptdate = '8/18/12'

DELETE FROM datAppointmentPhoto
WHERE AppointmentGUID IN (
	SELECT AppointmentGUID
	FROM datAppointment a
		INNER JOIN cfgCenter c ON a.CenterID = c.CenterID
	WHERE c.EmployeeDoctorGUID IS NULL and a.CenterID = @Center
		and a.AppointmentDate >= @apptdate
	)

DELETE FROM datSalesOrderTender
WHERE SalesOrderGUID IN (
	SELECT so.SalesOrderGUID
	FROM datSalesOrder so
		INNER JOIN datAppointment a ON so.AppointmentGUID = a.AppointmentGUID
		INNER JOIN cfgCenter c ON a.CenterID = c.CenterID
	WHERE c.EmployeeDoctorGUID IS NULL and so.CenterID = @Center
		and a.AppointmentDate >= @apptdate
	)

DELETE FROM datSalesOrderDetail
WHERE SalesOrderGUID IN (
	SELECT so.SalesOrderGUID
	FROM datSalesOrder so
		INNER JOIN datAppointment a ON so.AppointmentGUID = a.AppointmentGUID
		INNER JOIN cfgCenter c ON a.CenterID = c.CenterID
	WHERE c.EmployeeDoctorGUID IS NULL and so.CenterID = @Center
		and a.AppointmentDate >= @apptdate
	)

DELETE FROM datSalesOrder
WHERE AppointmentGUID IN (
	SELECT AppointmentGUID
	FROM datAppointment a
		INNER JOIN cfgCenter c ON a.CenterID = c.CenterID
	WHERE c.EmployeeDoctorGUID IS NULL and a.CenterID = @Center
		and a.AppointmentDate >= @apptdate
	)

DELETE FROM datAppointmentEmployee
WHERE AppointmentGUID IN (
	SELECT AppointmentGUID
	FROM datAppointment a
		INNER JOIN cfgCenter c ON a.CenterID = c.CenterID
	WHERE c.EmployeeDoctorGUID IS NULL and a.CenterID = @Center
		and a.AppointmentDate >= @apptdate
	)

DELETE FROM datAppointmentDetail
WHERE AppointmentGUID IN (
	SELECT AppointmentGUID
	FROM datAppointment a
		INNER JOIN cfgCenter c ON a.CenterID = c.CenterID
	WHERE c.EmployeeDoctorGUID IS NULL and a.CenterID = @Center
		and a.AppointmentDate >= @apptdate
	)

DELETE FROM datAppointment
WHERE AppointmentGUID IN (
	SELECT AppointmentGUID
	FROM datAppointment a
		INNER JOIN cfgCenter c ON a.CenterID = c.CenterID
	WHERE c.EmployeeDoctorGUID IS NULL and a.CenterID = @Center
		and a.AppointmentDate >= @apptdate
	)


CREATE TABLE #Appointments(
	AppointmentGUID UNIQUEIDENTIFIER DEFAULT NEWID()
	, AppointmentID_Temp INT
	, ClientGUID UNIQUEIDENTIFIER
	, ClientMembershipGUID UNIQUEIDENTIFIER
	, ParentAppointmentGUID UNIQUEIDENTIFIER
	, CenterID INT
	, ClientHomeCenterID INT
	, ResourceID VARCHAR(5)
	, ConfirmationTypeID INT
	, AppointmentTypeID INT
	, AppointmentDate DATETIME
	, StartTime DATETIME
	, EndTime DATETIME
	, CheckInTime DATETIME
	, CheckOutTime DATETIME
	, AppointmentSubject NVARCHAR(500)
	, CanPrintCommentFlag BIT
	, StartDateTimeCalc DATETIME
	, EndDateTimeCalc DATETIME
	, AppointmentDurationCalc INT
	, CreateDate DATETIME
	, CreateUser VARCHAR(25)
	, LastUpdate DATETIME
	, LastUpdateUser VARCHAR(25)
	, IsDeletedFlag BIT )

CREATE TABLE #AppointmentDetails (
		AppointmentDetailGUID UNIQUEIDENTIFIER DEFAULT NEWID()
	,	AppointmentGUID UNIQUEIDENTIFIER
	,	SalesCodeID INT
	,	AppointmentDetailDuration INT
	,	CreateDate DATETIME
	,	CreateUser VARCHAR(25)
	,	LastUpdate DATETIME
	,	LastUpdateUser VARCHAR(25))

CREATE TABLE #AppointmentEmployees (
		AppointmentEmployeeGUID UNIQUEIDENTIFIER DEFAULT NEWID()
	,	AppointmentGUID UNIQUEIDENTIFIER
	,	EmployeeGUID UNIQUEIDENTIFIER
	,	CreateDate DATETIME
	,	CreateUser VARCHAR(25)
	,	LastUpdate DATETIME
	,	LastUpdateUser VARCHAR(25))

CREATE TABLE #AppointmentSubject (
		AppointmentID int
	,	ApptSubject VARCHAR(50))

--
--
--

INSERT INTO #AppointmentSubject(
	AppointmentID,
	ApptSubject)
	SELECT
		a.appointmentid,
		max([Description])
	FROM [HCSQL2\SQL2005].INFOSTORE.DBO.appointment a
		INNER JOIN [HCSQL2\SQL2005].INFOSTORE.DBO.appointmentdetails
			on a.AppointmentID = appointmentdetails.AppointmentID
		INNER JOIN [HCSQL2\SQL2005].bosoperations.dbo.cmssalescodes
			on appointmentdetails.salescode = cmssalescodes.salescode
	WHERE a.[Date] >= @apptdate and a.Center = @Center
	GROUP BY a.appointmentid
--
-- Get Appointments
--
INSERT INTO #Appointments(
	AppointmentID_Temp
	, ClientGUID
	, ClientMembershipGUID
	, ParentAppointmentGUID
	, CenterID
	, ClientHomeCenterID
	, ResourceID
	, ConfirmationTypeID
	, AppointmentTypeID
	, AppointmentDate
	, StartTime
	, EndTime
	, CheckInTime
	, CheckOutTime
	, AppointmentSubject
	, CanPrintCommentFlag
	, StartDateTimeCalc
	, EndDateTimeCalc
	, AppointmentDurationCalc
	, CreateDate
	, CreateUser
	, LastUpdate
	, LastUpdateUser
	, IsDeletedFlag)
	SELECT a.AppointmentID As 'AppointmentID_Temp'
		,	CASE WHEN c.ClientGUID IS NOT NULL THEN c.ClientGUID ELSE NULL END As 'ClientGUID'
		,	CASE WHEN cm.ClientMembershipGUID IS NOT NULL THEN
				cm.ClientMembershipGUID ELSE NULL END As 'ClientMembershipGUID'
		,	NULL As 'ParentAppointmentGUID'
		,	Center As 'CenterID'
		,	ISNULL(c.CenterID,Center) As 'ClientHomeCenterID'
		,	NULL As 'ResourceID'
		,	CASE WHEN ConfirmationType = '1' THEN ConfirmationType END As 'ConfirmationTypeID'
		,	NULL As 'AppointmentTypeID'
		,	[date] As AppointmentDate
		,	CONVERT(VARCHAR,StartTime,8) 'StartTime'
		,	CONVERT(VARCHAR,DATEADD(mi,TotalDuration,StartTime),8) As 'EndTime'
		,	CheckInTime
		,	CheckOutTime
		,	#AppointmentSubject.ApptSubject AS 'AppointmentSubject'
		,	0 'CanPrintCommentFlag'
		,	[date] + CONVERT(VARCHAR,StartTime,8) As 'StartDateTimeCalc'
		,	[date] + CONVERT(VARCHAR,DATEADD(mi,TotalDuration,StartTime),8) As 'EndDateTimeCalc'
		,	TotalDuration As 'AppointmentDurationCalc'
		,	CMSCreateDate As 'CreateDate'
		,	CMSCreateID As 'CreateUser'
		,	CMSLastUpdate As 'LastUpdate'
		,	'NonSurgeryImport' As 'LastUpdateUser'
		,	0 As 'IsDeletedFlag'
FROM [HCSQL2\SQL2005].Infostore.dbo.Appointment a
	INNER JOIN datClient c ON a.Center = c.CenterID AND a.ClientNbr = c.clientNumber_Temp
	LEFT JOIN datClientMembership cm ON isnull(c.CurrentBioMatrixClientMembershipGUID,c.CurrentExtremeTherapyClientMembershipGUID)  = cm.ClientMembershipGUID
	LEFT OUTER JOIN #AppointmentSubject on a.AppointmentID = #AppointmentSubject.AppointmentID
WHERE a.[Date] >= @apptdate and a.Center = @Center


INSERT INTO #AppointmentDetails (
		AppointmentGUID
	,	SalesCodeID
	,	AppointmentDetailDuration
	,	CreateDate
	,	CreateUser
	,	LastUpdate
	,	LastUpdateUser)
SELECT 	A.AppointmentGUID
	,	C.SalesCodeID As 'SalesCodeID'
	,	AD.Duration As 'AppointmentDetailDuration'
	,	AD.CMSCreateDate As 'CreateDate'
	,	AD.CMSCreateID As 'CreateUser'
	,	AD.CMSLastUpdate As 'LastUpdate'
	,	'NonSurgeryImport' As 'LastUpdateUser'
FROM [HCSQL2\SQL2005].Infostore.dbo.AppointmentDetails AD
	INNER JOIN #Appointments A ON AD.AppointmentID = A.AppointmentID_Temp AND AD.Center = A.CenterID
	INNER JOIN cfgSalesCode C ON AD.SalesCode = C.SalesCodeDescriptionShort


INSERT INTO #AppointmentEmployees(
	AppointmentGUID
	, EmployeeGUID
	, CreateDate
	, CreateUser
	, LastUpdate
	, LastUpdateUser)
	SELECT AppointmentGUID
		,	hce.EmployeeGUID
		,	GETUTCDATE() As 'CreateDate'
		,	'NonSurgeryImport' As 'CreateUser'
		,	GETUTCDATE() As 'LastUpdate'
		,	'NonSurgeryImport' As 'LastUpdateUser'
FROM [HCSQL2\SQL2005].Infostore.dbo.Appointment AD
	INNER JOIN #Appointments A ON AD.AppointmentID = A.AppointmentID_Temp AND AD.Center = a.CenterID
	LEFT JOIN Infostoreconv.dbo.Employee hce
		ON AD.Stylist_Calc = hce.Code AND AD.Center = hce.Center AND hce.Position IN (1,2)
	LEFT JOIN datEmployee e ON hce.Full_Name = e.UserLogin AND hce.Center = e.CenterID


--HACK: lots employees don't tie, so just default the one's currently set to NULL
UPDATE ae
SET ae.EmployeeGUID = e.EmployeeGUID
FROM #AppointmentEmployees ae
	INNER JOIN #Appointments a ON ae.AppointmentGUID = a.AppointmentGUID
	INNER JOIN datEmployee e ON a.CenterID = e.CenterID
WHERE ae.EmployeeGUID IS NULL


DELETE FROM #AppointmentEmployees
WHERE #AppointmentEmployees.EmployeeGUID IS NULL

DELETE FROM #AppointmentDetails
WHERE AppointmentGUID NOT IN (
	SELECT a.AppointmentGUID
	FROM #Appointments a
		INNER JOIN #AppointmentEmployees ae ON a.AppointmentGUID = ae.AppointmentGUID
	)

DELETE FROM #Appointments
WHERE AppointmentGUID NOT IN (
	SELECT a.AppointmentGUID
	FROM #Appointments a
		INNER JOIN #AppointmentEmployees ae ON a.AppointmentGUID = ae.AppointmentGUID
	)

INSERT INTO datAppointment(
	  AppointmentGUID
	, AppointmentID_Temp
	, ClientGUID
	, ClientMembershipGUID
	, ParentAppointmentGUID
	, CenterID
	, ClientHomeCenterID
	, ResourceID
	, ConfirmationTypeID
	, AppointmentTypeID
	, AppointmentDate
	, StartTime
	, EndTime
	, CheckInTime
	, CheckOutTime
	, AppointmentSubject
	, CanPrintCommentFlag
	, CreateDate
	, CreateUser
	, LastUpdate
	, LastUpdateUser
	, IsDeletedFlag)
SELECT 	AppointmentGUID
	,	AppointmentID_Temp
	,	ClientGUID
	,	ClientMembershipGUID
	,	ParentAppointmentGUID
	,	CenterID
	,	ClientHomeCenterID
	,	ResourceID
	,	ConfirmationTypeID
	,	AppointmentTypeID
	,	AppointmentDate
	,	StartTime
	,	EndTime
	,	CheckInTime
	,	CheckOutTime
	,	AppointmentSubject
	,	CanPrintCommentFlag
	,	CreateDate
	,	CreateUser
	,	LastUpdate
	,	LastUpdateUser
	,	IsDeletedFlag
FROM #Appointments

INSERT INTO datAppointmentDetail(
		AppointmentDetailGUID
	,	AppointmentGUID
	,	SalesCodeID
	,	AppointmentDetailDuration
	,	CreateDate
	,	CreateUser
	,	LastUpdate
	,	LastUpdateUser)
SELECT 	AppointmentDetailGUID
	,	AppointmentGUID
	,	SalesCodeID
	,	AppointmentDetailDuration
	,	CreateDate
	,	CreateUser
	,	LastUpdate
	,	LastUpdateUser
FROM #AppointmentDetails

INSERT INTO datAppointmentEmployee(
		AppointmentEmployeeGUID
	,	AppointmentGUID
	,	EmployeeGUID
	,	CreateDate
	,	CreateUser
	,	LastUpdate
	,	LastUpdateUser)
SELECT 	AppointmentEmployeeGUID
	,	AppointmentGUID
	,	EmployeeGUID
	,	CreateDate
	,	CreateUser
	,	LastUpdate
	,	LastUpdateUser
FROM #AppointmentEmployees


/*
SELECT '#Appointments:', COUNT(*) FROM #Appointments
SELECT '#AppointmentDetails:', COUNT(*) FROM #AppointmentDetails
SELECT '#AppointmentEmployees:', COUNT(*) FROM #AppointmentEmployees
*/


DROP TABLE #Appointments
DROP TABLE #AppointmentDetails
DROP TABLE #AppointmentEmployees

/*
SELECT 'datAppointment:', COUNT(*)
FROM datAppointment a
	INNER JOIN cfgCenter c ON a.CenterID = c.CenterID
WHERE c.EmployeeDoctorGUID IS NULL

SELECT 'datAppointmentDetail:', COUNT(*)
FROM datAppointmentDetail ad
	INNER JOIN datAppointment a ON ad.AppointmentGUID = a.AppointmentGUID
	INNER JOIN cfgCenter c ON a.CenterID = c.CenterID
WHERE c.EmployeeDoctorGUID IS NULL


SELECT 'datAppointmentEmployee:', COUNT(*)
FROM datAppointmentEmployee ae
	INNER JOIN datAppointment a ON ae.AppointmentGUID = a.AppointmentGUID
	INNER JOIN cfgCenter c ON a.CenterID = c.CenterID
WHERE c.EmployeeDoctorGUID IS NULL


--find appointments with multiple details
SELECT a.CenterID, sc.SalesCodeDescription, ad.*
FROM datAppointment a
	INNER JOIN datAppointmentDetail ad ON a.AppointmentGUID = ad.AppointmentGUID
	INNER JOIN cfgSalesCode sc ON ad.SalesCodeID = sc.SalesCodeID
WHERE a.AppointmentGUID IN (
	SELECT a.AppointmentGUID
	FROM datAppointmentDetail ad
		INNER JOIN datAppointment a ON ad.AppointmentGUID = a.AppointmentGUID
		INNER JOIN cfgCenter c ON a.CenterID = c.CenterID
	WHERE c.EmployeeDoctorGUID IS NULL
	GROUP BY a.AppointmentGUID
	HAVING COUNT(*) > 1
	)
ORDER BY a.centerid, a.AppointmentGUID, ad.SalesCodeID


--find appointments with multiple employees
SELECT a.CenterID, e.EmployeeFullNameCalc, ad.*
FROM datAppointment a
	INNER JOIN datAppointmentEmployee ad ON a.AppointmentGUID = ad.AppointmentGUID
	INNER JOIN datEmployee e ON ad.EmployeeGUID = e.EmployeeGUID
WHERE a.AppointmentGUID IN (
	SELECT a.AppointmentGUID
	FROM datAppointmentEmployee ad
		INNER JOIN datAppointment a ON ad.AppointmentGUID = a.AppointmentGUID
		INNER JOIN cfgCenter c ON a.CenterID = c.CenterID
	WHERE c.EmployeeDoctorGUID IS NULL
	GROUP BY a.AppointmentGUID
	HAVING COUNT(*) > 1
	)
ORDER BY a.centerid, a.AppointmentGUID, e.EmployeeFullNameCalc

--find records where multiple employees have the same initials
SELECT e.CenterID, e.EmployeeInitials, e.EmployeeFullNameCalc
FROM datemployee e
	INNER JOIN (
	SELECT CenterID, EmployeeInitials
	FROM datEmployee
	group by CenterID, EmployeeInitials
	HAVING COUNT(*) > 1
	) sub ON e.CenterID = sub.CenterID AND e.EmployeeInitials = sub.EmployeeInitials
ORDER BY e.CenterID, e.EmployeeInitials

--find duplicate datAppointmentEmployee record
SELECT AppointmentGUID
		,	EmployeeGUID
FROM Infostore..Appointment AD
	INNER JOIN datAppointment A ON AD.AppointmentID = A.AppointmentID_Temp
	LEFT JOIN datEmployee e ON AD.Stylist_Calc = e.EmployeeInitials AND AD.Center = e.CenterID
WHERE A.AppointmentGUID IN (
	SELECT AppointmentGUID
	FROM Infostore..Appointment AD
		INNER JOIN datAppointment A ON AD.AppointmentID = A.AppointmentID_Temp AND AD.Center = a.CenterID
		LEFT JOIN datEmployee e ON AD.Stylist_Calc = e.EmployeeInitials AND AD.Center = e.CenterID
	GROUP BY AppointmentGUID
	HAVING COUNT(*) > 1
)
ORDER BY AppointmentGUID

*/

END
GO
