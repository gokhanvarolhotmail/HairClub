/***********************************************************************

		PROCEDURE:				dbaAppointmentImportbyCenter

		DESTINATION SERVER:		SQL01

		DESTINATION DATABASE: 	HairClubCMS

		RELATED APPLICATION:  	CMS

		AUTHOR: 				Dominic Leiba

		IMPLEMENTOR: 			Paul Madary

		DATE IMPLEMENTED: 		5/26/10

		LAST REVISION DATE: 	11/5/12

		--------------------------------------------------------------------------------------------------------
		NOTES: 	Import Non-Surgery records to database from infostore database
			* 5/26/10 PRM - Created Stored Proc
			* 6/16/10 PRM - Updated script to add an Appointment subject so scheduler doesn't error out on a drag and drop
			* 4/05/12 KRM - Modified script to run by Center
			* 4/11/12 KRM - Fixed Appointment Subject
			* 11/5/12 KRM - Modified Appt date to be 1 year ago
			* 12/13/12 KM - Modified Appt Details to use [SalesCodebyMembership] table
			* 02/21/13 KM - Modified Last Update to use GetUTCDate rather than original Lastupdate
			* 08/19/13 MT - Modified to import Appointment Notes.
			* 08/26/13 KM - Removed deletion of Consultation appointments
			* 08/26/13 MT - Removed deletion of Sales Orders, Tender, Detail and Accums for Consultation Appointments
			* 12/19/13 MT - Modified for the new datAppointment fields (Last Change Date/User)
			* 01/09/14 MLM - Modified the AppointmentEmployee Join to handle Franchises.
			* 1/14/14  MLM - Changed the Import to set CheckInTime and CheckOutTime
			* 03/20/15 MT  - Modified to bring in Check-in/out time from Infostore if available (TFS #4508)
			* 03/20/15 MT  - Modified to go back 2 years for appointments (TFS #4557)
			* 03/28/15 MT  - Added another check for check in/out time to make sure that the appointment is in the past
								and that the Check in/out datetime is greater than the check in minimum date.
			* 04/06/15 MT - Added additional deletes to clean up data prior to conversion. (added deletes to datNotification,
							datCreditCardTransactionLog, datAccountReceivableJoin, datAccountReceivable, datHairSystemOrderTransaction)
			* 04/10/15 MT - Modified to always set the Confirmation of appointments to NULL
			* 05/07/15 MT - Added script to update Certipay numbers prior to importing appointments
			* 5/15/2015 MVT - Added a work around to bring in appointments for Zelidith Baez in 817.  All appointments
					 in Infostore are under Zeledith Ruffino
			* 5/24/2015 MVT - Added a work around to bring in appointments for Barbara Giardino in 747.  All appointments
					 in Infostore are under Barbara Coleman.  Also updated position for Barbara Giardino to Stylist in InfostoreConv.

		--------------------------------------------------------------------------------------------------------

		SAMPLE EXECUTION:

		EXEC dbaAppointmentImportbyCenter 807

		***********************************************************************/

		CREATE PROCEDURE [dbo].[dbaAppointmentImportbyCenter](
			@Center int
		)AS
		BEGIN
			SET NOCOUNT ON


		------------------------------------------------------------
		--UPDATE CERTIPAY NUMBERS
		------------------------------------------------------------
		UPDATE INFOSTORECONV.dbo.Employee SET
			CertipayEmployeeNumber = 805017
		WHERE Center = 805
			AND First_Name like 'Angel'
			AND Last_Name like 'Baker'

		UPDATE INFOSTORECONV.dbo.Employee SET
			CertipayEmployeeNumber = 817022
		WHERE Center = 817
			AND First_Name like 'Flora'
			AND Last_Name like 'Sinoyianis'

		UPDATE INFOSTORECONV.dbo.Employee SET
			CertipayEmployeeNumber = 746030
		WHERE Center = 746
			AND First_Name like 'Caterina'
			AND Last_Name like 'Cruz'

		UPDATE INFOSTORECONV.dbo.Employee SET
			CertipayEmployeeNumber = 746033
		WHERE Center = 746
			AND First_Name like 'RENEE'
			AND Last_Name like 'PAWULA'

		UPDATE INFOSTORECONV.dbo.Employee SET
			CertipayEmployeeNumber = 820009
		WHERE Center IN (817)
			AND First_Name like 'Toya'
			AND Last_Name like 'Davis'



		UPDATE e SET
			First_Name = 'Zelidith',
			Last_Name = 'Baez',
			Full_Name = 'Zelidith Baez',
			EmployeeNameCalc = 'Baez, Zelidith',
			Code = 'ZBU'
		FROM INFOSTORECONV.dbo.Employee e
		WHERE EmployeeID = '817817004'

		UPDATE e SET
			position = 2
		FROM INFOSTORECONV.dbo.Employee e
		WHERE e.Center = 747
			AND e.First_Name like 'Barbara'
			AND e.Last_Name like 'Giardino'

		------------------------------------------------------------
		-- Certipay update end
		------------------------------------------------------------

		declare @apptdate datetime, @checkInOutMin datetime

		set @apptdate = '1/1/2013'  -- DATEADD(Day, -365 , GETDATE())
		set @checkInOutMin = DATEADD(Day, -365 , @apptdate)

		DECLARE @BosleyAppointmentTypeID int

		Select @BosleyAppointmentTypeID = AppointmentTypeId  from lkpAppointmentType Where AppointmentTypeDescriptionShort = 'BosleyAppt'
		print @BosleyAppointmentTypeID


		DELETE FROM [dbo].[datAccumulatorAdjustment]
		WHERE SalesOrderDetailGuid IN (
			SELECT SalesOrderDetailGUID
			FROM datSalesOrderDetail
				WHERE SalesOrderGUID IN (
				SELECT SalesOrderGUID
				FROM datSalesOrder
				WHERE AppointmentGUID IN (
					SELECT AppointmentGUID
					FROM datAppointment a
					WHERE a.CenterID = @Center
					AND (a.[AppointmentTypeID] IS NULL OR a.[AppointmentTypeID] <> @BosleyAppointmentTypeID)
					and a.AppointmentDate >= @apptdate
					AND a.OnContactContactID IS null
				))
			)

		DELETE FROM [dbo].[datAccumulatorAdjustment]
		WHERE SalesOrderTenderGuid IN (
			SELECT SalesOrderTenderGuid
			FROM datSalesOrderTender
			WHERE SalesOrderGUID IN (
				SELECT SalesOrderGUID
				FROM datSalesOrder
				WHERE AppointmentGUID IN (
					SELECT AppointmentGUID
					FROM datAppointment a
					WHERE a.CenterID = @Center
						AND (a.[AppointmentTypeID] IS NULL OR a.[AppointmentTypeID] <> @BosleyAppointmentTypeID)
						and a.AppointmentDate >= @apptdate
						AND a.OnContactContactID IS null
				))
			)


		DELETE FROM datAppointmentPhoto
		WHERE AppointmentGUID IN (
			SELECT AppointmentGUID
			FROM datAppointment a
			WHERE a.CenterID = @Center
				AND (a.[AppointmentTypeID] IS NULL OR a.[AppointmentTypeID] <> @BosleyAppointmentTypeID)
				and a.AppointmentDate >= @apptdate
				AND a.OnContactContactID IS null
			)

		DELETE FROM datNotification
		WHERE AppointmentGUID IN (
			SELECT AppointmentGUID
			FROM datAppointment a
			WHERE a.CenterID = @Center
				AND (a.[AppointmentTypeID] IS NULL OR a.[AppointmentTypeID] <> @BosleyAppointmentTypeID)
				and a.AppointmentDate >= @apptdate
				AND a.OnContactContactID IS null
			)

		DELETE FROM datCreditCardTransactionLog
		WHERE SalesOrderGUID IN (
			SELECT SalesOrderGUID
			FROM datSalesOrder
			WHERE AppointmentGUID IN (
				SELECT AppointmentGUID
				FROM datAppointment a
				WHERE a.CenterID = @Center
					AND (a.[AppointmentTypeID] IS NULL OR a.[AppointmentTypeID] <> @BosleyAppointmentTypeID)
					and a.AppointmentDate >= @apptdate
					AND a.OnContactContactID IS null
			))



		DELETE FROM datAccountReceivableJoin
		WHERE AccountReceivableJoinID IN (
			SELECT arj.AccountReceivableJoinID
			FROM datSalesOrder so
				INNER JOIN datAccountReceivable ar ON so.SalesOrderGUID = ar.SalesOrderGUID
				INNER JOIN datAccountReceivableJoin arj ON arj.ARChargeID = ar.AccountReceivableID OR arj.ARPaymentID = ar.AccountReceivableID
			WHERE so.AppointmentGUID IN (
				SELECT AppointmentGUID
				FROM datAppointment a
				WHERE a.CenterID = @Center
					AND (a.[AppointmentTypeID] IS NULL OR a.[AppointmentTypeID] <> @BosleyAppointmentTypeID)
					and a.AppointmentDate >= @apptdate
					AND a.OnContactContactID IS null
			))


		DELETE FROM datAccountReceivable
		WHERE AccountReceivableID IN (
			SELECT ar.AccountReceivableID
			FROM datSalesOrder so
				INNER JOIN datAccountReceivable ar ON so.SalesOrderGUID = ar.SalesOrderGUID
			WHERE so.AppointmentGUID IN (
				SELECT AppointmentGUID
				FROM datAppointment a
				WHERE a.CenterID = @Center
					AND (a.[AppointmentTypeID] IS NULL OR a.[AppointmentTypeID] <> @BosleyAppointmentTypeID)
					and a.AppointmentDate >= @apptdate
					AND a.OnContactContactID IS null
			))

		DELETE FROM datHairSystemOrderTransaction
		WHERE SalesOrderDetailGUID IN (
			SELECT sod.SalesOrderDetailGUID
			FROM datSalesOrderDetail sod
				INNER JOIN datSalesOrder so ON so.SalesOrderGUID = sod.SalesOrderGUID
			WHERE so.AppointmentGUID IN (
				SELECT AppointmentGUID
				FROM datAppointment a
				WHERE a.CenterID = @Center
					AND (a.[AppointmentTypeID] IS NULL OR a.[AppointmentTypeID] <> @BosleyAppointmentTypeID)
					and a.AppointmentDate >= @apptdate
					AND a.OnContactContactID IS null
			))


		DELETE FROM datSalesOrderTender
		WHERE SalesOrderGUID IN (
			SELECT SalesOrderGUID
			FROM datSalesOrder
			WHERE AppointmentGUID IN (
				SELECT AppointmentGUID
				FROM datAppointment a
				WHERE a.CenterID = @Center
					AND (a.[AppointmentTypeID] IS NULL OR a.[AppointmentTypeID] <> @BosleyAppointmentTypeID)
					and a.AppointmentDate >= @apptdate
					AND a.OnContactContactID IS null
			))

		DELETE FROM datSalesOrderDetail
		WHERE SalesOrderGUID IN (
			SELECT SalesOrderGUID
			FROM datSalesOrder
			WHERE AppointmentGUID IN (
				SELECT AppointmentGUID
				FROM datAppointment a
				WHERE a.CenterID = @Center
					AND (a.[AppointmentTypeID] IS NULL OR a.[AppointmentTypeID] <> @BosleyAppointmentTypeID)
					and a.AppointmentDate >= @apptdate
					AND a.OnContactContactID IS null
			))

		DELETE FROM datSalesOrder
		WHERE AppointmentGUID IN (
			SELECT AppointmentGUID
			FROM datAppointment a
			WHERE a.CenterID = @Center
				AND (a.[AppointmentTypeID] IS NULL OR a.[AppointmentTypeID] <> @BosleyAppointmentTypeID)
				and a.AppointmentDate >= @apptdate
				AND a.OnContactContactID IS null
			)

		DELETE FROM datAppointmentEmployee
		WHERE AppointmentGUID IN (
			SELECT AppointmentGUID
			FROM datAppointment a
			WHERE a.CenterID = @Center
				AND (a.[AppointmentTypeID] IS NULL OR a.[AppointmentTypeID] <> @BosleyAppointmentTypeID)
				and a.AppointmentDate >= @apptdate
				AND a.OnContactContactID IS null
			)

		DELETE FROM datAppointmentDetail
		WHERE AppointmentGUID IN (
			SELECT AppointmentGUID
			FROM datAppointment a
			WHERE a.CenterID = @Center
				AND (a.[AppointmentTypeID] IS NULL OR a.[AppointmentTypeID] <> @BosleyAppointmentTypeID)
				and a.AppointmentDate >= @apptdate
				AND a.OnContactContactID IS null
			)

		DELETE FROM datNotesClient
		WHERE AppointmentGUID IN (
			SELECT AppointmentGUID
			FROM datAppointment a
			WHERE a.CenterID = @Center
				AND (a.[AppointmentTypeID] IS NULL OR a.[AppointmentTypeID] <> @BosleyAppointmentTypeID)
				and a.AppointmentDate >= @apptdate
				AND a.OnContactContactID IS null
			)

		DELETE FROM datAppointment
		WHERE AppointmentGUID IN (
			SELECT a.AppointmentGUID
			FROM datAppointment a
				LEFT OUTER JOIN datAppointment parent on a.AppointmentGUID = parent.ParentAppointmentGUID
			WHERE a.CenterID = @Center
				AND (a.[AppointmentTypeID] IS NULL OR a.[AppointmentTypeID] <> @BosleyAppointmentTypeID)
				and a.AppointmentDate >= @apptdate
				AnD parent.AppointmentGUID IS NULL
				AND a.OnContactContactID IS null
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
			,	LastUpdate
			,	LastUpdateUser
		FROM #Appointments


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
	WHERE a.AppointmentDate >= @Today
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
