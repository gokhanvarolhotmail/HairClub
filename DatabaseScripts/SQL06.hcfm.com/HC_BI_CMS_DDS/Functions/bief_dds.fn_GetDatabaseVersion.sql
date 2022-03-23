/* CreateDate: 03/17/2022 11:57:10.600 , ModifyDate: 03/17/2022 11:57:10.600 */
GO
CREATE FUNCTION [bief_dds].[fn_GetDatabaseVersion] ()
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
	  FROM [bief_dds].[_DBVersion]

	RETURN
END
GO
