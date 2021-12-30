/* CreateDate: 05/03/2010 12:22:43.840 , ModifyDate: 05/03/2010 12:22:43.840 */
GO
CREATE FUNCTION [bief_dq].[fn_GetDatabaseVersion] ()
-----------------------------------------------------------------------
-- [fn_GetDatabaseVersion] retrieves the current database version
-----------------------------------------------------------------------
--         Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
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
	  FROM [bief_dq].[_DBVersion]

	RETURN
END
GO
