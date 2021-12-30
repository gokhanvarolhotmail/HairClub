/* CreateDate: 01/03/2013 10:22:38.807 , ModifyDate: 01/03/2013 10:22:38.807 */
GO
-- =============================================
-- Create date: 29 October 2012
-- Description:	Creates a new Activity User record for the provided Activity and User.
-- =============================================
CREATE PROCEDURE [dbo].[psoCreateActivityUser]
	@ActivityId		NCHAR(10),	-- The Activity to assign the User to.
	@UserCode		NCHAR(20),	-- The User to assign to the Activity.
	@PrimaryFlag	NCHAR(1)	-- The Primary Flag of the Activity User record.
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ActivityUserId	NCHAR(10)
	DECLARE @SortOrder		INT

	SET @PrimaryFlag = ISNULL(@PrimaryFlag, 'N')

	IF (@PrimaryFlag = 'Y')
	BEGIN
		UPDATE oncd_activity_user
		SET primary_flag = 'N'
		WHERE
		activity_id = @ActivityId
	END

	SET @SortOrder = (	SELECT
						MAX(sort_order)
						FROM oncd_activity_user
						WHERE
						activity_id = @ActivityId)
	SET @SortOrder = @SortOrder + 1

	EXEC onc_create_primary_key 10, 'oncd_activity_user', 'activity_user_id', @ActivityUserId OUTPUT, 'TRG'

	INSERT INTO oncd_activity_user(
		activity_user_id,
		activity_id,
		user_code,
		assignment_date,
		attendance,
		sort_order,
		creation_date,
		created_by_user_code,
		primary_flag)
	VALUES(
		@ActivityUserId,
		@ActivityId,
		@UserCode,
		GETDATE(),
		'N',
		@SortOrder,
		GETDATE(),
		@UserCode,
		@PrimaryFlag)
END
GO
