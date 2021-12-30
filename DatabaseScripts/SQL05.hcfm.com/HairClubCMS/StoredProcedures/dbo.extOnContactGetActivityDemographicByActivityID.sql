/* CreateDate: 12/11/2012 14:57:18.693 , ModifyDate: 12/11/2012 14:57:18.693 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactGetActivityDemographicByActivityID

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
		* 5/7/2010 PRM - New stored proc

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactGetActivityDemographicByActivityID
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactGetActivityDemographicByActivityID]
(
	@ActivityID varchar(50)
)
AS
  BEGIN
    SET NOCOUNT ON

    SELECT activity_demographic_id, activity_id, gender, birthday, occupation_code, ethnicity_code, maritalstatus_code, norwood, ludwig, age, creation_date, created_by_user_code, updated_date, updated_by_user_code, performer, price_quoted, solution_offered, no_sale_reason
    FROM HCMSkylineTest..cstd_activity_demographic
    WHERE activity_id = @ActivityID
  END
GO
