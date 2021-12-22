/* CreateDate: 05/24/2007 10:53:30.783 , ModifyDate: 05/01/2010 14:48:10.887 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Oncontact PSO Fred Remers
-- Create date: 4/26/07
-- Description:	Check for global closings based on the date passed in.
--				return T or F for true/false
-- =============================================
CREATE PROCEDURE [dbo].[spapp_IsCenterOpen] (
	@date_in datetime,
	@is_open char(1) output
)
AS

BEGIN
	SET NOCOUNT ON;
	DECLARE @closure_date datetime
	DECLARE @first_appointment datetime
	DECLARE @last_appointment datetime

	SET @is_open = 'T'
	SET @date_in = convert(char(10),@date_in,101)
	--insert into cstd_fred_log (val) values('In SP - date in: ' + convert(char(10),@date_in,101))

	--PRINT 'Date In: '
	--print @date_in
	IF (select count(*) from csta_global_closure where closure_date = @date_in) > 0
	BEGIN
		--insert into cstd_fred_log (val) values('closure record found ')
		--Print 'closure record found'
		DECLARE cursor_global_closures CURSOR FOR
			select closure_date, first_appointment, last_appointment from csta_global_closure
			where csta_global_closure.closure_date = @date_in

		OPEN cursor_global_closures
		FETCH NEXT FROM cursor_global_closures INTO @closure_date, @first_appointment, @last_appointment
		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			--print 'First:' + convert(varchar(20),@first_appointment)
			--print 'Last:' + convert(varchar(20),@last_appointment)
			IF(convert(varchar(20),@first_appointment,14) >= convert(varchar(20),@last_appointment,14))
				SET @is_open = 'F'
			ELSE IF (@first_appointment is null or @last_appointment is null)
				SET @is_open = 'F'
			ELSE
				SET @is_open = 'T'

			FETCH NEXT FROM cursor_global_closures INTO @closure_date, @first_appointment, @last_appointment
		END --(@@FETCH_STATUS = 0)
		--PRINT 'Is Open: '
		--PRINT @is_open
		CLOSE cursor_global_closures
		DEALLOCATE cursor_global_closures
	--ELSE
		--insert into cstd_fred_log (val) values('closure record NOT found -> return to trigger')
	END --IF (select count(*) from csta_global_closure where closure_date = @date_in) > 0
END
GO
