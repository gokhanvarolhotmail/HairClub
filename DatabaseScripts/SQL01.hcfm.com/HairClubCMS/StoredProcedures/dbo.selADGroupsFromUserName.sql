/***********************************************************************

PROCEDURE:				selADGroupsFromUserName

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Marlon Burrell/Dan Lorenz

IMPLEMENTOR: 			Marlon Burrell/Dan Lorenz

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE: 	4/13/09 Andrew Schwalbe, Skyline Technologies
						 * Change to dynamically determine Skyline vs. Production Servers


--------------------------------------------------------------------------------------------------------
NOTES: 	Returns the AD Groups the user is a part of.

		* 06/10/10 - PRM: Included HairClub Test Server User to the script
		* 10/27/10 - PRM: Changed server name if statement to include nodes of SQL server not just virtual SQL01 name
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

selADGroupsFromUserName 'aptak'

***********************************************************************/
CREATE PROCEDURE [dbo].[selADGroupsFromUserName]
	@User VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


		--Declare variables
		DECLARE @SQL VARCHAR(8000)

		--Declare variables
		DECLARE @UserPath VARCHAR(500)
		DECLARE @SQLUserPath VARCHAR(8000)
		DECLARE @SQLUserGroups VARCHAR(8000)

		--Create temp table to hold AD Path
		CREATE TABLE #ADPath (
			ADPath VARCHAR(200)
		)

		--Build SQL string to get AD Path based on user specified
		SET @SQLUserPath = '
			SELECT REPLACE(ADSPath,''LDAP://'', '''') ADSPath
			FROM OPENQUERY(ADSI,''
				SELECT sAMAccountname
				,	ADSPath
				FROM ''''LDAP://OU=HC.Users,OU=HAIRCLUB,DC=hcfm,DC=com''''
				WHERE sAMAccountname=''''' + @user + '''''''
			)
		'

		--Insert user AD Path into temp table
		--	*	temp table was used instead of variable because the value
		--		from a dynamic query cannot be assigned to a variable
		--		even if it's scalar
		INSERT INTO #ADPath
		EXEC (@SQLUserPath)

		--Set AD Path from temp table to variable
		SET @UserPath = (SELECT TOP 1 REPLACE(ADPath, '''', '''''''''') AS 'ADPath' FROM #ADPath)

		--Build SQL string to get groups based on AD Path
		SET @SQLUserGroups = '
			SELECT sAMAccountname AS ''Group''
			FROM OPENQUERY(ADSI,''
				SELECT sAMAccountname
				FROM ''''LDAP://OU=HC.Security,OU=HC.Groups,OU=HAIRCLUB,DC=hcfm,DC=com''''
				WHERE member=''''' + @UserPath + '''''''
			)
			ORDER BY sAMAccountname
		'

		--List group membership
		EXEC (@SQLUserGroups)

		DROP TABLE #ADPath


END
