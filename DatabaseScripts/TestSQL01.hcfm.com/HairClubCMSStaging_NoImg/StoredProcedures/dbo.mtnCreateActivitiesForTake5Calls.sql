/* CreateDate: 10/13/2017 14:10:04.453 , ModifyDate: 10/25/2018 10:25:30.363 */
GO
/*******************************************************************************************************
PROCEDURE:				mtnCreateActivitiesForTake5Calls
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/13/2017
DESCRIPTION:			10/13/2017
--------------------------------------------------------------------------------------------------------
NOTES:

		* 10/30/2017	SAL Updated to include a check for SalesForceTaskID on Get Appointments.
		* 10/31/2017	SAL Updated to create DueDate for Activity as Date only with NO time.
		* 11/01/2017	SAL	Updated to only create activities for 7 test centers (203,206,211,229,256,275,281)
		* 11/05/2017	SAL	Updated with new assignment logic: CRM for Center, Center Manager for Center,
								1st Center Manager associated with Center.
		* 11/16/2017	SAL	Updated to remove center 281 (TFS#9925)
		* 11/17/2017	SAL Updated to not create an activity if a TAKE5CALL activity has been created for the
								client in the last 12 months (TFS#9928)
		* 11/21/2017	SAL Updated to account for NULL DoNotCall and DoNotContact flag on Client (TFS#9948)
		* 12/07/2017	SAL Updated to remove Center 275 (TFS#9994)
		* 01/11/2018	SAL Updated to create activities for all Corporate centers (TFS#10094)
		* 01/12/2018	SAL Updated to exclude Center 206 from activity creation (TFS#10119)
		* 03/12/2018	SAL Updated to include Center 206 for activity creation (TFS#10122)
		* 03/21/2018	SAL Updated to exclude Center 235 from activity creation (TFS#10393)
		* 04/30/2018	SAL	Updated to exclude Centers 235, 269, 285, 206, and 202 from activity creation (TFS#10700)
		* 05/04/2018	SAL	Updated to include excluding Centers 241,242,245,229,230,249,296,276,277,281,292,259,222
							,282,201,220,252,205,227 from activity creation (TFS#10735)
		* 08/06/2018	SAL Updated to initialize EmployeeGUID on each loop (TFS#11203)
		* 10/11/2018	SAL	Updated to account for Hair Fit appointments (TFS#11450)
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC mtnCreateActivitiesForTake5Calls
*********************************************************************************************************/
CREATE PROCEDURE [dbo].[mtnCreateActivitiesForTake5Calls]
AS
BEGIN

SET NOCOUNT ON;

BEGIN TRY

DECLARE @Date DATE
DECLARE @WeekDay NVARCHAR(50)
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME

DECLARE @CenterID INT
DECLARE @ClientGUID UNIQUEIDENTIFIER
DECLARE @ActivityNote VARCHAR(MAX)
DECLARE @ActivitySubCategoryID INT
DECLARE @ActivityActionID INT
DECLARE @DueDate DATETIME
DECLARE @ActivityPriorityID INT
DECLARE @ActivityStatusID INT
DECLARE @TrichoViewAppointmentTypeID INT
DECLARE @HairFitAppointmentTypeID INT
DECLARE @EmployeeGUID UNIQUEIDENTIFIER
DECLARE @CRMEmployeePositionDescriptionShort NVARCHAR(10) = 'CRM'
DECLARE @CenterManagerEmployeePositionDescriptionShort NVARCHAR(10) = 'Manager'
DECLARE @User NVARCHAR(25) = 'Nightly_Take5Call'

SELECT @ActivitySubCategoryID = ActivitySubCategoryID FROM lkpActivitySubCategory WHERE ActivitySubCategoryDescriptionShort = 'SCHED'
SELECT @ActivityActionID = ActivityActionID FROM lkpActivityAction WHERE ActivityActionDescriptionShort = 'TAKE5CALL'
SELECT @DueDate = CONVERT(DATE, GETDATE())
SELECT @ActivityPriorityID = ActivityPriorityID FROM lkpActivityPriority WHERE ActivityPriorityDescriptionShort = 'MED'
SELECT @ActivityStatusID = ActivityStatusID FROM lkpActivityStatus WHERE ActivityStatusDescriptionShort = 'OPEN'
SELECT @TrichoViewAppointmentTypeID = AppointmentTypeID FROM lkpAppointmentType WHERE AppointmentTypeDescriptionShort = 'TrichoView'
SELECT @HairFitAppointmentTypeID = AppointmentTypeID FROM lkpAppointmentType WHERE AppointmentTypeDescriptionShort = 'HairFit'

SET @Date = GETDATE()
SET @WeekDay = DATENAME(WEEKDAY, @Date)


IF ( @WeekDay = 'Tuesday' )
   BEGIN
		SET @StartDate = DATEADD(dd, -3, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME)) --Saturday
		SET @EndDate = DATEADD(dd, -3, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME)) --Saturday
   END
ELSE
   BEGIN
		SET @StartDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME)) --Yesterday
		SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME)) --Yesterday
   END


-- Get Appointments
SELECT	CAST(da.AppointmentGUID AS NVARCHAR(50)) AS 'AppointmentGUID'
,       da.CenterID
,		clt.ClientGUID
,       clt.ClientFullNameAltCalc AS 'ClientFullName'
,       CONVERT(VARCHAR(11), CAST(da.AppointmentDate AS DATE), 101) AS 'AppointmentDate'
,       CONVERT(VARCHAR(15), CAST(da.StartTime AS TIME), 100) AS 'AppointmentTime'
,       de.FirstName AS 'StylistFirstName'
,       de.LastName AS 'StylistLastName'
INTO    #Appointment
FROM    datAppointment da WITH ( NOLOCK )
        INNER JOIN cfgCenter ctr WITH ( NOLOCK )
            ON ctr.CenterID = da.CenterID
        INNER JOIN datClient clt WITH ( NOLOCK )
            ON clt.ClientGUID = da.ClientGUID
        INNER JOIN datClientMembership dcm WITH ( NOLOCK )
            ON dcm.ClientMembershipGUID = da.ClientMembershipGUID
        INNER JOIN cfgMembership m WITH ( NOLOCK )
            ON m.MembershipID = dcm.MembershipID
        INNER JOIN datAppointmentEmployee ae WITH ( NOLOCK )
            ON ae.AppointmentGUID = da.AppointmentGUID
        INNER JOIN datEmployee de WITH ( NOLOCK )
            ON de.EmployeeGUID = ae.EmployeeGUID
		LEFT OUTER JOIN datActivity a WITH ( NOLOCK )
			ON a.ClientGUID = clt.ClientGUID
				AND a.ActivityActionID = @ActivityActionID
				AND DATEDIFF(MONTH, a.CreateDate, GETDATE()) <= 12
WHERE   ctr.CenterTypeID = 1 --Corporate Centers Only
		AND ctr.CenterNumber not in (235,269,285,206,202,241,242,245,229,230,249,296,276,277,281,292,259,222,282,201,220,252,205,227) --Exclude Centers
        AND da.AppointmentDate BETWEEN @StartDate AND @EndDate
        AND da.CheckinTime IS NOT NULL --Client was checked in
        AND da.CheckoutTime IS NOT NULL --Client was checked out
        AND (da.AppointmentTypeID IS NULL
			  OR da.AppointmentTypeID = @HairFitAppointmentTypeID
              OR (da.AppointmentTypeID = @TrichoViewAppointmentTypeID
                   AND da.OnContactActivityID IS NULL
				   AND da.SalesForceTaskID IS NULL)) --Excludes Sales Consultations and other Appointment Types
        AND m.RevenueGroupID = 2 --Recurring Memberships
        AND da.IsDeletedFlag = 0 --Appointment is valid
        AND (clt.DoNotCallFlag is null or clt.DoNotCallFlag = 0) --Client can be called
        AND (clt.DoNotContactFlag is null or clt.DoNotContactFlag = 0) --Client can be contacted
		AND a.ActivityID IS NULL --No cONEct! Take 5 activities created for this client in the last 12 months
ORDER BY NEWID()


SELECT  ROW_NUMBER() OVER ( PARTITION BY a.AppointmentGUID ORDER BY dep.SalesCodeDepartmentID, sc.CreateDate ) AS 'RowID'
,		a.AppointmentGUID
,		sc.SalesCodeDescriptionShort AS 'SalesCode'
,		sc.SalesCodeDescription
INTO	#AppointmentService
FROM    datAppointmentDetail ad WITH ( NOLOCK )
		INNER JOIN #Appointment a
			ON a.AppointmentGUID = ad.AppointmentGUID
		INNER JOIN cfgSalesCode sc WITH ( NOLOCK )
			ON sc.SalesCodeID = ad.SalesCodeID
		INNER JOIN lkpSalesCodeDepartment dep WITH ( NOLOCK )
			ON dep.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
		INNER JOIN lkpSalesCodeDivision div WITH ( NOLOCK )
			ON div.SalesCodeDivisionID = dep.SalesCodeDivisionID
WHERE   div.SalesCodeDivisionID = 50 --Services
ORDER BY dep.SalesCodeDepartmentID
,		sc.CreateDate


SELECT  A.CenterID
,       A.ClientGUID
,       A.ClientFullName + ' had a ' + ISNULL(S1.SalesCodeDescription, '')
		+ CASE WHEN ISNULL(S2.SalesCodeDescription, '') <> '' THEN ', ' + ISNULL(S2.SalesCodeDescription, '') ELSE '' END
		+ CASE WHEN ISNULL(S3.SalesCodeDescription, '') <> '' THEN ', ' + ISNULL(S3.SalesCodeDescription, '') ELSE '' END
		+ ' with ' + A.StylistFirstName + ' ' + LEFT(A.StylistLastName, 1) + ' on ' + A.AppointmentDate + ' @ ' + A.AppointmentTime AS 'ActivityNote'
INTO	#AppointmentDetail
FROM    #Appointment A
		LEFT JOIN #AppointmentService S1
			ON S1.AppointmentGUID = A.AppointmentGUID
				AND S1.RowID = 1
		LEFT JOIN #AppointmentService S2
			ON S2.AppointmentGUID = A.AppointmentGUID
				AND S2.RowID = 2
		LEFT JOIN #AppointmentService S3
			ON S3.AppointmentGUID = A.AppointmentGUID
				AND S3.RowID = 3


SELECT DISTINCT
        ad.CenterID
INTO	#Center
FROM    #AppointmentDetail ad


DECLARE CUR CURSOR FAST_FORWARD FOR

SELECT  x_A.CenterID
,       x_A.ClientGUID
,       x_A.ActivityNote
FROM    #Center c
        CROSS APPLY ( SELECT TOP 5
                                *
                      FROM      #AppointmentDetail ad
                      WHERE     ad.CenterID = c.CenterID
                      ORDER BY  NEWID()
                    ) x_A

OPEN CUR

FETCH NEXT FROM CUR INTO @CenterID, @ClientGUID, @ActivityNote

WHILE @@FETCH_STATUS = 0
BEGIN
	--Initialize EmployeeGUID
	SET @EmployeeGUID = NULL

	--Get the CRM for the Center.
	--If no CRM for the Center, then get the Center Manager for the Center.
	--If no Center Manager for the Center, assign to the first Center Manager associated with the Center.
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

	FETCH NEXT FROM CUR INTO @CenterID, @ClientGUID, @ActivityNote
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
