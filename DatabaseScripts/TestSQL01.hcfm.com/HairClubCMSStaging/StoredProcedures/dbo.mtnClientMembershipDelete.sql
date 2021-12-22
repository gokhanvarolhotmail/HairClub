/* CreateDate: 12/28/2009 13:56:18.667 , ModifyDate: 02/27/2017 09:49:18.003 */
GO
/***********************************************************************

PROCEDURE:				mtnClientMembershipDelete

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		12/22/09

LAST REVISION DATE:


--------------------------------------------------------------------------------------------------------
NOTES: 	Delete a Client Membership and all associated records
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnClientMembershipDelete '6A1D4B8F-FE98-4581-B07D-8C8D2A6BFF69'

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnClientMembershipDelete]
	@ClientMembershipGUID uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON

	-- wrap the entire stored procedure in a transaction
	BEGIN TRANSACTION

	--Delete all Appointments
	DELETE FROM datNotesClient WHERE AppointmentGUID IN (SELECT AppointmentGUID FROM datAppointment WHERE ClientMembershipGUID = @ClientMembershipGUID)
	DELETE FROM datAppointmentDetail WHERE AppointmentGUID IN (SELECT AppointmentGUID FROM datAppointment WHERE ClientMembershipGUID = @ClientMembershipGUID)
	DELETE FROM datAppointment WHERE ClientMembershipGUID = @ClientMembershipGUID

	--Delete all Sales Orders
	DELETE FROM datNotesClient WHERE SalesOrderGUID IN (SELECT SalesOrderGUID FROM datSalesOrder WHERE ClientMembershipGUID = @ClientMembershipGUID)
	DELETE FROM datAccumulatorAdjustment WHERE SalesOrderDetailGUID IN (SELECT SalesOrderDetailGUID FROM datSalesOrderDetail WHERE ClientMembershipGUID = @ClientMembershipGUID)
	DELETE FROM datSalesOrderDetail WHERE SalesOrderGUID IN (SELECT SalesOrderGUID FROM datSalesOrder WHERE ClientMembershipGUID = @ClientMembershipGUID)
	DELETE FROM datSalesOrderTender WHERE SalesOrderGUID IN (SELECT SalesOrderGUID FROM datSalesOrder WHERE ClientMembershipGUID = @ClientMembershipGUID)
	DELETE FROM datSalesOrder WHERE ClientMembershipGUID = @ClientMembershipGUID

	--Remove Client Membership
	DELETE FROM datClientMembershipAccum WHERE ClientMembershipGUID = @ClientMembershipGUID
	DELETE FROM datClientMembership WHERE ClientMembershipGUID = @ClientMembershipGUID


 	-- complete the transaction and save
	COMMIT TRANSACTION
END
GO
