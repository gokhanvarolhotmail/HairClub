/* CreateDate: 10/28/2010 00:49:56.743 , ModifyDate: 02/27/2017 09:49:15.490 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

		PROCEDURE:				dbaClientDelete

		DESTINATION SERVER:		SQL01

		DESTINATION DATABASE: 	HairClubCMS

		RELATED APPLICATION:  	CMS

		AUTHOR:

		IMPLEMENTOR:

		DATE IMPLEMENTED:

		LAST REVISION DATE: 	 03/02/2015

		--------------------------------------------------------------------------------------------------------
		NOTES:  This script is used to delete client
				* 03/02/2015 MVT - Updated proc for Xtrands Business Segment
				* 04/12/2015 MVT - Updated to change client name isntead of deleting
		--------------------------------------------------------------------------------------------------------
		SAMPLE EXECUTION:

		EXEC [dbaClientDelete]
		***********************************************************************/

CREATE PROCEDURE [dbo].[dbaClientDelete]
	  @ClientGUID uniqueidentifier = NULL,
	  @User nvarchar(25) = 'sa-Client Delete'
AS
BEGIN

	-- Log Client
	INSERT INTO [Log4Net].[dbo].[DeletedClient]
           ([ClientGUID]
           ,[ClientIdentifier]
           ,[FirstName]
           ,[LastName]
           ,[CenterID]
           ,[CreateDate]
           ,[CreateUser]
           ,[LastUpdate]
           ,[LastUpdateUser])
		SELECT
           ClientGUID
           ,ClientIdentifier
           ,FirstName
           ,LastName
           ,CenterID
           ,GETUTCDATE()
           ,@User
           ,GETUTCDATE()
           ,@User
		FROM datClient
		WHERE ClientGUID = @ClientGUID


	DECLARE @SalesCodeID int, @InactiveStatusID int

	SELECT @SalesCodeID = SalesCodeID FROM cfgSalesCode
	WHERE SalesCodeDescriptionShort = 'GENPROD'

	SELECT @InactiveStatusID = ClientMembershipStatusID FROM lkpClientMembershipStatus
	WHERE ClientMembershipStatusDescriptionShort = 'I'


	DELETE FROM datAccumulatorAdjustment WHERE ClientMembershipGUID IN (SELECT ClientMembershipGUID FROM datClientMembership WHERE ClientGUID = @ClientGUID)
	DELETE FROM datClientMembershipAccum WHERE ClientMembershipGUID IN (SELECT ClientMembershipGUID FROM datClientMembership WHERE ClientGUID = @ClientGUID)

	-- Set the Tender amount to $0
	UPDATE sot SET
		Amount = 0,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = @User
	FROM datSalesOrderTender sot
		 INNER JOIN datSalesOrder so ON so.SalesOrderGUID = sot.SalesOrderGUID
	WHERE so.ClientGUID = @ClientGUID

	-- Update Sales Code to Generic Product with a price of $0
	UPDATE sod SET
		SalesCodeID = @SalesCodeID,
		Price = 0,
		Discount = 0,
		Quantity = 0,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = @User
	FROM datSalesOrderDetail sod
		 INNER JOIN datSalesOrder so ON so.SalesOrderGUID = sod.SalesOrderGUID
	WHERE so.ClientGUID = @ClientGUID

	-- Update Appointment to Deleted
	UPDATE datAppointment SET
		IsDeletedFlag = 1,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = @User
	WHERE ClientGUID = @ClientGUID


	-- Update Client Membership to Inactive
	UPDATE datClientMembership SET
		ClientMembershipStatusID = @InactiveStatusID,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = @User
	WHERE ClientGUID = @ClientGUID


	UPDATE datClient SET
		FirstName = 'XXXX',
		LastName = 'XXXX',
		CurrentBioMatrixClientMembershipGUID = NULL,
		CurrentExtremeTherapyClientMembershipGUID = NULL,
		CurrentSurgeryClientMembershipGUID = NULL,
		CurrentXtrandsClientMembershipGUID = NULL,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = @User
	WHERE ClientGUID = @ClientGUID

END
GO
