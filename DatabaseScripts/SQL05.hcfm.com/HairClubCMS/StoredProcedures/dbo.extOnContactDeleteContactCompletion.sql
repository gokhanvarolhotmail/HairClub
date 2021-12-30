/* CreateDate: 12/11/2012 14:57:18.663 , ModifyDate: 12/11/2012 14:57:18.663 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactDeleteContactCompletion

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Dominic Leiba

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 7/29/2008

LAST REVISION DATE: 	 5/7/2010

==============================================================================
DESCRIPTION:	Interface with OnContact database
==============================================================================
NOTES:
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_DeleteContactCompletion

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactDeleteContactCompletion '4YS150DITC', 'C2VOGIIITC'
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactDeleteContactCompletion]
(
	@ContactID varchar(50),
	@ActivityID varchar(50)
)
AS
BEGIN TRANSACTION

	DELETE FROM HCMSkylineTest..cstd_contact_completion
	WHERE contact_id = @ContactID AND activity_id = @ActivityID

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

COMMIT TRANSACTION
GO
