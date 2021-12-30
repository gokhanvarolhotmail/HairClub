/* CreateDate: 11/12/2012 16:42:30.303 , ModifyDate: 02/27/2017 09:49:20.243 */
GO
/***********************************************************************

PROCEDURE:				[mtnGetClientMembershipNumber]

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		10/15/2012

LAST REVISION DATE: 	10/15/2012

--------------------------------------------------------------------------------------------------------
NOTES: 	Creates a unique Client Membership Number for a new client membership,
		assuming they will never have more than 20 active memberships.

		* 5/31/13	MVT	Modified so that Update and Increment are done as a single operation.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

DECLARE @result AS nvarchar(50)
Exec [mtnGetClientMembershipNumber] '477934EC-FAAD-4044-AEDE-00005750D64B', 301, '09/10/12', @result

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnGetClientMembershipNumber]
	@ClientGuid uniqueidentifier
	, @CenterId int
	, @MembershipStartDate date
	, @ClientMembershipNumber nvarchar(50) OUTPUT
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRANSACTION

	DECLARE @ClientMembershipCounter int

	----Grab the next Invoice Number
	--SELECT @ClientMembershipCounter = (ClientMembershipCounter + 1)
	--FROM datClient  WITH (HOLDLOCK)
	--WHERE ClientGuid = @ClientGuid


	----Roll counter back to 1 if we go over 20
	----   (this assumes a client will never have more than 20 Active Memberships
	--IF @ClientMembershipCounter >= 20
	--	SET @ClientMembershipCounter = 1


	DECLARE @MembershipCounterTable table (
		MembershipCounter int)

	--Update Client Membership Counter
	UPDATE datClient  WITH (HOLDLOCK)
	SET ClientMembershipCounter = CASE WHEN ClientMembershipCounter >= 20 THEN 1
										ELSE ClientMembershipCounter + 1 END
	OUTPUT inserted.ClientMembershipCounter INTO @MembershipCounterTable
	WHERE ClientGuid = @ClientGuid

  COMMIT

	SELECT TOP(1) @ClientMembershipCounter = MembershipCounter FROM @MembershipCounterTable

	SELECT @ClientMembershipNumber = (CAST(@CenterID AS nvarchar) +
			'-'	+ RIGHT(CAST(YEAR(@MembershipStartDate) AS nvarchar), 2) +
					REPLICATE('0', (2 - LEN(CAST(MONTH(@MembershipStartDate) AS nvarchar)))) + CAST(MONTH(@MembershipStartDate) AS nvarchar) +
			'-' + CAST(c.ClientIdentifier AS nvarchar) +
			'-' + REPLICATE('0', (2 - LEN(CAST(@ClientMembershipCounter AS nvarchar)))) + CAST(@ClientMembershipCounter AS nvarchar)) -- AS ClientMembershipNumber
		FROM datClient c
		WHERE c.ClientGuid = @ClientGuid

END
GO
