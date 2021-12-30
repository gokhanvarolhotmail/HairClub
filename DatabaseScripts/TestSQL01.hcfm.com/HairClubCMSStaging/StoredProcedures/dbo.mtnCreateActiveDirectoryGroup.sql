/* CreateDate: 07/30/2012 09:01:56.570 , ModifyDate: 03/31/2020 12:28:15.023 */
GO
/***********************************************************************

PROCEDURE:				mtnCreateActiveDirectoryGroup

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		07/17/12

LAST REVISION DATE: 	* 07/17/12


10/24/18 - MVT: Added Try/Catch Error checking to prevent issue of [dbo].[cfgActiveDirectoryGroupJoin] from getting deleted in a
				scenario where an error occurs running AD Sync.
03/31/20 - EJP: Updated to get group records from AD in chunks of 901 records to avoid AD provider limit.

--------------------------------------------------------------------------------------------------------
NOTES: 	Populates the cfgActiveDirectoryGroup
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

mtnCreateActiveDirectoryGroup

***********************************************************************/

CREATE   PROCEDURE [dbo].[mtnCreateActiveDirectoryGroup]
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
		-- We're on HairClub Servers, use Active Directory

		--Declare variables
		DECLARE @SQL varchar(8000);
		DECLARE @ReturnStatus int;
		DECLARE @Filter varchar(200);
		DECLARE @Rowcount int;

		--Create temp table to hold Groups
		CREATE TABLE #Groups (
			ADGroup VARCHAR(200)
		)

		SET @Filter = '';

		WHILE ISNULL(@rowcount, 901) = 901
		BEGIN

			SELECT @SQL = '
			SELECT TOP 901
				samaccountname
			FROM
				OpenQuery(ADSI, ''SELECT samaccountname FROM ''''LDAP://DC=hcfm,DC=com'''' WHERE objectCategory=''''group''''' + @filter + ' ORDER BY samaccountname'')';
			PRINT @SQL;
			INSERT INTO #Groups EXEC (@SQL) ;
			SELECT @Rowcount = @@ROWCOUNT;
			SELECT @Filter = ' AND samaccountname > ''''' + LTRIM((SELECT MAX(ADGroup) FROM #Groups)) + ''''' ';

		END


		--Remove ActiveDirectoryGroups which no longer exist in Active Directory
		DELETE FROM cfgActiveDirectoryGroupJoin
		WHERE ActiveDirectoryGroupID IN
				(SELECT ad.ActiveDirectoryGroupID
				 From cfgActiveDirectoryGroup ad
					LEFT OUTER join #Groups on ad.ActiveDirectoryGroup = #Groups.ADGroup
				  WHERE #Groups.ADGroup IS NULL)

		DELETE FROM cfgEmployeeActiveDirectoryGroupJoin
		WHERE ActiveDirectoryGroupID IN
				(SELECT ad.ActiveDirectoryGroupID
				 From cfgActiveDirectoryGroup ad
					LEFT OUTER join #Groups on ad.ActiveDirectoryGroup = #Groups.ADGroup
				  WHERE #Groups.ADGroup IS NULL)

		DELETE FROM cfgActiveDirectoryGroup
		WHERE ActiveDirectoryGroupID IN
				(SELECT ad.ActiveDirectoryGroupID
				 From cfgActiveDirectoryGroup ad
					LEFT OUTER join #Groups on ad.ActiveDirectoryGroup = #Groups.ADGroup
				  WHERE #Groups.ADGroup IS NULL)

		INSERT INTO cfgActiveDirectoryGroup(ActiveDirectoryGroup, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT #Groups.ADGroup, GETDATE(), 'sa', GETDATE(), 'sa'
		From #Groups
		LEFT OUTER JOIN cfgActiveDirectoryGroup AD on #Groups.ADGroup = ad.ActiveDirectoryGroup
		Where SUBSTRING(#Groups.ADGroup,1,1) <> '_'
			AND AD.ActiveDirectoryGroupID IS NULL


		DROP TABLE #Groups
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH

END
GO
