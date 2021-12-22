/* CreateDate: 06/22/2009 11:18:58.793 , ModifyDate: 02/27/2017 09:49:15.563 */
GO
/***********************************************************************

PROCEDURE:				dbaClientFindRecords

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		6/16/09

LAST REVISION DATE: 	6/16/09

--------------------------------------------------------------------------------------------------------
NOTES: 	Find  records associated with a client
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

dbaClientFindRecords 'Downing', 'Darrell', 315, 373614, NULL

***********************************************************************/

CREATE PROCEDURE [dbo].[dbaClientFindRecords]
	@LastName nvarchar(50) = NULL,
	@FirstName nvarchar(50) = NULL,
	@CenterID int = NULL,
	@ClientIdentifier int = NULL,
	@MembershipID int = NULL,
	@ClientGUID uniqueidentifier = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--grab the client record
	SELECT DISTINCT c.*
	FROM datClient c
		LEFT JOIN datClientMembership cm ON c.ClientGUID = cm.ClientGUID
	WHERE (@LastName IS NULL OR LastName LIKE @LastName + '%')
		AND (@FirstName IS NULL OR FirstName LIKE @FirstName + '%')
		AND (@CenterID IS NULL OR c.CenterID = @CenterID)
		AND (@ClientIdentifier IS NULL OR ClientIdentifier = @ClientIdentifier)
		AND (@MembershipID IS NULL OR MembershipID = @MembershipID)
		AND (@ClientGUID IS NULL OR c.ClientGUID = @ClientGUID)

	--grab all of the client membership records
	SELECT cm.*
	FROM datClient c
		LEFT JOIN datClientMembership cm ON c.ClientGUID = cm.ClientGUID
	WHERE (@LastName IS NULL OR LastName LIKE @LastName + '%')
		AND (@FirstName IS NULL OR FirstName LIKE @FirstName + '%')
		AND (@CenterID IS NULL OR c.CenterID = @CenterID)
		AND (@ClientIdentifier IS NULL OR ClientIdentifier = @ClientIdentifier)
		AND (@MembershipID IS NULL OR MembershipID = @MembershipID)
		AND (@ClientGUID IS NULL OR c.ClientGUID = @ClientGUID)

END
GO
