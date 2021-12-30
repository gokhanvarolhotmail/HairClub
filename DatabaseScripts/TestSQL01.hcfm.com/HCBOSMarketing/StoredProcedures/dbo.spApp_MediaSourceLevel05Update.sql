/* CreateDate: 06/17/2008 11:29:36.053 , ModifyDate: 01/25/2010 08:13:27.480 */
GO
CREATE PROCEDURE spApp_MediaSourceLevel05Update
	@Level05ID		int
,	@Level05Code	varchar(10)
,	@Level05Name	varchar(50)
AS
BEGIN
	UPDATE MediaSourceLevel05
	SET
		Level05CreativeCode	=	@Level05Code
	,	Level05Creative		=	@Level05Name
	WHERE
		Level05ID			=	@Level05ID
END
GO
