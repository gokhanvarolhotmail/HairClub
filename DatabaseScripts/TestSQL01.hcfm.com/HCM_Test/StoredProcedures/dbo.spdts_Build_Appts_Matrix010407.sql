/* CreateDate: 01/04/2008 11:19:20.303 , ModifyDate: 05/01/2010 14:48:10.547 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spdts_Build_Appts_Matrix010407]
	@days INT --THis is really being fed as a parameter but we don't know how to open the job
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
SET @days = 28

-- this is the current appt date
DECLARE @ApptDate DATETIME
SET @ApptDate = CONVERT(varchar(10),GetDate(),120)

-- this is the last apptdate in the schedule
DECLARE @EndDate DATETIME
SET @EndDate = DateAdd(day, @days, GetDate())

-- this is the weekday associated with cst_closed day
DECLARE @Weekday int

/*
-- loop through each of the dates of the schedule
WHILE (@ApptDate <= @EndDate) BEGIN
	SET @Weekday = DATEPART(weekday, @ApptDate)

	-- this query will return all open centers for a particular weekday
	DECLARE matrix_curs CURSOR FOR
	SELECT territory
	,	CAST(LTRIM(RTRIM(start_time)) AS int) AS 'start_time'
	,	CAST(LTRIM(RTRIM(end_time)) AS int) AS 'end_time'
	,	CAST(Increments AS int) as 'Increments'
	, 	max_appt
	FROM cstd_company_scheduled_closure
	WHERE [day] = @Weekday
	AND closed_<> 'Y'
	AND max_appt > 0
	ORDER BY territory

	-- loop through each of the center records for each day
	OPEN matrix_curs
	WHILE (0 = 0) BEGIN
		FETCH NEXT FROM matrix_curs INTO @center, @starttime, @endtime, @increments, @maxappts

		IF (@@Fetch_Status <> 0) BREAK
		-- get the first appointment time
		SET @apptTime = @starttime
		-- hourly increment
			IF (@increments = 60) BEGIN
				SET @incrementer = 100
			END
			-- half hourly increment
			ELSE BEGIN
				SET @incrementer = 50
			END
		-- loop through the range of appttimes using the increments field as the incrementer
		WHILE (@apptTime <= @endtime) BEGIN
			-- we must insert the time as xx:00 format
			-- first cast it to a string
			SET @apptTime_string = CAST(@apptTime AS varchar)

			-- insert colon in the middle
			-- test if 900 or 930 etc
			IF LEN(@apptTime_string) = 3 BEGIN
				SET @apptTime_string = '0' + LEFT(@apptTime_string, 1) + ':' + RIGHT(RTRIM(@apptTime_string), 2)
							-- check to see if appts start on the half hour then set the time to :50
				IF RIGHT(RTRIM(@apptTime_string), 2) = '30' BEGIN
					SET @apptTime = STUFF(@apptTime, 2, 2, '50')
				END

			END
			ELSE BEGIN
				SET @apptTime_string = LEFT(@apptTime_string, 2) + ':' + RIGHT(RTRIM(@apptTime_string), 2)
							-- check to see if appts start on the half hour then set the time to :50
				IF RIGHT(RTRIM(@apptTime_string), 2) = '30' BEGIN
					SET @apptTime = STUFF(@apptTime, 3, 2, '50')
				END

			END

			-- if we are incrementing by 50 we need to show 30 minutes
			IF RIGHT(@apptTime_string, 2) = '50' BEGIN
				SET @apptTime_string = LEFT(@apptTime_string, 3) + '30'
			END

			-- now do the insert with the proper string
			INSERT INTO dbo.Appointments_Matrix (Center, ApptDate, ApptTime, Appts)
				VALUES (@center, Convert(char(10), @ApptDate, 101), @apptTime_string, @maxappts)

			-- hourly increment
			IF (@increments = 60) BEGIN
				SET @incrementer = 100
			END
			-- half hourly increment
			ELSE BEGIN
				SET @incrementer = 50
			END

			-- move to the next appointment
			SET @apptTime = @apptTime + @incrementer

		END -- apptTimes WHILE LOOP

	END -- CURSOR

	-- close and deallocate the cursor so it can be opened for the next loop
	CLOSE matrix_curs
	DEALLOCATE matrix_curs

	-- move to the next day -
	Set @ApptDate = DateAdd(day, 1, @ApptDate)

END -- DATE WHILE LOOP
*/

-- loop through each of the dates of the schedule
WHILE (@ApptDate <= @EndDate) BEGIN
	--Create a list of Companies that are potientially open on the current date (@ApptDate)
	DECLARE @currentCompany varchar(10)
	DECLARE @currentCenterCode varchar(10)

	DECLARE pot_companies CURSOR FOR
	SELECT cstd_company_schedule.company_id, cst_center_number FROM cstd_company_schedule
		INNER JOIN oncd_company ON oncd_company.company_id = cstd_company_schedule.company_id
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
	FETCH NEXT FROM pot_companies INTO @currentCompany, @currentCenterCode

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

		FETCH NEXT FROM pot_companies INTO @currentCompany,@currentCenterCode
	END

	CLOSE pot_companies
	DEALLOCATE pot_companies

	SET @ApptDate = DATEADD(day,1,@ApptDate)

END -- DATE WHILE LOOP
GO
