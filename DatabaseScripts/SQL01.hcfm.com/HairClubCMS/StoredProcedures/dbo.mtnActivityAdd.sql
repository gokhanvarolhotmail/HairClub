/***********************************************************************

PROCEDURE:				mtnActivityAdd

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		11/02/15

LAST REVISION DATE: 	03/09/16

--------------------------------------------------------------------------------------------------------
NOTES: 	Adds a new activity to the database.

		* 11/02/2015 SAL - Created.
		* 03/04/2016 SAL - Removed IsOnHold and added ActivityStatusID
		* 03/08/2016 SAL - Removed ActivityStatusID and added back in IsOnHold
		* 03/09/2016 SAL - Removed IsOnHold and added back in ActivityStatusID

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnActivityAdd null, '3D5BC35B-F7AE-4AAA-84DD-C4F2AB82F4D5', null, 1, null, '11/02/2015', 2, 'This is my note.', 'C6A24555-FB7D-49BF-A9FD-475EBFDA362C', '54905628-47F8-40A1-B7D5-CA828DF01392', null, null, 'sal', 3

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnActivityAdd]
	  @MasterActivityID int = null
	, @ClientGUID uniqueidentifier
	, @ActivitySubCategoryID int = null
	, @ActivityActionID int
	, @ActivityResultID int = null
	, @DueDate datetime
	, @ActivityPriorityID int
	, @ActivityNote varchar(max)
	, @CreatedByEmployeeGUID uniqueidentifier
	, @AssignedToEmployeeGUID uniqueidentifier
	, @CompletedByEmployeeGUID uniqueidentifier = null
	, @CompletedDate datetime = null
	, @User nvarchar(25)
	, @ActivityStatusID int
AS
BEGIN

	SET NOCOUNT ON;

	--INSERT Activity record
	INSERT INTO datActivity
			(MasterActivityID
			,ClientGUID
			,ActivitySubCategoryID
			,ActivityActionID
			,ActivityResultID
			,DueDate
			,ActivityPriorityID
			,ActivityNote
			,CreatedByEmployeeGUID
			,AssignedToEmployeeGUID
			,CompletedByEmployeeGUID
			,CompletedDate
			,CreateDate
			,CreateUser
			,LastUpdate
			,LastUpdateUser
			,ActivityStatusID)
	VALUES	(@MasterActivityID
			,@ClientGUID
			,@ActivitySubCategoryID
			,@ActivityActionID
			,@ActivityResultID
			,@DueDate
			,@ActivityPriorityID
			,@ActivityNote
			,@CreatedByEmployeeGUID
			,@AssignedToEmployeeGUID
			,@CompletedByEmployeeGUID
			,@CompletedDate
			,GETUTCDATE()
			,@User
			,GETUTCDATE()
			,@User
			,@ActivityStatusID)
END
