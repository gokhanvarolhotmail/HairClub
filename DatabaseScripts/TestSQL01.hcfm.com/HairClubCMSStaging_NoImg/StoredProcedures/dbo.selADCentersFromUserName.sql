/* CreateDate: 02/18/2009 09:01:49.527 , ModifyDate: 02/09/2022 16:25:20.647 */
GO
/***********************************************************************

PROCEDURE:				selADCentersFromUserName

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Marlon Burrell/Dan Lorenz

IMPLEMENTOR: 			Marlon Burrell/Dan Lorenz

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE: 	* 04/13/09 - AS: Change to dynamically determine Skyline vs. Production Servers
						* 06/02/10 - PRM: Updated proc with database changes for v4.0
						* 06/10/10 - PRM: Included HairClub Test Server User to the script
						* 10/27/10 - PRM: Changed server name if statement to include nodes of SQL server not just virtual SQL01 name
						* 12/08/10 - MLM: Added the Reading of Groups from the Database
						* 12/15/10 - PRM: Added check for the HasAccessFlag when looking at security elements
						* 12/29/10 - PRM: Added Doctor Region back into query, and add logic to run all queries and put them in a temp table and query final results from there
						* 01/05/10 - PRM: moved the #Center select statement into the if block since it wasn't valid in the first if statement
						* 06/29/12 - MLM: Added Code handle a parameter with a single quote embedded in variable.
						* 08/06/12 - MLM: Added Code to get nested Group information
						* 08/15/12 - MLM: Modified to read the database instead of AD
						* 05/21/14 - MLM: Modified to use the IsActiveFlag on the EmployeeCenter table so people who have been removed from AD do not display any more.
						* 02/02/16 - DSL: Modified to use the IsActiveFlag on the EmployeePositionJoin table when checking for ctrAll access
--------------------------------------------------------------------------------------------------------
NOTES: 	Returns the centers the user has access to.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

selADCentersFromUserName 'apuerta'

***********************************************************************/

CREATE PROCEDURE [dbo].[selADCentersFromUserName] (
	@User VARCHAR(100))
AS
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		DECLARE @EmployeeGUID char(36)

		SELECT @EmployeeGUID = EmployeeGUID FROM datEmployee where UserLogin = @User

		CREATE TABLE #Centers (
			CenterID int,
		CenterDescription nvarchar(200)
	)

		--If they have access to ALL Centers
		IF EXISTS (SELECT DISTINCT ep.ActiveDirectoryGroup
					FROM lkpSecurityElement se
						INNER JOIN cfgSecurityGroup sg on se.SecurityElementID = sg.SecurityElementID
						INNER JOIN lkpEmployeePosition ep on sg.EmployeePositionID = ep.EmployeePositionID
						INNER JOIN cfgEmployeePositionJoin epj on ep.EmployeePositionID = epj.EmployeePositionID
					WHERE se.SecurityElementDescriptionShort = 'ctrAll' AND sg.HasAccessFlag = 1 AND ISNULL(epj.IsActiveFlag, 0) = 1
						AND epj.EmployeeGUID = @EmployeeGUID )
		  BEGIN
		  	INSERT INTO #Centers (CenterID, CenterDescription)
				SELECT c.CenterID, c.CenterDescriptionFullCalc AS 'CenterDescription'
				FROM cfgCenter c
					INNER JOIN cfgConfigurationCenter cc on c.CenterID = cc.CenterID
					INNER JOIN lkpCenterBusinessType cbt on cc.CenterBusinessTypeID = cbt.CenterBusinessTypeID
				WHERE c.IsActiveFlag = 1
					AND cbt.CenterBusinessTypeDescriptionShort <> 'Surgery'
		  END
		ELSE
		  BEGIN

			--If they only have access to centers assigned to them in AD
			INSERT INTO #Centers (CenterID, CenterDescription)
			SELECT c.CenterID, c.CenterDescriptionFullCalc AS 'CenterDescription'
			FROM cfgCenter c
				INNER JOIN datEmployeeCenter ec on c.CenterID = ec.CenterID
			WHERE c.IsActiveFlag = 1 AND ec.EmployeeGUID = @EmployeeGUID AND ec.IsActiveFlag = 1
		  END


	IF ((SELECT count(*) FROM #Centers) = 0)
	 BEGIN
		INSERT INTO #Centers (CenterID, CenterDescription)
			SELECT c.CenterID, c.CenterDescriptionFullCalc AS 'CenterDescription'
			FROM cfgCenter c
				INNER JOIN cfgConfigurationCenter cc on c.CenterID = cc.CenterID
				INNER JOIN lkpCenterBusinessType cbt on cc.CenterBusinessTypeID = cbt.CenterBusinessTypeID
			WHERE c.IsActiveFlag = 1
				AND cbt.CenterBusinessTypeDescriptionShort <> 'Surgery'
	END

	SELECT * FROM #Centers

	DROP TABLE #Centers
	--DECLARE @serverName varchar(50)
	--SET @serverName = (CAST (SERVERPROPERTY ( 'ComputerNamePhysicalNetBIOS') as varchar(50)) )
	--IF (NOT @serverName LIKE 'HCTESTSQL01' AND NOT @serverName LIKE 'SQL01' AND NOT @serverName LIKE 'HCSQL01%')
	--  BEGIN
	--	-- We are in Skyline Dev or Staging Environments
	--	SELECT c.CenterID, c.CenterDescriptionFullCalc AS 'CenterDescription'
	--	FROM cfgCenter c
	--	WHERE c.IsActiveFlag = 1
	--  END
	--ELSE
	--  BEGIN
	--	-- We're on HairClub Servers, use Active Directory

	--	--Declare variables
	--	DECLARE @SQL VARCHAR(8000)

	--	--Declare variables
	--	DECLARE @UserPath VARCHAR(500)
	--	DECLARE @SQLUserPath VARCHAR(8000)
	--	DECLARE @SQLUserGroups VARCHAR(8000)


	--	--Create temp table to hold AD Path
	--	CREATE TABLE #ADPath (
	--		ADPath VARCHAR(200)
	--	)

	--	CREATE TABLE #GroupMembers (
	--		Rowid int Identity(1,1)
	--	,	GroupName VARCHAR(100)
	--	)

	--	--Create temp table to hold Available Centers
	--	CREATE TABLE #Centers (
	--		CenterID int,
	--		CenterDescription nvarchar(200)
	--	)

	--	SET @user = REPLACE(@User, '''','''''''''')

	--	--Build SQL string to get AD Path based on user specified
	--	SET @SQLUserPath = '
	--		SELECT REPLACE(ADSPath,''LDAP://'', '''') ADSPath
	--		FROM OPENQUERY(ADSI,''
	--			SELECT sAMAccountname
	--			,	ADSPath
	--			FROM ''''LDAP://OU=HC.Users,OU=HAIRCLUB,DC=hcfm,DC=com''''
	--			WHERE sAMAccountname=''''' + @user + '''''''
	--		)
	--	'



	--	--Insert user AD Path into temp table
	--	--	*	temp table was used instead of variable because the value
	--	--		from a dynamic query cannot be assigned to a variable
	--	--		even if it's scalar
	--	INSERT INTO #ADPath
	--	EXEC (@SQLUserPath)

	--	--Set AD Path from temp table to variable
	--	SET @UserPath = (SELECT TOP 1 REPLACE(ADPath, '''', '''''''''') AS 'ADPath' FROM #ADPath)

	--	--Build SQL string to get groups based on AD Path
	--	SET @SQLUserGroups = '
	--		SELECT sAMAccountname AS ''Group''
	--		FROM OPENQUERY(ADSI,''
	--			SELECT sAMAccountname
	--			FROM ''''LDAP://OU=HC.Security,OU=HC.Groups,OU=HAIRCLUB,DC=hcfm,DC=com''''
	--			WHERE member=''''' + @UserPath + '''''''
	--		)
	--		ORDER BY sAMAccountname
	--	'

	--	--Insert group members into temp table
	--	INSERT INTO #GroupMembers
	--	EXEC (@SQLUserGroups)

	--	DECLARE @CurrentGroup VARCHAR(200)
	--			,@SQLGroupMembership VARCHAR(1000)

	--	DECLARE Level1_Cursor CURSOR FAST_FORWARD FOR
	--	SELECT GroupName
	--	FROM #GroupMembers
	--	Where SUBSTRING(#GroupMembers.GroupName,1,1) <> '_'

	--	OPEN Level1_Cursor
	--	FETCH NEXT FROM Level1_Cursor
	--	INTO @CurrentGroup

	--	WHILE @@FETCH_STATUS = 0
	--	BEGIN
	--		SET @SQLGroupMembership = '
	--			SELECT sAMAccountname
	--			FROM OPENQUERY(ADSI,''
	--				SELECT sAMAccountname
	--				FROM ''''LDAP://DC=hcfm,DC=com''''
	--				WHERE member=''''CN=' + REPLACE(@CurrentGroup, '''', '''''''''') + ',OU=HC.Security,OU=HC.Groups,OU=HAIRCLUB,DC=hcfm,DC=com''''
	--					OR member=''''CN=' + REPLACE(@CurrentGroup, '''', '''''''''') + ',OU=NEW Security Groups,OU=HC.Security,OU=HC.Groups,OU=HAIRCLUB,DC=hcfm,DC=com''''''
	--			)
	--			ORDER BY sAMAccountname
	--		'

	--		INSERT INTO #GroupMembers
	--		EXEC (@SQLGroupMembership)

	--		FETCH NEXT FROM Level1_Cursor
	--		INTO @CurrentGroup
	--	END
	--	CLOSE Level1_Cursor
	--	DEALLOCATE Level1_Cursor

	--	--If they have access to ALL Centers
	--	IF EXISTS (SELECT DISTINCT ep.ActiveDirectoryGroup
	--				FROM lkpSecurityElement se
	--					INNER JOIN cfgSecurityGroup sg on se.SecurityElementID = sg.SecurityElementID
	--					INNER JOIN lkpEmployeePosition ep on sg.EmployeePositionID = ep.EmployeePositionID
	--					INNER JOIN #GroupMembers gm on ep.ActiveDirectoryGroup = gm.GroupName
	--				WHERE se.SecurityElementDescriptionShort = 'ctrAll' AND sg.HasAccessFlag = 1)
	--	  BEGIN
	--		INSERT INTO #Centers (CenterID, CenterDescription)
	--			SELECT c.CenterID, c.CenterDescriptionFullCalc AS 'CenterDescription'
	--			FROM cfgCenter c
	--			WHERE c.IsActiveFlag = 1
	--	  END
	--	ELSE
	--	  BEGIN

	--		--If they only have access to centers assigned to them in AD
	--		INSERT INTO #Centers (CenterID, CenterDescription)
	--			SELECT c.CenterID, c.CenterDescriptionFullCalc AS 'CenterDescription'
	--			FROM #GroupMembers
	--				INNER JOIN cfgCenter c ON LEFT(#GroupMembers.GroupName,3) = CAST(c.ReportingCenterID AS VARCHAR(3)) OR LEFT(#GroupMembers.GroupName,3) = CAST(c.CenterID AS VARCHAR(3))
	--			WHERE c.IsActiveFlag = 1

	--	  END

	--	SELECT DISTINCT CenterID, CenterDescription
	--	FROM #Centers
	--	ORDER BY CenterID

	--	DROP TABLE #ADPath
	--	DROP TABLE #GroupMembers
	--	DROP TABLE #Centers
	--  END
END
GO
