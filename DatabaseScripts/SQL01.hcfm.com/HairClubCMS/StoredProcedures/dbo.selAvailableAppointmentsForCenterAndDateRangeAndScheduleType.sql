/* CreateDate: 01/19/2020 21:54:27.407 , ModifyDate: 01/19/2020 21:54:27.407 */
GO
/***********************************************************************

PROCEDURE:				selAvailableAppointmentsForCenterAndDateRangeAndScheduleType

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		12/30/2019

LAST REVISION DATE: 	12/30/2019

--------------------------------------------------------------------------------------------------------
NOTES:  Selects available timeslots for center, date range, and schedule type

		* 12/30/2019	SAL	Created
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

selAvailableAppointmentsForCenterAndDateRangeAndScheduleType 237, '2020-01-01', '2020-01-31', 'InitNS'

***********************************************************************/

CREATE PROCEDURE [dbo].[selAvailableAppointmentsForCenterAndDateRangeAndScheduleType]
	@CenterID int,
	@StartDate datetime,
	@EndDate datetime,
	@ScheduleTypeDescriptionShort nvarchar(10)
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRY

		DECLARE @AvailableSchedules table (ScheduleGUID uniqueidentifier)
		DECLARE @ScheduleGUID uniqueidentifier
		DECLARE @EmployeeGUID uniqueidentifier
		DECLARE @ScheduleStart datetime
		DECLARE @ScheduleEnd datetime
		DECLARE @ScheduleTypeID int

		SELECT @ScheduleTypeID = ScheduleTypeID FROM lkpScheduleType WHERE ScheduleTypeDescriptionShort = @ScheduleTypeDescriptionShort

		DECLARE CUR CURSOR FAST_FORWARD FOR
			SELECT s.ScheduleGUID
				,s.EmployeeGUID
				,CAST(s.ScheduleDate as datetime) + CAST(s.StartTime as datetime) as ScheduleStart
				,CAST(s.ScheduleDate as datetime) + CAST(s.EndTime as datetime) as ScheduleEnd
			 FROM datSchedule s
				inner join lkpScheduleType st on s.ScheduleTypeID = st.ScheduleTypeID
			 WHERE s.ScheduleTypeID = @ScheduleTypeID
				and s.CenterID = @CenterID
				and s.ScheduleDate >= @StartDate
				and s.ScheduleDate <= @EndDate

		OPEN CUR

		FETCH NEXT FROM CUR INTO @ScheduleGUID, @EmployeeGUID, @ScheduleStart, @ScheduleEnd

		WHILE @@FETCH_STATUS = 0 BEGIN

			--Check to see if any appointments exist that overlap the schedule
			IF NOT EXISTS(SELECT *
						  FROM datAppointment a
							inner join datAppointmentEmployee ae on a.AppointmentGUID = ae.AppointmentGUID
						  WHERE a.CenterID = @CenterID
							and ae.EmployeeGUID = @EmployeeGUID
							and (a.EndDateTimeCalc > @ScheduleStart and a.StartDateTimeCalc < @ScheduleEnd)
							and a.IsDeletedFlag = 0)
			BEGIN
				INSERT INTO @AvailableSchedules VALUES (@ScheduleGUID)
			END

			FETCH NEXT FROM CUR INTO @ScheduleGUID, @EmployeeGUID, @ScheduleStart, @ScheduleEnd
		END

		SELECT s.ScheduleDate, s.StartTime, e.AbbreviatedNameCalc AS EmployeeFirstNameLastInitial
		FROM @AvailableSchedules a
			inner join datSchedule s on a.ScheduleGUID = s.ScheduleGUID
			inner join datEmployee e on s.EmployeeGUID = e.EmployeeGUID
		ORDER BY ScheduleDate, StartTime, EmployeeFirstNameLastInitial

		CLOSE CUR
		DEALLOCATE CUR

  END TRY

  BEGIN CATCH
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
