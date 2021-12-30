/* CreateDate: 05/01/2010 23:05:34.780 , ModifyDate: 05/01/2010 23:05:34.780 */
GO
CREATE FUNCTION [bief_config].[fn_GetDatabaseVersion] ()
-----------------------------------------------------------------------
-- [fn_GetDatabaseVersion] retrieves the current database version
-----------------------------------------------------------------------
--         Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--
-----------------------------------------------------------------------

RETURNS @tblDBVersion table(
	[DBVersionMajor] [int] NOT NULL ,
	[DBVersionMinor] [int] NOT NULL ,
	[DBVersionBuild] [int] NOT NULL ,
	[DBVersionRevision] [int] NOT NULL
	)
BEGIN
	INSERT INTO @tblDBVersion
	SELECT  [DBVersionMajor]
		  , [DBVersionMinor]
		  , [DBVersionBuild]
		  , [DBVersionRevision]
	  FROM [bief_config].[_DBVersion]

	RETURN
END
GO
