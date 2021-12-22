/* CreateDate: 12/12/2006 14:53:19.063 , ModifyDate: 05/01/2010 14:48:10.580 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spdts_Build_Appts_Matrix]
	@days int
AS

DECLARE @center Int
DECLARE @starttime int
DECLARE @endtime int
DECLARE @increments int
DECLARE @maxappts int
DECLARE @apptTime int
DECLARE @apptTime_string char(5)
DECLARE @incrementer int

-- this will be parameter for stored procedure
-- use this for testing purposes
--DECLARE @days int
--SET @days = 14


SET NOCOUNT ON
-- Time zone for this server
DECLARE @localTimeZoneCode varchar(10)
SET @localTimeZoneCode = 'EST'


-- this is the current appt date
DECLARE @ApptDate DATETIME
SET @ApptDate = CONVERT(varchar(10),GetDate(),120)

-- this is the last apptdate in the schedule
DECLARE @EndDate DATETIME
SET @EndDate = DateAdd(day, @days, GetDate())

-- this is the weekday associated with cst_closed day
DECLARE @Weekday int

DECLARE @localTimeZoneOffset int
SET @localTimeZoneOffset = (SELECT greenwich_offset FROM onca_time_zone where time_zone_code = @localTimeZoneCode)

-- loop through each of the dates of the schedule
WHILE (@ApptDate <= @EndDate) BEGIN
	--Create a list of Companies that are potentially open on the current date (@ApptDate)
	DECLARE @currentCompany varchar(10)
	DECLARE @currentCenterCode varchar(10)
	DECLARE @currentCenterTZCode varchar(10)

	DECLARE pot_companies CURSOR FOR
	SELECT cstd_company_schedule.company_id, cst_center_number, oncd_company_address.time_zone_code FROM cstd_company_schedule
		INNER JOIN oncd_company ON oncd_company.company_id = cstd_company_schedule.company_id
		LEFT OUTER JOIN oncd_company_address ON oncd_company.company_id = oncd_company_address.company_id AND oncd_company_address.primary_flag = 'Y'
		WHERE 1=1
			--NOT EXISTS (SELECT 1 FROM csta_global_closure WHERE closure_date = @ApptDate AND SUBSTRING(CONVERT(varchar(16),first_appointment,120),12,5) >= SUBSTRING(CONVERT(varchar(16),last_appointment,120),12,5))
			AND NOT EXISTS (SELECT 1 FROM cstd_company_schedule_by_date
						WHERE company_id = cstd_company_schedule.company_id
							AND schedule_date = @ApptDate
							AND (SUBSTRING(CONVERT(varchar(16),first_appointment,120),12,5) <= SUBSTRING(CONVERT(varchar(16),cstd_company_schedule.first_appointment,120),12,5)
								AND
							     SUBSTRING(CONVERT(varchar(16),last_appointment,120),12,5) >= SUBSTRING(CONVERT(varchar(16),cstd_company_schedule.last_appointment,120),12,5)
							    )
							AND cstd_company_schedule_by_date.status_code = 'CLOSED')
						ORDER BY cst_center_number

	OPEN pot_companies
	FETCH NEXT FROM pot_companies INTO @currentCompany, @currentCenterCode, @currentCenterTZCode

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		DECLARE @NoAppts int
		--For each possible 1/2 hour TOD interval, check if the company is open
		-- for that date/time/weekday.  If so, get the #Appts for that interval
		DECLARE @UseHalfHour bit
		DECLARE @slotNumber float
		SET @slotNumber = 0
		WHILE (@slotNumber <= 47)  --48 1/2 hour intervals in a day
		BEGIN
			SET @NoAppts = 0
			DECLARE @ApptTimeString varchar(5)
			SET @ApptTimeString = RIGHT('0'+CONVERT(varchar(2),CONVERT(int,@slotNumber/2)),2)+':'
			IF @slotNumber/2 = CONVERT(int,@slotNumber/2)
				BEGIN
					SET @ApptTimeString = @ApptTimeString + '00'
					SET @UseHalfHour = 0
				END
			ELSE
				BEGIN
					SET @ApptTimeString = @ApptTimeString + '30'
					SET @UseHalfHour = 1
				END

			--Only show times later than now.  Since time is different for centers
			-- in other time zones, we need to convert based on TZ in center primary address.
			-- We are assuming that this server is running in EST time zone (GMT-5)
			DECLARE @timeAtCenter datetime
			IF @currentCenterTZCode IS NULL --No specified TZ for center, we assume same as this server
				SET @timeAtCenter = GETDATE()
			ELSE
				SET @timeAtCenter = dbo.TimeForContact(GETDATE(),@localTimeZoneOffset,@currentCenterTZCode)

			IF CONVERT(datetime,CONVERT(varchar(10), @ApptDate, 120) + ' ' + @ApptTimeString) < @timeAtCenter
				BEGIN
					SET @slotNumber = @slotNumber + 1

					CONTINUE
				END

			--See if there's an override schedule for this company/date in cstd_company_schedule_by_date
			DECLARE @csbdStatus varchar(10)
			SET @csbdStatus = (SELECT status_code FROM cstd_company_schedule_by_date WHERE company_id = @currentCompany AND schedule_date = @ApptDate AND @ApptTimeString BETWEEN SUBSTRING(CONVERT(varchar(16),first_appointment,120),12,5) AND SUBSTRING(CONVERT(varchar(16),last_appointment,120),12,5))

			IF ISNULL(@csbdStatus,'') <> ''
				BEGIN
					IF @csbdStatus = 'CLOSED'
						SET @NoAppts = 0
					ELSE
						BEGIN
							IF @UseHalfHour = 0
								SET @NoAppts = (SELECT hour_appointments FROM cstd_company_schedule_by_date WHERE company_id = @currentCompany AND schedule_date = @ApptDate AND status_code = 'OPEN' AND @ApptTimeString BETWEEN SUBSTRING(CONVERT(varchar(16),first_appointment,120),12,5) AND SUBSTRING(CONVERT(varchar(16),last_appointment,120),12,5))
							ELSE
								SET @NoAppts = (SELECT half_hour_appointments FROM cstd_company_schedule_by_date WHERE company_id = @currentCompany AND schedule_date = @ApptDate AND status_code = 'OPEN' AND @ApptTimeString BETWEEN SUBSTRING(CONVERT(varchar(16),first_appointment,120),12,5) AND SUBSTRING(CONVERT(varchar(16),last_appointment,120),12,5))
						END
				END
			ELSE
				BEGIN
					--See if it should be overriden by a Daily Timeframe entry
					DECLARE @currentTimeframeDailyID varchar(10)
					DECLARE @currentWeekday	int

					--Tuesday is Day 1 in this system rather than Sunday, so we subtract 2 here
					SET @currentWeekday = DATEPART(weekday,DATEADD(day,-2,@ApptDate))
					SET @currentTimeframeDailyID = (SELECT company_schedule_timeframe_daily_id FROM cstd_company_schedule_timeframe_daily std INNER JOIN cstd_company_schedule_timeframe st ON st.company_schedule_timeframe_id = std.company_schedule_timeframe_id AND @ApptDate BETWEEN st.start_date AND st.end_date AND st.active = 'Y' INNER JOIN cstd_company_schedule s ON st.company_schedule_id = s.company_schedule_id AND s.company_id = @currentCompany WHERE std.day_of_week = @currentWeekday)

					IF @currentTimeframeDailyID IS NOT NULL
						BEGIN
							IF (SELECT status_code FROM cstd_company_schedule_timeframe_daily WHERE company_schedule_timeframe_daily_id = @currentTimeframeDailyID AND @ApptTimeString BETWEEN SUBSTRING(CONVERT(varchar(16),first_appointment,120),12,5) AND SUBSTRING(CONVERT(varchar(16),last_appointment,120),12,5)) = 'CLOSED'
								SET @NoAppts = 0
							ELSE
								BEGIN
									--First check if there's a global closure
									IF EXISTS (SELECT 1 FROM csta_global_closure WHERE closure_date = @ApptDate AND (@ApptTimeString NOT BETWEEN SUBSTRING(CONVERT(varchar(16),first_appointment,120),12,5) AND SUBSTRING(CONVERT(varchar(16),last_appointment,120),12,5) OR @ApptTimeString = SUBSTRING(CONVERT(varchar(16),last_appointment,120),12,5)))
										SET @NoAppts = 0
									ELSE
										BEGIN
											IF (SELECT status_code FROM cstd_company_schedule_timeframe_daily WHERE company_schedule_timeframe_daily_id = @currentTimeframeDailyID AND @ApptTimeString BETWEEN SUBSTRING(CONVERT(varchar(16),first_appointment,120),12,5) AND SUBSTRING(CONVERT(varchar(16),last_appointment,120),12,5)) = 'OPEN'
												BEGIN
													IF @UseHalfHour = 0
														SET @NoAppts = 	(SELECT hour_appointment FROM cstd_company_schedule_timeframe_daily WHERE company_schedule_timeframe_daily_id = @currentTimeframeDailyID)
													ELSE
														SET @NoAppts = 	(SELECT half_hour_appointment FROM cstd_company_schedule_timeframe_daily WHERE company_schedule_timeframe_daily_id = @currentTimeframeDailyID)

													--Also check the detail for the Daily schedule to see if the current hour is overridden
													IF EXISTS (SELECT 1 FROM cstd_company_schedule_timeframe_detail WHERE company_schedule_timeframe_daily_id = @currentTimeFrameDailyID AND SUBSTRING(CONVERT(varchar(16),appointment_time,120),12,5) = @ApptTimeString)
														SET @NoAppts = (SELECT appointment_number FROM cstd_company_schedule_timeframe_detail WHERE company_schedule_timeframe_daily_id = @currentTimeFrameDailyID AND SUBSTRING(CONVERT(varchar(16),appointment_time,120),12,5) = @ApptTimeString)
												END
										END
								END


						END
					ELSE
						BEGIN
							--If there's no daily schedule, Get the appts from the Base Schedule (cstd_company_schedule)

							--First check if there's a global closure
							IF EXISTS (SELECT 1 FROM csta_global_closure WHERE closure_date = @ApptDate AND (@ApptTimeString NOT BETWEEN SUBSTRING(CONVERT(varchar(16),first_appointment,120),12,5) AND SUBSTRING(CONVERT(varchar(16),last_appointment,120),12,5) OR @ApptTimeString = SUBSTRING(CONVERT(varchar(16),last_appointment,120),12,5)))
								SET @NoAppts = 0
							ELSE
								BEGIN
									IF @UseHalfHour = 0
										SET @NoAppts = (SELECT hour_appointment FROM cstd_company_schedule WHERE company_id = @currentCompany AND  @ApptTimeString BETWEEN SUBSTRING(CONVERT(varchar(16),first_appointment,120),12,5) AND SUBSTRING(CONVERT(varchar(16),last_appointment,120),12,5))
									ELSE
										SET @NoAppts = (SELECT half_hour_appointment FROM cstd_company_schedule WHERE company_id = @currentCompany AND  @ApptTimeString BETWEEN SUBSTRING(CONVERT(varchar(16),first_appointment,120),12,5) AND SUBSTRING(CONVERT(varchar(16),last_appointment,120),12,5))
								END
						END
				END
--IF @NoAppts IS NOT NULL
--BEGIN
--	IF @NoAppts > 0
--		PRINT @currentCompany + ' ' + ISNULL(@currentCenterCode,'BLANK     ') + ' ' + CONVERT(varchar(10),@ApptDate,120) + ' ' +@ApptTimeString + ' ' + CONVERT(varchar(10),@NoAppts)
--END
			IF @NoAppts > 0
				BEGIN
					INSERT INTO cstd_appointments_matrix(Center, ApptDate, ApptTime, Appts) VALUES (CONVERT(int,@currentCenterCode), CONVERT(varchar(10),@ApptDate,101),@ApptTimeString, @NoAppts )
				END
			SET @slotNumber = @slotNumber + 1
		END

		FETCH NEXT FROM pot_companies INTO @currentCompany,@currentCenterCode, @currentCenterTZCode
	END

	CLOSE pot_companies
	DEALLOCATE pot_companies

	SET @ApptDate = DATEADD(day,1,@ApptDate)

END -- DATE WHILE LOOP
GO
