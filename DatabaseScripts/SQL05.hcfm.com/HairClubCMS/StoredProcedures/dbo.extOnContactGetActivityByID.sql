/* CreateDate: 12/11/2012 14:57:18.683 , ModifyDate: 12/11/2012 14:57:18.683 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactGetActivityByID

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
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_GetActivityByID

==============================================================================
SAMPLE EXECUTION:
EXEC spApp_TREConsultations_GetActivityByID 'WGRLRIBGC1'
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactGetActivityByID]
(
	@ActivityID varchar(50)
)
AS
BEGIN
	SET NOCOUNT ON

	-- Output results.
	SELECT  CONVERT(varchar(10), a.due_date, 101) + ' ' + a.start_time AS 'Appt', dbo.[pCase](LTRIM(RTRIM(info.last_name))) + ', ' + dbo.[pCase](LTRIM(RTRIM(info.first_name))) AS 'Name'
	FROM HCMSkylineTest..lead_info info WITH (NOLOCK)
		INNER JOIN HCMSkylineTest..oncd_activity_contact ac WITH (NOLOCK) ON ac.contact_id = info.contact_id AND ac.primary_flag = 'Y'
		INNER JOIN HCMSkylineTest..oncd_activity a WITH (NOLOCK) ON a.activity_id = ac.activity_id
	WHERE   a.activity_id = @ActivityID
END
GO
