/* CreateDate: 10/13/2017 14:07:29.110 , ModifyDate: 10/14/2020 10:36:07.920 */
GO
/***************************************************************************************************
PROCEDURE:				mtnCreateActivitiesForCustomerExperienceCareCalls
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/13/2017
DESCRIPTION:			10/13/2017
-----------------------------------------------------------------------------------------------------
NOTES:

		* 10/30/2017	SAL Updated to include a check for SalesForceTaskID on Get Appointments.
		* 10/31/2017	SAL Updated to create DueDate for Activity as Date only with NO time.
		* 11/16/2017	SAL Updated to limit number of activities being created to 5 per day (TFS#9919)
		* 11/17/2017	SAL Updated to not create an activity if a CUSTSRVOUT activity has been created
								for the client in the last 12 months (TFS#9928)
		* 11/21/2017	SAL Updated to account for NULL DoNotCall and DoNotContact flag on Client (TFS#9948)
		* 10/11/2018	SAL	Updated to account for Hair Fit appointments (TFS#11450)
		* 10/08/2020    KRM Changed the count from top 5 to top 10
		* 10/14/2020    KRM Changed the count from 10 to 15 per Danny's request
-----------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC mtnCreateActivitiesForCustomerExperienceCareCalls
*****************************************************************************************************/
CREATE PROCEDURE [dbo].[mtnCreateActivitiesForCustomerExperienceCareCalls]
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
DECLARE @EmployeeGUID UNIQUEIDENTIFIER = '75A4CFA4-CF9C-490D-A4DF-B69D31C7A09D' --Danny Lombana
DECLARE @User NVARCHAR(25) = 'Nightly_CustExpCall'


SELECT @ActivitySubCategoryID = ActivitySubCategoryID FROM lkpActivitySubCategory WHERE ActivitySubCategoryDescriptionShort = 'SCHED'
SELECT @ActivityActionID = ActivityActionID FROM lkpActivityAction WHERE ActivityActionDescriptionShort = 'CUSTSRVOUT'
SELECT @DueDate = CONVERT(DATE, GETDATE())
SELECT @ActivityPriorityID = ActivityPriorityID FROM lkpActivityPriority WHERE ActivityPriorityDescriptionShort = 'MED'
SELECT @ActivityStatusID = ActivityStatusID FROM lkpActivityStatus WHERE ActivityStatusDescriptionShort = 'OPEN'
SELECT @TrichoViewAppointmentTypeID = AppointmentTypeID FROM lkpAppointmentType WHERE AppointmentTypeDescriptionShort = 'TrichoView'
SELECT @HairFitAppointmentTypeID = AppointmentTypeID FROM lkpAppointmentType WHERE AppointmentTypeDescriptionShort = 'HairFit'


SET @Date = GETDATE()
SET @WeekDay = DATENAME(WEEKDAY, @Date)


IF ( @WeekDay = 'Tuesday' )
   BEGIN
		SET @StartDate = DATEADD(dd, -4, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME)) --Friday
		SET @EndDate = DATEADD(dd, -3, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME)) --Saturday
   END
ELSE
   BEGIN
		SET @StartDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME)) --Yesterday
		SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME)) --Yesterday
   END


-- Get Appointments
SELECT TOP 15
        CAST(da.AppointmentGUID AS NVARCHAR(50)) AS 'AppointmentGUID'
,       da.CenterID
,		clt.ClientGUID
,       clt.ClientFullNameAltCalc AS 'ClientFullName'
,       CONVERT(VARCHAR(11), CAST(da.AppointmentDate AS DATE), 101) AS 'AppointmentDate'
,       CONVERT(VARCHAR(15), CAST(da.StartTime AS TIME), 100) AS 'AppointmentTime'
,       de.FirstName AS 'StylistFirstName'
,       de.LastName AS 'StylistLastName'
INTO    #Appointments
FROM    datAppointment da WITH ( NOLOCK )
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
WHERE   da.CenterID LIKE '[2]%' --Corporate Centers Only
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
		AND a.ActivityID IS NULL --No cONEct! CUSTSRVOUT activities created for this client in the last 12 months
ORDER BY NEWID()


SELECT  ROW_NUMBER() OVER ( PARTITION BY a.AppointmentGUID ORDER BY dep.SalesCodeDepartmentID, sc.CreateDate ) AS 'RowID'
,		a.AppointmentGUID
,		sc.SalesCodeDescriptionShort AS 'SalesCode'
,		sc.SalesCodeDescription
INTO	#AppointmentServices
FROM    datAppointmentDetail ad WITH ( NOLOCK )
		INNER JOIN #Appointments a
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


DECLARE CUR CURSOR FAST_FORWARD FOR

SELECT  A.CenterID
,       A.ClientGUID
,       A.ClientFullName + ' had a ' + ISNULL(S1.SalesCodeDescription, '')
		+ CASE WHEN ISNULL(S2.SalesCodeDescription, '') <> '' THEN ', ' + ISNULL(S2.SalesCodeDescription, '') ELSE '' END
		+ CASE WHEN ISNULL(S3.SalesCodeDescription, '') <> '' THEN ', ' + ISNULL(S3.SalesCodeDescription, '') ELSE '' END
		+ ' with ' + A.StylistFirstName + ' ' + LEFT(A.StylistLastName, 1) + ' on ' + A.AppointmentDate + ' @ ' + A.AppointmentTime AS 'ActivityNote'
FROM    #Appointments A
		LEFT JOIN #AppointmentServices S1
			ON S1.AppointmentGUID = A.AppointmentGUID
				AND S1.RowID = 1
		LEFT JOIN #AppointmentServices S2
			ON S2.AppointmentGUID = A.AppointmentGUID
				AND S2.RowID = 2
		LEFT JOIN #AppointmentServices S3
			ON S3.AppointmentGUID = A.AppointmentGUID
				AND S3.RowID = 3

OPEN CUR

FETCH NEXT FROM CUR INTO @CenterID, @ClientGUID, @ActivityNote

WHILE @@FETCH_STATUS = 0
BEGIN

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
GO
