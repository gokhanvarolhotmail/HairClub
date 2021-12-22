/* CreateDate: 02/18/2013 07:20:18.313 , ModifyDate: 02/27/2017 09:49:23.133 */
GO
/***********************************************************************

PROCEDURE:				[mtnSetClientMembershipNumber]

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		12/04/2012

LAST REVISION DATE: 	12/04/2012

--------------------------------------------------------------------------------------------------------
NOTES: 	Creates a unique Client Membership Number for a new client membership,
		assuming they will never have more than 20 active memberships. Sets the
		identifier on the client membership for the passed in guid.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

Exec [mtnSetClientMembershipNumber] '389F3FA6-F672-434A-AD14-C18F730E2882'
***********************************************************************/

CREATE PROCEDURE [dbo].[mtnSetClientMembershipNumber]
	@ClientMembershipGuid uniqueidentifier

AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRANSACTION

	DECLARE @ClientMemberhsipIdentifier as nvarchar(50), @ClientMembershipCounter int, @CenterId int, @StartDate datetime

	--Grab the next Invoice Number
	SELECT @ClientMembershipCounter = (ClientMembershipCounter + 1)
			, @CenterId = cm.CenterId
			, @StartDate = cm.BeginDate
	FROM datClientMembership cm
		INNER JOIN datClient c ON c.ClientGuid = cm.ClientGuid
	WHERE cm.ClientMembershipGuid = @ClientMembershipGuid

	--Roll counter back to 1 if we go over 20
	--   (this assumes a client will never have more than 20 Active Memberships
	IF @ClientMembershipCounter >= 20
		SET @ClientMembershipCounter = 1

	--Update Client Membership Counter
	UPDATE c SET
		c.ClientMembershipCounter = @ClientMembershipCounter
	FROM datClientMembership cm
		INNER JOIN datClient c ON c.ClientGuid = cm.ClientGuid
	WHERE cm.ClientMembershipGuid = @ClientMembershipGuid

	-- Determine the identifier
	SELECT @ClientMemberhsipIdentifier = (CAST(@CenterID AS nvarchar) +
			'-'	+ RIGHT(CAST(YEAR(@StartDate) AS nvarchar), 2) +
					REPLICATE('0', (2 - LEN(CAST(MONTH(@StartDate) AS nvarchar)))) + CAST(MONTH(@StartDate) AS nvarchar) +
			'-' + CAST(c.ClientIdentifier AS nvarchar) +
			'-' + REPLICATE('0', (2 - LEN(CAST(@ClientMembershipCounter AS nvarchar)))) + CAST(@ClientMembershipCounter AS nvarchar)) -- AS ClientMembershipNumber
	FROM datClientMembership cm
		INNER JOIN datClient c ON c.ClientGuid = cm.ClientGuid
	WHERE cm.ClientMembershipGuid = @ClientMembershipGuid

	-- Update Identifier on the Client Membership
	UPDATE datClientMembership SET
		ClientMembershipIdentifier = @ClientMemberhsipIdentifier
	WHERE ClientMembershipGuid = @ClientMembershipGuid

  COMMIT

END
GO
