/* CreateDate: 09/04/2007 09:33:29.947 , ModifyDate: 05/01/2010 14:48:10.920 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Oncontact PSO Fred Remers
-- Create date: 	8/21/07
-- Description:		Find invalid schedules for centers and print to screen
-- =============================================
CREATE PROCEDURE [dbo].[spapp_FindInvalidCenterSchedules]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @company_id nchar(10)
	DECLARE @company_name_1 nchar(100)
	DECLARE @company_schedule_id nchar(10)
	DECLARE @company_schedule_timeframe_id nchar(10)
	DECLARE @first_appointment datetime
	DECLARE @last_appointment datetime
	DECLARE @day_of_week nchar(1)
	DECLARE @day_of_week_text nchar(19)
	DECLARE @company_schedule_timeframe_daily_id nchar(10)
	DECLARE @appointment_time datetime
	DECLARE @start_date datetime
	DECLARE @end_date datetime
	DECLARE @company_schedule_timeframe_detail_id nchar(10)

 	declare no_schedule_cursor cursor for select company_name_1, company_id from oncd_company where not exists(select company_schedule_id from cstd_company_schedule where cstd_company_schedule.company_id = oncd_company.company_id)
 	open no_schedule_cursor
 	fetch next from no_schedule_cursor into @company_name_1, @company_id
 	while (@@FETCH_STATUS = 0)
 	BEGIN
		if(isnull(@company_name_1,' ') = ' ')
			SET @company_name_1 = 'CENTER NAME DOES NOT EXISTS IN DATABASE FOR THIS CENTER'
 		PRINT 'Company Id: ' + @company_id + ' ' + RTRIM(@company_name_1) + ' does not have a schedule setup'
		print '----------------------------------'
 		fetch next from no_schedule_cursor into @company_name_1, @company_id
 	END
	CLOSE no_schedule_cursor
	DEALLOCATE no_schedule_cursor

	DECLARE company_cursor cursor for select company_id, company_name_1 from oncd_company
	OPEN company_cursor
	FETCH NEXT FROM company_cursor into @company_id, @company_name_1
	WHILE ( @@fetch_status = 0)
	BEGIN
		--print @company_name_1
		--print @company_id
		--print '-------------'
		DECLARE company_schedule_cursor cursor for select company_schedule_id from cstd_company_schedule where company_id = @company_id
		OPEN company_schedule_cursor
		FETCH NEXT FROM company_schedule_cursor into @company_schedule_id
		WHILE ( @@fetch_status = 0)
		BEGIN
			--print @company_schedule_id
			DECLARE company_schedule_timeframe_cursor cursor for select company_schedule_timeframe_id, start_date, end_date from cstd_company_schedule_timeframe where company_schedule_id = @company_schedule_id
			OPEN company_schedule_timeframe_cursor
			FETCH NEXT FROM company_schedule_timeframe_cursor into @company_schedule_timeframe_id, @start_date, @end_date
			WHILE (@@fetch_status = 0)
			BEGIN
				DECLARE cstd_company_schedule_timeframe_daily cursor for select company_schedule_timeframe_daily_id, day_of_week, first_appointment, last_appointment from cstd_company_schedule_timeframe_daily where company_schedule_timeframe_id = @company_schedule_timeframe_id and status_code = 'OPEN' order by day_of_week
				OPEN cstd_company_schedule_timeframe_daily
				FETCH NEXT FROM cstd_company_schedule_timeframe_daily into @company_schedule_timeframe_daily_id, @day_of_week, @first_appointment, @last_appointment
				WHILE (@@fetch_status = 0)
				BEGIN
				    if(@day_of_week = '7')
						SET @day_of_week_text = 'Monday'
					else if (@day_of_week = '1')
						SET @day_of_week_text = 'Tuesday'
					else if (@day_of_week = '2')
						SET @day_of_week_text = 'Wednesday'
					else if (@day_of_week = '3')
						SET @day_of_week_text = 'Thursday'
					else if (@day_of_week = '4')
						SET @day_of_week_text = 'Friday'
					else if (@day_of_week = '5')
						SET @day_of_week_text = 'Saturday'
					else if (@day_of_week = '6')
						SET @day_of_week_text = 'Sunday'
					else
						SET @day_of_week_text = 'Unknown day of week'

					DECLARE company_schedule_timeframe_detail cursor for select company_schedule_timeframe_detail_id, appointment_time from cstd_company_schedule_timeframe_detail where company_schedule_timeframe_daily_id = @company_schedule_timeframe_daily_id order by appointment_time
					OPEN company_schedule_timeframe_detail
					FETCH NEXT FROM company_schedule_timeframe_detail into @company_schedule_timeframe_detail_id,@appointment_time
					WHILE (@@fetch_status = 0)
					BEGIN
						if(DatePart(hh,@appointment_time) < DatePart(hh,@first_appointment))
						BEGIN
							print @company_name_1
							print 'Appointment time is before first appointment allowed on ' + LTRIM(RTRIM(@day_of_week_text)) + ' for schedule starting on ' + LTRIM(RTRIM(convert(char(20),@start_date,1))) + ' and ending on ' + LTRIM(RTRIM(convert(char(20),@end_date,1)))
							print 'Appointment Time:'
							print RIGHT(@appointment_time,8)
							print 'First Appointment Allowed:'
							print RIGHT(@first_appointment,8)
							print '----------------------------------'
							delete from cstd_company_schedule_timeframe_detail where company_schedule_timeframe_detail_id = @company_schedule_timeframe_detail_id
						END
						else if( DatePart(hh,@appointment_time) <= DatePart(hh,@first_appointment) and DatePart(mi,@appointment_time) < DatePart(mi,@first_appointment))
						BEGIN
							print @company_name_1
							print 'Appointment time is before first appointment allowed on ' + LTRIM(RTRIM(@day_of_week_text)) + ' for schedule starting on ' + LTRIM(RTRIM(convert(char(20),@start_date,1))) + ' and ending on ' + LTRIM(RTRIM(convert(char(20),@end_date,1)))
							print 'Appointment Time:'
							print RIGHT(@appointment_time,8)
							print 'First Appointment Allowed:'
							print RIGHT(@first_appointment,8)
							print '----------------------------------'
							delete from cstd_company_schedule_timeframe_detail where company_schedule_timeframe_detail_id = @company_schedule_timeframe_detail_id
						END
						else if(DatePart(hh,@appointment_time) > DatePart(hh,@last_appointment))
						BEGIN
							print @company_name_1
							print 'Appointment time is after last appointment allowed on ' + LTRIM(RTRIM(@day_of_week_text)) + ' for schedule starting on ' + LTRIM(RTRIM(convert(char(20),@start_date,1))) + ' and ending on ' + LTRIM(RTRIM(convert(char(20),@end_date,1)))
							print 'Appointment Time:'
							print RIGHT(@appointment_time,8)
							print 'Last Appointment Allowed:'
							print RIGHT(@last_appointment,8)
							print '----------------------------------'
							delete from cstd_company_schedule_timeframe_detail where company_schedule_timeframe_detail_id = @company_schedule_timeframe_detail_id
						END
						else if( DatePart(hh,@appointment_time) >= DatePart(hh,@last_appointment) and DatePart(mi,@appointment_time) > DatePart(mi,@last_appointment))
						BEGIN
							print @company_name_1
							print 'Appointment time is after last appointment allowed on ' + LTRIM(RTRIM(@day_of_week_text)) + ' for schedule starting on ' + LTRIM(RTRIM(convert(char(20),@start_date,1))) + ' and ending on ' + LTRIM(RTRIM(convert(char(20),@end_date,1)))
							print 'Appointment Time:'
							print RIGHT(@appointment_time,8)
							print 'Last Appointment Allowed:'
							print RIGHT(@last_appointment,8)
							print '----------------------------------'
							delete from cstd_company_schedule_timeframe_detail where company_schedule_timeframe_detail_id = @company_schedule_timeframe_detail_id
						END

					FETCH NEXT FROM company_schedule_timeframe_detail into @company_schedule_timeframe_detail_id,@appointment_time

					END
					CLOSE company_schedule_timeframe_detail
					DEALLOCATE company_schedule_timeframe_detail

				FETCH NEXT FROM cstd_company_schedule_timeframe_daily into @company_schedule_timeframe_daily_id, @day_of_week, @first_appointment, @last_appointment
				END
				CLOSE cstd_company_schedule_timeframe_daily
				DEALLOCATE cstd_company_schedule_timeframe_daily
			FETCH NEXT FROM company_schedule_timeframe_cursor into @company_schedule_timeframe_id, @start_date, @end_date
			END
			CLOSE company_schedule_timeframe_cursor
			DEALLOCATE company_schedule_timeframe_cursor

			FETCH NEXT FROM company_schedule_cursor into @company_schedule_id
		END
		CLOSE company_schedule_cursor
		DEALLOCATE company_schedule_cursor

		FETCH NEXT FROM company_cursor into @company_id, @company_name_1
	END
	CLOSE company_cursor
	DEALLOCATE company_cursor

	DECLARE company_cursor cursor for select company_id, company_name_1 from oncd_company
	OPEN company_cursor
	FETCH NEXT FROM company_cursor into @company_id, @company_name_1
	WHILE ( @@fetch_status = 0)
	BEGIN
		DECLARE company_schedule_cursor cursor for select company_schedule_id from cstd_company_schedule where company_id = @company_id
		OPEN company_schedule_cursor
		FETCH NEXT FROM company_schedule_cursor into @company_schedule_id
		WHILE ( @@fetch_status = 0)
		BEGIN
			DECLARE company_schedule_timeframe_cursor cursor for select company_schedule_timeframe_id, start_date, end_date from cstd_company_schedule_timeframe where company_schedule_id = @company_schedule_id
			OPEN company_schedule_timeframe_cursor
			FETCH NEXT FROM company_schedule_timeframe_cursor into @company_schedule_timeframe_id, @start_date, @end_date
			WHILE (@@fetch_status = 0)
			BEGIN
				DECLARE cstd_company_schedule_timeframe_daily cursor for select company_schedule_timeframe_daily_id, day_of_week, first_appointment, last_appointment from cstd_company_schedule_timeframe_daily where company_schedule_timeframe_id = @company_schedule_timeframe_id order by day_of_week
				OPEN cstd_company_schedule_timeframe_daily
				FETCH NEXT FROM cstd_company_schedule_timeframe_daily into @company_schedule_timeframe_daily_id, @day_of_week, @first_appointment, @last_appointment
				WHILE (@@fetch_status = 0)
				BEGIN
				    if(@day_of_week = '7')
						SET @day_of_week_text = 'Monday'
					else if (@day_of_week = '1')
						SET @day_of_week_text = 'Tuesday'
					else if (@day_of_week = '2')
						SET @day_of_week_text = 'Wednesday'
					else if (@day_of_week = '3')
						SET @day_of_week_text = 'Thursday'
					else if (@day_of_week = '4')
						SET @day_of_week_text = 'Friday'
					else if (@day_of_week = '5')
						SET @day_of_week_text = 'Saturday'
					else if (@day_of_week = '6')
						SET @day_of_week_text = 'Sunday'
					else
						SET @day_of_week_text = 'Unknown day of week'

					DECLARE company_schedule_timeframe_detail cursor for select appointment_time from cstd_company_schedule_timeframe_detail where company_schedule_timeframe_daily_id = @company_schedule_timeframe_daily_id order by appointment_time
					OPEN company_schedule_timeframe_detail
					FETCH NEXT FROM company_schedule_timeframe_detail into @appointment_time
					--WHILE (@@fetch_status = 0)
					BEGIN
						if(DatePart(hh,@appointment_time) > DatePart(hh,@first_appointment))
						BEGIN
							print @company_name_1
							print 'Appointment slots are missing at begining of day on ' + LTRIM(RTRIM(@day_of_week_text)) + ' for schedule starting on ' + LTRIM(RTRIM(convert(char(20),@start_date,1))) + ' and ending on ' + LTRIM(RTRIM(convert(char(20),@end_date,1)))
							print '----------------------------------'
						END
						else if( DatePart(hh,@appointment_time) >= DatePart(hh,@first_appointment) and DatePart(mi,@appointment_time) > DatePart(mi,@first_appointment))
						BEGIN
							print @company_name_1
							print 'Appointment slots are missing at begining of day on ' + LTRIM(RTRIM(@day_of_week_text)) + ' for schedule starting on ' + LTRIM(RTRIM(convert(char(20),@start_date,1))) + ' and ending on ' + LTRIM(RTRIM(convert(char(20),@end_date,1)))
							print '----------------------------------'
						END
						--FETCH NEXT FROM company_schedule_timeframe_detail into @appointment_time
					END
					CLOSE company_schedule_timeframe_detail
					DEALLOCATE company_schedule_timeframe_detail

					DECLARE company_schedule_timeframe_detail2 cursor for select appointment_time from cstd_company_schedule_timeframe_detail where company_schedule_timeframe_daily_id = @company_schedule_timeframe_daily_id order by appointment_time desc
					OPEN company_schedule_timeframe_detail2
					FETCH NEXT FROM company_schedule_timeframe_detail2 into @appointment_time
					--WHILE (@@fetch_status = 0)
					BEGIN
						if(DatePart(hh,@appointment_time) < DatePart(hh,@last_appointment))
						BEGIN
							print @company_name_1
							print 'Appointment slots are missing at end of day on ' + LTRIM(RTRIM(@day_of_week_text)) + ' for schedule starting on ' + LTRIM(RTRIM(convert(char(20),@start_date,1))) + ' and ending on ' + LTRIM(RTRIM(convert(char(20),@end_date,1)))
							print '----------------------------------'
						END
						else if( DatePart(hh,@appointment_time) <= DatePart(hh,@last_appointment) and DatePart(mi,@appointment_time) < DatePart(mi,@last_appointment))
						BEGIN
							print @company_name_1
							print 'Appointment slots are missing at end of day on ' + LTRIM(RTRIM(@day_of_week_text)) + ' for schedule starting on ' + LTRIM(RTRIM(convert(char(20),@start_date,1))) + ' and ending on ' + LTRIM(RTRIM(convert(char(20),@end_date,1)))
							print '----------------------------------'
						END

						--FETCH NEXT FROM company_schedule_timeframe_detail into @appointment_time
					END
					CLOSE company_schedule_timeframe_detail2
					DEALLOCATE company_schedule_timeframe_detail2

				FETCH NEXT FROM cstd_company_schedule_timeframe_daily into @company_schedule_timeframe_daily_id, @day_of_week, @first_appointment, @last_appointment
				END
				CLOSE cstd_company_schedule_timeframe_daily
				DEALLOCATE cstd_company_schedule_timeframe_daily
			FETCH NEXT FROM company_schedule_timeframe_cursor into @company_schedule_timeframe_id, @start_date, @end_date
			END
			CLOSE company_schedule_timeframe_cursor
			DEALLOCATE company_schedule_timeframe_cursor

			FETCH NEXT FROM company_schedule_cursor into @company_schedule_id
		END
		CLOSE company_schedule_cursor
		DEALLOCATE company_schedule_cursor

		FETCH NEXT FROM company_cursor into @company_id, @company_name_1
	END
	CLOSE company_cursor
	DEALLOCATE company_cursor

END
GO
