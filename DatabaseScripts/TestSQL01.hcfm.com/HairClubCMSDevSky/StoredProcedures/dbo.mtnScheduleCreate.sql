/* CreateDate: 10/04/2010 12:09:08.140 , ModifyDate: 12/11/2017 07:02:18.917 */
GO
/*
==============================================================================
PROCEDURE:				mtnScheduleCreate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 4/19/2010

LAST REVISION DATE: 	 4/19/2010

==============================================================================
DESCRIPTION:	Schedule Create:
					Executes each of the individual stored procs for creating
					schedules for employees and centers
==============================================================================
NOTES:
		* 04/09/10 MLM - Created stored proc
		* 09/21/10 PRM - Added config for date range, added delete logic to fix issue with multiple exceptions of the same type,
						included dayofweek into temp table, changed begin/end date logic, got rid of update/merge logic to also
						help fix the multiple exceptions error
		* 09/26/10 PRM - Added logic to pass in specific CenterID for employees
		* 10/29/13 MVT - Modified so that Lunch schedule is created from the template.
		* 08/13/15 SAL - Modified so that one Work schedule is created for the employeee's work day vs one for before lunch and one after lunch
		* 07/21/17 PRM - Updated appointment logic to remove Lunch from the EmpAvail record and making its own record so we can have multiple appointments besides lunch
		* 11/27/17 SAL - Implemented Holiday Hours for Employee Schedules (TFS#9659)

==============================================================================
SAMPLE EXECUTION:
EXEC mtnScheduleCreate '1/1/2010', '4/1/2010', NULL, NULL
==============================================================================
*/

CREATE PROCEDURE [dbo].[mtnScheduleCreate]
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL,
	@CenterID int = NULL,
	@EmployeeGUID uniqueidentifier = NULL
AS
  BEGIN

	DECLARE @tempStartDate DATETIME
	DECLARE @tempEndDate DATETIME

	DECLARE @ScheduleCreateRange int
	SELECT TOP 1 @ScheduleCreateRange = ISNULL(ScheduleCreateRange, 61) FROM cfgConfigurationApplication

	IF @StartDate IS NULL
		SET @tempStartDate = CONVERT(VARCHAR(10), GETUTCDATE(), 101)
	ELSE IF @StartDate < GETUTCDATE()
		SET @tempStartDate = CONVERT(VARCHAR(10), GETUTCDATE(), 101)
	ELSE
		SET @tempStartDate = CONVERT(VARCHAR(10), @StartDate, 101)

	IF @EndDate IS NULL
		SET @tempEndDate = DATEADD(DAY, @ScheduleCreateRange, CONVERT(VARCHAR(10), @tempStartDate, 101))
	ELSE
		SET @tempEndDate = CONVERT(VARCHAR(10), @EndDate, 101)

	--add a day-second so we include all records for the enddate
	SET @tempEndDate = DATEADD(SECOND, -1, DATEADD(DAY, 1, @tempEndDate))
	PRINT @tempEndDate

	DECLARE @DateTable TABLE(theDate datetime Primary Key, theDayOfWeek int)
	DECLARE @tempDate dateTime
	SET @tempDate = @tempStartDate

	WHILE @tempEndDate > @tempDate
	  BEGIN
		INSERT INTO @DateTable(thedate, theDayOfWeek) VALUES(@tempDate, DATEPART(DW, @tempDate))
		SET @tempDate = DATEADD(day, 1,@tempDate)
	  END

	-- Delete Records that fall between the dates
	IF NOT @EmployeeGUID IS NULL
	  BEGIN

		DELETE FROM datSchedule
		WHERE ScheduleDate BETWEEN @tempStartDate AND @tempEndDate
			AND EmployeeGUID = @EmployeeGUID
			AND NOT ScheduleTypeId IN (
				SELECT ScheduleTypeId
				FROM lkpScheduleType
				WHERE ScheduleTypeDescriptionShort IN ('PTO')
			)

	    -- Insert Available schedules and Appointments (lunch, meeting, etc)
		INSERT INTO datSchedule (ScheduleGUID, CenterID, EmployeeGUID, ScheduleDate, StartTime, EndTime, ScheduleSubject,
						ParentScheduleGUID, RecurrenceRule, CreateDate, CreateUser, LastUpdate, LastUpdateUser,
						ScheduleTypeId, ScheduleCalendarTypeID)
		SELECT NEWID() AS ScheduleGUID
					,ISNULL(@CenterID, ISNULL(e.CenterID, cst.CenterID)) AS CenterID
					,cst.EmployeeGUID
					,dt.theDate AS ScheduleDate
					,cst.StartTime
					,cst.EndTime
					,NULL AS ScheduleSubject
					,NULL AS ParentScheduleGUID
					,NULL AS RecurrenceRule
					,GETUTCDATE() AS CreateDate
					,'sa' AS CreateUser
					,GETUTCDATE() AS LastUpdate
					,'sa' AS LastUpdateuser
					,cst.ScheduleTypeID
					,cst.ScheduleCalendarTypeID
				FROM cfgScheduleTemplate cst
					INNER JOIN @DateTable dt ON cst.ScheduleTemplateDayOfWeek = dt.theDayOfWeek
					LEFT JOIN datEmployee e ON cst.EmployeeGUID = e.EmployeeGUID
					LEFT JOIN cfgCenter c ON c.CenterID = @CenterID
				WHERE cst.ScheduleDurationCalc > 0
					AND cst.IsActiveScheduleFlag = 1
					AND ( e.IsActiveFlag = 1 AND c.IsActiveFlag = 1 )
					AND ( cst.EmployeeGUID = @EmployeeGUID)

		--Get Holidays for the center's center type and country that fall between the dates
		DECLARE @HolidaysTable TABLE(holidayDate date, startTime time(0), endTime time(0), scheduleTypeID int, scheduleCalendarTypeID int)

		INSERT INTO @HolidaysTable(holidayDate, startTime, endTime, scheduleTypeID, scheduleCalendarTypeID)
		SELECT hst.ScheduleHolidayTemplateDate
			,hst.StartTime
			,hst.EndTime
			,hst.ScheduleTypeID
			,hst.ScheduleCalendarTypeID
		FROM cfgCenter c
			INNER JOIN cfgScheduleHolidayTemplate hst ON (c.CenterTypeID = hst.CenterTypeID AND c.CountryID = hst.CountryID)
		WHERE c.CenterID = @CenterID
			AND hst.ScheduleHolidayTemplateDate BETWEEN @tempStartDate AND @tempEndDate
			AND hst.IsActiveScheduleFlag = 1

		--Update existing employee schedules that fall on holiday dates
		UPDATE s
		SET StartTime = hst.StartTime
			,EndTime = hst.EndTime
			,LastUpdate = GETUTCDATE()
			,LastUpdateUser = 'ScheduleCreate_Holiday'
		FROM datSchedule s
			INNER JOIN @HolidaysTable hst ON (s.ScheduleDate = hst.holidayDate AND
											  s.ScheduleTypeID = hst.scheduleTypeID AND
											  s.ScheduleCalendarTypeID = hst.scheduleCalendarTypeID AND
											  s.EmployeeGUID = @EmployeeGUID)

		--Insert new employee schedules for holiday dates that don't already exist for the employee
		INSERT INTO datSchedule (ScheduleGUID, CenterID, EmployeeGUID, ScheduleDate, StartTime, EndTime, ScheduleSubject,
			ParentScheduleGUID, RecurrenceRule, CreateDate, CreateUser, LastUpdate, LastUpdateUser,
			ScheduleTypeId, ScheduleCalendarTypeID)
		SELECT NEWID() AS ScheduleGUID
			,@CenterID
			,@EmployeeGUID
			,hst.holidayDate AS ScheduleDate
			,hst.StartTime
			,hst.EndTime
			,NULL AS ScheduleSubject
			,NULL AS ParentScheduleGUID
			,NULL AS RecurrenceRule
			,GETUTCDATE() AS CreateDate
			,'ScheduleCreate_Holiday' AS CreateUser
			,GETUTCDATE() AS LastUpdate
			,'ScheduleCreate_Holiday' AS LastUpdateuser
			,hst.ScheduleTypeID
			,hst.ScheduleCalendarTypeID
		FROM datSchedule s
			RIGHT JOIN @HolidaysTable hst ON (s.ScheduleDate = hst.holidayDate AND
											  s.ScheduleTypeID = hst.scheduleTypeID AND
											  s.ScheduleCalendarTypeID = hst.scheduleCalendarTypeID AND
											  s.EmployeeGUID = @EmployeeGUID)
		WHERE s.ScheduleGUID IS NULL

	  END
	ELSE
	  BEGIN
		DELETE FROM datSchedule
		WHERE ScheduleDate BETWEEN @tempStartDate AND @tempEndDate
			AND CenterID = @CenterID AND EmployeeGUID IS NULL

		INSERT INTO datSchedule (ScheduleGUID, CenterID, EmployeeGUID, ScheduleDate, StartTime, EndTime, ScheduleSubject,
						ParentScheduleGUID, RecurrenceRule, CreateDate, CreateUser, LastUpdate, LastUpdateUser,
						ScheduleTypeId, ScheduleCalendarTypeID)
		SELECT NEWID() AS ScheduleGUID
					,@CenterID AS CenterID
					,NULL AS EmployeeGUID
					,dt.theDate AS ScheduleDate
					,cst.StartTime
					,cst.EndTime
					,NULL AS ScheduleSubject
					,NULL AS ParentScheduleGUID
					,NULL AS RecurrenceRule
					,GETUTCDATE() AS CreateDate
					,'sa' AS CreateUser
					,GETUTCDATE() AS LastUpdate
					,'sa' AS LastUpdateuser
					,cst.ScheduleTypeID
					,cst.ScheduleCalendarTypeID
				FROM cfgScheduleTemplate cst
					INNER JOIN @DateTable dt ON cst.ScheduleTemplateDayOfWeek = dt.theDayOfWeek
					LEFT JOIN cfgCenter c ON cst.CenterID = c.CenterID
				WHERE cst.ScheduleDurationCalc > 0
					AND ( c.IsActiveFlag = 1 )
					AND ( cst.CenterID = @CenterID AND cst.EmployeeGUID IS NULL)

	  END

  END
GO
