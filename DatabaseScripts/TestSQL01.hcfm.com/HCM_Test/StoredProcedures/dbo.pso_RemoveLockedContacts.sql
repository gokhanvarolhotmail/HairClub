/* CreateDate: 07/14/2010 15:37:15.250 , ModifyDate: 07/14/2010 15:37:15.250 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================
-- Create date: 7 July 2010
-- Description:	Removes the lock on all of the provided user's locked Contacts.
-- =============================================================================
CREATE PROCEDURE pso_RemoveLockedContacts
	@LockingUserCode NCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE cstd_contact_salon
	SET locked_by_user_code = NULL
	WHERE locked_by_user_code = @LockingUserCode

END
GO
