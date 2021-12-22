/* CreateDate: 02/27/2009 11:16:51.633 , ModifyDate: 02/27/2017 09:49:28.820 */
GO
/***********************************************************************

PROCEDURE:				rptMedicalAssistantResource

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Dan Lorenz

IMPLEMENTOR: 			Dan Lorenz

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE: 	3/17/09
						6/23/09 Shaun Hankermeyer: Added logic to only include Hub Centers
						7/21/09 PRM - Added code to exclude appointments marked as IsDeletedFlag = 1 from results,
										updated where statements to use short description instead of full description to follow our coding standards,
										added JV MA's to the where statement so we return both MA & Joint MA's,
										and Reformatted code to be more reader friendly

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns all the centers with the total number of grafts scheduled and the
		number of Medical Assistants and Doctors scheduled to be at that center.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

rptMedicalAssistantResource '2/1/2009', '3/1/2009'

***********************************************************************/

CREATE PROCEDURE [dbo].[rptMedicalAssistantResource]
	  @StartDate date
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


    CREATE TABLE #DateRange
	(
		CenterID int,
		[Date] Date
	)

	WHILE @StartDate <= @EndDate
		BEGIN
			INSERT INTO #DateRange (CenterID, [Date])
				SELECT
					  c.CenterID
					, @StartDate
				FROM cfgCenter c
				WHERE c.IsActiveFlag = 1 AND c.CenterID = c.SurgeryHubCenterID

			SET @StartDate = DATEADD(DD, 1, @StartDate)
		END

		SELECT dr.CenterID
			, ctr.CenterDescription
			, (DATENAME(WEEKDAY, dr.[Date]) + ', ' + CAST(DATENAME(MONTH, dr.[Date]) AS VARCHAR(10)) + ' ' + CAST(DATEPART(DAY, dr.[Date]) AS VARCHAR(10)) + ', ' + CAST(DATEPART(YEAR, dr.[Date]) AS VARCHAR(10))) AS [DayOfWeek]
			, ISNULL(
				(
					SELECT SUM(cma.TotalAccumQuantity)
					FROM datAppointment a
						INNER JOIN datClientMembership cm ON a.ClientMembershipGUID = cm.ClientMembershipGUID
						INNER JOIN datClientMembershipAccum cma ON cm.ClientMembershipGUID = cma.ClientMembershipGUID
						INNER JOIN cfgAccumulator acc ON cma.AccumulatorID = acc.AccumulatorID
					WHERE acc.AccumulatorDescriptionShort = 'Grafts'
						AND a.CenterID = dr.CenterID AND a.AppointmentDate = dr.[Date]
						AND (a.IsDeletedFlag IS NULL OR a.IsDeletedFlag <> 1)
				), 0) AS TotalGrafts
			, (
				SELECT COUNT(*)
				FROM datSchedule s
					INNER JOIN datEmployee e ON e.EmployeeGUID = s.EmployeeGUID
					INNER JOIN cfgEmployeePositionJoin epj ON e.EmployeeGUID = epj.EmployeeGUID
					INNER JOIN lkpEmployeePosition ep ON epj.EmployeePositionID = ep.EmployeePositionID
				WHERE ep.EmployeePositionDescriptionShort IN ('MedAsstn', 'JVMedAsstn')
					AND s.ScheduleDate = dr.Date AND s.CenterID = dr.CenterID
			) AS [NumberOfMedicalAssistants]
			, (
				SELECT COUNT(*)
				FROM datSchedule s
					INNER JOIN datEmployee e ON e.EmployeeGUID = s.EmployeeGUID
					INNER JOIN cfgEmployeePositionJoin epj ON e.EmployeeGUID = epj.EmployeeGUID
					INNER JOIN lkpEmployeePosition ep ON epj.EmployeePositionID = ep.EmployeePositionID
				WHERE ep.EmployeePositionDescriptionShort IN ('Doctor')
				AND s.ScheduleDate = dr.Date AND s.CenterID = dr.CenterID
			) AS [NumberOfDoctors]
		FROM #DateRange dr
			INNER JOIN cfgCenter ctr ON ctr.CenterID = dr.CenterID

	DROP TABLE #DateRange

END
GO
