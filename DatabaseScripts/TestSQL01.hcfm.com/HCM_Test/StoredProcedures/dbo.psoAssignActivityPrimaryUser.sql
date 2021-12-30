/* CreateDate: 01/03/2013 10:22:39.180 , ModifyDate: 01/03/2013 10:22:39.180 */
GO
-- =============================================
-- Create date: 29 October 2012
-- Description:	Assigns the provided User to the provided Activity as the primary Activity User.
-- =============================================
CREATE PROCEDURE [dbo].[psoAssignActivityPrimaryUser]
	 @ActivityId	NCHAR(10) -- The Activity to add the User to.
	,@UserCode		NCHAR(20) -- The User that should be assigned to the Activity.
AS
BEGIN
	UPDATE oncd_activity_user
	SET primary_flag = 'N'
	WHERE
	activity_id = @ActivityId AND
	user_code <> @UserCode

	IF (NOT EXISTS (SELECT 1
					FROM oncd_activity_user
					WHERE
					activity_id = @ActivityId AND
					user_code = @UserCode))
	BEGIN
		EXEC psoCreateActivityUser @ActivityId, @UserCode, 'Y'
	END
	ELSE
	BEGIN
		UPDATE oncd_activity_user
		SET primary_flag = 'Y'
		WHERE
		activity_id = @ActivityId AND
		user_code = @UserCode
	END
END
GO
