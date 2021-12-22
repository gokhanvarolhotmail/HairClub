/* CreateDate: 07/30/2012 08:54:10.360 , ModifyDate: 02/27/2017 09:49:18.590 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnCreateEmployeeCentersForUser

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		06/28/12

LAST REVISION DATE: 	* 07/26/12 - MLM: Crestored procedure

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns the centers the user has access to.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

mtnCreateEmployeeCentersForUser 'tcon'

			* 07/26/12 MLM - Changed to only add centers to datEmployeeCenter where they belong to the AD Group
			* 07/27/12 MLM - Modfied the Proc manage a single Employee at a time
			* 04/06/15 MVT - added a check for HCTESTSQL11
***********************************************************************/

CREATE PROCEDURE [dbo].[mtnCreateEmployeeCentersForUser] (
	@User VARCHAR(100),
	@EmployeeGUID CHAR(36))
AS
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--Remove datEmployeeCenter From Employee
	DELETE FROM datEmployeeCenter WHERE EmployeeGUID = @EmployeeGUID

	DECLARE @serverName varchar(50)
	SET @serverName = (CAST (SERVERPROPERTY ( 'ComputerNamePhysicalNetBIOS') as varchar(50)) )
	IF (NOT @serverName LIKE 'HCTESTSQL11' AND NOT @serverName LIKE 'HCTESTSQL01' AND NOT @serverName LIKE 'SQL01' AND NOT @serverName LIKE 'HCSQL%')
	  BEGIN
		-- We are in Skyline Dev or Staging Environments
		SELECT c.CenterID, c.CenterDescriptionFullCalc AS 'CenterDescription'
		FROM cfgCenter c
		WHERE c.IsActiveFlag = 1
	  END
	ELSE
	  BEGIN
		-- We're on HairClub Servers, use Active Directory

		--Declare variables
		DECLARE @SQL VARCHAR(8000)

		--Declare variables
		DECLARE @UserPath VARCHAR(500)
		DECLARE @SQLUserPath VARCHAR(8000)
		DECLARE @SQLUserGroups VARCHAR(8000)
		DECLARE @ADUser VARCHAR(100)


		--Create temp table to hold AD Path
		CREATE TABLE #ADPath (
			ADPath VARCHAR(200)
		)

		CREATE TABLE #GroupMembers (
			Rowid int Identity(1,1)
		,	GroupName VARCHAR(100)
		)

		--Create temp table to hold Available Centers
		CREATE TABLE #Centers (
			CenterID int,
			CenterDescription nvarchar(200)
		)

		SET @ADUser = REPLACE(@User, '''','''''''''')

		--Build SQL string to get AD Path based on user specified
		SET @SQLUserPath = '
			SELECT REPLACE(ADSPath,''LDAP://'', '''') ADSPath
			FROM OPENQUERY(ADSI,''
				SELECT sAMAccountname
				,	ADSPath
				FROM ''''LDAP://OU=HC.Users,OU=HAIRCLUB,DC=hcfm,DC=com''''
				WHERE sAMAccountname=''''' + @ADUser + '''''''
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

		--Insert group members into temp table
		INSERT INTO #GroupMembers
		EXEC (@SQLUserGroups)


			--If they only have access to centers assigned to them in AD
			INSERT INTO #Centers (CenterID, CenterDescription)
				SELECT c.CenterID, c.CenterDescriptionFullCalc AS 'CenterDescription'
				FROM #GroupMembers
					INNER JOIN cfgCenter c ON LEFT(#GroupMembers.GroupName,3) = CAST(c.ReportingCenterID AS VARCHAR(3)) OR LEFT(#GroupMembers.GroupName,3) = CAST(c.CenterID AS VARCHAR(3))
				WHERE c.IsActiveFlag = 1

		SET @User = REPLACE(@User, '', '''')


		INSERT INTO [dbo].[datEmployeeCenter](EmployeeCenterGUID, EmployeeGUID, CenterId, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT newID(), @EmployeeGUID, c.CenterID, GETDATE(), 'sa', GETDATE(), 'sa'
		FROM
			( SELECT DISTINCT CenterID
				FROM #Centers ) c

		DROP TABLE #ADPath
		DROP TABLE #GroupMembers
		DROP TABLE #Centers
	  END
END
GO
