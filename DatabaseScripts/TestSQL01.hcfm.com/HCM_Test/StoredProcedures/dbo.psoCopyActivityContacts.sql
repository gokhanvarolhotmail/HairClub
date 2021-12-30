/* CreateDate: 01/03/2013 10:22:39.163 , ModifyDate: 01/03/2013 10:22:39.163 */
GO
-- =============================================
-- Create date: 29 October 2012
-- Description:	Copies the Activity Contact records from one Activity to
--				another Activity.
-- =============================================
CREATE PROCEDURE [dbo].[psoCopyActivityContacts]
	@OriginalActivityId	NCHAR(10),	-- The Activity to copy the assigned Contacts from.
	@NewActivityId		NCHAR(10),	-- The Activity to copy the assigned Contacts to.
	@UserCode			NCHAR(20)	-- The User to create the Activity Contact records.
AS
BEGIN
	DECLARE @ActivityContactId NCHAR(10)
	DECLARE @ContactId NCHAR(10)
	DECLARE @Attendance NCHAR(1)
	DECLARE @SortOrder INT
	DECLARE @PrimaryFlag NCHAR(1)

	DECLARE activityContactCursor CURSOR FOR
		SELECT contact_id, attendance, sort_order, primary_flag
		FROM oncd_activity_contact
		WHERE activity_id = @OriginalActivityId

	OPEN activityContactCursor
	FETCH NEXT FROM activityContactCursor
	INTO @ContactId, @Attendance, @SortOrder, @PrimaryFlag

	WHILE (@@fetch_status = 0)
	BEGIN
		EXEC onc_create_primary_key 10, 'oncd_activity_contact', 'activity_contact_id', @ActivityContactId OUTPUT, ''

		IF(ISNULL(@Attendance, ' ') = ' ')
			SET @Attendance = 'Y'

		IF(ISNULL(@SortOrder, ' ') = ' ')
			SET @SortOrder = 1

		IF(ISNULL(@PrimaryFlag, ' ') = ' ')
			SET @PrimaryFlag = 'N'

		INSERT INTO oncd_activity_contact(
			activity_contact_id,
			activity_id,
			contact_id,
			assignment_date,
			attendance,
			sort_order,
			creation_date,
			created_by_user_code,
			updated_date,
			updated_by_user_code,
			primary_flag)
		VALUES(
			@ActivityContactId,
			@NewActivityId,
			@ContactId,
			GETDATE(),
			@Attendance,
			@SortOrder,
			GETDATE(),
			@UserCode,
			GETDATE(),
			@UserCode,
			@PrimaryFlag)

		FETCH NEXT FROM activityContactCursor
		INTO @ContactId, @Attendance, @SortOrder, @PrimaryFlag
	END
	CLOSE activityContactCursor
	DEALLOCATE activityContactCursor
END
GO
