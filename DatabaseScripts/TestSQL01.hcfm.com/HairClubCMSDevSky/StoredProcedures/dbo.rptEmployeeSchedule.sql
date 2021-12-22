/* CreateDate: 02/27/2009 09:09:28.183 , ModifyDate: 02/27/2017 09:49:26.860 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				rptEmployeeSchedule

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Dan Lorenz

IMPLEMENTOR: 			Dan Lorenz

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE: 	4/10/09  Andrew Schwalbe
						* Change to return 'Standard Hours' instead of 'Unscheduled' since a null subject
							does not mean they are unscheduled.
						* Change to return the scheduled center, not the employee's home center

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns the schedule for an employee or all the Employees of a specific center.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

rptEmployeeSchedule '5D044E24-96C8-4C10-B097-51C16F6F05D4', NULL, '2/1/2009', '4/1/2009'

***********************************************************************/

CREATE PROCEDURE [dbo].[rptEmployeeSchedule]
	  @EmployeeGUID AS uniqueidentifier = NULL
	, @CenterID AS int = NULL
	, @StartDate AS date
	, @EndDate AS date
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


	CREATE TABLE #DateRange
	(
		EmployeeGUID uniqueidentifier,
		[Date] Date
	)

	IF @EmployeeGUID IS NOT NULL
	BEGIN
		WHILE @StartDate <= @EndDate
		BEGIN
			INSERT INTO #DateRange VALUES (@EmployeeGUID, @StartDate)
			SET @StartDate = DATEADD(DD, 1, @StartDate)
		END

		SELECT DISTINCT
			  e.EmployeeFullNameCalc AS FullName
			, s.CenterID
			, ctr.CenterDescription
			, dr.[Date]
			, DATENAME(WEEKDAY, dr.[Date]) AS [DayOfWeek]
			, s.StartTime
			, s.EndTime
			, ISNULL(s.ScheduleSubject, 'Standard Hours') AS ScheduleSubject
		FROM datEmployee e
			INNER JOIN #DateRange dr ON e.EmployeeGUID = dr.EmployeeGUID
				AND e.EmployeeGUID = @EmployeeGUID AND e.IsActiveFlag = 1
			LEFT OUTER JOIN datSchedule s ON s.EmployeeGUID = dr.EmployeeGUID
				AND s.ScheduleDate = dr.[Date]
			INNER JOIN cfgCenter ctr ON ctr.CenterID = s.CenterID
		ORDER BY dr.[Date]
	END
	ELSE
	BEGIN
		WHILE @StartDate <= @EndDate
		BEGIN
			INSERT INTO #DateRange (EmployeeGUID, Date)
			SELECT
				e.EmployeeGUID,
				@StartDate
			FROM datEmployee e
			WHERE e.CenterID = @CenterID

			SET @StartDate = DATEADD(DD, 1, @StartDate)
		END

		SELECT DISTINCT
			  e.EmployeeFullNameCalc AS FullName
			, s.CenterID
			, ctr.CenterDescription
			, dr.[Date]
			, DATENAME(WEEKDAY, dr.[Date]) AS [DayOfWeek]
			, RTRIM(REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(char,CAST(s.StartTime AS DATETIME),100),18)),'AM',' AM'), 'PM', ' PM')) AS [StartTime]
			, RTRIM(REPLACE(REPLACE(LTRIM(RIGHT(CONVERT(char,CAST(s.EndTime AS DATETIME),100),18)),'AM',' AM'), 'PM', ' PM')) AS [EndTime]
			, ISNULL(s.ScheduleSubject, 'Standard Hours') AS ScheduleSubject
		FROM datEmployee e
			INNER JOIN #DateRange dr ON e.EmployeeGUID = dr.EmployeeGUID
				AND e.CenterID = @CenterID AND e.IsActiveFlag = 1
			LEFT OUTER JOIN datSchedule s ON s.EmployeeGUID = dr.EmployeeGUID
				AND s.ScheduleDate = dr.[Date]
			INNER JOIN cfgCenter ctr ON ctr.CenterID = s.CenterID
		ORDER BY e.EmployeeFullNameCalc, dr.[Date]
	END

	DROP TABLE #DateRange

END
GO
