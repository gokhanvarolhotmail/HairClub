/* CreateDate: 10/04/2010 12:09:08.150 , ModifyDate: 02/27/2017 09:49:16.737 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				dbaRefreshCache

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		4/23/2010

LAST REVISION DATE: 	4/23/2010

--------------------------------------------------------------------------------------------------------
NOTES:  Reset all of the last update stamps on lookup tables so cache gets refreshed automatically,
			this is mainly for testing purposes because we'd loose all of our update stamps in the database if run in production
		* 4/23/2010 PRM - Script created
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

dbaRefreshCache

***********************************************************************/

CREATE PROCEDURE [dbo].[dbaRefreshCache]
AS

BEGIN

DECLARE @TableName as nvarchar(50)
DECLARE @Sprocs_Cursor CURSOR
DECLARE @SQL as nVarchar(512)

SET @Sprocs_Cursor = CURSOR FAST_FORWARD FOR
	SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME LIKE 'lkp%'

OPEN @Sprocs_Cursor


FETCH NEXT FROM @Sprocs_Cursor
 INTO @TableName

WHILE @@FETCH_STATUS = 0
  BEGIN
	SET @SQL = 'UPDATE ' + @TableName + ' SET LastUpdate = GETUTCDATE()'
	EXEC sp_executesql @SQL
	--PRINT @SQL

	FETCH NEXT FROM @Sprocs_Cursor
    INTO @TableName
  END

CLOSE @Sprocs_Cursor
DEALLOCATE @Sprocs_Cursor

END
GO
