/* CreateDate: 05/13/2009 06:37:45.430 , ModifyDate: 12/16/2019 08:40:04.503 */
GO
/***********************************************************************

PROCEDURE:				selADEmployeesForSync

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Andrew Schwalbe & Paul Madary

IMPLEMENTOR: 			Andrew Schwalbe & Paul Madary

DATE IMPLEMENTED: 		5/5/09

LAST REVISION DATE: 	n/a

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns the AD users that are associated with the given group.

		* 06/10/10 - PRM: Included HairClub Test Server User to the script
		* 10/27/10 - PRM: Changed server name if statement to include nodes of SQL server not just virtual SQL01 name
		* 07/27/12 - MLM: Changed to get users of first level sub-groups.
		* 08/28/12 - MLM: Removed SQL Server Check for Development Environment.
		* 10/26/12 - MLM: Added EmployeePayrollID
		* 12/02/19 - SAL: Added getting Employee's title (TFS #13501)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

selADEmployeesForSync 'Access_CMS Administrators', 7

***********************************************************************/

CREATE PROCEDURE [dbo].[selADEmployeesForSync]
	@Group varchar(100),
	@EmployeePositionID int
AS
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--Declare variables
	DECLARE @SQL VARCHAR(8000)

		-- Assume to be on Hair Club Production

			CREATE TABLE #Groups (
				GroupName VARCHAR(200)
			)

			CREATE TABLE #Members(
				ADSID varbinary(100),
				ADUserLogin nvarchar(50),
				ADCenter nvarchar(50),
				ADFirstName nvarchar(50),
				ADLastName nvarchar(50),
				CenterID int,
				EmployeePosition int,
				EmployeeInitials nvarchar(5),
				EmployeePayrollID nvarchar(20),
				Title nvarchar(100),
				EmployeeTitleID int)


			--Top Level Group
			INSERT INTO #Groups(GroupName) VALUES(@Group)

			DECLARE @SQLUserGroups VARCHAR(8000)

			--Build SQL string to get groups based on AD Path
			SET @SQLUserGroups = '
				SELECT  cn AS ''Group''
				FROM    OpenQuery(ADSI, ''
					SELECT cn
					FROM ''''LDAP://DC=hcfm,DC=com''''
					WHERE objectCategory=''''group'''' and MemberOf=''''CN=' + REPLACE(@Group, '''', '''''''''') + ',OU=HC.Security,OU=HC.Groups,OU=HAIRCLUB,DC=hcfm,DC=com''''''
				)'


			INSERT INTO #Groups
			EXEC (@SQLUserGroups)

			DECLARE @CurrentGroup VARCHAR(200)

			DECLARE Group_Cursor CURSOR FAST_FORWARD FOR
			SELECT *
			FROM #Groups

			OPEN Group_Cursor
			FETCH NEXT FROM Group_Cursor
			INTO @CurrentGroup

			WHILE @@FETCH_STATUS = 0
			BEGIN

						--Build SQL string to get members of given group
						SET @SQL = '
							SELECT ObjectSID
							,	sAMAccountname
							,	Department
							,	givenName
							,	sn
							,	NULL
							,   ' + CAST(@EmployeePositionID AS varchar) + '
							,	NULL
							,   extensionattribute1
							,	title
							,	NULL
							FROM OPENQUERY(ADSI,''
								SELECT ObjectSID
								,	sAMAccountname
								,	Department
								,	givenName
								,	sn
								,   extensionattribute1
								,	title
								FROM ''''LDAP://OU=HC.Users,OU=HAIRCLUB,DC=hcfm,DC=com''''
								WHERE memberOf=''''CN=' + @CurrentGroup + ',OU=HC.Security,OU=HC.Groups,OU=HAIRCLUB,DC=hcfm,DC=com''''''
							)
							ORDER BY sAMAccountname
						'

						--List members of given group
						INSERT INTO #Members
						EXEC (@SQL)


				FETCH NEXT FROM Group_Cursor
				INTO @CurrentGroup
			END
			CLOSE Group_Cursor
			DEALLOCATE Group_Cursor


		--Update temp table with EmployeeTitleID from lkpEmployee given Title from AD
		UPDATE m
		SET EmployeeTitleID = t.EmployeeTitleID
		FROM #Members m
			inner join lkpEmployeeTitle t on m.Title = t.EmployeeTitleDescription


		INSERT INTO mtnActiveDirectoryImport
		SELECT DISTINCT ADSID, ADUserLogin,ADCenter,ADFirstName, ADLastName,CenterID,EmployeePosition,EmployeeInitials,GETUTCDATE(),EmployeePayrollID,EmployeeTitleID FROM #Members


		DROP TABLE #Groups
		DROP TABLE #Members
END
GO
