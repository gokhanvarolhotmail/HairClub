/* CreateDate: 02/27/2009 11:17:29.197 , ModifyDate: 02/27/2017 09:49:30.450 */
GO
/***********************************************************************

PROCEDURE:				rptSchedulingExceptions

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Dan Lorenz

IMPLEMENTOR: 			Dan Lorenz

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE: 	3/17/09
						7/21/09 PRM - Added logic to exclude appointments marked as IsDeletedFlag = 1

--------------------------------------------------------------------------------------------------------
NOTES: 	Retrieve scheduling data for Scheduling Exceptions report.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

rptSchedulingExceptions 301, '2/15/2009', '3/1/2009'

***********************************************************************/

CREATE PROCEDURE [dbo].[rptSchedulingExceptions]
      @CenterID int
	, @StartDate date
	, @EndDate date
AS
BEGIN

	SET NOCOUNT ON;

	IF @StartDate IS NULL
	BEGIN
		SET @StartDate = GETDATE()
	END
	IF @EndDate IS NULL
	BEGIN
		SET @EndDate = DATEADD(DD, 14, @StartDate)
	END

	DECLARE @OriginalStartDate datetime
	SET @OriginalStartDate = @StartDate

    CREATE TABLE #DateRange
	(
		EmployeeGUID uniqueidentifier,
		[Date] Date
	)

	DECLARE @CenterDates TABLE ([Date] date)
	INSERT INTO @CenterDates ([Date])
		SELECT DISTINCT s.ScheduleDate FROM datSchedule s
			WHERE s.EmployeeGUID IS NULL AND s.CenterID = 301
				AND s.ScheduleDate >= @OriginalStartDate AND s.ScheduleDate <= @EndDate
			ORDER BY s.ScheduleDate

	WHILE @StartDate <= @EndDate
		BEGIN
			IF (SELECT COUNT(*) FROM @CenterDates cd WHERE cd.[Date] = @StartDate) > 0
			BEGIN
				INSERT INTO #DateRange (EmployeeGUID, [Date])
					SELECT
						e.EmployeeGUID
						, @StartDate
					FROM datEmployee e
					WHERE e.CenterID = @CenterID
			END

			SET @StartDate = DATEADD(DD, 1, @StartDate)
		END


	CREATE TABLE #Results
	(
		  [Date] date
		, EmployeeGUID uniqueidentifier
		, [Message] VARCHAR(1000)
		, [EmployeePosition] VARCHAR(100)
	)

	INSERT INTO #Results ([Date], EmployeeGUID, [Message], [EmployeePosition])
	SELECT DISTINCT
		  s.ScheduleDate AS [Date]
		, e.EmployeeGUID
		, 'Employee is scheduled in more than one center.' AS [Message]
		, lkpEP.EmployeePositionDescription AS [EmployeePosition]
	FROM #DateRange dr
		INNER JOIN datSchedule s ON dr.[Date] = s.ScheduleDate and s.EmployeeGUID = dr.EmployeeGUID
		INNER JOIN datEmployee e ON s.EmployeeGUID = e.EmployeeGUID AND e.IsActiveFlag = 1
		INNER JOIN cfgEmployeePositionJoin epj on e.EmployeeGUID = epj.EmployeeGUID
			AND epj.EmployeePositionID IN (8,9) -- Doctor, Medical Assistant
		INNER JOIN lkpEmployeePosition lkpEP ON epj.EmployeePositionID = lkpEP.EmployeePositionID
	WHERE (SELECT DISTINCT
				COUNT(*)
		     FROM datSchedule s
				INNER JOIN datEmployee e ON s.EmployeeGUID = e.EmployeeGUID AND e.IsActiveFlag = 1
				INNER JOIN cfgEmployeePositionJoin epj on e.EmployeeGUID = epj.EmployeeGUID
		     WHERE s.EmployeeGUID IS NOT NULL
				AND s.ScheduleDate = dr.[Date]
				AND s.EmployeeGUID = dr.EmployeeGUID
				AND epj.EmployeePositionID IN (8,9) -- Doctor, Medical Assistant
		     GROUP BY s.EmployeeGUID
		     HAVING COUNT(s.CenterID) > 1) > 0
	ORDER BY s.ScheduleDate

	INSERT INTO #Results ([Date], EmployeeGUID, [Message], [EmployeePosition])
	SELECT
		  a.AppointmentDate AS [Date]
		, ae.EmployeeGUID
		, 'Employee has ' + at.AppointmentTypeDescription + ' from ' + RTRIM(ISNULL(REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(char,CAST(a.StartTime AS DATETIME),100),18)),'AM',' AM'), 'PM', ' PM'), '?')) + ' to ' + RTRIM(ISNULL(REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(char,CAST(a.EndTime AS DATETIME),100),18)),'AM',' AM'), 'PM', ' PM'), '?')) + '.' AS [Message]
		, lkpEP.EmployeePositionDescription AS [EmployeePosition]
	FROM #DateRange dr
		INNER JOIN datAppointment a ON dr.[Date] = a.AppointmentDate AND a.AppointmentTypeID <> 7
		INNER JOIN lkpAppointmentType at ON a.AppointmentTypeID = at.AppointmentTypeID
		INNER JOIN datAppointmentEmployee ae ON a.AppointmentGUID = ae.AppointmentGUID AND ae.EmployeeGUID = dr.EmployeeGUID
		INNER JOIN datEmployee e ON ae.EmployeeGUID = e.EmployeeGUID AND e.IsActiveFlag = 1
		INNER JOIN cfgEmployeePositionJoin epj on e.EmployeeGUID = epj.EmployeeGUID
			AND epj.EmployeePositionID IN (8,9) -- Doctor, Medical Assistant
		INNER JOIN lkpEmployeePosition lkpEP ON epj.EmployeePositionID = lkpEP.EmployeePositionID
	WHERE a.CenterID = @CenterID
		AND (a.IsDeletedFlag IS NULL OR a.IsDeletedFlag <> 1)
	ORDER BY a.AppointmentDate

	INSERT INTO #Results ([Date], EmployeeGUID, [Message], [EmployeePosition])
	SELECT
		  s.ScheduleDate AS [Date]
		, e.EmployeeGUID
		, 'Employee is scheduled in center ''' + CAST(s.CenterID AS VARCHAR(10)) + ''' from ' + RTRIM(ISNULL(REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(char,CAST(s.StartTime AS DATETIME),100),18)),'AM',' AM'), 'PM', ' PM'), '?')) + ' to ' + RTRIM(ISNULL(REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(char,CAST(s.EndTime AS DATETIME),100),18)),'AM',' AM'), 'PM', ' PM'), '?')) + '.' AS [Message]
		, lkpEP.EmployeePositionDescription AS [EmployeePosition]
	FROM #DateRange dr
		INNER JOIN datSchedule s ON dr.[Date] = s.ScheduleDate and s.EmployeeGUID = dr.EmployeeGUID
		INNER JOIN datEmployee e ON s.EmployeeGUID = e.EmployeeGUID AND e.IsActiveFlag = 1
		INNER JOIN cfgEmployeePositionJoin epj on e.EmployeeGUID = epj.EmployeeGUID
			AND epj.EmployeePositionID IN (8,9) -- Doctor, Medical Assistant
		INNER JOIN lkpEmployeePosition lkpEP ON epj.EmployeePositionID = lkpEP.EmployeePositionID
	WHERE s.CenterID <> @CenterID
	ORDER BY s.ScheduleDate

	--INSERT INTO #Results ([Date], EmployeeGUID, [Message], [EmployeePosition])
	--SELECT
	--	  NULL
	--	, e.EmployeeGUID
	--	, 'Employee is not scheduled for any day during the timeframe.' AS [Message]
	--	, lkpEP.EmployeePositionDescription AS [EmployeePosition]
	--FROM datEmployee e
	--	INNER JOIN cfgEmployeePositionJoin epj on e.EmployeeGUID = epj.EmployeeGUID
	--		AND epj.EmployeePositionID IN (8,9) -- Doctor, Medical Assistant
	--		AND e.IsActiveFlag = 1 AND e.CenterID = @CenterID
	--	INNER JOIN lkpEmployeePosition lkpEP ON epj.EmployeePositionID = lkpEP.EmployeePositionID
	--WHERE NOT EXISTS
	--	(
	--		SELECT DISTINCT
	--			s.EmployeeGUID
	--		FROM datSchedule s
	--		WHERE s.ScheduleDate >= @OriginalStartDate AND s.ScheduleDate <= @EndDate
	--			AND s.EmployeeGUID = e.EmployeeGUID
	--	)
	--AND EXISTS (
	--	SELECT 1 FROM datSchedule s
	--	WHERE s.EmployeeGUID IS NULL
	--	AND s.ScheduleDate >= @OriginalStartDate AND s.ScheduleDate <= @EndDate
	--	AND s.CenterID = 301)

	INSERT INTO #Results ([Date], EmployeeGUID, [Message], [EmployeePosition])
	SELECT
		  dr.[Date]
		, dr.EmployeeGUID
		, 'Employee is not scheduled this day.' AS [Message]
		, lkpEP.EmployeePositionDescription AS [EmployeePosition]
	FROM #DateRange dr
		INNER JOIN datEmployee e ON e.EmployeeGUID = dr.EmployeeGUID
		INNER JOIN cfgEmployeePositionJoin epj on e.EmployeeGUID = epj.EmployeeGUID
			AND epj.EmployeePositionID IN (8,9) -- Doctor, Medical Assistant
			AND e.IsActiveFlag = 1 AND e.CenterID = @CenterID
		INNER JOIN lkpEmployeePosition lkpEP ON epj.EmployeePositionID = lkpEP.EmployeePositionID
	WHERE dr.[Date] NOT IN
		(SELECT
			s.ScheduleDate
		 FROM datSchedule s
		 WHERE s.EmployeeGUID = dr.EmployeeGUID AND s.ScheduleDate = dr.[Date]
		 UNION
		 SELECT
			  [Date]
		 FROM #Results r
		 WHERE r.[Date] = dr.[Date] AND r.EmployeeGUID = dr.EmployeeGUID)

	IF (SELECT COUNT(*) FROM #Results) = 0
		INSERT INTO #Results ([Date], EmployeeGUID, [Message], [EmployeePosition]) VALUES (NULL, NULL, 'No Exceptions', NULL)

	SELECT
		  @CenterID AS HomeCenterID
		, ctr.CenterDescription
		, (DATENAME(WEEKDAY, r.[Date]) + ', ' + CAST(DATENAME(MONTH, r.[Date]) AS VARCHAR(10)) + ' ' + CAST(DATEPART(DAY, r.[Date]) AS VARCHAR(10)) + ', ' + CAST(DATEPART(YEAR, r.[Date]) AS VARCHAR(10))) AS [DayOfWeek]
		, e.EmployeeFullNameCalc AS [FullName]
		, r.EmployeePosition
		, r.[Message]
	FROM #Results r
		INNER JOIN cfgCenter ctr ON ctr.CenterID = @CenterID
		LEFT OUTER JOIN datEmployee e ON e.EmployeeGUID = r.EmployeeGUID
	WHERE e.EmployeeFullNameCalc <> ',' OR r.EmployeeGUID IS NULL
	ORDER BY r.[Date], r.EmployeePosition, e.EmployeeFullNameCalc, r.[Message]

	DROP TABLE #Results
    DROP TABLE #DateRange

END
GO
