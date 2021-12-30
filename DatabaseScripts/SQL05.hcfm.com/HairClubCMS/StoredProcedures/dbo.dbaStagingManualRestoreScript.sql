/* CreateDate: 12/11/2012 14:57:18.523 , ModifyDate: 12/11/2012 14:57:18.523 */
GO
/***********************************************************************

PROCEDURE:				dbaStagingManualRestoreScript

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Andrew Schwalbe

IMPLEMENTOR: 			Andrew Schwalbe

DATE IMPLEMENTED: 		9/15/2008

LAST REVISION DATE: 	4/10/2009

--------------------------------------------------------------------------------------------------------
NOTES:  *** THIS SHOULD ONLY BE RUN AGAINST THE STAGING DATABASE ***
		Use this script to manually reconnect the database user to a restored database
		and to rerun the grant permissions stored procedure so all stored procedures
		get their permissions reset for the user.

		* 4/10/09 PRM - Updated this to be specifically for staging
		* 6/10/10 PRM - Included HairClub Test Server User to the script
		* 10/27/10 - PRM: Changed server name if statement to include nodes of SQL server not just virtual SQL01 name
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

dbaStagingManualRestoreScript

***********************************************************************/


CREATE PROCEDURE [dbo].[dbaStagingManualRestoreScript]
@Database nvarchar(50) = NULL
AS
BEGIN

DECLARE @SQL nvarchar(2000)
IF NOT @Database IS NULL
  BEGIN
	SET @SQL = 'USE [' + @Database + ']'
	EXECUTE(@SQL)
	PRINT @SQL
  END

--remove HairClub Live environment user from database
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name IN (N'[HCFM\CMS]', N'HCFM\CMS'))
DROP USER [HCFM\CMS]

--remove HairClub Test environment user from database
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name IN (N'[HCFM\CMSTEST]', N'HCFM\CMSTEST'))
DROP USER [HCFM\CMSTEST]

--remove Skyline Dev and staging user from database
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'HCCMSUser')
DROP USER [HCCMSUser]


DECLARE @serverName varchar(50)
SET @serverName = (CAST (SERVERPROPERTY ( 'ComputerNamePhysicalNetBIOS') as varchar(50)) )
PRINT @serverName

IF (@serverName Like 'SQL01' OR @serverName LIKE 'HCSQL%')
  BEGIN
	PRINT 'Live Environment, do not adjust users'
  END
ELSE
  BEGIN
	IF (@serverName Like 'HCTESTSQL01')
	  BEGIN
		CREATE USER [HCFM\CMSTEST] FOR LOGIN [HCFM\CMSTEST]

		EXEC sp_addrolemember N'db_datareader', N'HCFM\CMSTEST'
		EXEC sp_addrolemember N'db_datawriter', N'HCFM\CMSTEST'
	  END
	ELSE
	  BEGIN
		CREATE USER [HCCMSUser] FOR LOGIN [HCCMSUser]

		EXEC sp_addrolemember N'db_datareader', N'HCCMSUser'
		EXEC sp_addrolemember N'db_datawriter', N'HCCMSUser'
	  END
  END

IF @Database IS NULL
  BEGIN
	EXEC dbaGrantPermissions
  END

END
GO
