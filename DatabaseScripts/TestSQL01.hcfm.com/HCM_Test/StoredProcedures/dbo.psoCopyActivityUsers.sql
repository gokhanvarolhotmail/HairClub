/* CreateDate: 01/03/2013 10:22:39.173 , ModifyDate: 01/03/2013 10:22:39.173 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 29 October 2012
-- Description:	Copies the Activity User records from one Activity to
--				another Activity.
-- =============================================
CREATE PROCEDURE [dbo].[psoCopyActivityUsers]
	@OriginalActivityId	NCHAR(10),	-- The Activity to copy the assigned Users from.
	@NewActivityId		NCHAR(10),	-- The Activity to copy the assigned Users to.
	@UserCode			NCHAR(20)	-- The User to create the Activity User records.
AS
BEGIN
	DECLARE @ActivityUserId NCHAR(10)
	DECLARE @User NCHAR(20)
	DECLARE @Attendance NCHAR(1)
	DECLARE @SortOrder INT
	DECLARE @PrimaryFlag NCHAR(1)

	DECLARE activityUserCursor CURSOR FOR
		SELECT user_code, attendance, sort_order, primary_flag
		FROM oncd_activity_user
		WHERE activity_id = @OriginalActivityId

	OPEN activityUserCursor

	FETCH NEXT FROM activityUserCursor
	INTO @User, @Attendance, @SortOrder, @PrimaryFlag

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		EXEC onc_create_primary_key 10, 'oncd_activity_user', 'activity_user_id', @ActivityUserId OUTPUT, ''

		INSERT INTO oncd_activity_user(
			activity_user_id,
			activity_id,
			user_code,
			assignment_date,
			attendance,
			sort_order,
			creation_date,
			created_by_user_code,
			updated_date,
			updated_by_user_code,
			primary_flag)
		VALUES(
			@ActivityUserId,
			@NewActivityId,
			@User,
			GETDATE(),
			@Attendance,
			@SortOrder,
			GETDATE(),
			@UserCode,
			GETDATE(),
			@UserCode,
			@PrimaryFlag)

		FETCH NEXT FROM activityUserCursor
		INTO @User, @Attendance, @SortOrder, @PrimaryFlag
	END
	CLOSE activityUserCursor
	DEALLOCATE activityUserCursor
END
GO
