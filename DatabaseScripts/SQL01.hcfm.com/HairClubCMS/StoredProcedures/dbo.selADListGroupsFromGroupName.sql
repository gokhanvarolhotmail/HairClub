/***********************************************************************

PROCEDURE:				selADListGroupsFromGroupName

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Marlon Burrell/Dan Lorenz

IMPLEMENTOR: 			Marlon Burrell/Dan Lorenz

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE: 	4/13/09 Andrew Schwalbe, Skyline Technologies
						 * Change to dynamically determine Skyline vs. Production Servers

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns the AD Groups that are associated with the given group.

		* 06/10/10 - PRM: Included HairClub Test Server User to the script
		* 10/27/10 - PRM: Changed server name if statement to include nodes of SQL server not just virtual SQL01 name
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

selADListUsersFromGroupName '125 - Information Technology'

***********************************************************************/

CREATE PROCEDURE [dbo].[selADListGroupsFromGroupName]
	@Group VARCHAR(100)
AS
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--Declare variables
	DECLARE @SQL VARCHAR(8000)


	DECLARE @serverName varchar(50)
	SET @serverName = (CAST (SERVERPROPERTY ( 'ComputerNamePhysicalNetBIOS') as varchar(50)) )
	IF (NOT @serverName LIKE 'HCTESTSQL01' AND NOT @serverName LIKE'SQL01' AND NOT @serverName LIKE 'HCSQL%')
	  BEGIN
		-- We are in Skyline Dev or Staging Environments

		SET @SQL = '
			SELECT sAMAccountname
			,	CN
			,	mail
			FROM OPENQUERY(ADSI,''
			SELECT sAMAccountname
			,	CN
			,	mail
			FROM ''''LDAP://OU=groups - Testing,DC=skyline,DC=gb''''
			WHERE memberOf=''''CN=' + @Group + ',OU=Users - Testing,DC=skyline,DC=gb''''''
			)
			ORDER BY sAMAccountname
		'

		--List members of given group
		EXEC (@SQL)


	  END
	ELSE
	  BEGIN
		-- Assume to be on Hair Club Production

		--Build SQL string to get members of given group
		SET @SQL = '
			SELECT sAMAccountname
			,	CN
			,	mail
			FROM OPENQUERY(ADSI,''
				SELECT sAMAccountname
				,	CN
				,	mail
				FROM ''''LDAP://OU=HC.groups,OU=HAIRCLUB,DC=hcfm,DC=com''''
				WHERE memberOf=''''CN=' + @Group + ',OU=HC.Security,OU=HC.Groups,OU=HAIRCLUB,DC=hcfm,DC=com''''''
			)
			ORDER BY sAMAccountname
		'

		--List members of given group
		EXEC (@SQL)

	  END

END
