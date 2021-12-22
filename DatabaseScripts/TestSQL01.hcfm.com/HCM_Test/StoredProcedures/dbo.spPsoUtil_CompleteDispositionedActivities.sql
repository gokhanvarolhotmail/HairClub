/* CreateDate: 11/26/2007 11:15:46.647 , ModifyDate: 05/01/2010 14:48:10.083 */
GO
-- =============================================
-- Author:			Oncontact PSO Fred Remers
-- Create date: 	11/16/07
-- Description:		Update completion_date, completion_time, completed_by_user_code
--					for disposioned activities where these fields are null.
--					Use updated_date if populated, else use creation_date.
--					Maintain original completed_by_user_code if exists. Else, ADMIN
-- =============================================
-- Altered By:		Oncontact PSO Toby Clubb
-- Altered Date:	11/30/2007
-- Description:		Updated to use updated_by_user_code then created_by_user_ocde then ADMIN
--					for completed_by_user_code if it is null

CREATE PROCEDURE [dbo].[spPsoUtil_CompleteDispositionedActivities]
AS
BEGIN
	DECLARE @activity_id nchar(10)
	DECLARE @updated_date datetime
	DECLARE @creation_date datetime
	DECLARE @completed_by_user_code nchar(20)
	DECLARE @updated_by_user_code nchar(20)
	DECLARE @created_by_user_code nchar(20)

	CREATE NONCLUSTERED INDEX [oncd_activity_tmp_idx1] ON [dbo].[oncd_activity]
	(
				[completion_date]ASC
	)
	CREATE NONCLUSTERED INDEX [oncd_activity_tmp_idx2] ON [dbo].[oncd_activity]
	(
				[completion_time]ASC
	)

	CREATE NONCLUSTERED INDEX [oncd_activity_tmp_idx3] ON [dbo].[oncd_activity]
	(
				[result_code]ASC
	)

	DECLARE expCursor cursor for
	select activity_id, updated_date, creation_date, completed_by_user_code, updated_by_user_code, created_by_user_code from oncd_activity
	where result_code is not null
		and (completion_date is null or completion_time is null)
		and creation_date >= '10/17/2007 00:00:00'



	OPEN expCursor
	FETCH NEXT FROM expCursor INTO @activity_id, @updated_date, @creation_date, @completed_by_user_code, @updated_by_user_code, @created_by_user_code
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (isnull(@updated_date,'') = '')
		BEGIN
			IF (isnull(@completed_by_user_code,'') = '')
			BEGIN
				IF (isnull(@updated_by_user_code,'') = '')
				BEGIN
					IF (isnull(@created_by_user_code,'') = '')
					BEGIN
						update oncd_activity set
							completion_date = dbo.CombineDates(creation_date,null),
							completion_time = dbo.CombineDates(null,creation_date),
							completed_by_user_code = 'ADMINISTRATOR'
						where activity_id = @activity_id
					END
					ELSE
					BEGIN
						update oncd_activity set
							completion_date = dbo.CombineDates(creation_date,null),
							completion_time = dbo.CombineDates(null,creation_date),
							completed_by_user_code = @created_by_user_code
						where activity_id = @activity_id
					END
				END
				ELSE
				BEGIN
					update oncd_activity set
						completion_date = dbo.CombineDates(creation_date,null),
						completion_time = dbo.CombineDates(null,creation_date),
						completed_by_user_code = @updated_by_user_code
					where activity_id = @activity_id
				END
			END
			ELSE
			BEGIN
				update oncd_activity set
					completion_date = dbo.CombineDates(creation_date,null),
					completion_time = dbo.CombineDates(null,creation_date)
				where activity_id = @activity_id
			END

		END
		ELSE
		BEGIN
			IF (isnull(@completed_by_user_code,'') = '')
			BEGIN
				IF (isnull(@updated_by_user_code,'') = '')
				BEGIN
					IF (isnull(@created_by_user_code,'') = '')
					BEGIN
						update oncd_activity set
							completion_date = dbo.CombineDates(updated_date,null),
							completion_time = dbo.CombineDates(null,updated_date),
							completed_by_user_code = 'ADMINISTRATOR'
						where activity_id = @activity_id
					END
					ELSE
					BEGIN
						update oncd_activity set
							completion_date = dbo.CombineDates(updated_date,null),
							completion_time = dbo.CombineDates(null,updated_date),
							completed_by_user_code = @created_by_user_code
						where activity_id = @activity_id
					END
				END
				ELSE
				BEGIN
					update oncd_activity set
						completion_date = dbo.CombineDates(updated_date,null),
						completion_time = dbo.CombineDates(null,updated_date),
						completed_by_user_code = @updated_by_user_code
					where activity_id = @activity_id
				END
			END
			ELSE
			BEGIN
				update oncd_activity set
					completion_date = dbo.CombineDates(updated_date,null),
					completion_time = dbo.CombineDates(null,updated_date)
				where activity_id = @activity_id
			END

		END
		FETCH NEXT FROM expCursor INTO @activity_id, @updated_date, @creation_date, @completed_by_user_code, @updated_by_user_code, @created_by_user_code
	END
	CLOSE expCursor
	DEALLOCATE expCursor
	DROP INDEX[dbo].[oncd_activity] .[oncd_activity_tmp_idx1]
	DROP INDEX[dbo].[oncd_activity] .[oncd_activity_tmp_idx2]
	DROP INDEX[dbo].[oncd_activity] .[oncd_activity_tmp_idx3]

END
GO
