/* CreateDate: 04/28/2015 15:37:44.550 , ModifyDate: 05/26/2015 14:04:51.330 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				dbaAppointmentImportbyCenterAndStylist

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		4/28/2015

LAST REVISION DATE: 	4/28/2015

--------------------------------------------------------------------------------------------------------
NOTES: 	Import Non-Surgery records to database from infostore database for a specific Stylist
	* 4/28/2015 MVT - Created Stored Proc
	* 5/15/2015 MVT - Added a work around to bring in appointments for Zelidith Baez in 817.  All appointments
					 in Infostore are under Zeledith Ruffino
	* 5/24/2015 MVT - Added a work around to bring in appointments for Barbara Giardino in 747.  All appointments
					 in Infostore are under Barbara Coleman. Also updated position for Barbara Giardino to Stylist in InfostoreConv.

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC dbaAppointmentImportbyCenterAndStylist 747, '7C374544-AC0C-41E8-90E8-BFFAD3CCEB11'

***********************************************************************/

CREATE PROCEDURE [dbo].[dbaAppointmentImportbyCenterAndStylist](
	@Center int,
	@EmployeeGUID uniqueidentifier
)AS
BEGIN
	SET NOCOUNT ON


		UPDATE e SET
			position = 2
		FROM INFOSTORECONV.dbo.Employee e
		WHERE e.Center = 747
			AND e.First_Name like 'Barbara'
			AND e.Last_Name like 'Giardino'


		declare @apptdate datetime, @checkInOutMin datetime

		set @apptdate = '1/1/2013'  -- DATEADD(Day, -365 , GETDATE())
		set @checkInOutMin = DATEADD(Day, -365 , @apptdate)


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
			, IsDeletedFlag BIT
			, AppointmentNotes VARCHAR(2000))

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
			, IsDeletedFlag
			, AppointmentNotes)
			SELECT a.AppointmentID As 'AppointmentID_Temp'
				,	CASE WHEN c.ClientGUID IS NOT NULL THEN c.ClientGUID ELSE NULL END As 'ClientGUID'
				,	CASE WHEN cm.ClientMembershipGUID IS NOT NULL THEN
						cm.ClientMembershipGUID ELSE NULL END As 'ClientMembershipGUID'
				,	NULL As 'ParentAppointmentGUID'
				,	Center As 'CenterID'
				,	ISNULL(c.CenterID,Center) As 'ClientHomeCenterID'
				,	NULL As 'ResourceID'
				,	NULL As 'ConfirmationTypeID' -- CASE WHEN ConfirmationType = '1' THEN ConfirmationType END As 'ConfirmationTypeID'
				,	NULL As 'AppointmentTypeID'
				,	[date] As AppointmentDate
				,	CONVERT(VARCHAR,StartTime,8) 'StartTime'
				,	CONVERT(VARCHAR,DATEADD(mi,TotalDuration,StartTime),8) As 'EndTime'
				,	CASE	WHEN a.[Date] < CAST(CONVERT(nvarchar(10),GETUTCDATE(),101) as DateTime)
										AND a.CheckInTime IS NOT NULL AND a.CheckInTime > @checkInOutMin THEN a.CheckInTime
							WHEN a.[Date] < CAST(CONVERT(nvarchar(10),GETUTCDATE(),101) as DateTime) THEN convert(dateTime, a.StartTime) + a.[Date]
								ELSE NULL END 'CheckinTime'
				,	CASE	WHEN a.[Date] < CAST(CONVERT(nvarchar(10),GETUTCDATE(),101) as DateTime)
										AND a.CheckOutTime IS NOT NULL AND a.CheckOutTime > @checkInOutMin THEN a.CheckOutTime
							WHEN a.[Date] < CAST(CONVERT(nvarchar(10),GETUTCDATE(),101) as DateTime) THEN convert(dateTime, a.StartTime) + a.[Date]
								ELSE NULL END 'CheckOutTime'
				,	#AppointmentSubject.ApptSubject AS 'AppointmentSubject'
				,	0 'CanPrintCommentFlag'
				,	[date] + CONVERT(VARCHAR,StartTime,8) As 'StartDateTimeCalc'
				,	[date] + CONVERT(VARCHAR,DATEADD(mi,TotalDuration,StartTime),8) As 'EndDateTimeCalc'
				,	TotalDuration As 'AppointmentDurationCalc'
				,	CMSCreateDate As 'CreateDate'
				,	CMSCreateID As 'CreateUser'
				,	GETUTCDATE() As 'LastUpdate'
				,	'NonSurgeryImport' As 'LastUpdateUser'
				,	0 As 'IsDeletedFlag'
				,	LTRIM(RTRIM(a.Comments))
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
			,	GETUTCDATE() As 'LastUpdate'
			,	'NonSurgeryImport' As 'LastUpdateUser'
		FROM [HCSQL2\SQL2005].Infostore.dbo.AppointmentDetails AD
			INNER JOIN #Appointments A ON AD.AppointmentID = A.AppointmentID_Temp AND AD.Center = A.CenterID
			INNER JOIN [HCSQL2\SQL2005].BOSOperations.[dbo].[SalesCodebyMembership] C
				ON AD.SalesCode = C.Code


		INSERT INTO #AppointmentEmployees(
			AppointmentGUID
			, EmployeeGUID
			, CreateDate
			, CreateUser
			, LastUpdate
			, LastUpdateUser)
			SELECT AppointmentGUID
				,	ISNULL(e.EmployeeGUID,hce.EmployeeGUID)
				,	GETUTCDATE() As 'CreateDate'
				,	'NonSurgeryImport' As 'CreateUser'
				,	GETUTCDATE() As 'LastUpdate'
				,	'NonSurgeryImport' As 'LastUpdateUser'
		FROM [HCSQL2\SQL2005].Infostore.dbo.Appointment AD
			INNER JOIN #Appointments A ON AD.AppointmentID = A.AppointmentID_Temp AND AD.Center = a.CenterID
			INNER JOIN Infostoreconv..Employee hce
				ON (CASE WHEN AD.Center = 817 AND AD.Stylist_Calc =  'ZRU' THEN 'ZBU'
						 WHEN AD.Center = 747 AND AD.Stylist_Calc =  'BCO' THEN 'BGI' ELSE AD.Stylist_Calc END) = hce.Code AND AD.Center = hce.Center AND hce.Position IN (1,2)
			inner join datEmployee e on hce.CertipayEmployeeNumber = e.EmployeePayrollID
			inner join datEmployeeCenter ec on e.EmployeeGUID  = ec.EmployeeGUID and hce.Center = ec.CenterID


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
			, IsDeletedFlag
			, LastChangeDate
			, LastChangeUser)
		SELECT 	a.AppointmentGUID
			,	a.AppointmentID_Temp
			,	a.ClientGUID
			,	a.ClientMembershipGUID
			,	a.ParentAppointmentGUID
			,	a.CenterID
			,	a.ClientHomeCenterID
			,	a.ResourceID
			,	a.ConfirmationTypeID
			,	a.AppointmentTypeID
			,	a.AppointmentDate
			,	a.StartTime
			,	a.EndTime
			,	a.CheckInTime
			,	a.CheckOutTime
			,	a.AppointmentSubject
			,	a.CanPrintCommentFlag
			,	a.CreateDate
			,	a.CreateUser
			,	a.LastUpdate
			,	a.LastUpdateUser
			,	a.IsDeletedFlag
			,	a.LastUpdate
			,	a.LastUpdateUser
		FROM #Appointments a
			INNER JOIN #AppointmentEmployees ae ON a.AppointmentGUID = ae.AppointmentGUID
		WHERE ae.EmployeeGUID = @EmployeeGUID


	DECLARE @AppointmentNotesTypeID int, @Today date
	SELECT @AppointmentNotesTypeID = NoteTypeID
	FROM lkpNoteType
	WHERE NoteTypeDescriptionShort = 'Appt'

	SET @Today = DATEADD(day,-1, GETDATE())

	INSERT INTO [dbo].[datNotesClient]
           ([NotesClientGUID]
           ,[ClientGUID]
           ,[EmployeeGUID]
           ,[AppointmentGUID]
           ,[SalesOrderGUID]
           ,[ClientMembershipGUID]
           ,[NoteTypeID]
           ,[NotesClientDate]
           ,[NotesClient]
           ,[CreateDate]
           ,[CreateUser]
           ,[LastUpdate]
           ,[LastUpdateUser]
           ,[HairSystemOrderGUID])
     SELECT NEWID()
           ,a.ClientGUID
           ,NULL
           ,a.AppointmentGUID
           ,NULL
           ,a.ClientMembershipGUID
           ,@AppointmentNotesTypeID
           ,a.CreateDate
           ,a.AppointmentNotes
           ,a.CreateDate
           ,a.CreateUser
           ,a.LastUpdate
		   ,a.LastUpdateUser
		   ,NULL
	FROM #Appointments a
			INNER JOIN #AppointmentEmployees ae ON a.AppointmentGUID = ae.AppointmentGUID
	WHERE ae.EmployeeGUID = @EmployeeGUID
		AND a.AppointmentDate >= @Today
		AND a.AppointmentNotes IS NOT NULL
		AND a.AppointmentNotes <> ''


		INSERT INTO datAppointmentDetail(
				AppointmentDetailGUID
			,	AppointmentGUID
			,	SalesCodeID
			,	AppointmentDetailDuration
			,	CreateDate
			,	CreateUser
			,	LastUpdate
			,	LastUpdateUser)
		SELECT 	ad.AppointmentDetailGUID
			,	ad.AppointmentGUID
			,	ad.SalesCodeID
			,	ad.AppointmentDetailDuration
			,	ad.CreateDate
			,	ad.CreateUser
			,	ad.LastUpdate
			,	ad.LastUpdateUser
		FROM #AppointmentDetails ad
			INNER JOIN #AppointmentEmployees ae ON ad.AppointmentGUID = ae.AppointmentGUID
		WHERE ae.EmployeeGUID = @EmployeeGUID

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
		WHERE EmployeeGUID = @EmployeeGUID

		--
		-- Update Appointments for EXTMEM clients
		--
		UPDATE AD
		SET SalescodeID = 672
		--select *
		FROM datappointment a
			inner join datappointmentdetail ad
				ON a.appointmentguid = ad.appointmentguid
			inner join datclientmembership mem
				ON a.ClientMembershipGUID = mem.ClientMembershipGUID
		WHERE mem.membershipid in (40,41) and ad.salescodeid = 393
			and a.centerid = @Center


		DROP TABLE #Appointments
		DROP TABLE #AppointmentDetails
		DROP TABLE #AppointmentEmployees

END
GO
