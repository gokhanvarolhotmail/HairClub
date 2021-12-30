/* CreateDate: 07/30/2012 09:01:56.660 , ModifyDate: 02/27/2017 09:49:18.513 */
GO
/***********************************************************************

PROCEDURE:				mtnCreateEmployeeActiveDirectoryGroupJoin

DESTINATION SERVER:		HCSQL2

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		7/18/12

LAST REVISION DATE: 	7/18/12

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns whether or not user is the center manager of specified group

	* 07/27/12 MLM - Modfied the Proc manage a single Employee at a time
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

[mtnCreateEmployeeActiveDirectoryGroupJoin] 'tgriffin'

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnCreateEmployeeActiveDirectoryGroupJoin] (
	@User VARCHAR(100),
	@EmployeeGUID CHAR(36))
AS
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--Remove cfgEmployeeActiveDirectoryGroupJoin From Employee
	DELETE FROM cfgEmployeeActiveDirectoryGroupJoin WHERE EmployeeGUID = @EmployeeGUID

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

	CREATE TABLE #Groups (
		GroupName VARCHAR(200)
	)

	--Build SQL string to get AD Path based on user specified
	SET @SQLUserPath = '
		SELECT REPLACE(ADSPath,''LDAP://'', '''') ADSPath
		FROM OPENQUERY(ADSI,''
			SELECT sAMAccountname
			,	ADSPath
			FROM ''''LDAP://DC=hcfm,DC=com''''
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
			FROM ''''LDAP://DC=hcfm,DC=com''''
			WHERE member=''''' + @UserPath + '''''''
		)
		ORDER BY sAMAccountname
	'

	--Populate table with first level group membership
	INSERT INTO #Groups
	EXEC (@SQLUserGroups)

	DECLARE @CurrentGroup VARCHAR(200)
	,	@SQLGroupMembership VARCHAR(1000)

	DECLARE Level1_Cursor CURSOR FAST_FORWARD FOR
	SELECT *
	FROM #Groups
	Where SUBSTRING(#Groups.GroupName,1,1) <> '_'

	OPEN Level1_Cursor
	FETCH NEXT FROM Level1_Cursor
	INTO @CurrentGroup

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQLGroupMembership = '
			SELECT sAMAccountname
			FROM OPENQUERY(ADSI,''
				SELECT sAMAccountname
				FROM ''''LDAP://DC=hcfm,DC=com''''
				WHERE member=''''CN=' + REPLACE(@CurrentGroup, '''', '''''''''') + ',OU=HC.Security,OU=HC.Groups,OU=HAIRCLUB,DC=hcfm,DC=com''''
					OR member=''''CN=' + REPLACE(@CurrentGroup, '''', '''''''''') + ',OU=NEW Security Groups,OU=HC.Security,OU=HC.Groups,OU=HAIRCLUB,DC=hcfm,DC=com''''''
			)
			ORDER BY sAMAccountname
		'

		INSERT INTO #Groups
		EXEC (@SQLGroupMembership)

		FETCH NEXT FROM Level1_Cursor
		INTO @CurrentGroup
	END
	CLOSE Level1_Cursor
	DEALLOCATE Level1_Cursor

	INSERT INTO cfgEmployeeActiveDirectoryGroupJoin(EmployeeGUID,ActiveDirectoryGroupID,CreateDate, CreateUser, LastUpdate, LastUpdateUser)
	SELECT DISTINCT @EmployeeGUID, AD.ActiveDirectoryGroupID, GETDATE(), 'sa', GETDATE(), 'sa'
	FROM #Groups
	INNER JOIN cfgActiveDirectoryGroup AD on #Groups.GroupName = AD.ActiveDirectoryGroup
	Where SUBSTRING(#Groups.GroupName,1,1) <> '_'

END
GO
