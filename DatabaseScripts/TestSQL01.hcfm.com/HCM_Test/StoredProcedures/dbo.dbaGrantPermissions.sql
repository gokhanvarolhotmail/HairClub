/* CreateDate: 07/29/2014 10:15:05.227 , ModifyDate: 07/29/2014 10:18:42.093 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--THIS SCRIPT IS TO CHANGE THE INSTANCES OF USAGE OF SERVERNAME TO INCLUDE THE HCSQLCMS
--WHICH IS USED FOR THE 2012 MIGRATION TESTING


/***********************************************************************

PROCEDURE:				dbaGrantPermissions

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Andrew Schwalbe

IMPLEMENTOR: 			Andrew Schwalbe

DATE IMPLEMENTED: 		4/10/2009

LAST REVISION DATE: 	10/2/2009

--------------------------------------------------------------------------------------------------------
NOTES:  Use this script to grant permissions to stored procedures
		* 4/10/09 PRM - changed it so it can be run from either staging or production,
			and defaulted it to production so there are no errors.  This was fixed after
			we had reporting permission issues on 4/9/09.
		* 9/24/09 PRM - hardcoded proc to grant TRE SQL User(s) access to Client mtnClientAdd stored proc
		* 10/2/09 PRM - In production the TRE use also needed access to the mtnGetInvoiceNumber stored proc
		* 6/10/10 PRM - Included HairClub Test Server User to the script
		* 10/27/10 PRM - Exclude tmp & dba stored procs as well as sp_
		* 11/09/10 PRM - Granted access to SP_Start_job stored proc to execute SSIS package - this is commented out at the bottom, need to execute manually
		* 01/14/10 PRM - Added brackets around stored proc names to handle '-'
		* 05/23/11 MVT - Modified to also check for the server name when granting access.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

dbaGrantPermissions

***********************************************************************/

CREATE PROCEDURE [dbo].[dbaGrantPermissions]
AS

BEGIN

DECLARE @Security_Account1 as sysname

DECLARE @Name as sysname
DECLARE @Type as nvarchar(1)

DECLARE @Sprocs_Cursor CURSOR

DECLARE @SQL as nVarchar(512)
DECLARE @serverName varchar(50)

SET @serverName = (CAST (SERVERPROPERTY ( 'ComputerNamePhysicalNetBIOS') as varchar(50)) )

IF  EXISTS (SELECT * FROM sys.database_principals WHERE name IN ('[HCFM\CMS]', 'HCFM\CMS')) AND (@serverName = 'SQL01' OR @serverName LIKE 'HCSQL%')
  BEGIN
	--HairClub Live Environment
	SET @Security_Account1 = '[HCFM\CMS]'
  END
ELSE
  BEGIN
	IF  EXISTS (SELECT * FROM sys.database_principals WHERE name IN ('[HCFM\CMSTEST]', 'HCFM\CMSTEST'))
	  BEGIN
		--HairClub Test Environment
		SET @Security_Account1 = '[HCFM\CMSTEST]'
	  END
	ELSE
	  BEGIN
		--Skyline Development & Staging Environments
		SET @Security_Account1 = 'HCCMSUser'
	  END
  END

PRINT ''
PRINT '''dbaGrantPermissions'' has begun updating permissions for ''' + @Security_Account1 + '''.'

SET @Sprocs_Cursor = CURSOR FAST_FORWARD FOR
	SELECT name,type FROM sysobjects WHERE (type = 'P') and category=0

OPEN @Sprocs_Cursor


FETCH NEXT FROM @Sprocs_Cursor
 INTO @Name,@Type

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Security Account 1 - Stored Procs ----------------------------------------------
	IF @Type = 'P' AND (LEFT(@Name, 3) <> 'sp_' AND LEFT(@Name, 3) <> 'dba' AND LEFT(@Name, 3) <> 'tmp')
	  BEGIN
		SET @SQL = 'GRANT EXECUTE ON [' + @Name + '] TO ' + @Security_Account1 + char(13)
		EXEC sp_executesql @SQL
		--PRINT @SQL
	  END
   ------------------------------------------------------------------------------------

	FETCH NEXT FROM @Sprocs_Cursor
    INTO @Name, @Type
END

-- hardcoded access to mtnClientAdd stored proc so TRE SQL User(s)
--      have access to proc to automatically insert clients in CMS production database
IF @Security_Account1 = '[HCFM\CMS]'
  BEGIN
    DECLARE @Security_SQLAdmin as sysname
	SET @Security_SQLAdmin = '[HCFM\Access_SQL Administrators]'

	--SET @Name = 'mtnClientAdd'
	--SET @SQL = 'GRANT EXECUTE ON [' + @Name + '] TO ' + @Security_SQLAdmin + char(13)
	--EXEC sp_executesql @SQL

	--SET @Name = 'mtnGetInvoiceNumber'
	--SET @SQL = 'GRANT EXECUTE ON [' + @Name + '] TO ' + @Security_SQLAdmin + char(13)
	--EXEC sp_executesql @SQL

	--Can't use a Use statement in a stored proc, but this needs to be executed on the production server to all allocation process to be executed
	--USE [msdb]
	--GO

	--CREATE USER [HCFM\CMS] FOR LOGIN [HCFM\CMS]
	--GO

	--EXEC sp_addrolemember N'SQLAgentOperatorRole', N'HCFM\CMS'
	--GO

	--GRANT EXECUTE ON sp_start_job TO [HCFM\CMS]
	--GO
  END


CLOSE @Sprocs_Cursor
DEALLOCATE @Sprocs_Cursor


PRINT '''dbaGrantPermissions'' has completed updating permissions.'

END
GO
