/* CreateDate: 08/15/2017 15:16:12.013 , ModifyDate: 10/25/2018 10:25:30.307 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnCreateActivitiesForMissedAppointments

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		08/08/2017

LAST REVISION DATE: 	08/08/2017

--------------------------------------------------------------------------------------------------------
NOTES:  Creates an activity for each missed appointment for the date passed in

		* 08/08/2017	SAL	Created
		* 08/25/2017	SAL	Temporarily create these activities for only the following centers:
							203,206,211,229,256,275,281.  This will be removed once training is complete
							so that these activities are created for all centers.
							Removed EmployeePayrollID check when getting AssignedTo Employee.
		* 09/14/2017	SAL Updated to exclude Assigning To Employees with FirstName of 'Test'
		* 10/05/2017	SAL	Updated with new assignment logic: CRM for Center, Center Manager for Center,
							1st Center Manager associated with Center.
		* 10/30/2017	SAL Updated to include a check for SalesForceTaskID is null on select of missed
							Appointments.
		* 10/31/2017	SAL Updated to only create activities for missed Appointments in Medium or Low priority.
		* 11/21/2017	SAL	Updated to only create activities for clients whose DoNotContact and DoNotCall
							are False or NULL (TFS#9945)
		* 12/07/2017	SAL Updated to remove Center 275 (TFS#9994)
		* 01/11/2018	SAL Updated to create activities for all Corporate centers (TFS#10094)
		* 01/12/2018	SAL Updated to exclude Center 206 from activity creation (TFS#10119)
		* 03/12/2018	SAL Updated to include Center 206 for activity creation (TFS#10122)
		* 03/21/2018	SAL Updated to exclude Center 235 from activity creation (TFS#10393)
		* 04/30/2018	SAL	Updated to exclude Centers 235, 269, 285, 206, and 202 from activity creation (TFS#10700)
		* 05/04/2018	SAL	Updated to include excluding Centers 241,242,245,229,230,249,296,276,277,281,292,259,222
							,282,201,220,252,205,227 from activity creation (TFS#10735)
		* 08/01/2018	SAL Updated to assign EXT Clients to the EXT Coordinator first if there is one (TFS#11186)
		* 08/06/2018	SAL Updated to initialize EmployeeGUID on each loop (TFS#11203)
		* 10/11/2018	SAL	Updated to account for Hair Fit appointments (TFS#11450)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnCreateActivitiesForMissedAppointments '08/08/2018'

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnCreateActivitiesForMissedAppointments]
	@AppointmentDate date
AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRY

	DECLARE @CenterID int
	DECLARE @ClientGUID uniqueidentifier
	DECLARE @ClientMembershipBusinessSegmentID int
	DECLARE @ActivitySubCategoryID int
	DECLARE @ActivityActionID int
	DECLARE @DueDate datetime
	DECLARE @ActivityPriorityID int
	DECLARE @ActivityNote varchar(max)
	DECLARE @ActivityStatusID int
	DECLARE @EmployeeGUID uniqueidentifier
	DECLARE @User nvarchar(25) = 'Nightly_MissedAppt'
	DECLARE @CRMEmployeePositionDescriptionShort nvarchar(10) = 'CRM'
	DECLARE @CenterManagerEmployeePositionDescriptionShort nvarchar(10) = 'Manager'
	DECLARE @EXTCoordinatorEmployeePositionDescriptionShort nvarchar(10) = 'EXTCoord'
	DECLARE @TrichoViewAppointmentTypeID int
	DECLARE @HairFitAppointmentTypeID int
	DECLARE @EXTBusinessSegmentID int

	SELECT @ActivitySubCategoryID = ActivitySubCategoryID FROM lkpActivitySubCategory WHERE ActivitySubCategoryDescriptionShort = 'SCHED'
	SELECT @ActivityActionID = ActivityActionID FROM lkpActivityAction WHERE ActivityActionDescriptionShort = 'FOLLOWUP'
	SELECT @DueDate = DATEADD(DAY, 1, @AppointmentDate)
	SELECT @ActivityPriorityID = ActivityPriorityID FROM lkpActivityPriority WHERE ActivityPriorityDescriptionShort = 'MED'
	SELECT @ActivityNote = CONCAT('Missed Appointment Date: ', CONVERT(VARCHAR(10), @AppointmentDate, 101))
	SELECT @ActivityStatusID = ActivityStatusID FROM lkpActivityStatus WHERE ActivityStatusDescriptionShort = 'OPEN'
	SELECT @TrichoViewAppointmentTypeID = AppointmentTypeID FROM lkpAppointmentType WHERE AppointmentTypeDescriptionShort = 'TrichoView'
	SELECT @HairFitAppointmentTypeID = AppointmentTypeID FROM lkpAppointmentType WHERE AppointmentTypeDescriptionShort = 'HairFit'
	SELECT @EXTBusinessSegmentID = BusinessSegmentID FROM lkpBusinessSegment WHERE BusinessSegmentDescriptionShort = 'EXT'

	DECLARE CUR CURSOR FAST_FORWARD FOR

	--Get Missed Appointments
	SELECT a.ClientGUID, a.CenterID, m.BusinessSegmentID
	FROM datAppointment a
		inner join cfgCenter ctr on a.CenterID = ctr.CenterID
		inner join datClient c on a.ClientGUID = c.ClientGUID
		left join lkpAppointmentPriorityColor apc on a.AppointmentPriorityColorID = apc.AppointmentPriorityColorID
		inner join datClientMembership cm on a.ClientMembershipGUID = cm.ClientMembershipGUID
		inner join cfgMembership m on cm.MembershipID = m.MembershipID
	WHERE a.AppointmentDate = @AppointmentDate
		and a.CheckInTime is null
		and a.CheckOutTime is null
		and a.IsDeletedFlag = 0
		and a.ClientGUID is not null
		and a.CenterID is not null
		and ctr.CenterTypeID = 1 --Corporate Centers Only
		and ctr.CenterNumber not in (235,269,285,206,202,241,242,245,229,230,249,296,276,277,281,292,259,222,282,201,220,252,205,227) --Exclude Centers
		and (a.AppointmentTypeID is null
			or a.AppointmentTypeID = @HairFitAppointmentTypeID
			or (a.AppointmentTypeID = @TrichoViewAppointmentTypeID
				and a.OnContactActivityID is null
				and a.SalesForceTaskID is null)) --Excludes Sales Consultations and other Appointment Types
		and apc.AppointmentPriorityColorDescriptionShort in ('High','Medium')
		and (c.DoNotCallFlag is null or c.DoNotCallFlag = 0) --Client can be called
		and (c.DoNotContactFlag is null or c.DoNotContactFlag = 0) --Client can be contacted

	OPEN CUR

	FETCH NEXT FROM CUR INTO @ClientGUID, @CenterID, @ClientMembershipBusinessSegmentID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Initialize EmployeeGUID
		SET @EmployeeGUID = NULL

		--If client's membership is in the EXT Business Segment, get the first EXT Coordinator associated with the Center
		--If client's membership is not in the EXT Business Segment or no EXT Coordinator for the Center, then get the CRM for the Center.
		--If no CRM for the Center, then get the Center Manager for the Center.
		--If no Center Manager for the Center, assign to the first Center Manager associated with the Center.
		If @ClientMembershipBusinessSegmentID = @EXTBusinessSegmentID
		BEGIN
			SELECT @EmployeeGUID = (SELECT TOP 1 e.EmployeeGUID
									FROM datEmployee e
										INNER JOIN cfgEmployeePositionJoin epj on e.EmployeeGUID = epj.EmployeeGUID
										INNER JOIN lkpEmployeePosition ep on epj.EmployeePositionID =  ep.EmployeePositionID
										INNER JOIN datEmployeeCenter ec on e.EmployeeGUID = ec.EmployeeGUID
									WHERE ep.EmployeePositionDescriptionShort = @EXTCoordinatorEmployeePositionDescriptionShort
										and ec.CenterID = @CenterID
										and e.IsActiveFlag = 1
										and e.FirstName <> 'Test'
										and epj.IsActiveFlag = 1
										and ec.IsActiveFlag = 1
									ORDER BY e.EmployeeFullNameCalc)
		END

		If @EmployeeGUID is NULL
		BEGIN
			SELECT @EmployeeGUID = (SELECT TOP 1 e.EmployeeGUID
									FROM datEmployee e
										INNER JOIN cfgEmployeePositionJoin epj on e.EmployeeGUID = epj.EmployeeGUID
										INNER JOIN lkpEmployeePosition ep on epj.EmployeePositionID =  ep.EmployeePositionID
										INNER JOIN datEmployeeCenter ec on (e.EmployeeGUID = ec.EmployeeGUID and e.CenterID = ec.CenterID)
									WHERE ep.EmployeePositionDescriptionShort = @CRMEmployeePositionDescriptionShort
										and ec.CenterID = @CenterID
										and e.IsActiveFlag = 1
										and e.FirstName <> 'Test'
										and epj.IsActiveFlag = 1
										and ec.IsActiveFlag = 1
									ORDER BY e.EmployeeFullNameCalc)
		END

		If @EmployeeGUID is NULL
		BEGIN
			SELECT @EmployeeGUID = (SELECT TOP 1 e.EmployeeGUID
									FROM datEmployee e
										INNER JOIN cfgEmployeePositionJoin epj on e.EmployeeGUID = epj.EmployeeGUID
										INNER JOIN lkpEmployeePosition ep on epj.EmployeePositionID =  ep.EmployeePositionID
										INNER JOIN datEmployeeCenter ec on (e.EmployeeGUID = ec.EmployeeGUID and e.CenterID = ec.CenterID)
									WHERE ep.EmployeePositionDescriptionShort = @CenterManagerEmployeePositionDescriptionShort
										and ec.CenterID = @CenterID
										and e.IsActiveFlag = 1
										and e.FirstName <> 'Test'
										and epj.IsActiveFlag = 1
										and ec.IsActiveFlag = 1
									ORDER BY e.EmployeeFullNameCalc)
		END

		If @EmployeeGUID is NULL
		BEGIN
			SELECT @EmployeeGUID = (SELECT TOP 1 e.EmployeeGUID
									FROM datEmployee e
										INNER JOIN cfgEmployeePositionJoin epj on e.EmployeeGUID = epj.EmployeeGUID
										INNER JOIN lkpEmployeePosition ep on epj.EmployeePositionID =  ep.EmployeePositionID
										INNER JOIN datEmployeeCenter ec on e.EmployeeGUID = ec.EmployeeGUID
									WHERE ep.EmployeePositionDescriptionShort = @CenterManagerEmployeePositionDescriptionShort
										and ec.CenterID = @CenterID
										and e.IsActiveFlag = 1
										and e.FirstName <> 'Test'
										and epj.IsActiveFlag = 1
										and ec.IsActiveFlag = 1
									ORDER BY e.EmployeeFullNameCalc)
		END

		If	@ClientGUID is not NULL
			and @ActivitySubCategoryID is not NULL
			and @ActivityActionID is not NULL
			and @ActivityActionID is not NULL
			and @ActivityPriorityID is not null
			and @EmployeeGUID is not null
			and @User is not null
			and @ActivityStatusID is not null
		BEGIN
				--Create Activity
				EXEC mtnActivityAdd null, @ClientGUID, @ActivitySubCategoryID, @ActivityActionID, null, @DueDate, @ActivityPriorityID, @ActivityNote, @EmployeeGUID, @EmployeeGUID, null, null, @User, @ActivityStatusID
		END

		FETCH NEXT FROM CUR INTO @ClientGUID, @CenterID, @ClientMembershipBusinessSegmentID
	END

	CLOSE CUR
	DEALLOCATE CUR

  END TRY
  BEGIN CATCH

  	CLOSE CUR
	DEALLOCATE CUR

	DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE();

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
  END CATCH
END

SET ANSI_NULLS ON
GO
