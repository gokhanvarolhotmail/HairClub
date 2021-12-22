/* CreateDate: 05/14/2012 17:41:18.303 , ModifyDate: 02/27/2017 09:49:31.153 */
GO
/***********************************************************************

PROCEDURE:				selCenterMessagesCount

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		4/27/11

LAST REVISION DATE: 	4/27/11

--------------------------------------------------------------------------------------------------------
NOTES: 	Determines number of Center Messages

		03/06/2012 mvt - added static notifications count from datNotification table
		05/14/2012 mvt - added a parameter that detrmines if Fee notifications are counted
		10/22/2013 mlm - Client Notification were returning multiple message due to Client Membership Join
		11/14/2013 mvt - added inactive fee profile notifications.
		01/07/2014 mvt - added separate notification for repair orders that have a charge decision.
		04/10/2014 mlm - Added Notification for Visiting Center for 'Pending Service Authorization Requests'
		04/10/2014 mlm - Added Notification for Pending Priority Hair Requests, that have not been approved/denied
		03/02/2015 sal - Added new Xtrands Business Segment (datClient.CurrentXtrandsClientMembershipGUID) - TFS#4363
		03/05/2015 mvt - Modified query to include Xtrands Business Segment for the:
							-Non retail clients with an AR Credit
							-Non retail clients with an AR Balance
		12/01/2016 mvt - Added Web Appointments notifications.
		01/07/2017 mvt - Fixed the proc to match the selCenterMessages Proc (TFS #8366)

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

selCenterMessagesCount 205, '9B97AE9D-5AB5-4ED9-A959-63D2D6AE9B24',0

***********************************************************************/
CREATE PROCEDURE [dbo].[selCenterMessagesCount]
	@CenterID int,
	@EmployeeGUID uniqueidentifier,
	@IncludeFeesNotifications bit
AS
BEGIN

	exec selCenterMessages @CenterID, @EmployeeGUID,@IncludeFeesNotifications
	RETURN @@rowcount

END
GO
