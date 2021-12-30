/* CreateDate: 12/11/2012 14:57:18.727 , ModifyDate: 12/11/2012 14:57:18.727 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactGetCompletionDate

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
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_GetCompletionDate

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactGetCompletionDate 'SZXC21JFI1'
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactGetCompletionDate]
(
	@ActivityID varchar(50)
)
AS
  BEGIN
    SET NOCOUNT ON

    SELECT ISNULL(CONVERT(varchar(10), completion_date, 101), '') AS 'completion_date'
    FROM HCMSkylineTest..oncd_activity
    WHERE activity_id = @ActivityID
  END
GO
